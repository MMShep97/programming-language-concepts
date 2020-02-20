#!/bin/sh

# Must compile code in  . . . . 
#   ... printargs
#   ... printargsandenv
#   ... shell

gcc -o printargs printargs.c
gcc -o printargsandenv printargsandenv.c
gcc -o shell shell.c
