# Compute pi to 1000 decimal places using the Chudnovsky algorithm
# with binary splitting. Uses gmp (bigz) for integers and Rmpfr
# for the final square root / division.
#
# Run: Rscript pi.R

suppressPackageStartupMessages({
  library(gmp)
  library(Rmpfr)
})

C3_OVER_24 <- as.bigz("10939058860032000")

bs <- function(a, b) {
  if (b - a == 1) {
    if (a == 0) {
      P <- as.bigz(1)
      Q <- as.bigz(1)
    } else {
      a_bz <- as.bigz(a)
      P <- (6L * a_bz - 5L) * (2L * a_bz - 1L) * (6L * a_bz - 1L)
      Q <- a_bz * a_bz * a_bz * C3_OVER_24
    }
    Tt <- P * (as.bigz("13591409") + as.bigz("545140134") * as.bigz(a))
    if (a %% 2L == 1L) Tt <- -Tt
    return(list(P = P, Q = Q, T = Tt))
  }
  m <- (a + b) %/% 2L
  L <- bs(a, m)
  R <- bs(m, b)
  list(
    P = L$P * R$P,
    Q = L$Q * R$Q,
    T = R$Q * L$T + L$P * R$T
  )
}

digits <- 1000L
n <- digits %/% 14L + 2L
r <- bs(0L, n)

prec_bits <- ceiling(digits * log2(10)) + 64L
Q <- mpfr(as.character(r$Q), prec_bits)
Tt <- mpfr(as.character(r$T), prec_bits)
sqrt_c <- sqrt(mpfr(10005, prec_bits))
pi_val <- (Q * mpfr(426880, prec_bits) * sqrt_c) / Tt

cat(formatMpfr(pi_val, digits = digits + 1L), "\n", sep = "")
