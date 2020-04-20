function velocity = savage2000(x,in)
%velocity = savage2000(x,in)
%  Savage (2000) viscoelastic coupling model for
%    2D strike-slip fault
%
%  in(1) = slip_rate   velocity will have same units
%  in(2) = t           time since last earthquake (years)
%  in(3) = T           Earthquake recurrence time
%  in(4) = Tr          Relaxation (Maxwell) time (2*eta/mu)
%  in(5) = D           depth of faulting
%  in(6) = H           thickness of elastic layer
%
slip_rate = in(1);
t = in(2);
T = in(3);
Tr = in(4);
D = in(5);
H = in(6);

num_n = 50;

elastic = screw2d(x, 0, num_n*D, slip_rate);


x = repmat(x,num_n,1);
n = repmat([1:num_n]',1,length(x(1,:)));

F = findF(x,D,H,n);

T = findT(t,T,Tr);
%T

T = repmat(T,1,length(x(1,:)));

%  First term is elastic component, second term is the viscoleastic

velocity = elastic + (slip_rate/pi)*sum(F.*T);

%---

function F = findF(x,D,H,n)

F = atan( 2*x*D ./ (x.*x + (2*n.*H).^2 - D^2));


%---

function T = findT(t,T,Tr)

num_n = 50;

n = repmat([1:num_n]',1,1001);
k = repmat([0:1000],num_n,1);

leftside = sum( (exp(-k.*T./Tr).*((t + k.*T) ./ Tr).^(n-1)) , 2);

for(i=1:num_n)
    nfact(i) = factorial(i-1);
end

nfact = nfact';


T = (T./Tr).*(exp(-t./Tr)./nfact).*leftside;
