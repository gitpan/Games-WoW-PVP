use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Games::WoW::PVP',
    AUTHOR              => 'Franck Cuny <franck@breizhdev.net>',
    VERSION_FROM        => 'lib/Games/WoW/PVP.pm',
    ABSTRACT_FROM       => 'lib/Games/WoW/PVP.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
		'Data::Dumper' => 0,
		'LWP::UserAgent' => 0,
		'XML::Simple' => 0,
		'Class::Base' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Games-WoW-PVP-*' },
);
