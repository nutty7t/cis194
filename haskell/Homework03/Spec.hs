module Homework03.Spec where

import Homework03.Golf (histogram, localMaxima, skips)
import Test.Hspec (Spec, describe, it, shouldBe)

homework03Spec :: Spec
homework03Spec = do
  describe "Homework 3" $ do
    describe "Exercise 1" $ do
      it "skips" $ do
        skips "ABCD" `shouldBe` ["ABCD", "BD", "C", "D"]
        skips "hello!" `shouldBe` ["hello!", "el!", "l!", "l", "o", "!"]
        skips [1] `shouldBe` [[1]]
        skips [True, False] `shouldBe` [[True, False], [False]]
        skips ([] :: [()]) `shouldBe` []

    describe "Exercise 2" $ do
      it "localMaxima" $ do
        localMaxima [2, 9, 5, 6, 1] `shouldBe` [9, 6]
        localMaxima [2, 3, 4, 1, 5] `shouldBe` [4]
        localMaxima [1, 2, 3, 4, 5] `shouldBe` []

    describe "Exercise 3" $ do
      it "histogram" $ do
        histogram [1, 1, 1, 5]
          `shouldBe` unlines
            [ " *        ",
              " *        ",
              " *   *    ",
              "==========",
              "0123456789"
            ]

        histogram [1, 4, 5, 4, 6, 6, 3, 4, 2, 4, 9]
          `shouldBe` unlines
            [ "    *     ",
              "    *     ",
              "    * *   ",
              " ******  *",
              "==========",
              "0123456789"
            ]
