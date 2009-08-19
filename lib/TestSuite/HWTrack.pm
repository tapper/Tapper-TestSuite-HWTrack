package TestSuite::HWTrack;

use warnings;
use strict;

=head1 NAME

TestSuite::HWTrack - The great new TestSuite::HWTrack!

=head1 VERSION

Version 0.01

=cut

        package TestSuite::HWTrack;
        our $VERSION = '0.01';

=head1 SYNOPSIS


HWTrack calls the tool lshw, parses its input and sends it to the report
framework. HWTrack offers a object orientated interface. Error handling is
implemented using Artemis::Exception.

  use TestSuite::HWTrack;
  use TryCatch;
  my $config = {report_server => 'bancroft', report_port => 7357};
  my $track = TestSuite::HWTrack($config);
  try {
      my $success = $track->run();
  } catch ($exception) {
        die $exception->msg();
  }

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2

=cut

#sub prepare { shift; TestSuite::HWTrack::Prepare->new->prepare(@_) }



=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-testsuite-hwtrack at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=TestSuite-HWTrack>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc TestSuite::HWTrack


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 OSRC SysInt Team, all rights reserved.

This program is released under the following license: Restricted


=cut
}
1; # End of TestSuite::HWTrack
