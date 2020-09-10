{-# LANGUAGE QuasiQuotes #-}

module Homework02.Spec where

import Data.String.QQ
import Homework02.Log
import Homework02.LogAnalysis
import Test.Hspec

homework02Spec :: Spec
homework02Spec = do
  describe "Homework 2" $ do
    describe "Exercise 1" $ do
      it "parseMessage" $ do
        parseMessage "garbage" `shouldBe` Unknown "garbage"
        parseMessage "I 1 message" `shouldBe` LogMessage Info 1 "message"
        parseMessage "W 5 message" `shouldBe` LogMessage Warning 5 "message"
        parseMessage "E 500 100 internal server error" `shouldBe` LogMessage (Error 500) 100 "internal server error"

      it "parse" $
        do
          parse
            [s|
          I 6 Completed armadillo processing
          I 1 Nothing to report
          I 4 Everything normal
          I 11 Initiating self-destruct sequence
          E 70 3 Way too many pickles
          E 65 8 Bad pickle-flange interaction detected
          W 5 Flange is due for a check-up
          I 7 Out for lunch, back in two time steps
          E 20 2 Too many pickles
          I 9 Back from lunch
          E 99 10 Flange failed!|]
          `shouldBe` [ LogMessage Info 6 "Completed armadillo processing",
                       LogMessage Info 1 "Nothing to report",
                       LogMessage Info 4 "Everything normal",
                       LogMessage Info 11 "Initiating self-destruct sequence",
                       LogMessage (Error 70) 3 "Way too many pickles",
                       LogMessage (Error 65) 8 "Bad pickle-flange interaction detected",
                       LogMessage Warning 5 "Flange is due for a check-up",
                       LogMessage Info 7 "Out for lunch, back in two time steps",
                       LogMessage (Error 20) 2 "Too many pickles",
                       LogMessage Info 9 "Back from lunch",
                       LogMessage (Error 99) 10 "Flange failed!"
                     ]

    describe "Exercise 2" $ do
      describe "insert" $ do
        it "inserting Unknown is a noop" $ do
          insert (Unknown "boom") Leaf `shouldBe` Leaf
          insert (Unknown "boom") (Node Leaf (LogMessage Info 10 "message") Leaf) `shouldBe` (Node Leaf (LogMessage Info 10 "message") Leaf)

        it "insert into nested tree" $
          do
            insert
              (LogMessage Warning 16 "")
              ( Node
                  ( Node
                      ( Node
                          Leaf
                          (LogMessage Info 8 "")
                          Leaf
                      )
                      (LogMessage Warning 10 "")
                      ( Node
                          Leaf
                          (LogMessage Info 12 "")
                          Leaf
                      )
                  )
                  (LogMessage Info 15 "")
                  ( Node
                      ( Node
                          Leaf
                          (LogMessage Info 18 "")
                          ( Node
                              Leaf
                              (LogMessage Info 19 "")
                              Leaf
                          )
                      )
                      (LogMessage (Error 1) 20 "")
                      ( Node
                          Leaf
                          (LogMessage Info 25 "")
                          ( Node
                              Leaf
                              (LogMessage Info 30 "")
                              Leaf
                          )
                      )
                  )
              )
            `shouldBe` ( Node
                           ( Node
                               ( Node
                                   Leaf
                                   (LogMessage Info 8 "")
                                   Leaf
                               )
                               (LogMessage Warning 10 "")
                               ( Node
                                   Leaf
                                   (LogMessage Info 12 "")
                                   Leaf
                               )
                           )
                           (LogMessage Info 15 "")
                           ( Node
                               ( Node
                                   -- [BEGIN INSERTED NODE]
                                   ( Node
                                       Leaf
                                       (LogMessage Warning 16 "")
                                       Leaf
                                   )
                                   -- [END INSERTED NODE]
                                   (LogMessage Info 18 "")
                                   ( Node
                                       Leaf
                                       (LogMessage Info 19 "")
                                       Leaf
                                   )
                               )
                               (LogMessage (Error 1) 20 "")
                               ( Node
                                   Leaf
                                   (LogMessage Info 25 "")
                                   ( Node
                                       Leaf
                                       (LogMessage Info 30 "")
                                       Leaf
                                   )
                               )
                           )
                       )

    describe "Exercise 3" $ do
      it "build" $ do
        build
          [ Unknown "",
            LogMessage Warning 2 "",
            LogMessage (Error 404) 1 "",
            Unknown "",
            LogMessage Info 3 "",
            Unknown ""
          ]
          `shouldBe` Node
            ( Node
                Leaf
                (LogMessage (Error 404) 1 "")
                Leaf
            )
            (LogMessage Warning 2 "")
            ( Node
                Leaf
                (LogMessage Info 3 "")
                Leaf
            )

    describe "Exercise 4" $ do
      it "inOrder" $ do
        ( inOrder . build $
            [ Unknown "",
              LogMessage Warning 2 "",
              LogMessage (Error 404) 1 "",
              Unknown "",
              LogMessage Info 3 "",
              Unknown ""
            ]
          )
          `shouldBe` [ LogMessage (Error 404) 1 "",
                       LogMessage Warning 2 "",
                       LogMessage Info 3 ""
                     ]

    describe "Exercise 5" $ do
      it "whatWentWrong" $ do
        whatWentWrong
          [ LogMessage (Error 400) 75 "banana",
            Unknown "",
            LogMessage Info 3 "",
            LogMessage Warning 2 "",
            LogMessage (Error 500) 50 "apple",
            Unknown "",
            LogMessage (Error 503) 999 "orange",
            Unknown ""
          ]
          `shouldBe` [ "apple",
                       "banana",
                       "orange"
                     ]
