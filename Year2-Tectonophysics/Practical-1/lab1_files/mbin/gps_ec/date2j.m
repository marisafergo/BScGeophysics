function J = date2j(yy,mm,dd)

% DATE2J	Returns the Modified Julian Date (MJD) for a given year, month and day
%		(with fraction of a day if hours, min., sec. are given).
%		Call: J = date2j([yy m d h min sec]) OR J = date2j(yy,m,d)
%
%		date = n x 6 matrix of [year month day hour min sec] for each epoch
%                     Years are two digits long. The [hour min sec] are optional.
%		OR
%		year =  n x 1 vector of two-digit years
%		month = n x 1 vector of months
%		day =   n x 1 vector of days
%
%		J =    n x 1 vector of Modified Julian Dates
%
%		[n = number of epochs]
%
%		1900 is added to the year values if they are greater than 80,
%		otherwise 2000 is added.
%		Note: add 2400000.5 to the MJD to get the Julian Date (JD).

extra=0;
if nargin == 1
   if size(yy,2)>3
     extra=yy(:,4)*3600;
     if size(yy,2)>4
       extra=extra+yy(:,5)*60;
       if size(yy,2)>5
         extra=extra+yy(:,6);
       end
     end
   end
   mm=yy(:,2);
   dd=yy(:,3);
   yy=yy(:,1);
end

yy=yy+(yy<100)*1900+(yy<80)*100;
J=floor(365.25*(yy-(mm<=2)))+floor(30.6001*(mm+1+12*(mm<=2)))+dd-679019+extra/86400;
