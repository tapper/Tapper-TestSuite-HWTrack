#!/usr/bin/env perl
use 5.010;

use warnings;
use strict;

use Log::Log4perl;

my $string = "
log4perl.rootLogger           = INFO, root
log4perl.appender.root        = Log::Log4perl::Appender::Screen
log4perl.appender.root.stderr = 1
log4perl.appender.root.layout = SimpleLayout";
Log::Log4perl->init(\$string);

use Test::More;
use Artemis::Config;
use TAP::DOM;
use Data::DPath 'dpath';


BEGIN {use_ok('TestSuite::HWTrack');}
$ENV{ARTEMIS_TESTRUN}       = 10;
$ENV{ARTEMIS_HOSTNAME}      = 'foobarhost';

my $track = TestSuite::HWTrack->new();
isa_ok($track, 'TestSuite::HWTrack');

$track->install();
ok(-x $track->prep->dst."/src/lshw",'lshw installed');


my $report = $track->generate();


my $server = IO::Socket::INET->new(Listen    => 5);
ok($server, 'create socket');
$ENV{ARTEMIS_REPORT_SERVER} = 'localhost';
$ENV{ARTEMIS_REPORT_PORT}   = $server->sockport;


my $retval;
my $pid=fork();
if ($pid==0) {
        $server->close();
        sleep(2); #bad and ugly to prevent race condition
        $retval = $track->send($report);
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
        $res = $dom ~~ dpath '//as_string[value =~ /Artemis-Machine-Name/]';
        {
                is(scalar @$res, 1, 'One entry contains machine name');
                last if not ref $res eq 'ARRAY';
                is($res->[0], "# Artemis-Machine-Name: $ENV{ARTEMIS_HOSTNAME}", 'File content from upload');
        }
        waitpid($pid,0);
}

done_testing();
