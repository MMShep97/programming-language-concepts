{
module Tokens where
}

%wrapper "basic"

tokens :-

  $white+                       ;
  \(                        { \s -> TokenLParen }
  \)                        { \s -> TokenRParen }
  \-\>                        { \s -> TokenArrow }
{

-- The token type:
data Token = TokenArrow | TokenLParen | TokenRParen
           deriving (Eq,Show)

}
