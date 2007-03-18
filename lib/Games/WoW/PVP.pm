package Games::WoW::PVP;

use warnings;
use strict;
use Carp;
use Games::WoW::Armory;
use base qw/Class::Base/;

=head1 NAME

Games::WoW::PVP - (DEPRECATED) fetch informations about pvp grades for world of warcraft

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

	# please use Games::WoW::Armory
	
	use Games::WoW::PVP;
   
	my $WoW  = Games::WoW::PVP->new();
	# looking for a character
	my $character = $WoW->search_player(
		{   country   => 'EU',					# EU europe US us
			realm     => 'conseil des ombres',
			character => 'raspa',
		}
	);
	print $$character{characterName}."\n";

=head2 METHOD

=head3 init

	init, create $self->{armory}

=head3 search_player

Get informations for a given character.

Return the following informations: 

	characterName / raceLabel / classLabel / level / lhk / rank

=cut
	
sub init {
    my ( $self ) = @_;
    $self->{ armory } = Games::WoW::Armory->new();
    return $self;
}

sub search_player {
    my ( $self ) = shift;
    $self->{ options } = shift;

    croak "you need to specify a guild name"
        unless defined $self->{ options }{ character };
    croak "you need to specify a realm"
        unless defined $self->{ options }{ realm };
    croak "you need to specify a region name"
        unless defined $self->{ options }{ country };

    $self->{ armory }->search_character( $self->{ options } );

    my $character_info = {
              characterName => $self->{ armory }->character->{ name },
              raceLabel     => $self->{ armory }->character->{ race },
              classLabel    => $self->{ armory }->character->{ class },
              level         => $self->{ armory }->character->{ level },
              lhk           => $self->{ armory }
                  ->characterinfo->{ pvp }{ lifetimehonorablekills }{ value },
              rank => $self->{ armory }
                  ->characterinfo->{ knownTitles }{ title }{ value },
    };

    return ( $character_info );
}

=head1 AUTHOR

Franck Cuny, C<< <franck.cuny at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-games-wow-pvp at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-WoW-PVP>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2006-2007 Franck Cuny, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
