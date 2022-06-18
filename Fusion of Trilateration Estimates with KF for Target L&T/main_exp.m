 %% WSN Deployment Setting Parameters    
    clear all
    close all
    clc
    
    N = 4;                                            % number of anchors
    M = 1;                                            % number of mobile nodes
    networkSize = 100;                                % we consider a 100by100 area that the mobile can wander
    
    anchorLoc   = [0                     0;           % set the anchor at 4 vertices of the region
                   networkSize           0;
                   0           networkSize;
                   networkSize networkSize];

 %show anchor Locations
    f1 = figure(1);
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    grid on
    hold on
    
 % Defining veriables
    no_of_positions = 50;
    mobileLoc1 = zeros(no_of_positions,2);
    mobileLoc2 = zeros(no_of_positions,2);
    mobileLoc_est = zeros(no_of_positions,2);
    mobileLoc2_est = zeros(8,2);
    d1 = zeros(8,1);                                   %Actual distance of mobile node from Anchor 1
    d2 = zeros(8,1);                                   %Actual distance of mobile node from Anchor 2
    d3 = zeros(8,1);                                   %Actual distance of mobile node from Anchor 3
    d4 = zeros(8,1);                                   %Actual distance of mobile node from Anchor 4
    
    P = [0.25 0 0  0; 0 0.04 0 0; 0 0 0.02 0; 0 0 0 0.01];   % Initial Process Covariance Matrix
    %P = [0.1 0 0  0; 0 0.1 0 0; 0 0 0.1 0; 0 0 0 0.1];
    q=0.1;                                                   %std of process
    
     
    error_x_kf = zeros( no_of_positions,1); error_y_kf = zeros(no_of_positions,1); error_xy_kf = zeros(no_of_positions,1);
    error_x_ukf = zeros(no_of_positions,1); error_y_ukf = zeros(no_of_positions,1); error_xy_ukf = zeros(no_of_positions,1);
    error_x_rssi = zeros(no_of_positions,1); error_y_rssi = zeros(no_of_positions,1); error_xy_rssi = zeros(no_of_positions,1);
    
  
    RMSE_kf =0 ; RMSE_rssi= 0; RMSE_ukf= 0;
       
 % Calculate reference RSSI at d0 = 1 meter using Free Space Path Loss Model
    d0=1;                                                    % in Meters
    Pr0 = RSSI_friss(d0);
    
    d_test = 20;
       
    Pr = RSSI_friss(d_test);

%Calculation of Path Loss Exponent : Use  RSSI = -(10*n*log10(d)+A)= -A-(10*n*log10(d))
 
      n = -(Pr + Pr0)/(10*log(d_test));
 
      
      x=10;
      y=10;
     
% Generating trajectory for the mobile node  
    for t = 1:no_of_positions    
       if(t<9)                 x_v = 2; y_v = 5;
       elseif(t==9 && t<16)    x_v = 5; y_v = 2;
       elseif(t>=16 && t<18)   x_v = 1; y_v = 2;
       elseif(t>=18 && t<35)   x_v = 2; y_v = -3;    
       elseif(t>=35 && t<=50)  x_v = 0; y_v = 4;    
       end
       x=x+x_v;
       y=y+y_v;
       
       disp('True Location')
       mobileLoc1 = [x,y]                                           % Actual Target Location
       plot(x,y,'rs','LineWidth',2)
       ylabel('Y-Axis[meter]');
       xlabel('X-Axis[meter]');
       legend('Anchor Location','Actual Target Location','Pure RSSI based Target Location','RSSI + kalman location','RSSI + Unscented KF Location','Location','SouthEast')
       hold on
       
% Actual Distances from Anchors required to generate RSSI Values
       d1 = sqrt( x^2 + y^2 );
       d2 = sqrt((100-x)^2 + y^2);
       d3 = sqrt((100-x)^2+ (100-y)^2);
       d4 = sqrt(x^2+ (100-y)^2);
       
% Generate RSSI Values at 4 Anchor Nodes which are at d1, d2, d3 & d4 distances respectively from Moving Target     
       % Use  RSSI = - (10*n*log10(d) + A)  and  d= antilog(-(RSSI + A)/(10*n))
       
       %if(t~=3 && t~=4)
       RSS = lognormalshadowing(n,d1,d2,d3,d4,Pr0);
       RSS_s = sort(RSS);
       %end   
       
       disp('RSSI Estimated Location')
       mobileLoc_est = trilateration(RSS,RSS_s,Pr0,n)
       X_T = mobileLoc_est(1)
       Y_T = mobileLoc_est(2)
             
       plot(X_T,Y_T,'g+','LineWidth',2,'MarkerSize',8);  
       hold on
       
