import { pipe } from 'fp-ts/lib/function'
import * as A from 'fp-ts/lib/Array'
import * as NEA from 'fp-ts/lib/NonEmptyArray'
import * as O from 'fp-ts/lib/Option'

import {
	MessageType,
	info,
	warning,
	error,
	LogMessage,
	logMessage,
	unknown,
	testParse,
} from './Log'

//
// Exercise 1
//

// consume :: Number -> [String] -> [String]
const consume = A.dropLeft

// readMaybe :: String -> Option Number
const readMaybe = (s: string) => {
	const maybeInt = parseInt(s)
	return maybeInt !== NaN ? O.some(maybeInt) : O.none
}

// _parseInt :: [String] -> ([String], Option Number)
const _parseInt = (tokens: string[]): [string[], O.Option<number>] =>
	pipe(
		A.head(tokens),
		O.chain(readMaybe),
		O.fold(
			() => [consume(0)(tokens), O.none],
			(i) => [consume(1)(tokens), O.some(i)]
		)
	)

// parseMessageType :: [String] -> ([String], Option MessageType)
const parseMessageType = (tokens: string[]): [string[], O.Option<MessageType>] =>
	pipe(
		A.head(tokens),
		O.map((messageType) => {
			switch (messageType) {
				case 'I':
					return [consume(1)(tokens), O.some(info())]
				case 'W':
					return [consume(1)(tokens), O.some(warning())]
				case 'E':
					return pipe(_parseInt(consume(1)(tokens)), ([leftoverTokens, maybeSeverity]) =>
						pipe(
							maybeSeverity,
							O.fold(
								() => [leftoverTokens, O.none],
								(severity) => [leftoverTokens, O.some(error(severity))]
							)
						)
					)
				default:
					return [consume(0)(tokens), O.none]
			}
		}),
		O.getOrElse(() => [consume(0)(tokens), O.none])
	)

// parseMessage :: [String] -> LogMessage
const parseMessage = (tokens: string[]): LogMessage =>
	pipe(parseMessageType(tokens), ([tokens2, maybeMessageType]) =>
		pipe(
			maybeMessageType,
			O.fold(
				() => unknown(tokens2.join(' ')),
				(messageType) =>
					pipe(_parseInt(tokens2), ([tokens3, maybeTimestamp]) =>
						pipe(
							maybeTimestamp,
							O.fold(
								() => unknown(tokens3.join(' ')),
								(timestamp) => logMessage(messageType)(timestamp)(tokens3.join(' '))
							)
						)
					)
			)
		)
	)

// _parse :: [String] -> [LogMessage]
const _parse = (lines: string[]) => {
	if (lines.length === 0) {
		return []
	} else {
		const nonEmptyLines = lines as NEA.NonEmptyArray<string>
		const head = NEA.head(nonEmptyLines)
		const tail = NEA.tail(nonEmptyLines)
		const tokens = head.split(' ')
		return A.cons(parseMessage(tokens), _parse(tail))
	}
}

// parse :: String -> [LogMessage]
const parse = (s: string) => pipe(s.split('\n'), _parse)

console.log(
	JSON.stringify(
		testParse(parse)(99)('/home/nutty/Code/cis194/typescript/Homework02/sample.log')(),
		null,
		2
	)
)
