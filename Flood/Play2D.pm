# this handles the ui and everything for playing a game. 

package Flood::Play2D;
use v5.10;
use Moose;

use Flood::Level;

has level => (
	is => 'ro',
	isa => 'Flood::Level',
	required => 1
);

# floods, then renders. You should render manually before first call in a loop.
sub one_round {
	my $self = shift;
	# `moves` is the number completed, we want to show which is about to be done
	printf 'Move #%d, flood with: ', $self->level->moves + 1;
	chomp(my $flood_with = <>);
	$self->level->flood($flood_with);
	$self->level->render_2d;
}

sub until_complete {
	my $self = shift;
	$self->level->render_2d;
	until ($self->level->complete) {
		$self->one_round;
	}
	printf 'Complete in %d moves!', $self->level->moves;
}

__PACKAGE__->meta->make_immutable;
