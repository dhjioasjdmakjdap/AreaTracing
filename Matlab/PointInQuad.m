function isInside = PointInQuad(P, A, B, C, D)
    vertices = [A; B; C; D];
    tol = 1e-6;
    unique_vertices = A;


    if norm(B - A) >= tol
        unique_vertices = [unique_vertices; B];
    end


    if (norm(C - A) >= tol) && (norm(C - B) >= tol)
        unique_vertices = [unique_vertices; C];
    end


    if (norm(D - A) >= tol) && (norm(D - B) >= tol) && (norm(D - C) >= tol)
        unique_vertices = [unique_vertices; D];
    end

    numVertices = size(unique_vertices, 1);

    if numVertices == 3

        isInside = PointInTriangle(P, unique_vertices(1, :), unique_vertices(2, :), unique_vertices(3, :));
    elseif numVertices == 4

        isInside = PointInTriangle(P, vertices(1, :), vertices(2, :), vertices(3, :)) || ...
                   PointInTriangle(P, vertices(1, :), vertices(3, :), vertices(4, :))||...
                   PointInTriangle(P, vertices(2, :), vertices(3, :), vertices(4, :));
    else
        isInside = false;
    end
    

end



