function ReflectVisibelSegment=ChoiceSegments(P,Segment,ReflectVisibelSegment,MaxSegment)


N=size(ReflectVisibelSegment,1);
for i=1:N

    Q1=Segment{1};
    Q2=Segment{2};
    Q3=Q2+((Q2-P)/norm((Q2-P)))*MaxSegment;
    Q4=Q1+((Q1-P)/norm((Q1-P)))*MaxSegment;
    Q=[Q1;Q2;Q3;Q4];
    A=ReflectVisibelSegment{i}{1,1};
    B=ReflectVisibelSegment{i}{1,2};
    

    A_in=PointInQuad(A, Q1,Q2, Q3, Q4);
    B_in=PointInQuad(B, Q1,Q2, Q3, Q4);


    edges=[Q;Q1];
    intersect_points = [];
    for j=1:4
        P1=edges(j,:);
        P2=edges(j+1,:);
        P_int=segment_segment_intersection(A, B, P1, P2);
        if ~isempty(P_int)
            intersect_points = [intersect_points; P_int];
        end
    end


    if A_in && B_in

        continue;
    elseif A_in && ~B_in

        if size(intersect_points,1)==1
            if norm(intersect_points-A)>1e-6
                ReflectVisibelSegment{i}{1,2}=intersect_points;
            else
                ReflectVisibelSegment{i}{1,1}=[];
                ReflectVisibelSegment{i}{1,2}=[];
            end
        else
         
            if norm(intersect_points(1,:)-intersect_points(2,:))>1e-6
                ReflectVisibelSegment{i}{1,1}=intersect_points(1,:);
                ReflectVisibelSegment{i}{1,2}=intersect_points(2,:);
            else
                
                ReflectVisibelSegment{i}{1,2}=intersect_points(1,:);
            end
        end
    elseif ~A_in && B_in
        if size(intersect_points,1)==1
            if norm(intersect_points-B)>1e-6
                ReflectVisibelSegment{i}{1,1}=intersect_points;
            else
                ReflectVisibelSegment{i}{1,1}=[];
                ReflectVisibelSegment{i}{1,2}=[];
            end
        else
            % size==2
            if norm(intersect_points(1,:)-intersect_points(2,:))>1e-6
                ReflectVisibelSegment{i}{1,1}=intersect_points(1,:);
                ReflectVisibelSegment{i}{1,2}=intersect_points(2,:);
            else
                ReflectVisibelSegment{i}{1,1}=intersect_points(1,:);
            end
        end
    else

        if size(intersect_points,1)==2
            if norm(intersect_points(1,:)-intersect_points(2,:))>1e-6

                ReflectVisibelSegment{i}{1,1}=intersect_points(1,:);
                ReflectVisibelSegment{i}{1,2}=intersect_points(2,:);
            else
                ReflectVisibelSegment{i}{1,1}=[];
                ReflectVisibelSegment{i}{1,2}=[];
            end
        else
            ReflectVisibelSegment{i}{1,1}=[];
            ReflectVisibelSegment{i}{1,2}=[];
        end
    end
    
    if ~isempty(ReflectVisibelSegment{i}{1,1})&&~isempty(ReflectVisibelSegment{i}{1,2})
        if norm(ReflectVisibelSegment{i}{1,1}-ReflectVisibelSegment{i}{1,2})<1e-6
            ReflectVisibelSegment{i}{1,1}=[];
            ReflectVisibelSegment{i}{1,2}=[];
        end
    end
end


        G=size(ReflectVisibelSegment,1);
        for i = 1:G
             if ~isempty(ReflectVisibelSegment{i}) % cell
                ReflectVisibelSegment{i} = ReflectVisibelSegment{i}(~cellfun('isempty', ReflectVisibelSegment{i}));
            end
        end
end