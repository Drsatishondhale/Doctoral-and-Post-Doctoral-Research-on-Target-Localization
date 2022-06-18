function [ velocity_est ] = velocity( X_T,Y_T,t )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%velocity=distance/time
global x_prev y_prev 
dt=1;

if t==1
    X_V =0; Y_V=0; 
    x_prev=X_T;
    y_prev=Y_T;
else
    X_V=(X_T-x_prev)/dt;  
    Y_V=(Y_T-y_prev)/dt;
    x_prev=X_T;
    y_prev=Y_T; 
end
velocity_est=[X_V,Y_V];
end
