%% WSN Deployment Setting Parameters    
    clear all
    close all
    clc
    
  %%%% Compare Phase I: Comparison of Trilateration, 4 I/P GRNN, 3 I/P SVR 
  %            Phase II: Comparison of Trilateration, 3 I/P SVR, SVR+KF (02 Tracks)
  
    networkSize = 100;                                % we consider a 100by100 area that the mobile can wander              
        anchorLoc   = [30 25;
                       10 60;
                       50 50;
                       30 90;
                       80 60;
                       70 90];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5  
 
  %show anchor Locations
    f1 = figure(1);
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    axis([-5 105 -3 105])
    grid on
    hold on
    
 % Defining veriables
    no_of_positions = 40;     % Total Simulation Period = 35 seconds
        
    P = [0.25 0 0  0; 0 0.04 0 0; 0 0 0.02 0; 0 0 0 0.01];   % Initial Process Covariance Matrix
    q=0.1;                                                   %std of process   
            
    %%%%%%%%%%%%%% Initialization of Error Values %%%%%%%%%%%%%%%%%
    RMSE_Trilateration_x= 0; RMSE_Trilateration_y= 0; 
    RMSE_SVR_x = 0; RMSE_SVR_y = 0; RMSE_grnn_x = 0; RMSE_grnn_y = 0;      
    RMSE_kf_x =0; RMSE_kf_y =0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%% Offline Training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A] 3 I/P SVR
RSSI_Input= [-5.44456911431004,-3.08201583824825,1.16955635649634,-0.545902486985023,-2.69978848452225,-2.22604954780853,-7.59680633727302,-7.75445406623096,-13.6860805776613,-15.2087661806412,-16.3047266832176,-19.7258261316726,-19.4972570389952,-22.5919208303673,-23.6883404522653,-22.2918835169782,-21.3384533523634,-22.1468279053855,-17.7150069757340,-18.2112136891646,-17.6259788579539,-17.8191684792814,-18.6071762853271,-16.1455726625226,-19.0633121821899,-22.1212073914273,-21.4949369741028,-21.6986334535170,-22.5321153607937,-22.2479776008480,-23.8765243389814,-23.9128876771843,-24.2859697841009,-24.3600615631486,-26.1047515585853,-24.9469060188932,-24.1198131342919,-26.1193070225268,-26.0192277493758,-29.0778772380685;-16.9174371349992,-15.7739798063551,-14.9792869727329,-12.9920288939645,-11.0977552848067,-9.10176360440646,-5.54145369385221,-5.69497394237543,-3.76668831730977,-7.41259722886094,-7.10181541497230,-10.2822389693830,-9.88477322938202,-16.7878104751766,-16.1773173903600,-15.4187327374285,-14.9303409621525,-15.2588101642827,-16.7911757718198,-15.3874256436462,-17.0047181779088,-16.1438252318594,-18.7408731741243,-18.1862134920633,-19.8709854207428,-20.8929508521657,-19.7294217309479,-21.6796688907812,-22.1560545170119,-23.6081124078182,-22.2912904545995,-23.6165394728185,-22.2367034322090,-23.2328456619132,-26.2053825444666,-24.3880550543640,-26.7237666213754,-26.6843852817284,-26.4592987240513,-28.0331999658076;-27.0964894826919,-26.7467545594712,-24.8453216527700,-24.0211707474059,-24.1289176801945,-22.4253954878664,-21.7790371690566,-21.1922617282004,-20.4969136930850,-20.6183935200397,-19.6795172761132,-20.1466473065832,-18.6778411870672,-21.2113401361958,-18.4529820873446,-14.6856283096601,-14.3332476417221,-16.2266567601460,-14.1844539012141,-13.7245447515995,-14.1303509885877,-11.3198757248423,-10.4321563381444,-8.74320960078690,-9.23882203242050,-9.19667430050632,-6.81017311584398,-6.25987950965550,-5.03207874078778,-4.06954112572321,-4.38972621643337,-3.63678304974223,-2.64909991619085,-4.17967905898124,-3.77295398141674,-4.67621485863568,-7.56847391681801,-5.71296487954554,-7.49692081012994,-8.90411305273960];
TargetX= [10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,43,44,45,46,47,48,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85];
Mdl = fitrsvm(RSSI_Input',TargetX','KernelFunction','linear')   
TargetY= [10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,81,78,75,72,69,66,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81];
Md2 = fitrsvm(RSSI_Input',TargetY','KernelFunction','linear')
%'linear' (default) | 'gaussian' | 'rbf' | 'polynomial' | function name

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
       if(t<15)                 x_v = 2; y_v = 5;
       elseif(t==15 && t<=20)   x_v = 5; y_v = 1;
       elseif(t<=21 && t<=30)   x_v = 1; y_v = -3;  
       elseif(t<=31 && t<=40)   x_v = 2; y_v = 1;      
       end
       
       x_actual(t)=x;        %  para 1
       y_actual(t)=y;        %  para 1
       
       x=x+x_v;
       y=y+y_v;
       
       disp('Actual Traget Location')
       [x,y]                                           % Actual Target Location
       plot(x,y,'rs','LineWidth',2)
       
       ylabel('y-Axis[m]','FontName','Times','Fontsize',14,'LineWidth',2);
       xlabel('x-Axis[m]','FontName','Times','Fontsize',14,'LineWidth',2);
       legend('Anchor Location','Actual Target Location','Trilateration based Estimation','SVR based Estimation','SVR+KF based Estimation','Location','SouthEast')
       hold on
       
