This is my solution to the Engineering Challenge located here:

https://github.com/peck/engineering-assessment

This code is running out of my house here:

http://c-24-4-182-109.hsd1.ca.comcast.net/cgi-bin/engineering-assessment.pl

This now uses the endpoint provided in the assignment.

It is no longer using a local .csv file.

If for whatever reason the link above doesn't work, it's simple to get running locally with these steps:

	1.) First, have a local webserver (running under a VM or container is fine).
	2.) Put 'engineering-assessment.pl' in the place where cgi scripts run.
	3.) Go to http://<whatever-the-domain-is>/cgi-bin/engineering-assessment.pl

NOTE: You may have to adjust the path of the $CSV_FILE variable to one that exists and is writable by the webserver. If you're running apache2 with Ubuntu and are using the stock ubuntu package repository then you most likely won't have to change this.

This used to have a splash html page that is now deprecated because I changed it. I changed it because the list of food items to select from is now a pulldown menu that is now dynamically generated in the PERL script instead of being a free form text area in the static HTML.

The way I designed this is a little flawed only because I know this is only going to be used to demonstrate my skills.  However, if this were the real thing I'd have to make sure 1.) it dies correctly, and 2.) it's super secure.

When I say it needs to 'die correctly', I mean give a user friendly error message on the browser without giving too much information to potential mallicious hackers. For example, it's getting data from an endpoint.  But if that endpoint were not available for some reason, the script is going to die with a user 'unfriendly' message about an 'Internal Server Error' or some such message. To the average user, this is useless because they have no idea what happened and that they should try again later.  To the mallicious hacker however, they now know that I'm running Apache/2.4.52 (Ubuntu) Server at c-24-4-182-109.hsd1.ca.comcast.net Port 80 (because that's part of the unfriendly error message). This brings me to my second point, that if Apache/2.4.52 is vulnerable to some expoit on port 80 that this hacker knows about, this could potentially be a very bad thing. So error checking and data validation and taint checking are all serious things to worry about when this is live production.

Another flawed thing is that the list of food items isn't exactly 100% correct but this is difficult because the list under 'FoodItems' in the .csv do not follow a standard format (the delimiters are not always the same, etc.).  So I have to do the best I can with regex to account for all the possible ways we can separate out the different food items into a list. If this were a real production environment I could either try to standardize the source if at all possible, and if not then reformat the incoming data so that things are more "sane".  The latter could be tricky because the data we get from the endpoint is going to change from time to time.
