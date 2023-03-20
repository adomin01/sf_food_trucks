#!/usr/bin/env perl

use File::Basename;
use LWP::UserAgent;
use Text::CSV qw( csv );
use Data::Dumper;
use CGI qw(:standard :cgi-lib);
use strict;
use warnings;

sub get_food_options($) {
	my $array_ref = shift();
	my @aoh = @{$array_ref};
	my %hash = ();
	foreach my $data_ref (@aoh) {
		my %data = %{$data_ref};
		my $FoodItems = $data{'FoodItems'} || '';
		if ($FoodItems) {
			chomp($FoodItems);
			my @items = split(/\s*[:;\&]+\s*/, $FoodItems);
			foreach my $item (@items) {
				next if (length($item) > 30);
				my $lowercase = lc($item);
				$hash{$lowercase} = 1;
			}
		}
	}
	my @array = keys(%hash);
	return(@array);
}

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
	my ($array_ref, $wanted) = @_;
	my @all_trucks = @{$array_ref};
	my @array = ();
	foreach my $truck_ref (@all_trucks) {
		my %truck_data = %{$truck_ref};
		if ($truck_data{'FoodItems'} =~ m/$wanted/i) {
			push(@array, $truck_ref);
		}
	}
	return(@array);
}

sub display_found_trucks(\@$) {
	my ($array_ref, $food_wanted) = @_;
	my @truck_list = @{$array_ref};
		print "<P>Alright, I have the following list of places that serve '$food_wanted':</P>\n";
		print '<TABLE BORDER=1>' . "\n";
		print '<TR>' . "\n";
		print '<TH>Applicant</TH>' . "\n";
		print '<TH>FoodItems</TH>' . "\n";
		print '<TH>dayshours</TH>' . "\n";
		print '<TH>Address</TH>' . "\n";
		print '<TH>FacilityType</TH>' . "\n";
		print '</TR>' . "\n";
		foreach my $truck_data (@truck_list) {
			print '<TR>' . "\n";
			print "<TD>$$truck_data{'Applicant'}</TD>\n";
			print "<TD>$$truck_data{'FoodItems'}</TD>\n";
			print "<TD>$$truck_data{'dayshours'}</TD>\n";
			print "<TD>$$truck_data{'Address'}</TD>\n";
			print "<TD>$$truck_data{'FacilityType'}</TD>\n";
			print '</TR>' . "\n";
		}
		print '</TABLE>' . "\n";
}

sub display_spash_page(\@) {
	my $array_ref = shift();
	my @food_options = @{$array_ref};
	print '<P>Welcome to the Food Truck Finder.' . "\n";
	print 'Please select an item to find food trucks and carts in San Francisco that sell what you are hungry for.</P>' . "\n";
	print '<FORM ACTION="/cgi-bin/engineering-assessment.pl" METHOD="get">' . "\n";
	print "<LABEL FOR='food_wanted'>Food Item:</LABEL>\n";
	print '<SELECT NAME="food_wanted" ID="food_wanted">' . "\n";
	foreach my $option (@food_options) {
		print "\t<OPTION VALUE='$option'>$option</OPTION>\n";
	}
	print '</SELECT>' . "\n";
	print "<INPUT TYPE='submit' value='Submit'>\n";
	print '</FORM>' . "\n";
}

## Main

my $PARAMS = Vars();
my $URL = 'https://data.sfgov.org/api/views/rqzj-sfat/rows.csv';
my $FILENAME = basename($URL);
my $CSV_FILE = '/var/www/csv/' . $FILENAME;

get_remote_csv($URL, $CSV_FILE);

my $AOH = csv (in => "$CSV_FILE", headers => "auto");

print header();
print start_html('Engineering Challenge');
print '<H1>Food Truck Finder</H1>' . "\n";
print '<HR NOSHADE />' . "\n";
if (exists($$PARAMS{'food_wanted'})) {
	my $FOOD_WANTED = $$PARAMS{'food_wanted'};
	my @FOUND_LIST = get_favorites($AOH, $FOOD_WANTED);
	if (@FOUND_LIST) {
		display_found_trucks(@FOUND_LIST, $FOOD_WANTED);
	} else {
		print "<P>Sorry, I couldn't find a list of food trucks that serve '$FOOD_WANTED'.</P>\n";
	}
} else {
	my @FOOD_OPTIONS = get_food_options($AOH);
	display_spash_page(@FOOD_OPTIONS);
}
print end_html();
