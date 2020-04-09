import Grammar
import Tokens
import Tp
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  s <- readFile $ head args
  putStrLn $ show $ parseTp $ alexScanTokens s
