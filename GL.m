function result = GL(alpha, f, start, term)
% Computes the GL fractional derivative 

num_points = max(size(f));

x = linspace(start,term,num_points);
step_size = x(2) - x(1);
b_coeffs = GLcoeffs(alpha, num_points-1);

B = fft(b_coeffs);
F = fft(f);

%size(B)
%size(F)

result = ifft(F.*B)*step_size^-alpha;