function InputFSOdensity
k = 6;
M_init = 36;
M_max = 100;
step =2;
% load = 25%
S = k*1000 ; % sinh cac diem trong khoi (k*1000)*(k*1000)*100
%M = 10; % so node dc sinh ra
%D = floor(M*(M-1)/3+2); % so luong yeu cau dc sinh ra 
D=200;
%D = M_init*(M_init-1)/2;

M=M_init;
x = zeros(1,M);
y = zeros(1,M);
z = zeros(1,M);
for i=1:M
    x(i)=S*rand;    % x duoc chon random tu 1 den S
    y(i)=S*rand;    % y duoc chon random tu 1 den S
    z(i)=100*rand;  % z duoc chon random tu 1 den 100
end


% for i=1:D
%         s = randi([1,M]);
%         t = randi([1,M]);
%         while (s==t)
%             t=randi([1,Mde 
%         end
%         bwidth=randi([100 300]);
%         fprintf(fid,'%d %d %d\n', s, t, bwidth);
% end

requested_bw =zeros(M,M);
for j=1:M
    for i=(j+1):M
        requested_bw(i,j)=randi([100 300]);   
    end    
end
   
[a,b,bw] = find(requested_bw);
n=randperm(M*(M-1)/2,D); % vector hang chua D cac so rieng biet tu 1 den M*(M-1)/2


while (M<M_max)
    V = [x;y;z];
    
    fileFSOsite=strcat('inputnodes_Set22_k',num2str(k),'M',num2str(M),'D',num2str(D),'.txt');
    fid = fopen(fileFSOsite,'w');
    fprintf(fid,'#He so k la\n');
    fprintf(fid,'%-0.1f\n',k);
    fprintf(fid,'#Number of Nodes\n');
    fprintf(fid,'%d\n',M);
    fprintf(fid,'# list of nodes \n');
    fprintf(fid,'#x #y #z \n');
    
    fprintf(fid,'%-0.2f %-0.2f %-0.2f\n',V);
    fprintf(fid,'#nguong BER \n');
    fprintf(fid,'0.001\n');
    fprintf(fid,'#Ma tran yeu cau D \n');
    fprintf(fid,'#source_index dest_index bw don vi Mbps \n');
    
  
    % for i=1:M
    %     for j=1:M
    %         if i < j
    %             bw(i,j)=randi([100 300]);
    %             [a,b,bww]=find(bw);
    %             if a<b
    %             bwidth = [a,b,bww]; % tat ca cac yeu cau duoc sinh ra tu M nodes
    %             end
    %         end
    %     end
    % end
    % n=randperm(M*(M-1)/2,D); % vector hang chua D cac so rieng biet tu 1 den M*(M-1)/2
    % index=bwidth(n,:); % n: chi so hang cua 'bwidth'
    % fprintf(fid,'%d %d %d\n',index');
    
    for index=1:D
        fprintf(fid,'%d %d %d\n', a(n(index)), b(n(index)), bw(n(index)));
    end
    
    %fprintf(fid,'%d %d %d\n',index');
    fclose(fid);
    
     for i=1:step
        x(M+i)=S*rand;    % x duoc chon random tu 1 den S
        y(M+i)=S*rand;    % y duoc chon random tu 1 den S
        z(M+i)=100*rand;  % z duoc chon random tu 1 den 100
     end
     M = M + step;
end
%type inputnodes.txt
