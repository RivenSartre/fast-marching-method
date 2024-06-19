% USAGE:	T = fast_marching(data_points);
%
% 参数:	  * data_points: 具有二维输入点的列向量。即data_points=[x1 y1;x2 y2;…;xn yn)。所有的坐标都应该是整数值。
%           * size: 图像域的大小。假设域为矩形[0 0 siz(1) siz(2)]。所有的输入坐标都应该在这个范围内。
%           * plot: Boolean(可选)。启用或禁用交互式绘图。
% 输出:     * T: 带有距离图的图像

function T=fast_marching(data_points,siz,plot,F)
% 检查参数
% M1=max(data_points,1);
% M2=max(data_points,2);
% m1=min(data_points,1);
% m2=min(data_points,2);
if(sum(data_points(:,1)>siz(1)-1) || sum(data_points(:,1)<2) || sum(data_points(:,2)>siz(2)-1) || sum(data_points(:,2)<2))
    error('数据点超出边界');
end


if(nargin<3)
    plot=1;
end

dim=2;
delta=1;

sourcenumber=size(data_points,1); % 数据点数量，博源数量

neighbours=[1 0;-1 0;0 1;0 -1]; % neighbours
%neighbours=[1 0;-1 0;0 1;0 -1;1 1;-1 -1;-1 1;1 -1]; % neighbours
num_vecinos=size(neighbours,1);

% la mayoria infinito (los far away)
% F=ones(siz(1),siz(2));          % 波的扩散率
T=ones(siz(1),siz(2))*inf;      % 到达时间
u=zeros(dim,1);
m=zeros(dim,1);
types=2*ones(siz(1),siz(2));    % Far away

% pongo en cero los puntos inicialmente alive
lin_ind=sub2ind(siz,data_points(:,1),data_points(:,2));
T(lin_ind)=0;                   % 赋波源为alive，到达时间为0
types(lin_ind)=0;               

% defino los narrow band 定义更新点
for k=1:sourcenumber
    for d=1:dim
        coord_vecinos(:,d)=data_points(k,d)+neighbours(:,d);
        ind=find( coord_vecinos(:,d)>siz(d) | coord_vecinos(:,d)<0 );
        coord_vecinos(ind,d)=data_points(k,d);
    end
    lin_ind=sub2ind(siz,coord_vecinos(:,1),coord_vecinos(:,2));
    types(lin_ind)=(types(lin_ind)~=0);
    T(lin_ind)=1./F(lin_ind);   % 这一步计算波扩散率
end

% 在绘制后改变标记的颜色，请使用
% set(get(gca,'Children'),'Color',[1 0 0])

stop=0; % 终止条件
iter=1; % 迭代要求

while ~stop

    % 寻找trail中哪个有最小的T。
	ind_narrow_band=find(types==1); % 找所有的trail的编号
	if ~isempty(ind_narrow_band) % trial是不是全找到了
		[useless,ind_rel_min_T]=min(T(ind_narrow_band)); % 找最小一个的序号
		ind_min_T=ind_narrow_band(ind_rel_min_T);  % 找最小一个序号对应的坐标序号
		% y lo paso a alive ，赋为alive网格
		types(ind_min_T)=0;

		%  fprintf('2');

		% 这是当前要计算的啷个位置
		[coord_x,coord_y]=ind2sub(siz,ind_min_T); % 把坐标序号换成坐标
		punto=[coord_x,coord_y]; % 塞到这里面来

		for d=1:dim % 这个是找到当前计算位置找邻域的。4邻域或者8邻域
			coord_vecinos(:,d)=punto(d)+neighbours(:,d);
			ind=find(coord_vecinos(:,d)>siz(d) | coord_vecinos(:,d)<=0 );
			% 修改，需要修正边界
			coord_vecinos(ind,d)=punto(d)-(coord_vecinos(ind,d)-punto(d));
		end

		% fprintf('3');

		% 把far的邻域送到trail中
		lin_ind=sub2ind(siz,coord_vecinos(:,1),coord_vecinos(:,2));
		ind_rel_far=find(types(lin_ind)==2);
		ind_far=lin_ind(ind_rel_far);
		types(ind_far)=1;
		cant_vecinos_narrow=length(ind_far);
        
        % t=1
		for t=1:num_vecinos
			current_vecino=coord_vecinos(t,:); % 现在该算哪个邻域
			F_curr=F(current_vecino(1),current_vecino(2)); % 找这个邻域的扩散率
			
            % 更新T值

			% fprintf('5');

			for d=1:dim
				coord_vec_vec(:,d)=current_vecino(d)+neighbours(:,d);
				ind=find(coord_vec_vec(:,d)>siz(d) | coord_vec_vec(:,d)<=0 ); % 是否有超边界的，一般没有
				
				coord_vec_vec(ind,d)=current_vecino(d)-(coord_vec_vec(ind,d)-current_vecino(d)); % 总之就是找邻域，和前面一样的
			end

			%fprintf('6');
            
            % d=1;

			for d=1:dim % 按照4/8邻域方法去找临时点
				temp_1=T(coord_vec_vec(2*d-1,1),coord_vec_vec(2*d-1,2));
				temp_2=T(coord_vec_vec(2*d,1),coord_vec_vec(2*d,2));
				m(d)=min(temp_1,temp_2); % 筛出来最小的临时点，m是他的值，要比两边
            end
            %fprintf('7');

			[m,ind_m]=sort(m);
			k=2;
			u(1)=m(1)+delta/F_curr;
			u(k)=u(1);
			me_pase_de_dim=0;
			
			while u(k-1)>m(k) && ~me_pase_de_dim

				u(k)=sum(m(1:k))+sqrt( sum(m(1:k))^2 + k*delta^2/F_curr - k*sum(m(1:k).^2) );
				u(k)=u(k)/k;
				if k<dim-2
					k=k+1;
				else
					me_pase_de_dim=1;
				end
			end


			if types(current_vecino(1),current_vecino(2))==1 % 如果是trail网格，则给定T值为u
				T(current_vecino(1),current_vecino(2))=u(k);
			end
			%fprintf('9');
			% keyboard
		end

	else
		stop=1;
	end
	iter=iter+1;

	if (plot)
		figure(1);
		mesh(T);
		axis([0 siz(1) 0 siz(2) 0 50])
		drawnow;
	end

end

if (plot) % 画个图8
	figure

	mesh(T);
end