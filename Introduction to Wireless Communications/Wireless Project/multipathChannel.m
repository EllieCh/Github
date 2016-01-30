
function [indoorChan outdoorChan] = multipathChannel(input, awgnSNR, tapsIndoor, tapsOutdoor)
%%%%%%%%%%%%%%%%%%%%%%---MULTIPATH CHANNEL---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputLen = length(input);   %Input length
nc = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %In-phase noise
ns = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %Quadrature-phase noise

indoorChan = ifft((fft(input,inputLen).*fft(tapsIndoor,inputLen)),inputLen) + (nc + (1i*ns));
outdoorChan = ifft((fft(input,inputLen).*fft(tapsOutdoor,inputLen)),inputLen) + (nc + (1i*ns));
end