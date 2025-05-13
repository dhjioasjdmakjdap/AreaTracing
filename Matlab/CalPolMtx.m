    function polMtx= CalPolMtx(pathDir,refCoeff)

        rxAxes=eye(3);
        txAxes=eye(3);
        % Calculate polarization and propagation matrices. If the ray is direct
        % (line-of-sight), the math is simpler than for indirect ray.
        propMtx = complex(eye(3));

        pathNorm = sqrt(sum(pathDir.^2, 1));
        pathDir = pathDir./pathNorm;

        % Get V-pol direction of the TX's E-field.  This uses the fact that
        % the V-pol starts as the ray direction rotated -theta 90 degrees.
        incPath = pathDir(:,1);
        incVPolDir = getVPolDir(incPath, txAxes); % [x;y;z]

        % Get pol. directions of the E field at Rx, using the last segment
        rxVPolDir = getVPolDir(pathDir(:,end), rxAxes); % [x;y;z]
        rxHPolDir = cross(rxVPolDir, pathDir(:,end));   % Yun convention

        % Iterate through reflection interactions to derive polarization
        % matrix
        outPath = incPath;
        refCoeffIdx = 1;
        for intIdx = 1:size(refCoeff,2)
            % Determine polarization coupling matrix.  This is a repeated
            % product for each interaction.
            incPath = outPath;
            outPath = pathDir(:, intIdx+1);
            % Rotation matrix to local surface for H/V pol.
            % [Yun 2011, (2.2.3)-(2.2.4)]
            if sum(abs(incPath+outPath)) < eps % Normal incidence (outPath = -incPath)
                s_in = cross(incPath, outPath+eps);
            else
                s_in = cross(incPath, outPath);
            end
            s_in = s_in / norm(s_in);
            p_in = cross(incPath, s_in);
            rotMtxIn = [s_in p_in incPath];

            % Rotation matrix back to global coordinates
            % [Yun 2011, (2.2.3)-(2.2.4)]
            p_out = cross(outPath, s_in);
            rotMtxOut = [s_in p_out outPath];

            % Cascade reflection into polarization matrix
            % [Yun 2011, (2.2.6)-(2.2.7), pg. 68]
            propMtx = rotMtxOut * diag([refCoeff(:,refCoeffIdx)' 1]) ...
                * rotMtxIn' * propMtx;

            % Increment reflection coefficient index
            refCoeffIdx = refCoeffIdx + 1;
        end

        % Calculate propagated V & H fields in 3D Cartesian
        propVPol = propMtx * incVPolDir;
        propHPol = propMtx * cross(incVPolDir, pathDir(:,1)); % Yun convention

        % Project propagated fields against expected receiver polarizations
        polMtx = [dot(propHPol, rxHPolDir) dot(propVPol, rxHPolDir); ...
            dot(propHPol, rxVPolDir) dot(propVPol, rxVPolDir)];
end

function VPolDirGCS = getVPolDir(rayDirGCS, LCS2GCSAxes)

% If 'LCS2GCSAxes' is eye(3), then local = global coordinates. Otherwise,
% perform coordinate transformation.
if isequal(LCS2GCSAxes, eye(3))
    % Get ray spherical direction in LCS
    [az, el] = cart2sph(rayDirGCS(1), rayDirGCS(2), rayDirGCS(3));
    % Get V-pol Cartesian direction in LCS
    [x, y, z] = sph2cart(az, el+pi/2, 1);
    VPolDirGCS = [x;y;z];
else
    % Get ray Cartesian direction in LCS
    rayDirLCS = global2localcoord(rayDirGCS, 'rr', zeros(3,1), LCS2GCSAxes);
    % Get ray spherical direction in LCS
    [az, el] = cart2sph(rayDirLCS(1), rayDirLCS(2), rayDirLCS(3));
    % Get V-pol Cartesian direction in LCS
    [x, y, z] = sph2cart(az, el+pi/2, 1);
    % Get V-pol Cartesian direction in GCS
    VPolDirGCS = local2globalcoord([x; y; z], 'rr', zeros(3,1), LCS2GCSAxes);
end

end