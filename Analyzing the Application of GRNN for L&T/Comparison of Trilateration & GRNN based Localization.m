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
    axis([0 100 0 100])
    grid on
    hold on
  
 %%% GRNN Setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kf_Input = [15.0792633060790,14.1806516547891,15.5799859112948,17.1688500372017,19.2431453939025,22.1110756657799,25.3338557065660,28.5745229361358,28.9256762444295,35.4503031634321,39.8886411957694,45.5290197027913,50.9263785329761,54.5409563656959,60.3158396257803,61.1616904632572,61.3755573011148,63.6194582030599,62.3096206650241,66.8491216959944,66.4835260614732,70.9631315499690,71.9942157331791,74.8374363530220,76.1277275197544,80.1434059474335,81.4845919759941,83.4158205738387,84.3456849229203,87.5499529232976,88.8884703013678,90.4357055723913,91.8733368269602,93.9862026987790,97.4864822329440;17.3030155923501,20.7152086281125,24.4262199464450,30.2690557488747,36.0073878657229,39.0178240931511,44.4959953896231,50.4330860867279,52.8669317328990,53.4375068486979,56.7644715003517,58.7992458585924,59.0334326429756,61.5129062974494,63.1886355843918,63.9834083249173,62.1746360415443,61.8806624926369,58.8559763030177,56.0980169509953,53.3310797228647,50.1452410889905,46.5496436482709,43.1279439863813,39.0991869071262,37.2540769401493,34.2177763898869,31.5360909888229,28.3773696020477,25.2805486974178,22.5676963251491,19.7740807580913,13.9620783689650,14.1370615106812,9.68464508494039];
kf_Target = [10,12,14,16,18,20,22,24,26,31,36,41,46,51,56,61,61,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95;10,15,20,25,30,35,40,45,50,52,54,56,58,60,62,64,64,64,61,58,55,52,49,46,43,40,37,34,31,28,25,22,19,16,13];
spread =1;

net_Loc_est = newgrnn(kf_Input,kf_Target,spread);
view(net_Loc_est ) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5  


% Defining veriables
    no_of_positions = 35;     % Total Simulation Period = 35 seconds
    
    
    P = [0.25 0 0  0; 0 0.04 0 0; 0 0 0.02 0; 0 0 0 0.01];   % Initial Process Covariance Matrix
    q=0.1;                                                   %std of process   
    
    %%%%%%%%%%%%%% Initialization of Error Values %%%%%%%%%%%%%%%%%
    RMSE_kf =0 ; RMSE_rssi= 0; RMSE_ukf= 0; RMSE_grnn = 0;
    MSE_x_kf = 0; MSE_y_kf = 0; MSE_xy_kf = 0; 
    MSE_x_ukf = 0; MSE_y_ukf = 0; MSE_xy_ukf = 0; 
    MSE_x_rssi = 0; MSE_y_rssi = 0; MSE_xy_rssi = 0;
    MSE_x_grnn = 0; MSE_y_grnn = 0; MSE_xy_grnn = 0; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
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
       elseif(t==9 && t<15)    x_v = 5; y_v = 2;
       elseif(t>=16 && t<17)   x_v = 0; y_v = 0;
       elseif(t>=18 && t<=35)   x_v = 2; y_v = -3;    
       %elseif(t>=35 && t<=50)  x_v = 0; y_v = 4;    
       end
       
       x_actual(t)=x;        %  para 1
       y_actual(t)=y;        %  para 1
       
       x=x+x_v;
       y=y+y_v;
       
       disp('True Location')
       [x,y]                                           % Actual Target Location
       plot(x,y,'rs','LineWidth',2)
             
       ylabel('y-Axis[meter]','FontName','Times','Fontsize',14,'LineWidth',2);
       xlabel('x-Axis[meter]','FontName','Times','Fontsize',14,'LineWidth',2);
       legend('Anchor Location','Actual Target Location','GRNN based Estimation','Trad RSSI based Estimation','GRNN + KF based Estimation','GRNN + UKF Based Implementation','Location','SouthEast')
       hold on
       
% Actual Distances from Anchors required to generate RSSI Values
       d1 = sqrt( x^2 + y^2 );
       d2 = sqrt((100-x)^2 + y^2);
       d3 = sqrt((100-x)^2+ (100-y)^2);
       d4 = sqrt(x^2+ (100-y)^2);
    
% Generate RSSI Values at 4 Anchor Nodes which are at d1, d2, d3 & d4 distances respectively from Moving Target     
       % Use  RSSI = - (10*n*log10(d) + A)  and  d= antilog(-(RSSI + A)/(10*n))
          
       RSS = lognormalshadowing_4(n,d1,d2,d3,d4,Pr0);
       
       RSS_1(t)= RSS(1);
       RSS_2(t)= RSS(2);
       RSS_3(t)= RSS(3);                        %4 RSS Values
       RSS_4(t)= RSS(4);
                     
       RSS_s = sort(RSS);
      
     disp('RSSI Estimated Location')
       mobileLoc_est = trilateration_4(RSS,RSS_s,Pr0,n,networkSize)
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2);          
          
       trad_x(t)=X_T;
       trad_y(t)=Y_T;
       
       plot(X_T,Y_T,'r+','LineWidth',2)       
       hold on
       
