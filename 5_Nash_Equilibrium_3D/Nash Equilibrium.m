%N = [1000,1000,3000];
%rate = [10000000000,2000000000,7000000000];
%p = [0.01,0.01,0.01];

N = [1000,1000,3000];
rate = [10000000000,4000000000,7000000000];
p = [0.01,0.01,0.01];

%wn_2_set=[0.8,0.6,0.4,0.2];
%wn_3_set=[0.1,0.3,0.5,0.7]; %注意这里和下面加和不能超过1
%ce_3_set=[0.2,0.2,0.2,0.2];

wn_2_set=[0.3, 0.3, 0.3, 0.3,   0.1, 0.1, 0.1,  0.1,0.1,0.1,    0.4,0.4,0.4,    0.2,0.2,0.2];
wn_3_set=[0.05,0.05,0.05,0.05,  0.2, 0.2, 0.2,  0.25,0.25,0.25, 0.01,0.01,0.01, 0.6,0.6,0.6]; %注意这里和下面加和不能超过1
ce_3_set=[0.16,0.19,0.22,0.25,  0.16,0.19,0.22, 0.5,0.55,0.6,   0.24,0.27,0.3,  0.15,0.2,0.25];



M = length(wn_2_set);
line = zeros(3,M); %每一行表示一个维度

for m=1:M

    wn_2 = wn_2_set(m); %2区wn的占比
    wn_3 = wn_3_set(m); %3区wn的占比
    ce_3 = ce_3_set(m); %3区ce的占比

    % 1:wm   2:ce  3:wl
    s_1 = randi([1,1],1,N(1)); %1区只能选wm

    s_2 = zeros(1,N(2));
    wn_2_num = int32(wn_2*N(2));
    for i=1:wn_2_num
        s_2(i) = 1;
    end
    for i=wn_2_num+1:N(2)
        s_2(i) = 2;
    end

    s_3 = zeros(1,N(3));
    wn_3_num = int32(wn_3*N(3));
    ce_3_num = int32(ce_3*N(3));
    for i=1:wn_3_num
        s_3(i) = 1;
    end
    for i = wn_3_num+1 : wn_3_num+ce_3_num
        s_3(i) = 2;
    end
    for i = wn_3_num+ce_3_num+1 : N(3)
        s_3(i) = 3;
    end


    pi = zeros(3,3);  %pi(a,i) 第a个区域，第i种选择
    pi_average = zeros(1,3); %pi_average(a) a区域平均


    x=[wn_2]; %wn_2
    y=[wn_3]; %wn_3
    
    K = 20; %循环直到收敛
    ce_3_arr=zeros(1,K+1); %3区ce的占比
    for i=1:K+1
        ce_3_arr(i) = ce_3;
    end


    for k = 1:K
        [pi, pi_average, x, y] = cal_pi( N, rate, p, s_1, s_2, s_3, pi, pi_average, x, y );

        %1区域的人没法选择

        %2区域
        for i = 1:N(2)
            if pi(2,s_2(i))<pi_average(2)
                if (pi_average(2)-pi(2,s_2(i)))/pi_average(2) > rand()
                    for j = 1:2
                        if pi(2,j)>pi(2,s_2(i))
                            s_2(i) = j;
                            break;
                        end
                    end
                end
            end
        end

        %3区域
        for i = 1:N(3)
            if s_3(i)==2 %维持ce_3占比不变
                continue;
            end
            if pi(3,s_3(i))<pi_average(3)
                if (pi_average(3)-pi(3,s_3(i)))/pi_average(3) > rand()   
                    if pi(3,1)>pi(3,s_3(i))
                        s_3(i) = 1;
                    elseif pi(3,3)>pi(3,s_3(i))
                        s_3(i) = 3;
                    end

                end
            end
        end

    end

    %plot3(y,ce_3_arr,x,'.')
    values = spcrv([y';ce_3_arr;x'],3);
    plot3(values(1,:),values(2,:),values(3,:));

    hold on
    
    line(1,m) = y(end);
    line(2,m) = ce_3;
    line(3,m) = x(end);
end

%plot3(line(1,:),line(2,:),line(3,:))

%line_values = spcrv([line(1,:);line(2,:);line(3,:)],3);
%plot3(line_values(1,:),line_values(2,:),line_values(3,:));

a0=[0.9 2.1 2.9 1.8 2.9 4.1];
data=line;
[a,resnorm] = fit_line(a0,data);
%disp(a)
exp1 = [num2str(a(4)),'*t+',num2str(a(1))];
exp2 = [num2str(a(5)),'*t+',num2str(a(2))];
exp3 = [num2str(a(6)),'*t+',num2str(a(3))];
LINE = ezplot3(exp1,exp2,exp3,[-0.6 -0.48]);
hold on
title('')
xlabel('x^{(3)}_{wm}')
ylabel('x^{(3)}_{ce}')
zlabel('x^{(2)}_{wm}')
axis([0 0.5 0 0.8 0 1])
grid on

t = 0; %search along the line to find the nash equilibrium poiont
while t<=-1
    line_x = a(4)*t+a(1);
    line_y = a(5)*t+a(2);
    line_z = a(6)*t+a(3);
    disp([line_x,line_y,line_z]);
    POINT = plot3(line_x,line_y,line_z,'.');
    legend([POINT,LINE]);
    hold on
    result = find_nash(N, rate, p, line_x, line_y, line_z);
    t = t+0.01;
end

