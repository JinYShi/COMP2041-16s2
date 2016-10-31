#!/usr/bin/perl -w

# ===================== lectures1.pl ===========================
# The output from lectures0.pl is (more or less) human readable 
# but is less convenient for other uses. Copy lectures0.pl to 
# lectures1.pl and modify it so that if a -d option is specified 
# it prints the hourly details of lectures
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
					@tuples = split (/, /, $next);
					push @times, $next;
					# if d flag
					if ($ARGV[0] eq "-d"){
						foreach $time (@tuples){
							$time =~ s/:[0-9]{2} - [0-9]{2}:[0-9]{2}//g;
							$time =~ s/\(.*\)$//g;
							print $sem." ".$code;
							print " ".$time;
							$size= @tuples;
							if ($tuples[$size-1] eq $time){
							} else{
								print "\n";
							}
							
						}
						
					} else{					
						print $code.": ";
						print $sem." ";
						print $next;
					}		
				}		
			}		
		}
	}
}
