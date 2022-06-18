function [ mobileLoc_est, X, Y ] = trilateration_4( RSS,RSS_s,Pr0,n,networkSize )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% Select  highest three RSSI Values  & Calculate distances using d = antilog(Pr0-RSSI)/(10*n)
           
           d1_est = 10^(-(Pr0+RSS_s(15))/(10*n));
           d2_est = 10^(-(Pr0+RSS_s(14))/(10*n));
           d3_est = 10^(-(Pr0+RSS_s(13))/(10*n));

         if (RSS_s(15) == RSS(1))
             X1 = 14; Y1 = 8;
         elseif (RSS_s(15) == RSS(2))
             X1 = 25; Y1 = 30;
         elseif (RSS_s(15) == RSS(3))
             X1 = 35; Y1 = 45;
         elseif (RSS_s(15) == RSS(4))
             X1 = 37; Y1 = 80;
         elseif (RSS_s(15) == RSS(5))
             X1 = 50; Y1 = 65;
         elseif (RSS_s(15) == RSS(6))
             X1 = 70; Y1 = 70;
         elseif (RSS_s(15) == RSS(7))
             X1 = 62; Y1 = 42;
         elseif (RSS_s(15) == RSS(8))
             X1 = 85; Y1 = 70;
          elseif (RSS_s(15) == RSS(9))
             X1 = 92; Y1 = 40;
          elseif (RSS_s(15) == RSS(10))
             X1 = 68; Y1 = 18;
          elseif (RSS_s(15) == RSS(11))
             X1 = 59; Y1 = 80;
          elseif (RSS_s(15) == RSS(12))
             X1 = 48; Y1 = 50;
          elseif (RSS_s(15) == RSS(13))
             X1 = 32; Y1 = 41;
          elseif (RSS_s(15) == RSS(14))
             X1 = 10; Y1 = 40;
          elseif (RSS_s(15) == RSS(15))
             X1 = 67; Y1 = 32;
         end
         
         
          if (RSS_s(14) == RSS(1))
             X2 = 14; Y2 = 8;
         elseif (RSS_s(14) == RSS(2))
             X2 = 25; Y2 = 30;
         elseif (RSS_s(14) == RSS(3))
             X2 = 35; Y2 = 45;
         elseif (RSS_s(14) == RSS(4))
             X2 = 37; Y2 = 80;
         elseif (RSS_s(14) == RSS(5))
             X2 = 50; Y2 = 65;
         elseif (RSS_s(14) == RSS(6))
             X2 = 70; Y2 = 70;
         elseif (RSS_s(14) == RSS(7))
             X2 = 62; Y2 = 42;
         elseif (RSS_s(14) == RSS(8))
             X2 = 85; Y2 = 70;
          elseif (RSS_s(14) == RSS(9))
             X2 = 92; Y2 = 40;
          elseif (RSS_s(14) == RSS(10))
             X2 = 68; Y2 = 18;
          elseif (RSS_s(14) == RSS(11))
             X2 = 59; Y2 = 80;
          elseif (RSS_s(14) == RSS(12))
             X2 = 48; Y2 = 50;
          elseif (RSS_s(14) == RSS(13))
             X2 = 32; Y2 = 41;
          elseif (RSS_s(14) == RSS(14))
             X2 = 10; Y2 = 40;
          elseif (RSS_s(14) == RSS(15))
             X2 = 67; Y2 = 32;
         end
         
          if (RSS_s(13) == RSS(1))
             X3 = 14; Y3 = 8;
         elseif (RSS_s(13) == RSS(2))
             X3 = 25; Y3 = 30;
         elseif (RSS_s(13) == RSS(3))
             X3 = 35; Y3 = 45;
         elseif (RSS_s(13) == RSS(4))
             X3 = 37; Y3 = 80;
         elseif (RSS_s(13) == RSS(5))
             X3 = 50; Y3 = 65;
         elseif (RSS_s(13) == RSS(6))
             X3 = 70; Y3 = 70;
         elseif (RSS_s(13) == RSS(7))
             X3 = 62; Y3 = 42;
         elseif (RSS_s(13) == RSS(8))
             X3 = 85; Y3 = 70;
          elseif (RSS_s(13) == RSS(9))
             X3 = 92; Y3 = 40;
          elseif (RSS_s(13) == RSS(10))
             X3 = 68; Y3 = 18;
          elseif (RSS_s(13) == RSS(11))
             X3 = 59; Y3 = 80;
          elseif (RSS_s(13) == RSS(12))
             X3 = 48; Y3 = 50;
          elseif (RSS_s(13) == RSS(13))
             X3 = 32; Y3 = 41;
          elseif (RSS_s(13) == RSS(14))
             X3 = 10; Y3 = 40;
          elseif (RSS_s(13) == RSS(15))
             X3 = 67; Y3 = 32;
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
       
       X = (X1+X2+X3)/3;
       Y = (Y1+Y2+Y3)/3;
end

