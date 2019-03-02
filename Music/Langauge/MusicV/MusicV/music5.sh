#!/bin/sh
rm snd.raw
cp -f $1 score
./pass1
./pass2
./pass3
echo "===================="
echo "snd.raw has been written to disk"
echo "===================="


