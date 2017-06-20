function [ equ ] = find_nash(N, rate, p, line_x, line_y, line_z)
    %line_x means x^3_wm
    %line_y means x^3_ce
    %line_z means x^2_wm
    num = zeros(3,3); %num(a,i) 第a个区域，第i种选择的人数
    num(1,1) = N(1);
    num(2,1) = int32(N(2)*line_z);
    num(2,2) = N(2)-num(2,1);
    num(3,1) = int32(N(3)*line_x);
    num(3,2) = int32(N(3)*line_y);
    num(3,3) = N(3)-num(3,1)-num(3,2);
    
    pi = zeros(3,3);  %pi(a,i) 第a个区域，第i种选择
    pi_area = zeros(1,3); %pi_area(a) a区域所有人payoff
    
    num_1 = num(1,1)+num(2,1)+num(3,1);
    num_2 = num(2,2) + num(3,2);  
    num_3 = num(3,3);
    
    pi_area(1) = utility(rate(1)*num(1,1)/num_1) - num(1,1)*p(1)*num_1;
    
    pi_area(2) = utility(rate(1)*num(2,1)/num_1) - num(2,1)*p(1)*num_1 ...
               + utility(rate(2)*num(2,2)/num_2) - num(2,2)*p(2)*num_2;
           
    pi_area(3) = utility(rate(1)*num(3,1)/num_1) - num(3,1)*p(1)*num_1 ...
               + utility(rate(2)*num(3,2)/num_2) - num(3,2)*p(2)*num_2 ...
               + utility(rate(3)*num(3,3)/num_3) - num(3,3)*p(3)*num_3;

    disp(pi_area);
    
    equ = 1;
end

