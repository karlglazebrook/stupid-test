# Compute pi to 1000 decimal places using the Chudnovsky algorithm
# with binary splitting. Ruby's Integer is arbitrary precision natively.

require "bigdecimal"
require "bigdecimal/math"
require "bigdecimal/util"

C3_OVER_24 = 10_939_058_860_032_000

def bs(a, b)
  if b - a == 1
    if a == 0
      p_ab = 1
      q_ab = 1
    else
      p_ab = (6 * a - 5) * (2 * a - 1) * (6 * a - 1)
      q_ab = a * a * a * C3_OVER_24
    end
    t_ab = p_ab * (13_591_409 + 545_140_134 * a)
    t_ab = -t_ab if a.odd?
    return [p_ab, q_ab, t_ab]
  end
  m = (a + b) / 2
  p1, q1, t1 = bs(a, m)
  p2, q2, t2 = bs(m, b)
  [p1 * p2, q1 * q2, q2 * t1 + p1 * t2]
end

digits = 1000
n = digits / 14 + 2
_, q, t = bs(0, n)

prec = digits + 10
sqrt_c = BigDecimal(10_005).sqrt(prec)
pi = (BigDecimal(q) * 426_880 * sqrt_c) / BigDecimal(t)
puts pi.round(digits).to_s("F")
