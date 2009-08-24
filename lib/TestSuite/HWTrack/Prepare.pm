use MooseX::Declare;
use 5.010;

class TestSuite::HWTrack::Prepare extends Artemis::Base {

        use File::ShareDir 'module_dir';
        use File::Temp     'tempdir';

        has src       => ( is => 'rw', default => sub { module_dir('TestSuite::HWTrack')."/lshw" } );
        has dst       => ( is => 'rw', default => sub { tempdir( CLEANUP => 0 ) } );
        has exitcode  => ( is => 'rw', );
        has starttime => ( is => 'rw', );

        method install
        {
                my $src = $self->src;
                my $dst = $self->dst;
                my ($error, $msg);
                ($error, $msg) = $self->log_and_exec("rsync -a $src/ $dst/");
                $self->log->logdie($msg) if $error;

                ($error, $msg) = $self->log_and_exec("cd $dst; make ");
                $self->log->logdie($msg) if $error;
        }

}

=head1 NAME

TestSuite::HWTrack::Prepare - Support package for TestSuite::HWTrack

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
