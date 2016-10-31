#!/usr/bin/perl -w

# Written by Samantha Chhoeu z5075755
# September 2016
# COMP2041/9041 assignment 

@imports=();
@code=();

while ($line = <>) {
	#chomp ($line); # gets rid of every new line character then u can add it whenever
	
	# ============== SUBSET 0 ==============
	# simple print statements (with explicit new lines) //
	# strings //
	# ======================================
	
	# //////////// SINGLE CASES ////////////
    if ($line =~ /^#!/ && $. == 1) {
    
        # translate #! line 
        
        print "#!/usr/local/bin/python3.5 -u\n";
		
    } elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {
    
        # Blank & comment lines can be passed unchanged
        
        #print $line;
		push(@code, "$line");
		
	} elsif ($line =~ /.*[^\\]}\s*$/){
	
		# Unescaped close bracket } by itself - get rid of it
		# ??? probably doesnt work but ill just leave it here
		$line =~ s/}//g;
		#print $line;
		push(@code, "$line");
	
	
	} elsif ($line =~ /^}\s*$/){
	
		# Unescaped close bracket } at start of line
		
		# $line =~ s/}//g;
		# print $line;
		
	}	
	
	# line contains last
	elsif ($line =~ /^\s*last\s*;\s*$/){
		$line =~ s/;//g; 
		$line =~ s/last/break/;
		push(@code, "$line");
	}
	
	# line contains next
	elsif ($line =~ /^\s*next\s*;\s*$/){
		$line =~ s/;//g; 
		$line =~ s/last/continue/;
		push(@code, "$line");
	}
		
	# /////////// NOT SINGLE CASES //////////
	
	# PRINT STATEMENTS
    elsif ($line =~ /^\s*print.*$/) {
	
		
		# prints with quotations
		if ($line =~ /^(\s*print\s*)\"(.*)\\n\"[\s;]*$/){
			# Python's print adds a new-line character by default
			# so we need to delete it from the Perl print statement
			
			$line = "$1(\"$2\")\n";
		}
		# prints without quotations (THIS IS DEFINITELY NOT 
		# BUT FIX IT LATER THE CORRECT WAY TO DO IT BUT)
		# print $factor0 * $factor1, "\n"; -> print(factor0 * factor1)
		if ($line =~ /^(\s*print\s*)(.*),.*\\n.*[\s;]*$/){
			$line = "$1(\"$2\")\n";
			
		}
		# concat strings for prints using commas
        # can put into array or something or use $1 $2 $3 etc
		# print without new line
		
		# join probably needs to be outside but ill reorganise later
		
		if ($line =~ /^(\s*print\s*).*\"join\((.*),\s*(.*)\)\"\)/){
			$line = "$1\($2.$3\)";
		
		}
		# CONTAINS unescaped ARGV
		if ($line =~ /^(.*[^\\])\@ARGV(.*)$/){
			$line = argv($line);
		}	
		
		# convert print to int
		#print "$a+$b\n";
		#print (a+b)
		if ($line =~ /^(\s*print\s*\()(.+[^\\])([\+|\-|\*|\/])(.+\).*)$/){
			$line = $1." int"."($2)".$3."int"."($4)\n";
		}
		
		
	# ============== SUBSET 1 ==============
	# variables //
	# numeric constants//
	# arithmetic operators//
	# ======================================
		# CONTAINING VARIABLES
		if ($line =~ /.*[^\\]\$.*/) {
			$line = var($line);
		}
		if ($line =~ /ARGV\[.*\]/){
			$line = arg($line);
		}
		

	#print $line;
	push(@code, "$line");
	
	
	# ============== SUBSET 2 ==============
	# logical operators: || && ! and or not//
	# comparison operators: <, <=, >, >=, <=>, !=, ==//
	# bitwise operators: | ^ & << >> ~//
	# if/else/elsif, for/foreach, while statements //
	# last, next (in java break, continue - also python i think)//
	# ======================================
	

	# if/for/while statements
	# unescaped open bracket {
	} elsif ($line =~ /^(.*)\((.*)\)(.*){.*/){
		$line = conditional($line);
		push(@code, "$line:\n");
		
	# ELSE
	}elsif ($line =~ /^.*else.*$/){ 
		# starting with bracket
		if ($line =~ /^(\s*)}\s*else\s*{\s*$/){
			$line = "$1else";
		# not starting with bracket
		} elsif ($line =~ /^(\s*)else(\s*){$/){
			$line = "$1else$2";
		}
		push(@code, "$line:\n");
	}
	# ============== SUBSET 3 ==============
	# simple use of <STDIN> \\
	# more complex print statements (e.g. without new lines)
	# simple uses of ++ & -- \\
	# .. (two dots) range? and stuff \\
	# chomp, split, join, ARGV, exit
	# ======================================
	
	# split
	elsif ($line =~ /(.*[^"]\s*)split\s*[^"]\/(.*)\/\s*,\s*(.*);$/){
		$first = $1;
		$second = $2;
		$third = $3;
		# variable
		$line = var($line);
		# if it contains an escape 
		if ($second =~ /(.*)\\(.*)/){
			$2 = $1.$2
		}
		$line = "$first$third.split(\"$second\")";
		push(@code, "$line\n");

	}
	# exit
	# exit exit if ($i ==1);
	elsif($line =~ /^\s*exit\s(.*);/){
		
		$line = var($line);
		$line = conditional($line);
		$line = "    ".$1."\n    exit()";
		push(@code, "$line\n");
	}
	elsif($line =~ /^\s*exit\s*;/){
		$line =~ s/\s*;/()/;
		push(@code, "$line\n");
	}
	
	
	# FROM SUBSET 1 - PUT HERE COS ITS USED A LOT
	# LINE BEGINS WITH UNESCAPED VARIABLE OR CONTAINS VARIABLE
	 elsif ($line =~ /.*[^\\]\$.*/ || $line =~ /^\$.*/) {
		# while line contains unescaped dollar sign
		# ??? not sure if works
	
		$line =~ s/^\$//s;
		$line =~ s/[\s;]*$//s;
		while ($line =~ /.*[^\\]\$.*/) {
			$line =~ s/\$//g;
			$line =~ s/^.*;\s*$//g;	
		}
		# ++ and --
		if ($line =~ /^(.*[^+])\+\+\s*$/){
			$line = $1."=".$1."+1";
		} elsif ($line =~ /^(.*[^-])\-\-\s*$/){
			$line = $1."=".$1."-1";
		}
		
		
		# from SUBSET 3 VARIABLE = <STDIN>
		# line = <STDIN>
		if ($line =~ /^(.*=\s*)<STDIN>\s*$/){
			# numbers have to be converted to float but when
			# i try it fails other tests so idk
			# for now if its number = something then itll be float
			# I KNOW ITS PRETTY SHITTY
			$var = $1;
			if ($1=~ /\s*number.*/){
				$line = "$var"."float(sys.stdin.readline())";
			}else{
				$line = "$1sys.stdin.readline()";
			}
			
			
			if(exists($imports{"import sys\n"})) { 
			}else{
				push(@imports, "import sys\n");
			}
			
			
		}
		
		# CHOMP
		# chomp line;
		if ($line =~ /^(\s*)chomp\s*(.*)\s*$/){
			$line = "$1$2 = line.rstrip()";
			
	
		}
		# REGEX
		if ($line =~ /^(\s*)(.*)=~\ss\/(.*)\/(.*[^g]*)\/[g\s;]*$/){
			$line = $1.$2."= re.sub(r'$3','$4',$2)";
		}
		
		# line containing addition/subtraction etc
		# convert to int just in case $var = "3"
		# $sum = $a+$b;
		elsif ($line =~ /^(.+\=\s*)(.+[^\\])[\+|\-|\*|\/](.+)$/){
			$convert = "int";
			
			# convert equation to int 
			if ($line =~ /^(.*[=]+)([^\\]+)([\+\-\*\/])(.+)$/){
				$line = $1.$convert."($2)".$3.$convert."($4)";
			}
			
			# if its divison change to \\ for int 
			$line =~ s/\//\/\//;
		}
		
		#join
		if ($line =~ /^(\s*print\s*).*\"join\((.*),\s*(.*)\)\"\)/){
			$line = "$1\($2.$3\)";
		
		}

		
		push(@code, "$line\n");
	# ============== SUBSET 4 ==============
	# <>
	# . and .=
	# variable interpolation
	# simple uses of printf (requiring % in python)
	# arrays \\and hashes
	# push, pop, shift, unshift, reverse
	# simple use of regexes (// and s///)
	# ======================================
	# <>
	
	
	# ============== SUBSET 5 ==============
	# anonymous variable ($_)
	# open
	# functions
	# more complex uses of features from subsets 1-4
	# self-application (translating itself to python)
	# You may suggest in the forum other features to 
	# be added to the list for subset 5. 
	# Some features in subset 5 present great 
	# difficulties to translation. 
	# Perfect handling of these will not be required
	# for full marks.
	# ======================================		
		
	} else {
        # Lines we can't translate are turned into comments
		#print "#$line\n";
		push(@code, "#$line\n");
	}
	
	# GO THROUGH CODE TO CHANGE * to +
}

# EXTRA FUNCTIONS
# change ARGV 
sub argv{
	$line = $line;
	# if imports doesnt already have import sys
	if(exists($imports{"import sys\n"})) { 
	}else{
		push(@imports, "import sys\n");
	}
	return $line = "$1join(sys.argv[1:])$2";
}

sub arg{
	if ($line =~ /(.*)ARGV\[(.*)\](.*)/){
	return $line = "$1sys.argv[$2+1]$3";
	}
	
}

# lines containing $
sub var{
	# while line contains unescaped dollar sign
	# not sure if works
	while ($line =~ /.*[^\\]\$.*/) {
	
		$line =~ s/\$//g;
		#$line =~ s/^.*;\s*$//g;
		# isn't effective if "" is part of the string
		# whenever i change below, it fails tests
		$line =~ s/"//g;
			
	}
	# while line contains unescaped @
	# not sure if works
	$line =~ s/^\@//g;
	while ($line =~ /^(.*[^\\])\@(.*)$/) {

		$line = $1.$2;
		#$line =~ s/^.*;\s*@//g;
		# isn't effective if "" is part of the string
		# whenever i change below, it fails tests
		#$line =~ s/"//g;
			
	}
	return $line		
}



# lines containing 
sub hash{
		
}

sub logical{
	# logical operators
	# and &&
	
	if ($line =~ /^(.*[^][^"])\&\&([^"][^&].*)$/){
		$line = $1."and".$2;
	}	
	# or ||
	if ($line =~ /^(.*[^|][^"])\|\|([^"][^|].*)$/){
		$line = $1."or".$2;
	}
	# not !
	if ($line =~ /^(.*[^!][^"])\!([^"=][^!].*)$/){
		$line = $1."not".$2;
	}

	return $line;
}

sub conditional{
$line = $1.$2;
	if ($line =~ /.*[^\\]\$.*/ || $line =~ /^\$.*/) {
		# doesnt work when i use the function?
		while ($line =~ /(.*[^\\])\$(.*)/) {
		$line = $1.$2;
			}
	}

		
		
		
	# CONTAINS unescaped ARGV FOR SOME REASON IT DOESNT WORK HERE
	#if ($line =~ /^(.*[^\\])\@ARGV(.*)$/){
	#	$line = argv($line);
	#}	
	# CONTAINS unescaped ARGV
	if ($line =~ /^(.*[^\\])\@ARGV(.*)$/){
			#$line = argv($line);
		if(exists($imports{"import sys\n"})) { 
		}else{
			push(@imports, "import sys\n");
		}
		$line = "$1sys.argv[1:]$2";
	}
	while ($line =~ /^(.*[^\\])\@([^@]*.*)$/) {
		$line = $1.$2;
	}
		
	# IF  - can leave alone (I THINK??)
		
		
		
	# ELSIF -> ELIF
	# starting with bracket
	if ($line =~ /^}.*elsif(.*)$/){
		$line = "elif$1";
	# not starting with bracket
	} elsif ($line =~ /^(\s*)elsif(.*)$/){
		$line = "$1elif$2";
	}
	
		
	# WHILE -can leave alone (I THINK??)
		
		

	# FOREACH foreach arg sys.argv[1:]
	if ($line =~ /^(\s*)foreach(.*)[\s]+(.*)$/){
		$line = "for$1$2 in $3";
	}
	
	# FOR - for $i (0..9){
	elsif ($line =~ /^(\s*)for(.*)[\s]+(.*)$/){
		$line = "for $1$2 in $3";
	}
		
		
	# comparison operators 
	# == 
	# $line eq "cookie"
	if ($line =~ /(^.*\s*)eq(\s*.*)$/){
		$line = "$1==$2";
	}
	
	# .. ie range stuff
	#foreach $i (0..4) 
	#for i in range(0, 5):
	if ($line =~ /^(.*)(\d+)\.\.(\d+|#ARGV)/){
		if ($line =~ /^(.*)(\d+)\.\.(\d+)/){
			$num = $3+1;
			$line = "$1range($2, $num)";
		} elsif ($line =~ /^(.*)(\d+)\.\.(#ARGV)/){
			$num = 1;
			$line = "$1range(len(sys.argv)\-"."$num)";
			if(exists($imports{"import sys\n"})) { 
			}else{
				push(@imports, "import sys\n");
			}
		}
		
		
	}
		
	# change logical operators
	$line = logical($line);
	# bitwise and comparison doesn't need to be changed i think
		
	return $line;
}


foreach $line (@imports) {
  print "$line";
}


foreach $line (@code) {
  print "$line";
}