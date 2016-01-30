function sim3

global cp psc nscr nscl N dsc mod dveh dped dind

N = 1024;                 %FFT Size 
dsc = 720;              %Data Subcarrier   
nscl = 92;               %Null Subcarrier in left side
nscr = 92;              %Null Subcarrier in the right side
psc = 120;               %Pilot Subcarriers
cp = 256;                %Cyclic Prefix Size

ts = 0.1; 

dind = zeros(100,256);  


%Indoor Channel Co-efficients

c0_i = (10^0).*randn(100,1);  %0 nsec
c1_i = (10^-0.3).*randn(100,1);      %50 nsec
c2_i = (10^-1).*randn(100,1);  %110 nsec
c3_i = (10^-1.8).*randn(100,1);     %170 nsec
c4_i = (10^-2.6).*randn(100,1);  %290 nsec
c5_i = (10^-3.2).*randn(100,1);   %310 nsec


%Delays Associated with Indoor Channel

dind(:,0/ts + 1) =   c0_i;
dind(:,int16(0.05/ts)) = c1_i;
dind(:,int16(0.11/ts)) = c2_i;
dind(:,int16(0.17/ts)) = c3_i;
dind(:,int16(0.29/ts)) = c4_i;
dind(:,int16(0.31/ts)) = c5_i;
nos = 2;
X_sym = zeros(1,N+cp);
snr = [0 2 4 6 8 10 12];
tr = zeros(3,length(snr));
no = zeros(3,length(snr));
isc = zeros(3,length(snr));
for m = 1:1:3
    switch m
        case 1 
            mod = 'qpsk';
        case 2
            mod = '8psk';
        case 3
            mod = 'mqam';
        
        otherwise disp('Invalid Selection');
    end
    
for n = 1:1:nos
    switch mod
    
    case  'qpsk'
    q = 4;
    bits = randi([0 q-1],1,dsc);
    X = pskmod(bits,q,pi/4);
    
    case '8psk'
    mpsk = 8;
    bits = randi([0 mpsk-1],1,dsc);
    X = pskmod(bits,mpsk);
    
    case 'mqam'
    Mqam = 16;
    bits = randi([0 Mqam-1],1,dsc);
    X = qammod(bits,Mqam);
    
    otherwise
        
        disp('Invalid Selection')
end

%Adding Pilot Sub-Carriers 

X_pilot = ones(1,dsc+psc);
for k = 0:1:119
X_pilot(2+7*k:7+7*k) = X(1+6*k:6+6*k);
end

%Adding Null Sub-Carriers

nullmat = zeros(1,nscr);
X_null = horzcat(nullmat,X_pilot,nullmat);
X_frame = X_null;

x = ifft(X_frame,N);

%Adding Cyclic Prefix

x_cp = horzcat(x(N+1-cp :N),x);
x_sym = x_cp;
X_sym = fft(x_sym,N+cp) + X_sym;
chan_name = 'AWGN';

for i = 1:1:length(snr)
chan_out = channel(x_sym,chan_name,snr(i),n);
bits_rx = ofdm_recv(chan_out);

%Bit Error Calculation

[no(m,i), new(m,i)] = biterr(bits,bits_rx);
tr(m,i) = tr(m,i) + new(m,i); 
isc(m,i) = isc(m,i) +1;
end
end    
tr = tr./nos;
end
figure,
semilogy(snr,tr(1,:),'-r*')
hold on
semilogy(snr,tr(2,:),'-b+')
semilogy(snr,tr(3,:),'-go')
legend('QPSK','8 PSK','16 QAM');
title('BER vs SNR for Indoor Channel')
xlabel('SNR (db)')
ylabel('BER')
grid on

function bits_rx = ofdm_recv(x_sym)

global cp psc nscr nscl N dsc mod

%Discarding the Cyclic Prefix
 
x_rx = x_sym(cp+1:length(x_sym));

%FFT Operation

X_frame_rx = fft(x_rx,N);

%Discarding Null Sub-Carriers

X_pilot_rx = X_frame_rx(nscr+1 : N-nscl);

%Removing Pilot Sub-Carriers

X_rx = zeros(1,dsc);

for k = 0:1:119
X_rx(1+6*k:6+6*k) = X_pilot_rx(2+7*k:7+7*k);
end

%Demodulation
switch mod
    
    case  'qpsk'
    q = 4;
    bits_rx = pskdemod(X_rx,q,pi/4);
    
    case '8psk'
    mpsk = 8;
    bits_rx = pskdemod(X_rx,mpsk);
    
    case 'mqam'
    Mqam = 16;
    bits_rx = qamdemod(X_rx,Mqam);
    
    otherwise
        
    disp('Invalid Selection')
end

function chan_out = channel(sig,chan_name,snr,n)

global N cp dveh dped dind

if(strcmp(chan_name,'AWGN'))
   
noisy_sig = awgn(sig,snr,'measured');
chan_out = noisy_sig;

elseif(strcmp(chan_name,'Multipath'))
    
indout = cconv(dind(n,:),sig,N+cp);
n_indout = awgn(indout,snr,'measured');
chan_out = n_indout;

end
