module Main where

import Data.Time.LocalTime

{- this IO action should read a line of text
  (getLine) and print it out twice (putStrLn) -}
p1 :: IO ()
p1 = undefined
    
{- read two lines of text (getLine) and
   return the second (discarding the first) -}
p2 :: IO String
p2 = undefined

{- read the file test.txt (readFile) and
   write its contents reversed to output.txt (writeFile) -}
p3 :: IO ()
p3 = undefined

{- return the number of times the given Char occurs in the
   file named by the given String (so you will use readFile
   to get the contents of the file named by the given String,
   and then count occurrences of the given character). -}
p4 :: Char -> String -> IO Int
p4 = undefined

{- print the current time (in the local timezone).
   Hint: use getZonedTime. -}
p5 :: IO ()
p5 = undefined

main :: IO ()
main =
  do
    putStrLn "p1. Enter a string and hit enter:"
    p1
    putStrLn "p2. Enter a string and hit enter, then do it again:"
    l <- p2
    putStrLn (show $ length l)
    putStrLn "p3."
    p3
    putStrLn "p4."
    p4v <- p4 '.' "test.txt"
    putStrLn (show p4v)
    putStrLn "p5. Current time of day:"
    p5
