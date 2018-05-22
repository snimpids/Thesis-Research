function [Ix, Iy] = GLderiv(im, alpha)

shape = size(im);
M = shape(1);
N = shape(2);

% Calculate derivatives with respect to x.
Ix = zeros(shape);
for i = 1:M
    Ix(i,:) = GL(alpha,im(i,:),0,1);
end

% Calculate derivatives with respect to y.
Iy = zeros(shape);
for j = 1:N
    Iy(:,j) = GL(alpha,im(:,j)',0,1);
end