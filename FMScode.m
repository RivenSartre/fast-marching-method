clear all
close all
home

%% 1.导入地图，所为0-1二值化的扩散率
load mape.mat           % 地图二值环境
load tau.mat            % 避障代价场，未归一化
siz=size(mape);         % 地图范围
plot_flag=0;            % 不要绘图0，要绘图1（最好别，因为会很慢）

data_points=[200,500];  % 波源，即目标点
F_mape=mape;
Us=tau;

%% 2.处理一下避障场
minValue = min(Us(:));   % 先最值归一化
maxValue = max(Us(:));
Us_normal = (Us - minValue) / (maxValue - minValue); % 归一化完了 
F_safe=eetanh(Us_normal,1);  % 一个基于双曲正切函数的归一化

%% 3.做在避障和无避障情况下的路径规划
%% FMM
Tm=fast_marching(data_points,siz,plot_flag,F_mape);
figure(1)
drawaPic(Tm)

%% FMS：考虑到避障距离
Ts=fast_marching(data_points,siz,plot_flag,F_safe);
TT=real(Ts);
figure(2)
drawaPic(TT)
