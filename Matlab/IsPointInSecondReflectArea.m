function [SecondReflectCir,SecondReflectDelay,toc5,toc6]=IsPointInSecondReflectArea(P,Point, SecondReflectVisibelArea,L,Idx_Second,Idx_SecondReflect)
        fc = 2.4e9;
        lamda=physconst('lightspeed')/fc;
        SecondReflectCir=[];
        SecondReflectDelay=[];
        toc5=0;
        toc6=0;
        N=size(Idx_Second,1);
        for i=1:N
            O=size(Idx_SecondReflect{i},1);

            flag=false;
            for k=1:O
                    I=size(SecondReflectVisibelArea{Idx_Second(i,1),Idx_Second(i,2)}{Idx_SecondReflect{i}(k),1},2);
                    for kk=1:I/4

                        A=SecondReflectVisibelArea{Idx_Second(i,1),Idx_Second(i,2)}{Idx_SecondReflect{i}(k),1}{1,4*kk-3};
                        B=SecondReflectVisibelArea{Idx_Second(i,1),Idx_Second(i,2)}{Idx_SecondReflect{i}(k),1}{1,4*kk-2};
                        C=SecondReflectVisibelArea{Idx_Second(i,1),Idx_Second(i,2)}{Idx_SecondReflect{i}(k),1}{1,4*kk-1};
                        D=SecondReflectVisibelArea{Idx_Second(i,1),Idx_Second(i,2)}{Idx_SecondReflect{i}(k),1}{1,4*kk};
                        tic
                        isInside = PointInQuad(Point, A, B, C, D);
                        toc1=toc;
                        toc5=toc5+toc1;
                        tic
                        if isInside
                            flag=true;

                            FirstImagePoint=computeImagePoint(P, L{Idx_Second(i,1),1}{1}, L{Idx_Second(i,1),1}{2});
                            SecondImagePoint=computeImagePoint(FirstImagePoint, L{Idx_Second(i,2),1}{1}, L{Idx_Second(i,2),1}{2});

                            RxImagePoint=computeImagePoint(Point, L{Idx_Second(i,2),1}{1}, L{Idx_Second(i,2),1}{2});
                            SecondRximagePoint=computeImagePoint(RxImagePoint, L{Idx_Second(i,1),1}{1}, L{Idx_Second(i,1),1}{2});

                            Iscorner=CalIsCorner(P,FirstImagePoint,RxImagePoint,Point,SecondImagePoint);

                            if ~Iscorner
                       
                                ReflectLoss=CalSecondReflectLoss(P,FirstImagePoint,SecondImagePoint,Point,RxImagePoint,SecondRximagePoint);
                                
                                d=norm(SecondImagePoint-Point);
                                
                                PropLoss=lamda/(4*pi*d);
                                
                                Delay=d/physconst('lightspeed');
                                
                                Loss=PropLoss*ReflectLoss;
                                
                                SecondReflectDelay=[SecondReflectDelay,Delay];
                                SecondReflectCir=[SecondReflectCir,Loss];
                            end
                            break;
                        end
                        toc2=toc;
                        toc6=toc2+toc6;
                    end
                if flag
                   break;
                end
            end
        end
end
