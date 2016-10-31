#!/usr/bin/perl -w

# ============= digits.pl ==================
# reads from stin and writes to stdout
# replace characters less than 5 with <
# replace characters greater than 5 with >
# ==========================================

while ($line = <STDIN>){
	$line =~ tr/0-4/</;
	$line =~ tr/6-9/>/;	
	print $line;
}

# with implicit variables
# while (<STDIN>){
#	 tr/0-4/</;
#	 tr/6-9/>/;	
#	 print;
# }
