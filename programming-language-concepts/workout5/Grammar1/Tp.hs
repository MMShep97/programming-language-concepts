module Tp where

data Tp = Unit | Arrow Tp Tp
  deriving Show
