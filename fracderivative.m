% This function is based on work by Mathieu, Melchor, Oustaloup, and
% Ceyral (2003), "Fractional differentiation for edge detection", Signal
% Processing, 83, pp. 2421-2432.

% Inputs:
% =======
% im         := image which will be differentiated
% m          := size of fractional derivative mask/filter
% varargin   := 'x' or 'y'; direction of the derivative
% alpha      := order of fractional derivative; this may be real or complex
%             scalar
% Outputs:
% ========
% varargout  := differentiated image with respect to varargin with order alpha

function varargout = fracderivative(im, m, alpha, varargin)
varargin = varargin(:);
varargout = cell(size(varargin)); 

% Initialize arrays for storing the fractional binomial coefficients and
% the convolution mask.

a = zeros(1,m);
D = zeros(1, 2*m+1);  % This will contain the fractional derivative coefficients.

for i = 1:m
    a(i) = general_nchoosek(alpha, i);
end;
D(1,1:m) = fliplr(a);
D(1, m+2:2*m+1) = -a;

% T = ['Fractional Derivative of order $$\alpha=$$',num2str(alpha),', $$N=$$',num2str(m)];
% plot(D); title(T,'interpreter','latex'); xlim([1,length(D)]);

for n = 1:length(varargin)
      if strcmpi('x', varargin{n})
          varargout{n} = conv2(im, D, 'same');
      elseif strcmpi('y', varargin{n})
          varargout{n} = conv2(im, D', 'same');
      elseif strcmpi('xy', varargin{n}) || strcmpi('yx', varargin{n})
          varargout{n} = conv2(conv2(im, D, 'same'), D', 'same');
      else
          error(sprintf('''%s'' is an unrecognized derivative option',varargin{n}));
      end;
end;

% Usage: general_nchoosek.m takes a number 'a', real or complex, and
%        calculates a choose k.
% Inputs:
% =======
% a :=    scalar input; can be real, complex, integer, float, etc.
% k :=    integer input; number of choices of a.

function A = general_nchoosek(a,k)
A = (-1)^k*Gamma(a+1)/(Gamma(k+1)*Gamma(a-k+1));