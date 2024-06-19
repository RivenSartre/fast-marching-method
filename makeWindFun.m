% This is just a helper function to make a random scalar function. This is
% called twice to generate a random wind field.
% 这只是一个辅助函数，用于制作随机标量函数。调用两次可生成随机风场。
% 输入XY两个方向的尺寸，输出平滑向量场
function iWind = makeWindFun(SZX,SZY)

windFineness = 0.1;
if ~exist("SZX","var")
    SZX = 50;
    SZY = 50;
end

N = 50; % Various parameters used in generating a random "smooth" matrix 用于生成随机 "平滑 "矩阵的各种参数
NL = 40;
NP = 500;
rx = randn(NL,N);
rx = interpft(rx,NP);
ry = randn(NL,N);
ry = interpft(ry,NP);
I = (rx*ry');

[xgi,ygi] = meshgrid(linspace(1,2 + 498*windFineness,SZX+1),linspace(1,2 + 498*windFineness,SZY+1));
iWind = 10*interp2(1:500,1:500,I,xgi,ygi);


end