#!/usr/bin/perl -w

use CGI qw/:all/;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;

print header, start_html('Login');
warningsToBrowser(1);

$username = param('username') || '';
$password = param('password') || '';

# both
if ($username && $password) {
	# check if file exists 
	if (open F, "accounts/$username/password"){
	#if (open F, "accounts/$username/password"){
		$authenticate = <F>;
		if ($password eq $authenticate){
			print "$username authenticated.\n";
		} else {
			print "Incorrect password!\n";
		}	
	} else {
		print "Unknown username!\n";
	}
    
# username only
} elsif (!$username && $password){
	print start_form, "\n";
    print "Username:\n", textfield('username'), "\n";
    print submit(value => Login), "\n";
	print hidden('password' => $password);
    print end_form, "\n";
# password only
} elsif ($username && !$password){
	print start_form, "\n";
    print "Password:\n", textfield('password'), "\n";
    print submit(value => Login), "\n";
	print hidden('username' => $username);
    print end_form, "\n";
# else
} else {
    print start_form, "\n";
    print "Username:\n", textfield('username'), "\n";
    print "Password:\n", textfield('password'), "\n";
    print submit(value => Login), "\n";
    print end_form, "\n";
}
print end_html;
exit(0);
