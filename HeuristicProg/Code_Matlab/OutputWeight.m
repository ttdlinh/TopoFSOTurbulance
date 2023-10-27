function OutputWeight
fid = fopen('OutputWeight.txt','w');
load('varicurrent')
fprintf(fid,'# list of nodes \n');
fprintf(fid,'#x #y #z \n');
fprintf(fid,'%-0.2f %-0.2f %-0.2f\n',Node);
weight=zeros(M);
for i=1:M
    for j=1:M
        if i<j&&W(i,j)~=inf
            weight(i,j)=W(i,j);            
            [a,b,weight1]=find(weight);
            %if a<b
            weight2 = [a,b,weight1];
            %end
        end
    end
end
fprintf(fid,'\nList Weight giua cac node la:\n');
fprintf(fid,'%d %d %e\n',weight2');
fclose(fid);
type OutputWeight.txt
