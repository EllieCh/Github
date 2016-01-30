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
