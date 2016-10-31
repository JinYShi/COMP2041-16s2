#!/usr/bin/env python3.5

# written by andrewt@cse.unsw.edu.au September 2016
# as a starting point for COMP2041/9041 assignment 2
# http://cgi.cse.unsw.edu.au/~cs2041/assignments/matelook/

import cgi, cgitb, glob, os

def main():
    print(page_header())
    cgitb.enable()
    users_dir = "dataset-medium"
    parameters = cgi.FieldStorage()
    print(user_page(parameters, users_dir))
    print(page_trailer(parameters))
	

# == DONE
# >> NOT DONE
# ?? NOT SURE or FILL IN LATER or ATTEMPTED

# LEVEL 0: Display User Information & Posts 
# == The starting-point script - displays user information in raw form and does not display their image or posts.
# >> Should display user information in nicely formatted HTML with appropriate accompanying text.
# >> Should display the user's image if there is one.
# >> Private information such e-mail, password, lat, long and courses should not be displayed.
# >> The user's posts should be displayed in reverse chronological order.

# LEVEL 0: Interface 
# generate nicely formatted convenient-to-use web pages including appropriate navigation facilities and instructions for naive users. 
# Although this is not a graphic design exercise you should produce pages with a common and somewhat distinctive look-and-feel. 
# You may find CSS useful for this.
# As part of your personal design you may change the name of the website to something other than matelook but the primary CGI script has to be matelook.cgi.

# Show unformatted user for user "n".
# Increment parameter n and store it as a hidden variable
#
def user_page(parameters, users_dir):
    n = int(parameters.getvalue('n', 0))
    users = sorted(glob.glob(os.path.join(users_dir, "*")))
    user_to_show  = users[n % len(users)]
    user_filename = os.path.join(user_to_show, "user.txt")
    # assuming all images are called profile.jpg
    user_image = os.path.join(user_to_show, "profile.jpg")
    if os.path.isfile(user_image):
          user_image = os.path.join(user_to_show, "profile.jpg")
    else:
        # ?? make default image
        user_image = "default.jpg"
    with open(user_filename) as f:
        user = f.read()
        # ?? don't display private information
        
    # ?? display posts
    
    return """
<div class="matelook_user_details">
<img src="%s" width=200 height=200 border=0 alt="">
%s
</div>
<p>
<form method="POST" action="">
    <input type="hidden" name="n" value="%s">
    <input type="submit" value="Next user" class="matelook_button">
</form>
""" % (user_image, user, n + 1)


#
# HTML placed at the top of every page
#
def page_header():
    return """Content-Type: text/html;charset=utf-8

<!DOCTYPE html>
<html lang="en">
<head>
<title>matelook</title>
<link href="matelook.css" rel="stylesheet">
</head>
<body>
<div class="matelook_heading">
matelook
</div>
"""


#
# HTML placed at the bottom of every page
# It includes all supplied parameter values as a HTML comment
# if global variable debug is set
#
def page_trailer(parameters):
    html = ""
    if debug:
        html += "".join("<!-- %s=%s -->\n" % (p, parameters.getvalue(p)) for p in parameters)
    html += "</body>\n</html>"
    return html

if __name__ == '__main__':
    debug = 1
    main()

# LEVEL 1: Search for Names 
# Searching for a user whose name containing a specified substring. 
# Search results should include the matching name and a thumbnail image.
# Clicking on the image and/or name should take you to that matelook page.    

# display_search() display the search bar on page
def display_search():
	return """
<form action="/cgi-bin/hello_get.py" method="get">
First Name: <input type="text" name="first_name">  <br />

Last Name: <input type="text" name="last_name" />
<input type="submit" value="Submit" />
</form>
"""

# search() does the actual search
def search():
	return
