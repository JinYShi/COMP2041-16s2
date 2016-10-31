#!/usr/bin/perl -w

# ==================== identify_poet.pl ==========================
# Given 1 or more files, print the most likely poet for each poem.
# For each file given as argment, go through 10 poets and calculate
# the log probability that the poet wrote that poem by summing log 
# probability for each word in the file. 
# ================================================================

%matchcount=();
%wordcount=();
@files=();
%probability=();

$match = $ARGV[0];
# ignore case 
$match =~ tr/A-Z/a-z/;
$count = 0;
$total = 0;
$fraction = 0;

# for each file in arguments

foreach $arg (@ARGV) {
    push @files, $arg;
}

foreach $poem (@files) {
	open (F, $poem) or die ("could not open file");
	while ($line = <F>){
		# convert to lowercase
		$line =~ tr/A-Z/a-z/; 
		# change everything that  lisnt a character to space
		$line =~ s/[^a-z]/ /g;
		# change every whitespace to a space
		$line =~ s/\s/ /g;
		# weird stuff with spaces at the start of the line
		# fix by deleting whitespace at start
		$line =~ s/^\s+//g;
		# split by whitespace into @words
		@cmpwords = split (/\s+/, $line);
	}
	foreach $word (@cmpwords){
	# while there is a line
		foreach $file (glob "poems/*.txt") {
			open (F, $file) or die ("could not open file");
			# format filename
			$poet = $file; 
			$poet =~ s/poems\///;
			$poet =~ s/_/ /g;
			$poet =~ s/.txt//;
			while ($line = <F>){
				# convert to lowercase
				$line =~ tr/A-Z/a-z/;
				# change everything that isnt a character to space
				$line =~ s/[^a-z]/ /g;
				# change every whitespace to a space
				$line =~ s/\s/ /g;
				# weird stuff with spaces at the start of the line
				# fix by deleting whitespace at start
				$line =~ s/^\s+//g;
				# split by whitespace into @words
				@words = split (/\s+/, $line);
				# for each word in @words
				foreach $word (@words){
					# add to total word count
					$total += 1;
					# if word matches match
					if ($word eq $match){
						# increment counter
						$count += 1;
					}
				}
			}		
			$matchcount{$file} = $count;
			$wordcount{$file} = $total;
			$fraction = ($matchcount{$file}+1)/$wordcount{$file}; 
			$log = log$fraction;
			#print $log;
			#print "total $totalprob";
			$probability{$poet} += $log;
			# reset counters
			$count = 0;
			$total = 0;
			$fraction = 0;
			$total = 0;
		}
	}
	# find highest probability
	$highest = $probability{$poet};
	$likeliest = $poet;
	foreach $poet (keys %probability){
		print $poet.$probability{$poet}."\n";
		if ($probability{$poet} > $highest) {
			$highest = $probability{$poet};
			$likeliest = $poet;
		}
	}
	printf("%s most resembles the work of %s (log-probability=%.1f)\n",$poem,$likeliest,$highest);
}

