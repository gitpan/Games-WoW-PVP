#!/usr/bin/perl -w

use strict;
use Test::More tests => 6;
use Games::WoW::PvP;

my $WoW = Games::WoW::PVP->new();

# looking for a character
my $character = $WoW->search_player( {
      country   => 'EU',       # EU europe US us KR korean
      realm     => 'Elune',    # name of the realm
      character => 'Aarnn',    # name of the player
    } );

ok( $character );
is( $$character{ characterName }, "Aarnn",          "Player name OK" );
is( $$character{ raceLabel },     "Dwarf",          "Player race OK" );
is( $$character{ classLabel },    "Priest",         "Player class OK" );
is( $$character{ level },         70,               "Player level OK" );
is( $$character{ rank },          "Sergeant Major", "Player rank OK" );
