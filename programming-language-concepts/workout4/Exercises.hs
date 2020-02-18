module Exercises where

{- conjoin the booleans inside the given inputs.  So
   p1 (Just True) (Just True) would be Just True, for
   the example where the applicative f is Maybe. -}
a1 :: Applicative f => f Bool -> f Bool -> f Bool
a1 = undefined

{- process each action in the given list, but if you encounter one which return False, skip the next action. -}
a2 :: Monad f => [f Bool] -> f ()
a2 = undefined

s1 :: Monad f => f Bool -> f a -> f a -> f a
s1 x a1 a2 =
  do
    b <- x
    if b then
      a1
    else
      a2

s2 :: Monad f => f a -> f Int
s2 x =
  do
    x
    x
    return 3

{- A simple state monad for accessing a stack of Ints -}
newtype St a = St {openSt :: [Int] -> ([Int] , a)}

instance Functor St where
  fmap f (St s) = St $ \ i -> fmap f (s i) -- using sneaky fact that (,) is functorial in second component

instance Applicative St where
  pure x = St $ \ i -> (i , x)
  (St f) <*> (St y) = St (\ i -> let (i',vf) = f i in
                             let (i'',vy) = y i' in
                               (i'',vf vy))
instance Monad St where
  (St m) >>= f = St (\ i -> let (i',vm) = m i in
                              openSt (f vm) i')

pushValue :: Int -> St ()
pushValue x = St $ \ i -> (x : i , ())

-- assumes the stack is nonempty
topValue :: St Int
topValue = St $ \ i -> (i,head i)

-- assumes stack is nonempty
popValue :: St Int
popValue = St $ \ i -> (tail i, head i)

data StackProg =
  Push Int | Pop | BinOp (Int -> Int -> Int) | Flip | StackProg :- StackProg

example :: StackProg
example =
  Push 3 :-
  Push 4 :-
  BinOp (-) :-
  Push 5 :-
  Flip

sum3 :: Int -> Int -> Int -> StackProg
sum3 = undefined

evalh :: StackProg -> St ()
evalh = undefined

eval :: StackProg -> [Int]
eval = fst . ($ []) . openSt . evalh
