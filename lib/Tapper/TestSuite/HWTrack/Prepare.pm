## no critic (RequireUseStrict)
package Tapper::TestSuite::HWTrack::Prepare;
# ABSTRACT: Support package for Tapper::TestSuite::HWTrack

        use 5.010;

        use Moose;
        extends 'Tapper::Base';
        use File::ShareDir 'module_dir';
        use File::Temp     'tempdir';

        has src       => ( is => 'rw', default => sub { module_dir('Tapper::TestSuite::HWTrack')."/lshw" } );
        has dst       => ( is => 'rw', default => sub { tempdir( CLEANUP => 0 ) } );
        has exitcode  => ( is => 'rw', );
        has starttime => ( is => 'rw', );


        # Prepare lshw executable
        #
        # @return success - 0
        # @return error   - error string
        sub install {
                my ($self) = @_;

                my $src = $self->src;
                my $dst = $self->dst;
                my ($error, $msg);
                ($error, $msg) = $self->log_and_exec("rsync -a $src/ $dst/");
                return $msg if $error;

                ($error, $msg) = $self->log_and_exec("cd $dst; make ");
                return $msg if $error;
                return 0;
        }

1;
