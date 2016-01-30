function wireless_final_project()
clc
close all;
clear all;
% disp('                              Physical Layer Simulation of OFDM System');
% disp('                              ========================================');
% disp('      ');
% 
% disp('Please enter the following input parameters');
% disp('-------------------------------------------');
% disp('      ');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%input parameters

% disp('1. BPSK');
% disp('2. QPSK');
% disp('3. 16 QAM');
%M = input('Select modulation scheme (1/2/3): ');    %Modulation scheme
% if ((isempty(M)) || (M>3))
%     disp('None/invalid input entered..Using BPSK as default modulation');
%     M = 1;
% end

% disp('      ');
% disp('1. AWGN Channel');
% disp('2. Multipath Channel');
% C = input('Select channel (1/2): ');    %Channel
% if ((isempty(C)) || (C>3))
%     disp('None/invalid input entered..Using AWGN as default channel');
%     C = 1;
% end
% 
% disp('      ');
% disp('Please wait...Simulation is in progress...');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%assumptions

N1 = 100; %100 symbols
N2 = 5; %Monte-Carlo trials for each symbol
range = 10:30;  %Range for Adaptive Modulation
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%simulator coding

pilot = rand(1,4)>0.5;  %pseudo binary sequence
BPSK_pilot = BPSK(1,pilot); %BPSK Modulated pilot signal

