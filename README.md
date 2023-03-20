This is my solution to the Engineering Challenge located here:

https://github.com/peck/engineering-assessment

This code is running out of my house here:

http://c-24-4-182-109.hsd1.ca.comcast.net/cgi-bin/engineering-assessment.pl

This now uses the endpoint provided in the assignment.

It is no longer using a local .csv file.

If for whatever reason the link above doesn't work, it's simple to get running locally with these steps:

	1.) First, have a local webserver running under a VM or container, etc.
	2.) Put 'engineering-assessment.pl' in the place where cgi scripts run.
	3.) Go to http://<whatever-the-domain-is>/cgi-bin/engineering-assessment.pl

NOTE: You may have to adjust the path of the $CSV_FILE variable to one that exists and is writable by the webserver. If you're running apache2 with Ubuntu and are using the stock ubuntu package repository then you most likely won't have to change this.

This used to have a splash html page that is now deprecated because I changed it. I changed it because the list of food items to select from is now a pulldown menu that is now dynamically generated in the PERL script instead of being a free form text area in the static HTML.
