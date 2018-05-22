function GL_filter = GLcoeffs(alpha, n)
% Computes the GL coefficient array of size n.

GL_filter = zeros(1,n+1);
GL_filter(1,1) = 1;

for i = 1:n
    GL_filter(1,i+1) = (-alpha + (i-1))*GL_filter(1,i)/(i);
end;