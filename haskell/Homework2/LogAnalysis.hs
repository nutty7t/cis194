{-# OPTIONS_GHC -Wall #-}

module Homework2.LogAnalysis where

import Prelude

import Safe
import Text.Read

import Homework2.Log

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

