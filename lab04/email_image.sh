#!/bin/sh

# ============= email_image.sh =============
# shell script that gives a list of image 
# files as arguments and displays them one 
# by one. After the user has viewed each 
# image the script should prompt the user
# for an email address, then a message to 
# accompany the image. Then send.
# ==========================================

# for each image/argument
for image in $@
do
	# display image
	display $image
	# ask for email
	echo -n "Address to e-mail this image to?"
	read email
	# ask for message
	echo -n "Message to accompany image?"
	read message
	# send email
	mutt -s "$message" -a "$image" -- "$email"
	# success message 
	echo $file sent to $email
	# else, ask for email again
	# echo 'Not a valid email address'
done
