{- Joseph Fitzpatrick 14312993 jfitzpa1 -}

module Lab04 where
import BinTree
import System.IO
import Data.Maybe

thisIsLab04 = "This is Lab 4"

{- 

Lab 04 implements a REPL that allows
the user to maintain and build a simple database
that records insured items: a description string along with their valuation.

The REPL provides facilites to add items, display them
and keeps a running total of the value of everything listed

When the REPL exists, it returns the running total

-}
type State
  = (BinTree String Float  , Float )              -- total valuation

{- Task 1 ======= (1 mark)

The prompt string should display the running total (somewhere)

-}

prompt04 hout state = hPutStr hout $ mkprompt state
mkprompt state = " \nCurrent Total:" ++ show (check state) ++ "\n"

check :: State -> Float
check (holder,checkingThis)  = checkingThis


{- Task 2 ======= (2 marks)

The user should enter the command "exit" to exit.

-}
done04 command =  if(command == "exit") then True else False
 

{- Task 3 ======= (1 mark)

  The running total should be returned on exit

-}
exit04 state =  return (check state)

{- Tasks 4.1--4.5 ====== (16 marks)

  All commands are single lowercase words

  Task 4.1 ----- (4 marks)
   command "add" will issue two prompts, one to get the description, the second to get the value.
   The tree will have this information inserted into it,
   and the running total updated appropriately.

   use 'hGetLine handle' rather than 'getLine' !

   hint: to convert a string  'str' to a float 'f' use  f = read str :: Float
   This will give a runtime  error if the string does not represetn a float.
   All tests will use strings that do represent a float

-} 
addMethod :: String -> String -> State -> State
addMethod a str (x,y) =
	let t = treeLookup a x
	in if(isNothing t) then 
	 ((treeInsert a (read str :: Float) x), (y+(read str :: Float) ))
	else 
	let r = fromJust t
	in ((treeInsert a (read str :: Float) x), (y+(read str :: Float) - r))

{-fixed :: State -> State
fixed (x, y) = if ( "Empty"==(treeShow False x)) then (x, 0)
		else (x, y)
-}

fixed :: State -> State
fixed (x, y) = let val = getVal x
	      in if val == y then (x,y)
		else (x,val)

getVal :: (BinTree String Float) -> Float
getVal Empty =0.0
getVal (Leaf k dat) =  dat 
getVal (Branch ltree k dat rtree) = (getVal ltree) +  dat + (getVal rtree)



delete :: State -> String -> State
delete (x,y) str = if ((treeLookup str x) == Nothing) then (x,y)
                        else let temp = (findAndDelete x str)
                              in (temp, (getVal temp))

findAndDelete :: BinTree String Float -> String -> BinTree String Float
findAndDelete (Leaf k dat) _ = (Leaf k 0.0)
findAndDelete (Branch ltree k dat rtree) str
 | str < k    =Branch (findAndDelete ltree str) k dat rtree
 | str > k    = Branch ltree k dat (findAndDelete rtree str)
 | otherwise  = Branch ltree k 0.0 rtree

     

printThis :: State -> String
printThis (x, y) = toStringThis x

toStringThis :: BinTree String Float -> String
toStringThis Empty = ""
toStringThis (Leaf k d) = (k ++ " " ++ (show d) ++ " ")
toStringThis (Branch rtree k d ltree) = (toStringThis rtree) ++( k ++ " " ++ (show d) ++" " ) ++ (toStringThis ltree)



execute04 hin   hout "add" state
 = do c <- hGetLine hin
      str <- hGetLine hin
      return ((addMethod c str state))

	 
{-
 treeInsert a temp x
  Task 4.2 ---- (4 marks)
   command "fix" will compute the total in the database tree
   and compare to the running total.
   If different it will issue a warning, and then fix it.
   If not different, it will silently return to the user prompt
-}
execute04 hin   hout "fix" state
 = let temp = fixed state
    in if(temp /= state)
        then do hPutStr   hout "error updated"
	        return temp
	else do return state
        
{-
   command "_zero",  already implemented, will set total to zero but leave tree untouched

  Task 4.3 ---- (4 marks)
   command "remove" will issue one prompt to get a description.
   It will remove the item by setting its value to zero,
   and correcting the running total
-}
execute04 hin   hout "remove" state
 = do c <- hGetLine hin
      return ((delete state c))
{-
  Task 4.4 ---- (2 marks)
   command "list" will list each ntry, one per line,
   in the form 'description value'
-}
execute04 hin   hout "list" state
 = let bob = (printThis state)
   in do hPutStr hout (show bob)
         return state
{-
  Task 4.5 ---- (2 marks)
   command "?" will list all the commands on one line, except for _zero
-}

execute04 hin   hout "?" state
 = do hPutStr hout ("? " ++ "add " ++ "exit " ++ "fix " ++ "list " ++ "remove ")
      return state
-- Ignore empty command lines
execute04 hin hout "" state 
 = return state

-- if all above fail, then report unknown command error to user
execute04 hin   hout command state
 = do hPutStr   hout "Command '"
      hPutStr   hout command
      hPutStrLn hout "' not recognised!"
      return state


