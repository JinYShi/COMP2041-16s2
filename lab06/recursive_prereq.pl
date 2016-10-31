#!/usr/bin/perl -w

# ====================== recursive_prereq.pl ============================
# 
# =======================================================================
$subject=$ARGV[0];

# supplied code from lab spec
# simple (but not best) way to access web page from Perl

$undergradurl = "http://www.handbook.unsw.edu.au/undergraduate/courses/2016/$subject.html";
$postgradurl = "http://www.handbook.unsw.edu.au/postgraduate/courses/2016/$subject.html";


open F, "wget -q -O- $undergradurl|" or die;
while ($line = <F>) {
	if ($line =~ /Prerequisite/){
		$line =~ s/<\/p>.*//g;
		
		@classes = $line =~ /[A-Z]{4}[0-9]{4}/g;
		print "$_\n" for @classes;
	}

}

open F, "wget -q -O- $postgradurl|" or die;
while ($line = <F>) {
	if ($line =~ /Prerequisite/){
		$line =~ s/<\/p>.*//g;
		
		@classes = $line =~ /[A-Z]{4}[0-9]{4}/g;
		print "$_\n" for @classes;
	}
    
}


