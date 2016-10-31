#!/usr/bin/perl -w

# ======================================= tail.pl ==============================================
# script to implement unix tail command
# should have the features:
# 	- read from files supplied as command line arguments
#	- read from standard input if no file name arguments are supplied
#  - display the error message tail.pl: can't open FileName for any unreadable file
#  - display the last N lines of each file (default N = 10)
#  - can adjust the number of lines displayed via an optional first argument -N
#  - if there are more than one named files, separate each by ==> FileName <== 
# ==============================================================================================

# default is 10
$lines = 10;

# supplied code from lab spec - deals with collection of files in command line
@files = ();
foreach $arg (@ARGV) {
    if ($arg eq "--version") {
        print "$0: version 0.1\n";
        exit(0);
	# first argument is in form "-3"
    } elsif ($arg =~ /^-[0-9]+$/){
		$arg =~ s/-//g;
		$lines = $arg;
	} else {
        push @files, $arg;
    }
}
# if no files 
if (@files == 0){
	@lines = <STDIN>;
	$count = @lines;
	# more lines than the argument
	if ($count > $lines){
		# print only the bottom
		print @lines[$count-$lines..$count-1];
	# less lines than the argument
	} else {
		# print everything
		print @lines;
	}	
}

# at least one file supplied
foreach $f (@files) {
	open(F,"<$f") or die "$0: Can't open $f: $!\n";
	# if one file
	if (@files == 1){
		@lines = <F>;
	# more than one file
	} else{
		print "==> $f <==\n";
		@lines = <F>;
	}	
    $count = @lines;
	# more lines than the argument
	if ($count > $lines){
		# print only the bottom
		print @lines[$count-$lines..$count-1];
	# less lines than the argument
	} else {
		# print everything
		print @lines;
	}		
	close(F);
}
