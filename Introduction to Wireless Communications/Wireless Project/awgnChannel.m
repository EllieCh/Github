function [receive] = awgnChannel(input, awgnSNR)
%%%%%%%%%%%%%%%%%%%%%%---AWGN CHANNEL---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inputLen = length(input);   %Input length

nc = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %In-phase noise
ns = (1/sqrt(2*awgnSNR))*randn(1,inputLen);    %Quadrature-phase noise
rc = real(input) + nc;
rs = imag(input) + ns;
receive = rc + (1i.*rs);
end