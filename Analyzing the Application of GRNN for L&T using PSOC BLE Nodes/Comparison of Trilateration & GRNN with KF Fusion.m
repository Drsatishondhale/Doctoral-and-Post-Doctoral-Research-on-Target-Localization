%% WSN Deployment Setting Parameters    
    clear all
    close all
    clc
    
    N = 4;                                            % number of anchors
    M = 1;                                            % number of mobile nodes
    networkSize = 30;                                % we consider a 100by100 area that the mobile can wander
    
        anchorLoc   = [networkSize*0.033     networkSize*0.13;           % set the anchor at 4 vertices of the region
                       networkSize*0.3      networkSize*0.13;
                       networkSize*0.033    networkSize*0.4;
                       networkSize*0.3     networkSize*0.4];

%%% GRNN Setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RSSI_input_Vector = [21.7387782019220,28.2452926046665,30.4306834501080,38.3682461740157,33.0369589449853,28.3882055176818,20.7378173235525,20.2159134335169,13.9785156071710,8.54643815386706,11.8622368787026,8.27409414429550,6.00753967974051,7.30459313921137,5.93305633048783,-2.98783974621676,-1.02241739435725,-0.974222603203503,-2.24143356189886,-2.27908680838789,1.08272792622511,-0.524142049497959,3.11678591845415,9.12393684302102,5.34131992652948,8.19115138376715,5.72127246541938,6.81124251495229,5.09293124695973,9.78299545419615,4.28043140867071,9.29753178527877,5.87304044839544,9.79819672543600,5.96174130639606;8.42925408128604,6.40135421411176,17.7533660431446,10.5566955054971,8.32624248909003,6.06794209602777,6.75276809755457,9.17712704687031,9.52063848786620,5.19261064347387,10.7786932856444,1.18898066056339,-1.85127075024971,-0.226772516645734,-3.22244746605060,-2.26944726427404,1.91576934519662,4.41432442468001,2.08440067784953,0.894590310817569,1.61422277979000,5.22434043079986,6.39529991307418,8.80538326663791,5.45253990026949,14.2917305207220,13.1043969862258,15.5199146062608,25.5305452060513,34.0930503183431,25.8293839861376,35.4659149899652,38.3855735031903,23.4294489222452,20.9549234270350;-3.32182389832789,0.957607939259997,4.77544422713974,2.93237906557498,2.46630209384394,1.95026302356063,4.55491103345388,8.78827924471640,7.24375330824835,9.52724561436450,5.18474695479228,9.60163224602470,7.89088630089537,7.27594975543089,7.58350816446472,7.93338066674443,13.5157415400111,16.3128408852804,19.7730928573003,24.2667309432002,21.5612205785766,30.6833476366398,40.9825501033826,43.5064242431614,31.1943055299881,26.2345154077715,13.6732390107918,18.6803904877838,15.1420834329554,12.3172602749315,6.98533285564721,7.07964708826056,1.80355973649392,3.29594351651374,4.03366861444021;0.697320828386623,2.56133399959318,6.64621430875566,8.24142294484661,14.1202150288611,10.2534079740616,13.8585711545668,19.3254089985544,22.4900912924085,28.7434529429255,30.1885670822950,37.0938088923161,35.2417487410686,22.1462979625869,22.9682615753257,20.4186319623552,12.2674854709185,14.0854395647665,15.6394378252240,7.53768817664919,9.72167333532494,11.4724138806547,11.7186397783424,10.2679007240979,9.40660975641612,7.30833495671435,6.70990645676123,7.32071908808287,4.92223715101561,5.58520224871402,9.06521967703518,1.24840749920657,1.82186321377976,1.92918487775344,1.36692130574327];
Target = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,4,5,6,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8;0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,15,15,15,15,15,15,14,13,12,11,10,9,8,7,6,5,4,3,2];
spread =3;

