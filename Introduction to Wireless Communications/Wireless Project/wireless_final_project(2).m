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

disp('1. BPSK');
disp('2. QPSK');
disp('3. 16 QAM');
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
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%assumptions

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
            in_BPSK = rand(1,48)>0.5;  %input to BPSK modulator
            in_QPSK = rand(1,2*48)>0.5;  %input to QPSK modulator
            in_QAM = rand(1,4*48)>0.5;   %input to 16 QAM modulator

            for q = 1:length(AWGNSNR)
                for r = 1:N2
                    switch M
                        case 1
                            %BPSK Modulation
                            BPSK_Mod = BPSK(1,in_BPSK); %BPSK Modulation
                            BPSK_Mod_OFDM = ofdmTransmit(BPSK_Mod,BPSK_pilot);  %OFDM Transmission
                            BPSK_Mod_OFDM_Channel = awgnChannel(BPSK_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
                            [BPSK_Demod_OFDM temp] = ofdmReceive(1,BPSK_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
                            BPSK_Demod = BPSK(2,BPSK_Demod_OFDM);   %BPSK Demodulation
                            er(r) = sum(in_BPSK ~= BPSK_Demod)/48;   %bit error probability

                        case 2
                            %QPSK Modulation
                            QPSK_Mod = QPSK(1,in_QPSK); %QPSK Modulation
                            QPSK_Mod_OFDM = ofdmTransmit(QPSK_Mod,BPSK_pilot);  %OFDM Transmission
                            QPSK_Mod_OFDM_Channel = awgnChannel(QPSK_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
                            [QPSK_Demod_OFDM temp] = ofdmReceive(1,QPSK_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
                            QPSK_Demod = QPSK(2,QPSK_Demod_OFDM);   %QPSK Demodulation
                            er(r) = sum(in_QPSK ~= QPSK_Demod)/(48*2);   %bit error probability

                        case 3
                            %16 QAM Modulation
                            QAM_Mod = QAM(1,in_QAM); %QAM Modulation
                            QAM_Mod_OFDM = ofdmTransmit(QAM_Mod,BPSK_pilot);  %OFDM Transmission
                            QAM_Mod_OFDM_Channel = awgnChannel(QAM_Mod_OFDM,AWGNSNR(q));  %AWGN Channel
                            [QAM_Demod_OFDM temp] = ofdmReceive(1,QAM_Mod_OFDM_Channel,[],[],[]); %OFDM Receiver
                            QAM_Demod = QAM(2,QAM_Demod_OFDM);   %QAM Demodulation
                            er(r) = sum(in_QAM ~= QAM_Demod)/(48*4);   %bit error probability

                    end
                end
                per(p,q) = sum(er)/N2;
            end
        end

        for q = 1:length(AWGNSNR)
            ber(q) = sum(per(:,q))/N1;
        end

        switch M
            case 1
                figure
                semilogy(AWGNSNRdB,ber,'r','marker','*');
                title('Error Probability vs SNR for BPSK to AWGN channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
            case 2
                figure
                semilogy(AWGNSNRdB,ber,'r','marker','*');
                title('Error Probability vs SNR for QPSK to AWGN channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
            case 3
                figure
                semilogy(AWGNSNRdB,ber,'r','marker','*');
                title('Error Probability vs SNR for 16 QAM to AWGN channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
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
                            %BPSK Modulation
                            BPSK_Mod = BPSK(1,in_BPSK); %BPSK Modulation
                            BPSK_Mod_OFDM = ofdmTransmit(BPSK_Mod,BPSK_pilot);  %OFDM Transmission
                            [BPSK_Mod_OFDM_ChannelV BPSK_Mod_OFDM_ChannelP] = multipathChannel(BPSK_Mod_OFDM, AWGNSNR(q), tapsV, tapsOutdoor);  %Multipath Channel
                            [BPSK_Demod_OFDMV BPSK_Demod_OFDMP] = ofdmReceive(2,BPSK_Mod_OFDM_ChannelV,BPSK_Mod_OFDM_ChannelP,tapsV,tapsOutdoor); %OFDM Receiver
                            BPSK_DemodV = BPSK(2,BPSK_Demod_OFDMV);   %BPSK Demodulation for Vehicular
                            BPSK_DemodP = BPSK(2,BPSK_Demod_OFDMP);   %BPSK Demodulation for Pedestrian
                            erV(r) = sum(in_BPSK ~= BPSK_DemodV)/48;   %bit error probability for Vehicular
                            erP(r) = sum(in_BPSK ~= BPSK_DemodP)/48;   %bit error probability for Vehicular

                        case 2
                            %QPSK Modulation
                            QPSK_Mod = QPSK(1,in_QPSK); %QPSK Modulation
                            QPSK_Mod_OFDM = ofdmTransmit(QPSK_Mod,BPSK_pilot);  %OFDM Transmission
                            [QPSK_Mod_OFDM_ChannelV QPSK_Mod_OFDM_ChannelP] = multipathChannel(QPSK_Mod_OFDM, AWGNSNR(q), tapsV, tapsOutdoor);  %Multipath Channel
                            [QPSK_Demod_OFDMV QPSK_Demod_OFDMP] = ofdmReceive(2,QPSK_Mod_OFDM_ChannelV,QPSK_Mod_OFDM_ChannelP,tapsV,tapsOutdoor); %OFDM Receiver
                            QPSK_DemodV = QPSK(2,QPSK_Demod_OFDMV);   %QPSK Demodulation for Vehicular
                            QPSK_DemodP = QPSK(2,QPSK_Demod_OFDMP);   %QPSK Demodulation for Pedestrian
                            erV(r) = sum(in_QPSK ~= QPSK_DemodV)/(48*2);   %bit error probability for Vehicular
                            erP(r) = sum(in_QPSK ~= QPSK_DemodP)/(48*2);   %bit error probability for Vehicular
                            
                        case 3
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
                perV(p,q) = sum(erV)/N2;
                perP(p,q) = sum(erP)/N2;
            end
        end

        for q = 1:length(AWGNSNR)   %Total Probability
            berV(q) = sum(perV(:,q))/N1;    
            berP(q) = sum(perP(:,q))/N1;
        end

        switch M
            case 1  %BPSK
                figure
                semilogy(AWGNSNRdB,berV,'r','marker','*'); hold on;
                semilogy(AWGNSNRdB,berP,'b','marker','*');
                legend('Vehicular','Pedestrian',1); 
                title('Error Probability vs SNR for BPSK to Multipath channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
            case 2  %QPSK
                figure
                semilogy(AWGNSNRdB,berV,'r','marker','*'); hold on;
                semilogy(AWGNSNRdB,berP,'b','marker','*'); 
                legend('Vehicular','Pedestrian',1); 
                title('Error Probability vs SNR for QPSK to Multipath channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
            case 3  %16 QAM
                figure
                semilogy(AWGNSNRdB,berV,'r','marker','*'); hold on;
                semilogy(AWGNSNRdB,berP,'b','marker','*'); 
                legend('Vehicular','Pedestrian',1); 
                title('Error Probability vs SNR for 16 QAM to Multipath channel');
                xlabel('SNR in dB -->');
                ylabel('Pe -->');
                grid on;
        end
        
end

disp('      ');
disp('      ');
disp('Please select the options below');
disp('-------------------------------');
disp('      ');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%input parameters

T = 'N';    %Initialising T
Q = 'N';    %Initialising Q
T = input('Simulate Adaptive Modulation? (Y/N): ','s');  %Adaptive Modulation
    if ((upper(T) ~= 'Y') && (upper(T) ~= 'N'))
        disp('None/invalid input entered..By default not using 2-antenna transmit');
        T = 'N';
    end
Q = input('Simulate MIMO-OFDM transmit? (Y/N): ','s');  %MIMO-OFDM
    if ((upper(Q) ~= 'Y') && (upper(Q) ~= 'N'))
        disp('None/invalid input entered..By default not using 2-antenna transmit');
        Q = 'N';
    end

if (T ~= 'N')   %Adaptive Modulation 
    EmpSpecEffV = zeros(1,length(range));
    EmpSpecEffP = zeros(1,length(range));
    for k = 1:N1
        [tapsIndoor tapsOutdoor] = multipathChannelTaps();
        [spectralEffV spectralEffP] = adaptiveModulation(tapsIndoor,tapsOutdoor);
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
end

if (Q ~= 'N')   %MIMO-OFDM    
    EmpSpecEffV = zeros(1,length(range));
    EmpSpecEffP = zeros(1,length(range));
    for k = 1:N1
        [spectralEffV spectralEffP] = mimoOFDM();
        EmpSpecEffV = EmpSpecEffV + spectralEffV;
        EmpSpecEffP = EmpSpecEffP + spectralEffP;
    end

    EmpSpecEffV = EmpSpecEffV./N1;
    EmpSpecEffP = EmpSpecEffP./N1;

    figure
    plot(range,EmpSpecEffV,'r','marker','*'); hold on;
    plot(range,EmpSpecEffP,'b','marker','*'); 
    legend('Vehicular','Pedestrian',2); 
    title('Spectral Efficiency vs SNR using MIMO-OFDM transmit');
    xlabel('SNR in dB -->');
    ylabel('Spectral Efficiency -->');
    grid on;
end


disp('.');
disp('.');
disp('.');
disp('Simulation is completed...Please check the populated graph for results');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%---FUNCTIONS---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%















