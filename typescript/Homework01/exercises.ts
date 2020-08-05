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
