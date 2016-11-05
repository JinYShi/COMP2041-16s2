#!/usr/bin/env python3.5

# written by andrewt@cse.unsw.edu.au September 2016
# as a starting point for COMP2041/9041 assignment 2
# http://cgi.cse.unsw.edu.au/~cs2041/assignments/matelook/

import cgi, cgitb, glob, os, re, sys, codecs


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
    # initialise HTML string to return
    HTML = ""
    user_image =""
    
    # login (ITD BE BETTER IF I SEPARATED 
    # AND MADE THE USER PAGE
    # ITS OWN FUNC BUT THATS OK)
    
    # Search for users
    # Search for post
    n = 0
    # if username and password has been entered
    if ('username_input' in parameters) and ('password_input' in parameters):
        username = parameters.getvalue('username_input')
        user_password = parameters.getvalue('password_input')
        if (verify_login(username, user_password, users_dir)):
            user_to_show = users_dir+"/"+username
            user_filename = os.path.join(user_to_show, "user.txt")
            user_image = os.path.join(user_to_show, "profile.jpg")
        else:
            return """
    <p class="login_error">Incorrect Login Details - Try Again.</p>
    <form method="POST" action="" class="matelook_login">
    <input type="textbox" name="username_input" placeholder="Username">
	<input type="password" placeholder="Password" name="password_input">
	<input type="submit" value="Login" class="login_button" name="login_button">
    </form>
    """
    # commented out login for debugging purposes
    #elif ('username_input' not in parameters) and ('password_input' not in parameters):
    #    loginHTML = login()
    #    return loginHTML
    # returning search results
    elif 'search_string' in parameters:
        HTML = page_header()
        search = parameters.getvalue('search_string')
        search_string = search[0]
        results = search_results(users_dir, search_string)
        return results
    # display the correct user
    elif 'user' in parameters:
        user_image = ""
        user_to_show = parameters.getvalue('user')
        user_to_show = users_dir+"/"+user_to_show
        user_filename = user_to_show+"/user.txt"
        user_image = user_to_show+"/profile.jpg"
        # if image exists, otherwise display anonymous one
        if os.path.isfile(user_image):
            user_image = user_to_show+"/profile.jpg"
            # ?? make default image
        else:
            user_image = "anonymous.jpg"
    else:
        user_image = ""
        n = int(parameters.getvalue('n', 0))
        users = sorted(glob.glob(os.path.join(users_dir, "*")))
        user_to_show  = users[n % len(users)]
        user_filename = user_to_show+"/user.txt"
        #user_filename = os.path.join(users_dir, "%s/user.txt")%(user_to_show)
        user_image = user_to_show+"/profile.jpg"
        # if image exists, otherwise display anonymous one
        if os.path.isfile(user_image):
            user_image = user_to_show+"/profile.jpg"
        else:
            # ?? make default image
            user_image = "anonymous.jpg"
    
    with open(user_filename) as f:
        # ?? don't display private information
        home_suburb=""
        # read file
        for line in f: 
            # ?? full name
            if "full_name" in line:
                full_name = line
                full_name = re.sub(r'^.*=', "", full_name)
            # password
            if "password" in line:
                password = line
                password = re.sub(r'^.*=', "", password)
            # zID
            if "zid" in line:
                zID = line
                zID = re.sub(r'^.*=', "", zID)
            # birthday
            if "birthday" in line:
                birthday = line
                birthday = re.sub(r'^.*=', "", birthday)
            # home longitude
            if "home_longitude" in line:
                home_longitude = line
                home_longitude = re.sub(r'^.*=', "", home_longitude)
            # home latitude
            if "home_latitude" in line:
                home_latitude = line
                home_latitude = re.sub(r'^.*=', "", home_latitude)
            # home suburb
            if "home_suburb" in line:
                home_suburb = line
                home_suburb = re.sub(r'^.*=', "", home_suburb)
            # email
            if "email" in line:
                email = line
                email = re.sub(r'^.*=', "", email)
            # program
            if "program" in line:
                program = line    
                program = re.sub(r'^.*=', "", program)
            # courses
            if "courses" in line:
                courses = line    
                courses = re.sub(r'^.*=', "", courses)    
            # mates
            if "mates" in line:
                mates = line
                mates = re.sub(r'^.*=', "", mates)
                mates = re.sub(r'^\[', "", mates)
                mates = re.sub(r'\]$', "", mates)
                mates = re.sub(r'\n', "", mates)
                mates = re.sub(r'\s', "", mates)
    # ?? display posts
    # call display posts
    posts = user_posts(users_dir, user_to_show)
    returnposts=""
    for post in posts:
        returnposts += """
<div class="matelook_post">
%s
</div>        
        """ %(post)
    
    # display mates
    returnmates = ""
    mates_info = mate_list(mates, users_dir)
    i = 0
    for mate, image in (mates_info.items()):
        i+=1
        name = convert_ID(mate, users_dir)
        returnmates += """
<div class="matelook_mate">
<a href="?user=%s" method="post">
<p>%s</p>
<img src="%s" width=100 height=100 class="mates_image">
</a>
</div>
    """ % (mate, name, image)
    # IDtoName(mate, users_dir) CONVERT TO NAME
    return """
<div class="matelook_user_details">
<div class="matelook_subheading">
profile
</div>
<img src="%s" width=200 height=200 border=0 alt="">
</br>
name: %s</br>
zID: %s</br>
birthday: %s</br>
location: %s</br>
</div>
<div class="matelook_mates">
<div class="matelook_subheading">
mates
</div>
%s
</div>
<div class="matelook_post_block">
<div class="matelook_subheading">
posts
</div>
%s</br>
</div>
<form method="POST" action="">
    <input type="hidden" name="n" value="%s">
    <input type="submit" value="Next user" class="matelook_button">
</form>
""" % (user_image, full_name, zID, birthday, home_suburb, returnmates, returnposts, n + 1)


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
<form method="post" action="">
<input type="textbox" placeholder="stalk!" name="search_string"> 
<input type="submit" value="Stalk a mate" name ="search_string" >
</form>
</br>
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