% Actual Distances from Anchors required to generate RSSI Values
       d1 = sqrt( (30-x)^2 + (25-y)^2);
       d2 = sqrt( (10-x)^2 + (60-y)^2);
       d3 = sqrt( (50-x)^2 + (50-y)^2);
       d4 = sqrt( (30-x)^2 + (90-y)^2);
       d5 = sqrt( (80-x)^2 + (60-y)^2);
       d6 = sqrt( (70-x)^2 + (90-y)^2);
          
       
% Generate RSSI Values at 4 Anchor Nodes which are at d1, d2, d3 & d4 distances respectively from Moving Target     
       % Use  RSSI = - (10*n*log10(d) + A)  and  d= antilog(-(RSSI + A)/(10*n))
          
       RSS = lognormalshadowing(n,d1,d2,d3,d4,d5,d6,Pr0);
       
       RSS_1(t)= RSS(1);
       RSS_2(t)= RSS(2);
       RSS_3(t)= RSS(3);                        
       RSS_4(t)= RSS(4);
       RSS_5(t)= RSS(5);
       RSS_6(t)= RSS(6);       
         
       RSS_s = sort(RSS);
       disp('Trilateration Estimated Location')
       [mobileLoc_est, X, Y] = trilateration(RSS,RSS_s,Pr0,n,networkSize);
   
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2); 
       Trilateration_estmation= [X_T Y_T]       
       Trilateration_x(t)=X_T;
       Trilateration_y(t)=Y_T;
       plot(X_T,Y_T,'bo','LineWidth',2)       
       hold on  
                   
       RSS_new_vector1 = [RSS(1) RSS(2) RSS(5)];         
       SVMX = predict(Mdl,RSS_new_vector1)       
       SVMY = predict(Md2,RSS_new_vector1)
       SVR_Estimated_Loc = [SVMX SVMY];
       SVR_x(t)= SVR_Estimated_Loc(1); 
       SVR_y(t)= SVR_Estimated_Loc(2); 
       plot(SVR_Estimated_Loc(1),SVR_Estimated_Loc(2),'k+','LineWidth',2)        
       hold on                  
       
% calculate velocities in X & Y Directions
       
      velocity_est= velocity(X_T,Y_T,t);       
      s = [x; y; 0; 0];                                           % State of the system at time 't'
      X = s;                                       % state with noise                 
      hold on
      
      % Kalman Filter for Tracking Moving Target Code starts here
       [X_kalmanG,Y_kalmanG,X_kf]= kf(X,P,SVR_Estimated_Loc(1), SVR_Estimated_Loc(2), velocity_est,t);       
       kf1_x(t)=X_kalmanG;      %Para 3
       kf1_y(t)=Y_kalmanG;      %Para 4        
       plot(X_kalmanG,Y_kalmanG,'r+','LineWidth',2)      
       hold on
       
      % Error Analysis of algorithm
% ---> Part 1 : RMSE Analysis
       RMSE_Trilateration_x = RMSE_Trilateration_x + (X_T - x)^2 ;
       RMSE_Trilateration_y = RMSE_Trilateration_y +  (Y_T - y)^2;                                 
       RMSE_SVR_x = RMSE_SVR_x + (SVR_Estimated_Loc(1) - x)^2 ;
       RMSE_SVR_y = RMSE_SVR_y + (SVR_Estimated_Loc(2) - y)^2;       
       RMSE_kfG_x = RMSE_kf_x + (X_kalmanG - x)^2 ;
       RMSE_kfG_y = RMSE_kf_y + (Y_kalmanG - y)^2;
       
