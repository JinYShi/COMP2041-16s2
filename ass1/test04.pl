#!/usr/bin/perl -w
# put your demo script here

# split with split in the string and separated by /
$str = "split/spilt/split/hi/bye";
@words = split /\//, $str;

foreach $word (@words){
	print "$word\n";
}