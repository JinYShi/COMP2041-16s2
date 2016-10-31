#!/usr/bin/perl -w
# put your demo script here

# a bunch of statements
print " statements \n";
$a = 3;
$b = 6;
# if/else
if ($a == 3 || $b == 1){
	print "true\n";
} else {
	print "false\n";
}
# for/foreach
for $i (0..9){
	print "$i\n";
}

foreach $i (0..9){
	print "$i\n";
}

#while
$a = 0;
while ($a < 3) {
	$a++;
	print "$a\n";	
}
