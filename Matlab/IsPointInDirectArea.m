function [Cir,Delay,tocP,tocC] = IsPointInDirectArea(P,Point, DirectArea)
    % cal CIR
    fc = 2.4e9;
    lamda=physconst('lightspeed')/fc;
    N=size(DirectArea,1);
    Cir=[];
    Delay=[];
    tocP=0;
    tocC=0;
    for i=1:N
        M=size(DirectArea{i},2);
        for j=1:M
            tic
            % PIP
            inside = PointInTriangle(Point, DirectArea{i}{1,j}{1}, DirectArea{i}{1,j}{2}, DirectArea{i}{1,j}{3});
            toc1=toc;
            tocP=tocP+toc1;
            tic
            if inside
                d=norm(P-Point);
                Cir=lamda/(4*pi*d);
                Delay=d/physconst('lightspeed');
                return;
            end
            toc2=toc;
            tocC=toc2+tocC;
        end
    end

end