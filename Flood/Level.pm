package Flood::Level;
use v5.10;
use Moose;
use Carp;

use List::Util qw/product max min/;

# SET INTERNALLY
has board => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub { [] },
);
has corner_color => (
	is => 'ro',
	isa => 'Num',
	writer => '_set_corner_color',
);
has moves => (
	is => 'ro',
	isa => 'Num',
	# TODO: figure out if there's a built-in or otherwise better way to increment
	writer => '_set_moves',
	default => 0,
);

# OPTIONALLY FROM CONSTRUCTOR
has seed => (
	is => 'ro',
	isa => 'Num',
	writer => '_set_seed',
	predicate => '_has_seed',
);

# SET FROM CONSTRUCTOR
has dimensions => (
    is => 'ro',
    isa => 'ArrayRef',
    required => 1,
);
has colors => (
    is => 'ro',
    isa => 'Num',
    required => 1,
);

sub flood {

	my $self = shift;
	my ($new_corner_color) = @_;

	# Increment moves counter
	$self->_set_moves($self->moves + 1);
	
	# undef if not checked, 1 if connected, 0 if not
	my %connected = ();
	# not using recursion, for some reason
	# cells to be checked like a shitty stack!
	my @maybe_connected = ( 0 );
	my $check_next = 0;
	while ($check_next < @maybe_connected) {
		my $check_now = $maybe_connected[$check_next];
		$check_next++;
		# next if this isn't connected
		next unless $self->board->[$check_now] == $self->corner_color;
		# we're hooked up
		$connected{$check_now} = 1;
		# and check children
		for my $dimension_num (0..$#{$self->dimensions}) {
			# to move forwards in dimension X, we should move forward by the product of the
			# size of all previous dimensions. So, in the first dimension, there is no
			# previous dimension, so product = 1: we go up and down by 1. For second
			# dimension, product = dimension_1_size * 1, so by the size of a row. In three
			# dimensions, product = size of a plane, which is good because each plane gets
			# put consecutively into the array, so add size of plane means same spot in next
			# plane
			
			# for some (good) reason, @arr[0..-1] is empty
			my $crement_by = product @{$self->dimensions}[0..$dimension_num - 1];
			for my $maybe_add ($check_now + $crement_by, $check_now - $crement_by) {
				push @maybe_connected, $maybe_add
					# don't push if it's already there
					unless grep { $_ == $maybe_add } @maybe_connected
					# or if it wraps around
					or $maybe_add < 0
					or $maybe_add > @{$self->board};
			}
		}
	}
	# and update colors in board
	for (keys %connected) {
		$self->board->[$_] = $new_corner_color;
	}
	# update corner color
	$self->_set_corner_color($new_corner_color);
}

sub render_2d {
	my $self = shift;

	croak '2D render requested of level with different dimension count.'
		unless @{$self->dimensions} == 2;
	
	my ($width, $height) = @{$self->dimensions};
	# loop through rows
	for (0..$height) {
		say join ' ', @{$self->board}[$_ * $width..($_ + 1) * $width - 1];
	}
}

sub complete {
	my $self = shift;
	return max( @{$self->board} ) == min( @{$self->board} );
}

sub generate {
    my $self = shift;
    # seed
    if ($self->_has_seed) {
		srand $self->seed;
    } else {
		$self->_set_seed(srand);
    }
    # generate board
	# total number of cells = length of @board = product of all dimension sizes
    my $cells = product @{$self->dimensions};
    for (0..$cells - 1) {
        $self->board->[$_] = int rand $self->colors;
    }
    
    $self->_set_corner_color($self->board->[0]);
}

__PACKAGE__->meta->make_immutable;
