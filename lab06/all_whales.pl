#!/usr/bin/perl -w

# ========================= all_whales.pl ===============================
# Perl scripts all_whales.pl that reads whale obsevatiions in the above 
# format until the end-of-input is reached and for all species of whale 
# observed prints the number of pods of the specified whale and the 
# total numbers of whales in those pods. 
#	- The whales should be listed in alphabetical order.
#	- All whale names should be converted to lower case.
#	- All whale names should be converted from plural to singular (assume 
#	  this can be done safely by deleting a trailing 's' if it is present)
#	- Any extra white space should be ignored.
#	- You can make no assumptions about possible whale names.
#	- No mention of particular whale names can appear in your program. 
# =======================================================================

# whale data storage as hashes
%whalecount=();
%podcount=();

# reading input
while (<STDIN>){
	$line = $_;
	$line =~ /^([0-9]*)\s+(.*)\s*$/;
	$count = $1;
	$whale = $2;
	
	# remove whitespace
	$whale =~ s/^ //g;
	$whale =~ s/\s+//g;
	# lower case
	$whale =~ tr /A-Z/a-z/;
	# singular - delete trailing s/
	$whale =~ s/s$//;		

	$whalecount{$whale} += $count;
	$podcount{$whale}++;

}
#output
foreach $w(sort keys %whalecount){
	print "$w observations: ";
	print "$podcount{$w} pods, ";
	print "$whalecount{$w} individuals\n";
}

