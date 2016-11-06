#!/bin/sh

# ============= date_image.sh =============
# shell script given a list of image files
# as arguments, change each file so that 
# it has a label added to the image  
# indicating the time it was taken.
# can assume last modified time is time
# last taken
# ==========================================

# for each image/argument
for image in $@
do
	# retrieve the date
	date=`ls -l "$image" | egrep -o "[A-Z][a-z]{2} [0-9]+ [0-9]{2}:[0-9]{2}"`
	convert -gravity south -pointsize 36 -draw "text 0,10 '$date'" $image temp
	# copy temp to image
	mv temp $image
	# doesnt affect modification time by changing the date
	touch -d"$date" $image
done
