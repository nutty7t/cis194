{-# OPTIONS_GHC -Wall #-}

module Homework02.LogAnalysis where

import Prelude

import Safe
import Text.Read

import Homework02.Log

--
-- Exercise 1
--

consume :: Int -> [String] -> String
consume n = unwords . drop n

parseInt :: String -> (String, Maybe Int)
parseInt m =
  let
    tokens = words m
    value = readMaybe =<< headMay tokens
  in
    case value of
      Just i  -> (consume 1 tokens, Just i)
      Nothing -> (consume 0 tokens, Nothing)

parseMessageType :: String -> (String, Maybe MessageType)
parseMessageType m =
  let
    tokens = words m
    messageType = headMay tokens
  in
    case messageType of
      Just "I" -> (consume 1 tokens, Just Info)
      Just "W" -> (consume 1 tokens, Just Warning)
      Just "E" -> case parseInt (consume 1 tokens) of
                    (m', Just s)  -> (m', Just $ Error s)
                    (m', Nothing) -> (m', Nothing)
      _        -> (m, Nothing)

parseMessage :: String -> LogMessage
parseMessage m =
  case parseMessageType m of
    (m', Just messageType) -> case parseInt m' of
                                (m'', Just timestamp) -> LogMessage messageType timestamp m''
                                (m'', Nothing)        -> Unknown m''
    (m', Nothing)          -> Unknown m'

parse :: String -> [LogMessage]
parse = parse' . lines
  where
    parse' :: [String] -> [LogMessage]
    parse' [] = []
    parse' (l:ls) = parseMessage l : parse' ls

--
-- Exercise 2
--

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _)           t                      = t
insert m@(LogMessage _ _  _) Leaf                   = Node Leaf m Leaf
insert m@(LogMessage _ ts _) t@(Node left m' right) =
  case m' of
    Unknown _            -> t
    (LogMessage _ ts' _) -> if ts <= ts'
                              then (Node (insert m left) m' right)
                              else (Node left m' (insert m right))

--
-- Exercise 3
--

build :: [LogMessage] -> MessageTree
build messages = build' messages Leaf
  where
    build' :: [LogMessage] -> MessageTree -> MessageTree
    build' []     t = t
    build' (m:ms) t = build' ms (insert m t)

--
-- Exercise 4
--

inOrder :: MessageTree -> [LogMessage]
inOrder Leaf         = []
inOrder (Node l m r) = inOrder l ++ [m] ++ inOrder r

--
-- Exercise 5
--

sortMessages :: [LogMessage] -> [LogMessage]
sortMessages = inOrder . build

getMessage :: LogMessage -> String
getMessage (Unknown m)        = m
getMessage (LogMessage _ _ m) = m

whatWentWrong :: [LogMessage] -> [String]
whatWentWrong = fmap getMessage . sortMessages . filter isSevere
  where
    isSevere :: LogMessage -> Bool
    isSevere (LogMessage (Error s) _ _) = s >= 50
    isSevere _                          = False

--
-- Exercise 6
--

-- Yann-Joachim Ringard (Jean-Yves Girard)

