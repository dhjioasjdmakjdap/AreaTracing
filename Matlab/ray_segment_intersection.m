function [intersection,t] = ray_segment_intersection(P, EndPoint, Point_A, Point_B)

    r = EndPoint - P; 
    s = Point_B - Point_A;     

    r_cross_s = r(1) * s(2) - r(2) * s(1);

    q = Point_A - P;

    if abs(r_cross_s) < 1e-10
        intersection = [];
        t=[];
    else
        t = (q(1) * s(2) - q(2) * s(1)) / r_cross_s;
        u = (q(1) * r(2) - q(2) * r(1)) / r_cross_s;

        if t >= 0 && (u >=-0.00001) && u <= 1.000001
            % intersection location
            intersection_point = P + t * r;
            intersection=[intersection_point,t];
        else
            % no intersection
            intersection = [];
            t=[];
        end
    end

end