#!/usr/bin/perl -w
# put your demo script here

# ============== SUBSET 2 ==============
# logical operators: || && ! and or not
# comparison operators: <, <=, >, >=, <=>, !=, ==
# bitwise operators: | ^ & << >> ~
# if/else/elsif, for/foreach, while statements
# ======================================

$a = 6;
$b = "|hello";

# test if the logical operator works if operator is in string
if ($a == 3 || $b eq "||hello"){
	print "true\n";
# check if elsif works without bracket
} 
elsif ($a+2 > 3) {
	print "false\n";
}