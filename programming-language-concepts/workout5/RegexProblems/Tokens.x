{
module Tokens where
}

%wrapper "basic"

tokens :-

  ab*                         { TokenIt "p0" }
  c*d+                        { TokenIt "p1" }
  [ef]+                       { TokenIt "p2" }
  [a-z][0-9a-z]*              { TokenIt "p3" }
  [\'\"][A-Z a-z \ ]+[\'\"]   { TokenIt "p4" }
  Y*(X(Y*)X)*Y+(X(Y*)X)*Y*    { TokenIt "p5" }

  $white+                       ;
{
-- The token type:
data Token = TokenIt String {- which problem the string is for -} String
           deriving (Eq)

instance Show Token where
  show (TokenIt name str) = name ++ "(" ++ show str ++ ")"
}
