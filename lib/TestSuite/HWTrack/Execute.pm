use MooseX::Declare;
use 5.010;

class TestSuite::HWTrack::Execute {
        use File::Temp 'tempfile';
        use XML::Simple;
        use YAML;
        use IO::Socket::INET;

        has dst    => ( is => 'rw');

        # Generate lshw output and return it as a report string
        #
        # @return success - report string
        # @return error   - undef
        method generate() {
                my (undef, $file) = tempfile( CLEANUP => 1 );
                my $lshw = $self->dst."/src/lshw";
                my $exec = "$lshw -xml > $file";
                system($exec); # can't use Artemis::Base->log_and_exec since
                               # this puts STDERR into the resulting XML file
                               # which in turn becomes invalid XML
                return $self->gen_report($file);
        }

        # Generate a report based upon the XML formatted data found in the
        # file given as parameter
        #
        # @param string - file name
        #
        # @return success - report string
        # @return error   - undef
        method gen_report(Str $file) {
                my $test_run = $ENV{ARTEMIS_TESTRUN};
                my $hostname = $ENV{ARTEMIS_HOSTNAME};
                my $xml      = XML::Simple->new(ForceArray => 1);
                my $data     = $xml->XMLin($file);
                my $yaml     = Dump($data);
                $yaml       .= "...\n";
                $yaml        =~ s/^(.*)$/  $1/mg;  # indent
                my $report   = sprintf("
TAP Version 13
1..2
# Artemis-Reportgroup-Testrun: %s
# Artemis-Suite-Name: HWTrack
# Artemis-Maschine-Name: %s
# Artemis-Suite-Version: %s
ok 1 - Getting hardware information
%s
ok 2 - Sending
", $test_run, $hostname, $TestSuite::HWTrack::VERSION, $yaml);
                return $report;
        }


        # Generate an error report based upon given error string
        # the file given as parameter
        #
        # @param string - error string
        #
        # @return success - report string
        # @return error   - undef
        method gen_error(Str $error) {
                my $test_run = $ENV{ARTEMIS_TESTRUN};
                my $hostname = $ENV{ARTEMIS_HOSTNAME};
                my $yaml     = Dump({error => $error});
                $yaml       .= "...\n";
                $yaml        =~ s/^(.*)$/  $1/mg;  # indent
                my $report   = sprintf("
TAP Version 13
1..2
# Artemis-Reportgroup-Testrun: %s
# Artemis-Suite-Name: HWTrack
# Artemis-Maschine-Name: %s
# Artemis-Suite-Version: %s
not ok 1 - Generating lshw executable
%s
ok 2 - Sending
", $test_run, $hostname, $TestSuite::HWTrack::VERSION, $yaml);
                return $report;
        }


        # Send a given report to report receiver.
        #
        # @param string - report
        #
        # @return success - 0
        # @return error   - error string
        method send(Str $report) {
                my $cfg;
                $cfg->{report_server}   = $ENV{ARTEMIS_REPORT_SERVER} || 'bascha';
                $cfg->{report_api_port} = $ENV{ARTEMIS_REPORT_API_PORT} || 7358;
                $cfg->{report_port}     = $ENV{ARTEMIS_REPORT_PORT} || 7357;

                # following options are not yet used in this class
                $cfg->{mcp_server}      = $ENV{ARTEMIS_SERVER};
                $cfg->{runtime}         = $ENV{ARTEMIS_TS_RUNTIME};

                my $sock = IO::Socket::INET->new(PeerAddr => $cfg->{report_server},
                                                 PeerPort => $cfg->{report_port},
                                                 Proto    => 'tcp');
                unless ($sock) { die "Can't open connection to ", $cfg->{report_server}, ":$!" }
                $sock->print($report);
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
