function [ RSS ] = lognormalshadowing_4( n,d1,d2,d3,d4,d5,d6,Pr0 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
       %clear all
       
 % how can I generate random variable from Gaussian distribution with zero mean and 0.3 standard deviation?
 %% Example
           % a = .3;%  standard deviation
           % b = 0; %  mean
           % out = a.*randn + b;

       % Here we set 
        a = 1; b = 0;   %%% oringinal values for MDPI Sensors Results
                   
       RSS_d1= -(10*n* log10(d1) + Pr0) + a.*randn + b;  
       RSS_d2= -(10*n* log10(d2) + Pr0) + a.*randn + b; 
       RSS_d3= -(10*n* log10(d3) + Pr0) + a.*randn + b;
       RSS_d4= -(10*n* log10(d4) + Pr0) + a.*randn + b;
       RSS_d5= -(10*n* log10(d5) + Pr0) + a.*randn + b;  
       RSS_d6= -(10*n* log10(d6) + Pr0) + a.*randn + b;  
       
       
RSS = [ RSS_d1,RSS_d2,RSS_d3,RSS_d4,RSS_d5,RSS_d6];
end

