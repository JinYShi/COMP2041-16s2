#!/bin/sh
# =============== jpg2png.sh ===============
# shell script that converts all images in 
# JPEG (.jpg)format in the current directory
# to PNG (.png) format
# ==========================================

# if conversion is successful JPEG should be removed


for file in *
do
	# get filename
	filename=$(echo $file|cut -d'.' -f1)
	filetype=$(echo $file|cut -d'.' -f2)
	# if jpg file
	if [ $filetype == "jpg" ];
	then
		echo $file
		# if filename.png already exists
		pngfile=($filename.png)
		if [ -e $pngfile ]
		then 
			# error message  
			echo $filename.png already exists
			# exit status
		else
			newfile=$(echo $file|sed s/\.jpg/\.png/)
			echo $newfile
			convert "$file" "$newfile"
			rm "$file"
		fi
	fi	
done
