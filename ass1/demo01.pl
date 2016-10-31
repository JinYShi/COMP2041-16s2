#!/usr/bin/perl -w
# put your demo script here

# assign arguments to num and str variables
$num=$ARGV[0];
$str=$ARGV[1];

# increment through arguments
for ($i = 0; $i < @ARGV; $i++){	}


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
