function [Idx,Idx_Reflect]=PreReflectVisibelArea(ReflectVisibelArea)
        % Reduce iterations
        Idx=find(~cellfun('isempty', ReflectVisibelArea));
        N=size(Idx,1);
        Idx_Reflect=cell(N,1);
        for i=1:N
            Idx_Reflect{i}=find(~cellfun('isempty', ReflectVisibelArea{Idx(i)}));
        end
end