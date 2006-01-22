#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Games::WoW::PVP' );
}

diag( "Testing Games::WoW::PVP $Games::WoW::PVP::VERSION, Perl $], $^X" );
