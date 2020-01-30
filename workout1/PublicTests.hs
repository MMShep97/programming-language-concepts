module PublicTests where

import Control.Applicative
import Basic

-- test x y n means to run test number n, to check that x equals y.
test :: (Show a , Ord a) => a -> a -> Int -> IO ()
test x y n =
  let name = "test for p" ++ show n in
  if x == y then
    putStrLn ("Passing " ++ name ++ ".")
  else
    putStrLn ("Failing " ++ name ++ ": expected " ++ show y ++ ", computed " ++ show x)

main :: IO ()
main =
  do
    {- zipWith id fs xs has the effect of applying a list of functions fs to the corresponding inputs in xs.
       So (zipWith id tests [1..]) has type [IO ()], because each element in tests has type Int -> IO ().
       So we compute which test is which very easily, without having to write down the test number as
       part of the calls to test below.

       This value of type [IO ()] can then be evaluated in order using sequence_,
       from Control.Applicative. -}
    putStrLn ("Executing " ++ show (length tests) ++ " tests.")
    sequence_ (zipWith id tests [1..])
  where
    -- it is nice we can just write a list of tests compactly as follows:
    tests = 
      [
        test (p1 (1,2,3)) 6 ,
        test (p2 (1,2)) (2,1) ,
        test (p3 (10,20) (3,4)) (13,24) ,
        test (p4 ('a','b') ('c','d')) ('a','b','c','d') ,
        test (p5 (3 +) (10,20)) (13,23) ,
        test (p6 "can") "cancan",
        test (p7 "nib") "bin",
        test (p8 "the weather" "frightful") "the weather is frightful",
        test (p9 (1 / 3)) "1 % 3",
        test (p10 (1 / 3)) "1 / 3",
        test (p11 (+) 100) 200,
        test (p12 (==) id 'c') True,
        test (p13 (2,3) (+ 10) (uncurry (+))) 15,
        test (p14 (Just 1) 0 (+ 10)) 11,
        test (p15 Nothing (Just 3)) (Just 3),
        test (p16 [0,1,0,2,3]) 3,
        test (p17 [1,2] [3,4,5] [6,7,8,9]) [1..9],
        test (p18 [1,2,3,4,5]) [2,3,4],
        test (p19 (* 3) even [1,2,3,4,5]) [2,4],
        test (p20 not [True,False,False,True]) [(True,False),(False,True),(False,True),(True,False)]
      ]
      
