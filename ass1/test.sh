#!/bin/sh
for arg in "$@"
do
	name="$(echo $arg | sed s/\.pl$//)"
	echo " ============== perl =============="
	chmod 700 $name.pl
	 ./$name.pl 
	 echo " ============== python =============="
	 ./plpy.pl $name.pl > $name.py
	cat $name.py
	 chmod 700 $name.py
	 ./$name.py
	 echo " ============== compare =============="
	 ./$name.pl >pl.output
	 ./$name.py >py.output
	 diff py.output pl.output && echo success
done
