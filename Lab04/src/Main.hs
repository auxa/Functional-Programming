module Main where
import System.IO

import BinTree
import REPL
import Lab04

main
 = do putStrLn "\n\t Welcome to Lab 04\n"
      hSetBuffering stdout NoBuffering
      result <- srepl prompt04 done04 exit04 execute04 (Empty,0.0)
      putStrLn ("\n\tFinal Result: "++show result)
      putStrLn "\n\tGoodbye !\n"