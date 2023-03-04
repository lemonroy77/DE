function fitness_value = fitness(pop, dim)
[xsize,~]=size(pop);
%Sphere function
    f=[];
for i=1:xsize
        f(i,1) = pop(i,1)^2 + pop(i,2)^2 + pop(i,3)^2;
end
  fitness_value=f;
end
