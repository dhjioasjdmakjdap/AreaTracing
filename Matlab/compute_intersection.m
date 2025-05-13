function [pt, is_intersect] = compute_intersection(seg1, seg2, epsilon)
    % Calculate the intersection points of the two facets
    A1 = seg1(1,:);
    A2 = seg1(2,:);
    B1 = seg2(1,:);
    B2 = seg2(2,:);


    dA = A2 - A1;

    dB = B2 - B1;


    cross = dA(1) * dB(2) - dA(2) * dB(1);


    if abs(cross) < epsilon
        pt = [];
        is_intersect = false;
        return;
    end


    delta = B1 - A1;
    t1 = (delta(1) * dB(2) - delta(2) * dB(1)) / cross;
    t2 = (delta(1) * dA(2) - delta(2) * dA(1)) / cross;


    if (t1 >epsilon && t1 < 1-epsilon) && (t2 >epsilon && t2 <1-epsilon)
        pt = A1 + t1 * dA; 
        is_intersect = true;
    else
        pt = [];
        is_intersect = false;
    end
end