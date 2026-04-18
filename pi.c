/* Compute pi to 1000 decimal places using the Chudnovsky algorithm
 * with binary splitting and GMP for arbitrary precision arithmetic.
 *
 * Build: gcc -O2 -o pi pi.c -lgmp
 */

#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>

#define DIGITS 1000
#define C3_OVER_24 10939058860032000UL

static void bs(unsigned long a, unsigned long b, mpz_t P, mpz_t Q, mpz_t T) {
    if (b - a == 1) {
        if (a == 0) {
            mpz_set_ui(P, 1);
            mpz_set_ui(Q, 1);
        } else {
            mpz_set_ui(P, 6 * a - 5);
            mpz_mul_ui(P, P, 2 * a - 1);
            mpz_mul_ui(P, P, 6 * a - 1);
            mpz_set_ui(Q, a);
            mpz_mul_ui(Q, Q, a);
            mpz_mul_ui(Q, Q, a);
            mpz_mul_ui(Q, Q, C3_OVER_24);
        }
        mpz_set_ui(T, 545140134);
        mpz_mul_ui(T, T, a);
        mpz_add_ui(T, T, 13591409);
        mpz_mul(T, T, P);
        if (a & 1) mpz_neg(T, T);
        return;
    }
    unsigned long m = (a + b) / 2;
    mpz_t P1, Q1, T1, P2, Q2, T2;
    mpz_inits(P1, Q1, T1, P2, Q2, T2, NULL);
    bs(a, m, P1, Q1, T1);
    bs(m, b, P2, Q2, T2);
    mpz_mul(P, P1, P2);
    mpz_mul(Q, Q1, Q2);
    mpz_mul(T, Q2, T1);
    mpz_addmul(T, P1, T2);
    mpz_clears(P1, Q1, T1, P2, Q2, T2, NULL);
}

int main(void) {
    unsigned long digits = DIGITS;
    unsigned long prec_bits = (unsigned long)(digits * 3.3219280948873626) + 64;
    unsigned long n = digits / 14 + 2;

    mpz_t P, Q, T;
    mpz_inits(P, Q, T, NULL);
    bs(0, n, P, Q, T);

    mpf_set_default_prec(prec_bits);
    mpf_t pi, num, den, sqrt_c;
    mpf_inits(pi, num, den, sqrt_c, NULL);

    mpf_set_z(num, Q);
    mpf_mul_ui(num, num, 426880);
    mpf_set_ui(sqrt_c, 10005);
    mpf_sqrt(sqrt_c, sqrt_c);
    mpf_mul(num, num, sqrt_c);

    mpf_set_z(den, T);
    mpf_div(pi, num, den);

    gmp_printf("%.*Ff\n", (int)digits, pi);

    mpf_clears(pi, num, den, sqrt_c, NULL);
    mpz_clears(P, Q, T, NULL);
    return 0;
}
