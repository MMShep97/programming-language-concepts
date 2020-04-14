module equational where

open import lib

postulate
  A : Set
  a : A
  b : A
  c : A
  d : A    
  f : A → A
  g : A → A 
  h : A → A → A
  p : a ≡ b
  q : b ≡ c
  r : f a ≡ a
  s : h a a ≡ a
  t : ∀ x → f (g x) ≡ g (f x)
  u : ∀ {x} → f x ≡ x → g (g x) ≡ x  -- {x} means x is implicit, so you do not need to write it when you call u
  v : ∀ x → h x d ≡ x

L0 : c ≡ c
L0 = {!!}

L1 : c ≡ a
L1 = {!!}

L2 : h (f a) (f (f a)) ≡ a
L2 = {!!}

L3 : f b ≡ b
L3 = {!!} 

L4 : h (h d d) d ≡ d
L4 = {!!}

L5 : f (g (g a)) ≡ a
L5 = {!!}

L6 : f (g (f (g a))) ≡ g (g (f (f a)))
L6 = {!!}

L7 : ∀ x → f (f (f x)) ≡ x → f (f (f (f (f x)))) ≡ x → f x ≡ x
L7 = {!!}
