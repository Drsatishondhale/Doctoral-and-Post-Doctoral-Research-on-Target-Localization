 %% WSN Deployment Setting Parameters    
    clear all
    close all
    clc
    
    N = 4;                                            % number of anchors
    M = 1;                                            % number of mobile nodes
    networkSize = 100;                                % we consider a 100by100 area that the mobile can wander
    
    prompt = 'Enter Number of Anchors : ';
    No_of_Anchors = input(prompt);
    
    if(No_of_Anchors==4)
        anchorLoc   = [0                     0;           % set the anchor at 4 vertices of the region
                       networkSize           0;
                       0           networkSize;
                       networkSize networkSize];
    end
    
    if(No_of_Anchors==6)
    anchorLoc   = [0                     0;                % set the anchor at 6 vertices of the region
                   networkSize*0.6       networkSize*0.8;
                   networkSize           0;
                   networkSize           networkSize;
                   networkSize*0.2       networkSize/2;
                   0                     networkSize];
    end
     
    if(No_of_Anchors==8)
    anchorLoc   = [0                     0;                % set the anchor at 8 vertices of the region
                   networkSize*0.3       networkSize*0.4;
                   networkSize           0;
                   networkSize*0.7       networkSize*0.6;
                   networkSize           networkSize;
                   networkSize/2         networkSize*0.8;
                   0                     networkSize;
                   networkSize*0.3       networkSize*0.6];
    end
    
 %show anchor Locations
    f1 = figure(1);
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    grid on
    hold on
    
 % Defining veriables
    no_of_positions = 16;
    
    P = [0.25 0 0  0; 0 0.04 0 0; 0 0 0.02 0; 0 0 0 0.01];   % Initial Process Covariance Matrix
   
    q=0.1;                                                   %std of process
    
    error_x_kf = zeros( no_of_positions,1); error_y_kf = zeros(no_of_positions,1); error_xy_kf = zeros(no_of_positions,1);
    error_x_ukf = zeros(no_of_positions,1); error_y_ukf = zeros(no_of_positions,1); error_xy_ukf = zeros(no_of_positions,1);
    error_x_rssi = zeros(no_of_positions,1); error_y_rssi = zeros(no_of_positions,1); error_xy_rssi = zeros(no_of_positions,1);
    
  
    RMSE_kf =0 ; RMSE_rssi= 0; RMSE_ukf= 0; RMSE_kf_V= 0;
       
 % Calculate reference RSSI at d0 = 1 meter using Free Space Path Loss Model
    d0=1;                                                    % in Meters
    Pr0 = RSSI_friss(d0);
    
    d_test = 20;
       
    Pr = RSSI_friss(d_test);

%Calculation of Path Loss Exponent : Use  RSSI = -(10*n*log10(d)+A)= -A-(10*n*log10(d))
 
      n = -(Pr + Pr0)/(10*log(d_test));
 
 % Initial Position of Target
      x=10;
      y=10;
   
      
% Generating trajectory for the mobile node  
    for t = 1:no_of_positions    
       
       
     if(t<9)
       x=10;
       y=x*t+10;
     end
     
     if(t>=9)
       y=90;
       x=x+10;
     end 
     
       disp('True Location');
       mobileLoc1 = [x,y]                                           % Actual Target Location
       plot(x,y,'rs','LineWidth',2,'MarkerSize',8)
       ylabel('Y-Axis[meter]');
       xlabel('X-Axis[meter]');
       title('Actual and Estimated Target Trajectories');
       legend('Anchor Location','Actual Target Location','Traditional RSSI based Estimation','RSSI + KF based Estimation','RSSI + UKF based Estimation','Location','SouthEast')
       hold on
       
% Actual Distances from Anchors required to generate RSSI Values

    if(No_of_Anchors==4)
       d1 = sqrt( x^2 + y^2 );
       d2 = sqrt((100-x)^2 + y^2);
       d3 = sqrt((100-x)^2+ (100-y)^2);
       d4 = sqrt(x^2+ (100-y)^2);
    end

    if(No_of_Anchors==6)
       d1 = sqrt( x^2 + y^2 );
       d2 = sqrt((networkSize*0.6 - x)^2 + ((networkSize*0.8) - y)^2);
       d3 = sqrt((networkSize - x)^2 + y^2);   
       d4 = sqrt((networkSize - x)^2+ (networkSize - y)^2);
       d5 = sqrt((networkSize*0.2 - x)^2+ (networkSize/2 - y)^2);
       d6 = sqrt(x^2+ (networkSize - y)^2);     
    end
    
    if(No_of_Anchors==8)
       d1 = sqrt( x^2 + y^2 );
       d2 = sqrt((networkSize*0.3 - x)^2 + (networkSize*0.4 - y)^2);
       d3 = sqrt((networkSize - x)^2 + y^2);
       d4 = sqrt((networkSize*0.7 - x)^2+ (networkSize*0.6 - y)^2);
       d5 = sqrt((networkSize - x)^2+ (networkSize - y)^2);
       d6 = sqrt((networkSize/2 - x)^2+ (networkSize*0.8 - y)^2)
       d7 = sqrt(x^2+ (networkSize - y)^2)
       d8 = sqrt((networkSize*0.3 - x)^2 + (networkSize*0.6 - y)^2)
    end
       
