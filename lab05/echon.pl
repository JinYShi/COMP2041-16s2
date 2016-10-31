#!/usr/bin/perl -w

# ============= echon.pl ===================
# given two arguments, integer n and string
# prints string n times
# ==========================================

# assign arguments to num and str variables
$num=$ARGV[0];
$str=$ARGV[1];

# increment through arguments
for ($i = 0; $i < @ARGV; $i++){	}

# test if two arguments
if ("$i" <= 2){ # can go without quotations
	# test if positive integer
	if ("$num" >= 0) { 
		# check if greater than 1 or 0
		while ("$num" > 0){
			# print string
			print "$str\n";
			# decrement
			$num -=1;
		}
	} else {
		# error message
		print "./echon.pl: argument 1 must be a non-negative integer";
	}
} else {
	# error message
	print "Usage: ./echon.pl <number of lines> <string> at ./echon.pl line 3.\n";
}
