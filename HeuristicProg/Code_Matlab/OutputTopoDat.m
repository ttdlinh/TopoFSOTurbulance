function OutputTopoDat
load('varicurrent');
name_FileDat=strcat('../../input_output_Topo/Final_programk',num2str(k),'m',num2str(M),'D',num2str(D), '.dat');
fid= fopen(name_FileDat,'w');
fprintf(fid,'n = %d;\n',M);
fprintf(fid,'alpha = 1;\n');
fprintf(fid,'beta = 0.001;\n');
fprintf(fid,'d = %d;\n',D);
fprintf(fid,'cap = %d;\n',Bwmax);
fprintf(fid,'\n');


fprintf(fid,'A = [');

for i=1:M
    fprintf(fid,'[%0.2f %0.2f %0.2f]\n',N(i,1),N(i,2),N(i,3));
end
fprintf(fid,'];\n');
fprintf(fid,'\n');
fprintf(fid,'D = [');
for i=1:D
    fprintf(fid,'[%d %d %d]\n',matrixD_output(i,1),matrixD_output(i,2),matrixD_output(i,3));
end
fprintf(fid,'];\n');
fprintf(fid,'BER_range = %d;\n',M*(M-1));
name_FileExcel=strcat('"BERk',num2str(k),'m',num2str(M),'D',num2str(D),'.xls"');
fprintf(fid,'SheetConnection my_sheet(');
fprintf(fid,name_FileExcel);
fprintf(fid,');\n');
start_line = M+5;
end_line = start_line + M*(M-1)-1;
text_44=strcat('BER from SheetRead(my_sheet,"''Sheet1''!C',num2str(start_line),':C',num2str(end_line),'");\n');
fprintf(fid,text_44);
fprintf(fid,'topo_file_name = ');
topo_file_name=strcat('"topoILPk',num2str(k),'m',num2str(M),'D', num2str(D),'.txt";\n');
fprintf(fid,topo_file_name);
result_file_name =strcat('result_file_name = "ResultsILPk',num2str(k),'m',num2str(M), 'D',num2str(D),'.txt";\n');
fprintf(fid,result_file_name);
fclose(fid);


