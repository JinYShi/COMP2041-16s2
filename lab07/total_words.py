#!/usr/bin/python

# =================== total_words.py =========================
# Perl script which counts the total number of words found on 
# in its input (STDIN). Define a word to be maximal non-empty 
# contiguous sequences of alphabetic characters ([a-zA-Z]).
# ============================================================

import sys, re
count = 0
ignore=0
for lines in sys.stdin:
	for line in  lines.rstrip().split():
		if not line.strip():
			line = re.sub('[^a-zA-Z]+', '*', line)
			line = re.sub ('\W', ' ', line)
			line = re.sub ('^ ', '', line)
			line = re.sub (' $', '', line)
			
			for word in line.split(' '):
				if re.search('\W', word):
					ignore+=1
				elif word.isspace():
					ignore+=1
				else:
					count+=1	
				print word
				print count
print count, "words"