%switch C
    %case 1
        AWGNSNRdB = [3 5 7 9 11];
        AWGNSNR = 10.^((AWGNSNRdB)./10); %SNR in linear scale
        for p = 1:N1
            in_BPSK = rand(1,48)>0.5;  %input to BPSK modulator
            in_QPSK = rand(1,2*48)>0.5;  %input to QPSK modulator
            in_QAM = rand(1,4*48)>0.5;   %input to 16 QAM modulator

            for q = 1:length(AWGNSNR)
                for r = 1:N2
                   % switch M
                       % case 1
                            %BPSK Modulation
                            BPSK_Mod = BPSK(1,in_BPSK); %BPSK Modulation
                            BPSK_Mod_OFDM = ofdmTransmit(BPSK_Mod,BPSK_pilot);  %OFDM Transmission
                            BPSK_Mod_OFDM_Channel = awgnChannel(BPSK_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
                            [BPSK_Demod_OFDM temp] = ofdmReceive(1,BPSK_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
                            BPSK_Demod = BPSK(2,BPSK_Demod_OFDM);   %BPSK Demodulation
                            er(r) = sum(in_BPSK ~= BPSK_Demod)/48;   %bit error probability

                       % case 2
                            %QPSK Modulation
                            QPSK_Mod = QPSK(1,in_QPSK); %QPSK Modulation
                            QPSK_Mod_OFDM = ofdmTransmit(QPSK_Mod,BPSK_pilot);  %OFDM Transmission
                            QPSK_Mod_OFDM_Channel = awgnChannel(QPSK_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
                            [QPSK_Demod_OFDM temp] = ofdmReceive(1,QPSK_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
                            QPSK_Demod = QPSK(2,QPSK_Demod_OFDM);   %QPSK Demodulation
                            er(r) = sum(in_QPSK ~= QPSK_Demod)/(48*2);   %bit error probability

                        %case 3
                            %16 QAM Modulation
                            QAM_Mod = QAM(1,in_QAM); %QAM Modulation
                            QAM_Mod_OFDM = ofdmTransmit(QAM_Mod,BPSK_pilot);  %OFDM Transmission
                            QAM_Mod_OFDM_Channel = awgnChannel(QAM_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
                            [QAM_Demod_OFDM, temp] = ofdmReceive(1,QAM_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
                            QAM_Demod = QAM(2,QAM_Demod_OFDM);   %QAM Demodulation
                            er(r) = sum(in_QAM ~= QAM_Demod)/(48*4);   %bit error probability

                    %end
                end
                per(p,q) = sum(er)/N2;
            end
        end

        for q = 1:length(AWGNSNR)
            ber(q) = sum(per(:,q))/N1;
        end

        %switch M
          %  case 1
                figure
                semilogy(AWGNSNRdB,ber,'r','marker','*');
                title('Error Probability vs SNR for BPSK to AWGN channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
            %case 2
                figure
                semilogy(AWGNSNRdB,ber,'r','marker','*');
                title('Error Probability vs SNR for QPSK to AWGN channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
           % case 3
                figure
                semilogy(AWGNSNRdB,ber,'r','marker','*');
                title('Error Probability vs SNR for 16 QAM to AWGN channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
       % end
   % case 2
        AWGNSNRdB = 0:30;
        AWGNSNR = 10.^((AWGNSNRdB)./10); %SNR in linear scale
        for p = 1:N1
            in_BPSK = rand(1,48)>0.5;  %input to BPSK modulator
            in_QPSK = rand(1,2*48)>0.5;  %input to QPSK modulator
            in_QAM = rand(1,4*48)>0.5;   %input to 16 QAM modulator
            [tapsV tapsP] = multipathChannelTaps();

            for q = 1:length(AWGNSNR)
                for r = 1:N2
                   % switch M
                    %    case 1
                            %BPSK Modulation
                            BPSK_Mod = BPSK(1,in_BPSK); %BPSK Modulation
                            BPSK_Mod_OFDM = ofdmTransmit(BPSK_Mod,BPSK_pilot);  %OFDM Transmission
                            [BPSK_Mod_OFDM_ChannelV BPSK_Mod_OFDM_ChannelP] = multipathChannel(BPSK_Mod_OFDM, AWGNSNR(q), tapsV, tapsP);  %Multipath Channel
                            [BPSK_Demod_OFDMV BPSK_Demod_OFDMP] = ofdmReceive(2,BPSK_Mod_OFDM_ChannelV,BPSK_Mod_OFDM_ChannelP,tapsV,tapsP); %OFDM Receiver
                            BPSK_DemodV = BPSK(2,BPSK_Demod_OFDMV);   %BPSK Demodulation for Vehicular
                            BPSK_DemodP = BPSK(2,BPSK_Demod_OFDMP);   %BPSK Demodulation for Pedestrian
                            erV(r) = sum(in_BPSK ~= BPSK_DemodV)/48;   %bit error probability for Vehicular
                            erP(r) = sum(in_BPSK ~= BPSK_DemodP)/48;   %bit error probability for Vehicular

                      %  case 2
                            %QPSK Modulation
                            QPSK_Mod = QPSK(1,in_QPSK); %QPSK Modulation
                            QPSK_Mod_OFDM = ofdmTransmit(QPSK_Mod,BPSK_pilot);  %OFDM Transmission
                            [QPSK_Mod_OFDM_ChannelV QPSK_Mod_OFDM_ChannelP] = multipathChannel(QPSK_Mod_OFDM, AWGNSNR(q), tapsV, tapsP);  %Multipath Channel
                            [QPSK_Demod_OFDMV QPSK_Demod_OFDMP] = ofdmReceive(2,QPSK_Mod_OFDM_ChannelV,QPSK_Mod_OFDM_ChannelP,tapsV,tapsP); %OFDM Receiver
                            QPSK_DemodV = QPSK(2,QPSK_Demod_OFDMV);   %QPSK Demodulation for Vehicular
                            QPSK_DemodP = QPSK(2,QPSK_Demod_OFDMP);   %QPSK Demodulation for Pedestrian
                            erV(r) = sum(in_QPSK ~= QPSK_DemodV)/(48*2);   %bit error probability for Vehicular
                            erP(r) = sum(in_QPSK ~= QPSK_DemodP)/(48*2);   %bit error probability for Vehicular
                            
                       % case 3
                            %16 QAM Modulation
                            QAM_Mod = QAM(1,in_QAM); %QAM Modulation
                            QAM_Mod_OFDM = ofdmTransmit(QAM_Mod,BPSK_pilot);  %OFDM Transmission
                            [QAM_Mod_OFDM_ChannelV QAM_Mod_OFDM_ChannelP] = multipathChannel(QAM_Mod_OFDM, AWGNSNR(q), tapsV, tapsP);  %Multipath Channel
                            [QAM_Demod_OFDMV QAM_Demod_OFDMP] = ofdmReceive(2,QAM_Mod_OFDM_ChannelV,QAM_Mod_OFDM_ChannelP,tapsV,tapsP); %OFDM Receiver
                            QAM_DemodV = QAM(2,QAM_Demod_OFDMV);   %QAM Demodulation for Vehicular
                            QAM_DemodP = QAM(2,QAM_Demod_OFDMP);   %QAM Demodulation for Pedestrian
                            erV(r) = sum(in_QAM ~= QAM_DemodV)/(48*4);   %bit error probability for Vehicular
                            erP(r) = sum(in_QAM ~= QAM_DemodP)/(48*4);   %bit error probability for Vehicular
                 end
            end
                perV(p,q) = sum(erV)/N2;
                perP(p,q) = sum(erP)/N2;
         end
       % end

        for q = 1:length(AWGNSNR)   %Total Probability
            berV(q) = sum(perV(:,q))/N1;    
            berP(q) = sum(perP(:,q))/N1;
        end

        %switch M
           % case 1  %BPSK
                figure
                semilogy(AWGNSNRdB,berV,'r','marker','*'); hold on;
                semilogy(AWGNSNRdB,berP,'b','marker','*');
                legend('Vehicular','Pedestrian',1); 
                title('Error Probability vs SNR for BPSK to Multipath channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
         %   case 2  %QPSK
                figure
                semilogy(AWGNSNRdB,berV,'r','marker','*'); hold on;
                semilogy(AWGNSNRdB,berP,'b','marker','*'); 
                legend('Vehicular','Pedestrian',1); 
                title('Error Probability vs SNR for QPSK to Multipath channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
          %  case 3  %16 QAM
                figure
                semilogy(AWGNSNRdB,berV,'r','marker','*'); hold on;
                semilogy(AWGNSNRdB,berP,'b','marker','*'); 
                legend('Vehicular','Pedestrian',1); 
                title('Error Probability vs SNR for 16 QAM to Multipath channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
       % end
        


% disp('      ');
% disp('      ');
% disp('Please select the options below');
% disp('-------------------------------');
% disp('      ');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%input parameters

% T = 'N';    %Initialising T
% Q = 'N';    %Initialising Q
% T = input('Simulate Adaptive Modulation? (Y/N): ','s');  %Adaptive Modulation
%     if ((upper(T) ~= 'Y') && (upper(T) ~= 'N'))
%         disp('None/invalid input entered..By default not using 2-antenna transmit');
%         T = 'N';
%     end
% Q = input('Simulate MIMO-OFDM transmit? (Y/N): ','s');  %MIMO-OFDM
%     if ((upper(Q) ~= 'Y') && (upper(Q) ~= 'N'))
%         disp('None/invalid input entered..By default not using 2-antenna transmit');
%         Q = 'N';
%     end

%if (T ~= 'N')   %Adaptive Modulation 
    EmpSpecEffV = zeros(1,length(range));
    EmpSpecEffP = zeros(1,length(range));
    for k = 1:N1
        [tapsV tapsP] = multipathChannelTaps();
        [spectralEffV spectralEffP] = adaptiveModulation(0,tapsV,tapsP);
        EmpSpecEffV = EmpSpecEffV + spectralEffV;
        EmpSpecEffP = EmpSpecEffP + spectralEffP;
    end

    EmpSpecEffV = EmpSpecEffV./N1;
    EmpSpecEffP = EmpSpecEffP./N1;

    figure
    plot(range,EmpSpecEffV,'r','marker','*'); hold on;
    plot(range,EmpSpecEffP,'b','marker','*'); 
    legend('Vehicular','Pedestrian',2); 
    title('Spectral Efficiency vs SNR');
    xlabel('SNR in dB -->');
    ylabel('Spectral Efficiency -->');
    grid on;
%end

%if (Q ~= 'N')   %MIMO-OFDM    
%     EmpSpecEffV = zeros(1,length(range));
%     EmpSpecEffP = zeros(1,length(range));
%     for k = 1:N1
%        [spectralEffV spectralEffP] = mimoOFDM();
%         EmpSpecEffV = EmpSpecEffV + spectralEffV;
%         EmpSpecEffP = EmpSpecEffP + spectralEffP;
%     end
% 
%     EmpSpecEffV = EmpSpecEffV./N1;
%     EmpSpecEffP = EmpSpecEffP./N1;
% 
%     figure
%     plot(range,EmpSpecEffV,'r','marker','*'); hold on;
%     plot(range,EmpSpecEffP,'b','marker','*'); 
%     legend('Vehicular','Pedestrian',2); 
%     title('Spectral Efficiency vs SNR using MIMO-OFDM transmit');
%     xlabel('SNR in dB -->');
%     ylabel('Spectral Efficiency -->');
%     grid on;
%end


% disp('.');
% disp('.');
% disp('.');
% disp('Simulation is completed...Please check the populated graph for results');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%---FUNCTIONS---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%DONE
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

%Done
function [receive] = awgnChannel(input, awgnSNR)
%%%%%%%%%%%%%%%%%%%%%%---AWGN CHANNEL---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputLen = length(input);   %Input length

nc = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %In-phase noise
ns = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %Quadrature-phase noise
rc = real(input) + nc;
rs = imag(input) + ns;
receive = rc + (1i.*rs);
end

%Done
function [vehicular pedestrian] = multipathChannel(input, awgnSNR, tapsV, tapsP)
%%%%%%%%%%%%%%%%%%%%%%---MULTIPATH CHANNEL---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputLen = length(input);   %Input length
nc = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %In-phase noise
ns = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %Quadrature-phase noise

vehicular = ifft((fft(input,inputLen).*fft(tapsV,inputLen)),inputLen) + (nc + (1i*ns));
pedestrian = ifft((fft(input,inputLen).*fft(tapsP,inputLen)),inputLen) + (nc + (1i*ns));
end

%Done
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

function output = BPSK(type, input)
%%%%%%%%%%%%%%%%%---BPSK MODULATOR/DEMODULATOR---%%%%%%%%%%%%%%%%%%%%%%%%%%
if (type == 1)
    output = 2.*input - 1; %mapping the bits to +1 or -1
else
    d_BPSK_0 = abs(input - (-1)) ;   %distance from -1
    d_BPSK_1 = abs(input - (1)) ;   %distance from +1
    output = d_BPSK_1 < d_BPSK_0; %Decision rule
end
end

function [output] = QPSK(type, input)
%%%%%%%%%%%%%%%%%---QPSK MODULATOR/DEMODULATOR---%%%%%%%%%%%%%%%%%%%%%%%%%%
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

function [output] = QAM(type, input)
%%%%%%%%%%%%%%%%%---16QAM MODULATOR/DEMODULATOR---%%%%%%%%%%%%%%%%%%%%%%%%%
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

%Done
function [spectralEffIndoor spectralEffOutdoor] = adaptiveModulation(type,tapsIndoor,tapsOutdoor)
%%%%%%%%%%%%%%%%%%%%%%%%---ADAPTIVE MODULATION---%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%         if ((SNRV(j) >= 3.5) && (SNRV(j) < 10.61))  %BPSK
%             nbits = nbits + 1;
         if ((SNRIndoor(j) >= 10.61) && (SNRIndoor(j) < 13.94))   %QPSK
                nbits = nbits + 2;
%             else if ((SNRV(j) >= 13.94) && (SNRV(j) < 17.25))   %8 PSK
%                     nbits = nbits + 3;
                 else if ((SNRIndoor(j) >= 17.25) && (SNRIndoor(j) < 20.4))   %16 QAM
                        nbits = nbits + 4;
%                      else if ((SNRV(j) >= 20.4) && (SNRV(j) < 23.48))   %32 QAM
%                             nbits = nbits + 5;
%                          else if (SNRV(j) >= 23.48) %64 QAM
%                                  nbits = nbits + 6;
%                              end
%                          end
                     end
                %end
          end
     end
%end
    spectralEffIndoor(i) = nbits/length(SNRIndoor);
    nbits = 0;
    for j = 1:length(SNROutdoor)
%         if ((SNRP(j) >= 3.5) && (SNRP(j) < 10.61))  %BPSK
%             nbits = nbits + 1;
         if ((SNROutdoor(j) >= 10.61) && (SNROutdoor(j) < 13.94))   %QPSK
                nbits = nbits + 2;
%             else if ((SNRP(j) >= 13.94) && (SNRP(j) < 17.25))   %8 PSK
%                     nbits = nbits + 3;
                 else if ((SNROutdoor(j) >= 17.25) && (SNROutdoor(j) < 20.4))   %16 QAM
                        nbits = nbits + 4;
%                      else if ((SNRP(j) >= 20.4) && (SNRP(j) < 23.48))   %32 QAM
%                             nbits = nbits + 5;
%                          else if (SNRP(j) >= 23.48) %64 QAM
%                                  nbits = nbits + 6;
%                              end
%                          end
                     end
                %end
          end
     end

    spectralEffOutdoor(i) = nbits/length(SNROutdoor);
end    
end

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