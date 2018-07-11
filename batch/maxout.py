from decimal import *
import sys, time

digits = 1000
sys.setrecursionlimit(10**6)
getcontext().prec = digits

def factorial(n):
    if n<1:
        return 1
    else:
        return n * factorial(n-1)

def chudnovskyBig(n): #http://en.wikipedia.org/wiki/Chudnovsky_algorithm
    pi = Decimal(0)
    k = 0
    while k < n:
        pi += (Decimal(-1)**k)*(Decimal(factorial(6*k))/((factorial(k)**3)*(factorial(3*k)))* (13591409+545140134*k)/(640320**(3*k)))
        k += 1
    return (pi * Decimal(10005).sqrt()/4270934400)**(-1)

def main():
  start_time = time.time()
  print("\nPi: " + str(chudnovskyBig(digits)))
  end_time = time.time()
  print("\nTotal time: " + str(end_time - start_time))


if __name__== "__main__":
  main()
