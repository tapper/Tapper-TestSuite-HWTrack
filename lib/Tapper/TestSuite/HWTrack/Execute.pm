use MooseX::Declare;
use 5.010;

## no critic (RequireUseStrict)
class Tapper::TestSuite::HWTrack::Execute {
        use File::Temp 'tempfile';
        use IO::Socket::INET;
        use Sys::Hostname;
        use XML::Simple;
        use YAML;

        has dst    => ( is => 'rw');

        # Generate lshw output and return it as a report string
        #
        # @return success - report string
        # @return error   - undef
        method generate() {
                my (undef, $file) = tempfile( CLEANUP => 1 );
                my $lshw = "lshw";
                my $exec = "$lshw -xml > $file";
                system($exec); # can't use Tapper::Base->log_and_exec since
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
                my $test_run = $ENV{TAPPER_TESTRUN};
                my $hostname = $ENV{TAPPER_HOSTNAME} || Sys::Hostname::hostname();
                my $xml      = XML::Simple->new(ForceArray => 1);
                my $data     = $xml->XMLin($file);
                my $yaml     = Dump($data);
                $yaml       .= "...\n";
                $yaml        =~ s/^(.*)$/  $1/mg;  # indent
                my $report   = sprintf("
TAP Version 13
1..2
# Tapper-Reportgroup-Testrun: %s
# Tapper-Suite-Name: HWTrack
# Tapper-Machine-Name: %s
# Tapper-Suite-Version: %s
ok 1 - Getting hardware information
%s
ok 2 - Sending
", $test_run, $hostname, $Tapper::TestSuite::HWTrack::VERSION, $yaml);
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
                my $test_run = $ENV{TAPPER_TESTRUN};
                my $hostname = $ENV{TAPPER_HOSTNAME};
                my $yaml     = Dump({error => $error});
                $yaml       .= "...\n";
                $yaml        =~ s/^(.*)$/  $1/mg;  # indent
                my $report   = sprintf("
TAP Version 13
1..2
# Tapper-Reportgroup-Testrun: %s
# Tapper-Suite-Name: HWTrack
# Tapper-Machine-Name: %s
# Tapper-Suite-Version: %s
not ok 1 - Generating lshw executable
%s
ok 2 - Sending
", $test_run, $hostname, $Tapper::TestSuite::HWTrack::VERSION, $yaml);
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
                $cfg->{report_server}   = $ENV{TAPPER_REPORT_SERVER}   || 'tapper';
                $cfg->{report_api_port} = $ENV{TAPPER_REPORT_API_PORT} || 7358;
                $cfg->{report_port}     = $ENV{TAPPER_REPORT_PORT}     || 7357;

                print STDERR "host:port = ".$cfg->{report_server}.":".$cfg->{report_port};
                # following options are not yet used in this class
                $cfg->{mcp_server}      = $ENV{TAPPER_SERVER};
                $cfg->{runtime}         = $ENV{TAPPER_TS_RUNTIME};

                my $sock = IO::Socket::INET->new(PeerAddr => $cfg->{report_server},
                                                 PeerPort => $cfg->{report_port},
                                                 Proto    => 'tcp');
                unless ($sock) { die "Can't open connection to ", $cfg->{report_server}, ":", $cfg->{report_port}, ": $!" }
                $sock->print($report);
                $sock->close;
                return 0;
        }
}


=head1 NAME

Tapper::TestSuite::HWTrack::Execute - Support package for Tapper::TestSuite::HWTrack

=head1 SYNOPSIS

Don't use this module directly!

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tapper::TestSuite::HWTrack


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper team, all rights reserved.

This program is released under the following license: freebsd


=cut

1;
