#!/usr/bin/env perl

use File::Basename;
use LWP::UserAgent;
use Text::CSV qw( csv );
use Data::Dumper;
use CGI qw(:standard :cgi-lib);
use strict;
use warnings;

sub get_remote_csv($$) {
	my ($url, $file) = @_;
	my $ua = LWP::UserAgent->new(timeout => 10);
	my $response = $ua->get("$url");
	if ($response->is_success) {
		my @lines = split(/[\r\n]+/, $response->decoded_content);
		open(my $wh, '>', $file) or die "Cannot write '$file': $!";
		foreach my $line (@lines) {
			chomp($line);
			print {$wh} $line . "\n";
		}
		close($wh);
	} else {
		die $response->status_line;
	}
}

sub get_favorites($$) {
	my ($array_ref, $item) = @_;
	my @all_trucks = @{$array_ref};
	my @array = ();
	foreach my $truck_ref (@all_trucks) {
		my %truck_data = %{$truck_ref};
		if ($truck_data{'FoodItems'} =~ m/$item/i) {
			push(@array, $truck_ref);
		}
	}
	return(@array);
}

## Main

my $PARAMS = Vars();
my $URL = 'https://data.sfgov.org/api/views/rqzj-sfat/rows.csv';
my $FILENAME = basename($URL);
my $CSV_FILE = '/tmp/' . $FILENAME;

get_remote_csv($URL, $CSV_FILE);

my $AOH = csv (in => "$CSV_FILE", headers => "auto");
my $FOOD_ITEM = $$PARAMS{'food_item'};
my @TRUCK_LIST = get_favorites($AOH, $FOOD_ITEM);

print header();
print start_html('Engineering Challenge');
if (@TRUCK_LIST) {
	print "<P>Alright, I have the following list of places that serve '$FOOD_ITEM':</P>\n";
	print '<TABLE BORDER=1>' . "\n";
	print '<TR>' . "\n";
	print '<TH>Applicant</TH>' . "\n";
	print '<TH>FoodItems</TH>' . "\n";
	print '<TH>dayshours</TH>' . "\n";
	print '<TH>Address</TH>' . "\n";
	print '<TH>FacilityType</TH>' . "\n";
	print '</TR>' . "\n";
	foreach my $truck_data (@TRUCK_LIST) {
		print '<TR>' . "\n";
		print "<TD>$$truck_data{'Applicant'}</TD>\n";
		print "<TD>$$truck_data{'FoodItems'}</TD>\n";
		print "<TD>$$truck_data{'dayshours'}</TD>\n";
		print "<TD>$$truck_data{'Address'}</TD>\n";
		print "<TD>$$truck_data{'FacilityType'}</TD>\n";
		print '</TR>' . "\n";
	}
	print '</TABLE>' . "\n";
} else {
	print "<P>Sorry, I couldn't find a list of food trucks that serve '$FOOD_ITEM'.</P>\n";
}
print end_html();
