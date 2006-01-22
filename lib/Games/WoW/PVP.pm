package Games::WoW::PVP;

use warnings;
use strict;
use Data::Dumper;
use LWP::UserAgent;
use XML::Simple;
use Class::Base;
use base qw/Class::Base/;

=head1 NAME

Games::WoW::PVP - The great new Games::WoW::PVP!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

our $EU_URL   = 'http://www.wow-europe.com/';
our $US_URL   = 'http://www.worldofwarcraft.com/';
our $pvp_rank = 'pvp/rankings.xml?';

our @rating = (
    0,     25,    1000,  5000,  10000, 15000, 20000, 25000,
    30000, 35000, 40000, 45000, 50000, 55000, 60000
);

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Games::WoW::PVP;
   
    my $WoW  = Games::WoW::PVP->new();
    # looking for a character
    my %hash = $WoW->search_player(
        {   country   => 'EU',                      # EU europe US us
            realm     => 'conseil des ombres',      # name of the realm
            faction   => 'h',                       # h horde a ally
            character => 'raspa',                   # name of the player
        }
    );
    
    # looking for top players
    my %hash = $WoW->top(
        {   country => 'EUR,
            realm   => 'elune',
            faction => 'a',
        }
    );
    
=head1 FUNCTIONS

=head2 init

=cut

sub init {
    my ($self) = @_;
    $self->{ua} = LWP::UserAgent->new() || die "[PROBLEM]: " . $!;
    return $self;
}

=head1 FUNCTIONS

=head2 construct_url

=cut

sub construct_url {
    my ( $self, $type ) = @_;

    # if we have $type == 1 we want a top_ten, for 0 search for a character
    $self->{url} = ( $self->{options}{country} eq 'US' ) ? $US_URL : $EU_URL;

    if ( !defined $self->{options}{realm} ) {
        print "You have to specify a realm\n";
        return;
    }

    if ( !defined $self->{options}{character} && $self->{type} == 0) {
        print "You have to specify a character name\n";
        return;
    }

    if ( !defined $self->{options}{faction} ) {
        print "You have to specify a faction\n";
        return;
    }

    $self->{url} .= $pvp_rank . "r="
        . $self->{options}{realm}
        . "&faction="
        . $self->{options}{faction};
    $self->{url} .= "&c=" . $self->{options}{character}
        if ( $self->{type} == 0 );

}

=head1 FUNCTIONS

=head2 query

=cut

sub search_player {
    my ($self) = shift;
    $self->{options} = shift;

    $self->{type} = 0;
    $self->construct_url();

    my %hash = $self->query();

    if ( $self->{find} == 1 ) {
        return %hash;
    }
    elsif ( $self->{find} == -1 ) {
        return;
    }
    else {
        $self->{options}{realm} =~ s/\+/ /g;
        my $faction = ( $self->{options}{faction} eq 'h' ) ? 'horde' : 'ally';
        print "[ERROR]: no result for the " . $faction . " "
            . $self->{options}{character} . " on "
            . $self->{options}{realm} . "\n";
        return;
    }
}

=head1 FUNCTIONS

=head2 top_ten

=cut

sub top {
    my ($self) = shift;
    $self->{options} = shift;

    $self->{type} = 1;
    $self->construct_url();

    my %hash = $self->query();

    if ( $self->{find} == -1 ) {
        return;
    }
    else {
        return %hash;
    }
    return;
}

=head1 FUNCTIONS

=head2 query

=cut

sub query {
    my ($self) = @_;

    my ( $response, $xml, $xp, $data );
    my %hash = ();
    $self->{find} = 0;

    $response = $self->{ua}->get( $self->{url} );

    if ( $response->is_success ) {
        $xml = $response->content;
    }
    else {
        print "[ERROR]: " . $response->status_line . "\n";
        $self->{find} = -1;
        return;
    }

    $xp   = XML::Simple->new;
    $data = $xp->XMLin($xml);

    foreach my $el ( @{ $data->{characters}->{character} } ) {
        if ( $self->{type} == 0 ) {
            if ( $self->{options}{character} eq $el->{characterName} ) {
                $hash{characterName} = $el->{characterName};
                $hash{guildName}     = $el->{guildName};
                $hash{raceLabel}     = $el->{raceLabel};
                $hash{classLabel}    = $el->{classLabel};
                $hash{level}         = $el->{level};
                $hash{position}      = $el->{position};
                $hash{rank}          = $el->{rank};
                $hash{rankLabel}     = $el->{rankLabel};
                $hash{lhk}           = $el->{lhk};
                $hash{ldk}           = $el->{ldk};
                $hash{rating}        = $el->{rating};
                $hash{percent}       = int (
                    ( $el->{rating} / $rating[ $el->{rank} + 1 ] ) * 100 );
                $self->{find} = 1;
            }
        }
        else {
            $hash{ $el->{characterName} }{guildName}  = $el->{guildName};
            $hash{ $el->{characterName} }{raceLabel}  = $el->{raceLabel};
            $hash{ $el->{characterName} }{classLabel} = $el->{classLabel};
            $hash{ $el->{characterName} }{level}      = $el->{level};
            $hash{ $el->{characterName} }{position}   = $el->{position};
            $hash{ $el->{characterName} }{rank}       = $el->{rank};
            $hash{ $el->{characterName} }{rankLabel}  = $el->{rankLabel};
            $hash{ $el->{characterName} }{lhk}        = $el->{lhk};
            $hash{ $el->{characterName} }{ldk}        = $el->{ldk};
            $hash{ $el->{characterName} }{rating}     = $el->{rating};
            $hash{ $el->{characterName} }{percent}
                = int ( ( $el->{rating} / $rating[ $el->{rank} + 1 ] ) * 100 );
        }
    }
    return (%hash);
}

=head1 AUTHOR

Franck Cuny, C<< <franck at breizhdev.net> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-games-wow-pvp at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-WoW-PVP>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::WoW::PVP

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-WoW-PVP>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-WoW-PVP>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-WoW-PVP>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-WoW-PVP>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Franck Cuny, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of Games::WoW::PVP
