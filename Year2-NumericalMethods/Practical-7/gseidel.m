function [ ] = gseidel( A,b,miner,maxit )
% This MATLAB function performs the Gauss-Seidel method
% to solve a linear system of the form [A]{x}={b}
% independently of the dimensions of the system

% ______________________________________________________________
%|                   Abdullah and Marisabel                     |
%|                       13/11/2017                             |
%|______________________________________________________________|



% ______________________________________________________________
%|                         Relevant nomenclature                         
%|______________________________________________________________

% A: square nxn matrix
% b: column vector
% xo: initial/previous value of x
% xn: new value of x
% maxit: maxiumum number of iterations
% miner: minimum error limit
% ea: approximate error


% ______________________________________________________________
%|                         Relevant equations                      
%|______________________________________________________________

% Equation needed to find xn:   x_j = (b_j-a_jk*x_k-a_jk*x_k)/a_jj   (1)
% this equation was divided into two parts as a_jj is independent of x_j


% Equation to find the approximate error:  ea = abs(xn(j)-xo(j));    (2)




xo = zeros(length(b),1);     % column vector containing zero values to 
                             % to later store the new values of xo


for i = 1:1:maxit                        % for loop looping over the
                                         % maximum number of iterations
    
          emax = 0;
                
   for j = 1:1:length(b)                 % for loop looping over the 
                                         % number of equations needed to
                                         % find xn values, where the number
                                         % of equations equals the length
                                         % of b
                                         
           sm = 0;
              
           
       for k = 1:1:length(b)             % for loop looping over the sum
                                         % to calculate the xn values
           
           if j ~= k
               
           sm = sm + ( xo(k,1)*A(j,k) );     % part 1 of equation (1)
      
           end
           
         xn(j,1) =  (b(j,1) - sm) / A(j,j);  % part 2 of equation (1)
       
       
       end
       
       ea = abs(xn(j,1)-xo(j,1));
       
       if (ea > emax)      % if ea is bigger than 0, let the maximum
          emax = ea;       % approximate error equal the maximum error
       end 
      
           xo(j,1) = xn(j,1);  % setting the new value of x as the previous
             
   end
   
    if (emax <= miner)   % when the maximum error value equals the minimum 
     break               % error provided, stop runing the script
    end 
 
end

  disp(xn)
       
end


% ______________________________________________________________
%|                              END                    
%|______________________________________________________________
