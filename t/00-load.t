#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Tapper::TestSuite::HWTrack' );
}

diag( "Testing Tapper::TestSuite::HWTrack $Tapper::TestSuite::HWTrack::VERSION, Perl $], $^X" );
