module bools where

open import lib

----------------------------------------------------------------------
-- these problems are about the nand operator, also known as the Scheffer stroke
----------------------------------------------------------------------
nand-not : ∀ (b : 𝔹) → ~ b ≡ b nand b
nand-not tt = refl
nand-not ff = refl

nand-or : ∀ (b1 b2 : 𝔹) → b1 || b2 ≡ (b1 nand b1) nand (b2 nand b2)
nand-or tt tt = refl
nand-or tt ff = refl
nand-or ff tt = refl
nand-or ff ff = refl

nand-and : ∀ (b1 b2 : 𝔹) → b1 && b2 ≡ (b1 nand b2) nand (b1 nand b2)
nand-and tt tt = refl
nand-and tt ff = refl
nand-and ff tt = refl
nand-and ff ff = refl

nand-imp : ∀ (b1 b2 : 𝔹) → b1 imp b2 ≡ b1 nand (b2 nand b2)
nand-imp tt tt = refl
nand-imp tt ff = refl
nand-imp ff tt = refl
nand-imp ff ff = refl

ite-not : ∀(A : Set)(x : 𝔹)(y : A)(z : A) → if x then y else z ≡ if ~ x then z else y
ite-not A tt y z = refl
ite-not A ff y z = refl

&&-distrib : ∀ x y z → x && (y || z) ≡ (x && y) || (x && z)
&&-distrib tt tt tt = refl
&&-distrib tt tt ff = refl
&&-distrib tt ff tt = refl
&&-distrib tt ff ff = refl
&&-distrib ff tt tt = refl
&&-distrib ff tt ff = refl
&&-distrib ff ff tt = refl
&&-distrib ff ff ff = refl

combK : ∀ x y → x imp (y imp x) ≡ tt
combK tt tt = refl
combK tt ff = refl
combK ff tt = refl
combK ff ff = refl 

combS : ∀ x y z → (x imp (y imp z)) ≡ tt → (x imp y) ≡ tt → x ≡ tt → z ≡ tt
combS x y z u v w rewrite w | v | u = refl
