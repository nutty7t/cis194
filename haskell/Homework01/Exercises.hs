module Homework01.Exercises where

import Prelude

--
-- Exercise 1
--

toDigits :: Integer -> [Integer]
toDigits n
  | n <= 0 = []
  | n <= 9 = [n]
  | otherwise = toDigits (n `div` 10) <> [n `mod` 10]

toDigitsRev :: Integer -> [Integer]
toDigitsRev = reverse . toDigits

--
-- Exercise 2
--

doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther = reverse . doubleEveryOther' . reverse
  where
    doubleEveryOther' :: [Integer] -> [Integer]
    doubleEveryOther' [] = []
    doubleEveryOther' [x] = [x]
    doubleEveryOther' (x:y:z) = (x : y + y : doubleEveryOther' z)

--
-- Exercise 3
--

sumDigits :: [Integer] -> Integer
sumDigits xs = sum $ toDigits =<< xs

--
-- Exercise 4
--

validate :: Integer -> Bool
validate = endsWithZero . sumDigits . doubleEveryOther . toDigits
  where
    endsWithZero :: Integer -> Bool
    endsWithZero n = n `mod` 10 == 0

--
-- Exercise 5
--

type Peg = String
type Move = (Peg, Peg)

hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi n a b c
  | n <= 0 = []
  | otherwise =
      hanoi (n - 1) a c b <>
      [(a, b)] <>
      hanoi (n - 1) c b a

--
-- Exercise 6
--

hanoi4 :: Integer -> Peg -> Peg -> Peg -> Peg -> [Move]
hanoi4 n a b c d
  | n <= 0 = []
  | n == 1 = [(a, b)]
  | otherwise =
      hanoi4 (n - 2) a c b d <>
      [(a, d), (a, b), (d, b)] <>
      hanoi4 (n - 2) c b a d
