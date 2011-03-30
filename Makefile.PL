use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-TestSuite-HWTrack';
license  'freebsd';
all_from 'lib/Tapper/TestSuite/HWTrack.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';

requires 'perl'                  => 5.010;
install_script 'tapper-testsuite-hwtrack';

requires 'File::ShareDir';
requires 'File::Temp';
requires 'File::Temp';
requires 'IO::Socket::INET';
requires 'MooseX::Declare'       => 0.27;
requires 'Sys::Hostname';
requires 'XML::SAX';
requires 'XML::Simple';
requires 'YAML';


build_requires 'Data::DPath'     => 0.17;
build_requires 'Test::More';
build_requires 'Tapper::Config';
build_requires 'TAP::DOM';

# the following string concatenation might look weird but it's the best
# trade-off between having tabs instead of 8 spaces and not having to quote
# everything Perl understands

WriteAll;

