function [Y,M,DoM,DoY,GPSW,DoGPSW,SoGPSW,JD,DecY] = gpsdate(varargin)

% GPSDATE	Converts date between various formats.
%
%		Input can be:
%		  Julian day 
%		  Decimal year
%		  Year, Day of Year
%		  Year, Month, Day, Hour, Min, Sec
%
%		Returns: year, month, day of month, day of year, GPS week,
%			 day of GPS week, second of GPS week, Julian day,
%			 decimal year.
%
%		Usage:
%		  [Y,M,DoM,DoY,GPSW,DoGPSW,SoGPSW,JD,DecY] = gpsdate(varargin)
%		  
% Written by T. Dautermann
% Vectorized by EC

switch nargin
    % Julian Date or Decimal Year entered
    case 1
        % Runs this path if JD
        % ***Warning: doesn't work properly for JD <= 10,000
        if varargin{1} > 10000
            % retrieval of the Julian Date
            JD = varargin{1};
            
            % Calculation of the Decimal Year
            DecY = (JD - 2451545.0)./365.25 + 2000;
        % Runs this path is Decimal Year
        else
            % retrieval of the Decimal Year
            DecY = varargin{1};

            % calculation of the Julian Date
            JD = 2451545.0 + (DecY - 2000).*365.25;
        end
        
        % Calculations for Day of the Month, Month, and Year
        a = fix(JD + 0.5);
        b = a + 1537;
        c = fix((b - 122.1)./365.25);
        d = fix(365.25.*c);
        e = fix((b - d)./30.6001);
        DoM = b - d - fix(30.6001.*e) + (JD + 0.5) - fix(JD + 0.5);
        M = e - 1 - 12.*fix(e./14);
        Y = c - 4715 - fix((7+M)./10);
        
        % Calculation of the Day of the Year
        I = ones(length(Y),1);
        DoY = datenum([Y M DoM]) - datenum([Y I I]) + 1;
        
    % Year, Day of Year entered
    case 2
        Y = varargin{1};
        DoY = varargin{2};
        
        % Calculation of the Decimal Year
        DecY = Y + (DoY - 1.5)./365.25;
        
        % calculation of the Julian Date
        JD = 2451545.0 + (DecY - 2000).*365.25;
        
        % Calculation of the Day of the Month, and the Month
        a = fix(JD + 0.5);
        b = a + 1537;
        c = fix((b - 122.1)./365.25);
        d = fix(365.25.*c);
        e = fix((b - d)./30.6001);
        DoM = b - d - fix(30.6001.*e) + (JD + 0.5) - fix(JD + 0.5);
        M = e - 1 - 12.*fix(e./14);
        
    % Year, Month, Day entered
    case 6
        Y = varargin{1};
        M = varargin{2};
        DoM = varargin{3};
        Hr = varargin{4};
        Mn = varargin{5};
        Sc = varargin{6};
        UT = Hr + Mn./60 + Sc ./3600;
        
        I = find(M==1 | M==2);
        Y(I) = Y(I) - 1;
        M(I) = M(I) + 12;
         y = Y;
         m = M;
        
        % calculation of the Julian Date
        JD = fix(365.25.*y) + fix(30.6001.*(m+1)) + DoM  + UT./24 + 1720981.5;
        
        % Calculation of the Decimal Year
        DecY = (JD - 2451545.0)./365.25 + 2000;
        
        % Calculation of the Day of the Year
        I = ones(length(Y),1);
        DoY = datenum([Y M DoM]) - datenum([Y I I]) + 1;
        
    otherwise
        error('Improper Inputs')
end

% calculation of GPS week
GPSW = fix((JD - 2444244.5)./7);

% calculation of day of the GPS Week
DoGPSW = round(((JD - 2444244.5)./7 - GPSW).*7);

% calculation of second of the GPS Week
SoGPSW = round(((JD - 2444244.5)./7 - GPSW).*7).*(24*60*60);
