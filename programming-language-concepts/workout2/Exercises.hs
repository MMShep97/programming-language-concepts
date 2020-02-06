module Exercises where

import Data.List

----------------------------------------------------------------------
-- Recursing through lists
--
-- The following problems may be solved by writing recursive
-- functions which pattern match on an input list (or lists).
--
-- We will do more examples in class, but you can find one already 
-- in lec/jan28-maybe--pattern-matching/Inclass.hs,
-- namely anyNothingList.
----------------------------------------------------------------------

{- drop every other element from the input list, beginning
   with the first element.  So p1 [1,2,3,4,5,6] should return
   [2,4,6]. For a one-element list, just return the empty list. -}
p1 :: [a] -> [a]
p1 [] = []
p1 [a] = []
p1 xs = (drop 1 (take 2 xs)) ++ p1 (drop 2 xs)

{- drop every other element from the input list, beginning
   with the second element.  So p1 [1,2,3,4,5,6] should return
   [1,3,5]. -}
p2 :: [a] -> [a]
p2 [] = []
p2 xs = take 1 xs ++ p2 (drop 2 xs)

{- duplicate every element in the list.  So p3 "abc" should return
   "aabbcc". -}
p3 :: [a] -> [a]
p3 [] = []
p3 xs = take 1 xs ++ take 1 xs ++ p3 (drop 1 xs)

-- heads and tails ^ v

{- tower of exponents: [1,2,3,4] should turn into 1 ^ 2 ^ 3 ^ 4
   [] can just turn into 1, as a corner case (and also this is
   helpful for defining the function recursively.) -}
p4 :: Integral a => [a] -> a
p4 [] = 1
p4 xs = head xs ^ (p4 (tail xs))


{- This function is supposed to create a new list consisting of
   alternating elements of the two input lists (so first from
   the first list, then from the second, then from the first
   again, etc.). So p1 [1,3,5] [2,4,6] should produce [1,2,3,4,5,6].
   When the list to choose elements from runs out, you just give
   all the elements of the other list.  This handles the case
   where the lists are not the same l)ength. -}
p5 :: [a] -> [a] -> [a]
p5 [] xs = xs
p5 xs [] = xs
p5 xs ys = take 1 xs ++ take 1 ys ++ p5 (drop 1 xs) (drop 1 ys)

----------------------------------------------------------------------
-- Operations on trees
--
-- These problems are to help get you used to programming with
-- user-declared datatypes.  Some of these require recursion, while
-- others do not.
----------------------------------------------------------------------

-- here is a datatype for binary trees with data at the nodes
data Tree a = Leaf | Node a (Tree a) (Tree a) deriving (Show , Eq)

-- inject a piece of data as a Node whose left and right subtrees
-- are leaves.  So p6 3 should return Node 3 Leaf Leaf.
p6 :: a -> Tree a
p6 a = Node a Leaf Leaf 

-- count the number of elements (i.e., the number of uses of Node)
p7 :: Tree a -> Int
p7 (Leaf) = 0
p7 (Node a l r) = 1 + p7 l + p7 r

{- given an element and a tree, build a new tree with that
   element at the root and the tree as both the left and right
   subtree.  So p8 3 (Node 1 Leaf Leaf) would return
   Node 3 (Node 1 Leaf Leaf) (Node 1 Leaf Leaf). -}
p8 :: a -> Tree a -> Tree a
p8 a t = Node a t t

{- return the elements of the tree using an in-order traversal.  This
   means that for any Node, you should list the elements of the left
   subtree, then the data at that Node, and then the elements of the
   right subtree.

   See, for example,
   https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/ -}
p9 :: Tree a -> [a]
p9 (Leaf) = []
p9 (Node a l r) = p9 l ++ [a] ++ p9 r

-- do the same thing as for p9, but use a post-order traveral. 
p10 :: Tree a -> [a]
p10 (Leaf) = []
p10 (Node a l r) = p10 l ++ p10 r ++ [a]

{- apply the given function to all the data in the input tree,
   constructing a new tree with the same structure (but holding
   the outputs of the function). -}
p11 :: (a -> b) -> Tree a -> Tree b
p11 f (Leaf) = Leaf
p11 f (Node a l r) = Node (f a) (p11 f l) (p11 f r)

-- recursively flip left and right subtrees throughout the tree
p12 :: Tree a -> Tree a
p12 (Leaf) = Leaf
p12 (Node a l r) = Node a (p12 r) (p12 l)

