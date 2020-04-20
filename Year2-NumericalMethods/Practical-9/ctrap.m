function [ I,h ] = ctrap( f,ll,ul,ni1 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% ll = -1; ul = 1; ni1 = 10; ni2 = 20
% [integral,iwidth] = ctrap(f,ll,ul,ni1)
% f=@(x) (1/sqrt(2*pi))*exp(-(x^2)/2)
% ctrap(f,-1,1,10)


sm = 0;

xn = ul;
x1 = ll;

n = ni1;

h = ( xn - x1 ) / ( n );


for i = ll+h:h:ul-h      % here we use ll+h and ul-h because in the composite 
                         % trapezoidal we go from i=2 to i=n-1 in the sum
                         % if it was from i=1 we would go from ll:h:ul-h
                         % remeber that n is i=n (the max number of x that 
                         % we have
    sm = sm +f(i);  
    
end

I = (h/2) * ( f(ll) + (2)*sm + f(ul) ); 

%disp([' The answer is: ' num2str(I) '.' ])

end

