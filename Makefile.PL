use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile( NAME          => 'Games::WoW::PVP',
               AUTHOR        => 'Franck Cuny <franck.cuny@gmail.com>',
               VERSION_FROM  => 'lib/Games/WoW/PVP.pm',
               ABSTRACT_FROM => 'lib/Games/WoW/PVP.pm',
               LICENSE       => 'perl',
               PL_FILES      => {},
               PREREQ_PM     => {
                              'Test::More'         => 0,
                              'Class::Base'        => 0,
                              'Games::WoW::Armory' => 0,
                              'Test::Perl::Critic' => 0,
               },
               dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
               clean => { FILES    => 'Games-WoW-PVP-*' },
);
