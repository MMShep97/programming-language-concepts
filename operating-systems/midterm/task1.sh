#!/bin/bash

# Decompress tar files w/ 
#   -> 'cs3620' in filename (in dir/subdir)

DIRECTORY=$1

TAR_FILES=$(find $DIRECTORY -name "*cs3620*.tar")

for TAR_FILE in $TAR_FILES
do
    tar -xf $TAR_FILE
done