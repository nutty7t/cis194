module Main where

import Test.Hspec

import Homework1.Spec

testSuite :: Spec
testSuite = do
  homework1Spec

main :: IO ()
main = hspec testSuite
