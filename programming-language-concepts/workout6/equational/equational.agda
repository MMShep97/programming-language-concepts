module equational where

open import lib

postulate
  A : Set
  a b c d : A    
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
L0  = refl

L1 : c ≡ a
L1 rewrite sym q | sym p = refl

L2 : h (f a) (f (f a)) ≡ a
L2 rewrite r | r | s = refl

L3 : f b ≡ b
L3 rewrite sym p | r = refl 

L4 : h (h d d) d ≡ d
L4 rewrite v(d) | v(d) = refl

L5 : f (g (g a)) ≡ a
L5 rewrite u(r) | t (g(a)) | t(a) | r = refl

L6 : f (g (f (g a))) ≡ g (g (f (f a)))
L6 rewrite t (a) | t (g (f a)) | t (f a) = refl

L7 : ∀ x → f (f (f x)) ≡ x → f (f (f (f (f x)))) ≡ x → f x ≡ x
L7 a b c rewrite r = {!!}
