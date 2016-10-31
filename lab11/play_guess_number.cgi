#!/usr/bin/perl -w

use CGI qw/:all/;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

# Simple CGI script written by andrewt@cse.unsw.edu.au
# Outputs a form which will rerun the script
# An input field of type hidden is used to pass an integer
# to successive invocations

print <<eof;
Content-Type: text/html

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Guess A Number</title>
	<link href="play_guess_number.css" rel="stylesheet">
</head>
<body class = "mystyle">
eof

warningsToBrowser(1);

$higher_bound = param("higher_bound")||100;
$lower_bound = param("lower_bound")||1;
$guess = param("guess")||50; #hidden

if (defined param("correct")) {
	print <<eof;
    <form method="POST" action="">
		<p class="font">I win!!!<\p>
        <input type="submit" value="Play Again" class ="correct">
    </form>
eof
} else {

	if (defined param("higher")) {
		$lower_bound = $guess;
		$guess = int(($guess+$higher_bound)/2);
	} elsif (defined param("lower")) {
		$higher_bound = $guess;
		$guess = int(($guess+$lower_bound)/2);
	}

	print "<p class=\"font\">my guess is: $guess<\p>\n";
	print <<eof;
	<form method="POST" action="">
	<input class ="incorrect" type="submit" value="lower" name="lower">
	<input class ="correct" type="submit" value="correct" name="correct">
	<input class ="incorrect" type="submit" value="higher" name="higher">
eof
	print "<input type=\"hidden\" name=\"guess\" value=\"$guess\">\n";
	print "<input type=\"hidden\" name=\"lower_bound\" value = \"$lower_bound\">\n";
	print "<input type=\"hidden\" name=\"higher_bound\" value = \"$higher_bound\">\n";

}
print"</form>";
print <<eof;
</body>
</html>
eof
