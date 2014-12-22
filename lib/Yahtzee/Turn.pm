package Yahtzee::Turn;
use 5.014;
use warnings;

use Game::Die;

1;

__END__

=head1 NAME

Yahtzee::Turn;

=head1 SYNOPSIS

    my $turn = Yahtzee::Turn->new();

    say $turn->as_string;
    # 1: 2
    # 2: 4
    # 3: 4
    # 4: 5
    # 5: 6
    say $turn->rethrows_remaining;
    # 2

    $turn->rethrow(1,3);
    say $turn->as_string;
    # 1: 1
    # 2: 4
    # 3: 5
    # 4: 6
    # 5: 6

    turn->rethrow(1,2,3);
    say $turn->as_string;
    # 1: 2
    # 2: 6
    # 3: 6
    # 4: 6
    # 5: 6
    say $turn->rethrows_remaining;
    # 0

    say $turn->result;
    # Four of a kind
    say $turn->significant_value;
    # 6
    say $turn->spot_total;
    # 26

=head1 DESCRIPTION

This class represents the rules for taking a single turn at the
game of Yahtzee. It provides methods for viewing the individual
dice, category matched, and other information useful for scoring.

=head1 BUGS AND LIMITATIONS

No known bugs. If you find one, please create an issue.

=head1 AUTHOR

Douglas L. Schrag

C<doug@theschrags.net>

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2014 by Douglas L. Schrag

This is free software, licensed under:

The Artistic License, Version 2.0, 2006
