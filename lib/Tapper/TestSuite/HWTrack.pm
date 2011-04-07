use MooseX::Declare;
use 5.010;

## no critic (RequireUseStrict)
class Tapper::TestSuite::HWTrack {
        use aliased 'Tapper::TestSuite::HWTrack::Prepare';
        use aliased 'Tapper::TestSuite::HWTrack::Execute';
        has 'exec' => ( is => 'ro', isa => Execute, handles => [qw( generate send gen_error )], default => sub { Execute->new }, );

}

package Tapper::TestSuite::HWTrack;
our $VERSION = '3.000010';

=head1 NAME

Tapper::TestSuite::HWTrack - Tapper - Report hardware meta information

=head1 SYNOPSIS


HWTrack calls the tool lshw, parses its input and sends it to the
report framework.

  use TestSuite::HWTrack;
  use TryCatch;
  my $config  = { report_server => 'bancroft', report_port => 7357 };
  my $track   = TestSuite::HWTrack($config);
  my $success = $track->run();

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-testsuite-hwtrack
at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=TestSuite-HWTrack>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tapper::TestSuite::HWTrack

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper team, all rights reserved.

This program is released under the following license: freebsd


=cut

1; # End of Tapper::TestSuite::HWTrack
