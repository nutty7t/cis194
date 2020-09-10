import { pipe } from 'fp-ts/lib/function'
import { parseMessage, parse, insert, build, inOrder, whatWentWrong } from './LogAnalysis'
import { logMessage, unknown, info, warning, error, leaf, node } from './Log'

describe('Exercise 1', () => {
	it('parseMessage', () => {
		expect(parseMessage(['garbage'])).toEqual(unknown('garbage'))
		expect(parseMessage(['I', '1', 'message'])).toEqual(logMessage(info())(1)('message'))
		expect(parseMessage(['W', '5', 'message'])).toEqual(logMessage(warning())(5)('message'))
		expect(parseMessage(['E', '500', '100', 'internal server error'])).toEqual(
			logMessage(error(500))(100)('internal server error')
		)
	})

	it('parse', () => {
		const file = `I 6 Completed armadillo processing
I 1 Nothing to report
I 4 Everything normal
I 11 Initiating self-destruct sequence
E 70 3 Way too many pickles
E 65 8 Bad pickle-flange interaction detected
W 5 Flange is due for a check-up
I 7 Out for lunch, back in two time steps
E 20 2 Too many pickles
I 9 Back from lunch
E 99 10 Flange failed!`
		expect(parse(file)).toEqual([
			logMessage(info())(6)('Completed armadillo processing'),
			logMessage(info())(1)('Nothing to report'),
			logMessage(info())(4)('Everything normal'),
			logMessage(info())(11)('Initiating self-destruct sequence'),
			logMessage(error(70))(3)('Way too many pickles'),
			logMessage(error(65))(8)('Bad pickle-flange interaction detected'),
			logMessage(warning())(5)('Flange is due for a check-up'),
			logMessage(info())(7)('Out for lunch, back in two time steps'),
			logMessage(error(20))(2)('Too many pickles'),
			logMessage(info())(9)('Back from lunch'),
			logMessage(error(99))(10)('Flange failed!'),
		])
	})
})

describe('Exercise 2', () => {
	describe('insert', () => {
		it('inserting Unknown is a noop', () => {
			expect(insert(unknown('boom'))(leaf())).toEqual(leaf())
			expect(
				insert(unknown('boom'))(node(leaf())(logMessage(info())(10)('message'))(leaf()))
			).toEqual(node(leaf())(logMessage(info())(10)('message'))(leaf()))
		})

		it('insert into nested tree', () => {
			expect(
				insert(logMessage(warning())(16)(''))(
					node(
						node(node(leaf())(logMessage(info())(8)(''))(leaf()))(logMessage(warning())(10)(''))(
							node(leaf())(logMessage(info())(12)(''))(leaf())
						)
					)(logMessage(info())(15)(''))(
						node(
							node(leaf())(logMessage(info())(18)(''))(
								node(leaf())(logMessage(info())(19)(''))(leaf())
							)
						)(logMessage(error(1))(20)(''))(
							node(leaf())(logMessage(info())(25)(''))(
								node(leaf())(logMessage(info())(30)(''))(leaf())
							)
						)
					)
				)
			).toEqual(
				node(
					node(node(leaf())(logMessage(info())(8)(''))(leaf()))(logMessage(warning())(10)(''))(
						node(leaf())(logMessage(info())(12)(''))(leaf())
					)
				)(logMessage(info())(15)(''))(
					node(
						node(
							// [BEGIN INSERTED NODE]
							node(leaf())(logMessage(warning())(16)(''))(leaf())
							// [END INSERTED NODE]
						)(logMessage(info())(18)(''))(node(leaf())(logMessage(info())(19)(''))(leaf()))
					)(logMessage(error(1))(20)(''))(
						node(leaf())(logMessage(info())(25)(''))(
							node(leaf())(logMessage(info())(30)(''))(leaf())
						)
					)
				)
			)
		})
	})
})

describe('Exercise 3', () => {
	it('build', () => {
		expect(
			build([
				unknown(''),
				logMessage(warning())(2)(''),
				logMessage(error(404))(1)(''),
				unknown(''),
				logMessage(info())(3)(''),
				unknown(''),
			])
		).toEqual(
			node(node(leaf())(logMessage(error(404))(1)(''))(leaf()))(logMessage(warning())(2)(''))(
				node(leaf())(logMessage(info())(3)(''))(leaf())
			)
		)
	})
})

describe('Exercise 4', () => {
	it('inOrder', () => {
		expect(
			pipe(
				[
					unknown(''),
					logMessage(warning())(2)(''),
					logMessage(error(404))(1)(''),
					unknown(''),
					logMessage(info())(3)(''),
					unknown(''),
				],
				build,
				inOrder
			)
		).toEqual([
			logMessage(error(404))(1)(''),
			logMessage(warning())(2)(''),
			logMessage(info())(3)(''),
		])
	})
})

describe('Exercise 5', () => {
	it('whatWentWrong', () => {
		expect(
			whatWentWrong([
				logMessage(error(400))(75)('banana'),
				unknown(''),
				logMessage(info())(3)(''),
				logMessage(warning())(2)(''),
				logMessage(error(500))(50)('apple'),
				unknown(''),
				logMessage(error(503))(999)('orange'),
				unknown(''),
			])
		).toEqual(['apple', 'banana', 'orange'])
	})
})
