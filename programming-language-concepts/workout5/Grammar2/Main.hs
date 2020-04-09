import Grammar
import Tokens
import Prog
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  s <- readFile $ head args
  putStrLn $ show $ parseProg $ alexScanTokens s
