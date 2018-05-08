#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;

use lib '.';
use Flood::Playable2DLevel;

$| = 1;

my $level = Flood::Playable2DLevel->new(
	dimensions => [ 8, 8 ],
	colors => 6
);

$level->play_until_complete;
