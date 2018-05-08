package Flood::2DLevel;
use v5.10;
use Moose;
use Carp;

extends 'Flood::Level';

before BUILD => sub {
	my $self = shift;
	croak 'More than 2 dimensions specified in 2DLevel'
		unless @{$self->dimensions} == 2;
};

sub render_2d {
	my $self = shift;

	my ($width, $height) = @{$self->dimensions};
	# loop through rows
	for (0..$height) {
		say(join(' ', @{$self->board}[$_ * $width..($_ + 1) * $width - 1]));
	}
}

__PACKAGE__->meta->make_immutable;
