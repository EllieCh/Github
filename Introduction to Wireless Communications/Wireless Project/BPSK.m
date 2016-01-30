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