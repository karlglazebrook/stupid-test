REM Compute pi to 1000 decimal places using the Rabinowitz-Wagon
REM spigot algorithm. Uses only small-integer arithmetic on an
REM array of remainders - no bignum needed.
REM
REM Run: yabasic pi.bas

n = 1001
ln = int(10 * n / 3) + 1
dim a(ln)

for i = 1 to ln
    a(i) = 2
next i

nines = 0
predig = 0

for j = 1 to n
    q = 0
    for i = ln to 1 step -1
        x = 10 * a(i) + q * i
        d = 2 * i - 1
        q = int(x / d)
        a(i) = x - q * d
    next i
    a(1) = mod(q, 10)
    q = int(q / 10)

    if q = 9 then
        nines = nines + 1
    elsif q = 10 then
        print chr$(48 + predig + 1);
        for k = 1 to nines : print "0"; : next k
        predig = 0
        nines = 0
    else
        if j > 1 then print chr$(48 + predig); fi
        if j = 2 then print "."; fi
        for k = 1 to nines : print "9"; : next k
        predig = q
        nines = 0
    endif
next j

print chr$(48 + predig);
for k = 1 to nines : print "9"; : next k
print
