use MooseX::Declare;
use 5.010;

class TestSuite::HWTrack::Execute {
        use File::Temp 'tempfile';
        use XML::Simple;
        use YAML;
        use IO::Socket::INET;

        has output => ( is => 'rw', default => sub { my $file; (undef, $file) = tempfile( CLEANUP => 1 ); return $file} );
        has dst    => ( is => 'rw');

        method generate() {
                my $lshw = $self->dst."/src/lshw";
                my $exec = "$lshw -xml > ".$self->output;
                system($exec); # can't use Artemis::Base->log_and_exec since
                               # this puts STDERR into the resulting XML file
                               # which in turn becomes invalid XML
        }

        method gen_report(HashRef $cfg) {
                my $xml  = XML::Simple->new(ForceArray => 1);
                my $data = $xml->XMLin($self->output);
                my $yaml = Dump($data);
                $yaml   .= "...\n";
                $yaml =~ s/^(.*)$/  $1/mg;  # indent
                my $report = sprintf("
TAP Version 13
1..2
# Artemis-Reportgroup-Testrun: %s
# Artemis-Suite-Name: HWTrack
# Artemis-Suite-Version: %s
ok 1 - Getting hardware information
%s
ok 2 - Sending
", $cfg->{test_run}, $TestSuite::HWTrack::VERSION, $yaml);
                return $report;
        }


        method send() {
                my $cfg;
                $cfg->{test_run}        = $ENV{ARTEMIS_TESTRUN};
                $cfg->{report_server}   = $ENV{ARTEMIS_REPORT_SERVER};
                $cfg->{report_api_port} = $ENV{ARTEMIS_REPORT_API_PORT} || 7358;
                $cfg->{report_port}     = $ENV{ARTEMIS_REPORT_PORT} || 7357;

                # following options are not yet used in this class
                $cfg->{mcp_server}      = $ENV{ARTEMIS_SERVER};
                $cfg->{runtime}         = $ENV{ARTEMIS_TS_RUNTIME};
                $cfg->{hostname}        = $ENV{ARTEMIS_HOSTNAME};

                my $sock = IO::Socket::INET->new(PeerAddr => $cfg->{report_server},
                                                 PeerPort => $cfg->{report_port},
                                                 Proto    => 'tcp');
                unless ($sock) { die "Can't open connection to ", $cfg->{report_server}, ":$!" }
                $sock->print($self->gen_report($cfg));
                $sock->close;
                return 0;
        }

}


=head1 NAME

TestSuite::HWTrack::Execute - Support package for TestSuite::HWTrack

=head1 SYNOPSIS

Don't use this module directly!

=head1 AUTHOR

OSRC SysInt team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc TestSuite::HWTrack


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt team, all rights reserved.

This program is released under the following license: restrictive / proprietary


=cut

1;
