function PlotSimpleOri
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
figure
    hold on; 
    pbaspect([1 1 1]);

    %building1
    x1=[-13.655,4.84521,-1.20483,-25.6936];
    y1=[38.2432,29.6533,18.5225,22.8193];
    p1=fill(x1,y1,[0.8,0.8,0.8]);
    p1.EdgeColor="none";
    %building2
    x2=[9.41943,37.968,33.3076,3.59473];
    y2=[28.9414,15.9336,6.6123,17.1094];
    p2=fill(x2,y2,[0.8,0.8,0.8]);
    p2.EdgeColor="none";
    %building3
    x3=[-25.6326,-6.39038,-6.9646,-25.2842,-25.573,-44.8118,-44.7041,-27.5312];
    y3=[0.896484,-0.162109,-14.7646,-13.7129,-21.2363,-19.7227,-5.80469,-7.06934];
    p3=fill(x3,y3,[0.8,0.8,0.8]);
    p3.EdgeColor="none";
    %building4
    x4=[0.775391,18.8728,19.3887,39.0891,38.2874,20.8718,20.3625,0.660645];
    y4=[-7.17676,-8.22754,-1.16113,-1.53516,-16.8242,-16.0127,-23.3125,-22.0166];
    p4=fill(x4,y4,[0.8,0.8,0.8]);
    p4.EdgeColor="none";
    % BS
    for i = size(L,1)-3:size(L,1)
        plot([L{i}{1,1}(1),L{i}{1,2}(1)], [L{i}{1,1}(2),L{i}{1,2}(2)], 'k', 'LineWidth', 1);
    end
    xlim([x_min-1, x_max+1]); ylim([y_min-1, y_max+1]);
    set(gca,'XTick',[],'YTick',[])
end