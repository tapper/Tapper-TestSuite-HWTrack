#!/usr/bin/env perl

use warnings;
use strict;

use Test::More tests => 4;

BEGIN {use_ok('TestSuite::HWTrack');}

my $track = TestSuite::HWTrack->new();
isa_ok($track, 'TestSuite::HWTrack');

$track->install();
ok(-x $track->prep->dst."/src/lshw",'lshw installed');


$track->generate();
$track->send();
is(1,1,'Still alive');
