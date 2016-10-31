#!/usr/bin/perl -w

# ===================== courses.pl ===========================
# Write a Perl script courses.pl which prints the course codes 
# with a given prefix of all UNSW courses with lectures on the 
# Kensington Campus this session. For example:
# ./courses.pl VISN
# VISN1101
# VISN1111
# VISN1221
# VISN2111
# VISN2211
# VISN2231
# VISN3111
# VISN3211
# VISN4003
# Hints: The course codes with prefix VISN can be found in 
# this web page: http://www.timetable.unsw.edu.au/current/VISNKENS.html. 
# You can assume this is the case for all prefixes. You saw 
# how to retrieve a web page using wget in a previous lab. 
# So you can perform this task in less than 10 lines of Perl.
# ============================================================

# get first argument
$code = $ARGV[0];

# open url
$url = "http://www.timetable.unsw.edu.au/current/".$code."KENS.html";
open F, "wget -q -O- $url|" or die;
while ($line = <F>) {
	
	if ($line =~ /<td class="data"><a href="($code[0-9]{4}).html">$code[0-9]{4}<\/a><\/td>/) {
		print $line =~ /<td class="data"><a href="($code[0-9]{4}).html">$code[0-9]{4}<\/a><\/td>/;
		print "\n";
	}
	
}

