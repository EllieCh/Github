function [IndoorTaps OutdoorTaps] = multipathChannelTaps()
%%%%%%%%%%%%%%%%%%%---MULTIPATH CHANNEL TAPS---%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sampleDuration = 1/(20*10^6);   %Channel bandwidth = 20MHz
% delayV = (10^-9).*[0 30 90 250 400 800]; %Delay profile for Vehicular Multipath channel model
% relativePowerVdB = [-2.5 0 -12.8 -10 -25.2 -16]; %Power profile for Vehicular Multipath channel model
% delayP = (10^-9).*[0 20 80 120 230 370]; %Delay profile for Pedestrian Multipath channel model
% relativePowerPdB = [0 -0.9 -4.9 -8.0 -7.8 -23.9]; %Power profile for Pedestrian Multipath channel model

sampleDuration = 1/(10*10^6);   %Channel bandwidth = 10MHz
delayIndoor = (10^-9).*[0 100 200 300 500 700]; %Delay profile for Indoor channel model
relativePowerVdB = [0 -3.6 -7.2 -10.8 -18 -25.2]; %Power profile for indoor channel model
delayOutdoor = (10^-9).*[0 5 30 45 75 90 105 140 210 230 250 270 275 475 595 690]; %Delay profile for Outdoor Multipath channel model
relativePowerPdB = [-1.5 -10.2 -16.6 -19.2 -20.9 -20.6 -16.6 -16.6 -23.9 -12 -23.9 -21 -17.7 -24.6 -22 -29.2]; %Power profile for Outdoor Multipath channel model

% tapsV = zeros(1,80);
% tapsP = zeros(1,80);

relativePowerV = 10.^(relativePowerVdB./10);
relativePowerP = 10.^(relativePowerPdB./10);

% for i = 1:1:6
%     tapsV(round(delayV(i)/sampleDuration) + 1) = sqrt(relativePowerV(i)*((randn(1,1)^2) + (randn(1,1)^2))/2);
%     tapsP(round(delayP(i)/sampleDuration) + 1) = sqrt(relativePowerP(i)*((randn(1,1)^2) + (randn(1,1)^2))/2);
% end

for i = 1:1:length(delayIndoor)
    IndoorTaps(round(delayIndoor(i)/sampleDuration) + 1) = sqrt(relativePowerV(i)*((randn(1,1)^2) + (randn(1,1)^2))/2);
end
for i = 1:1:length(delayOutdoor)
    OutdoorTaps(round(delayOutdoor(i)/sampleDuration) + 1) = sqrt(relativePowerP(i)*((randn(1,1)^2) + (randn(1,1)^2))/2);
end
end