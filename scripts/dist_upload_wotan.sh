#! /bin/bash

EXECDIR=$(dirname $0)
DISTFILES='TestSuite*-*.*.tar.gz '
$EXECDIR/tapper_version_increment.pl $EXECDIR/../lib/TestSuite/HWTrack.pm
cd $EXECDIR/..

rm MANIFEST
make manifest || exit -1

perl Makefile.PL || exit -1
make dist || exit -1

# -----------------------------------------------------------------
# It is important to not overwrite existing files.
# -----------------------------------------------------------------
# That guarantees that the version number is incremented so that we
# can be sure about version vs. functionality.
# -----------------------------------------------------------------

echo ""
echo '----- upload ---------------------------------------------------'
rsync -vv --progress --ignore-existing ${DISTFILES} tapper@wotan:/home/tapper/CPANSITE/CPAN/authors/id/T/TA/TAPPER/

echo ""
echo '----- re-index -------------------------------------------------'
ssh tapper@wotan /home/tapper/perl510/bin/cpansite -vv --site=/home/tapper/CPANSITE/CPAN --cpan=ftp://ftp.fu-berlin.de/unix/languages/perl/ index
ssh tapper@wotan /home/tapper/perl510/bin/cpan TestSuite::HWTrack

