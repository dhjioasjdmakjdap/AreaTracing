function [Idx_Second,Idx_SecondReflect]=PreReflectSecondVisibelArea(SecondReflectVisibelArea)
        % Reduce iterations
        [Idx_x,Idx_y]=find(~cellfun('isempty', SecondReflectVisibelArea));
        N=size(Idx_x,1);
        Idx_SecondReflect=cell(N,1);
        Idx_Second= [Idx_x,Idx_y];
        for i=1:N
            Idx_SecondReflect{i}=find(~cellfun('isempty', SecondReflectVisibelArea{Idx_x(i),Idx_y(i)}));
        end
end