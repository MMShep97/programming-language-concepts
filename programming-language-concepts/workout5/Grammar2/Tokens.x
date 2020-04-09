{
module Tokens where
}

%wrapper "basic"

tokens :-

  $white+                       ;
  [a-z]+                    { \s -> TokenId s }
  \(                        { \s -> TokenLParen }
  \)                        { \s -> TokenRParen }
  \,                        { \s -> TokenComma }
  \;                        { \s -> TokenSemi }  
{

-- The token type:
data Token = TokenId String | TokenLParen | TokenRParen | TokenComma | TokenSemi
           deriving (Eq,Show)

}
