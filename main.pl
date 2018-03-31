#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;

use lib '.';
use Flood::Play2D;
use Flood::Level;

$| = 1;

my $level = Flood::Level->new(
	dimensions => [ 8, 8 ],
	colors => 6
);
$level->generate;

my $game = Flood::Play2D->new( level => $level );
$game->until_complete;
