#!/usr/bin/perl -w

use strict;
use Games::WoW::PvP;

use Getopt::Simple qw($switch);

my ( $options ) = {
    help => { type    => '',
              env     => '-',
              default => '',
              verbose => 'this help',
              order   => 1,
    },
    character => { type    => '=s',
                   env     => '-',
                   default => '',
                   verbose => 'character name',
                   order   => 2,
    },
    realm => {
        type    => '=s',
        env     => '-',
        default => '',
        verbose => 'realm name',
        order   => 3,

    },
    country => {
        type    => '=s',
        env     => '-',
        default => '',
        verbose => 'Region name (EU|US)',
        order   => 4,

    },
};

my $o = Getopt::Simple->new();
if ( !$o->getOptions( $options, "Usage : $0 [options]" ) ) {
    exit( -1 );
}

my $WoW = Games::WoW::PVP->new();

# looking for a character
my $character = $WoW->search_player( { realm     => $$switch{ 'realm' },
                                       character => $$switch{ 'character' },
                                       country   => $$switch{ 'country' } } );

print $$character{ characterName } . ":"
    . $$character{ raceLabel } . "/"
    . $$character{ classLabel }
    . "(level "
    . $$character{ level } . ") is "
    . $$character{ rank } . "\n";
