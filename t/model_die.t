#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Test::Exception;
use Test::Warnings;
use List::MoreUtils qw(any pairwise);

## no critic (MagicNumbers)
my $TEST_CLASS = qw(Game::Die);
my $N_DICE = 4;

use_ok($TEST_CLASS);

lives_ok(sub { $TEST_CLASS->seed(25) },
                                                        'set a seed value for testing');

my @dice;
for (1..$N_DICE) {
  lives_ok(sub { push @dice, $TEST_CLASS->new(); },
                                                        "create $_ of $N_DICE dice");
}

my @individual_dice;
for my $die (@dice) {
  my @rolls;
  for (1..3) {
    $die->roll;
    push @rolls, $die->spots;
  }
  push @individual_dice, \@rolls;
}

while (@individual_dice) {
  my $test = shift @individual_dice;
  for my $comp (@individual_dice) {
    ## no critic (ProhibitParens, ProhibitNoWarnings)
    no warnings qw(once);
    ok( (any { $_ } (pairwise { $a ne $b } @{ $test }, @{ $comp })),
                                                        'series of rolls differs for die '
                                                        .($N_DICE - @individual_dice))
      ||  diag(show_array($test)
                . ' => '
                . join(q{, }, map { show_array($_) } @individual_dice)
          );
  }
}

done_testing;

sub show_array {
  my ($ref) = @_;
  return '[' . join(q{,}, @{$ref}) . ']';
}
