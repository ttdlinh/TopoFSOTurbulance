function OutputTopo
load('varicurrent')

name_fileTopo=strcat('../../input_output_Topo/outputTopoHeur',num2str(k),'M',num2str(M), 'D',num2str(D),'.txt');
fid = fopen(name_fileTopo,'w');
fprintf(fid,'# Information TopoFSO\n');
fprintf(fid,'# Dien tich dat Topo la: S=(k*1000)*(k*1000)*100   (voi k=%d)\n',k);
fprintf(fid,'# So node cua Topo la:   M=%d      (voi M~=k^2)\n',M);
fprintf(fid,'# Tong so yeu cau cho Topo la:   D=%d      \n',D);
fprintf(fid,'# Information TopoFSO\n\n\n');
fprintf(fid,'Thoi gian bat dau chuong trinh la:         %d %d %d %d %d %-0.4f\n',timecurrent);
fprintf(fid,'Thoi gian doc xong file input la:          %-0.4f\n',timeinput);
fprintf(fid,'Thoi gian tinh xong BER va Weight la:      %-0.4f\n',timeweight);
fprintf(fid,'Thoi gian chay het chuong trinh la:        %-0.4f\n\n',timeTopo);
fprintf(fid,'Tong so link su dung la:    %d\n',tonglink);
fprintf(fid,'Tong so BER tren Topo la:    %d\n',tongBER);

LinkW=Tw;
for i=1:M
    for j=1:M
        if i<j
            LinkW(i,j)=0;
            [a,b,LinkWW]=find(LinkW);            
        end
    end
end
fprintf(fid,'Tat ca cac link su dung trong Topo la: \n');
for q=1:numel(LinkWW)
    fprintf(fid,'           (%d,%d)\n',a(q),b(q));
end
fprintf(fid,'Do dai duong di thuc la: \n');
fprintf(fid,'#source_index(s)      #dest_index(t)       #bandwidth(bw Mbps)       #BER_thuc_te          #path\n');
Inpath2=Inpath;
for i=1:D
    Inpath1=mat2str(Inpath2{i});
    fprintf(fid,'   s=%d                 t=%d                  bw=%d                   %e            path=%s\n',s(i),t(i),bw(i),distK(i),Inpath1);
end
fclose(fid);
%type OutputTopo.txt