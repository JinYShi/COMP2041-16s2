#!/usr/bin/perl -w

# =================== total_words.pl =========================
# Perl script which counts the total number of words found on 
# in its input (STDIN). Define a word to be maximal non-empty 
# contiguous sequences of alphabetic characters ([a-zA-Z]).
# ============================================================


$nwords=0;
while ($line = <STDIN>){
	# convert to lowercase
	$line =~ tr/A-Z/a-z/;
	# change everything that isnt a character to space
	$line =~ s/[^a-z]/ /g;
	# change every whitespace to a space
	$line =~ s/\s/ /g;
	# weird stuff with spaces at the start of the line
	# fix by deleting whitespace at start
	$line =~ s/^\s+//g;
	
	$nwords+=scalar(split(/ +/, $line));
}
	print $nwords," words\n";
