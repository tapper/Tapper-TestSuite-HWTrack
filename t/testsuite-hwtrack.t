#!/usr/bin/env perl
use 5.010;

use warnings;
use strict;

use Test::More tests => 6;
use Artemis::Config;
use TAP::DOM;
use Data::DPath 'dpath';


BEGIN {use_ok('TestSuite::HWTrack');}

my $track = TestSuite::HWTrack->new();
isa_ok($track, 'TestSuite::HWTrack');

$track->install();
ok(-x $track->prep->dst."/src/lshw",'lshw installed');


$track->generate();


my $server = IO::Socket::INET->new(Listen    => 5);
ok($server, 'create socket');

$ENV{ARTEMIS_TESTRUN}       = 10;
$ENV{ARTEMIS_REPORT_SERVER} = 'localhost';
$ENV{ARTEMIS_REPORT_PORT}   = $server->sockport;

my $retval;
my $pid=fork();
if ($pid==0) {
        $server->close();
        sleep(2); #bad and ugly to prevent race condition
        $retval = $track->send();
        # Can't make this a test since the test counter istn't handled correctly after fork
        die $retval if $retval;
        exit 0;
} else {
        my $content;
        eval{
                $SIG{ALRM}=sub{die("timeout of 5 seconds reached while waiting for file upload test.");};
                alarm(5);
                my $msg_sock = $server->accept();
                while (my $line=<$msg_sock>) {
                        $content.=$line;
                }
                alarm(0);
        };
        is($@, '', 'Getting report from hwtrack');

        my $dom = TAP::DOM->new(tap => $content);
        my $res = $dom ~~ dpath '//description[value ~~ /Getting hardware information/]/../_children//data/capabilities';
        ok(scalar @$res, 'File content from upload');
        waitpid($pid,0);
}

