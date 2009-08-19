#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'TestSuite::HWTrack' );
}

diag( "Testing TestSuite::HWTrack $TestSuite::HWTrack::VERSION, Perl $], $^X" );
