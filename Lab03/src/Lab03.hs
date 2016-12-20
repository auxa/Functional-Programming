{- FORENAME SURNAME STUDENT-ID -}

module Lab03 where
import Data.Char

thisIsLab03 = "This is Lab 3"

data BinTree k d
 = Empty
 | Leaf k d
 | Branch (BinTree k d) k d (BinTree k d)
 deriving Eq

instance (Show k, Show d) => Show (BinTree k d) where
    show = treeShow False


{-   ====== Task 1 ========

  treeShow takes two inputs:

    inDeep - a boolean indicating if the second argument occurs inside a BinTree
    bintree - a BinTree

  It returns a result of type String
    This converts the BinTree to a string.
    This should be the same as produced by show,
    if the BinTree datatype was declared with "deriving Show"

-}
treeShow :: (Show k, Show d) => Bool -> BinTree k d -> String

treeShow False (Leaf k d) = "Leaf " ++ show k ++ " " ++ show d
treeShow True (Leaf k d) = "(Leaf " ++ show k ++ " " ++ show d ++ ")"
treeShow False (Branch left k d right) = "Branch " ++ treeShow True left ++ " "++ show k ++
			 " "++ show d	++ " "++ treeShow True right
treeShow True (Branch left k d right) = "(Branch " ++ treeShow False left ++ " "++show k ++ 
			" " ++show d ++" "++ treeShow False right ++ ")"
treeShow _ Empty = "Empty"




{- ====== Task 2 ===== 

 treeMap takes three inputs:

 a function to transform key values
 a function to transform datum values
 a BinTree

 It returns a new BinTree with keys and datum values transformed
 using the first two function-valued inputs

-}
treeMap :: (k1 -> k2) -> (d1 -> d2) -> BinTree k1 d1 -> BinTree k2 d2
treeMap _ _ Empty = Empty
treeMap f f1 (Leaf k d) = Leaf (f k) (f1 d)
treeMap f f1 (Branch left k d right) = Branch (treeMap f f1 left) (f k) (f1 d) (treeMap f f1 right)


{- ===== Task 3 =====

Implement an insertion function.

1. It should never produce a BinTree component  of the form 
     Branch Empty key datum Empty
2. If inserting into a Leaf requires a Branch as a result
   then the original Leaf key and datum end up in a sub-tree


-}
treeInsert :: (Ord k) => k -> d -> BinTree k d -> BinTree k d
treeInsert key dat Empty = Leaf key dat 
treeInsert key dat (Leaf k d) = if (key < k) then Branch (Empty) key dat (treeInsert k d Empty)
				else if (key == k) then Leaf key dat
				else Branch (treeInsert k d Empty) key dat ( Empty)
treeInsert key dat (Branch left k d right) = if key < k then Branch (treeInsert key dat left) k d (right)
					else Branch (left) k d (treeInsert key dat right)
treeInsert _ _ _ = Empty


{-   ===== Task 4 ======

Implement a lookup function

-}
treeLookup :: Ord k => k -> BinTree k d -> Maybe d
treeLookup key Empty = Nothing
treeLookup key (Leaf k d) = if (k==key) then Just d else Nothing
treeLookup key (Branch left k d right) = if (k == key) then Just d
					else if (key< k) then treeLookup key left
					else treeLookup key right



{- ===== TEST VALUES  ===  DO NOT MODIFY BELOW HERE ==== -}

empCI,leaf_a1,leaf_b2,br_emp_a1,br_left_a1_b2,br_right_a1_b2 :: BinTree Char Int

empCI = Empty
leaf_a1 = Leaf 'a' 1
leaf_b2 = Leaf 'b' 2
br_emp_a1 = Branch Empty 'a' 1 Empty
br_left_a1_b2 = Branch leaf_a1 'b' 2 Empty
br_right_a1_b2 = Branch Empty 'a' 1 leaf_b2

empIC,leaf_1a,leaf_2b :: BinTree Int Char

empIC = Empty
leaf_1a = Leaf 1 'a'
leaf_2b = Leaf 2 'b'

emptyX2 = Branch Empty () () Empty
emptyX4 = Branch emptyX2 () () emptyX2

alphaOrd :: Char -> Int; alphaOrd c = ord c - 96
alphaChr :: Int -> Char; alphaChr i = chr (i + 96)

ins1 = treeInsert 'c' 3 empCI
ins2 = treeInsert 'd' 4 ins1
ins3 = treeInsert 'b' 2 ins2
ins4 = treeInsert 'c' 99 ins3
