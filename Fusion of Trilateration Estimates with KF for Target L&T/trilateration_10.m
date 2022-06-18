function [ mobileLoc_est ] = trilateration_10( RSS,RSS_s,Pr0,n,networkSize )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% Select  highest three RSSI Values  & Calculate distances using d = antilog(Pr0-RSSI)/(10*n)
           
           d1_est = 10^(-(Pr0+RSS_s(10))/(10*n));
           d2_est = 10^(-(Pr0+RSS_s(9))/(10*n));
           d3_est = 10^(-(Pr0+RSS_s(8))/(10*n));

         if (RSS_s(10) == RSS(1))
             X1 = 0; Y1 = 0;
         elseif (RSS_s(10) == RSS(2))
             X1 = networkSize*0.3; Y1 = networkSize*0.3;
         elseif (RSS_s(10) == RSS(3))
             X1 = networkSize; Y1 = 0;
         elseif (RSS_s(10) == RSS(4))
             X1 = networkSize*0.5; Y1 = networkSize*0.4;
         elseif (RSS_s(10) == RSS(5))
             X1 = networkSize; Y1 = networkSize;
         elseif (RSS_s(10) == RSS(6))
             X1 = networkSize*0.7; Y1 = networkSize*0.2;
         elseif (RSS_s(10) == RSS(7))
             X1 = 0; Y1 = networkSize;
         elseif (RSS_s(10) == RSS(8))
             X1 = networkSize*0.9; Y1 = networkSize*0.6;
         elseif (RSS_s(10) == RSS(9))
             X1 = networkSize*0.5; Y1 = networkSize*0.9;
         elseif (RSS_s(10) == RSS(10))
             X1 = networkSize*0.1; Y1 = networkSize*0.6;
         end
         
         if (RSS_s(9) == RSS(1))
             X2 = 0; Y2 = 0;
         elseif (RSS_s(9) == RSS(2))
             X2 = networkSize*0.3; Y2 = networkSize*0.3;
         elseif (RSS_s(9) == RSS(3))
             X2 = networkSize; Y2 = 0;
         elseif (RSS_s(9) == RSS(4))
             X2 = networkSize*0.5; Y2 = networkSize*0.4;
         elseif (RSS_s(9) == RSS(5))
             X2 = networkSize; Y2 = networkSize;
         elseif (RSS_s(9) == RSS(6))
             X2 = networkSize*0.7; Y2 = networkSize*0.2;
         elseif (RSS_s(9) == RSS(7))
             X2 = 0; Y2 = networkSize;
         elseif (RSS_s(9) == RSS(8))
             X2 = networkSize*0.9; Y2 = networkSize*0.6;
         elseif (RSS_s(9) == RSS(9))
             X2 = networkSize*0.5; Y2 = networkSize*0.9;
         elseif (RSS_s(9) == RSS(10))
             X2 = networkSize*0.1; Y2 = networkSize*0.6;
         end
         
         if (RSS_s(8) == RSS(1))
             X3 = 0; Y3 = 0;
         elseif (RSS_s(8) == RSS(2))
             X3 = networkSize*0.3; Y3 = networkSize*0.3;
         elseif (RSS_s(8) == RSS(3))
             X3 = networkSize; Y3 = 0;
         elseif (RSS_s(8) == RSS(4))
             X3 = networkSize*0.5; Y3 = networkSize*0.4;
         elseif (RSS_s(8) == RSS(5))
             X3 = networkSize; Y3 = networkSize;
         elseif (RSS_s(8) == RSS(6))
             X3 = networkSize*0.7; Y3 = networkSize*0.2;
         elseif (RSS_s(8) == RSS(7))
             X3 = 0; Y3 = networkSize;
         elseif (RSS_s(8) == RSS(8))
             X3 = networkSize*0.9; Y3 = networkSize*0.6;
         elseif (RSS_s(8) == RSS(9))
             X3 = networkSize*0.5; Y3 = networkSize*0.9;
         elseif (RSS_s(8) == RSS(10))
             X3 = networkSize*0.1; Y3 = networkSize*0.6;
         end   

       % Trilateration Algorithm (x – xi)^2 + (y – yi)^2 = di^2 
       % d1^2 = (x1-x)^2 + (y1-y)^2   similarly write for d2 & d3
       % Calculate A , B, C as : A = x1^2 + y1^2 - d1^2,  B = x2^2 + y2^2 -d2^2, C =  x3^2 + y3^2 -d3^2
       % Then Target coordinates are given as follows
       
       A = X1^2 + Y1^2 - d1_est^2;
       B = X2^2 + Y2^2 - d2_est^2;
       C = X3^2 + Y3^2 - d3_est^2;
       
       X32 = (X3 - X2);
       Y32 = (Y3 - Y2);
       X21 = (X2 - X1);
       Y21 = (Y2 - Y1);
       X13 = (X1 - X3); 
       Y13 = (Y1 - Y3);
       
       X_T = (A*Y32 + B*Y13 + C*Y21) / (2*( X1*Y32 + X2*Y13 + X3*Y21));    % X coordinate of target
       Y_T = (A*X32 + B*X13 + C*X21) / (2*( Y1*X32 + Y2*X13 + Y3*X21));    % Y coordinate of target
       mobileLoc_est = [ X_T, Y_T];   
       
end

