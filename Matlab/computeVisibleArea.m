function ReflectVisibelArea=computeVisibleArea(P,Segmengt,ReflectVisibelSegment)

        N=size(ReflectVisibelSegment,1);
        ReflectVisibelArea=cell(N,1);
        for i=1:N
            if ~isempty(ReflectVisibelSegment{i})
            M=size(ReflectVisibelSegment{i},2);
            for j=1:M/2

                A=ReflectVisibelSegment{i}{1,2*j-1};
                B=ReflectVisibelSegment{i}{1,2*j};

                [intersectionSegmentA,~] = ray_segment_intersection(P, A, Segmengt{1}, Segmengt{2});
                [intersectionSegmentB,~] = ray_segment_intersection(P, B, Segmengt{1}, Segmengt{2});

                ReflectVisibelArea{i}{1,4*j-3}=A;
                ReflectVisibelArea{i}{1,4*j-2}=B;
                ReflectVisibelArea{i}{1,4*j-1}=intersectionSegmentA(1:2);
                ReflectVisibelArea{i}{1,4*j}=intersectionSegmentB(1:2);
            end
            end
        end
end


