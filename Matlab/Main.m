clc,clear
% set sampling density
Density=32;
%% Data preprocessing
P=[0,0];
% load Data
load('ComplexScenario.mat')
mapFileName = ('ComplexScenario.stl');
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
%% Direct Area
% shadow testing
visible_segments = computeVisibleSegments(P, L);
% get direct area
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


%% first-order reflection area

N=size(L,1);
ReflectVisibelSegment=cell(N,1);
ReflectVisibelArea=cell(N,1);
for i=1:N
    % get imagePoint
    imagePoint = computeImagePoint(P, L{i}{1}, L{i}{2});
    M=size(visible_segments{i},2)/2;
    LocalReflectVisibelSegment=cell(1,M);
    LocalReflectVisibelArea=cell(1,M);
    for j=1:M
        Segment={visible_segments{i}{2*j-1},visible_segments{i}{2*j}};
        % shadow testing
        [LocalReflectVisibelSegment{1,j},LocalReflectVisibelArea{1,j}]=ComputeReflectVisibelSegment(imagePoint,Segment,L,i,MaxSegment);
        
        % get reflection area
        ReflectVisibelSegment{i,1}=[ReflectVisibelSegment{i,1};LocalReflectVisibelSegment{1,j}];
        ReflectVisibelArea{i,1}=[ReflectVisibelArea{i,1};LocalReflectVisibelArea{1,j}];
    end
end

%% second-order reflection area
SecondReflectVisibelSegment=cell(N,N);
SecondReflectVisibelArea=cell(N,N);
for i=1:N
    if ~isempty(ReflectVisibelSegment{i})
        for j=1:N-1
            O=size(ReflectVisibelSegment{i}{j},2);
            for k=1:O/2

               if i>j
                    % get ImagePoint
                    if ~isempty(ReflectVisibelSegment{i}{j})
                        % reflective facet
                        FirstImagePoint = computeImagePoint(P, L{i}{1}, L{i}{2});
                        SecondImagePoint = computeImagePoint(FirstImagePoint, L{j}{1}, L{j}{2});
                        FirstSegment={ReflectVisibelSegment{i,1}{j,1}{1,2*k-1},ReflectVisibelSegment{i,1}{j,1}{1,2*k}};
                        % shadow testing
                        [LocalSecondReflectVisibelSegment,LocalSecondReflectVisibelArea]=ComputeReflectVisibelSegment(SecondImagePoint,FirstSegment,L,j,MaxSegment);
                        % get reflection area
                        SecondReflectVisibelSegment{i,j}=[SecondReflectVisibelSegment{i,j};LocalSecondReflectVisibelSegment];
                        SecondReflectVisibelArea{i,j}=[SecondReflectVisibelArea{i,j};LocalSecondReflectVisibelArea];
                    end
                elseif i<=j
                    % get ImagePoint
                    if ~isempty(ReflectVisibelSegment{i}{j})
                        % reflective facet
                        FirstImagePoint = computeImagePoint(P, L{i}{1}, L{i}{2});
                        SecondImagePoint = computeImagePoint(FirstImagePoint, L{j+1}{1}, L{j+1}{2});
                        FirstSegment={ReflectVisibelSegment{i,1}{j,1}{1,2*k-1},ReflectVisibelSegment{i,1}{j,1}{1,2*k}};
                        % shadow testing
                        [LocalSecondReflectVisibelSegment,LocalSecondReflectVisibelArea]=ComputeReflectVisibelSegment(SecondImagePoint,FirstSegment,L,j+1,MaxSegment);
                        % get reflection area
                        SecondReflectVisibelSegment{i,j+1}=[SecondReflectVisibelSegment{i,j+1};LocalSecondReflectVisibelSegment];
                        SecondReflectVisibelArea{i,j+1}=[SecondReflectVisibelArea{i,j+1};LocalSecondReflectVisibelArea];
                    end
               end
            end
        end
    end

end
%% CIR calculation

% no reflection in BS
ReflectVisibelArea=ReflectVisibelArea(1:N-4);
SecondReflectVisibelArea=SecondReflectVisibelArea(1:N-4,1:N-4);
% FOP position
x=linspace(x_min-1,x_max+1,Density);
y=linspace(y_min-1,y_max+1,Density);
AreaDivision_Cir=cell(Density,Density);
% Reduce iterations
[Idx,Idx_Reflect]=PreReflectVisibelArea(ReflectVisibelArea);
[Idx_Second,Idx_SecondReflect]=PreReflectSecondVisibelArea(SecondReflectVisibelArea);

for i=1:Density
    for j=1:Density
        Point=[x(i),y(j)];
        % PIP in direct area
        [DirectCir,DirectDelay]=IsPointInDirectArea(P,Point, DirectArea);
        % PIP in first-order reflection area
        [FirstReflectCir,FirstReflectDelay]=IsPointInFirstReflectArea(P,Point, ReflectVisibelArea,L,Idx,Idx_Reflect);
        % PIP in second-order reflection area
        [SecondReflectCir,SecondReflectDelay]=IsPointInSecondReflectArea(P,Point, SecondReflectVisibelArea,L,Idx_Second,Idx_SecondReflect);
        % Combine CIR
        Cir=[DirectCir,FirstReflectCir,SecondReflectCir];
        Delay=[DirectDelay,FirstReflectDelay,SecondReflectDelay];
        AreaDivision_Cir{i,j}={Cir;Delay};
    end
