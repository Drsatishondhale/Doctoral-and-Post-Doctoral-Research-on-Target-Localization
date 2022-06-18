function [ Pr ] = RSSI_friss( d )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    C=3e8;                      %LightSpeed
    prompt = 'Enter Frequency in MHz : ';
    Freq = input(prompt);
    
    Freq = Freq*1000000;
    %Freq=2400*1000000;%hz  
    %Freq = 867*1000000;
    Zigbee=915.0e6;%hz    
    TXAntennaGain=1;%db
    RXAntennaGain=1;%db
    
    PTx=0.001;%watt
    
     %%%%%%   FRIIS Equation %%%%%%%%%

     %        Pt * Gt * Gr * (Wavelength^2)
     %  Pr = --------------------------
     %        (4 *pi * d)^2 * L
     
        Wavelength=C/Freq;
        PTxdBm=10*log10(PTx*1000);
        M = Wavelength / (4 * pi * d);
Pr=PTxdBm + TXAntennaGain + RXAntennaGain- (20*log10(1/M));    % Pr0 means A in RSSI formula

end

