This is my solution to the Engineering Challenge located here:

https://github.com/peck/engineering-assessment

This code is no longer running out of my house; instead it's running from AWS.

http://ec2-44-201-176-26.compute-1.amazonaws.com/cgi-bin/engineering-assessment.pl

This now uses the endpoint provided in the assignment.

It is no longer using a local .csv file.

I'm just going to list the steps to create this in AWS since I just moved it there:

	1.) Log into 'https://aws.amazon.com/' and Leave 'New EC2 Experience' on.
	2.) Click on 'Services' at the top, to the left of the search bar.
	3.) Navigate to 'Compute -> EC2' and Click the 'Launch Instance' pulldown.
	4.) Select 'Launch Instance' and type a webserver name in the 'Name' textarea.
	5.) Select ubuntu under 'Application and OS Images'.
	6.) Click 'Create new key pair' and create a new ssh key.
	7.) Select 'Custom' under 'Allow SSH traffic from'
	8.) Type in your router's public IP under 'Custom'.
	9.) Check 'Allow HTTPS traffic' and 'Allow HTTP traffic'.
	10.) Use the AWS instructions on how to get to a shell prompt on your instance.
	11.) Install apache2 with 'sudo apt-get --assume-yes install apache2'.
	12.) cd /etc/apache2/mods-enabled; sudo ln -s ../mods-available/cgi.load
	12.) apt-get --assume-yes install liblwp-protocol-https-perl libcgi-pm-perl
	13.) Restart the apache service with 'sudo service apache2 restart'.
	14.) Create a 'csv' dir: mkdir /var/www/csv; chown www-data:www-data /var/www/csv
	15.) Now navigate to the page via browser and select your favorite food:

http://ec2-44-201-176-26.compute-1.amazonaws.com/cgi-bin/engineering-assessment.pl

If it doesn't work then look at '/var/log/apache2/error.log' and fix it.
