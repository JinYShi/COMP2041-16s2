#!/usr/bin/perl -w

# ==================== frequency.pl ==========================
# Write a Perl script frequency.pl which prints the frequency 
# with each poet uses a word specified as argument. So if 
# Robert Frost uses the word "snow" 30 times in the 21699 words 
# of his poetry you are given, then its frequency is 
# 30/21699 = 0.001382552. 
# 	- the printf format of the output is "%4d/%6d = %.9f %s\n"
# 	- ignore case (change A-Z to a-z)
# 	- treat as a word any sequence of alphabetic characters
# 	- non-alphabetic characters [^a-z]) as spaces
# 
# Hint: this loop executes once for each .txt file in the directory poems. 
#    foreach $file (glob "poems/*.txt") {
#        print "$file\n";
#    }
# Hint: reuse code from last exercise
# ============================================================

# Hint: use a hash table of hash tables indexed by poet and word to store the word counts.
%matchcount=();
%wordcount=();

$match = $ARGV[0];
# ignore case 
$match =~ tr/A-Z/a-z/;
$count = 0;
$total = 0;
$fraction = 0;

# while there is a line
foreach $file (glob "poems/*.txt") {
	open (F, $file) or die ("could not open file");
	# format filename
	$filename = $file; 
	$filename =~ s/poems\///;
	$filename =~ s/_/ /g;
	$filename =~ s/.txt//;

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
	$fraction = $matchcount{$file}/$wordcount{$file}; 
	printf "%4d", $matchcount{$file};
	print "/";
	printf "%6d", $wordcount{$file};
	print " = ";
	printf "%.9f",$fraction;
	print " ".$filename."\n";
	#%4d/%6d = %.9f %s
	$count = 0;
	$total = 0;
	$fraction = 0;

}




