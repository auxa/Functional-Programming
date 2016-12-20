{-# LANGUAGE StandaloneDeriving #-}

module Main where

import Test.HUnit
import Test.Framework as TF (defaultMain, testGroup, Test)
import Test.Framework.Providers.HUnit (testCase)
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Data.Char
import Data.List

import System.IO
import System.IO.Unsafe

import BinTree
import REPL
import Lab04

{- HUnit Tests -}

{- Regression Tests (not marked - just check BinTree hasn't been broken) -}

test_R_show_empty  = show empCI @?= "Empty"
test_R_show_leaf_a1 = show leaf_a1 @?= "Leaf 'a' 1"
test_R_show_leaf_1a = show leaf_1a @?= "Leaf 1 'a'"
test_R_show_br_emp_a1 = show br_emp_a1 @?= "Branch Empty 'a' 1 Empty"
test_R_show_br_left_a1_b2
 = show br_left_a1_b2 @?= "Branch (Leaf 'a' 1) 'b' 2 Empty"
test_R_show_br_right_a1_b2
 = show br_right_a1_b2 @?= "Branch Empty 'a' 1 (Leaf 'b' 2)"
test_R_show_emptyX4
 = show emptyX4 
   @?= 
   "Branch (Branch Empty () () Empty) () () (Branch Empty () () Empty)"

test_R_map_emp = treeMap ord chr empCI @?= empIC
test_R_map_leaf = treeMap alphaOrd alphaChr leaf_b2 @?= leaf_2b
test_R_map_branch
  = treeMap (const 0) (const []) emptyX4
    @?=
    (nullX4 :: BinTree Int [Int])
  where
    nullX2 = Branch Empty 0 [] Empty
    nullX4 = Branch nullX2 0 [] nullX2

test_R_insert_emp = ins1 @?= Leaf 'c' 3
test_R_insert_leaf = ins2 @?= Branch (Leaf 'c' 3) 'd' 4 Empty
test_R_insert_br_new = ins3 @?= Branch (Branch Empty 'b' 2 (Leaf 'c' 3)) 'd' 4 Empty
test_R_insert_br_old = ins4 @?= Branch (Branch Empty 'b' 2 (Leaf 'c' 99)) 'd' 4 Empty

test_R_lkp_emp = treeLookup 'a' empCI @?= Nothing
test_R_lkp_leaf_fail = treeLookup 'a' leaf_b2 @?= Nothing
test_R_lkp_leaf_ok = treeLookup 'b' leaf_b2 @?= Just 2
test_R_lkp_branch = treeLookup 'c' ins4 @?= Just 99

{- Graded Tests -}

test_prompt = (take 6 $ dropWhile (not . isDigit) $ mkprompt (Empty,123.45)) @?= "123.45"

test_done_exit = done04 "exit" @?= True
test_done_stay = any done04 ["","add","fix","remove","_zero"] @?= False

test_exit_result
 = (unsafePerformIO (exit04 (Empty,123.45))) @?= (123.45 :: Float)

test_empty_add
 = ( unsafePerformIO $
      do hin <- openFile "test/empty_add.txt" ReadMode
         hout <- openFile "test/tests.log" AppendMode
         s1 <- execute04 hin hout "add" (Empty,0.0)
         hClose hin
         hClose hout
         return s1
   )  @?= (Leaf "gold" 100.0,100.0)

test_add_revise
 = ( unsafePerformIO $
      do hin <- openFile "test/add_revise.txt" ReadMode
         hout <- openFile "test/tests.log" AppendMode
         s1 <- execute04 hin hout "add" (Empty,0.0)
         s2 <- execute04 hin hout "add" s1
         hClose hin
         hClose hout
         return s2
   )  @?= (Leaf "gold" 1000.0,1000.0)

test_fix_bad_empty
 = ( unsafePerformIO $
      do hout <- openFile "test/fix_bad_empty.log" WriteMode
         s1 <- execute04 stdin hout "fix" (Empty,1000.0)
         hClose hout
         log <- readFile "test/fix_bad_empty.log"
         return (s1,null log)
   )  @?= ((Empty,0.0)::Lab04.State,False)

test_fix_good_empty
 = ( unsafePerformIO $
      do hout <- openFile "test/fix_good_empty.log" WriteMode
         s1 <- execute04 stdin hout "fix" (Empty,0.0 :: Float)
         hClose hout
         log <- readFile "test/fix_good_empty.log"
         return (s1 :: Lab04.State,null log)
   )  @?= ((Empty,0.0 :: Float),True)

test_fix_bad_branch
 = ( unsafePerformIO $
      do hout <- openFile "test/fix_bad_branch.log" WriteMode
         s1 <- execute04 stdin hout "fix" (Branch Empty "a" 11.0 (Leaf "b" 31.0),1000.0)
         hClose hout
         log <- readFile "test/fix_bad_branch.log"
         return (s1,null log)
   )  @?= ((Branch Empty "a" 11.0 (Leaf "b" 31.0),42.0),False)

test_fix_good_branch
 = ( unsafePerformIO $
      do hout <- openFile "test/fix_good_branch.log" WriteMode
         s1 <- execute04 stdin hout "fix" (Branch Empty "a" 11.0 (Leaf "b" 31.0),42.0)
         hClose hout
         log <- readFile "test/fix_good_branch.log"
         return (s1,null log)
   )  @?= ((Branch Empty "a" 11.0 (Leaf "b" 31.0),42.0),True)

test_remove_leaf
 = ( unsafePerformIO $
      do hin <- openFile "test/remove_gold.txt" ReadMode
         hout <- openFile "test/tests.log" AppendMode
         s1 <- execute04 hin hout "remove" (Leaf "gold" 1000.0,1000.0)
         hClose hin
         hClose hout
         return s1
   )  @?= (Leaf "gold" 0.0,0.0)

test_remove_branch
 = ( unsafePerformIO $
      do hin <- openFile "test/remove_gold.txt" ReadMode
         hout <- openFile "test/tests.log" AppendMode
         s1 <- execute04 hin hout "remove" ( Branch 
                                               Empty 
                                               "banana" 1.0 
                                               (Leaf "gold" 100.0)
                                           , 101.0 )
         hClose hin 
         hClose hout
         return s1
   )  @?= (Branch Empty "banana" 1.0 (Leaf "gold" 0.0), 1.0)

test_list
 = ( unsafePerformIO $
      do hout <- openFile "test/list_ghb.log" WriteMode
         s1 <- execute04 stdin hout "list" 
                 (Branch (Leaf "banana" 1.0) 
                         "gold" 1000.0
                         (Leaf "home" 15000.0)
                 ,15001.0)
         hClose hout
         log <- readFile "test/list_ghb.log"
         return (lines log)
   )  @?= ["banana 1.0","gold 1000.0","home 15000.0",""]

test_help
 = ( unsafePerformIO $
      do hout <- openFile "test/help.log" WriteMode
         s1 <- execute04 stdin hout "?" (Empty,0.0)
         hClose hout
         log <- readFile "test/help.log"
         return $ sort $ words log
   )  @?= ["?","add","exit","fix","list","remove"]

{- Test Main -}

main = defaultMain tests

tests :: [TF.Test]
tests 
  = [ testGroup "\nREGRESSION TESTS (not marked)" 
      [ testCase "Show Empty {R}" $ test_R_show_empty
      , testCase "Show Leaf a 1 {R}" $ test_R_show_leaf_a1
      , testCase "Show Leaf 1 a {R}" $ test_R_show_leaf_1a
      , testCase "Show Br Empty a 1 {R}" $ test_R_show_br_emp_a1
      , testCase "Show Br Left a 1 b 2 {R}" $ test_R_show_br_left_a1_b2
      , testCase "Show Br Right a 1 b 2 {R}" $ test_R_show_br_right_a1_b2
      , testCase "Show Empty X 4 {R}" $ test_R_show_emptyX4
      , testCase "Map Empty {R}" $ test_R_map_emp
      , testCase "Map Leaf {R}" $ test_R_map_leaf
      , testCase "Map Branch {R}" $ test_R_map_branch
      , testCase "Insert Empty {R}" $ test_R_insert_emp
      , testCase "Insert Leaf {R}" $ test_R_insert_leaf
      , testCase "Insert Branch (New) {R}" $ test_R_insert_br_new
      , testCase "Insert Branch (Old) {R}" $ test_R_insert_br_old
      , testCase "Lookup Empty {R}" $ test_R_lkp_emp
      , testCase "Lookup Leaf (Fail) {R}" $ test_R_lkp_leaf_fail
      , testCase "Lookup Leaf (Ok) {R}" $ test_R_lkp_leaf_ok
      , testCase "Lookup Branch {R}" $ test_R_lkp_branch
      ]
    , testGroup "Prompting (1 mark)" 
      [ testCase "Prompt {1 mark}" test_prompt
      ]
    , testGroup "Exiting (2 marks)" 
      [ testCase "Exit {1 mark}" test_done_exit
      , testCase "Stay {1 mark}" test_done_stay
      ]
    , testGroup "Exit Result (1 mark)" 
      [ testCase "Final Result {1 mark}" test_exit_result
      ]
    , testGroup "Commands (16 marks)" 
      [ testCase "Add to Empty {2 marks}" test_empty_add
      , testCase "Revise Add {2 marks}" test_add_revise
      , testCase "Fix Bad Empty {1 mark}" test_fix_bad_empty
      , testCase "Fix Good Empty {1 mark}" test_fix_good_empty
      , testCase "Fix Bad Branch {1 mark}" test_fix_bad_branch
      , testCase "Fix Good Branch {1 mark}" test_fix_good_branch
      , testCase "Remove Leaf {2 marks}" test_remove_leaf
      , testCase "Remove Branch {2 marks}" test_remove_branch
      , testCase "List (b,g,h) {2 marks}" test_list
      , testCase "Help Listing {2 marks}" test_help
      ]
    ]
