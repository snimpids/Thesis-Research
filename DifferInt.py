import numpy as np

def GL(alpha, f_name, domain_start = None, domain_end = None, num_points = None):
    """Computes the GL fractional derivative of a function at a point.
       
       Parameters
        ==========
        domain_start : float
            The left-endpoint of the function domain.
        domain_end : float
            The right-endpoint of the function domain; the point at which the 
            differintegral is being evaluated.
        num_points : integer
            The number of points in the domain.
        alpha : float
            The order of the differintegral to be computed.
        *argv : function handle
            Either a lambda function or elsewhere defined function. 
            This is the function that is to be differintegrated.
    """
    # Set the default domain left-endpoint and number of domain points.
    if domain_start == None:
        domain_start = 0.
    
    if num_points == None:
        num_points = 100
    
    # Define the function domain.
    x = np.linspace(domain_start, domain_end, num_points + 1)
        
    # Calculate the GL differintegral, avoiding the explicit calculation of
    # the gamma function.
    GL_previous = f_name(x[1])
    for index in range(1,num_points):
        GL_current = GL_previous*(num_points-alpha-index-1)/(num_points-index) + f_name(x[index+1])
        GL_previous = GL_current
        
    return GL_current*(num_points/(domain_end - domain_start))**alpha
