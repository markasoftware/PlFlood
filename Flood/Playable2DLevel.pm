package Flood::Playable2DLevel;
use v5.10;
use Moose;
use Carp;

extends 'Flood::2DLevel';

sub play_one_round {
	my $self = shift;
	# `moves` is the number completed, we want to show which is about to be done
	printf 'Move #%d, flood with: ', $self->moves + 1;
	chomp(my $flood_with = <>);
	$self->flood($flood_with);
	$self->render_2d;
}

sub play_until_complete {
	my $self = shift;
	$self->render_2d;
	until ($self->complete) {
		$self->play_one_round;
	}
	printf 'Complete in %d moves!', $self->moves;
}

__PACKAGE__->meta->make_immutable;
