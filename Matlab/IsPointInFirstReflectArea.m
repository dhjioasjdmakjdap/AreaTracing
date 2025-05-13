function [FirstReflectCir,FirstReflectDelay,toc3,toc4]=IsPointInFirstReflectArea(P,Point, ReflectVisibelArea,L,Idx,Idx_Reflect)

        fc = 2.4e9;
        lamda=physconst('lightspeed')/fc;
        FirstReflectCir=[];
        FirstReflectDelay=[];
        N=size(Idx,1);
        toc3=0;
        toc4=0;
        for i=1:N
            M=size(Idx_Reflect{i},1);
            flag=false;
            for j=1:M
                O=size(ReflectVisibelArea{Idx(i)}{Idx_Reflect{i}(j)},2);
                for k=1:O/4
                    A=ReflectVisibelArea{Idx(i)}{Idx_Reflect{i}(j)}{1,4*k-3};
                    B=ReflectVisibelArea{Idx(i)}{Idx_Reflect{i}(j)}{1,4*k-2};
                    C=ReflectVisibelArea{Idx(i)}{Idx_Reflect{i}(j)}{1,4*k-1};
                    D=ReflectVisibelArea{Idx(i)}{Idx_Reflect{i}(j)}{1,4*k};
                    tic
                    isInside = PointInQuad(Point, A, B, C, D);
                    toc1=toc;
                    toc3=toc3+toc1;
                    tic
                    if isInside
                        flag=true;

                        imagePoint = computeImagePoint(P, L{Idx(i),1}{1}, L{Idx(i),1}{2});

                        RximagePoint = computeImagePoint(Point, L{Idx(i),1}{1}, L{Idx(i),1}{2});

                        intersection= findIntersection(P, imagePoint, Point);
                        if (norm(intersection-L{Idx(i),1}{1})<1e-6)||(norm(intersection-L{Idx(i),1}{2})<1e-6)
                            break;
                        end

                        ReflectLoss=CalReflectLoss(P,imagePoint,Point,RximagePoint);

                        d=norm(imagePoint-Point);

                        PropLoss=lamda/(4*pi*d);

                        Delay=d/physconst('lightspeed');

                        Loss=PropLoss*ReflectLoss;
                        FirstReflectDelay=[FirstReflectDelay,Delay];
                        FirstReflectCir=[FirstReflectCir,Loss];
                        break;
                    end
                    toc2=toc;
                    toc4=toc4+toc2;
                end
                if flag
                    break;
                end
            end
        end
end