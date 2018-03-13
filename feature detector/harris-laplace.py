import numpy as np
import cv2
from matplotlib import pyplot as plt

rgb_im = cv2.imread('pentagon.tiff')

alpha = 0.5

# Need to calculate directional derivatives in 'x' and 'y' directions.
im = cv2.cvtColor(rgb_im, cv2.COLOR_RGB2GRAY) # Convert to one-band image.
siz = np.shape(im)

Ix = np.zeros(siz)
Iy = np.zeros(siz)

for i in range(siz[0]):
    Ix[i,:] = GL(alpha, im[i,:], 0, 1, siz[0])
    Iy[:,i] = GL(alpha, im[:,i], 0, 1, siz[0])
    
sigma = 1
Ix2 = cv2.GaussianBlur(np.multiply(Ix, Ix), (5,5), sigma)
Iy2 = cv2.GaussianBlur(np.multiply(Iy, Iy), (5,5), sigma)
Ixy = cv2.GaussianBlur(np.multiply(Ix, Iy), (5,5), sigma)

# Corner image
#cim = (np.multiply(Ix2,Iy2) - np.multiply(Ixy,Ixy)) \
#- 0.04*np.multiply(Ix2 + Iy2, Ix2 + Iy2)

T = Ix2 + Iy2
D = np.multiply(Ix2, Iy2) - np.multiply(Ixy, Ixy)

cim = T/2 - np.sqrt(np.multiply(T, T)/4 - D)

# Attempt at non-max suppression code, adapted from Kovesi.

def nonmax(cim, radius = 1):
    sze = 2*radius + 1
    thresh = 0
    
    # Extract local maxima by performing a grayscale morphological
    # dilation and then finding points in the corner strength image
    # that match the dilated image and are also above the threshold.
    kern = cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(sze,sze))
    mx = cv2.dilate(cim, kern)
    
    # Excluding points within radius of the image boundary.
    full_size = np.shape(cim)
    size_without_borders_x = full_size[0] - 2
    size_without_borders_y = full_size[1] - 2
    
    bordermask = np.zeros(size_without_borders_x, size_without_borders_y)
    cimmx = (cim == mx) and (cim > thresh) and bordermask
    
    [r,c] = find(cimmx)
    
    return [r,c]
