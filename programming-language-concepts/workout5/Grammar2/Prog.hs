module Prog where

data FunCall = FunCall String [FunCall] | Var String
  deriving Show

type Prog = [ FunCall ]
