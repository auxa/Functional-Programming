# CS3016 Lab 04  Insurance Valuation DB

## Task

You are implementing a simple REPL that will allow the user to enter
items (as `String`) and their  valuation/worth (as `Float`),  for insurance valuation purposes. The state of the  REPL consists of 

1. a binary tree that is used to store the mapping between items and their valuations, and
2. a running total of the value of the whole portfolio.

This involves implementing the following functions

1. `mkprompt` constructs a prompt string that shows the running total (1 mark)
2. `done04` tests a command-string to see if it means the program should exit (2 marks).
3. `exit04` exits the program, returning the running total (1 mark).
4. `execute04` implements all the commands, which are as follows:
  * "add"  allows the addition of new items, or the revising of existing ones (4 marks)
  * "fix" allows the running total to be adjusted to reflect the database contents. A command "_zero" already implemented allows the database to be corrupted to test this command. (4 marks)
  * "remove" allows an item to be removed by zero its valuation (4 marks)
  * "list" will list all the items present and their valuations (2 marks)
  * "?" will provide the user with basic help (2 marks)
 
Some command handling is already implemented, such as ignoring empty commands and reporting unknowmn ones.

Complete details of these are in the file `Lab04.hs`
in the src directory.

Again, as for the previous labs, Lab04.hs is the ***only*** file you should modify.

## Running Tests

As with previous labs, you need to type
`stack test`
to run the tests.

## Running the Program

Unlike previous lab, in this case you are producing a standalone program. The `main` function that runs the program is defined in `src/Main.hs`
To build and run the program do:

`stack build`

`stack exec lab04`


## Submitting Work

Remember to zip/tar or otherwise archive/compress the Lab04 folder
and submit this to Blackboard.
Currently supported archive formats are `.zip`, `.tar`, `.tar.gz`, `.rar`

*New: we now support  `.rar` !*

You should upload somethng of the form
`Lab04.zip`, `Lab04.tar`, `Lab04.tar.gz`, or `Lab04.rar`,
containing the entire `Lab04` folder.

## Running the Interpeter

You can also type

`stack ghci` 

to startup the GHCi interpeter.
Type `:help` to get help.

Once the interpeter is loaded,
enter the command

`:l Lab04`

which will load up the Lab04.hs file so you can experiment.

Simply type an expression at the prompt and GHCi will evaluate it.

The command 

`:browse`

will show all the values currently defined in that file.

You can exit the interpeter by typing

`:q`

