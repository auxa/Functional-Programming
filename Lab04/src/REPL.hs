module REPL where
import System.IO


hrepl :: Handle                 -- hin  : input stream handle
      -> Handle                 -- hout  : output stream handle
      -> (Handle -> s -> IO ())           -- hprompt  : issues a prompt dependent on the state
      -> (String -> Bool)       -- done    : tests if user command is for exit
      -> (s -> IO a)            -- exit    : computes the return value on exit
      -> (Handle -> Handle      -- hexecute : executes command to do IO and change state
          -> String -> s -> IO s)  
      -> s                      -- state   : starting state
      -> IO a                   -- REPL returns value of type a

hrepl hin hout hprompt done exit hexecute state
 = do hprompt hout state 
      cmd <- hGetLine hin
      if done cmd
       then exit state
       else
        do state' <- hexecute hin hout cmd state
           hrepl hin hout hprompt done exit hexecute state'

-- set handles to stdin,stdout
srepl :: (Handle -> s -> IO ())  -- prompt  : issues a prompt dependent on the state
      -> (String -> Bool)        -- done    : tests if user command is for exit
      -> (s -> IO a)             -- exit    : computes the return value on exit
      -> (Handle -> Handle       -- hexecute : executes command to do IO and change state
          -> String -> s -> IO s)  
      -> s                       -- state   : starting state
      -> IO a                    -- REPL returns value of type a

srepl hprompt done exit hexecute state
 =  hrepl stdin stdout hprompt done exit hexecute state

