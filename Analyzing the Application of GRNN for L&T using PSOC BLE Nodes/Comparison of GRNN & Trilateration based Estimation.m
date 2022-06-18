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
    axis([-2 12 -2 22])
    grid on
    hold on
    
 % Defining veriables
    no_of_positions = 35;     % Total Simulation Period = 35 seconds
    
    %%%%%%%%%%%%%% Initialization of Error Values %%%%%%%%%%%%%%%%%
    RMSE_kf_x =0 ; RMSE_rssi_x= 0; RMSE_ukf_x= 0; RMSE_grnn_x = 0;
    RMSE_kf_y =0 ; RMSE_rssi_y= 0; RMSE_ukf_y= 0; RMSE_grnn_y = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
 % Calculate reference RSSI at d0 = 1 meter using Free Space Path Loss Model
    d0=1;                                                    % in Meters
    Pr0 = RSSI_friss(d0);
    
    d_test = 20;
       
    Pr = RSSI_friss(d_test);

%Calculation of Path Loss Exponent : Use  RSSI = -(10*n*log10(d)+A)= -A-(10*n*log10(d))
 
      n = -(Pr + Pr0)/(10*log(d_test))      
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
       legend('Locations of PSOC BLE Nodes','Actual Track','GRNN based Tracking','Trilateration based Tracking')
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
       plot(GRNN_Estimated_Loc(1),GRNN_Estimated_Loc(2),'g+','LineWidth',2) 
       hold on
       
       RSS_s = sort(RSS);
      
     disp('RSSI Estimated Location')

       mobileLoc_est = trilateration_4(RSS,RSS_s,Pr0,n,networkSize)
   
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2);          
          
       trad_x(t)=X_T;
       trad_y(t)=Y_T;
       
       plot(X_T,Y_T,'r+','LineWidth',2)       
       hold on
       
      
      % Error Analysis of algorithm
% ---> Part 1 : RMSE Analysis
       RMSE_rssi_x = RMSE_rssi_x + (X_T - x)^2 ;
       RMSE_rssi_y = RMSE_rssi_y +  (Y_T - y)^2;
       RMSE_grnn_x = RMSE_grnn_x + (GRNN_Estimated_Loc(1) - x)^2 ;
       RMSE_grnn_y = RMSE_grnn_y + (GRNN_Estimated_Loc(2) - y)^2;              
       
% ---> Part 2 : Calculation of Absolute Errors     
       
     % A) For Pure RSSI based Technique
       error_x_rssi(t) = abs((x - X_T));
       error_y_rssi(t) = abs((y - Y_T));
       error_xy_rssi(t) =((error_x_rssi(t) + error_y_rssi(t))/2);            
     
    % B) For GRNN based Estimation
       error_x_grnn(t) = abs((x - GRNN_Estimated_Loc(1)));
       error_y_grnn(t) = abs((y - GRNN_Estimated_Loc(2)));
       error_xy_grnn(t) =((error_x_grnn(t) + error_y_grnn(t))/2);
    
    end
      
    % Average Error in x & y  coordinates
      avg_error_xy_rssi = 0; avg_error_xy_kf = 0 ;
      avg_error_xy_grnn = 0; avg_error_xy_ukf = 0 ;
      
    for t = 1:no_of_positions
      avg_error_xy_rssi=avg_error_xy_rssi + (error_xy_rssi(t)/no_of_positions); 
      avg_error_xy_grnn=avg_error_xy_grnn + (error_xy_grnn(t)/no_of_positions);      
    end
    
     disp('Average Localization Errors :')
     avg_error_xy_rssi
     avg_error_xy_grnn
     
      disp('RMSE Errors :')
     RMSE_rssi_x = sqrt(RMSE_rssi_x/no_of_positions)
     RMSE_rssi_y = sqrt(RMSE_rssi_y/no_of_positions)
     RMSE_grnn_x = sqrt(RMSE_grnn_x/no_of_positions)
     RMSE_grnn_y = sqrt(RMSE_grnn_y/no_of_positions)
     
      RMSE_rssi_avg = (RMSE_rssi_x + RMSE_rssi_y)/2 
      RMSE_grnn_avg = (RMSE_grnn_x + RMSE_grnn_y)/2      
     
% Plotting Absolute Errors of KF & UKF based Tracking

f2 = figure(2);
  for t =1:no_of_positions
        
    plot(t,error_x_grnn(t),'g+','LineWidth',2)   
    plot(t,error_x_rssi(t),'ro','LineWidth',2)
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in x estimates [meter]','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on
    
  end
  legend('Error in Trilateration based Estimation','Error in GRNN based Estimation','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions
      
    plot(t,error_y_grnn(t),'g+','LineWidth',2)  
    plot(t,error_y_rssi(t),'ro','LineWidth',2)    %,'Markersize',2,'MarkerEdgeColor','g')   
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14, 'LineWidth',2) 
    ylabel('Error in y estimates [m]','FontName','Times','Fontsize',14, 'LineWidth',2)
    
  hold on
  end
   legend('Error in Trilateration based Estimation','Error in GRNN based Estimation','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions
    
    plot(t,error_xy_grnn(t),'g+','LineWidth',2)    
    plot(t,error_xy_rssi(t),'ro','LineWidth',2)    %,'Markersize',2,'MarkerEdgeColor','g')     
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in xy estimates [m]','FontName','Times','Fontsize',14,'LineWidth',2)
    
  hold on
  end
  legend('Error in Trilateration based Estimation','Error in GRNN based Estimation','Location','NorthWest')
  
  %linearity_test(n,Pr0);
  
  f5 = figure(5);
  for t =1:no_of_positions
      
      if(t>=1 && t<=15)         x_v = 0; y_v = 1;
       elseif(t>15 && t<=21)     x_v = 1; y_v = 0;    
       elseif(t>21 && t<=35)     x_v = 0; y_v = -1; 
       end
       
    plot(t,x_v,'b+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b')  
    xlabel('Time [sec]','FontName','Times','Fontsize',14, 'LineWidth',2) 
    ylabel('Actual Velocity in x Direction','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on
    
  end
  
  f6 = figure(6);
  for t =1:no_of_positions
      
      if(t>=1 && t<=15)         x_v = 0; y_v = 1;
       elseif(t>15 && t<=21)     x_v = 1; y_v = 0;    
       elseif(t>17 && t<=35)     x_v = 0; y_v = -1; 
       end
       
    plot(t,y_v,'r+','Linewidth',2)      %,'Markersize',2,'MarkerEdgeColor','b')  
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Actual Velocity in y Direction','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on
    
  end
  

