package Flood::HiScore

use v5.10;
use Moose;

use Flood::Level;

has alias => (
	is => 'ro',
	# TODO: use a type constraint to force it to be a 3-letter, all caps name instead of doing it manually in other methods?
	isa => 'String',
	# can you hear me major tom?
	default => 'TOM',
);

has level => ( is => 'ro', isa => 'Flood::Level', required => 1 );
has created_at => ( is => 'ro', default => sub { time } );

__PACKAGE__->meta->make_immutable;
