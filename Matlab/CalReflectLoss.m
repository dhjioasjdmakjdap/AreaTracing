function ReflectLoss=CalReflectLoss(P,imagePoint,Point,RximagePoint)
        % first-order reflection loss
        epsino=5.31+0.4961i;% Dielectric constant
        % reflection anger
        anger=Anger_base_tx_txmirror(P,Point,imagePoint);
        % cal PathDir
        PathDir=[RximagePoint'-P',Point'-imagePoint'];
        PathDir(3,:)=0;
        ReflectLoss=get_average_Rh_Rv(anger,epsino,PathDir);
        
        
end

function anger=Anger_base_tx_txmirror(tx_pos,rx_pos,mirror_point)
    [A, B, ~] = calculate_plane_equation(tx_pos,mirror_point);
    %anger
    anger=Anger([A,B],mirror_point,rx_pos);
      
end

function reflection_esti=get_average_Rh_Rv(theat,epsino,PathDir)
    r3=epsino;
    b=r3-sind(theat).*sind(theat);
    b1=sqrt(b/(r3*r3));
    b2=sqrt(b);
    Rh=(cosd(theat)-b1)./(cosd(theat)+b1);
    Rv=(cosd(theat)-b2)./(cosd(theat)+b2);
    % average_Rh_Rv=(abs(Rh)+abs(Rv))/2;
    refCoeff=[Rh;Rv];
    polMtx= CalPolMtx(PathDir,refCoeff);
    reflection_esti = sum(abs(polMtx),'all')/2;
end



function [A, B, D] = calculate_plane_equation(tx,tx_mirror)

    vector=tx-tx_mirror;
    A=vector(1);
    B=vector(2);   
    equ_point=(tx+tx_mirror)/2;
    D=-dot(vector,equ_point);
end

% reflection anger
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