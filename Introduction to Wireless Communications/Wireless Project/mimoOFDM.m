function [spectralEffMIMOV spectralEffMIMOP] = mimoOFDM()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---MIMO OFDM---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len = 64;
range = 10:30;
spectralEffMIMOP = zeros(1,length(range));
spectralEffMIMOV = zeros(1,length(range));

[taps11V taps11P] = multipathChannelTaps(); %h11
[taps12V taps12P] = multipathChannelTaps(); %h12
[taps21V taps21P] = multipathChannelTaps(); %h21
[taps22V taps22P] = multipathChannelTaps(); %h22

H11V = fft(taps11V, len);
H11P = fft(taps11P, len);

H12V = fft(taps12V, len);
H12P = fft(taps12P, len);

H21V = fft(taps21V, len);
H21P = fft(taps21P, len);

H22V = fft(taps22V, len);
H22P = fft(taps22P, len);

for k = 1:len
    HV = [H11V(k),H12V(k);H21V(k),H22V(k)];
    HP = [H11P(k),H12P(k);H21P(k),H22P(k)];
    
    [UV SV VV] = svd(HV);
    [UP SP VP] = svd(HP);
    
    tapsV = max(SV(1,1), SV(2,2));
    tapsP = max(SP(1,1), SP(2,2));
    [spectralEffV spectralEffP] = adaptiveModulation(1,tapsV,tapsP);
    spectralEffMIMOV = spectralEffMIMOV + spectralEffV;
    spectralEffMIMOP = spectralEffMIMOP + spectralEffP;
end
spectralEffMIMOV = spectralEffMIMOV./len;
spectralEffMIMOP = spectralEffMIMOP./len;
end