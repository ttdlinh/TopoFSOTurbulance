function Inputnodes(k,M)
%k = 3;
S = k*1000 ; % sinh cac diem trong khoi (k*1000)*(k*1000)*100
%M = 10; % so node dc sinh ra
D = floor((M*(M-1))/17); % so luong yeu cau dc sinh ra
fid = fopen('inputnodes.txt','w');
fprintf(fid,'#He so k la\n');
fprintf(fid,'%-0.1f\n',k);
fprintf(fid,'#Number of Nodes\n');
fprintf(fid,'%d\n',M);
fprintf(fid,'# list of nodes \n');
fprintf(fid,'#x #y #z \n');
x = zeros(1,M);
y = zeros(1,M);
z = zeros(1,M);
for i=1:M
    x(i)=S*rand;    % x duoc chon random tu 1 den S
    y(i)=S*rand;    % y duoc chon random tu 1 den S
    z(i)=100*rand;  % z duoc chon random tu 1 den 100
end
V = [x;y;z];
fprintf(fid,'%-0.2f %-0.2f %-0.2f\n',V);
fprintf(fid,'#nguong BER \n');
fprintf(fid,'0.001\n');
fprintf(fid,'#Ma tran yeu cau D \n');
fprintf(fid,'#source_index dest_index bw don vi Mbps \n');
bw=zeros(M);
for i=1:M
    for j=1:M
        if i<j
            bw(i,j)=randi([100 300]);            
            [a,b,bww]=find(bw);
            if a<b
            bwidth = [a,b,bww]; % tat ca cac yeu cau duoc sinh ra tu M nodes
            end
        end
    end
end
n=randperm(M*(M-1)/2,D); % vector hang chua D cac so rieng biet tu 1 den M*(M-1)/2
index=bwidth(n,:); % n: chi so hang cua 'bwidth'
fprintf(fid,'%d %d %d\n',index');
fclose(fid);
type inputnodes.txt
