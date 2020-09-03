import { flow, pipe } from 'fp-ts/lib/function'
import * as A from 'fp-ts/lib/Array'
import * as E from 'fp-ts/lib/Either'
import * as IOE from 'fp-ts/lib/IOEither'
import * as fs from 'fs'

// data MessageType = Info | Warning | Error Int
export type MessageType =
	| {
			_tag: 'Info'
	  }
	| {
			_tag: 'Warning'
	  }
	| {
			_tag: 'Error'
			severity: number
	  }

export const info = (): MessageType => ({ _tag: 'Info' })

export const warning = (): MessageType => ({ _tag: 'Warning' })

export const error = (severity: number): MessageType => ({ _tag: 'Error', severity })

export type TimeStamp = Number

// data LogMessage = LogMessage MessageType TimeStamp String | Unknown String
export type LogMessage =
	| {
			_tag: 'LogMessage'
			type: MessageType
			timestamp: TimeStamp
			message: string
	  }
	| {
			_tag: 'Unknown'
			message: string
	  }

export const logMessage = (type: MessageType) => (timestamp: TimeStamp) => (
	message: string
): LogMessage => ({
	_tag: 'LogMessage',
	type,
	timestamp,
	message,
})

export const unknown = (message: string): LogMessage => ({ _tag: 'Unknown', message })

// data MessageTree = Leaf | Node MessageTree LogMessage MessageTree
export type MessageTree =
	| { _tag: 'Leaf' }
	| {
			_tag: 'Node'
			left: MessageTree
			value: LogMessage
			right: MessageTree
	  }

export const leaf = (): MessageTree => ({ _tag: 'Leaf' })

export const node = (left: MessageTree) => (value: LogMessage) => (
	right: MessageTree
): MessageTree => ({
	_tag: 'Node',
	left,
	value,
	right,
})

export type FilePath = string

// readFile :: String -> IO (Either Error String)
export const readFile = (path: string): IOE.IOEither<Error, string> =>
	IOE.tryCatch(() => fs.readFileSync(path, 'utf8'), E.toError)

// testParse :: (String -> [LogMessage]) -> Int -> FilePath -> IO (Either Error [LogMessage])
export const testParse = (parse: (m: string) => LogMessage[]) => (n: number) => (
	file: FilePath
): IOE.IOEither<Error, LogMessage[]> => {
	return pipe(readFile(file), IOE.map(flow(parse, A.takeLeft(n))))
}

// testWhatWentWrong :: (String -> [LogMessage]) -> ([LogMessage] -> [String]) -> FilePath -> IO (Either Error [String])
export const testWhatWentWrong = (parse: (m: string) => LogMessage[]) => (
	whatWentWrong: (ms: LogMessage[]) => string[]
) => (file: FilePath): IOE.IOEither<Error, string[]> => {
	return pipe(readFile(file), IOE.map(flow(parse, whatWentWrong)))
}
