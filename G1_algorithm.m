%==============================================%
%=  MATLAB Implementation of G1 Algorithm for =%
%=  Numerically differintegrating a function. =%
%==============================================%
clear;

N = 201;
a = 0;
b = 3;
x = linspace(a,b,N);
f = (x-1).*(x-2).*(x-3);
q = 0.5;
D = zeros(1,N);     % The differintegral.
f = fliplr(f);
% D(1,1) = f(1);

F_previous = f(1);

% Outer loop assigns differintegral sums to array D.
% Inner loop calculates differintegral at each point in the domain.

for i = 1:N
    for j = 1:i
        F_current = F_previous*(i-j-q)/(i-j+1) + f(j);
        F_previous = F_current;
    end
    D(1,i) = (i/x(i))^q*F_current;
end

figure(1);
plot(x,f,'k',x,D,'r')