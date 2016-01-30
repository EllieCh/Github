function [IndoorDetection OutdoorDetection] = ofdmReceive(type,indoor, outdoor, IndoorTaps, OutdoorTaps)
%%%%%%%%%%%%%%%%%%%%%%---OFDM RECEIVER---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nfft = 64;   %Length of fft/ifft
outputLen = length(indoor);   %Length of received signal (same for both V and P)

if (type == 1)  %type = 1 for AWGN channel
    Indoorfft = (1/sqrt(nfft))*fft(indoor(17:80),nfft);
    IndoorDetection = [Indoorfft(7:11) Indoorfft(13:25) Indoorfft(27:32) Indoorfft(34:39) Indoorfft(41:53) Indoorfft(55:59)];
    OutdoorDetection = [];
else
indoor = ifft((fft(indoor,outputLen)./fft(IndoorTaps,outputLen)),outputLen);
outdoor = ifft((fft(outdoor,outputLen)./fft(OutdoorTaps,outputLen)),outputLen);
Indoorfft = (1/sqrt(nfft))*fft(indoor(17:80),nfft);
Outdoorfft = (1/sqrt(nfft))*fft(outdoor(17:80),nfft);

IndoorDetection = [Indoorfft(7:11) Indoorfft(13:25) Indoorfft(27:32) Indoorfft(34:39) Indoorfft(41:53) Indoorfft(55:59)];
OutdoorDetection = [Outdoorfft(7:11) Outdoorfft(13:25) Outdoorfft(27:32) Outdoorfft(34:39) Outdoorfft(41:53) Outdoorfft(55:59)];
end
end