# Display users posts
def user_posts(users_dir, user_to_show):
    # go into post folder
    posts_folder = user_to_show+"/posts/"
    
    posts = []
    com = []
    
    # get pathname of every folder
    pathnames = os.listdir(posts_folder)
    # latest posts first
    pathnames.sort(reverse = True)
    # go through all paths
    for path in pathnames:
        current_folder = posts_folder+path
        current_post = current_folder+"/post.txt"
        with open(current_post,'r',encoding='utf-8') as f:
            
            # read file
            for line in f: 
                returncomments = ""
                latitude=""
                longitude=""
                # open and read post.txt
                if "message=" in line:
                    message = line
                    message = re.sub(r'^.*=', "", message)  
                    message = re.sub(r'\\n', "</br>", message)
                    # replace non character with z with space and non character or z
                    message = re.sub(r',', " , ", message)  
                    message = re.sub(r'\?', " ? ", message)  
                    message = re.sub(r'\.', " . ", message)
                    # just in case zIDs are next to each other
                    message = re.sub(r'z', " z", message)
                    words = re.split (r'\s',message)
                    message = ""
                    for word in words: 
                        match = re.match(r'z[0-9]{7}', word)
                        if match:
                            
                            zID = word
                            name = convert_ID(zID, users_dir)
                            name = """
<a href="?user=%s" method="post">
%s</a>                      """%(zID,name)
                            word = name
                        message += word+" "
                    # replace non character or z with space with non character or z
                    message = re.sub(r' , ', ",", message)  
                    message = re.sub(r' \? ', "?", message)  
                    message = re.sub(r' \. ', ".", message)
                    message = re.sub(r' z ', "z ", message)
                if "latitude=" in line:
                    latitude = line
                    latitude = re.sub(r'^.*=', "", latitude)  
                if "longitude=" in line:
                    longitude = line
                    longitude = re.sub(r'^.*=', "", longitude)  
                if "time=" in line:
                    date_and_time = line
                    date_and_time = re.sub(r'^.*=', "", date_and_time)  
                    date = re.sub(r'T.*$', "", date_and_time)  
                    time = re.sub(r'^.*T', "", date_and_time)  
                    time = re.sub(r'\+.*', "", time) 
                    date_and_time = "date: "+date+" - time: "+time 
                if "from=" in line:
                    from_user = line
                    from_user = re.sub(r'^.*=', "", from_user)  
            
            # call post_comments to display the comments
            comments = post_comments(current_folder,users_dir)
            # add post to array or string
            post_details = """
%s </br>
%s </br>
%s
            """ %(message,date_and_time,comments)
            posts.append(post_details)
        
    return posts

