from sage.misc.randstate import random
import hashlib

#Extended Euclidean Algorithm
def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)

#Elliptic Curve defined by y^2 = x^3 + a*x + b 
#Used secp112r1
F = FiniteField(4451685225093714772084598273548427)
C = EllipticCurve(F, [4451685225093714772084598273548424, 2061118396808653202902996166388514])
print(C)

#Generator G
G = C.point((188281465057972534892223778713752, 3419875491033170827167861896082688))
n = G.order()
print('G = {}\nn = {}'.format(G, G.order()))

#keyPair
da = random() % n
Qa = G*da
print('KeyPair(Qa, da) = ({}, {})'.format(Qa, da))

#calculate the hash
m = "oi"
hash_func = hashlib.sha256()
hash_func.update(bytearray(m))
e = int(hash_func.digest().encode('hex'), 16)
print('e = HASH256(m) = {}'.format(e))

####SIGNING####
k = random() % n
R = G * k
r = Integer(R.xy()[0])
print('k = {}\nR = G*k = {}'.format(k, R))

s = ((e + da*r)/k) % n
print('Signature (r, s) = ({}, {})'.format(r,s))

####VERIFY####
w = egcd(s, n)[1] % n
P = ((e*w)%n)*G + ((r*w)%n)*Qa
print('P = u1*G + u2*Qa = {}\nValidation result = {}'.format(P, P.xy()[0] == r))