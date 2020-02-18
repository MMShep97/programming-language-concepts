module PublicTests where

import Control.Applicative
import Exercises
import System.Directory

-- test x y n means to run test number n, to check that x equals y.
test :: (Show a , Eq a) => a -> a -> String -> IO ()
test x y name =
  if x == y then
    putStrLn ("Passing " ++ name ++ ".")
  else
    putStrLn ("Failing " ++ name ++ ": expected " ++ show y ++ ", computed " ++ show x)

putStrLnb :: String -> IO Bool
putStrLnb s = putStrLn s >> return True

main :: IO ()
main =
  do
    putStrLn ("Tests for a1:")
    test (a1 (Just True) (Just True)) (Just True) "a1a"
    test (a1 [True,True] [True,False]) [True,False,True,False] "a1b"
    b <- a1 (doesPathExist "test.txt") (doesPathExist "someFileThatIsNotThere.txt")
    putStrLn (if b then "Two paths exist (not expected)." else "One path does not exist (expected).")
    putStrLn ""

    putStrLn "Test for a2, should see just \"hi\" and \"again\":"
    a2 [doesPathExist "test.txt" , putStrLnb "hi" , putStrLnb "again" ,doesPathExist "someFileThatIsNotThere.txt" , putStrLnb "yo"]
      

      
