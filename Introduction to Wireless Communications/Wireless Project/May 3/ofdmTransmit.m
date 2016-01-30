function [transmit] = ofdmTransmit(input, pilot)
%%%%%%%%%%%%%%%%%%%---OFDM TRANSMITTER---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nfft = 64;  %Length of fft/ifft
cpLen = 16; %Length of cyclic prefix
cpStart = nfft - cpLen + 1;
cpStop = nfft;

ofdmSequence = [zeros(1,6) input(1:5) pilot(1) input(6:18) pilot(2) input(19:24) zeros(1,1) input(25:30) pilot(3) input(31:43) pilot(4) input(44:48) zeros(1,5)];

inputIFFT = sqrt(nfft)*ifft(ofdmSequence,64);  %IFFT
transmit = [inputIFFT(cpStart:cpStop) inputIFFT];   %Adding Cyclic Prefix
end