#!/usr/bin/perl -w
# validate a credit card number by calculating its
# checksum using Luhn's formula (https://en.wikipedia.org/wiki/Luhn_algorithm)


# read arguments and push to array
foreach $arg (@ARGV) {
    push @numbers, $arg;
}

# for each element in array
foreach $element (@numbers) {
	# check if its 16 DIGITS (with or without)
	# 9182387723427777 or 1234-5678-9012-3456
	if ($element =~ /\d\d\d\d\-?\d\d\d\d\-?\d\d\d\d\-?\d\d\d\d/){
		# check if its valid 
			# print "element is valid"
			print "$element is valid\n";
		# else 
			# print "element is invalid"
			print "$element is invalid\n";
	} else {
		# print "element is invalid"
		print "$element is invalid\n";	
	}
}
