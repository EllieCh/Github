function [tapsIndoor tapsOutdoor] = multipathChannelTaps()
%%%%%%%%%%%%%%%%%%%---MULTIPATH CHANNEL TAPS---%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sampleDuration = 1/(10*10^6);   %Channel bandwidth = 10MHz
delayIndoor = (10^-9).*[0 100 200 300 500 700]; %Delay profile for Indoor channel model
relativePowerVdB = [0 -3.6 -7.2 -10.8 -18 -25.2]; %Power profile for indoor channel model
delayOutdoor = (10^-9).*[0 5 30 45 75 90 105 140 210 230 250 270 275 475 595 690]; %Delay profile for Outdoor Multipath channel model
relativePowerPdB = [-1.5 -10.2 -16.6 -19.2 -20.9 -20.6 -16.6 -16.6 -23.9 -12 -23.9 -21 -17.7 -24.6 -22 -29.2]; %Power profile for Outdoor Multipath channel model

tapsIndoor = zeros(1,80);
tapsOutdoor = zeros(1,80);

relativePowerV = 10.^(relativePowerVdB./10);
relativePowerP = 10.^(relativePowerPdB./10);

for i = 1:length(delayIndoor)
    tapsIndoor(round(delayIndoor(i)/sampleDuration) + 1) = sqrt(relativePowerV(i)*((randn(1,1)^2) + (randn(1,1)^2))/2);
end
for m = 1:length(delayOutdoor)
tapsOutdoor(round(delayOutdoor(m)/sampleDuration) + 1) = sqrt(relativePowerP(m)*((randn(1,1)^2) + (randn(1,1)^2))/2);
end
end