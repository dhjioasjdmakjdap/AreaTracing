function intersection = findIntersection(A, B, C)

    xA = A(1); yA = A(2);
    xB = B(1); yB = B(2);
    xC = C(1); yC = C(2);

    slopeBC = (yC - yB) / (xC - xB);
    

    midAB = [(xA + xB) / 2, (yA + yB) / 2];
    

    slopeAB = (yB - yA) / (xB - xA);
    

    if slopeAB ~= 0
        slopePerpendicular = -1 / slopeAB;
    else

        slopePerpendicular = Inf;
    end
    

    
    if isinf(slopePerpendicular)

        xIntersection = midAB(1);
        yIntersection = slopeBC * (xIntersection - xB) + yB;
    elseif isinf(slopeBC)

        xIntersection = xB;
        yIntersection = slopePerpendicular * (xIntersection - midAB(1)) + midAB(2);
    else

        xIntersection = (slopePerpendicular * midAB(1) - slopeBC * xB + yB - midAB(2)) / (slopePerpendicular - slopeBC);
        yIntersection = slopeBC * (xIntersection - xB) + yB;
    end
    
    intersection = [xIntersection, yIntersection];
end