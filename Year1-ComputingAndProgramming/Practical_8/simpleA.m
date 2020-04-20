A simple exercises


 % PART I
for i = 10:-1:1
   disp (num2str(i));
end 



% PART II
for j = 0:4:50
    disp (num2str(j));
end 




% PART III
sm = 1;    % initialize variable storing sum
int = 1;   % initialize variable storing integer

while (sm < 1000) % repeat while sum is less than a thousand 
   disp(sm) 
   int = int + 1;
   sm = sm + int;
end



% PART IV
k = 1;
sm = 1;
pm = 1;


while (sm < 1000)
  disp(sm); 
  
   k = k + 1;
   
   pm = pm*(-1);
   
   sm = sm + k^(2*pm);  
  
end 
% 

% aqui nao precisamos de um if statement pois pm vai ter sempre um valor 
% diferente 
% na primeira round vai ser -2 e na segunda sera 2 e assim sucessivamente
% pois o valor estara constantemente a mudar. k e sm serao iguais a 1
% porque eles comecam em um.

    
PART V
matrix = zeros(5,5);

for i=1:1:5
   matrix(i,i) = 1 
   matrix(i,6-i) = 1
end


% PART VI
matrix = zeros(5,5);
shift = 0;

for i=1:1:5
  for j=1+shift:2:5
     matrix(i,j) = 1;
  end 
  shift = shift - (-1)^(i);
end






