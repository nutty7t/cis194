module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Homework01.Exercises (homework01Spec)
import Test.Homework02.Exercises (homework02Spec)
import Test.Spec.Reporter (specReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main =
  launchAff_
    $ runSpec [ specReporter ] do
        homework01Spec
        homework02Spec
