function D = CRONE(siz, alpha)
% Computes the CRONE differentiation filter of size 'siz'.

% 'siz' is the width/height of the image to be differentiated.

% Change size of filter depending on whether siz is odd or even.
if mod(siz, 2) ~= 0
    w = siz;
    stop = (siz-1)/2;
else
    w = siz + 1;
    stop = siz/2;
end;

D = zeros(1, w);

D(1, stop:-1:1) = GLcoeffs(alpha, stop-1);
D(1, stop+2:end) = -D(1, stop:-1:1);