module Exercises where

import E
import Data.List

{- given an input list of tuples of the form ((x,y),n),
   return the list of those values n where x == y.

   Hint: try some combination of map and filter. -}
p1 :: Eq a => [((a,a),b)] -> [b]          
p1 xs = map (\((x,y),n) -> n) (filter (\((x,y),n) -> x == y) xs)
-- p1 = map snd . filter ( (fst fst) == (fst snd) ) 
-- p1 = map (fst . fst)

{- p2 n ns should subtract the numbers in ns from n.
   So p2 10 [1,2,3] equals ((10 - 1) - 2) - 3.

   Hint: try a foldl. -}
p2 :: Int -> [Int] -> Int
p2 = foldl (-)

{- compose corresponding functions from the two lists,
   creating a list of the resulting compositions.  If one
   list is longer, drop the excess.

   Hint: use zipWith -}
p3 :: [b -> c] -> [a -> b] -> [a -> c]
p3 = zipWith (.)                

{- change the order of the types in the input tuple of a function.  This is
   like the flip function we saw in class (or run ':type flip' in the REPL),
   except for uncurried functions. -}
p4 :: ((a,b) -> c) -> (b,a) -> c
p4 f (a,b) = f (b,a)
-- curry flip uncurry ?

{- create a list of all the suffixes of the input list.  So
   p5 "abc" should returned ["abc","bc","c",""].  The order of the
   suffixes in the list does not matter. -}
p5 :: [a] -> [[a]]
-- p5 [] = [[]]
-- p5 xs = xs : p5 (drop 1 xs)
p5 = tails

e1 :: Int -> Int
e1 = (-) 3

e2 :: Int -> [Int] -> [Int]
e2 = map . (+)

e3 :: (Int,Int) -> (Int,Int)
e3 = mapPair ( (+) 3) ( (-) 3)

--  Just uncomment the ones you choose to implement:
{-}
r1 :: Eq a => E ([((a,a),b)] -> [b])
r1 = undefined
-}

r2 :: E (Int -> [Int] -> Int)
r2 = Foldl :@ Subtract


r3 :: E ([b -> c] -> [a -> b] -> [a -> c])
r3 = ZipWith :@ Compose


r4 :: E (((a,b) -> c) -> (b,a) -> c)
r4 = Compose :@ Uncurry :@ (Compose :@ Flip :@ Curry)

{-}
r5 :: E ([a] -> [[a]])
r5 = undefined -}