% Generate RSSI Values at 4 Anchor Nodes which are at d1, d2, d3 & d4 distances respectively from Moving Target     
       % Use  RSSI = - (10*n*log10(d) + A)  and  d= antilog(-(RSSI + A)/(10*n))
       
      if(No_of_Anchors==4) 
       RSS = lognormalshadowing_4(n,d1,d2,d3,d4,Pr0);
       RSS_s = sort(RSS);
      end
      
      if(No_of_Anchors==6)
       RSS = lognormalshadowing_6(n,d1,d2,d3,d4,d5,d6,Pr0);
       RSS_s = sort(RSS);
      end  
     
     if(No_of_Anchors==8)
       %if(t<11)                               % Experiment when no RSSI readings available
       RSS = lognormalshadowing_8(n,d1,d2,d3,d4,d5,d6,d7,d8,Pr0);
       RSS_s = sort(RSS);
       %end
     end  
 
     % RSSI Estimated Locations 
       disp('Estimated Location')
       
     if(No_of_Anchors==4) 
       mobileLoc_est = trilateration_4(RSS,RSS_s,Pr0,n,networkSize)
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2);
     end
     
     if(No_of_Anchors==6)
       mobileLoc_est = trilateration_6(RSS,RSS_s,Pr0,n,networkSize)
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2);
     end
     
     if(No_of_Anchors==8)
       mobileLoc_est = trilateration_8(RSS,RSS_s,Pr0,n,networkSize)
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2);
     end
 
       plot(X_T,Y_T,'r+','LineWidth',2,'MarkerSize',8);  
      
       hold on
       
% calculate velocities in X & Y Directions
       
       velocity_est=velocity(X_T,Y_T,t);
          s = [x; y; 0; 0];                                           % State of the system at time 't'
          X = s  %+ q*randn(4,1);                                       % state with noise
          
          
% Kalman Filter for Tracking Moving Target Code starts here
       [X_kalman,Y_kalman,X_V_kalman, Y_V_kalman]= kf(X,P,X_T,Y_T,velocity_est,t);
       plot(X_kalman,Y_kalman,'b+','LineWidth',2)
       hold on

 %UKF implementation
      Z = [X_T; Y_T; velocity_est(1); velocity_est(2)];
      disp('UKF Estimated State');
      [X_ukf]= ukf5(X,P,Z)
      
      plot(X_ukf(1),X_ukf(2),'ko','LineWidth',2)
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
      avg_error_xy_rssi = 0;
      avg_error_xy_kf = 0 ;
      avg_error_xy_ukf = 0 ;
      
    for t = 1:no_of_positions
      avg_error_xy_rssi=avg_error_xy_rssi + (error_xy_rssi(t)/no_of_positions);
      avg_error_xy_kf= avg_error_xy_kf + (error_xy_kf(t)/no_of_positions);
      avg_error_xy_ukf= avg_error_xy_ukf + (error_xy_ukf(t)/no_of_positions);
    end
     
     avg_error_xy_rssi
     avg_error_xy_kf
     avg_error_xy_ukf

     
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
    xlabel('Time, [sec]','FontName','Times','Fontsize',12) 
    ylabel('Error in x estimate [meters]','FontName','Times','Fontsize',12)
    hold on
    
  end
  legend('Error in x estimate of Pure RSSI','Error in x estimate of KF','Error in x estimate of UKF','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions
  
    plot(t,error_y_kf(t),'b+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    plot(t,error_y_ukf(t),'k+','Linewidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')
     plot(t,error_y_rssi(t),'ro','Linewidth',2)    %,'Markersize',2,'MarkerEdgeColor','g') 
    xlabel('Time, [sec]','FontName','Times','Fontsize',12) 
    ylabel('Error in y estimate [meters]','FontName','Times','Fontsize',12)
    
  hold on
  end
  legend('Error in y estimate of Pure RSSI','Error in y estimate of KF','Error in y estimate of UKF','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions
      
    plot(t,error_xy_kf(t),'b+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    plot(t,error_xy_ukf(t),'k+','Linewidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')
    plot(t,error_xy_rssi(t),'ro','Linewidth',2)    %,'Markersize',2,'MarkerEdgeColor','g') 
    xlabel('Time, [second]','FontName','Times','Fontsize',12) 
    ylabel('Error in xy estimate [meter]','FontName','Times','Fontsize',12)
    
  hold on
  end
  legend('Error in xy estimate of Pure RSSI','Error in xy estimate of KF','Error in xy estimate of UKF','Location','NorthWest')
  
  %linearity_test(n,Pr0);
 
f6 = figure(6); 
  for t =1:no_of_positions
      
      if(t<=8)
          x_v=10;
          plot(t,x_v,'b+','Linewidth',2) 
      elseif(t>8)
          x_v=0;
          plot(t,x_v,'b+','Linewidth',2)
      end
      hold on
      xlabel('Time, [s]','FontName','Times','Fontsize',12) 
      ylabel('Actual Velocity of Target in X direction [m/sec]','FontName','Times','Fontsize',12)
  end
   
  f7 = figure(7); 
  for t =1:no_of_positions
      
      if(t<=8)
          y_v=0;
          plot(t,y_v,'b+','Linewidth',2) 
      elseif(t>8)
          y_v=10;
          plot(t,y_v,'b+','Linewidth',2)
      end
      hold on
      xlabel('Time, [s]','FontName','Times','Fontsize',12) 
      ylabel('Actual Velocity of Target in Y direction [m/sec]','FontName','Times','Fontsize',12)
  end
  rssi_variation_wrt_time(n,Pr0);