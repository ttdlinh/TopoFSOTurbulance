function OutputBER
load('varicurrent')
file_name = strcat('../../input_output_Topo/BERk',num2str(k),'m',num2str(M), 'D',num2str(D));
line_1 = {'#','list','of','nodes'};
xlswrite(file_name,line_1,'','A1');
line_2 = {'#x','#y','#z'};
xlswrite(file_name,line_2,'','A2');
%insert data ma tran toa do
xlswrite(file_name,Node','','A3');
list_ber_line = {'List','BER','giua','cac','node','la:'};
xls_range_next = strcat('A',num2str(2+M+2));
xlswrite(file_name,list_ber_line,'',xls_range_next);

ber=zeros(M);
for i=1:M
    for j=1:M  
        ber(i,j)=BER(i,j);  
        if ber(i,j)==0
            ber(i,j)=100;
        end
        if i==j
            ber(i,j)=0;
        end
    end
end
[a,b,berr]=find(ber);
for m=1:M*(M-1)
    if berr(m) ==100
        berr(m)=0;
    end
end
berrr=[b,a,berr];
xls_range_next = strcat('A',num2str(2+M+3));
xlswrite(file_name,berrr,'',xls_range_next);
% fprintf(fid,'\nList BER giua cac node la:\n');
% fprintf(fid,'%d %d %e\n',berrr');
% fclose(fid);
% type OutputBER.txt
