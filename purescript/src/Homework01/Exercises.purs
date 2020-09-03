module Homework01.Exercises where

import Prelude

import Data.Array (mapWithIndex, reverse)
import Data.Traversable (traverse)
import Data.String.Utils (toCharArray)
import Data.Int (fromString)
import Data.Foldable (foldMap, sum)
import Data.Maybe (Maybe(..))
import Data.Monoid.Conj (Conj(..))
import Data.Newtype (unwrap)
import Data.Tuple (Tuple(..))

--
-- Exercise 1
--

toDigits :: Int -> Array Int
toDigits n
  | n <= 0 = []
  | n <= 9 = [n]
  | otherwise = toDigits (n / 10) <> [n `mod` 10]

toDigitsRev :: Int -> Array Int
toDigitsRev = reverse <<< toDigits

-- | Int has the same width as a signed 32-bit integer. This function accepts
-- | a String argument so that we can work with arbitrary precision.
-- |
-- | Example:
-- | ``` purescript
-- | toDigits' "4012888888881881" = [4,0,1,2,8,8,8,8,8,8,8,8,1,8,8,1]
-- | toDigits' "garbage" = []
-- | ```
toDigits' :: String -> Array Int
toDigits' s =
  let
    toIntArray :: String -> Maybe (Array Int)
    toIntArray = traverse fromString <<< toCharArray

    isZero :: Array Int -> Boolean
    isZero = unwrap <<< foldMap (\x -> Conj $ x == 0)
  in
    case toIntArray s of
      Nothing -> []
      Just xs -> if isZero xs then [] else xs

toDigitsRev' :: String -> Array Int
toDigitsRev' = reverse <<< toDigits'

--
-- Exercise 2
--

double :: Int -> Int
double x = x + x

isOdd :: Int -> Boolean
isOdd x = x `mod` 2 /= 0

doubleOddIndexedValue :: Int -> Int -> Int
doubleOddIndexedValue i x
  | isOdd i = double x
  | otherwise = x

doubleEveryOther :: Array Int -> Array Int
doubleEveryOther = reverse <<< mapWithIndex doubleOddIndexedValue <<< reverse

--
-- Exercise 3
--

sumDigits :: Array Int -> Int
sumDigits xs = sum $ toDigits =<< xs

--
-- Exercise 4
--

endsWithZero :: Int -> Boolean
endsWithZero x = x `mod` 10 == 0

validate :: Int -> Boolean
validate = endsWithZero <<< sumDigits <<< doubleEveryOther <<< toDigits

validate' :: String -> Boolean
validate' = endsWithZero <<< sumDigits <<< doubleEveryOther <<< toDigits'

--
-- Exercise 5
--

type Peg = String
type Move = Tuple Peg Peg

hanoi :: Int -> Peg -> Peg -> Peg -> Array Move
hanoi n a b c
  | n <= 0 = []
  | otherwise =
      (hanoi (n - 1) a c b) <>
      [Tuple a b] <>
      (hanoi (n - 1) c b a)

--
-- Exercise 6
--

hanoi4 :: Int -> Peg -> Peg -> Peg -> Peg -> Array Move
hanoi4 n a b c d
  | n <= 0 = []
  | n == 1 = [Tuple a b]
  | otherwise =
      (hanoi4 (n - 2) a c b d) <>
      [Tuple a d] <>
      [Tuple a b] <>
      [Tuple d b] <>
      (hanoi4 (n - 2) c b a d)