end

%% IM method

stl=siteviewer("SceneModel",mapFileName);
tx = txsite("cartesian", ...
        "AntennaPosition",[0;0;2], ...
        "TransmitterFrequency",2.4e9,...
         "TransmitterPower",5);
pm = propagationModel("raytracing", ...
        "CoordinateSystem","cartesian", ...
        "Method","image", ...
        "AngularSeparation","low", ...
        "MaxNumReflections",2, ...
        "SurfaceMaterial","concrete");

% Image method
Ray_Cir=cell(Density,Density);
for i=1:Density
    for j=1:Density
        %calculate ray cir
        pos=[x(i);y(j);2];
        rx = rxsite("cartesian", ...
    "AntennaPosition",pos);
        rays=raytrace(tx,rx,pm);
        if ~isempty(rays{1,1})
            % cal CIR
            rx_rtChan = comm.RayTracingChannel(rays{1,1},tx,rx);
            rx_rtChan.SampleRate = 300e6;
            rx_rtChan.ReceiverVirtualVelocity = [0; 0; 0];
            rx_rtChan.ChannelFiltering=false;
            rx_CIR=rx_rtChan();
            AbsCIR=abs(rx_CIR);
            rx_cir=AbsCIR(1,:);
            rx_Delay=zeros(1,length(rx_cir));
            for l=1:length(rx_cir)
                rx_Delay(l)=rays{1, 1}(1, l).PropagationDelay;
            end
        else
            rx_cir=[];
            rx_Delay=[];
        end
        %cal NRMSE
        Ray_Cir{i,j}={rx_cir;rx_Delay};

    end
end
close(stl);
%% SBR method
stl=siteviewer("SceneModel",mapFileName);
tx = txsite("cartesian", ...
        "AntennaPosition",[0;0;2], ...
        "TransmitterFrequency",2.4e9,...
         "TransmitterPower",5);
pm = propagationModel("raytracing", ...
        "CoordinateSystem","cartesian", ...
        "Method","sbr", ...
        "AngularSeparation","low", ...
        "MaxNumReflections",2, ...
        "SurfaceMaterial","concrete");
pm.MaxNumDiffractions = 0;


SBRRay_Cir=cell(Density,Density);
for i=1:Density
    for j=1:Density
        %calculate ray cir
        pos=[x(i);y(j);2];
        rx = rxsite("cartesian", ...
    "AntennaPosition",pos);
        rays=raytrace(tx,rx,pm);
        if ~isempty(rays{1,1})
            % cal CIR
            rx_rtChan = comm.RayTracingChannel(rays{1,1},tx,rx);
            rx_rtChan.SampleRate = 300e6;
            rx_rtChan.ReceiverVirtualVelocity = [0; 0; 0];
            rx_rtChan.ChannelFiltering=false;
            rx_CIR=rx_rtChan();
            AbsCIR=abs(rx_CIR);
            rx_cir=AbsCIR(1,:);
            rx_Delay=zeros(1,length(rx_cir));
            for l=1:length(rx_cir)
                rx_Delay(l)=rays{1, 1}(1, l).PropagationDelay;
            end
        else
            rx_cir=[];
            rx_Delay=[];
        end
        SBRRay_Cir{i,j}={rx_cir;rx_Delay};

    end
end
close(stl);

%% AT NRMSE
AreaCirNRMSE=zeros(Density,Density);
    for i=1:Density
        for j=1:Density

            InvYlabel=AreaDivision_Cir{i,j}{1,1};
            InvXlabel=AreaDivision_Cir{i,j}{2,1};
            [DisInvCirXlabel,DisInvCirYlabel]=continuous_discrete_cir(InvXlabel,InvYlabel);

            RayYlabel=Ray_Cir{i,j}{1,1};
            RayXlabel=Ray_Cir{i,j}{2,1};
            [DisRayCirXlabel,DisRayCirYlabel]=continuous_discrete_cir(RayXlabel,RayYlabel);

            if isempty(RayYlabel)
                AreaCirNRMSE(i,j)=0;
            else
                AreaCirNRMSE(i,j)=calc_nrmse(DisRayCirYlabel,DisInvCirYlabel);
            end

        end
    end
%% SBR NRMSE
SBRNRMSE=zeros(Density,Density);
    for i=1:Density
        for j=1:Density
   
            InvYlabel=SBRRay_Cir{i,j}{1,1};
            InvXlabel=SBRRay_Cir{i,j}{2,1};
            [DisInvCirXlabel,DisInvCirYlabel]=continuous_discrete_cir(InvXlabel,InvYlabel);
            % 处理Ray
            RayYlabel=Ray_Cir{i,j}{1,1};
            RayXlabel=Ray_Cir{i,j}{2,1};
            [DisRayCirXlabel,DisRayCirYlabel]=continuous_discrete_cir(RayXlabel,RayYlabel);
    
            if isempty(RayYlabel)
                SBRNRMSE(i,j)=0;
            else
                SBRNRMSE(i,j)=calc_nrmse(DisRayCirYlabel,DisInvCirYlabel);
            end
        end
    end




