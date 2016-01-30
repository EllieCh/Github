function [IndoorDetection OutdoorDetection] = ofdmReceive(type,indoor, outdoor, IndoorTaps, OutdoorTaps)
%%%%%%%%%%%%%%%%%%%%%%---OFDM RECEIVER---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nfft = 64;   %Length of fft/ifft
outputLen = length(indoor);   %Length of received signal (same for both V and P)

if (type == 1)  %type = 1 for AWGN channel
    IndoorFFT = (1/sqrt(nfft))*fft(indoor(17:80),nfft);
    IndoorDetection = [IndoorFFT(7:11) IndoorFFT(13:25) IndoorFFT(27:32) IndoorFFT(34:39) IndoorFFT(41:53) IndoorFFT(55:59)];
    OutdoorDetection = [];
else
indoor = ifft((fft(indoor,outputLen)./fft(IndoorTaps,outputLen)),outputLen);
outdoor = ifft((fft(outdoor,outputLen)./fft(OutdoorTaps,outputLen)),outputLen);
IndoorFFT = (1/sqrt(nfft))*fft(indoor(17:80),nfft);
OutdoorFFT = (1/sqrt(nfft))*fft(outdoor(17:80),nfft);

IndoorDetection = [IndoorFFT(7:11) IndoorFFT(13:25) IndoorFFT(27:32) IndoorFFT(34:39) IndoorFFT(41:53) IndoorFFT(55:59)];
OutdoorDetection = [OutdoorFFT(7:11) OutdoorFFT(13:25) OutdoorFFT(27:32) OutdoorFFT(34:39) OutdoorFFT(41:53) OutdoorFFT(55:59)];
end
end