# Display comments on users posts
def post_comments(current_folder,users_dir):
    comments_folder = current_folder+"/comments"
    # if comments exists
    if (os.path.isdir(comments_folder)):
        # get pathname of every folder
        pathnames = os.listdir(comments_folder)
    # otherwise return
    else:
        return
    # earliest comments first
    pathnames.sort()
    #return pathnames
    comments = []
    # while post.txt exists
    for path in pathnames:
        comment_details = ""
        current_comment_path = current_folder+"/comments/"+path
        current_comment = current_comment_path+"/comment.txt"
        with open(current_comment,'r',encoding='utf-8') as f:
            latitude=""
            longitude=""
            for line in f:
            # open and read post.txt
                if "message=" in line:
                    message = line
                    message = re.sub(r'^.*=', "", message)  
                    message = re.sub(r'\\n', "</br>", message)
                    # replace non character with z with space and non character or z
                    message = re.sub(r',', " , ", message)  
                    message = re.sub(r'\?', " ? ", message)  
                    message = re.sub(r'\.', " . ", message)
                    message = re.sub(r'z', " z", message)
                    message = re.sub(r'!', " ! ", message)
                    message = re.sub(r'</br>', " </br> ", message)  
                    words = re.split (r'\s',message)
                    message = ""
                    for word in words: 
                        match = re.match(r'^z[0-9]{7}$', word)
                        if match:
                            
                            zID = word
                            name = convert_ID(zID, users_dir)
                            name = """
<a href="?user=%s" method="post">
%s</a>                      """%(zID,name)
                            word = name
                        message += word+" "
                    # replace non character or z with space with non character or z
                    message = re.sub(r' , ', ",", message)  
                    message = re.sub(r' \? ', "?", message)  
                    message = re.sub(r' \. ', ".", message)
                    message = re.sub(r' ! ', "!", message)
                    message = re.sub(r' z ', "z ", message)
                if "latitude=" in line:
                    latitude = line
                    latitude = re.sub(r'^.*=', "", latitude)  
                if "longitude=" in line:
                    longitude = line
                    longitude = re.sub(r'^.*=', "", longitude)  
                if "time=" in line:
                    date_and_time = line
                    date_and_time = re.sub(r'^.*=', "", date_and_time)  
                    date = re.sub(r'T.*$', "", date_and_time)  
                    time = re.sub(r'^.*T', "", date_and_time) 
                    time = re.sub(r'\+.*', "", time) 
                    date_and_time = "date: "+date+" - time: "+time
                if "from=" in line:
                    from_user = line
                    from_user = re.sub(r'^.*=', "", from_user)  
                    zID = re.sub(r'\n', "",  from_user)  
                    from_user = convert_ID(zID,users_dir)
                    from_user = """
<a href="?user=%s" method="post">
%s</a>              """%(zID,from_user)
        comment_comment = comment_comments(current_comment_path, users_dir)
            
        comment_details += """
<div class="matelook_comment">        
%s </br>
%s </br>
from: %s </br> 
comments:
%s
</div>
        """ %(message,date_and_time,from_user, comment_comment)
        comments.append(comment_details)
    comment_html =""
    for comment in comments:
        comment_html += comment
    return comment_html
