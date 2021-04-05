function [ price ] = Mellin_NIG_European_Price( S_0, W, T, r, q, call, alpha, beta, delta, N1, tol)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% About: Pricing Function for European Options using Mellin Transform
% Models Supported: Normal Inverse Gaussian (NIG)
% Returns: price of contract
% Author: Justin Lars Kirkby/ Jean-Philippe Aguilar
%
% Reference: 1) "Closed-form option pricing in exponential Levy models", Aguilar and Kirkby, 2021
%            2) "Pricing, risk and volatility in subordinated marketmodels", Aguilar, Kirkby, Korbel, 2020
%
% ----------------------
% Contract/Model Params 
% ----------------------
% S_0 = initial stock price (e.g. 100)
% W   = strike  (e.g. 100)
% r   = interest rate (e.g. 0.05)
% q   = dividend yield (e.g. 0.05)
% T   = time remaining until maturity (in years, e.g. T=1)
% call  = 1 for call (else put)
%
% alpha = param in model
% beta = param in model
% delta = param in model
%
% ----------------------
% Numerical Params 
% ----------------------
% N1  = maximum number summation terms in the series, will sum fewer terms
%       if error threshold (tol) is reached
% tol = desired error threshold of price (will stop adding terms once satisfied) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 11
    tol = 0;
end

N2 = N1;
N3 = N1;

gam = sqrt(alpha^2 - beta^2);
k0 = log(S_0/W) + (r - q + delta*(sqrt(alpha^2 - (beta + 1)^2) - gam))*T;
adt = alpha*delta*T;
dta = 0.5*delta*T/alpha;

sum = 0;
last = 0;
cons =  W*alpha*exp((gam*delta - r)*T)/sqrt(pi);
tol = tol/cons;

if beta == 0
    % Symmetric Formula
    for n1 = 0:N1
        fn1 = factorial(n1);
        for n2 = 1:N2
            d = n1 - n2;
            term = k0^n1 / (fn1 * gamma(1 - d/2) );
            term = term * besselk((d + 1)/2, adt) * (dta)^((1 - d)/2);
            sum = sum + term;
        end
        if n1 > 1 && abs(sum - last) < tol
            break;
        end
        last = sum;
    end
else
   % Asymmetric Formula
    for n1 = 0:N1
        fn1 = factorial(n1);
        for n2 = 0:N2
            fn2 = factorial(n2);
            for n3 = 1:N3
                g = pochhammer(-n1 + n3 + 1, n2);
                term = g * k0^n1 * beta^n2 / (fn1 * fn2 * gamma(1 + (-n1 + n2 + n3)/2) );
                term = term * besselk((n1 - n2 - n3 + 1)/2, adt) * (dta)^((-n1 + n2 + n3 + 1)/2);
                sum = sum + term;
            end
        end
        if n1 > 1 && abs(sum - last) < tol
            break;
        end
        last = sum;
    end
end


price = cons*sum;

if call ~= 1  % price put using put-call parity
    price = price - (S_0*exp(-q*T) - W*exp(-r*T));
end

end

function p = pochhammer(a, n)
if (a == 0 && n <= 0) || (n == 0 && a > 0)
    p = 1;
elseif a == 0 && n > 0
    p = 0;
elseif a > 0
    if n == 1
        p = a;  % uses Gamma(a + 1) = a * Gamma(a)
    elseif n > 0
        p = prod(a:a + n - 1);
        % p = gamma(a + n)/gamma(a); 
    else
        p = inf; % TODO: what happens when a - n < 0
    end
else  
    p = neg_poch(a, n);
end
    
end

function p = neg_poch(m, n)
% Used for (-m)_n, m >= 1

m = -m;

if n > m
    p = 0;
else
    p = (-1)^n * factorial(m) / factorial(m - n);
end

end

