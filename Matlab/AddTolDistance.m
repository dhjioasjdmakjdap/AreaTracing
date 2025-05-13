function P_new = AddTolDistance(P,Point1,Point2)

    tol = double(sqrt(eps('single')))/2;

    direction = Point1 - Point2;
    
    norm_direction = direction / norm(direction);
    
    P_new = P + tol * norm_direction;
end