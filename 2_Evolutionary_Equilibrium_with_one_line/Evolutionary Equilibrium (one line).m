%N = [10,10,20];
%rate = [10,2,11];
%p = [0.0018,0.0025,0.002];

N = [1000,1000,3000];
rate = [10000000000,2000000000,7000000000];
p = [0.01,0.01,0.01];

wn_2 = 0.8; %wn的占比
wn_3 = 0.8; %wn的占比 这里假设3区的人都不选择ce 因此只有wn和wl可以选择


% 1:wm   2:ce  3:wl
s_1 = randi([1,1],1,N(1)); %1区只能选wm

s_2 = zeros(1,N(2));
wn_2_num = wn_2*N(2);
for i=1:wn_2_num
    s_2(i) = 1;
end
for i=wn_2_num+1:N(2)
    s_2(i) = 2;
end

s_3 = zeros(1,N(3));
wn_3_num = wn_3*N(3);
for i=1:wn_3_num
    s_3(i) = 1;
end
for i=wn_3_num+1:N(3)
    s_3(i) = 3;
end


pi = zeros(3,3);  %pi(a,i) 第a个区域，第i种选择
pi_average = zeros(1,3); %pi_average(a) a区域平均


x=[];
y=[];



K = 20;
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

%plot(x,y,'.')
plot(x,y)
xlabel('x^{(2)}_{wm}')
ylabel('x^{(3)}_{wm}')
axis([0 1 0 1])



