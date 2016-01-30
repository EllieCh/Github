close all;
clear all;
N=64;
size=1000;  
snr_db=10:1:30;
snr_db_l=10.^(snr_db/10); 
Spectral_Efficency=zeros(1,length(snr_db));

c1=sqrt(1)*(randn(1,size)+(sqrt(-1)*randn(1,size))); 
c2=sqrt(0.79)*(randn(1,size)+(sqrt(-1)*randn(1,size))); 
c3=sqrt(0.1258)*(randn(1,size)+(sqrt(-1)*randn(1,size))); 
c4=sqrt(0.1)*(randn(1,size)+(sqrt(-1)*randn(1,size))); 
c5=sqrt(0.0316)*(randn(1,size)+(sqrt(-1)*randn(1,size)));  
c6=sqrt(0.01)*(randn(1,size)+(sqrt(-1)*randn(1,size))); 

for chunk=1:size    
for k=1:length(snr_db)
h=zeros(1,64);
h(1)=c1(chunk);
h(3)=c2(chunk);
h(7)=c3(chunk);
h(11)=c4(chunk);
h(17)=c5(chunk);
h(25)=c6(chunk);
H=fft(h,N);
H=power(abs(H),2);
lk=[9.035 10.18 15.09 16.81 23.00]; 
snr_db_BPSK=10^(lk(1)/10);   
snr_db_QPSK=10^(lk(2)/10);    
snr_db_8PSK=10^(lk(3)/10);  
snr_db_16QAM=10^(lk(4)/10);  
snr_db_64QAM=10^(lk(5)/10);  
snr_db_Cal=[];
for i=1:N
    snr_db_Cal(i)=H(i)*snr_db_l(k);
end
M1=[];M2=[];M3=[];M4=[];M5=[];M6=[];

for i=1:1:64
    if (snr_db_Cal(i)<snr_db_BPSK)
        M1=[M1 0];
    end
    if (snr_db_Cal(i)>snr_db_BPSK & snr_db_Cal(i)<=snr_db_QPSK)
        M2=[M2 1];
    end
    if (snr_db_Cal(i)>snr_db_QPSK & snr_db_Cal(i)<=snr_db_8PSK)
        M3=[M3 2];
    end
    if (snr_db_Cal(i)>snr_db_8PSK & snr_db_Cal(i)<=snr_db_16QAM)
        M4=[M4 3];
    end
    if (snr_db_Cal(i)>snr_db_16QAM & snr_db_Cal(i)<=snr_db_64QAM)
        M5=[M5 4];
    end
    if (snr_db_Cal(i)>snr_db_64QAM)
        M6=[M6 6];
    end
end
s1=(length(M1)/64)*log2(M1);
s2=(length(M2)/64)*log2(1);
s3=(length(M3)/64)*log2(2);
s4=(length(M4)/64)*log2(3);
s5=(length(M5)/64)*log2(4);
s6=(length(M6)/64)*log2(6);

eff=(s2+s3+s4+s5+s6);

Spectral_Efficency(k)=Spectral_Efficency(k)+eff;
end

end
Spectral_Efficency=Spectral_Efficency/size;

plot(snr_db,Spectral_Efficency,'-*r'),
title('Spectral Efficieny for Vehicular Channnel using Adaptive Modulation ');
xlabel('SNR');
ylabel('Spectral Efficieny')
grid on;
hold on;
    
    

