module PublicTests where

import Control.Applicative
import Exercises

-- test x y n means to run test number n, to check that x equals y.
test :: (Show a , Eq a) => a -> a -> Int -> IO ()
test x y n =
  let name = "test for p" ++ show n in
  if x == y then
    putStrLn ("Passing " ++ name ++ ".")
  else
    putStrLn ("Failing " ++ name ++ ": expected " ++ show y ++ ", computed " ++ show x)

main :: IO ()
main =
  do
    putStrLn ("Executing " ++ show (length tests) ++ " tests.")
    sequence_ (zipWith id tests [1..])
  where
    tests = 
      [
        test (p1 [1,2,3,4,5,6]) [2,4,6] ,
        test (p2 [1,2,3,4,5,6]) [1,3,5],
        test (p3 "abc") "aabbcc",
        test (p4 [2,2,3]) 256,
        test (p5 [1,3,5] [2,4,6]) [1,2,3,4,5,6],
        test (p6 3) (Node 3 Leaf Leaf),
        test (p7 (Node 3 (Node 4 Leaf Leaf) (Node 5 (Node 6 Leaf Leaf) Leaf))) 4,
        test (p8 3 (Node 4 Leaf Leaf)) (Node 3 (Node 4 Leaf Leaf) (Node 4 Leaf Leaf)) ,
        test (p9 (Node 1 (Node 2 (Node 3 Leaf Leaf) (Node 4 Leaf Leaf)) (Node 5 Leaf Leaf))) [3,2,4,1,5],
        test (p10 (Node 1 (Node 2 (Node 3 Leaf Leaf) (Node 4 Leaf Leaf)) (Node 5 Leaf Leaf))) [3,4,2,5,1],
        test (p11 not (Node True (Node False Leaf Leaf) (Node True Leaf Leaf))) (Node False (Node True Leaf Leaf) (Node False Leaf Leaf)),
        test (p12 (Node 1 (Node 2 (Node 3 Leaf Leaf) Leaf) (Node 4 Leaf (Node 5 Leaf Leaf))))
             (Node 1 (Node 4 (Node 5 Leaf Leaf) Leaf) (Node 2 Leaf (Node 3 Leaf Leaf))),
        test (p13 (Node 1 Leaf Leaf)) (Just 1),
        test (show p14) "{\"id\": 51.0, \"public\": false, \"JobPairs\": [{\"id\": 31.0, \"sid\": 1.0, \"bid\": 251.0}, {\"id\": 32.0, \"sid\": 1.0, \"bid\": 58.0}, {\"id\": 33.0, \"sid\": 2.0, \"bid\": 251.0}]}",
        test (p15 (JBool True)) False ,
        test (p16 (JObject [ ("hi" , JNumber 1) , ("bye" , JNumber 2) ])) (Just [ ("hi" , JNumber 1) , ("bye" , JNumber 2) ]),
        test (p17 (JArray [ JObject [ ("val" , JString "null") ] , JString "null", JBool True]))
             (JArray [ JObject [ ("val" , JNull) ] , JNull, JBool True]),
        test (p18 "val"
              (JArray [ JObject [ ("val" , JNumber 3) ] , JObject [ ("nested" , JObject [ ("val" , JArray [ JBool True , JBool False])])],
                        JNull, JBool True]))
             [ JNumber 3 , JArray [ JBool True , JBool False ]]
      ]
      
