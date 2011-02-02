use strict;
use warnings;

use inc::Module::Install;

name     'TestSuite-HWTrack';
all_from 'lib/TestSuite/HWTrack.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';
license  'freebsd';

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
postamble('
MOUNT=/opt/tapper/mnt
MOUNT64:=${MOUNT}64
MOUNT32:=${MOUNT}32
PKG_DIR=/data/bancroft/tapper/live/repository/packages/tapperutils/

live:
'."\t./scripts/dist_upload_wotan.sh dist
\tssh".' tapper@bancroft "cd ${MOUNT64}; sudo chroot ${MOUNT64} /opt/tapper/bin/cpan TestSuite::HWTrack; tar -czf ${PKG_DIR}/opt-tapper64.tar.gz opt/ etc/resolv.conf"
'."\tssh".' tapper@bancroft "cd ${MOUNT32}; sudo chroot ${MOUNT32} /opt/tapper/bin/cpan TestSuite::HWTrack; tar -czf ${PKG_DIR}/opt-tapper32.tar.gz opt/ etc/resolv.conf"

devel:
'."\t./scripts/dist_upload_wotan.sh dist

\tssh".' tapper@bancroft "sudo mv ${MOUNT64}/opt ${MOUNT64}/opt.live; sudo mv ${MOUNT64}/opt.devel ${MOUNT64}/opt;"
'."\tssh".' tapper@bancroft "cd ${MOUNT64}; sudo chroot ${MOUNT64} /opt/tapper/bin/cpan TestSuite::HWTrack; tar -czf ${PKG_DIR}/opt-tapper64_devel.tar.gz opt/"
'."\tssh".' tapper@bancroft "sudo mv ${MOUNT64}/opt ${MOUNT64}/opt.devel; sudo mv ${MOUNT64}/opt.live ${MOUNT64}/opt;"

'."\tssh".' tapper@bancroft "sudo mv ${MOUNT32}/opt ${MOUNT32}/opt.live; sudo mv ${MOUNT32}/opt.devel ${MOUNT32}/opt;"
'."\tssh".' tapper@bancroft "cd ${MOUNT32}; sudo chroot ${MOUNT32} /opt/tapper/bin/cpan TestSuite::HWTrack; tar -czf ${PKG_DIR}/opt-tapper32_devel.tar.gz opt/"
'."\tssh".' tapper@bancroft "sudo mv ${MOUNT32}/opt ${MOUNT32}/opt.devel; sudo mv ${MOUNT32}/opt.live ${MOUNT32}/opt;"

');

WriteAll;

