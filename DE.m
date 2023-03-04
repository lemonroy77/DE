%%%%%%%%%%%%%%%%%%%%%%%%%%%Differential Evolution%%%%%%%%%%%%%%%%%%%%%%%%%%
%仅针对单目标问题
%结果受参数NP，CR的影响很大，每代可能且最多变化1个个体
clear
clc

%----------------------------设定初始化条件-----------------------------------
NP = 10;                                        %种群数量
it_max = 100;                                   %最大迭代次数
dim = 3;                                        %决策空间维数
  d_min = [-5.12, -5.12, -5.12];                %决策变量取值范围最小值
  d_max = [5.12, 5.12, 5.12];                   %决策变量取值范围最大值
CR = 0.8;                                       %交叉概率
F = 0.5;                                        %缩放因子
%------------------------------初始化种群------------------------------------
init_pop = init_pop(NP, dim, d_min, d_max);
fitness_value = fitness(init_pop, dim);
init_pop = [init_pop, fitness_value];
pop = init_pop;
for iter = 1:it_max
    %-----------------------------生成实验个体V------------------------------
    num = randperm(NP,4);                           %生成x_1,x_2,x_3,x_4在pop中的编号
    %生成差分矢量diff_var
    x_2 = pop(num(2),:);
    x_3 = pop(num(3),:);
    diff_var = x_2 - x_3;
    %生成变异中间个体V
    x_1 = pop(num(1),:);
    V = x_1 + F*diff_var;
    V(:,dim+1) = fitness(V(:,1:dim),dim);
    %-------------------------------交叉得到U-------------------------------
    x_4 = pop(num(4),:);                            %用于与V交叉的个体
    n = randperm(dim,1);                            %开始交叉的维数
    %得到交叉的维数L,L/in{0,1,...,dim-n+1}
    for i = 1:dim
        pro_cross_all(:,dim-i+1) = CR^i;            
    end
    pro_cross_all = [0,pro_cross_all,1];            %所有情况的交叉概率
    pro_cross = [0,pro_cross_all(:,n+1:size(pro_cross_all,2))];   
                                                    %针对n所能取到的L值的所有交叉概率              
    location = find(rand <= pro_cross);             %location是针对n所能取到L值的位置
    L = dim - find(pro_cross_all == pro_cross(:,location(:,1))) + 2;
                                                    %L是交叉的维数
    U = x_4;                                        %经常不交叉怎么办！！！！！
    U(:,n:n+L-1) = V(:,n:n+L-1);
    U(:,end) = fitness(U(:,1:dim),dim);             %U是交叉后个体
    %--------------------------选择函数值小的代替x_4--------------------------
    if U(:,end) < x_4(:,end)
        pop(num(4),:) = U;
    else
        pop(num(4),:) = x_4;
    end
    pop = sortrows(pop,dim+1);
    optimal(iter) = pop(1,dim+1);
end
%-------------------------------绘制出适应度变化曲线图-------------------------
plot(optimal,'*-')
xlabel('迭代次数')
ylabel('适应度值')
title('Sphere function')
hold on
