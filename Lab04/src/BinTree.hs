module BinTree where
import Data.Char

data BinTree k d
 = Empty
 | Leaf k d
 | Branch (BinTree k d) k d (BinTree k d)
 deriving Eq

instance (Show k, Show d) => Show (BinTree k d) where
    show = treeShow False


treeShow :: (Show k, Show d) => Bool -> BinTree k d -> String
treeShow _ Empty = "Empty"
treeShow inDeep (Leaf key datum)
  = parenthesiseIf inDeep ("Leaf "++show key++" "++show datum)
treeShow inDeep (Branch ltree key datum rtree)
 = parenthesiseIf inDeep
     ("Branch "++treeShow True ltree++" "++show key++" "++show datum++" "++treeShow True rtree)

parenthesiseIf inDeep str
 | inDeep     =  "("++str++")"
 | otherwise  =       str


treeMap :: (k1 -> k2) -> (d1 -> d2) -> BinTree k1 d1 -> BinTree k2 d2
treeMap fk fd Empty = Empty
treeMap fk fd (Leaf key datum) = Leaf (fk key) (fd datum)
treeMap fk fd (Branch ltree key datum rtree)
 = Branch (treeMap fk fd ltree)
          (fk key) (fd datum)
          (treeMap fk fd rtree)

treeInsert :: (Ord k) => k -> d -> BinTree k d -> BinTree k d
treeInsert key datum Empty = Leaf key datum
treeInsert key datum tree@(Leaf k d)
 | key < k    =  Branch Empty key datum tree
 | key > k    =  Branch tree key datum Empty
 | otherwise  =  Leaf k datum
treeInsert key datum (Branch ltree k d rtree)
 | key < k    =  Branch (treeInsert key datum ltree) k d rtree
 | key > k    =  Branch ltree k d (treeInsert key datum rtree)
 | otherwise  =  Branch ltree k datum rtree

treeLookup :: Ord k => k -> BinTree k d -> Maybe d
treeLookup key Empty = Nothing
treeLookup key (Leaf k d)
 | key == k   =  Just d
 | otherwise  =   Nothing
treeLookup key (Branch ltree k d rtree)
 | key < k    =  treeLookup key ltree
 | key > k    = treeLookup key rtree
 | otherwise  =  Just d



{- ===== TEST VALUES  ======= -}

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
