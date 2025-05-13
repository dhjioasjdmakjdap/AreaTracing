function [intersection] = segment_segment_intersection(A1, A2, B1, B2)

    dA = A2 - A1;
    dB = B2 - B1;

    cross = dA(1) * dB(2) - dA(2) * dB(1);

    if abs(cross) < 1e-10
        intersection = [];
        return;
    end

    delta = B1 - A1;
    t1 = (delta(1) * dB(2) - delta(2) * dB(1)) / cross;
    t2 = (delta(1) * dA(2) - delta(2) * dA(1)) / cross;

    if (t1 > -1e-10 && t1 < 1+1e-10) && (t2 > -1e-10 && t2 < 1+1e-10)
        intersection = A1 + t1 * dA; 
    else
        intersection = [];
    end
end
