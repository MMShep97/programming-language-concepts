module PF where

import E

e1 :: E (Int -> Int)
e1 = Subtract :@ (Num 3)

e2 :: E (Int -> [Int] -> [Int])
e2 = Compose :@ Map :@ Plus

e3 :: E ((Int,Int) -> (Int,Int))
e3 = MapPair :@ (Plus :@ (Num 3)) :@ (Subtract :@ (Num 3))
