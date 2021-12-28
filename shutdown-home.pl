#!/usr/bin/perl
use Net::SSH::Perl;

use warnings;
use strict;
use Data::Dumper;
my $listCmd = "esxcli vm process list";
my @hosts =("192.168.178.214","192.168.178.206");
foreach(@hosts){
	my $host = $_;
        my $list = ssh( $listCmd, $host );
	my @id = $list =~ /World ID: ([a-z0-9-]+)/g ;
	print Dumper @id;
	print $host;
	foreach(@id){
		`echo "esxcli vm process kill –t=soft –w=$_"`;
		my $result = ssh("esxcli vm process kill –t=soft –w=$_", $host);
		print $result;
		}
	}



sub ssh{
	my $hostname = $_[1];
	my $cmd = $_[0];
	my $ssh = Net::SSH::Perl->new("$hostname", debug=>0);
	$ssh->login("root");
	my ($stdout,$stderr,$exit) = $ssh->cmd("$cmd");
	return $stdout;
	}
