import { flow } from 'fp-ts/lib/function'
import * as A from 'fp-ts/lib/Array'
import * as M from 'fp-ts/lib/Monoid'

//
// Exercise 1
//

// isPositiveInteger :: Number -> Boolean
const isPositiveInteger = (x: number) => Number.isInteger(x) && x > 0

// split :: Number -> [Number]
const split = (x: number) => x.toString().split('').map(Number)

// toDigits :: Number -> [Number]
export const toDigits = (x: number) => isPositiveInteger(x) ? split(x) : []

// toDigitsRev :: Number -> [Number]
export const toDigitsRev = flow(toDigits, A.reverse)

//
// Exercise 2
//

// double :: Number -> Number
const double = (x: number) => x + x

// isOdd :: Number -> Boolean
const isOdd = (x: number) => x % 2 !== 0

// doubleOddIndexedValue :: (Number, Number) -> Number
const doubleOddIndexedValue = (i: number, x: number) => isOdd(i) ? double(x) : x

// doubleEveryOther :: [Number] -> [Number]
export const doubleEveryOther = flow(
	A.reverse,
	A.mapWithIndex(doubleOddIndexedValue),
	A.reverse
)

//
// Exercise 3
//

// sumDigits :: [Number] -> Number
export const sumDigits = flow(A.chain(toDigits), M.fold(M.monoidSum))

//
// Exercise 4
//

// endsWithZero :: Number -> Boolean
const endsWithZero = (x: number) => x % 10 === 0

// validate :: Number -> Boolean
export const validate = flow(toDigits, doubleEveryOther, sumDigits, endsWithZero)

//
// Exercise 5
//

type Peg = String
type Move = [Peg, Peg]

// hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
export const hanoi = (n: number) => (a: Peg) => (b: Peg) => (c: Peg): Move[] => {
	if (n <= 0) {
		// nothing to do
		return []
	} else {
		return A.flatten([
			// move n - 1 discs from a to c using b
			hanoi(n - 1)(a)(c)(b),
			// move a to b
			A.of([a, b]),
			// move n - 1 discs from c to b using a
			hanoi(n - 1)(c)(b)(a),
		])
	}
}

//
// Exercise 6
//

// hanoi4 :: Integer -> Peg -> Peg -> Peg -> Peg -> [Move]
export const hanoi4 = (n: number) => (a: Peg) => (b: Peg) => (c: Peg) => (d: Peg): Move[] => {
	if (n <= 0) {
		// nothing to do
		return []
	} else if (n === 1) {
		return A.of([a, b])
	} else {
		return A.flatten([
			// move n - 2 discs from a to c using b and d
			hanoi4(n - 2)(a)(c)(b)(d),
			// move bottom two disks from a to b
			A.of([a, d]),
			A.of([a, b]),
			A.of([d, b]),
			// move n - 2 discs from c to b using a and d
			hanoi4(n - 2)(c)(b)(a)(d),
		])
	}
}
