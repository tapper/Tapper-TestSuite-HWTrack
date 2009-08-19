use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'TestSuite::HWTrack',
    AUTHOR              => 'OSRC SysInt Team <osrc-sysint@elbe.amd.com>',
    VERSION_FROM        => 'lib/TestSuite/HWTrack.pm',
    ABSTRACT_FROM       => 'lib/TestSuite/HWTrack.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'Restricted')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'TestSuite-HWTrack-*' },
);
