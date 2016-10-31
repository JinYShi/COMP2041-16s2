
#!/bin/bash
character="$(echo $1 | head -c 1)"
undergrad=$(wget -q -O- "http://www.handbook.unsw.edu.au/vbook2016/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=$character") 
postgrad=$(wget -q -O- "http://www.handbook.unsw.edu.au/vbook2016/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=character") 
echo "$undergrad" "$postgrad" 
#|egrep $1|egrep -o "[A-Z]{4}[0-9]{4}</TD>|<A.*>.*</A>"| sed s/'<[^>]*>'//g
#| tr '\n' ' ' 
