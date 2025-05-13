function L_new=PreData(L_old)
    % Format conversion
    N=size(L_old,1);
    L_new=cell(N,1);
    for i=1:N
        L_new{i}{1,1}=[L_old(i,1,1),L_old(i,1,2)];
        L_new{i}{1,2}=[L_old(i,2,1),L_old(i,2,2)];
    end
end