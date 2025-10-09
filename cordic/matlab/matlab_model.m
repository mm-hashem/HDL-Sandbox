% angle range: [-2pi, 4pi]
% CORDIC range: [-pi/2, pi/2]
function [sine, cosine] = matlab_model(angle)
    %% Variables and constants declarations
    % Fixed-point formats
    Q1_14 = numerictype(1, 16, 14);
    Q4_27 = numerictype(1, 32, 27);
    %Q4_27_q = quantizer('RoundMode', 'fix', 'OverflowMode', 'wrap', 'format', [32 27]);
    F = fimath("RoundingMethod", "Zero", "OverflowAction", "Wrap");
    N = 16; % Number of itereations
    angle_ip = fi(angle, Q4_27, F);
    sign_cos = 1;    
    x_cos_prev = fi(0.607252935103139, Q1_14, F);
    y_sin_prev = fi(0, Q1_14, F);

    % PI Values
    TWO_PI = fi(2*pi, Q4_27, F);
    THREE_PI_ov_2 = fi(3*pi/2, Q4_27, F);
    PI = fi(pi, Q4_27, F);
    PI_ov_2 = fi(pi/2, Q4_27, F);
    
    %% ATAN LUT Creator
    tan_lut = fi(zeros(1, N), Q4_27, F);
    for i = 0:N-1
        tan_lut(i+1) = fi(atan(2^-i), Q4_27, F);
    end

    %% Angle correction logic
    angle_corrected = angle_ip;

    % Angles above 2pi and negative angles
    if angle_ip > TWO_PI
        angle_corrected = accumneg(angle_ip, TWO_PI, "Zero");
    elseif angle_ip < -PI_ov_2
        angle_corrected = accumpos(angle_ip, TWO_PI, "Zero");
    end
    
    % Correcting angles to the I or IV quadrant
    if angle_corrected > THREE_PI_ov_2
        angle_corrected = accumneg(angle_corrected, TWO_PI, "Zero");
    elseif angle_corrected > PI_ov_2
        angle_corrected = accumneg(PI, angle_corrected, "Zero");
        sign_cos = -1;
    end
    
    %% CORDIC Iterations
    z = angle_corrected;
    for i = 0:N-1
        if z.bin(1) == '1'
            direction = -1;
        else
            direction = 1;
        end

        if direction == -1
            x_cos = accumpos(x_cos_prev, bitsra(y_sin_prev, i), "Zero");
            y_sin = accumneg(y_sin_prev, bitsra(x_cos_prev, i), "Zero");
            z = accumpos(z, tan_lut(i + 1), "Zero");
        elseif direction == 1
            x_cos = accumneg(x_cos_prev, bitsra(y_sin_prev, i), "Zero");
            y_sin = accumpos(y_sin_prev, bitsra(x_cos_prev, i), "Zero");
            z = accumneg(z, tan_lut(i + 1), "Zero");
        end
        x_cos_prev = x_cos;
        y_sin_prev = y_sin;
    end

    sine = y_sin;
    if sign_cos == 1
        cosine = x_cos;
    elseif sign_cos == -1
        cosine = -x_cos;
    end

    %display(angle, sine, cosine);
end

%% Displaying the results
function display(angle, sine, cosine)
    x_cos_geo = cos(angle);
    y_sin_geo = sin(angle);
    angle_cordic = atan2(sine, cosine)*180.0/pi;
    angle_geo = atan2(y_sin_geo, x_cos_geo)*180.0/pi;
    fprintf("\tCos\t\t\tSin\t\t\tAngle\n");
    fprintf("CORDIC\t%0.15f\t%0.15f\t%f\n" + ...
            "GEOMET\t%f\t\t%f\t\t%f\n" + ...
            "Differ\t%f\t\t%f\t\t%f\n" + ...
            "Percen\t%f\t\t%f\t\t%f\n\n", ...
            cosine, sine, angle_cordic, ...
            x_cos_geo, y_sin_geo, angle_geo, ...
            cosine - x_cos_geo, sine - y_sin_geo, angle_cordic - angle_geo, ...
            100*(cosine - x_cos_geo)/x_cos_geo, 100*(sine - y_sin_geo)/y_sin_geo, 100*(angle_cordic - angle_geo)/angle_geo);
end