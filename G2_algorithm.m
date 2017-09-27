%==============================================%
%=  MATLAB Implementation of G1 Algorithm for =%
%=  Numerically differintegrating a function. =%
%==============================================%
clear;

N = 101;
a = 0;
b = 3;
x = linspace(a,b,N);
f = (x-1).*(x-2).*(x-3);
q = 0.5;
D = zeros(1,N);     % The differintegral.
D(1,1) = f(2) + 0.25*q*(f(1) - f(3)) + q^2/8*(f(1) - 2*f(2) + f(1));
F_previous = D(1,1);

for i = 2:N-1
    for j = 2:i
        F_current = F_previous*(i-j-q)/(i-j+1) + f(j) + ...
            0.25*q*(f(j-1) - f(j+1)) + ...
            0.125*q^2*(f(j-1) - 2*f(j) + f(j+1));
        F_previous = F_current;
    end
    D(1,i) = (i/x(i))^q*F_current;
end

plot(x,f,'k',x,D,'r')