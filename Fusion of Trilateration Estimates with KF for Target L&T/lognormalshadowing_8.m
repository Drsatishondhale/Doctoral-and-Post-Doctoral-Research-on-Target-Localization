function [ RSS ] = lognormalshadowing_8( n,d1,d2,d3,d4,d5,d6,d7,d8,Pr0 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
       %clear all
       std_meas_noise = 3;  % standard deviation 0f measurement noise in db
      
       
       RSS_d1= -(10*n* log10(d1) + Pr0) + (std_meas_noise + 1.*randn);  
       RSS_d2= -(10*n* log10(d2) + Pr0) + (std_meas_noise + 1.*randn);    
       RSS_d3= -(10*n* log10(d3) + Pr0) + (std_meas_noise + 1.*randn);     
       RSS_d4= -(10*n* log10(d4) + Pr0) + (std_meas_noise + 1.*randn);
       RSS_d5= -(10*n* log10(d5) + Pr0) + (std_meas_noise + 1.*randn);  
       RSS_d6= -(10*n* log10(d6) + Pr0) + (std_meas_noise + 1.*randn);    
       RSS_d7= -(10*n* log10(d7) + Pr0) + (std_meas_noise + 1.*randn);     
       RSS_d8= -(10*n* log10(d8) + Pr0) + (std_meas_noise + 1.*randn);
       
       RSS = [ RSS_d1, RSS_d2, RSS_d3, RSS_d4,RSS_d5, RSS_d6, RSS_d7, RSS_d8];
end

