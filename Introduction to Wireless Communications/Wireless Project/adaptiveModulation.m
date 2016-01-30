function [spectralEffIndoor spectralEffOutdoor] = adaptiveModulation(tapsIndoor,tapsOutdoor)
%%%%%%%%%%%%%%%%%%%%%%%%---ADAPTIVE MODULATION---%%%%%%%%%%%%%%%%%%%%%%%%%%
lengh = 64;
SNRrange = 10:30; %range of average SNR is from 10 to 30dB
noisePower = 1./(10.^((SNRrange)./10));

    fftIndoor = fft(tapsIndoor,lengh);
    fftOutdoor = fft(tapsOutdoor,lengh);

spectralEffOutdoor = zeros(1,length(SNRrange));
spectralEffIndoor = zeros(1,length(SNRrange));

for i = 1:length(SNRrange)
    SNRIndoor = 10*log10((abs(fftIndoor).^2)./noisePower(i));
    SNROutdoor = 10*log10((abs(fftOutdoor).^2)./noisePower(i));
    nbits = 0;
    for j = 1:length(SNRIndoor)
         if ((SNRIndoor(j) >= 10.61) && (SNRIndoor(j) < 13.94))   %QPSK
                nbits = nbits + 2;
                 else if ((SNRIndoor(j) >= 17.25) && (SNRIndoor(j) < 20.4))   %16 QAM
                        nbits = nbits + 4;
                     end
         end
    end          
        
    spectralEffIndoor(i) = nbits/length(SNRIndoor);
    nbits = 0;
    for j = 1:length(SNROutdoor)
          if ((SNROutdoor(j) >= 10.61) && (SNROutdoor(j) < 13.94))   %QPSK
                nbits = nbits + 2;
             else if ((SNROutdoor(j) >= 17.25) && (SNROutdoor(j) < 20.4))   %16 QAM
                        nbits = nbits + 4; 
                 end
          end
    end
    spectralEffOutdoor(i) = nbits/length(SNROutdoor);
end    
end