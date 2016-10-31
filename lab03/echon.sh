#!/bin/sh
if test $# = 2
then
	if test $1 -ge 0 2>/dev/null # check if greater than or equal to 0 ie positive integer
	then
		NUM=$1
		STR=$2
		while [ $NUM -ge 1 ] # same as test
		do
			echo $STR
			#decrease by one
			NUM=$((NUM-1))
		done
	else
	# error message
	echo "./echon.sh: argument 1 must be a non-negative integer"
	fi
else
	# error message
	echo "Usage: ./echon.sh <number of lines> <string>"
fi
