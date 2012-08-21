#!/usr/bin/perl
# This is a sample code to create a new conference.
# See Cisco API reference for detail.

use strict;
use warnings;
use RPC::XML::Client;
use DateTime;
use Data::Dumper;


# conference.create
#   authenticationUser
#   authenticationPassword
#   conferenceName
#   startTime
#   durationSeconds
sub conference_create {
    return 
	('conference.create',
	 {
	     'authenticationUser'     => RPC::XML::string->new($_[0]), 
	     'authenticationPassword' => RPC::XML::string->new($_[1]),
	     'conferenceName'         => RPC::XML::string->new($_[2]),
	     'startTime'              => RPC::XML::datetime_iso8601->new($_[3]),
	     'durationSeconds'        => RPC::XML::int->new($_[4])
	 }
	);
}

my $client = RPC::XML::Client->new('http://your_mcu/RPC2');

# The conference starts in one hour and will last one hour (= 3600s).
my $dt = DateTime->from_epoch(epoch => (time + 3600), time_zone => 'Asia/Tokyo');
my $req = RPC::XML::request->new(
	 conference_create('admin', 'TANDBERG', 'My Conference', $dt->iso8601(), 3600)
       );

# If you want to see the body of POST request, uncomment the lines below.
#my $str =  $req->as_string . "\n";
#$str =~ s/(\/[^>]+>)/$1\n/g;  # Adding newlines, make it easier to see.
#print $str;

my $res = $client->send_request($req);

if (ref $res) {
  foreach my $key (keys %{$res->value}) {
    print "$key = ${$res->value}{$key}\n";
  }
}
else {
  print "ERROR: $res\n";
}
