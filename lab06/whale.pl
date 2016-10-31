#!/usr/bin/perl -w

# ============================ whale.pl ==================================
# Perl script whale.pl which given a whale name as a command line argument
# reads whale observations in the above format until the end-of-input is 
# reached and then prints the number of pods of the specified whale and 
# the total numbers of whales in those pods.
# ========================================================================

# initialise variables
$whale=$ARGV[0];
$individuals=0;
$pods=0;

# reading input
while ($line = <STDIN>){
	# if the input contains whale name (arg1)
	if($line =~ /^[0-9]* $whale$/){
		# increment pod numbers, and individual count
		$pods++;
		$count=$line;
		$count =~ s/[^0-9]//g;
		$individuals=$individuals+$count
	}
}

#output
print $whale." observations: ".$pods." pods, ".$individuals." individuals\n";