net_Loc_est = newgrnn(RSSI_input_Vector,Target,spread);
view(net_Loc_est)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5  
 
  %show anchor Locations
    f1 = figure(1);
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    axis([0 10 0 23])
    grid on
    hold on
    
 % Defining veriables
    no_of_positions = 35;     % Total Simulation Period = 35 seconds
    
    
    P = [0.25 0 0  0; 0 0.04 0 0; 0 0 0.02 0; 0 0 0 0.01];   % Initial Process Covariance Matrix
    q=0.1;                                                   %std of process   
    
    %%%%%%%%%%%%%% Initialization of Error Values %%%%%%%%%%%%%%%%%
    RMSE_kf_x_GRNN =0 ;  RMSE_ukf_x_GRNN= 0; RMSE_kf_x_Trilat =0 ;  RMSE_ukf_x_Trilat= 0;
    RMSE_kf_y_GRNN =0 ;  RMSE_ukf_y_GRNN= 0; RMSE_kf_y_Trilat =0 ;  RMSE_ukf_y_Trilat= 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
 % Calculate reference RSSI at d0 = 1 meter using Free Space Path Loss Model
    d0=1;                                                    % in Meters
    Pr0 = RSSI_friss(d0);
    
    d_test = 20;
       
    Pr = RSSI_friss(d_test);

%Calculation of Path Loss Exponent : Use  RSSI = -(10*n*log10(d)+A)= -A-(10*n*log10(d))
 
      n = -(Pr + Pr0)/(10*log(d_test));      
      x=2;
      y=0;
           
% Generating trajectory for the mobile node  
    for t = 1:no_of_positions          
       
       if(t>=1 && t<=15)         x_v = 0; y_v = 1;
       elseif(t>15 && t<=21)     x_v = 1; y_v = 0;    
       elseif(t>21 && t<=35)     x_v = 0; y_v = -1; 
       end
               
       x_actual(t)=x;        %  para 1
       y_actual(t)=y;        %  para 1
              
       x=x+x_v;
       y=y+y_v;
       
       disp('True Location')
       [x,y]                                           % Actual Target Location
       plot(x,y,'rs','LineWidth',2)
       
       ylabel('y-Axis [meter]','FontName','Times','Fontsize',14,'LineWidth',2);
       xlabel('x-Axis [meter]','FontName','Times','Fontsize',14,'LineWidth',2);
       legend('Node Locations','Actual Track','Trilat.+KF based Tracking','Trilat.+UKF based Tracking','GRNN+KF based Tracking','GRNN+UKF Based Tracking')
       hold on
       
% Actual Distances from Anchors required to generate RSSI Values
       d1 = sqrt( (1-x)^2 + (4-y)^2 );
       d2 = sqrt((9-x)^2 + (4-y)^2);
       d3 = sqrt((9-x)^2+ (12-y)^2);
       d4 = sqrt((1-x)^2+ (12-y)^2);
    
% Generate RSSI Values at 4 Anchor Nodes which are at d1, d2, d3 & d4 distances respectively from Moving Target     
       % Use  RSSI = - (10*n*log10(d) + A)  and  d= antilog(-(RSSI + A)/(10*n))
          
       RSS = lognormalshadowing_4(n,d1,d2,d3,d4,Pr0);
       
       RSS_1(t)= RSS(1);
       RSS_2(t)= RSS(2);
       RSS_3(t)= RSS(3);                        %4 RSS Values
       RSS_4(t)= RSS(4);
       
       RSS_new_vector = RSS.';
       GRNN_Estimated_Loc = sim(net_Loc_est ,RSS_new_vector)
      
       GRNN_x(t)= GRNN_Estimated_Loc(1); 
       GRNN_y(t)= GRNN_Estimated_Loc(2); 
      
       RSS_s = sort(RSS);
      
       mobileLoc_est = trilateration_4(RSS,RSS_s,Pr0,n,networkSize)   
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2);                    
       trad_x(t)=X_T;
       trad_y(t)=Y_T;
    
       
% calculate velocities in X & Y Directions
       
          velocity_est=velocity(X_T,Y_T,t);
       
          s = [x; y; 0; 0];                                           % State of the system at time 't'
          X = s;                                       % state with noise
                  

% Trilateration + Kalman Filter for Tracking Moving Target Code starts here
       [X_kalman_Trilat,Y_kalman_Trilat,X_kf]= kf(X,P,X_T, Y_T, velocity_est,t);
       
       kf_Trilat_x(t)=X_kalman_Trilat;      %Para 3
       kf_Trilat_y(t)=Y_kalman_Trilat;      %Para 4              
       plot(X_kalman_Trilat,Y_kalman_Trilat,'ro','LineWidth',2)      
       hold on
       
