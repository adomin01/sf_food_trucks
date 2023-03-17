This is my solution to the Engineering Challenge located here:

https://github.com/peck/engineering-assessment

This code is actually live here:

http://c-24-4-182-109.hsd1.ca.comcast.net/engineering-assessment.html

This now uses the csv endpoint provided in the assignment.

It is no longer using a local .csv file.

If for whatever reason the link above doesn't work, it's simple to get running with these steps:

	1.) Transfer the files to a webserver (note: I wrote this on a linux machine with apache2, but it should work anywhere a cgi script can run).
	2.) Put 'engineering-assessment.pl' in a cgi directory.
	3.) Put 'engineering-assessment.html' wherever the webroot is.
	4.) If the cgi directory aliases to /cgi-bin/ in a browser, then this should already work.  If not then you either need to modify the <FORM> attribute in the html or modify the ScriptAlias directive in the apache configs (or whatever the equivalent of that is for your particular flavor of webserver)
