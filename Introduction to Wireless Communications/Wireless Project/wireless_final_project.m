function wireless_final_project()
clc
close all;
clear all;
disp('                              Physical Layer Simulation of OFDM System');
disp('                              ========================================');
disp('      ');

disp('Please enter the following input parameters');
disp('-------------------------------------------');
disp('      ');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%input parameters

disp('1. QPSK');
disp('2. 16 QAM');
M = input('Select modulation scheme (1/2/3): ');    %Modulation scheme
if ((isempty(M)) || (M>3))
    disp('None/invalid input entered..Using BPSK as default modulation');
    M = 1;
end

disp('      ');
disp('1. AWGN Channel');
disp('2. Multipath Channel');
C = input('Select channel (1/2): ');    %Channel
if ((isempty(C)) || (C>3))
    disp('None/invalid input entered..Using AWGN as default channel');
    C = 1;
end

disp('      ');
disp('Please wait...Simulation is in progress...');

N1 = 100; %100 symbols
N2 = 10; %Monte-Carlo trials for each symbol
range = 10:30;  %Range for Adaptive Modulation
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%simulator coding

pilot = rand(1,4)>0.5;  %pseudo binary sequence
BPSK_pilot = BPSK(1,pilot); %BPSK Modulated pilot signal

switch C
    case 1
        AWGNSNRdB = [3 5 7 9 11];
        AWGNSNR = 10.^((AWGNSNRdB)./10); %SNR in linear scale
        for p = 1:N1
            in_QPSK = rand(1,2*48)>0.5;  %input to QPSK modulator
            in_QAM = rand(1,4*48)>0.5;   %input to 16 QAM modulator

            for q = 1:length(AWGNSNR)
                for r = 1:N2
                    switch M
                        case 1
                            %QPSK Modulation
                            QPSKModultion = QPSK(1,in_QPSK); %QPSK Modulation
                            QPSKModultion_OFDM = ofdmTransmit(QPSKModultion,BPSK_pilot);  %OFDM Transmission
                            QPSK_OFDM_Chan = awgnChannel(QPSKModultion_OFDM,AWGNSNR(q));  %AWGN Channel
                            [QPSKReceived var] = ofdmReceive(1,QPSK_OFDM_Chan,[],[],[]); %OFDM Receiver
                            QPSKDemodulated = QPSK(2,QPSKReceived);   %QPSK Demodulation
                            error(r) = sum(in_QPSK ~= QPSKDemodulated)/(48*2);   %bit error probability

                        case 2
                            %16 QAM Modulation
                            QAM_Mod = QAM(1,in_QAM); %QAM Modulation
                            QAM_Mod_OFDM = ofdmTransmit(QAM_Mod,BPSK_pilot);  %OFDM Transmission
                            QAM_Mod_OFDM_Channel = awgnChannel(QAM_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
                            [QAM_Demod_OFDM var] = ofdmReceive(1,QAM_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
                            QAM_Demod = QAM(2,QAM_Demod_OFDM);   %QAM Demodulation
                            error(r) = sum(in_QAM ~= QAM_Demod)/(48*4);   %bit error probability

                    end
                end
                per(p,q) = sum(error)/N2;
            end
        end

        for q = 1:length(AWGNSNR)
            ber(q) = sum(per(:,q))/N1;
        end

        switch M
            case 1
                figure
                semilogy(AWGNSNRdB,ber);
                title('BER of QPSK vs SNR in AWGN channel');
                xlabel('SNR(dB)');
                ylabel('Probability of Error');
                
            case 2
                figure
                semilogy(AWGNSNRdB,ber);
                title('BER of 16 QAM vs SNR in AWGN channel');
                xlabel('SNR (dB) ');
                ylabel('Probability of Error');
              
        end
    case 2
        AWGNSNRdB = 0:30;
        AWGNSNR = 10.^((AWGNSNRdB)./10); %SNR in linear scale
        for p = 1:N1
            in_BPSK = rand(1,48)>0.5;  %input to BPSK modulator
            in_QPSK = rand(1,2*48)>0.5;  %input to QPSK modulator
            in_QAM = rand(1,4*48)>0.5;   %input to 16 QAM modulator
            [tapsV tapsOutdoor] = multipathChannelTaps();

            for q = 1:length(AWGNSNR)
                for r = 1:N2
                    switch M
                        case 1
                            %QPSK Modulation
                            QPSKModultion = QPSK(1,in_QPSK); %QPSK Modulation
                            QPSKModultion_OFDM = ofdmTransmit(QPSKModultion,BPSK_pilot);  %OFDM Transmission
                            [QPSK_OFDM_IndoorChan QPSK_OFDM_OutdoorChan] = multipathChannel(QPSKModultion_OFDM, AWGNSNR(q), tapsV, tapsOutdoor);  %Multipath Channel
                            [QPSKDemodulatedIndoor QPSKDemodulatedIndoor] = ofdmReceive(2,QPSK_OFDM_IndoorChan,QPSK_OFDM_OutdoorChan,tapsV,tapsOutdoor); %OFDM Receiver
                            QPSK_DemodV = QPSK(2,QPSKDemodulatedIndoor);   %QPSK Demodulation for Vehicular
                            QPSK_DemodP = QPSK(2,QPSK_Demod_OFDMP);   %QPSK Demodulation for Pedestrian
                            erV(r) = sum(in_QPSK ~= QPSK_DemodV)/(48*2);   %bit error probability for Vehicular
                            erP(r) = sum(in_QPSK ~= QPSK_DemodP)/(48*2);   %bit error probability for Vehicular
                            
                        case 2
                            %16 QAM Modulation
                            QAM_Mod = QAM(1,in_QAM); %QAM Modulation
                            QAM_Mod_OFDM = ofdmTransmit(QAM_Mod,BPSK_pilot);  %OFDM Transmission
                            [QAM_Mod_OFDM_ChannelV QAM_Mod_OFDM_ChannelP] = multipathChannel(QAM_Mod_OFDM, AWGNSNR(q), tapsV, tapsOutdoor);  %Multipath Channel
                            [QAM_Demod_OFDMV QAM_Demod_OFDMP] = ofdmReceive(2,QAM_Mod_OFDM_ChannelV,QAM_Mod_OFDM_ChannelP,tapsV,tapsOutdoor); %OFDM Receiver
                            QAM_DemodV = QAM(2,QAM_Demod_OFDMV);   %QAM Demodulation for Vehicular
                            QAM_DemodP = QAM(2,QAM_Demod_OFDMP);   %QAM Demodulation for Pedestrian
                            erV(r) = sum(in_QAM ~= QAM_DemodV)/(48*4);   %bit error probability for Vehicular
                            erP(r) = sum(in_QAM ~= QAM_DemodP)/(48*4);   %bit error probability for Vehicular
                    end
                end
                perIndoor(p,q) = sum(erV)/N2;
                perOutdoor(p,q) = sum(erP)/N2;
            end
        end

        for q = 1:length(AWGNSNR)   %Total Probability
            berIndoor(q) = sum(perIndoor(:,q))/N1;    
            berOutdoor(q) = sum(perOutdoor(:,q))/N1;
        end

        switch M
            case 1  %QPSK
                figure
                semilogy(AWGNSNRdB,berIndoor); 
                hold on;
                semilogy(AWGNSNRdB,berOutdoor); 
                legend('Indoor','Outdoor',1); 
                title('BER vs SNR for QPSK in Multipath channel');
                xlabel('SNR (dB)');
                ylabel('Probability of Error');
                
            case 2  %16 QAM
                figure
                semilogy(AWGNSNRdB,berIndoor); 
                hold on;
                semilogy(AWGNSNRdB,berOutdoor); 
                legend('Indoor','Outdoor',1); 
                title('BER vs SNR for 16 QAM in Multipath channel');
                xlabel('SNR (dB)');
                ylabel('Probability of Error');
                
        end
        
end

%Adaptive Modulation 
    EffIndoor = zeros(1,length(range));
    EffOutdoor = zeros(1,length(range));
    for k = 1:N1
        [tapsIndoor tapsOutdoor] = multipathChannelTaps();
        [IndoorSpectralEff OutdoorSpectralEff] = adaptiveModulation(tapsIndoor,tapsOutdoor);
        EffIndoor = EffIndoor + IndoorSpectralEff;
        EffOutdoor = EffOutdoor + OutdoorSpectralEff;
    end

    EffIndoor = EffIndoor./N1;
    EffOutdoor = EffOutdoor./N1;

    figure
    plot(range,EffIndoor); 
    hold on;
    plot(range,EffOutdoor); 
    legend('Indoor','Outdoor',2); 
    title('Spectral Efficiency vs SNR');
    xlabel('SNR (dB) ');
    ylabel('Spectral Efficiency');
   
end














