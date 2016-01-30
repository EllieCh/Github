function [vehicular pedestrian] = multipathChannel(input, awgnSNR, tapsV, tapsP)
%%%%%%%%%%%%%%%%%%%%%%---MULTIPATH CHANNEL---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputLen = length(input);   %Input length
nc = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %In-phase noise
ns = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %Quadrature-phase noise

vehicular = ifft((fft(input,inputLen).*fft(tapsV,inputLen)),inputLen) + (nc + (1i*ns));
pedestrian = ifft((fft(input,inputLen).*fft(tapsP,inputLen)),inputLen) + (nc + (1i*ns));
end