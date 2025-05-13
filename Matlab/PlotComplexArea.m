clc,clear
%% Data preprocessing
P=[0,0];
% load Data
load('ComplexScenario.mat')

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
figure
hold on; 
pbaspect([1 1 1]);
P = [0, 0];
plot(P(1), P(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
text(P(1) + 6, P(2), 'P', 'FontSize', 15, 'Color', 'k');
%building1
x1=[-117.636,-101.934,-91.3303,-84.0898,-84.1841,-112.583,-117.381];
y1=[150.404,149.094,110.48,108.031,94.7793,96.1904,101.042];
p1=fill(x1,y1,[0.8,0.8,0.8]);
p1.EdgeColor="none";
%building2
x2=[-65.2839,32.0272,34.3795,-61.1304,-65.2839];
y2=[118.132,118.64,109.587,106.658,118.132];
p2=fill(x2,y2,[0.8,0.8,0.8]);
p2.EdgeColor="none";
%building3
x3=[-38.9224,33.0048,31.7197,-37.2021];
y3=[84.8232,85.5225,75.2969,72.168];
p3=fill(x3,y3,[0.8,0.8,0.8]);
p3.EdgeColor="none";
%building4
x4=[-35.7175,22.9055,22.8868,42.8776,42.9863,24.7888,24.8146,-35.6018];
y4=[53.9766,54.5371,56.7129,56.9033,45.7588,45.5879,43.1904,42.6094];
p4=fill(x4,y4,[0.8,0.8,0.8]);
p4.EdgeColor="none";
%building5
x5=[-96.5508,-32.1132,-32.0359,-96.4734];
y5=[21.1875,21.6504,10.8945,10.4424];
p5=fill(x5,y5,[0.8,0.8,0.8]);
p5.EdgeColor="none";
%building6
x6=[-22.3109,29.2081,29.1877,45.02,45.1342,28.9518,28.995,-22.174];
y6=[24.001,24.5781,26.5215,26.6973,16.3076,16.1338,12.6035,12.0342];
p6=fill(x6,y6,[0.8,0.8,0.8]);
p6.EdgeColor="none";
%building7
x7=[57.5027,143.628,144.875,58.7496];
y7=[83.1279,84.7158,17.3096,15.7441];
p7=fill(x7,y7,[0.8,0.8,0.8]);
p7.EdgeColor="none";
%building8
x8=[-47.9779,8.13501,8.28259,-47.8391];
y8=[-39.5732,-39.0615,-54.3691,-54.8809];
p8=fill(x8,y8,[0.8,0.8,0.8]);
p8.EdgeColor="none";
%building9
x9=[25.6062,51.0302,51.472,26.048];
y9=[-46.2119,-45.7041,-67.6738,-68.1816];
p9=fill(x9,y9,[0.8,0.8,0.8]);
p9.EdgeColor="none";
%building10
x10=[71.3865,96.8038,96.4076,70.9901];
y10=[-36.1475,-36.5605,-61.1543,-60.7412];
p10=fill(x10,y10,[0.8,0.8,0.8]);
p10.EdgeColor="none";
%building11
x11=[-95.1533,-62.8507,-61.6696,-93.9722];
y11=[-68.0752,-66.9287,-100.181,-101.315];
p11=fill(x11,y11,[0.8,0.8,0.8]);
p11.EdgeColor="none";
%building12
x12=[-36.9161,-4.85229,-4.8468,-36.9106];
y12=[-83.4961,-83.501,-97.165,-97.1592];
p12=fill(x12,y12,[0.8,0.8,0.8]);
p12.EdgeColor="none";
%building13
x13=[-0.132446,11.5695,13.3375,1.64404];
y13=[-77.8076,-77.3027,-118.15,-118.655];
p13=fill(x13,y13,[0.8,0.8,0.8]);
p13.EdgeColor="none";
%building14
x14=[23.7025,35.7457,38.2596,26.2163];
y14=[-89.4648,-89.0068,-154.723,-155.182];
p14=fill(x14,y14,[0.8,0.8,0.8]);
p14.EdgeColor="none";
%building15
x15=[48.8175,97.8401,98.2428,49.2201];
y15=[-79.5645,-78.3135,-93.7891,-95.04];
p15=fill(x15,y15,[0.8,0.8,0.8]);
p15.EdgeColor="none";
% BS
for i = size(L,1)-3:size(L,1)
    plot([L{i}{1,1}(1),L{i}{1,2}(1)], [L{i}{1,1}(2),L{i}{1,2}(2)], 'k', 'LineWidth', 1);
end
xlim([x_min-1, x_max+1]); ylim([y_min-1, y_max+1]);
set(gca,'XTick',[],'YTick',[])
hold off

%% direct area
PlotComplexOri

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

        PlotComplexOri

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

        plot(imagePoint(1), imagePoint(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
        
        plot(P(1), P(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');

        hold off;
    end
end

%% second-order map
for i=1:N-4
    for j=1:N-4
        if ~isempty(SecondReflectVisibelArea{i,j})
            PlotComplexOri

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
           
            plot(P(1), P(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
            
            plot(SecondImagePoint(1), SecondImagePoint(2), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k','MarkerEdgeColor','none');
            
            hold off
        end
    end
end
