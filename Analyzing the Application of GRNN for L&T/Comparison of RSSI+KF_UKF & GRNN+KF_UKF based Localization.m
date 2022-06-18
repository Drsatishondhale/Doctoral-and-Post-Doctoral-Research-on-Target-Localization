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

%%% GRNN Setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RSSI_input_Vector = [-9,-3,-22,-14,-8,-8,-25,-19,-10,-20,-20,-34,-30,-26,-26,-20,-24,-24,-29,-30,-31,-29,-27,-24,-25,-30,-27,-31,-20,-30,-38,-29,-28,-27,-37,-5.74383846205120,-10.5271360245834,-11.9568581840782,-14.5573673593119,-15.9272516920373,-17.9347616967786,-19.6515604742009,-21.6487647637235,-21.6488784244201,-22.9320678674317,-24.8580897402942,-25.1969072932256,-28.3479954329871,-26.8971685148825,-29.1093219495418,-27.2105349212443,-27.8707513713502,-29.0910413657862,-28.3945264707311,-27.1000476206782,-28.2990380818818,-27.8402686958009,-28.5741632985159,-28.2207166574054,-27.0971490723350,-28.9229212392991,-28.7776770572564,-26.7292474689114,-31.2692767178927,-29.8725310555889,-28.6328930954573,-28.6977411829075,-28.9759701463069,-27.5619514555927,-30.8733730700282;-27,-25,-24,-33,-29,-28,-30,-30,-25,-31,-28,-17,-28,-25,-22,-34,-25,-29,-24,-24,-23,-29,-19,-18,-26,-16,-9,-7,-15,-16,-21,-16,-8,-3,8,-27.8125282585631,-29.5411013494510,-28.9119868896749,-27.4400003486173,-26.6376436021166,-28.4607455675391,-26.7403357717975,-27.7631760669118,-24.5744390332230,-26.8417656019169,-26.7610146287211,-25.1176780345839,-26.0516210729923,-26.4971282952776,-25.6959619045169,-25.8816309762259,-27.7298716028250,-25.2063121579286,-23.6743786118613,-23.1417559876042,-22.0124261787784,-19.6991146242814,-20.1437848390622,-20.5682367340970,-19.0325432138794,-18.7195474770453,-16.3724170892785,-13.9965698399162,-12.6789465416153,-10.6682405003900,-9.31005541056201,-7.49507627141044,-3.89002600414719,-0.569672188099916,2.76359946098976;-28,-32,-34,-36,-32,-28,-25,-31,-26,-29,-25,-30,-18,-21,-14,-27,-30,-18,-19,-25,-8,-27,-19,-20,-28,-24,-17,-25,-26,-28,-35,-28,-28,-29,-32,-32.6785919459785,-32.6444605265936,-33.9304415696157,-29.7756765586898,-31.4487160087178,-29.4498213693888,-29.2753097487000,-27.6912331333804,-24.3420708668210,-27.3010498084451,-25.9309835065899,-25.1446820748165,-22.4642667021720,-21.0949951688151,-23.1149775490863,-20.7748882964838,-21.8722583766570,-20.5399753404201,-20.5651702593370,-21.3685063370386,-22.2483235434017,-21.9331802123878,-21.3374399541496,-23.6292777021614,-22.6339843308163,-22.5229787691702,-23.8038925254348,-25.0952928032412,-24.0717065502028,-26.1563494195998,-28.6217202047606,-27.7331906829676,-28.3945632382675,-28.6416924907753,-27.0787256442605;-27,-34,-17,-26,-20,-28,-14,-18,-26,-26,-21,-22,-18,-24,-38,-32,-28,-24,-20,-25,-33,-30,-36,-30,-29,-32,-31,-34,-29,-36,-34,-29,-35,-35,-24,-29.5205409525122,-28.0044018292004,-27.2157705893991,-27.2476125676854,-23.3331126670582,-21.3227286155088,-21.6427690009574,-21.3655975971106,-20.8245799863627,-21.7843958593469,-22.7257978336001,-24.0911441543699,-22.5650162253030,-23.7646606977744,-26.5472148835505,-25.8998600637911,-25.3900041096342,-25.3554404869719,-27.8916430036086,-26.7725388506481,-29.7340653369743,-27.8221113717370,-28.5202346832637,-29.7146187200687,-28.6777888207681,-30.8372707913025,-31.7605466616006,-32.4951947504270,-31.8575062827818,-32.6639352904930,-33.5994366942798,-34.0286493189285,-33.6166140242227,-32.4734987055958,-35.4244759090660];
Target = [10,12,14,16,18,20,22,24,26,31,36,41,46,51,56,61,61,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,10,12,14,16,18,20,22,24,26,31,36,41,46,51,56,61,61,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95;10,15,20,25,30,35,40,45,50,52,54,56,58,60,62,64,64,64,61,58,55,52,49,46,43,40,37,34,31,28,25,22,19,16,13,10,15,20,25,30,35,40,45,50,52,54,56,58,60,62,64,64,64,61,58,55,52,49,46,43,40,37,34,31,28,25,22,19,16,13];
spread =3.5;