-- return the root of the tree if it has one
p13 :: Tree a -> Maybe a
p13 Leaf = Nothing
p13 (Node a l r) = Just a

{---------------------------------------------------------------------
 A more complex datatype

 The following code is taken from
 http://book.realworldhaskell.org/read/writing-a-library-working-with-json-data.html

 JSON is a textual format commonly used for exchanging structured data between
 clients and servers in web applications.  There are just a few forms of data
 allowed.  

 A tiny explanation is given below with p14.

 See various online references for a tutorial if needed, like
     https://www.w3schools.com/js/js_json_intro.asp
----------------------------------------------------------------------}

-- elements of the JValue datatype represent JSON text
data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull
            | JObject [(String, JValue)]
            | JArray [JValue]
              deriving (Eq, Ord)

{- this function turns a JValue into a syntactically correct JSON string (except
   that it does not implement JSON rules for escape sequences like \n, but this
   is not important for the problems below). -}
renderJValue :: JValue -> String
renderJValue (JString s)   = show s
renderJValue (JNumber n)   = show n
renderJValue (JBool True)  = "true"
renderJValue (JBool False) = "false"
renderJValue JNull         = "null"
renderJValue (JObject o) = "{" ++ pairs o ++ "}"
  where pairs [] = ""
        pairs ps = intercalate ", " (map renderPair ps)
        renderPair (k,v)   = show k ++ ": " ++ renderJValue v
renderJValue (JArray a) = "[" ++ values a ++ "]"
  where values [] = ""
        values vs = intercalate ", " (map renderJValue vs)

instance Show JValue where
  show = renderJValue

{- Implement the JSON value

     { "id" : 51 ,
       "public" : false ,
       "JobPairs" : [ { "id" : 31 , "sid" : 1 , "bid" : 251 } ,
                      { "id" : 32 , "sid" : 1 , "bid" : 58  } ,
                      { "id" : 33 , "sid" : 2 , "bid" : 251  } ] }

   as a value of type JValue.  (This could represent some information from
   starexec.org, if you are curious -- but the semantics of this sample
   JSON text is not important.)

   Square brackets are for arrays, curly brackets are for objects.

   I found it handy to write a helper function for creating the JSON for
   a job pair like { "id" : 33 , "sid" : 2 , "bid" : 251  }.
   Then I can call this helper function three times, rather than write out
   three rather bulky JValue expressions directly.
   -}

p14 :: JValue
p14 = JObject [
        ("id", JNumber 51), 
        ("public", JBool False),
        ("JobPairs", JArray 
            [
              JObject [("id", JNumber 31), ("sid", JNumber 1), ("bid", JNumber 251)],
              JObject [("id", JNumber 32), ("sid", JNumber 1), ("bid", JNumber 58)],
              JObject [("id", JNumber 33), ("sid", JNumber 2), ("bid", JNumber 251)]
            ] 
         )]

-- return True if the input JValue is JNull, and False otherwise
p15 :: JValue -> Bool
p15 JNull = True
p15 x = False

{- return the list of attribute-value pairs if the input JValue is a JObject. -}   
p16 :: JValue -> Maybe [(String , JValue)]
-- p16 a = if a :: JObject then show a else []
p16 (JObject a) = Just a
p16 x = Nothing

{- replace JString "null" everywhere you find it with JNull (do not try to
   replace attributes of JObjects like in { "null" : 3 }) -}
p17 :: JValue -> JValue
p17 (JString "null")  = JNull
p17 (JString a) = (JString a)
p17 (JArray xs) = JArray(map p17 xs)
p17 (JBool a) = (JBool a)
p17 (JNumber b) = (JNumber b)
p17 (JObject o) = JObject (map (\(a, b) -> (a, p17 b) ) o )


{- return a list of all the values v for which the attribute-value pair (s,v)
   occurs in the JValue, where s is the given input String. The order of the
   values v in the return list does not matter. -}
p18 :: String -> JValue -> [JValue]
p18 = undefined
-- -- p18 s (JObject o) = map (\(a, b) -> if s == a then b else Nothing) o concat (map(\(a,b) -> if s == a then p18 s b else Nothing) o)
-- p18 s (JObject o) = (map (\(a,b) -> b) (filter (\(a,b) -> s == a) o) ) ++ (map (\(a,b) -> p18 s b) o)
-- p18 s (JArray a) = map (\x -> p18 s x) a
-- p18 s j = []

-- JObject [(String, JValue)]