# COmments on comments
def comment_comments(comment_dir, users_dir):

    comments_folder = comment_dir+"/replies"
    #return comments_folder
    # if comments exists
    if (os.path.isdir(comments_folder)):
        # get pathname of every folder
        pathnames = os.listdir(comments_folder)
    # otherwise return
    else:
        return
    # earliest comments first
    pathnames.sort()
    comments = []
    # while post.txt exists
    for path in pathnames:
        comment_details = ""
        current_comment = comments_folder+"/"+path+"/reply.txt"
        with open(current_comment,'r',encoding='utf-8') as f:
            latitude=""
            longitude=""
            message = ""
            for line in f:
            # open and read post.txt
                if "message=" in line:
                    message = line
                    message = re.sub(r'^.*=', "", message)  
                    message = re.sub(r'\\n', "</br>", message)
                    # replace non character with z with space and non character or z
                    message = re.sub(r',', " , ", message)  
                    message = re.sub(r'\?', " ? ", message)  
                    message = re.sub(r'\.', " . ", message)
                    message = re.sub(r'z', " z", message)
                    message = re.sub(r'</br>', " </br> ", message)  
                    words = re.split (r'\s',message)
                    message = ""
                    for word in words: 
                        match = re.match(r'^z[0-9]{7}$', word)
                        if match:
                            
                            zID = word
                            name = convert_ID(zID, users_dir)
                            name = """
<a href="?user=%s" method="post">
%s</a>                      """%(zID,name)
                            word = name
                        message += word+" "
                    # replace non character or z with space with non character or z
                    message = re.sub(r' , ', ",", message)  
                    message = re.sub(r' \? ', "?", message)  
                    message = re.sub(r' \. ', ".", message)
                    message = re.sub(r' z ', "z ", message)
                if "latitude=" in line:
                    latitude = line
                    latitude = re.sub(r'^.*=', "", latitude)  
                if "longitude=" in line:
                    longitude = line
                    longitude = re.sub(r'^.*=', "", longitude)  
                if "time=" in line:
                    date_and_time = line
                    date_and_time = re.sub(r'^.*=', "", date_and_time)  
                    date = re.sub(r'T.*$', "", date_and_time)  
                    time = re.sub(r'^.*T', "", date_and_time) 
                    time = re.sub(r'\+.*', "", time) 
                    date_and_time = "date: "+date+" - time: "+time
                if "from=" in line:
                    from_user = line
                    from_user = re.sub(r'^.*=', "", from_user)  
                    zID = re.sub(r'\n', "",  from_user)  
                    from_user = convert_ID(zID,users_dir)
                    from_user = """
<a href="?user=%s" method="post">
%s</a>              """%(zID,from_user)
            
        comment_details += """
<div class="matelook_comment_comment">        
%s </br>
%s </br>
from: %s
</div>
        """ %(message,date_and_time,from_user)
        comments.append(comment_details)
    comment_comment_html =""
    for comment in comments:
        comment_comment_html += comment
    return comment_comment_html
# LEVEL 1: Mate List   
# List of the names of that user's mates should be displayed.
# list should include a thumbnail image of the mate (if they have a profile image).
# Clicking on the image and/or name should take you to that matelook page.
def mate_list(mates, users_dir):
    # split into list of mates
    list = re.split(r',',mates)     
    # initialise array of images
    mate_images = []
    # initialise dictionary
    mateDetails = {} 
    # for each zID in the list
    for mate in list:
        # default image
        default_image = os.path.join("", "anonymous.jpg")
        mate_image = os.path.join(users_dir, "%s/profile.jpg")%(mate)
        # if the image exists for zID
        if os.path.isfile(mate_image):
            # add to array of images
            mate_images.append(mate_image)
        else:
            # add default to array of images
            mate_images.append(default_image)     
    # initialise counter
    i = 0
    while (i<len(list)):
        # set each image to the zID
        # keep in dictionary mateDetails
        mateDetails[list[i]] = mate_images[i]
        i+=1    
    return mateDetails

