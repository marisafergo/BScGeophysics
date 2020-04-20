function write_psvelo(file_name,data);

% WRITE_PSVELO

fid = fopen(file_name,'w');
fprintf(fid,'%.4f %.4f %.2f %.2f %.2f %.2f %g\n',data');
fclose(fid);

