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
                system($exec);
        }

        method send() {
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
