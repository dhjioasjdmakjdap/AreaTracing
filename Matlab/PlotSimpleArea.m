clc,clear
%% Data preprocessing
P=[0,0];
% load Data
load('SimpleScenario.mat')

L=PreData(L);
% Intersect at the endpoints to generate new facets
L = split_segments(L);
% obtain the rectangular boundary
N=size(L,1);
[x_min,x_max,y_min,y_max]=GetRectangularBoundary(L,N);
% BS
AddEdge={
    {[x_min-2,y_min-2],[x_max+2,y_min-2]};
    {[x_max+2,y_min-2],[x_max+2,y_max+2]};
    {[x_max+2,y_max+2],[x_min-2,y_max+2]};
    {[x_min-2,y_max+2],[x_min-2,y_min-2]}};
L=[L;AddEdge];
% Reflection Space size
MaxSegment=10000;
%% shadow testing
tic
visible_segments = computeVisibleSegments(P, L);
N=size(visible_segments,1);
DirectArea=cell(N,1);
for i=1:N
    if isempty(visible_segments{i})
        DirectArea{i}=[];
        continue;
    end
    M=size(visible_segments{i},2);
    for j=1:M/2
       DirectArea{i}{1,j}={P,visible_segments{i}{1,2*j-1},visible_segments{i}{1,2*j}};
    end
end


%% first-order

N=size(L,1);
ReflectVisibelSegment=cell(N,1);
ReflectVisibelArea=cell(N,1);
for i=1:N

    imagePoint = computeImagePoint(P, L{i}{1}, L{i}{2});
    M=size(visible_segments{i},2)/2;
    LocalReflectVisibelSegment=cell(1,M);
    LocalReflectVisibelArea=cell(1,M);
    for j=1:M
        Segment={visible_segments{i}{2*j-1},visible_segments{i}{2*j}};

        [LocalReflectVisibelSegment{1,j},LocalReflectVisibelArea{1,j}]=ComputeReflectVisibelSegment(imagePoint,Segment,L,i,MaxSegment);
        

        ReflectVisibelSegment{i,1}=[ReflectVisibelSegment{i,1};LocalReflectVisibelSegment{1,j}];
        ReflectVisibelArea{i,1}=[ReflectVisibelArea{i,1};LocalReflectVisibelArea{1,j}];
    end
end

%% second-order
SecondReflectVisibelSegment=cell(N,N);
SecondReflectVisibelArea=cell(N,N);
for i=1:N
    if ~isempty(ReflectVisibelSegment{i})
        for j=1:N-1
            O=size(ReflectVisibelSegment{i}{j},2);
            for k=1:O/2

               if i>j

                    if ~isempty(ReflectVisibelSegment{i}{j})
                        FirstImagePoint = computeImagePoint(P, L{i}{1}, L{i}{2});
                        SecondImagePoint = computeImagePoint(FirstImagePoint, L{j}{1}, L{j}{2});
                        FirstSegment={ReflectVisibelSegment{i,1}{j,1}{1,2*k-1},ReflectVisibelSegment{i,1}{j,1}{1,2*k}}; 
                        [LocalSecondReflectVisibelSegment,LocalSecondReflectVisibelArea]=ComputeReflectVisibelSegment(SecondImagePoint,FirstSegment,L,j,MaxSegment);
                        SecondReflectVisibelSegment{i,j}=[SecondReflectVisibelSegment{i,j};LocalSecondReflectVisibelSegment];
                        SecondReflectVisibelArea{i,j}=[SecondReflectVisibelArea{i,j};LocalSecondReflectVisibelArea];
                    end
                elseif i<=j

                    if ~isempty(ReflectVisibelSegment{i}{j})
                        FirstImagePoint = computeImagePoint(P, L{i}{1}, L{i}{2});
                        SecondImagePoint = computeImagePoint(FirstImagePoint, L{j+1}{1}, L{j+1}{2});
                        FirstSegment={ReflectVisibelSegment{i,1}{j,1}{1,2*k-1},ReflectVisibelSegment{i,1}{j,1}{1,2*k}};
                        [LocalSecondReflectVisibelSegment,LocalSecondReflectVisibelArea]=ComputeReflectVisibelSegment(SecondImagePoint,FirstSegment,L,j+1,MaxSegment);
                        SecondReflectVisibelSegment{i,j+1}=[SecondReflectVisibelSegment{i,j+1};LocalSecondReflectVisibelSegment];
                        SecondReflectVisibelArea{i,j+1}=[SecondReflectVisibelArea{i,j+1};LocalSecondReflectVisibelArea];
                    end
               end
            end
        end
    end