% Trilateration + UKF implementation
      Z = [X_T; Y_T; velocity_est(1); velocity_est(2)];
      disp('UKF Estimated State')
      [X_ukf]= ukf5(X,P,Z)      
     
      X_ukf_Trilat=X_ukf(1);      %Para 5
      Y_ukf_Trilat=X_ukf(2);      %Para 6        
      ukf_Trilat_x(t)=X_ukf_Trilat;      %Para 5
      ukf_Trilat_y(t)=Y_ukf_Trilat;      %Para 6      
      plot(X_ukf_Trilat,Y_ukf_Trilat,'g+','LineWidth',2)      
      hold on       
 
  % GRNN + Kalman Filter for Tracking Moving Target Code starts here
       [X_kalman_GRNN,Y_kalman_GRNN,X_kf]= kf(X,P,GRNN_Estimated_Loc(1), GRNN_Estimated_Loc(2), velocity_est,t);
       
       kf_GRNN_x(t)=X_kalman_GRNN;      %Para 3
       kf_GRNN_y(t)=Y_kalman_GRNN;      %Para 4              
       plot(X_kalman_GRNN,Y_kalman_GRNN,'b*','LineWidth',2)      
       hold on
       
 % GRNN + UKF implementation
      Z = [GRNN_Estimated_Loc(1); GRNN_Estimated_Loc(2); velocity_est(1); velocity_est(2)];
      disp('UKF Estimated State')
      [X_ukf]= ukf5(X,P,Z) 
      
      X_ukf_GRNN=X_ukf(1);      
      Y_ukf_GRNN=X_ukf(2);        
      ukf_GRNN_x(t)=X_ukf_GRNN;      %Para 5
      ukf_GRNN_y(t)=Y_ukf_GRNN;     %Para 6      
      plot(X_ukf_GRNN,Y_ukf_GRNN,'ko','LineWidth',2)      
      hold on
      
      
      % Error Analysis of algorithm
% ---> Part 1 : RMSE Analysis
       
       RMSE_kf_x_GRNN = RMSE_kf_x_GRNN + (X_kalman_GRNN - x)^2 ;
       RMSE_kf_y_GRNN = RMSE_kf_y_GRNN + (Y_kalman_GRNN - y)^2;
       RMSE_ukf_x_GRNN = RMSE_ukf_x_GRNN + (X_ukf_GRNN-x)^2 ;
       RMSE_ukf_y_GRNN = RMSE_ukf_y_GRNN + (Y_ukf_GRNN-y)^2; 
       
       RMSE_kf_x_Trilat = RMSE_kf_x_Trilat + (X_kalman_Trilat - x)^2 ;
       RMSE_kf_y_Trilat = RMSE_kf_y_Trilat + (Y_kalman_Trilat - y)^2;
       RMSE_ukf_x_Trilat = RMSE_ukf_x_Trilat + (X_ukf_Trilat-x)^2 ;
       RMSE_ukf_y_Trailat = RMSE_ukf_y_Trilat + (Y_ukf_Trilat-y)^2; 
       
