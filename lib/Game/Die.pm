package Game::Die;
use 5.014;
use warnings;

use Math::Random::OO qw(UniformInt); # Loads the subclass, function will be cleaned
my $PRNG_CLASS = 'Math::Random::OO::UniformInt';

use Moo;
use DLS::MooTypes;
use namespace::clean;

has sides => (
  is      =>  'ro',
  default =>  sub { 6 }, ## no critic (MagicNumber)
);

has _roller  =>  (
  is      =>  'lazy', # one of ->sides or ->_roller MUST be lazy
  builder =>  sub {
                my ($self) = @_;
                return $PRNG_CLASS->new(1, $self->sides);
              },
);

has spots => (
  is        =>  'lazy',
  builder   =>  sub { my ($self) = @_; $self->_roller->next; },
  clearer   =>  'roll',
  predicate =>  1,
);

# Class Method
#
# Since perl's rand/srand are used by Math::Random::OO::UniformInt,
# setting the seed globally affects perl's default random number
# generator.
#
# Consider using another PRNG if you need to use a seed and other
# parts of the program use rand/srand (directly or indirectly).

my $seed;

# use this for testing only
sub seed {
  my ($class, $integer) = @_;
  if (defined $integer) {
    DLS::MooTypes::Integer()->($integer);
    die 'Seed must be a positive integer!'  ## no critic (RequireCarping)
      if not ($integer > 0);
    # ignore if the seed has already been set
    $seed //= $PRNG_CLASS->seed($integer) || 0; # guard for absence of return value
  }
  return $seed;
}

1;

__END__

=head1 NAME

Game::Die

=head1 SYNOPSIS

    use Game::Die;
    my @dice = map { Game::Die->new() } 1 .. 2;
    my $throw;
    for my $die (@dice) {
      $die->roll;
      $throw += $die->spots;
    }

=head1 VERSION

=head1 DESCRIPTION

This class simulates a single die, as used in dice games.

=head1 CONSTRUCTOR

=head2 new [ options ... ]

Create a new die. By default, this is a conventional six-sided die.

=head3 Options

=over 4

=item sides

Specify the number of faces the die has (default 6).

=back

=head1 INSTANCE METHODS

=head2 spots

Returns the random number of spots on the top face of the die.

The first time the C<spots> method is accessed, the die is effectively rolled.
Subsequent accesses will return the same value of the die, unless the C<roll>
method is called in the interim, in which case the value will be a new random
number.

=head2 roll

Cause the next access of the C<spots> method to reflect a new roll of the die.

=head1 CLASS METHODS

=head2 seed [ <integer> ]

** USE THIS FOR TESTING ONLY **

Supply a seed value to the random number generator, for testing purposes. The
parameter must be a positive integer, of size acceptable to the PRNG. The
return value is the seed value used by the PRNG.

With no parameter, the method returns a previously set value of the seed, or
C<undef> if no seed has been used. If multiple attempts are made to set the
seed, only the first will be used.

Be wary of conflicting uses of perl's built-in random number generator
(C<rand / srand>).

=head1 DIAGNOSTICS

'Seed must be a positive integer!' - An attempt was made to set the PRNG seed
using something that doesn't look like a positive integer.

=head1 DEPENDENCIES

    DLS::MooTypes
    Math::Random::OO
    Moo
    namespace::clean

For testing:

    List::MoreUtils
    Test::Exception
    Test::More
    Test::Warnings

=head1 BUGS AND LIMITATIONS

Using Perl's built-in PRNG is problematic, because it is global. The builder
method C<_build__roller> may be overridden in a subclass to use a different
PRNG.

=head1 AUTHOR

Douglas L. Schrag

C<doug@theschrags.net>

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2014 by Douglas L. Schrag

This is free software, licensed under:

The Artistic License, Version 2.0, 2006
