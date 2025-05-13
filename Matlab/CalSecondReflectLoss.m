function reflection_esti=CalSecondReflectLoss(P,imagePoint,SecondimagePoint,Point,RximagePoint,SecondRximagePoint)
        % second-order reflection loss
        epsino=5.31+0.4961i;
        anger1=Anger_base_tx_txmirror(P,RximagePoint,imagePoint);
        anger2=Anger_base_tx_txmirror(imagePoint,Point,SecondimagePoint);
        [Rh1,Rv1]=GetRhRv(anger1,epsino);
        [Rh2,Rv2]=GetRhRv(anger2,epsino);
        % PathDir
        PathDir=[SecondRximagePoint'-P',RximagePoint'-imagePoint',Point'-SecondimagePoint'];
        PathDir(3,:)=0;

        refCoeff=[Rh1,Rh2;Rv1,Rv2];
        polMtx= CalPolMtx(PathDir,refCoeff);
        reflection_esti = sum(abs(polMtx),'all')/2;
end


function anger=Anger_base_tx_txmirror(tx_pos,rx_pos,mirror_point)

    [A, B, ~] = calculate_plane_equation(tx_pos,mirror_point);

    anger=Anger([A,B],mirror_point,rx_pos);
end


function [Rh,Rv]=GetRhRv(theat,epsino)
        r3=epsino;
        b=r3-sind(theat).*sind(theat);
        b1=sqrt(b/(r3*r3));
        b2=sqrt(b);
        Rv=(cosd(theat)-b1)./(cosd(theat)+b1);
        Rh=(cosd(theat)-b2)./(cosd(theat)+b2);
end



function [A, B, D] = calculate_plane_equation(tx,tx_mirror)

    vector=tx-tx_mirror;
    A=vector(1);
    B=vector(2);   

    equ_point=(tx+tx_mirror)/2;
    D=-dot(vector,equ_point);
end


function angle_deg=Anger(n,mirror_point,rx_pos)

    re=rx_pos-mirror_point;
    dot_product = dot(re, n);


    norm_re = norm(re);
    norm_n = norm(n);
    

    cos_angle = dot_product / (norm_re * norm_n);
    angle_rad = acos(cos_angle);
    
    angle_deg = rad2deg(angle_rad);
    if angle_deg>90
       angle_deg=180-angle_deg;
    end

end