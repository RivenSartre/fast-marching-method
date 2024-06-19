function [] = drawaPic(soln_copy)
ind = find(soln_copy == Inf);
soln_copy(ind) = 1;
maxval = max(soln_copy(:));
map_rgb = jet(128);
soln_copy = floor((soln_copy./maxval)*length(map_rgb));
soln_copy = ind2rgb(soln_copy, map_rgb);
[x, y] = ind2sub(size(soln_copy), ind);
for i = 1:length(x)
    soln_copy(x(i), y(i), :) = [0 0 0];
end
imagesc(soln_copy);

end