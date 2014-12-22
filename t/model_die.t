#!/usr/bin/env perl
use Test::More;
use Test::Exception;
use Test::Warnings;

my $TEST_CLASS = qw(Game::Die);
my $N_DICE = 4;

use_ok($TEST_CLASS);

my @dice;
for (1..$N_DICE) {
  lives_ok(sub { push @dice, $TEST_CLASS->new(); },
                                "create $_ of $N_DICE dice");
}

my @individual_dice;
$TEST_CLASS->seed(25);
for my $die (@dice) {
  my @rolls;
  for (1..3) {
    $die->roll;
    push @rolls, $die->spots;
  }
  push @individual_dice, \@rolls;
}

done_testing;
