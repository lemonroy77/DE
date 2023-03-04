function init_pop = init_pop(NP, dim, d_min, d_max)
init_pop = [];
for i = 1:NP %第i个个体
    for j = 1:dim %第j维决策变量的取值
    init_pop(i,j) = d_min(j) + (d_max(j) - d_min(j)).*rand;
    end
end
end