net_Loc_est = newgrnn(RSSI_input_Vector,Target,spread);
view(net_Loc_est)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5  
 
  %show anchor Locations
    f1 = figure(1);
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    axis([0 100 0 100])
    grid on
    hold on
    
 % Defining veriables
    no_of_positions = 35;     % Total Simulation Period = 35 seconds
    
    
    P = [0.25 0 0  0; 0 0.04 0 0; 0 0 0.02 0; 0 0 0 0.01];   % Initial Process Covariance Matrix
    q=0.1;                                                   %std of process   
    
    %%%%%%%%%%%%%% Initialization of Error Values %%%%%%%%%%%%%%%%%
    RMSE_kf1_x =0 ; RMSE_rssi_x= 0; RMSE_ukf1_x= 0; RMSE_grnn_x = 0;
    RMSE_kf1_y =0 ; RMSE_rssi_y= 0; RMSE_ukf1_y= 0; RMSE_grnn_y = 0;
    RMSE_kf2_x =0 ; RMSE_rssi_x= 0; RMSE_ukf2_x= 0; RMSE_grnn_x = 0;
    RMSE_kf2_y =0 ; RMSE_rssi_y= 0; RMSE_ukf2_y= 0; RMSE_grnn_y = 0;
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
       legend('Anchor Location','Actual Target Location','GRNN+KF based Estimation','GRNN+UKF based Estimation','RSSI+KF based Estimation','RSSI+UKF Based Implementation','Location','SouthEast')
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
        
       RSS_new_vector = RSS.';
       GRNN_Estimated_Loc = sim(net_Loc_est ,RSS_new_vector)
     
       GRNN_x(t)= GRNN_Estimated_Loc(1); 
       GRNN_y(t)= GRNN_Estimated_Loc(2); 
       %plot(GRNN_Estimated_Loc(1),GRNN_Estimated_Loc(2),'g+','LineWidth',2) 
       %hold on
       
       RSS_s = sort(RSS);
      
     disp('RSSI Estimated Location')

       mobileLoc_est = trilateration_4(RSS,RSS_s,Pr0,n,networkSize)
   
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2);          
          
       trad_x(t)=X_T;
       trad_y(t)=Y_T;
       
       %plot(X_T,Y_T,'r+','LineWidth',2)       
       %hold on
       
% calculate velocities in X & Y Directions
       
          velocity_est=velocity(X_T,Y_T,t);
       
          s = [x; y; 0; 0];                                           % State of the system at time 't'
          X = s;                                       % state with noise
                  
% GRNN + Kalman Filter for Tracking Moving Target Code starts here
       [X_kalman1,Y_kalman1,X_kf]= kf(X,P,GRNN_Estimated_Loc(1), GRNN_Estimated_Loc(2), velocity_est,t);       
       kf1_x(t)=X_kalman1;      %Para 3
       kf1_y(t)=Y_kalman1;      %Para 4
       plot(X_kalman1,Y_kalman1,'ko','LineWidth',2)      
       hold on

%GRNN + UKF implementation
      Z = [GRNN_Estimated_Loc(1); GRNN_Estimated_Loc(2); velocity_est(1); velocity_est(2)];
      disp('UKF Estimated State')
      [X_ukf1]= ukf5(X,P,Z)      
      ukf1_x(t)=X_ukf1(1);      %Para 5
      ukf1_y(t)=X_ukf1(2);      %Para 6      
      plot(X_ukf1(1),X_ukf1(2),'mo','LineWidth',2)      
      hold on
      
% Trad. RSSI + Kalman Filter for Tracking Moving Target Code starts here
       [X_kalman2,Y_kalman2,X_kf]= kf(X,P,X_T, Y_T, velocity_est,t);       
       kf2_x(t)=X_kalman2;      %Para 3
       kf2_y(t)=Y_kalman2;      %Para 4
       plot(X_kalman2,Y_kalman2,'g+','LineWidth',2)      
       hold on         
      
