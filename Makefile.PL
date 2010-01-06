use strict;
use warnings;

use inc::Module::Install;

name     'TestSuite-HWTrack';
all_from 'lib/TestSuite/HWTrack.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';

requires 'perl'                  => 5.010;
install_script 'artemis-testsuite-hwtrack';

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
build_requires 'Artemis::Config';
build_requires 'TAP::DOM';


WriteAll;

