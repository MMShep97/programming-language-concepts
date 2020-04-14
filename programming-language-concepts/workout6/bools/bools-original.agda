module bools where

open import lib

----------------------------------------------------------------------
-- these problems are about the nand operator, also known as the Scheffer stroke
----------------------------------------------------------------------
nand-not : ∀ (b : 𝔹) → ~ b ≡ b nand b
nand-not = {!!}

nand-or : ∀ (b1 b2 : 𝔹) → b1 || b2 ≡ (b1 nand b1) nand (b2 nand b2)
nand-or = {!!}

nand-and : ∀ (b1 b2 : 𝔹) → b1 && b2 ≡ (b1 nand b2) nand (b1 nand b2)
nand-and = {!!}

nand-imp : ∀ (b1 b2 : 𝔹) → b1 imp b2 ≡ b1 nand (b2 nand b2)
nand-imp = {!!}

ite-not : ∀(A : Set)(x : 𝔹)(y : A)(z : A) → if x then y else z ≡ if ~ x then z else y
ite-not = {!!}

&&-distrib : ∀ x y z → x && (y || z) ≡ (x && y) || (x && z)
&&-distrib = {!!}

combK : ∀ x y → x imp (y imp x) ≡ tt
combK = {!!} 

combS : ∀ x y z → (x imp (y imp z)) ≡ tt → (x imp y) ≡ tt → x ≡ tt → z ≡ tt
combS = {!!}
