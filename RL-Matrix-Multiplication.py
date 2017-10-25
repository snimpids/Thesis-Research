import numpy as np
from scipy import special as sp
import time

def RLMatrix(N,alpha):
    A = np.zeros((N,N))
    
    p = 1 - alpha
    
    for i in range(0,N-1):
        A[i,i] = (i+2)**p - (i+1)**p
        A[i,i+1] = (i+1)**p - (i+2)**p
    A[N-1,N-1] = p/(N**alpha)
    
    return A

def RLdifferint(F,A,a,b,N,alpha):
    h = (b-a)/N
    DF = (N/b)**alpha*np.dot(A,F)/sp.factorial(1-alpha)
    
    return DF
    
N = 100
a = 0.
b = 1.
x = np.linspace(a,b,N)
q = 0.5

def f(x):
    return np.sqrt(x)
    
F = f(x)
F = F[::-1]

RL_times = []
RL_results = []

A = RLMatrix(N,q)

for i in range(0,100):
    RL_start = time.time()
    DF = RLdifferint(F,A,a,b,N,q)
    RL_times.append(time.time() - RL_start)
    RL_results.append(DF)
    
RL_faster = np.mean(RL_results)
RL_time = np.mean(RL_times)

print(RL_faster*100)
print(RL_time)

true_value = 0.5*np.sqrt(np.pi)

abs_error = abs(RL_faster*100 - true_value)
rel_error = abs(RL_faster*100 - true_value)/abs(true_value)

print('Absolute error is: ' + str(abs_error) + '\n' + 'Relative error is: ' + str(rel_error))
