#!/usr/bin/perl -w
# put your demo script here

while ($line = <STDIN>){
	$line =~ tr/0-4/</;
	$line =~ tr/6-9/>/;	
	print $line;
}
