module Test.Homework1.Exercises where

import Prelude

import Data.Array (length)

import Homework1.Exercises as E

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

homework1Spec :: Spec Unit
homework1Spec =
  describe "Homework 1" do
    describe "Exercise 1" do
      it "toDigits" do
        E.toDigits 0 `shouldEqual` []
        E.toDigits (-1) `shouldEqual` []
        E.toDigits 12345 `shouldEqual` [1, 2, 3, 4, 5]
    
      it "toDigitsRev" do
        E.toDigitsRev 0 `shouldEqual` []
        E.toDigitsRev (-1) `shouldEqual` []
        E.toDigitsRev 12345 `shouldEqual` [5, 4, 3, 2, 1]

      it "toDigits'" do
        E.toDigits' "0" `shouldEqual` []
        E.toDigits' "00000000" `shouldEqual` []
        E.toDigits' "-1" `shouldEqual` []
        E.toDigits' "12345" `shouldEqual` [1, 2, 3, 4, 5]
    
      it "toDigitsRev'" do
        E.toDigitsRev' "0" `shouldEqual` []
        E.toDigitsRev' "-1" `shouldEqual` []
        E.toDigitsRev' "12345" `shouldEqual` [5, 4, 3, 2, 1]

    describe "Exercise 2" do
      it "doubleEveryOther" do
        E.doubleEveryOther [] `shouldEqual` []
        E.doubleEveryOther [1] `shouldEqual` [1]
        E.doubleEveryOther [1, 2, 3, 4] `shouldEqual` [2, 2, 6, 4]
        E.doubleEveryOther [1, 2, 3, 4, 5] `shouldEqual` [1, 4, 3, 8, 5]

    describe "Exercise 3" do
      it "sumDigits" do
        E.sumDigits [] `shouldEqual` 0
        E.sumDigits [1] `shouldEqual` 1
        E.sumDigits [(-1)] `shouldEqual` 0
        E.sumDigits [11] `shouldEqual` 2
        E.sumDigits [1, 2, 33, 123] `shouldEqual` 15
        E.sumDigits [11, 22, 33, 44] `shouldEqual` 20
        E.sumDigits [(-52), 1, 2, 3, 0, 342, (-9)] `shouldEqual` 15

    describe "Exercise 4" do
      it "validate'" do
        E.validate' "4012888888881881" `shouldEqual` true
        E.validate' "4012888888881882" `shouldEqual` false

    describe "Exercise 5" do
      it "hanoi" do
        let a = "a"
        let b = "b"
        let c = "c"
        length (E.hanoi (-1) a b c) `shouldEqual` 0
        length (E.hanoi 0 a b c) `shouldEqual` 0
        length (E.hanoi 1 a b c) `shouldEqual` 1
        length (E.hanoi 2 a b c) `shouldEqual` 3
        length (E.hanoi 3 a b c) `shouldEqual` 7
        length (E.hanoi 4 a b c) `shouldEqual` 15
        length (E.hanoi 5 a b c) `shouldEqual` 31
        length (E.hanoi 15 a b c) `shouldEqual` 32767

    describe "Exercise 6" do
      it "hanoi4" do
        let a = "a"
        let b = "b"
        let c = "c"
        let d = "d"
        length (E.hanoi4 5 a b c d) `shouldEqual` 13
        length (E.hanoi4 15 a b c d) `shouldEqual` 129
