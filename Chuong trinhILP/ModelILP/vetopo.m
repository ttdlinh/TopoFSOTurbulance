% filename = 'topoILPk2.5m7D10.txt';%duong dan file output can ve
% filename = 'topoILPk2.5m8D14.txt';%duong dan file output can ve
% filename = 'topoILPk2m5D5.txt';%duong dan file output can ve
% filename = 'topoILPk2m6D7.txt';%duong dan file output can ve
% filename = 'topoILPk3m9D18.txt';%duong dan file output can ve
% filename = 'topoILPk3m10D10.txt';%duong dan file output can ve
% filename = 'topoILPk3m10D22.txt';%duong dan file output can ve
% filename = 'topok3m12.txt';%duong dan file output can ve
% filename = 'topok4m20.txt';%duong dan file output can ve
filename = 'topoILPk3m10D10.txt'
fid = fopen(filename);
M=fscanf(fid,'%*s %*s %*s %*s %*s %d',1);
fscanf(fid,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',10);
Node=fscanf(fid,'%f',[6,M]);

N=Node';
for i=1:M
    j=1;
    X=zeros(2,1);
    Y=zeros(2,1);
    Z=zeros(2,1);
    X(j,:)=N(i,1);
    X(j+1,:)=N(i,4);
    Y(j,:)=N(i,2);
    Y(j+1,:)=N(i,5);
    Z(j,:)=N(i,3);
    Z(j+1,:)=N(i,6);
    plot3(X,Y,Z,'-o');
   
    xlabel('x-axis(m)');ylabel('y-axis(m)');zlabel('z-axis(m)');
    grid on;
    hold on;
end
save ('varicurrent','Node','N');