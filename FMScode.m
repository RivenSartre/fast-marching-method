clear all
close all
home
%% 1.导入地图，所为0-1二值化的扩散率。
load mapeN.mat           % 地图二值环境
mape=~mapeN;
load UsN.mat             % 避障代价场，未归一化的版本
siz=size(mape);         % 地图范围
plot_flag=0;            % 不要绘图
data_points=[430,590];  % 波源，即目标点
F_mape=mape;

%% 2.处理一下避障场
minValue = min(Us(:));   % 先最值归一化
maxValue = max(Us(:));
Us_normal = (Us - minValue) / (maxValue - minValue); % 归一化完了 
F_safe=eetanh(Us_normal,20);

%% 3.做在避障和无避障情况下的路径规划
%% FMM
Tm=fast_marching(data_points,siz,plot_flag,F_mape);
figure(1)
drawaPic(Tm)
hold on
contour(Tm,20)

%% FMS：考虑到避障距离
Ts=fast_marching(data_points,siz,plot_flag,F_safe);
TT=real(Ts);
figure(2)
drawaPic(TT)
hold on
contour(TT,20)