% calculate velocities in X & Y Directions
       
          velocity_est=velocity(X_T,Y_T,t);
       
          s = [x; y; 0; 0];                                           % State of the system at time 't'
          X = s + q*randn(4,1);                                       % state with noise
                  
% Kalman Filter for Tracking Moving Target Code starts here
       [X_kalman,Y_kalman,X_kf]= kf(X,P,X_T, Y_T, velocity_est,t);
       
       kf_x(t)=X_kalman;      %Para 3
       kf_y(t)=Y_kalman;      %Para 4
       
       plot(X_kalman,Y_kalman,'b*','LineWidth',2)
       hold on
       
       kf_new_vector = [X_kalman; Y_kalman];
       GRNN_Estimated_Loc = sim(net_Loc_est ,kf_new_vector)
       
       GRNN_x(t)= GRNN_Estimated_Loc(1); 
       GRNN_y(t)= GRNN_Estimated_Loc(2); 
       plot(GRNN_Estimated_Loc(1),GRNN_Estimated_Loc(2),'g+','LineWidth',2) 
       hold on       

 %UKF implementation
      Z = [X_T; Y_T; velocity_est(1); velocity_est(2)];
      disp('UKF Estimated State')
      [X_ukf]= ukf5(X,P,Z)
      
      ukf_x(t)=X_ukf(1);      %Para 5
      ukf_y(t)=X_ukf(2);      %Para 6
      
      plot(X_ukf(1),X_ukf(2),'ko','LineWidth',2)      
      hold on
      
      % Error Analysis of algorithm
% ---> Part 1 : RMSE Analysis
       RMSE_rssi = RMSE_rssi + ((X_T - x)^2 + (Y_T - y)^2);
       RMSE_grnn = RMSE_grnn + ((GRNN_Estimated_Loc(1) - x)^2 + (GRNN_Estimated_Loc(2) - y)^2);
       RMSE_kf = RMSE_kf + ((X_kalman - x)^2 + (Y_kalman - y)^2);
       RMSE_ukf = RMSE_ukf + ((X_ukf(1)-x)^2 + (X_ukf(2)-y)^2);
       
% ---> Part 2 : Calculation of Absolute Errors 

     % a) For Kalman Filter
       error_x_kf(t) =  abs((x - X_kalman));
       error_y_kf(t) =  abs((y - Y_kalman));
       error_xy_kf(t) = ((error_x_kf(t) + error_y_kf(t))/2);
       
       MSE_x_kf = MSE_x_kf + ((x - X_kalman)*(x - X_kalman));
       MSE_y_kf = MSE_y_kf + ((y - Y_kalman))*((y - Y_kalman));
       MSE_xy_kf = MSE_xy_kf +((MSE_x_kf + MSE_y_kf)/2);
       
     % b) For Unscented Kalman Filter
       error_x_ukf(t) = abs((x - X_ukf(1)));
       error_y_ukf(t) = abs((y - X_ukf(2)));
       error_xy_ukf(t) = ((error_x_ukf(t) + error_y_ukf(t))/2);
     
       MSE_x_ukf = MSE_x_ukf + ((x - X_ukf(1)))*((x - X_ukf(1)));
       MSE_y_ukf = MSE_y_ukf + ((y - X_ukf(2)))*((y - X_ukf(2)));
       MSE_xy_ukf = MSE_xy_ukf + ((MSE_x_ukf + MSE_y_ukf)/2);
       
     % c) For Pure RSSI based Technique
       error_x_rssi(t) = abs((x - X_T));
       error_y_rssi(t) = abs((y - Y_T));
       error_xy_rssi(t) =((error_x_rssi(t) + error_y_rssi(t))/2);
     
       MSE_x_rssi = MSE_x_rssi + ((x - X_T))*((x - X_T));
       MSE_y_rssi = MSE_y_rssi +((y - Y_T))*((y - Y_T));
       MSE_xy_rssi =MSE_xy_rssi + ((MSE_x_rssi + MSE_y_rssi)/2);
     
    % d) For GRNN based Estimation
       error_x_grnn(t) = abs((x - GRNN_Estimated_Loc(1)));
       error_y_grnn(t) = abs((y - GRNN_Estimated_Loc(2)));
       error_xy_grnn(t) =((error_x_grnn(t) + error_y_grnn(t))/2);
    
       MSE_x_grnn = MSE_x_grnn + ((x- GRNN_Estimated_Loc(1))*(x- GRNN_Estimated_Loc(1)));
       MSE_y_grnn = MSE_y_grnn + ((x- GRNN_Estimated_Loc(2))*(x- GRNN_Estimated_Loc(2)));
       MSE_xy_grnn = MSE_xy_grnn + ((MSE_x_grnn + MSE_y_grnn)/2);
    end
      
    % Average Error in x & y  coordinates
      avg_error_xy_rssi = 0;
      avg_error_xy_kf = 0 ;
      
    for t = 1:no_of_positions
      avg_error_xy_rssi=avg_error_xy_rssi + (error_xy_rssi(t)/no_of_positions);   
      avg_error_xy_kf= avg_error_xy_kf + (error_xy_kf(t)/no_of_positions);           
    end
    
     
     avg_error_xy_rssi
     avg_error_xy_kf
     RMSE_rssi = sqrt(RMSE_rssi/no_of_positions)
     RMSE_kf = sqrt(RMSE_kf/no_of_positions)
     RMSE_ukf = sqrt(RMSE_ukf/no_of_positions)
     RMSE_grnn = sqrt(RMSE_grnn/no_of_positions)
     
     MSE_xy_rssi = MSE_xy_rssi/no_of_positions 
     MSE_xy_grnn = MSE_xy_grnn/no_of_positions  
     MSE_xy_kf = MSE_xy_kf/no_of_positions  
     MSE_xy_ukf = MSE_xy_kf/no_of_positions 
     
     