%Trad. RSSI + UKF implementation
      Z = [X_T; Y_T; velocity_est(1); velocity_est(2)];
      disp('UKF Estimated State')
      [X_ukf2]= ukf5(X,P,Z)      
      ukf2_x(t)=X_ukf2(1);      %Para 5
      ukf2_y(t)=X_ukf2(2);      %Para 6      
      plot(X_ukf2(1),X_ukf2(2),'b+','LineWidth',2)      
      hold on
      
      
%%%%% Error Analysis of algorithm
% ---> Part 1 : RMSE Analysis
      % RMSE_rssi_x = RMSE_rssi_x + (X_T - x)^2 ;
      % RMSE_rssi_y = RMSE_rssi_y +  (Y_T - y)^2;
      % RMSE_grnn_x = RMSE_grnn_x + (GRNN_Estimated_Loc(1) - x)^2 ;
      % RMSE_grnn_y = RMSE_grnn_y + (GRNN_Estimated_Loc(2) - y)^2;
       RMSE_kf1_x = RMSE_kf1_x + (X_kalman1 - x)^2 ;
       RMSE_kf1_y = RMSE_kf1_y + (Y_kalman1 - y)^2;
       RMSE_kf2_x = RMSE_kf2_x + (X_kalman2 - x)^2 ;
       RMSE_kf2_y = RMSE_kf2_y + (Y_kalman2 - y)^2;
       
       RMSE_ukf1_x = RMSE_ukf1_x + (X_ukf1(1)-x)^2 ;
       RMSE_ukf1_y = RMSE_ukf1_y + (X_ukf1(2)-y)^2; 
       RMSE_ukf2_x = RMSE_ukf2_x + (X_ukf2(1)-x)^2 ;
       RMSE_ukf2_y = RMSE_ukf2_y + (X_ukf2(2)-y)^2; 
       
% ---> Part 2 : Calculation of Absolute Errors 

     % a) For Kalman Filter
       error_x_kf1(t) =  abs((x - X_kalman1));
       error_y_kf1(t) =  abs((y - Y_kalman1));
       error_xy_kf1(t) = ((error_x_kf1(t) + error_y_kf1(t))/2);
       error_x_kf2(t) =  abs((x - X_kalman2));
       error_y_kf2(t) =  abs((y - Y_kalman2));
       error_xy_kf2(t) = ((error_x_kf2(t) + error_y_kf2(t))/2);
       
      
     % b) For Unscented Kalman Filter
       error_x_ukf1(t) = abs((x - X_ukf1(1)));
       error_y_ukf1(t) = abs((y - X_ukf1(2)));
       error_xy_ukf1(t) = ((error_x_ukf1(t) + error_y_ukf1(t))/2);
       error_x_ukf2(t) = abs((x - X_ukf2(1)));
       error_y_ukf2(t) = abs((y - X_ukf2(2)));
       error_xy_ukf2(t) = ((error_x_ukf2(t) + error_y_ukf2(t))/2);
       
       
     % c) For Pure RSSI based Technique
      % error_x_rssi(t) = abs((x - X_T));
      % error_y_rssi(t) = abs((y - Y_T));
      % error_xy_rssi(t) =((error_x_rssi(t) + error_y_rssi(t))/2);
            
     
    % d) For GRNN based Estimation
      % error_x_grnn(t) = abs((x - GRNN_Estimated_Loc(1)));                      
      % error_y_grnn(t) = abs((y - GRNN_Estimated_Loc(2)));
      % error_xy_grnn(t) =((error_x_grnn(t) + error_y_grnn(t))/2);
    
    end
      
    % Average Error in x & y  coordinates
     % avg_error_xy_rssi = 0; avg_error_xy_grnn = 0;
      avg_error_xy_kf1 = 0 ;avg_error_xy_kf2 = 0 ;
      avg_error_xy_ukf1 = 0 ;avg_error_xy_ukf2 = 0 ;
      
    for t = 1:no_of_positions
      %avg_error_xy_rssi=avg_error_xy_rssi + (error_xy_rssi(t)/no_of_positions); 
      %avg_error_xy_grnn=avg_error_xy_grnn + (error_xy_grnn(t)/no_of_positions);
      avg_error_xy_kf1= avg_error_xy_kf1 + (error_xy_kf1(t)/no_of_positions); 
      avg_error_xy_ukf1= avg_error_xy_ukf1 + (error_xy_ukf1(t)/no_of_positions);
      avg_error_xy_kf2= avg_error_xy_kf2 + (error_xy_kf2(t)/no_of_positions); 
      avg_error_xy_ukf2= avg_error_xy_ukf2 + (error_xy_ukf2(t)/no_of_positions);
    end
    
     disp('Average Localization Errors :')
     %avg_error_xy_rssi
     %avg_error_xy_grnn
     avg_error_xy_kf1
     avg_error_xy_ukf1
     avg_error_xy_kf2
     avg_error_xy_ukf2
     
      disp('RMSE Errors :')
    % RMSE_rssi_x = sqrt(RMSE_rssi_x/no_of_positions)
    % RMSE_rssi_y = sqrt(RMSE_rssi_y/no_of_positions)
     %RMSE_grnn_x = sqrt(RMSE_grnn_x/no_of_positions)
     %RMSE_grnn_y = sqrt(RMSE_grnn_y/no_of_positions)
     RMSE_kf1_x = sqrt(RMSE_kf1_x/no_of_positions)
     RMSE_kf1_y = sqrt(RMSE_kf1_y/no_of_positions)
     RMSE_ukf1_x = sqrt(RMSE_ukf1_x/no_of_positions)
     RMSE_ukf1_y = sqrt(RMSE_ukf1_y/no_of_positions)
     RMSE_kf2_x = sqrt(RMSE_kf2_x/no_of_positions)
     RMSE_kf2_y = sqrt(RMSE_kf2_y/no_of_positions)
     RMSE_ukf2_x = sqrt(RMSE_ukf2_x/no_of_positions)
     RMSE_ukf2_y = sqrt(RMSE_ukf2_y/no_of_positions)
     
     % RMSE_rssi_avg = (RMSE_rssi_x + RMSE_rssi_y)/2 
     % RMSE_grnn_avg = (RMSE_grnn_x + RMSE_grnn_y)/2
      RMSE_kf1_avg = (RMSE_kf1_x + RMSE_kf1_y)/2
      RMSE_ukf1_avg = (RMSE_ukf1_x + RMSE_ukf1_y)/2 
      RMSE_kf2_avg = (RMSE_kf2_x + RMSE_kf2_y)/2
      RMSE_ukf2_avg = (RMSE_ukf2_x + RMSE_ukf2_y)/2 
     
