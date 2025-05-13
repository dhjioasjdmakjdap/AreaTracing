
function imagePoint = computeImagePoint(P, A, B)
    % get image point
    AB = B - A;

    AP = P - A;

    AB_unit = AB / norm(AB);
    

    projectionLength = dot(AP, AB_unit);

    projectionVector = projectionLength * AB_unit;

    projectionPoint = A + projectionVector;
    

    imagePoint = 2 * projectionPoint - P;
end