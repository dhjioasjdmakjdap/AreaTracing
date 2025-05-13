
function [ReflectVisibelSegment,ReflectVisibelArea]=ComputeReflectVisibelSegment(P,Segmengt,L,Index,MaxSegment)
    % reflection shadow testing 

    
    L(Index)=[];
    % choose reflection space
    ChoiseSegment=ChoiceSegments(P,Segmengt,L,MaxSegment);
    % direct shadow testing
    ReflectVisibelSegment = computeVisibleSegments(P, ChoiseSegment);
    % get area
    ReflectVisibelArea=computeVisibleArea(P,Segmengt,ReflectVisibelSegment);
    
    
end


