%dijkstra la ham tim kiem duong di ngan nhat tu 1 node start den 1 node
    %end
    function [dist,path,status] = dijkstra_modified_BER(G,s,t,BER,Threshold_BER,BW)
        %khai bao bien
       
        v = size(G,1); % v so canh trong do thi G 
        %disp(v);
        S= zeros(v); % S la tap chua dinh da duyet
        Len = zeros(v); % Len la ma tran chua gia tri duong di ngan nhat 
        P = zeros(v); % chua diem bat dau cu moi dinh
        Cons = zeros(v); % chua TICH 1-ber cua tu dinh dau toi dinh xet
        %bandwidth = zeros(v); % tong bang thong tu node dau toi node dang xet
      
        %path = zeros(v);
        % khoi tao gia tri
        for i= 1 : v
            Len(i,1) = inf;  % gan gia tri ban dau bang vo cung
            P(i,1) = s; % dat diem bat dau cua moi diem la s
            Cons(i,1) = BER(s,i);
        end
        Cons(s,1) =1;
        Len(s,1)=0; % dat do dai tu s->s la 0
        %giai thuat
        x=0;
        status = 1;
        while S(t,1) == 0
            temp = v+1;
            for i= 1 : v
                if S(i,1) ~= 1 && ~isinf(Len(i,1))
                    temp=i;
                    break;
                end
            end
            
            % neu i>=v thi khong thi duyet het cac dinh roi ma khong tim
            % thay dinh t
            if temp >= v +1
                msg = strcat('Khong tim thay node ',num2str(t));
                disp(msg);
                status = 0;% 0 la khong tim thay duong di,1 la tim thay
                break;
            end
            % tim diem co do dai duong di ngan nhat trong cac canh chua
            % duoc duyet
            for j= 1:v 
                if S(j,1) ~=1 && Len(temp,1) > Len(j,1)
                    temp = j;
                end
            end
            % Cho dinh co gia tri duong di ngan nhat tu s vao tap S chua cac
            % dinh da duyet
            S(temp,1) = 1;
            %Cap nhat la do dai duong di cac diem chua xet
            for j=1:v
               % disp(num2str(S(j,1)));
                if S(j,1) ~=1 && Len(temp,1)+G(temp,j) < Len(j,1)
                    if Cons(temp,1)* (1- BER(temp,j)) > (1-Threshold_BER)
                        Len(j,1) = Len(temp,1) + G(temp,j);
                       % disp(strcat('cap nhat lenght(',num2str(j),',1) =',num2str(Len(j,1))));
                        Cons(j,1) = Cons(temp,1)* (1- BER(temp,j));
                       % disp(strcat('cap nhat Cons(',num2str(j),',1) =',num2str(Cons(j,1))));
                        P(j,1) = temp; % danh dau diem truoc no
                       % bandwidth(j,1) = bandwidth(temp,1) + BW(temp,j);
                    end
                end
            end
        end
        if status == 1
            %tra ve ket qua dist
            dist = Len(t,1);
            % in ra man hinh ket qua tong weight
            msg = strcat('tong duong di tu node ',num2str(s),' toi node ',num2str(t),'la ',num2str(dist));
            disp(msg);
            % tra ve ket qua path
            count = 2;
            path(1)= t;
            while t ~= s
                path(count) = P(t,1);
                t = P(t,1);
                count = count +1;
            end
            path = fliplr(path);
        else
            dist = 0;
            path = zeros(1);
        end
    end