% Plotting Absolute Errors of KF & UKF based Tracking

f2 = figure(2);
  for t =1:no_of_positions
        
    plot(t,error_x_grnn(t),'g+','LineWidth',2)
    plot(t,error_x_kf(t),'b+','LineWidth',2)    
    plot(t,error_x_ukf(t),'k+','LineWidth',2)
    plot(t,error_x_rssi(t),'ro','LineWidth',2)
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in x estimates [meter]','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on
    
  end
  legend('Error in Traditional RSSI based Estimation','Error in GRNN based Estimation','Error in GRNN + KF based Estimation','Error in GRNN + UKF based Estimation','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions
      
    plot(t,error_y_grnn(t),'g+','LineWidth',2)  
    plot(t,error_y_kf(t),'b+','LineWidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    plot(t,error_y_ukf(t),'k+','LineWidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')    
    plot(t,error_y_rssi(t),'ro','LineWidth',2)    %,'Markersize',2,'MarkerEdgeColor','g')   
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14, 'LineWidth',2) 
    ylabel('Error in y estimates [m]','FontName','Times','Fontsize',14, 'LineWidth',2)
    
  hold on
  end
  legend('Error in Traditional RSSI based Estimation','Error in GRNN based Estimation','Error in GRNN + KF based Estimation','Error in GRNN + UKF based Estimation','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions
    
    plot(t,error_xy_grnn(t),'g+','LineWidth',2)  
    plot(t,error_xy_kf(t),'b+','LineWidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    plot(t,error_xy_ukf(t),'k+','LineWidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')    
    plot(t,error_xy_rssi(t),'ro','LineWidth',2)    %,'Markersize',2,'MarkerEdgeColor','g')     
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in xy estimates [m]','FontName','Times','Fontsize',14,'LineWidth',2)
    
  hold on
  end
  legend('Error in Traditional RSSI based Estimation','Error in GRNN based Estimation','Error in GRNN + KF based Estimation','Error in GRNN + UKF based Estimation','Location','NorthWest')
  
  %linearity_test(n,Pr0);
  
  f5 = figure(5);
  for t =1:no_of_positions
      
      if(t<9)                 x_v = 2; y_v = 5;
       elseif(t==9 && t<=15)    x_v = 5; y_v = 2;
       elseif(t<=16 && t<=17)   x_v = 0; y_v = 0;
       elseif(t<=18 && t<=35)   x_v = 2; y_v = -3;               
       end
       
    plot(t,x_v,'b+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b')  
    xlabel('Time [sec]','FontName','Times','Fontsize',14, 'LineWidth',2) 
    ylabel('Actual Velocity in x Direction','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on
    
  end
  
  f6 = figure(6);
  for t =1:no_of_positions
      
       if(t<9)                 x_v = 2; y_v = 5;
       elseif(t==9 && t<=15)    x_v = 5; y_v = 2;
       elseif(t<=16 && t<=17)   x_v = 0; y_v = 0;
       elseif(t<=18 && t<=35)   x_v = 2; y_v = -3;               
       end
       
    plot(t,y_v,'r+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b')  
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Actual Velocity in y Direction','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on
    
  end
  

 f7 = figure(7);
 plotregression(x_actual, trad_x,'Regression using Traditional', x_actual,GRNN_x,'Regression using GRNN', x_actual, kf_x,'Regression using KF', x_actual, ukf_x,'Regression using UKF')
 
 f8 = figure(8);
 plotregression(y_actual, trad_y,'Regression using Traditional',y_actual,GRNN_y,'Regression using GRNN', y_actual, kf_y,'Regression using KF', y_actual, ukf_y,'Regression using UKF')
 
 
 