% Plotting Absolute Errors of KF & UKF based Tracking

f2 = figure(2);
  for t =1:no_of_positions                   
   
    plot(t,error_x_ukf1(t),'ro','LineWidth',2)
    plot(t,error_x_kf2(t),'g+','LineWidth',2)        
    plot(t,error_x_ukf2(t),'b+','LineWidth',2)     
    plot(t,error_x_kf1(t),'ko','LineWidth',2) 
    
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in x estimates [meter]','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on
    
  end
  legend('Error in GRNN+KF based Estimation','Error in GRNN+UKF based Estimation','Error in RSSI+KF based Estimation','Error in RSSI+UKF based Estimation','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions
           
   
    plot(t,error_y_ukf1(t),'ro','LineWidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')
    plot(t,error_y_kf2(t),'g+','LineWidth',2)      %,'Markersize',2,'MarkerEdgeColor','b')     
    plot(t,error_y_ukf2(t),'b+','LineWidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')
     plot(t,error_y_kf1(t),'ko','LineWidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    xlabel('Time [sec]','FontName','Times','Fontsize',14, 'LineWidth',2) 
    ylabel('Error in y estimates [m]','FontName','Times','Fontsize',14, 'LineWidth',2)    
    hold on
  end
   legend('Error in GRNN+KF based Estimation','Error in GRNN+UKF based Estimation','Error in RSSI+KF based Estimation','Error in RSSI+UKF based Estimation','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions
        
    plot(t,error_xy_ukf1(t),'ro','LineWidth',2)     %,'Markersize',2,'MarkerEdgeColor','r') 
    plot(t,error_xy_kf2(t),'g+','LineWidth',2)      %,'Markersize',2,'MarkerEdgeColor','b')    
    plot(t,error_xy_ukf2(t),'b+','LineWidth',2)     %,'Markersize',2,'MarkerEdgeColor','r')  
     plot(t,error_xy_kf1(t),'ko','LineWidth',2)      %,'Markersize',2,'MarkerEdgeColor','b') 
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in xy estimates [m]','FontName','Times','Fontsize',14,'LineWidth',2)    
    hold on
  end
   legend('Error in GRNN+KF based Estimation','Error in GRNN+UKF based Estimation','Error in RSSI+KF based Estimation','Error in RSSI+UKF based Estimation','Location','NorthWest')
  
  %linearity_test(n,Pr0);
  
  f5 = figure(5);
  for t =1:no_of_positions
      
      if(t<9)                   x_v = 2; y_v = 5;
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
  

