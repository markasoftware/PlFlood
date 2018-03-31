package Flood::HiStore

use v5.10;
use Moose;

use DBI;

has sqlite_file => (
	is => 'ro',
	isa => 'String',
	default => 'plflood.sqlite',
);

sub save_score {
	my $self = shift;
	my ($
}

__PACKAGE__->meta->make_immutable;
