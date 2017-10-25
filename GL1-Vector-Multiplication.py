import numpy as np
from scipy import special as sp
import time

def isInteger(n):
    """Return True if argument is a whole number, False if argument has a fractional part.

    Note that for values very close to an integer, this test breaks. During
    superficial testing the closest value to zero that evaluated correctly
    was 9.88131291682e-324. When dividing this number by 10, Python 2.7.1 evaluated
    the result to zero"""

    if n%2 == 0 or (n+1)%2 == 0:
        return True
    return False

def poch(a,n):
    # Returns the Pochhammer symbol (a)_n.
    
    # First, check if 'a' is a real number (this is currently only working for reals).
    if np.iscomplex(a):
        raise ValueError('Value "a" must be a real number.')
    elif n < 0:
        raise ValueError('Value "n" must be a positive integer.')
    elif isInteger(n) == False:
        raise ValueError('Value "n" must be an integer.')
    
    # Compute the Pochhammer symbol.
    if n == 0:
        poch = 1
        return poch
    else:
        poch = 1
        for j in range(0,n):
            poch *= (a + j)
        return poch

def GLcoeffs(alpha,n):
    # Computes the coefficient array of size n.
    if n < 0:
        raise ValueError('Value "n" must be positive.')
    elif isInteger(n) == False:
        raise ValueError('Value "n" must be an integer.')
        
    else:
        GL_filter = np.zeros(n,)
        for j in range(0,n):
            GL_filter[j] = poch(-alpha,j)/sp.factorial(j)
            #print(GL_filter[j])
    return GL_filter
  
N = 100
a = 0.
b = 1.
x = np.linspace(a,b,N)
q = 0.5

#print(x)

def f(x):
    return np.sqrt(x)
    
F = f(x)
A = GLcoeffs(q,N)
F = F[::-1]

GL_times = []
GL_faster_results = []

for i in range(0,100):
    GL_start = time.time()
    result = np.dot(A,F)*(N/b)**q    
    GL_times.append(time.time() - GL_start)
    GL_faster_results.append(result)

GL_faster = np.mean(GL_faster_results)
GL_time = np.mean(GL_times)

print(GL_faster)
print(GL_time)

true_value = 0.5*np.sqrt(np.pi)

abs_error = abs(GL_faster - true_value)
rel_error = abs(GL_faster - true_value)/abs(true_value)

print('Absolute error is: ' + str(abs_error) + '\n' + 'Relative error is: ' + str(rel_error))
