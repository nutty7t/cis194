import {
	toDigits,
	toDigitsRev,
	doubleEveryOther,
	sumDigits,
	validate,
	hanoi,
	hanoi4,
} from './exercises'

describe('Exercise 1', () => {
	it('toDigits', () => {
		expect(toDigits(-1)).toEqual([])
		expect(toDigits(0)).toEqual([])
		expect(toDigits(12345)).toEqual([1, 2, 3, 4, 5])
	})

	it('toDigitsRev', () => {
		expect(toDigitsRev(-1)).toEqual([])
		expect(toDigitsRev(0)).toEqual([])
		expect(toDigitsRev(12345)).toEqual([5, 4, 3, 2, 1])
	})
})

describe('Exercise 2', () => {
	it('doubleEveryOther', () => {
		expect(doubleEveryOther([])).toEqual([])
		expect(doubleEveryOther([1])).toEqual([1])
		expect(doubleEveryOther([1, 2, 3, 4])).toEqual([2, 2, 6, 4])
		expect(doubleEveryOther([1, 2, 3, 4, 5])).toEqual([1, 4, 3, 8, 5])
	})
})

describe('Exercise 3', () => {
	it('sumDigits', () => {
		expect(sumDigits([])).toBe(0)
		expect(sumDigits([1])).toBe(1)
		expect(sumDigits([-1])).toBe(0)
		expect(sumDigits([11])).toBe(2)
		expect(sumDigits([1, 2, 33, 123])).toBe(15)
		expect(sumDigits([11, 22, 33, 44])).toBe(20)
		expect(sumDigits([-52, 1, 2, 3, 0, 342, -9])).toBe(15)
	})
})

describe('Exercise 4', () => {
	it('validate', () => {
		expect(validate(4012888888881881)).toBe(true)
		expect(validate(4012888888881882)).toBe(false)
	})
})

describe('Exercise 5', () => {
	it('hanoi', () => {
		expect(hanoi(-1)('a')('b')('c').length).toBe(0)
		expect(hanoi(0)('a')('b')('c').length).toBe(0)
		expect(hanoi(1)('a')('b')('c').length).toBe(1)
		expect(hanoi(2)('a')('b')('c').length).toBe(3)
		expect(hanoi(3)('a')('b')('c').length).toBe(7)
		expect(hanoi(4)('a')('b')('c').length).toBe(15)
		expect(hanoi(5)('a')('b')('c').length).toBe(31)
		expect(hanoi(15)('a')('b')('c').length).toBe(32767)
	})
})

describe('Exercise 6', () => {
	it('hanoi4', () => {
		expect(hanoi4(5)('a')('b')('c')('d').length).toBe(13)
		expect(hanoi4(15)('a')('b')('c')('d').length).toBe(129)
	})
})
