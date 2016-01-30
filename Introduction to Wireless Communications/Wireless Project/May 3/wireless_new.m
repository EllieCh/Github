%function wireless_final_project()
clc
close all;
clear all;
N1 = 100; %100 symbols
N2 = 5; %Monte-Carlo trials for each symbol
range = 10:30;  %Range for Adaptive Modulation
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%simulator coding

pilot = rand(1,4)>0.5;  %pseudo binary sequence
BPSK_pilot = BPSK(1,pilot); %BPSK Modulated pilot signal
AWGNSNRdB = [3 5 7 9 11];
AWGNSNR = 10.^((AWGNSNRdB)./10); %SNR in linear scale

for p = 1:N1
    in_QPSK = rand(1,2*48)>0.5;  %input to QPSK modulator
    in_QAM = rand(1,4*48)>0.5;   %input to 16 QAM modulator

    for q = 1:length(AWGNSNR)
        for r = 1:N2
            %QPSK Modulation
            QPSK_Mod = QPSK(1,in_QPSK); %QPSK Modulation
            QPSK_Mod_OFDM = ofdmTransmit(QPSK_Mod,BPSK_pilot);  %OFDM Transmission
            QPSK_Mod_OFDM_Channel = awgnChannel(QPSK_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
            [QPSK_Demod_OFDM temp] = ofdmReceive(1,QPSK_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
            QPSK_Demod = QPSK(2,QPSK_Demod_OFDM);   %QPSK Demodulation
            er(r) = sum(in_QPSK ~= QPSK_Demod)/(48*2);   %bit error probability
        end
        for t = 1:N2
            %16 QAM Modulation
            QAM_Mod = QAM(1,in_QAM); %QAM Modulation
            QAM_Mod_OFDM = ofdmTransmit(QAM_Mod,BPSK_pilot);  %OFDM Transmission
            QAM_Mod_OFDM_Channel = awgnChannel(QAM_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
            [QAM_Demod_OFDM, temp] = ofdmReceive(1,QAM_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
            QAM_Demod = QAM(2,QAM_Demod_OFDM);   %QAM Demodulation
            er(t) = sum(in_QAM ~= QAM_Demod)/(48*4);   %bit error probability
        end
        per(p,q) = sum(er)/N2;
     end
end

for q = 1:length(AWGNSNR)
    ber(q) = sum(per(:,q))/N1;
end
% QPSK Modulation
figure
semilogy(AWGNSNRdB,ber,'r','marker','*');
title('Error Probability vs SNR for QPSK to AWGN channel');
xlabel('SNR in dB -->');
ylabel('Pe -->');
grid on;
% 16 QAM Modulation
figure
semilogy(AWGNSNRdB,ber,'r','marker','*');
title('Error Probability vs SNR for 16 QAM to AWGN channel');
xlabel('SNR in dB -->');
ylabel('Pe -->');
grid on;
      
AWGNSNRdB = 0:30;
AWGNSNR = 10.^((AWGNSNRdB)./10); %SNR in linear scale
for p = 1:N1
    in_QPSK = rand(1,2*48)>0.5;  %input to QPSK modulator
    in_QAM = rand(1,4*48)>0.5;   %input to 16 QAM modulator
    [tapsIndoor tapsOutdoor] = multipathChannelTaps();

    for q = 1:length(AWGNSNR)
        for r = 1:N2
            %QPSK Modulation
            QPSK_Mod = QPSK(1,in_QPSK); %QPSK Modulation
            QPSK_Mod_OFDM = ofdmTransmit(QPSK_Mod,BPSK_pilot);  %OFDM Transmission
            [QPSK_Mod_OFDM_ChannelI QPSK_Mod_OFDM_ChannelO] = multipathChannel(QPSK_Mod_OFDM, AWGNSNR(q), tapsIndoor, tapsOutdoor);  %Multipath Channel
            [QPSK_Demod_OFDMI QPSK_Demod_OFDMO] = ofdmReceive(2,QPSK_Mod_OFDM_ChannelI,QPSK_Mod_OFDM_ChannelO,tapsIndoor,tapsOutdoor); %OFDM Receiver
            QPSK_DemodI = QPSK(2,QPSK_Demod_OFDMI);   %QPSK Demodulation for Indoor
            QPSK_DemodO = QPSK(2,QPSK_Demod_OFDMO);   %QPSK Demodulation for Outdoor
            erV(r) = sum(in_QPSK ~= QPSK_DemodI)/(48*2);   %bit error probability for Indoor
            erP(r) = sum(in_QPSK ~= QPSK_DemodO)/(48*2);   %bit error probability for Outdoor
                   
            %16 QAM Modulation
            QAM_Mod = QAM(1,in_QAM); %QAM Modulation
            QAM_Mod_OFDM = ofdmTransmit(QAM_Mod,BPSK_pilot);  %OFDM Transmission
            [QAM_Mod_OFDM_ChannelI QAM_Mod_OFDM_ChannelO] = multipathChannel(QAM_Mod_OFDM, AWGNSNR(q), tapsIndoor, tapsOutdoor);  %Multipath Channel
            [QAM_Demod_OFDMI QAM_Demod_OFDMO] = ofdmReceive(2,QAM_Mod_OFDM_ChannelI,QAM_Mod_OFDM_ChannelO,tapsIndoor,tapsOutdoor); %OFDM Receiver
            QAM_DemodI = QAM(2,QAM_Demod_OFDMI);   %QAM Demodulation for Indoor
            QAM_DemodO = QAM(2,QAM_Demod_OFDMO);   %QAM Demodulation for Outdoor
            erV(r) = sum(in_QAM ~= QAM_DemodI)/(48*4);   %bit error probability for Indoor
            erP(r) = sum(in_QAM ~= QAM_DemodO)/(48*4);   %bit error probability for Outdoor
        end
    end
    perV(p,q) = sum(erV)/N2;
    perP(p,q) = sum(erP)/N2;
end

for q = 1:length(AWGNSNR)   %Total Probability
    berV(q) = sum(perV(:,q))/N1;    
    berP(q) = sum(perP(:,q))/N1;
end
%QPSK
figure
semilogy(AWGNSNRdB,berV,'r','marker','*'); hold on;
semilogy(AWGNSNRdB,berP,'b','marker','*'); 
legend('Indoor','Outdoor',1); 
title('Error Probability vs SNR for QPSK to Multipath channel');
xlabel('SNR in dB -->');
ylabel('Pe -->');
grid on;
%16 QAM
figure
semilogy(AWGNSNRdB,berV,'r','marker','*'); hold on;
semilogy(AWGNSNRdB,berP,'b','marker','*'); 
legend('Indoor','Outdoor',1); 
title('Error Probability vs SNR for 16 QAM to Multipath channel');
xlabel('SNR in dB -->');
ylabel('Pe -->');
grid on;
%Adaptive Modulation 
EmpSpecEffI = zeros(1,length(range));
EmpSpecEffO = zeros(1,length(range));
for k = 1:N1
    [tapsIndoor tapsOutdoor] = multipathChannelTaps();
    [spectralEffI spectralEffO] = adaptiveModulation(0,tapsIndoor,tapsOutdoor);
    EmpSpecEffI = EmpSpecEffI + spectralEffI;
    EmpSpecEffO = EmpSpecEffO + spectralEffO;
end

EmpSpecEffI = EmpSpecEffI./N1;
EmpSpecEffO = EmpSpecEffO./N1;
figure
plot(range,EmpSpecEffI,'r','marker','*'); hold on;
plot(range,EmpSpecEffO,'b','marker','*'); 
legend('Indoor','Outdoor',2); 
title('Spectral Efficiency vs SNR');
xlabel('SNR in dB -->');
ylabel('Spectral Efficiency -->');
grid on;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%---FUNCTIONS---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%---OFDM TRANSMITTER---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [transmit] = ofdmTransmit(input, pilot)
nfft = 64;  %Length of fft/ifft
cpLen = 16; %Length of cyclic prefix
cpStart = nfft - cpLen + 1;
cpStop = nfft;

ofdmSequence = [zeros(1,6) input(1:5) pilot(1) input(6:18) pilot(2) input(19:24) zeros(1,1) input(25:30) pilot(3) input(31:43) pilot(4) input(44:48) zeros(1,5)];

inputIFFT = sqrt(nfft)*ifft(ofdmSequence,64);  %IFFT
transmit = [inputIFFT(cpStart:cpStop) inputIFFT];   %Adding Cyclic Prefix
end
%%%%%%%%%%%%%%%%%%%%%%---AWGN CHANNEL---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [receive] = awgnChannel(input, awgnSNR)
inputLen = length(input);   %Input length
nc = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %In-phase noise
ns = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %Quadrature-phase noise
rc = real(input) + nc;
rs = imag(input) + ns;
receive = rc + (1i.*rs);
end
%%%%%%%%%%%%%%%%%%%%%%---MULTIPATH CHANNEL---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Indoor Outdoor] = multipathChannel(input, awgnSNR, tapsIndoor, tapsOutdoor)
inputLen = length(input);   %Input length
nc = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %In-phase noise
ns = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %Quadrature-phase noise
Indoor = ifft((fft(input,inputLen).*fft(tapsIndoor,inputLen)),inputLen) + (nc + (1i*ns));
Outdoor = ifft((fft(input,inputLen).*fft(tapsOutdoor,inputLen)),inputLen) + (nc + (1i*ns));
end
%%%%%%%%%%%%%%%%%%%---MULTIPATH CHANNEL TAPS---%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [IndoorTaps OutdoorTaps] = multipathChannelTaps()
sampleDuration = 1/(10*10^6);   %Channel bandwidth = 10MHz
delayIndoor = (10^-9).*[0 100 200 300 500 700]; %Delay profile for Indoor channel model
relativePowerVdB = [0 -3.6 -7.2 -10.8 -18 -25.2]; %Power profile for indoor channel model
delayOutdoor = (10^-9).*[0 5 30 45 75 90 105 140 210 230 250 270 275 475 595 690]; %Delay profile for Outdoor Multipath channel model
relativePowerPdB = [-1.5 -10.2 -16.6 -19.2 -20.9 -20.6 -16.6 -16.6 -23.9 -12 -23.9 -21 -17.7 -24.6 -22 -29.2]; %Power profile for Outdoor Multipath channel model

relativePowerV = 10.^(relativePowerVdB./10);
relativePowerP = 10.^(relativePowerPdB./10);

for i = 1:1:length(delayIndoor)
    IndoorTaps(round(delayIndoor(i)/sampleDuration) + 1) = sqrt(relativePowerV(i)*((randn(1,1)^2) + (randn(1,1)^2))/2);
end
for i = 1:1:length(delayOutdoor)
    OutdoorTaps(round(delayOutdoor(i)/sampleDuration) + 1) = sqrt(relativePowerP(i)*((randn(1,1)^2) + (randn(1,1)^2))/2);
end
end
%%%%%%%%%%%%%%%%%%%%%%---OFDM RECEIVER---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [IndoorDetection OutdoorDetection] = ofdmReceive(type,indoor, outdoor, IndoorTaps, OutdoorTaps)
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
%%%%%%%%%%%%%%%%%---QPSK MODULATOR/DEMODULATOR---%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output] = QPSK(type, input)

QPSK_signals = [-1-1i -1+1i 1+1i 1-1i]; %corresponding to [-3pi/4 3pi/4 pi/4, -pi/4]
if (type == 1)
    x_QPSK = 2.*input - 1;  %mapping the bits to +1 or -1
    in_quad = reshape(x_QPSK,2,length(input)/2); %QPSK in-phase/quadrature-phase seperation
    xc_QPSK = in_quad(1,:);  %in-phase component (input) for QPSK
    xs_QPSK = in_quad(2,:);  %quadrature-phase component (input) for QPSK
    output = xc_QPSK + (1i.*xs_QPSK);
else
    output = zeros(1,length(input)*2);
    d_QPSK = [abs(input - QPSK_signals(1));
              abs(input - QPSK_signals(2));
              abs(input - QPSK_signals(3));
              abs(input - QPSK_signals(4))];

    for m = 1:length(input)
        s_QPSK = QPSK_signals(find(d_QPSK(:,m)==min(d_QPSK(:,m)),1,'first'));
        output(2*m - 1) = (real(s_QPSK)+1)/2;
        output(2*m) = (imag(s_QPSK)+1)/2;
    end
end
end
%%%%%%%%%%%%%%%%%---16QAM MODULATOR/DEMODULATOR---%%%%%%%%%%%%%%%%%%%%%%%%%
function [output] = QAM(type, input)

QAM_signals = (2/sqrt(10)).*[-3 -1 3 1]; %corresponding to [00 01 10 11] and making Eb = 1
if (type == 1)
    in_quad_QAM = reshape(input,4,length(input)/4);  %QAM in-phase/quadrature-phase bits seperation
    b1 = in_quad_QAM(1,:);  %b1 of QAM
    b2 = in_quad_QAM(2,:);  %b2 of QAM
    b3 = in_quad_QAM(3,:);  %b3 of QAM
    b4 = in_quad_QAM(4,:);  %b4 of QAM
    xc_QAM = zeros(1,length(input)/4);
    xs_QAM = zeros(1,length(input)/4);
    
    for m = 1:length(input)/4
        xc_QAM(m) = QAM_signals(((2*b1(m))+b2(m))+ 1);
        xs_QAM(m) = QAM_signals(((2*b3(m))+b4(m))+ 1);
    end
output = xc_QAM + (1i.*xs_QAM);  
else
    output = zeros(1,length(input)*4);
    d_QAM = zeros(length(QAM_signals)*4,length(input));
    for m = 1:(length(QAM_signals)*4)
        bin = dec2bin(m-1,4);
        d_QAM(m,:) = abs(input - ((QAM_signals(bin2dec(bin(1:2))+ 1))+(1i*(QAM_signals(bin2dec(bin(3:4))+ 1)))));
    end

    for m = 1:length(input)
        bin = dec2bin((find(d_QAM(:,m)==min(d_QAM(:,m)),1,'first')-1),4);
        output(4*m - 3) = str2double(bin(1));
        output(4*m - 2) = str2double(bin(2));
        output(4*m - 1) = str2double(bin(3));
        output(4*m) =  str2double(bin(4));
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%---ADAPTIVE MODULATION---%%%%%%%%%%%%%%%%%%%%%%%%%%
function [spectralEffIndoor spectralEffOutdoor] = adaptiveModulation(type,tapsIndoor,tapsOutdoor)
len_FFT = 64;
range = 10:30;
noisePower = 1./(10.^((range)./10));
if (type == 1)  %MIMO
    fftIndoor = tapsIndoor;
    fftOutdoor = tapsOutdoor;
else
    fftIndoor = fft(tapsIndoor,len_FFT);
    fftOutdoor = fft(tapsOutdoor,len_FFT);
end
spectralEffOutdoor = zeros(1,length(range));
spectralEffIndoor = zeros(1,length(range));

for i = 1:length(range)
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
%end