function angle = normalize_angle(angle)
    % 将角度转换到 [-pi, pi] 范围内
    while angle <= -pi
        angle = angle + 2*pi;
    end
    
    while angle > pi
        angle = angle - 2*pi;
    end
    
end