% ---> Part 2 : Calculation of Absolute Errors 
     
     % a) For Trilateration based Technique
       error_x_Trilateration(t) = abs((x - X_T));
       error_y_Trilateration(t) = abs((y - Y_T));
       error_xy_Trilateration(t) =((error_x_Trilateration(t) + error_y_Trilateration(t))/2);           
            
     % b) For CGRNN based Estimation
       error_x_SVR(t) = abs((x - SVR_Estimated_Loc(1)));                      
       error_y_SVR(t) = abs((y - SVR_Estimated_Loc(2)));
       error_xy_SVR(t) =((error_x_SVR(t) + error_y_SVR(t))/2);          
       
     % c) For SVR-GRNN+Kalman Filter
       error_x_kfG(t) =  abs((x - X_kalmanG));
       error_y_kfG(t) =  abs((y - Y_kalmanG));
       error_xy_kfG(t) = ((error_x_kfG(t) + error_y_kfG(t))/2);            
    end
      
    % Average Error in x & y  coordinates
      avg_error_xy_Trilateration = 0; avg_error_xy_SVR = 0; avg_error_xy_kfG = 0;   
      
    for t = 1:no_of_positions
      avg_error_xy_Trilateration=avg_error_xy_Trilateration + (error_xy_Trilateration(t)/no_of_positions);           
      avg_error_xy_SVR=avg_error_xy_SVR + (error_xy_SVR(t)/no_of_positions);      
      avg_error_xy_kfG= avg_error_xy_kfG + (error_xy_kfG(t)/no_of_positions); 
    end
    
     disp('Average Localization Errors :')
     avg_error_xy_Trilateration          
     avg_error_xy_SVR    
     avg_error_xy_kfG
     
     disp('RMSE Errors :')
     RMSE_Trilateration_x = sqrt(RMSE_Trilateration_x/no_of_positions)
     RMSE_Trilateration_y = sqrt(RMSE_Trilateration_y/no_of_positions)          
     RMSE_Trilateration_avg = (RMSE_Trilateration_x + RMSE_Trilateration_y)/2                 
  
     RMSE_SVR_x = sqrt(RMSE_SVR_x/no_of_positions)
     RMSE_SVR_y = sqrt(RMSE_SVR_y/no_of_positions)
     RMSE_SVR_avg = (RMSE_SVR_x + RMSE_SVR_y)/2       

     RMSE_kfG_x = sqrt(RMSE_kfG_x/no_of_positions)
     RMSE_kfG_y = sqrt(RMSE_kfG_y/no_of_positions)
     RMSE_kfG_avg= (RMSE_kfG_x + RMSE_kfG_y)/2
     
% Plotting Absolute Errors of KF & UKF based Tracking

f2 = figure(2);
  for t =1:no_of_positions  
           
    plot(t,error_x_SVR(t),'k+','LineWidth',2) 
    plot(t,error_x_kfG(t),'r+','LineWidth',2)  
    plot(t,error_x_Trilateration(t),'bo','LineWidth',2)
    xlabel('Time [sec]','FontName','Times','Fontsize',13,'LineWidth',2) 
    ylabel('coordinate differences in the direction of the x-axis [m]','FontName','Times','Fontsize',12,'LineWidth',2)
    hold on    
  end
  legend('Error in Trilateration based Estimation','Error in SVR based Estimation','Error in SVR+KF based Estimation','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions  
        
    plot(t,error_y_SVR(t),'k+','LineWidth',2) 
    plot(t,error_y_kfG(t),'r+','LineWidth',2)    
    plot(t,error_y_Trilateration(t),'bo','LineWidth',2)
    xlabel('Time [sec]','FontName','Times','Fontsize',13,'LineWidth',2) 
    ylabel('coordinate differences in the direction of the y-axis [m]','FontName','Times','Fontsize',12,'LineWidth',2)
    hold on    
  end
 legend('Error in Trilateration based Estimation','Error in SVR based Estimation','Error in SVR+KF based Estimation','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions     
        
    plot(t,error_xy_SVR(t),'k+','LineWidth',2) 
    plot(t,error_xy_kfG(t),'r+','LineWidth',2)   
    plot(t,error_xy_Trilateration(t),'bo','LineWidth',2) 
    xlabel('Time [sec]','FontName','Times','Fontsize',13,'LineWidth',2) 
    ylabel('coordinate differences in the direction of the X-Y axis [m]','FontName','Times','Fontsize',12,'LineWidth',2)
    hold on    
  end
 legend('Error in Trilateration based Estimation','Error in SVR based Estimation','Error in SVR+KF based Estimation','Location','NorthWest')
        
f5 = figure(5);
 plotregression(x_actual, kf1_x,'Regression using SVR+KF', x_actual,SVR_x,'Regression using SVR')
 
 f6 = figure(6);
 plotregression(y_actual, kf1_y,'Regression using SVR+KF',y_actual,SVR_y,'Regression using SVR')
 
 