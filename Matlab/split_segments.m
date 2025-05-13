function final_output = split_segments(initial_segments)
    epsilon = 1e-10;
    n = length(initial_segments);
    segments = cell(n, 1);
    for i = 1:n
        seg = initial_segments{i};
        segments{i} = [seg{1}; seg{2}];
    end

    intersection_pts = cell(n, 1);

    for i = 1:n
        for j = i+1:n
            seg1 = segments{i};
            seg2 = segments{j};
            [pt, is_pt] = compute_intersection(seg1, seg2, epsilon);
            if is_pt
                intersection_pts{i} = [intersection_pts{i}; pt];
                intersection_pts{j} = [intersection_pts{j}; pt];
            end

            A1 = seg1(1,:);
            B1 = seg1(2,:);
            if is_point_on_segment(A1, seg2, epsilon)
                intersection_pts{j} = [intersection_pts{j}; A1];
            end
            if is_point_on_segment(B1, seg2, epsilon)
                intersection_pts{j} = [intersection_pts{j}; B1];
            end

            A2 = seg2(1,:);
            B2 = seg2(2,:);
            if is_point_on_segment(A2, seg1, epsilon)
                intersection_pts{i} = [intersection_pts{i}; A2];
            end
            if is_point_on_segment(B2, seg1, epsilon)
                intersection_pts{i} = [intersection_pts{i}; B2];
            end
        end
    end

    output_segments = cell(0);
    for i = 1:n
        seg = segments{i};
        A = seg(1,:);
        B = seg(2,:);
        pts = intersection_pts{i};

        AB = B - A;
        len2 = sum(AB.^2);
        t_values = zeros(size(pts,1), 1);
        for k = 1:size(pts,1)
            AP = pts(k,:) - A;
            t_values(k) = dot(AP, AB) / len2;
        end

        [sorted_t, idx] = sort(t_values);
        sorted_pts = pts(idx, :);
        unique_pts = [];
        prev_pt = [];
        for k = 1:size(sorted_pts,1)
            current_pt = sorted_pts(k,:);
            if isempty(prev_pt) || norm(current_pt - prev_pt) > epsilon
                unique_pts = [unique_pts; current_pt];
                prev_pt = current_pt;
            end
        end

        split_pts = [A; unique_pts; B];
        for k = 1:size(split_pts,1)-1
            p1 = split_pts(k,:);
            p2 = split_pts(k+1,:);
            if norm(p1 - p2) > epsilon
                output_segments{end+1} = {p1, p2};
            end
        end
    end

    final_output = cell(length(output_segments),1);
    for i = 1:length(output_segments)
        seg = output_segments{i};
        final_output{i} = {seg{1}, seg{2}};
    end
end