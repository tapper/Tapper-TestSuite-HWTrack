## no critic (RequireUseStrict)
package Tapper::TestSuite::HWTrack;
# ABSTRACT: Tapper - Report hardware meta information

        use 5.010;
        use Moose;

        use aliased 'Tapper::TestSuite::HWTrack::Prepare';
        use aliased 'Tapper::TestSuite::HWTrack::Execute';
        has 'exec' => ( is => 'ro', isa => Execute, handles => [qw( generate send gen_error )], default => sub { Execute->new }, );

1;

=head1 ABOUT

HWTrack calls the tool lshw, parses its input and sends it to the
report framework.

=cut
