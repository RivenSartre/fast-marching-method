function [start_angle,end_angle] = AngleTrans(phi,theta,flag)
% flag = 0，小扇形
% flag = 1，反扇形
if flag==0
    start_angle = phi-theta;
    end_angle = phi+theta;
else
    start_angle = phi+theta;
    end_angle = phi-theta;
end

start_angle= normalize_angle(start_angle);
end_angle= normalize_angle(end_angle);



end

