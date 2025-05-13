function visible_segments = computeVisibleSegments(P, L)
    % init FS
    visible_segments=L;
    N=size(visible_segments,1);
    
    % Traverse each facet
    for i=1:N
        if ~isempty(L{i})
            A = L{i}{1,1};
            B = L{i}{1,2};
            for j=1:N
                if ~isempty(visible_segments{i})
                    if i==j
                        continue;
                    end
                    if ~isempty(L{j})
                        C = L{j}{1,1};
                        D = L{j}{1,2};
                        % endpoint
                        C_inside = PointInTriangle_EdgeIsOut(C, P, A, B);
                        D_inside = PointInTriangle_EdgeIsOut(D, P, A, B);
                        if C_inside&&D_inside
                            % A1
                            [I_C,~] = ray_segment_intersection(P, C, A, B);
                            [I_D,~] = ray_segment_intersection(P, D, A, B);
                            visible_segments{i}=InsertVisibleSegmenntsHighCenter(visible_segments{i},I_C(1:2),I_D(1:2));
                        elseif (~C_inside)&&(~D_inside)
                            
                            I_PA = segment_segment_intersection(C, D, P, A);
                            I_PB = segment_segment_intersection(C, D, P, B);
                            if ~isempty(I_PA)&&~isempty(I_PB)
                                % C1
                                visible_segments{i}=InsertVisibleSegmenntsHighCenter(visible_segments{i},A,B);
                            else
                                %B1
                                continue;
                                
                            end
                        else
                            I_PA = segment_segment_intersection(C, D, P, A);
                            I_PB = segment_segment_intersection(C, D, P, B);
                            if ~isempty(I_PA)
                                % D1
                                if C_inside
                                    [I_C,~] = ray_segment_intersection(P, C, A, B);
                                    visible_segments{i}=InsertVisibleSegmenntsHighCenter(visible_segments{i},A,I_C(1:2));
                                elseif D_inside
                                    [I_D,~] = ray_segment_intersection(P, D, A, B);
                                    visible_segments{i}=InsertVisibleSegmenntsHighCenter(visible_segments{i},A,I_D(1:2));
                                end
                            elseif ~isempty(I_PB)
                                % E1
                                if C_inside
                                    [I_C,~] = ray_segment_intersection(P, C, A, B);
                                    visible_segments{i}=InsertVisibleSegmenntsHighCenter(visible_segments{i},B,I_C(1:2));
                                elseif D_inside
                                    [I_D,~] = ray_segment_intersection(P, D, A, B);
                                    visible_segments{i}=InsertVisibleSegmenntsHighCenter(visible_segments{i},B,I_D(1:2));
                                end
                            end
                        end
                    else
                        continue;
                    end
                else
                    continue;
                end

            end
            
        end
    end
end

function visible_segments_new = InsertVisibleSegmenntsHighCenter(visible_segments, intersection_StartPoint, intersection_EndPoint, tol)
    % remove intersection portion


    if nargin < 4
        tol = 1e-10;
    end
    intersection_StartPoint=intersection_StartPoint(1:2);
    segments_matrix = reshape(cell2mat(visible_segments), 2, []).';
    segments_matrix = reshape(segments_matrix.', 4, []).';

    origin = intersection_StartPoint;


    dir_vec = intersection_EndPoint - intersection_StartPoint;
    dir_norm = norm(dir_vec);
    if dir_norm < tol
        visible_segments_new=visible_segments;
        return;
    end
    dir_unit = dir_vec / dir_norm;

    vec_start = segments_matrix(:, 1:2) - origin;
    t_start = vec_start * dir_unit.'; 

    vec_end = segments_matrix(:, 3:4) - origin; 
    t_end = vec_end * dir_unit.';


    swap_mask = t_start > t_end;
    if any(swap_mask)
        temp_t = t_start(swap_mask);
        t_start(swap_mask) = t_end(swap_mask);
        t_end(swap_mask) = temp_t;

        temp_coords = segments_matrix(swap_mask, 1:2);
        segments_matrix(swap_mask, 1:2) = segments_matrix(swap_mask, 3:4);
        segments_matrix(swap_mask, 3:4) = temp_coords;
    end

    t_B1 = 0; 
    t_B2 = dir_norm;

    if t_B1 > t_B2
        [t_B1, t_B2] = deal(t_B2, t_B1);
    end

    no_overlap_mask = (t_end < t_B1 - tol) | (t_start > t_B2 + tol);
    segments_no_overlap = segments_matrix(no_overlap_mask, :);

    overlap_mask = ~no_overlap_mask;
    segments_overlap = segments_matrix(overlap_mask, :);
    t_start_overlap = t_start(overlap_mask);
    t_end_overlap = t_end(overlap_mask);

    new_segments = [];

    if ~isempty(segments_no_overlap)
        new_segments = [new_segments; segments_no_overlap];
    end

    if ~isempty(segments_overlap)
        before_mask = t_start_overlap < t_B1 - tol;
        if any(before_mask)
            parts_before = segments_overlap(before_mask, :);
            parts_before(:, 3:4) = origin + t_B1 * dir_unit;
            new_segments = [new_segments; parts_before(:, 1:2), parts_before(:, 3:4)];
        end

        after_mask = t_end_overlap > t_B2 + tol;
        if any(after_mask)
            parts_after = segments_overlap(after_mask, :);
            parts_after(:, 1:2) = origin + t_B2 * dir_unit;
            new_segments = [new_segments; parts_after(:, 1:2), parts_after(:, 3:4)];
        end
    end

    if ~isempty(new_segments)
        valid_segments_mask = (abs(new_segments(:,1) - new_segments(:,3)) > tol) | (abs(new_segments(:,2) - new_segments(:,4)) > tol);
        new_segments = new_segments(valid_segments_mask, :);
    end

    if isempty(new_segments)
        visible_segments_new = {};
    else
        visible_segments_new = cell(1, size(new_segments, 1) * 2);
        for i = 1:size(new_segments, 1)
            visible_segments_new{2*i-1} = new_segments(i, 1:2);
            visible_segments_new{2*i} = new_segments(i, 3:4);
        end
    end

end



