use MooseX::Declare;
use 5.010;

class TestSuite::HWTrack {
        use aliased 'TestSuite::HWTrack::Prepare';
        use aliased 'TestSuite::HWTrack::Execute';
        has 'prep' => ( is => 'ro', isa => Prepare, handles => [qw( install )],       default => sub { Prepare->new }, );
        has 'exec' => ( is => 'ro', isa => Execute, handles => [qw( generate send gen_error )], default => sub { Execute->new }, );

        method BUILD
        {
                $self->exec->dst($self->prep->dst);
        }
}


{

=head1 NAME

TestSuite::HWTrack - Keep track of actual hardware in test machine

=head1 VERSION

=cut

        package TestSuite::HWTrack;
        our $VERSION = '1.010027';

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

This program is released under the following license: restrictive / proprietary


=cut
}
1; # End of TestSuite::HWTrack
