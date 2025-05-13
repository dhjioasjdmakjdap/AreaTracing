function is_inside = is_point_on_segment(p, seg, epsilon)
    A = seg(1,:);
    B = seg(2,:);
    AB = B - A;
    AP = p - A;

    cross = AB(1)*AP(2) - AB(2)*AP(1);
    if abs(cross) > epsilon
        is_inside = false;
        return;
    end

    len2_AB = sum(AB.^2);
    if len2_AB < epsilon^2
        is_inside = false;
        return;
    end

    t = dot(AP, AB) / len2_AB;
    is_inside = (t > epsilon) && (t < 1 - epsilon);
end