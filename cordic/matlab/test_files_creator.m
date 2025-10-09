clear all; clc
Q4_27 = numerictype(1, 32, 27);
F = fimath("RoundingMethod", "Zero", "OverflowAction", "Wrap");

outputFile = fopen('output_matlab.txt', 'w');

% Angles from -360 to 720 in 45 degrees steps
for i=-2.0*pi:pi/4.0:4.0*pi
    [sin_o, cos_o] = matlab_model(i);
    fprintf(outputFile, "%s %s %s %0.0f\n", fi(i, Q4_27, F).hex, sin_o.hex, cos_o.hex, i*180.0/pi);
end

% Random Angles between -360 and 720
minVal = -2.0*pi;
maxVal =  4.0*pi;
for i=1:10
    randFixed = fi(minVal + (maxVal - minVal) * rand, Q4_27, F);
    [sin_o, cos_o] = matlab_model(randFixed);
    fprintf(outputFile, "%s %s %s %f\n", randFixed.hex, sin_o.hex, cos_o.hex, randFixed*180.0/pi);
end
fclose('all');