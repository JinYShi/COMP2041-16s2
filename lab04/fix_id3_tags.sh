#!/bin/sh

# this doesnt actually work because of the file stuff
for file in $*
do
	echo "$file"
	
	# music files
	# get the list file names
	id3 -l *.mp3 | egrep ^[0-9] |sort -n
	# separate individual file names, in the format of...
	name= # 2 - Little Talks - Of Monsters and Men.mp3
	directory= # Triple J Hottest 100, 2012
	
	title=$(echo $name|cut -d'-' -f2|sed s/'^ *'//)
	album= $directory
	artist=$(echo $name|cut -d'-' -f3|sed s/'^ *'//|sed s/.mp3:$//)
	year=$(echo $directory|cut -d',' -f2|sed s/'^ *'//)
	track=$(echo $name|cut -d' ' -f1)
	
	# set each thing in id3 tag to correct information
	# title -t
	id3 -t$title
	# track -T
	id3 -T$track
	# artist -a
	id3 -a$artist
	# album -A 
	id3 -A$album
	# year -y 
	id3 -y$year
	# comment and genre not required
done