#!/usr/bin/perl -w

# ===================== lectures0.pl ===========================
# Write a Perl script lectures0.pl which given course codes as 
# arguments prints details of their lectures.
# 
# Its difficult to use a regexp to match the line containing the 
# lecture description but you match a previous line, then skip a 
# certain number of lines. You can also get the teaching period 
# this way. Don't panic if you can't get this quite right your 
# tutor will be generous with hints.
# Hint: a hash can be easily used to avoid repeated output.
# Hint: make sure you have the URL exactly as above - e.g. don't 
# have repeated slashes (the timetable website uses fragile rewriting rules).
# ==============================================================

# get first argument - course code

@times = ();

foreach $arg (@ARGV) {
    push @courses, $arg;
}

for $code (@courses){
	$url = "http://timetable.unsw.edu.au/current/".$code.".html";
	open F, "wget -q -O- $url|" or die;
	while ($line = <F>) {
		# if line matches Lecture</a></td>
		if ($line =~ /<td class="data"><a href="(#[SX][12]-[0-9]{4})">Lecture<\/a><\/td>/) {
			$sem = $1;
			$sem =~ s/#//g;
			$sem =~ s/-[0-9]{4}//g;
			# print 6 lines after
			for ($count = 6; $count != 0; $count--){
				$next = <F>;
			}
			if ($next =~ /<td class="data"><\/td>/){
			} else{
				# remove tags
				$next =~ s/<td class="data">//g;
				$next =~ s/<\/td>//g;
				# remove whitespace at start
				$next =~ s/^\s+//g;
				if (grep $_ eq $next, @times) {
					
				} else {
					push @times, $next;
					print $code.": ";
					print $sem." ";
					print $next;
				}		
			}		
		}
	}
}
