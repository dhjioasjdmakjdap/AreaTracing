function Iscorner=CalIsCorner(P,FirstImagePoint,RxImagePoint,Point,SecondImagePoint)
    % Determine whether it is at the corner
    intersection1 = findIntersection(P, FirstImagePoint, RxImagePoint);
    intersection2 = findIntersection(RxImagePoint, Point, SecondImagePoint);
    if norm(intersection1-intersection2)<1e-6
        Iscorner=1;
    else
        Iscorner=0;
    end
end
