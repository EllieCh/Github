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
