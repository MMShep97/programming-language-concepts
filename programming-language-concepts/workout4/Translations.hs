t1 :: Monad f => f Bool -> f a -> f a -> f a
t1 x a1 a2 = x >>= \b -> (if b then a1 else a2)

t2 :: Monad f => f a -> f Int
t2 x = x >> x >> return 3