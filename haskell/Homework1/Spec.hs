module Homework1.Spec where

import Test.Hspec

import Homework1.Exercises as E

homework1Spec :: Spec
homework1Spec = do
  describe "Homework1" $ do
    describe "Exercise 1" $ do
      it "toDigits" $ do
        E.toDigits 0 `shouldBe` []
        E.toDigits (-1) `shouldBe` []
        E.toDigits 12345 `shouldBe` [1, 2, 3, 4, 5]

      it "toDigitsRev" $ do
        E.toDigitsRev 0 `shouldBe` []
        E.toDigitsRev (-1) `shouldBe` []
        E.toDigitsRev 12345 `shouldBe` [5, 4, 3, 2, 1]

    describe "Exercise 2" $ do
      it "doubleEveryOther" $ do
        E.doubleEveryOther [] `shouldBe` []
        E.doubleEveryOther [1] `shouldBe` [1]
        E.doubleEveryOther [1, 2, 3, 4] `shouldBe` [2, 2, 6, 4]
        E.doubleEveryOther [1, 2, 3, 4, 5] `shouldBe` [1, 4, 3, 8, 5]

    describe "Exercise 3" $ do
      it "sumDigits" $ do
        E.sumDigits [] `shouldBe` 0
        E.sumDigits [1] `shouldBe` 1
        E.sumDigits [(-1)] `shouldBe` 0
        E.sumDigits [11] `shouldBe` 2
        E.sumDigits [1, 2, 33, 123] `shouldBe` 15
        E.sumDigits [11, 22, 33, 44] `shouldBe` 20
        E.sumDigits [(-52), 1, 2, 3, 0, 342, (-9)] `shouldBe` 15

    describe "Exercise 4" $ do
      it "validate" $ do
        E.validate 4012888888881881 `shouldBe` True
        E.validate 4012888888881882 `shouldBe` False

    describe "Exercise 5" $ do
      it "hanoi" $ do
        let a = "a"
        let b = "b"
        let c = "c"
        length (E.hanoi (-1) a b c) `shouldBe` 0
        length (E.hanoi 0 a b c) `shouldBe` 0
        length (E.hanoi 1 a b c) `shouldBe` 1
        length (E.hanoi 2 a b c) `shouldBe` 3
        length (E.hanoi 3 a b c) `shouldBe` 7
        length (E.hanoi 4 a b c) `shouldBe` 15
        length (E.hanoi 5 a b c) `shouldBe` 31
        length (E.hanoi 15 a b c) `shouldBe` 32767

    describe "Exercise 6" $ do
      it "hanoi4" $ do
        let a = "a"
        let b = "b"
        let c = "c"
        let d = "d"
        length (E.hanoi4 5 a b c d) `shouldBe` 13
        length (E.hanoi4 15 a b c d) `shouldBe` 129