# Converts zID to name and link 
def convert_ID(zID, users_dir):
    user_filename = os.path.join(users_dir, "%s/user.txt") %(zID)
    # read file to get the name
    with open(user_filename) as f:       
        # read file
        for line in f: 
            # ?? full name
            if "full_name" in line:
                full_name = line
                full_name = re.sub(r'^.*=', "", full_name)
# LEVEL 1: Search for Names 
    return full_name
# Searching for a user whose name containing a specified substring. 
# Search results should include the matching name and a thumbnail image.
# Clicking on the image and/or name should take you to that matelook page.    



# search() does the actual search
def search_results(users_dir,search):

    # get pathname of every folder
    pathnames = os.listdir(users_dir)
    resultsHTML = ""
    user_file=""
    boolean = 0
    
    # match zID
    for path in pathnames: 
        if (str(search) == str(path)):
            boolean = 1
            user_to_show = search
            user_path = users_dir+"/"+user_to_show
            user_file = user_path+"/user.txt"
            user_image = user_path+"/profile.jpg"
            #return user_image
            # if image exists, otherwise display anonymous one
            if os.path.isfile(user_image):
                user_image = user_path+"/profile.jpg"
                # ?? make default image
            else:
                user_image = "anonymous.jpg"
            with open(user_file) as f:
                # ?? don't display private information
                # read file
                for line in f: 
                    # ?? full name
                    if "full_name" in line:
                        full_name = line
                        full_name = re.sub(r'^.*=', "", full_name)
            resultsHTML += """
        <div class="matelook_mate">
        <a href="?user=%s" method="post">
        <p>%s</p>
        <img src="%s" width=100 height=100 >
        </a>
        </div>
            """ % (user_to_show, full_name, user_image) 
    # match name CASE INSENSITIVE
    for path in pathnames: 
        user_path = users_dir+"/"+path
        user_file = user_path+"/user.txt"
        user_image = user_path+"/profile.jpg"
        user_to_show = path
        # open file
        with open(user_file) as f:
            for line in f: 
                if "full_name" in line:
                    boolean = 1
                    full_name = line
                    full_name = re.sub(r'^.*=', "", full_name)
                    # if name contains string
                    if search.lower() in full_name.lower():
                        if os.path.isfile(user_image):
                            user_image = user_path+"/profile.jpg"
                        # ?? make default image
                        else:
                            user_image = "anonymous.jpg"
                        resultsHTML += """
                    <div class="matelook_mate">
                    <a href="?user=%s" method="post">
                    <p>%s</p>
                    <img src="%s" width=100 height=100 >
                    </a>
                    </div>
                        """ % (user_to_show, full_name, user_image) 

    
    
    #if no match
    if (boolean == 0):
        
        resultsHTML = "No Search Results"  
        return resultsHTML
    
    
    # name
    return resultsHTML
    
def login():
    return """
<form method="POST" action="" class="matelook_login">
    <input type="textbox" placeholder="Username" name="username_input">
    <input type="password" placeholder="Password" name="password_input">
    <input type="submit" value="Login" class="login_button" name="login_button">
</form>
    """

# checks if login is correct
#password=debbie
#zid=z3275760
def verify_login(zID, user_password, users_dir):
	file_path = users_dir+"/"+zID+"/user.txt"
	temp = ""

	if (os.path.isfile(file_path)):
		with open(file_path) as f:
			for line in f:
				if (re.compile("password").match(line)):
					password = re.sub(r'^password=', '', line).rstrip()
		if(password==user_password):
			return True
	else:
		return False

    
# MAIN - KEEP THIS AT THE BOTTOM OTHERWISE STUFF BREAKS
if __name__ == '__main__':
    debug = 1
    sys.stdout = codecs.getwriter('utf8')(sys.stdout.buffer)
    main()
