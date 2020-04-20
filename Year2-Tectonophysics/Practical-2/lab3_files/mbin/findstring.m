function idx=findstring(tab,str)
% find the row index containing a matching string
% returns 0 if the string is not found
[nrows,ncols]=size(tab);
for idx=1:nrows
    matches = findstr(tab(idx,:),str);
    if (length(matches)>0)
return;
    end;
end;
idx=0;
return;