{
module Grammar where
import Tokens
import Tp
}

%name parseTp
%tokentype { Token }
%error { parseError }

%token
    '('  { TokenLParen }
    ')'  { TokenRParen }
    '->'  { TokenArrow}

%right '->'

%%

-- replace this with your productions:
Tp : { Unit }

{

parseError :: [Token] -> a
parseError tks = error ("Parse error: " ++ show tks)

}
