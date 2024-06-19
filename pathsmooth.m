function [values] = pathsmooth(path_g,start,goal)
n=2;
p(1,:)=path_g(1,:);
roott=10;
for i = 2:size(path_g,1)
    if mod(i,roott)==0
        p(n,1)=path_g(i,1);
        p(n,2)=path_g(i,2);
        n=n+1;
    end
end
p(n,1)=path_g(size(path_g,1),1);
p(n,2)=path_g(size(path_g,1),2);

points = p';
values = spcrv(points,20); 
values=values';
values=[start;values;goal];
end