% calculate velocities in X & Y Directions
       
       velocity_est=velocity(X_T,Y_T,t);
          s = [x; y; 0; 0];                                           % State of the system at time 't'
          X = s + q*randn(4,1);                                       % state with noise
          
          
% Kalman Filter for Tracking Moving Target Code starts here
       [X_kalman,Y_kalman]= kf(X,P,X_T,Y_T,velocity_est,t);
       plot(X_kalman,Y_kalman,'r+')
       hold on

 %UKF implementation
      Z = [X_T; Y_T; velocity_est(1); velocity_est(2)];
      disp('UKF Estimated State')
      [X_ukf]= ukf5(X,P,Z)
      plot(X_ukf(1),X_ukf(2),'ro')
      hold on
      
% Error Analysis of algorithm
% ---> Part 1 : for Pure RSSI based Technique
       RMSE_rssi = abs(RMSE_rssi + ((X_T - x)^2 + (Y_T - y)^2));

       RMSE_kf = RMSE_kf + ((X_kalman - x)^2 + (Y_kalman - y)^2);
       RMSE_ukf = RMSE_ukf + ((X_ukf(1)-x)^2 + (X_ukf(2)-y)^2);
       
% ---> Part 2 : Calculation of Absolute Errors 

     % a) For Kalman Filter
       error_x_kf(t) =  abs((x - X_kalman));
       error_y_kf(t) =  abs((y - Y_kalman));
       error_xy_kf(t) = ((error_x_kf(t) + error_y_kf(t))/2);
       
     % b) For Unscented Kalman Filter
       error_x_ukf(t) = abs((x - X_ukf(1)));
       error_y_ukf(t) = abs((y - X_ukf(2)));
       error_xy_ukf(t) = ((error_x_ukf(t) + error_y_ukf(t))/2);
       
     % c) For Pure RSSI based Technique
       error_x_rssi(t) = abs((x - X_T));
       error_y_rssi(t) = abs((y - Y_T));
       error_xy_rssi(t) =((error_x_rssi(t) + error_y_rssi(t))/2);
       
    end

% Average Error in x & y  coordinates
      RMSE_rssi = sqrt(RMSE_rssi/no_of_positions)
      RMSE_kf = sqrt(RMSE_kf/no_of_positions)
      RMSE_ukf = sqrt(RMSE_ukf/no_of_positions)
      
    
% Plotting Absolute Errors of KF & UKF based Tracking

f2 = figure(2);
  for t =1:no_of_positions
    %b= error_x_kf(1);
    %disp('Test of first value')
    %disp(b)
    plot(t,error_x_kf(t),'b+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    plot(t,error_x_ukf(t),'k+','Linewidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')
    plot(t,error_x_rssi(t),'ro','Linewidth',2)    %,'Markersize',2,'MarkerEdgeColor','g')
    xlabel('Time, [s]','FontName','Times','Fontsize',12) 
    ylabel('Error in x estimate in RSSI, KF & UKF Implementation, [m]','FontName','Times','Fontsize',12)
    hold on
    
  end
  legend('Error in x estimate of Pure RSSI','Error in x estimate of KF','Error in x estimate of UKF','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions
      
    plot(t,error_y_kf(t),'b+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    plot(t,error_y_ukf(t),'k+','Linewidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')
    plot(t,error_y_rssi(t),'ro','Linewidth',2)    %,'Markersize',2,'MarkerEdgeColor','g') 
    xlabel('Time, [s]','FontName','Times','Fontsize',12) 
    ylabel('Error in y estimate in RSSI, KF & UKF Implementation, [m]','FontName','Times','Fontsize',12)
    
  hold on
  end
  legend('Error in y estimate of Pure RSSI','Error in y estimate of KF','Error in y estimate of UKF','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions
      
    plot(t,error_xy_kf(t),'b+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    plot(t,error_xy_ukf(t),'k+','Linewidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')
    plot(t,error_xy_rssi(t),'ro','Linewidth',2)    %,'Markersize',2,'MarkerEdgeColor','g') 
    xlabel('Time, [s]','FontName','Times','Fontsize',12) 
    ylabel('Error in xy estimate in RSSI, KF & UKF Implementation, [m]','FontName','Times','Fontsize',12)
    
  hold on
  end
  legend('Error in xy estimate of Pure RSSI','Error in xy estimate of KF','Error in xy estimate of UKF','Location','NorthWest')
  
  linearity_test(n,Pr0);
    
 
   
   