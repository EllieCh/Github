clc
close all
clear all

fftsize = 1024;        %FFT size                
totcarr = 1024;        %Total Sub-Carriers               
datacarr = 720;        %Data Sub-Carriers                
pilotcarr = datacarr/6;         %Pilot Sub-Carriers            
nullcarr = totcarr-(datacarr+pilotcarr);     %Null Sub-Carriers    
cycpre = 256;                         %Cyclic Prefix Length 
dccarr = 0;                            %DC Sub-Carrier
totsymbol = 100;                       
totbit = [];
txsymbit = [];

for sym = 1:totsymbol
    bit = round(rand(1,(2*datacarr)));       
    bit1 = zeros(1,datacarr);
    bit2 = ones(1,datacarr+pilotcarr);
    bit3 = zeros(1,totcarr);
    bit4 = zeros(1,fftsize);
    txsym = zeros(1,fftsize+cycpre);
    ofdmfreq = zeros(1,fftsize+cycpre);
    totbit = [totbit bit];            
    
    for i = 1:datacarr
            
            x = (2*i)-1;
            y = (2*i);
            
            if (bit(x) == 0 && bit(y) == 0)
                ang = -3*pi/4;
            elseif (bit(x) == 0 && bit(y) == 1)
                ang = 3*pi/4;
            elseif (bit(x) == 1 && bit(y) == 0)
                ang = -1*pi/4;    
            elseif (bit(x) == 1 && bit(y) == 1)
                ang = pi/4;
            end
            
            bit1(i) = complex(cos(ang),sin(ang));
            Es = 1;
        end
    
    for i = 1: pilotcarr                             %Adding pilot bit at the starting of every 6 symbols
        bit2((7*i)-6:(7*i)) = [1,bit1((6*i)-5:(6*i))];
    end

    m = length(bit2);                         %Adding null and Ndc subcarriers
    bit3((nullcarr/2)+1:fftsize-(nullcarr/2)+1) = [bit2(1:(m/2)) dccarr bit2((m/2)+1:end)];
    
    bit4 = sqrt(fftsize).*ifft(transpose(bit3),fftsize);
    bit4 = transpose(bit4);                 %IFFT
    
    txsym = [bit4((fftsize-cycpre+1):end) bit4];      %Adding the cyclic prefix
    txsymbit = [txsymbit txsym];                     
    ofdmfreq = ofdmfreq+(txsym./totsymbol);           %Magnitude of Frequency response of Transmitted Signal
         
end
figure;
subplot(2,1,1);
plot(real(txsymbit));
title('Real Part of OFDM Symbols using QPSK')
xlabel('Sub-Carriers');
ylabel('Magnitude');
subplot(2,1,2);
plot(imag(txsymbit));
title('Imaginary Part of OFDM Symbols using QPSK')
xlabel('Sub-Carriers');
ylabel('Magnitude');
figure;
freqz(ofdmfreq);

