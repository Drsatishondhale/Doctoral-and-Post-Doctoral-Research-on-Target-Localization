function [ mobileLoc_est ] = trilateration_4( RSS,RSS_s,Pr0,n,networkSize )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% Select  highest three RSSI Values  & Calculate distances using d = antilog(Pr0-RSSI)/(10*n)
           
           d1_est = 10^(-(Pr0+RSS_s(4))/(10*n));
           d2_est = 10^(-(Pr0+RSS_s(3))/(10*n));
           d3_est = 10^(-(Pr0+RSS_s(2))/(10*n));

         if (RSS_s(4) == RSS(1))
             X1 = 1; Y1 = 4;
         elseif (RSS_s(4) == RSS(2))
             X1 = 9; Y1 = 4;
         elseif (RSS_s(4) == RSS(3))
             X1 = 9; Y1 = 12;
         elseif (RSS_s(4) == RSS(4))
             X1 = 1; Y1 = 12;
         end
         
         if (RSS_s(3) == RSS(1))
             X2 = 1; Y2 = 4;
         elseif (RSS_s(3) == RSS(2))
             X2 = 9; Y2 = 4;
         elseif (RSS_s(3) == RSS(3))
             X2 = 9; Y2 = 12;
         elseif (RSS_s(3) == RSS(4))
             X2 = 1; Y2 = 12;
         end
         
         if (RSS_s(2) == RSS(1))
             X3 = 1; Y3 = 4;
         elseif (RSS_s(2) == RSS(2))
             X3 = 9; Y3 = 4;
         elseif (RSS_s(2) == RSS(3))
             X3 = 9; Y3 = 12;
         elseif (RSS_s(2) == RSS(4))
             X3 = 1; Y3 = 12;
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

