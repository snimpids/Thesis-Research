%==============================================%
%=  MATLAB Implementation of G1 Algorithm for =%
%=  Numerically differintegrating a function. =%
%==============================================%
clear;

N = 101;
a = 0;
b = 3;
x = linspace(b,a,N);
f = (x-1).*(x-2).*(x-3);
q = 0.5;
D = zeros(1,N);     % The differintegral.
D(1,1) = f(1);
F_previous = f(1);

for i = 2:N
    for j = 2:i
        F_current = F_previous*(i-j-q)/(i-j+1) + f(j);
        F_previous = F_current;
    end
    D(1,i) = (i/x(i))^q*F_current;
end

% Comparing to the analytic differintegral.
AD = (Gamma(2)/Gamma(4-q)).*x.^(3-q)...
    - 6*x.^(2-q)./Gamma(3-q)...
    + 11*x.^(1-q)./Gamma(2-q)...
    - 6*x.^(-q)./Gamma(1-q);

FD = fracderivative(f,32,q,'x');

g = 3.*x.^2 - 12*x + 11;

figure(2);
plot(x,f,'k',x,D,'r')
