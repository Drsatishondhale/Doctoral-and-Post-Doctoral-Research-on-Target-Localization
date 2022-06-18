function [  ] = linearity_test( n,Pr0 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

       std_meas_noise = 1;  % standard deviation 0f measurement noise in db
       for d=0:0.8:100
       RSS = -(10*n* log10(d) + Pr0) + std_meas_noise*randn;  
       f5 = figure(5);
       plot(d,RSS,'r+','LineWidth',2)
       xlabel('Distance, [m]','FontName','Times','Fontsize',14) 
       ylabel('RSSI value, [dbm]','FontName','Times','Fontsize',14) 
       hold on
       end
       disp('Figure 6 shows non linearity in RSSI values with distance')
       text(8,10,'\leftarrow RSSI Curve')
       title('Non-Linearity of RSSI with Distance','FontName','Times','FontSize',14)
       
       f8 = figure(8);
       d=10;
       for t=1:10
        RSS(t) = -(10*n* log10(d) + Pr0) + std_meas_noise*randn; 
        plot(t,RSS(t),'r+','LineWidth',2)
        xlabel('Time, [sec]','FontName','Times','Fontsize',14) 
        ylabel('RSSI value, [dbm]','FontName','Times','Fontsize',14) 
        hold on
       end 
       
       title('Fluctuations in RSSIs at Distance of 10 meter from source wrt Time','FontName','Times','FontSize',12)
end