end


%% Plotcomplex
PlotSimpleOri

%% direct map
PlotSimpleOri
N=size(DirectArea,1);
c1=[250,148,51]./255;
c2=[246,180,111]./255;
c3=[242,211,177]./255;
for i=1:N
    if ~isempty(DirectArea{i})
        M=size(DirectArea{i},2);
        for j=1:M
            patch([DirectArea{i}{1,j}{1}(1),DirectArea{i}{1,j}{2}(1),DirectArea{i}{1,j}{3}(1)], [DirectArea{i}{1,j}{1}(2),DirectArea{i}{1,j}{2}(2),DirectArea{i}{1,j}{3}(2)], c1,'FaceAlpha', 0.9, 'EdgeColor', 'none');
        end
    end
end
plot(P(1), P(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
hold off

%% first-order map

for i=1:N-4
    if ~isempty(ReflectVisibelArea{i})
        PlotSimpleOri
        imagePoint = computeImagePoint(P, L{i}{1,1}, L{i}{1,2});
        M=size(ReflectVisibelArea{i,1},1);
        for k=1:M
            O=size(ReflectVisibelArea{i,1}{k,1},2);
            for kk=1:O/4
                if isempty(ReflectVisibelArea{i,1}{k,1}{1,4*kk-3})
                    continue;
                end
                x=[ReflectVisibelArea{i}{k,1}{1,4*kk-3}(1),ReflectVisibelArea{i}{k,1}{1,4*kk-2}(1),ReflectVisibelArea{i}{k,1}{1,4*kk-1}(1),ReflectVisibelArea{i}{k,1}{1,4*kk}(1)];
                y=[ReflectVisibelArea{i}{k,1}{1,4*kk-3}(2),ReflectVisibelArea{i}{k,1}{1,4*kk-2}(2),ReflectVisibelArea{i}{k,1}{1,4*kk-1}(2),ReflectVisibelArea{i}{k,1}{1,4*kk}(2)];
                T = convhull(x, y);
                patch(x(T), y(T), c2,'FaceAlpha', 0.9, 'EdgeColor', 'none');
              
            end
        end
        plot(P(1), P(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
        hold off;
    end
end


%% second-order map
for i=1:N-4
    for j=1:N-4
        if ~isempty(SecondReflectVisibelArea{i,j})
            PlotSimpleOri

            FirstImagePoint = computeImagePoint(P, L{i}{1}, L{i}{2});
            SecondImagePoint = computeImagePoint(FirstImagePoint, L{j}{1}, L{j}{2});
            Q=size(SecondReflectVisibelArea{i,j},1);
            for kk=1:Q
                if ~isempty(SecondReflectVisibelArea{i,j}{kk,1})
                    O=size(SecondReflectVisibelArea{i,j}{kk,1},2);
                    for kkk = 1:O/4
                        if isempty(SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk-3})
                            continue;
                        end
                        x=[SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk-3}(1),SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk-2}(1),SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk-1}(1),SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk}(1)];
                        y=[SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk-3}(2),SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk-2}(2),SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk-1}(2),SecondReflectVisibelArea{i,j}{kk,1}{1,4*kkk}(2)];
                        T = convhull(x, y);
                        patch(x(T), y(T), c3,'FaceAlpha', 0.9, 'EdgeColor', 'none');
                    end
                end
            end
            plot(FirstImagePoint(1), FirstImagePoint(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
            % text(FirstImagePoint(1) + 1.5, FirstImagePoint(2), 'P^1', 'FontSize', 15, 'Color', 'k');
            plot(P(1), P(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
            % text(P(1) + 1.5, P(2), 'P', 'FontSize', 15, 'Color', 'k');
            plot(SecondImagePoint(1), SecondImagePoint(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
            % text(SecondImagePoint(1) + 1.5, SecondImagePoint(2), 'P^2', 'FontSize', 15, 'Color', 'k');
            hold off
        end
    end
end
