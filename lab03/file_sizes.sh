#!/bin/sh
for file in *
	do
		if test `wc -l<$file` -lt 10
			then small="$small $file"
		elif test `wc -l<$file` -lt 100
			then medium="$medium $file"
		else 
			large="$large $file"
		fi
	done
echo "Small files:$small"
echo "Medium-sized files:$medium"
echo "Large files:$large"
