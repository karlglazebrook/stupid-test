"""Compute pi to 1000 decimal places using the Chudnovsky algorithm with binary splitting."""

from decimal import Decimal, getcontext


def binary_split(a, b):
    if b - a == 1:
        if a == 0:
            Pab = Qab = 1
        else:
            Pab = (6 * a - 5) * (2 * a - 1) * (6 * a - 1)
            Qab = a * a * a * 10939058860032000
        Tab = Pab * (13591409 + 545140134 * a)
        if a & 1:
            Tab = -Tab
        return Pab, Qab, Tab
    m = (a + b) // 2
    Pam, Qam, Tam = binary_split(a, m)
    Pmb, Qmb, Tmb = binary_split(m, b)
    return Pam * Pmb, Qam * Qmb, Qmb * Tam + Pam * Tmb


def chudnovsky(digits):
    getcontext().prec = digits + 10
    n = digits // 14 + 2
    P, Q, T = binary_split(0, n)
    sqrt_c = Decimal(10005).sqrt()
    pi = (Q * 426880 * sqrt_c) / T
    return +pi.quantize(Decimal(10) ** -digits)


if __name__ == "__main__":
    pi = chudnovsky(1000)
    print(pi)