% ---> Part 2 : Calculation of Absolute Errors 

     % a) For GRNN + Kalman Filter
       error_x_kf_GRNN(t) =  abs((x - X_kalman_GRNN));
       error_y_kf_GRNN(t) =  abs((y - Y_kalman_GRNN));
       error_xy_kf_GRNN(t) = ((error_x_kf_GRNN(t) + error_y_kf_GRNN(t))/2);
       
     % b) For Trilateration + Kalman Filter
       error_x_kf_Trilat(t) =  abs((x - X_kalman_Trilat));
       error_y_kf_Trilat(t) =  abs((y - Y_kalman_Trilat));
       error_xy_kf_Trilat(t) = ((error_x_kf_Trilat(t) + error_y_kf_Trilat(t))/2);
       
      
     % c) For GRNN + Unscented Kalman Filter
       error_x_ukf_GRNN(t) = abs((x - X_ukf_GRNN));
       error_y_ukf_GRNN(t) = abs((y - Y_ukf_GRNN));
       error_xy_ukf_GRNN(t) = ((error_x_ukf_GRNN(t) + error_y_ukf_GRNN(t))/2);
       
     % d) For Trilateration + Unscented Kalman Filter
       error_x_ukf_Trilat(t) = abs((x - X_ukf_Trilat));
       error_y_ukf_Trilat(t) = abs((y - Y_ukf_Trilat));
       error_xy_ukf_Trilat(t) = ((error_x_ukf_Trilat(t) + error_y_ukf_Trilat(t))/2);            
    
    end
      
    % Average Error in x & y  coordinates
       avg_error_xy_kf_GRNN = 0 ; avg_error_xy_kf_Trilat = 0 ;
       avg_error_xy_ukf_GRNN = 0 ;  avg_error_xy_ukf_Trilat = 0 ;
      
    for t = 1:no_of_positions      
      avg_error_xy_kf_GRNN= avg_error_xy_kf_GRNN + (error_xy_kf_GRNN(t)/no_of_positions); 
      avg_error_xy_ukf_GRNN= avg_error_xy_ukf_GRNN + (error_xy_ukf_GRNN(t)/no_of_positions); 
      avg_error_xy_kf_Trilat= avg_error_xy_kf_Trilat + (error_xy_kf_Trilat(t)/no_of_positions); 
      avg_error_xy_ukf_Trilat= avg_error_xy_ukf_Trilat + (error_xy_ukf_Trilat(t)/no_of_positions); 
    end
    
     disp('Average Localization Errors :')
     
     avg_error_xy_kf_GRNN
     avg_error_xy_ukf_GRNN
     avg_error_xy_kf_Trilat
     avg_error_xy_ukf_Trilat
     
      disp('RMSE Errors :')
     
     RMSE_kf_x_GRNN = sqrt(RMSE_kf_x_GRNN/no_of_positions)
     RMSE_kf_y_GRNN = sqrt(RMSE_kf_y_GRNN/no_of_positions)
     RMSE_ukf_x_GRNN = sqrt(RMSE_ukf_x_GRNN/no_of_positions)
     RMSE_ukf_y_GRNN = sqrt(RMSE_ukf_y_GRNN/no_of_positions)
           
      RMSE_kf_avg_GRNN = (RMSE_kf_x_GRNN + RMSE_kf_y_GRNN)/2
      RMSE_ukf_avg_GRNN = (RMSE_ukf_x_GRNN + RMSE_ukf_y_GRNN)/2 
      
      RMSE_kf_x_Trilat = sqrt(RMSE_kf_x_Trilat/no_of_positions)
     RMSE_kf_y_Trilat = sqrt(RMSE_kf_y_Trilat/no_of_positions)
     RMSE_ukf_x_Trilat = sqrt(RMSE_ukf_x_Trilat/no_of_positions)
     RMSE_ukf_y_Trilat = sqrt(RMSE_ukf_y_Trilat/no_of_positions)
           
      RMSE_kf_avg_Trilat = (RMSE_kf_x_Trilat + RMSE_kf_y_Trilat)/2
      RMSE_ukf_avg_Trilat = (RMSE_ukf_x_Trilat + RMSE_ukf_y_Trilat)/2 
     
% Plotting Absolute Errors of KF & UKF based Tracking

f2 = figure(2);
  for t =1:no_of_positions
    plot(t,error_x_ukf_Trilat(t),'ro','LineWidth',2)       
    plot(t,error_x_kf_GRNN(t),'b+','LineWidth',2)    
    plot(t,error_x_ukf_GRNN(t),'k+','LineWidth',2)    
    plot(t,error_x_kf_Trilat(t),'g+','LineWidth',2)
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in x estimates [meter]','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on
    
  end
  legend('Error in Trilat.+ KF based Estimation','Error in Trilat. + UKF based Estimation','Error in GRNN+KF based Estimation','Error in GRNN + UKF based Estimation','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions
    plot(t,error_y_ukf_Trilat(t),'ro','LineWidth',2)          
    plot(t,error_y_kf_GRNN(t),'b+','LineWidth',2)    
    plot(t,error_y_ukf_GRNN(t),'k+','LineWidth',2)    
    plot(t,error_y_kf_Trilat(t),'g+','LineWidth',2)
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14, 'LineWidth',2) 
    ylabel('Error in y estimates [m]','FontName','Times','Fontsize',14, 'LineWidth',2)
    
  hold on
  end
  legend('Error in Trilat.+ KF based Estimation','Error in Trilat. + UKF based Estimation','Error in GRNN+KF based Estimation','Error in GRNN + UKF based Estimation','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions
    plot(t,error_xy_ukf_Trilat(t),'ro','LineWidth',2) 
    plot(t,error_xy_kf_GRNN(t),'b+','LineWidth',2)    
    plot(t,error_xy_ukf_GRNN(t),'k+','LineWidth',2)        
    plot(t,error_xy_kf_Trilat(t),'g+','LineWidth',2)
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in xy estimates [m]','FontName','Times','Fontsize',14,'LineWidth',2)
    
  hold on
  end
legend('Error in Trilat.+ KF based Estimation','Error in Trilat. + UKF based Estimation','Error in GRNN+KF based Estimation','Error in GRNN + UKF based Estimation','Location','NorthWest')
  
 