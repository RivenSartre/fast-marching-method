# fast-marching-method
# 一个快速行进法/快速平方行进法的便捷函数

`T=fast_marching(data_points,siz,plot,F)`
- T：波前函数，代表波前到网格的时间
- data_points：波源位置，[x,y]
- siz：地图尺寸，[gridX, gridY]
- plot：是否绘图，0不绘图，1绘图，绘图会很慢
- F：地图，取值在0到1内，0代表完全自由扩散，1代表不能扩散，取值影响波的扩散速度
