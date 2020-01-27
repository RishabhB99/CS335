#!/bin/bash

read -p "Enter file name: " INFILE
gcc lexer.c
T1=$(echo $INFILE | awk -F'.' '{print $1}')
T2=$(echo $INFILE | awk -F'.' '{print $2}')
if [ "$T2" != "java" ]; then
	echo "ERROR: File name '$INFILE' is incorrect!"
	exit -1
fi

#Check if file exists
if [ ! -f $INFILE ]; then
	echo "ERROR: FIle '$INFILE' is not present!"
	exit -1
fi

OUTFILE="$T1.out"
./a.out $INFILE > $OUTFILE
