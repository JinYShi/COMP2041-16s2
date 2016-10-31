#!/usr/bin/perl -w
use CGI qw/:all/;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;

print header, start_html("Credit Card Validation"), "\n";
warningsToBrowser(1);

print h2("Credit Card Validation");

$credit_card = param("credit_card");
param('credit_card',$credit_card);
$close = param("Close");

if (defined $close){
	print"Thank you for using the Credit Card Validator.";
	print end_html;
	exit 0;
} else {
	print "This page checks whether a potential credit card number satisfies the Luhn Formula.<br>";
}

if (defined $credit_card) {
	$ret = validate($credit_card);
	if ($ret == 1){ # is there a reason why (validate($credit_card) == 1) doesnt work?
		param('credit_card','');
		print start_form, "\n";
		print "<p>$credit_card is valid</p>\n";
		print "Another card number:\n";
		print textfield(-name => 'credit_card'),"\n";
	} elsif ($ret == 0) { 
		print start_form, "\n";
		print span({-style => 'Color: red;'},"<p><b>$credit_card is invalid</b></p>"),"\n";
		print "Try again:\n";
		print textfield(-name => 'credit_card',-value => $credit_card),"\n";
	} elsif ($ret == 2) {
		print start_form, "\n";
		print span({-style => 'Color: red;'},"<p><b>$credit_card is invalid - does not contain exactly 16 digits</b></p>"),"\n";
		print "Try again:\n";
		print textfield(-name => 'credit_card',-value => $credit_card),"\n";
	}
} else {
	print start_form,"\n";
	print "Enter credit card number:\n";
	print textfield('credit_card'),"\n";
}
print submit(value => Validate),"\n";
print reset(),"\n";
print submit(-name => Close,-value => Close),"\n";
print end_html;
exit 0;

sub validate {
	$card = shift;
	my $element = $card;
	$element =~ s/\D//g;
	# check if its 16 DIGITS (with or without)
	# 9182387723427777 or 1234-5678-9012-3456
	if (length $element == 16 ){
		# check if its valid 
		if (luhn_checksum($element) % 10 == 0){
			return 1;
		} else {
			return 0;
		}	
	} else {
		return 2;	
	}
}

# luhan checksum from tutorial
sub luhn_checksum {
    my ($number) = @_;
    my $checksum = 0;
    my @digits = reverse(split //, $number);
    foreach $index (0..$#digits) {
        my $digit = $digits[$index];
        my $multiplier = 1 + $index % 2;
        my $check_digit = int($digit) * $multiplier;
        if ($check_digit > 9) {
            $check_digit -= 9;
        }
        $checksum += $check_digit;
    }
    return $checksum;
}


# cross-site scripting
# Validate by replacing < with &lt
