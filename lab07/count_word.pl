#!/usr/bin/perl -w

# ==================== count_word.pl ==========================
# Perl script which counts the number of times a specified word 
# is found on in its input (STDIN). Word is defined as maximal 
# non-empty contiguous sequences of alphabetic characters 
# ([a-zA-Z]). Word you should count will be specified as a 
# command line argument. Should ignore case.
# =============================================================

$match = $ARGV[0];
# ignore case 
$match =~ tr/A-Z/a-z/;
$count = 0;

# while there is a line
while ($line = <STDIN>){
	# convert to lowercase --- is there something to ignore case rather than tr??
	$line =~ tr/A-Z/a-z/;
	# convert non character to space
	$line =~ s/[^a-z]/ /g;
	# split by whitespace into @words
	@words = split (/\s+/, $line);
	# for each word in @words
	foreach $word (@words){
		# if word matches match
		if ($word eq $match){
			# increment counter
			$count += 1;
		}
	}
}
print $match." occurred ".$count." times\n";


