#!/usr/bin/perl -w
# put your demo script here

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
