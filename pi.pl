#!/usr/bin/perl
# Compute pi to 1000 decimal places using the Chudnovsky algorithm
# with binary splitting. Uses Math::BigInt/BigFloat (core).
# For faster runs, install Math::BigInt::GMP.

use strict;
use warnings;
use Math::BigInt try => 'GMP';
use Math::BigFloat;

use constant C3_OVER_24 => Math::BigInt->new('10939058860032000');

sub bs {
    my ($a, $b) = @_;
    if ($b - $a == 1) {
        my ($P, $Q);
        if ($a == 0) {
            $P = Math::BigInt->bone;
            $Q = Math::BigInt->bone;
        } else {
            $P = Math::BigInt->new(6 * $a - 5)
                ->bmul(2 * $a - 1)
                ->bmul(6 * $a - 1);
            $Q = Math::BigInt->new($a)->bmul($a)->bmul($a)->bmul(C3_OVER_24);
        }
        my $T = Math::BigInt->new('545140134')
            ->bmul($a)
            ->badd('13591409')
            ->bmul($P);
        $T->bneg if $a & 1;
        return ($P, $Q, $T);
    }
    my $m = int(($a + $b) / 2);
    my ($P1, $Q1, $T1) = bs($a, $m);
    my ($P2, $Q2, $T2) = bs($m, $b);
    my $P = $P1 * $P2;
    my $Q = $Q1 * $Q2;
    my $T = $Q2 * $T1 + $P1 * $T2;
    return ($P, $Q, $T);
}

my $digits = 1000;
my $n = int($digits / 14) + 2;

my (undef, $Q, $T) = bs(0, $n);

Math::BigFloat->precision(-($digits + 5));
my $sqrt_c = Math::BigFloat->new(10005)->bsqrt;
my $num = Math::BigFloat->new($Q)->bmul(426880)->bmul($sqrt_c);
my $pi = $num->bdiv(Math::BigFloat->new($T));

my $str = $pi->bfround(-$digits)->bstr;
print "$str\n";
