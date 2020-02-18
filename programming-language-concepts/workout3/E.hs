{-# LANGUAGE GADTs #-}
module E where

infixl 6 :@

data E a where

  -- pairs
  Fst :: E ((a,b) -> a)
  Snd :: E ((a,b) -> b)  
  MapPair :: E ((a -> c) -> (b -> d) -> (a,b) -> (c,d))

  -- arithmetic
  Subtract :: E (Int -> Int -> Int)
  Plus :: E (Int -> Int -> Int)
  Num :: Int -> E Int

  -- equality
  Equality :: Eq a => E (a -> a -> Bool)

  -- lists
  Nil :: E [a]
  Cons :: E (a -> [a] -> [a])
  Append :: E ([a] -> [a] -> [a])
  Filter :: E ((a -> Bool) -> [a] -> [a])
  Foldl :: E ((b -> a -> b) -> b -> [a] -> b)
  Foldr :: E ((a -> b -> b) -> b -> [a] -> b)
  ZipWith :: E ((a -> b -> c) -> [a] -> [b] -> [c])
  Map :: E ((a -> b) -> [a] -> [b])

  -- functions
  Compose :: E ((b -> c) -> (a -> b) -> a -> c)
  Curry :: E (((a,b) -> c) -> a -> b -> c)
  Uncurry :: E ((a -> b -> c) -> (a,b) -> c)
  Flip :: E ((a -> b -> c) -> b -> a -> c)
  (:@) :: E (a -> b) -> E a -> E b

mapPair :: (a -> c) -> (b -> d) -> (a,b) -> (c,d)
mapPair f g (a,b) = (f a , g b)

eval :: E a -> a

eval Fst = fst
eval Snd = snd
eval MapPair = mapPair

eval Subtract = (-)
eval Plus = (+)
eval (Num x) = x

eval Nil = []
eval Cons = (:)
eval Append = (++)
eval Filter = filter
eval Foldl = foldl
eval Foldr = foldr
eval ZipWith = zipWith
eval Map = map

eval Compose = (.)
eval Curry = curry
eval Uncurry = uncurry
eval Flip = flip
eval (f :@ a) =  eval f $ eval a
