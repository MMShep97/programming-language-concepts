#!/bin/bash

for p in p0 p1 p2 p3 p4 p5 ; do
    echo "--------------------------"
    echo $p
    ./dist/build/Main/Main $p-yes.txt
done
