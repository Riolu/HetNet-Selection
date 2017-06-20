function [ pi, pi_average ] = cal_pi( N, rate, p, s_1, s_2, s_3, pi, pi_average )
    num = zeros(3,3); %num(a,i) 第a个区域，第i种选择的人数
    num(1,1) =  N(1);
    for i = 1:N(2) %2区
        num(2,s_2(i)) = num(2,s_2(i))+1;
    end
    for i = 1:N(3) %3区
        num(3,s_3(i)) = num(3,s_3(i))+1;
    end
    
    num_1 = num(1,1)+num(2,1)+num(3,1);
    pi(1,1) = utility( rate(1)/ num_1 ) - p(1)*num_1;
    pi(2,1) = pi(1,1);
    pi(3,1) = pi(1,1);
    
    num_2 = num(2,2) + num(3,2);
    pi(2,2) = utility( rate(2)/ num_2 ) - p(2)*num_2;
    pi(3,2) = pi(2,2);
    
    num_3 = num(3,3);
    pi(3,3) = utility( rate(3)/ num_3 ) - p(3)*num_3;
    
    
    pi_average(1) = pi(1,1);
    pi_average(2) = (pi(2,1)*num(2,1)+pi(2,2)*num(2,2))/N(2);
    pi_average(3) = (pi(3,1)*num(3,1)+pi(3,2)*num(3,2)+pi(3,3)*num(3,3))/N(3);
    
    %disp(num(2,2)/N(2));
    disp(num(3,2)/N(3));
end

