%% WSN Deployment Setting Parameters    
    clear all
    close all
    clc
    
  %%%% Compare Phase I: Trilateration, 4 I/P GRNN, 3 I/P SVR 
  %            Phase II: 3 I/P SVR, GRNN+SVR, SVR+KF, GRNN+SVR+KF
  %            Phase III: Variance= 1, 2, 3
  
    networkSize = 100;                                % we consider a 100by100 area that the mobile can wander              
        anchorLoc   = [14 8;
                       25 30;
                       35 45;
                       37 80;
                       50 65;
                       70 70;
                       62 42;
                       85 70;
                       92 40;
                       68 18;
                       59 80;
                       48 50;
                       32 41;
                       10 40;
                       67 32];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5  
 
  %show anchor Locations
    f1 = figure(1);
    plot(anchorLoc(:,1),anchorLoc(:,2),'ko','MarkerSize',8,'lineWidth',2,'MarkerFaceColor','k');
    axis([-5 105 -3 105])
    grid on
    hold on
    
 % Defining veriables
    no_of_positions = 35;     % Total Simulation Period = 35 seconds
        
    P = [0.25 0 0  0; 0 0.04 0 0; 0 0 0.02 0; 0 0 0 0.01];   % Initial Process Covariance Matrix
    q=0.1;                                                   %std of process   
            
    %%%%%%%%%%%%%% Initialization of Error Values %%%%%%%%%%%%%%%%%
    RMSE_Trilateration_x= 0; RMSE_Trilateration_y= 0; 
    RMSE_SVR_x = 0; RMSE_SVR_y = 0;      
    RMSE_kf_x =0; RMSE_kf_y =0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%% Offline Training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A] SVR
RSSI_Input= [7.38100767982368,0.309820663503201,-4.97466098008930,-7.42610239976332,-10.7468224319073,-14.7114867969291,-16.7566754808822,-17.7717484872184,-19.9443759753592,-19.3479189834253,-21.7477990790755,-25.4783392509730,-25.0337091189613,-26.3502949570692,-24.9786476043989,-23.8844167478204,-24.3898934688452,-24.3491631287550,-25.8303851824617,-25.4028862921194,-22.9751811977251,-26.0454511074267,-23.5800403094728,-24.5033324783636,-25.5142069493801,-25.7516144995722,-24.5550322117214,-24.5599280411356,-25.4767746019730,-27.8559234620760,-25.8491873148392,-26.2829317043190,-27.1024961850306,-27.4497209260151,-27.2211386043045;-6.77366577459188,-0.736915485972453,1.95574104609839,9.50478585665959,7.83363261648933,2.68942768538065,-2.90708074304278,-5.38416898119722,-8.89573833687509,-10.6668399271217,-11.7784239631309,-14.0637319716277,-15.3497790479310,-17.8693606093839,-20.3779099274531,-18.3725202487813,-20.5772005987087,-20.3689019717547,-19.0417864473523,-17.5361247824540,-18.2180893164981,-18.5391644632862,-20.1664851119702,-20.1951779505893,-22.3424869682197,-21.9609861309284,-22.8678608335448,-21.5871158094225,-21.1759147980203,-23.8456776677890,-23.2756056652532,-23.9038754525550,-25.4142781592473,-25.9288302259142,-26.8045523032821;-16.3446564510222,-11.8210053319925,-11.4317338740280,-8.55057411953922,-5.80008923513967,-1.99074216897610,3.04696331865026,4.19220555538837,7.43102465523154,6.14396047281500,1.85849255405713,-4.91170185483260,-7.49077172038227,-11.7045560437537,-13.4769691526009,-13.8003944880032,-13.3443947530891,-13.8628122284491,-13.2885597362099,-12.3123753975580,-13.9664642331273,-13.6404500510627,-16.4045380658520,-16.0257643218332,-15.7709731511495,-17.8353129823873,-18.8243110945123,-19.5628105859867,-20.8645173862991,-21.6661658602209,-22.5906716787324,-22.2334639698276,-24.1621061354337,-23.4329500620539,-24.2602030173258];
TargetX= [10,12,14,16,18,20,22,24,26,31,36,41,46,51,56,61,61,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95];
Mdl = fitrsvm(RSSI_Input',TargetX','KernelFunction','linear')   
TargetY= [10,15,20,25,30,35,40,45,50,52,54,56,58,60,62,64,64,64,61,58,55,52,49,46,43,40,37,34,31,28,25,22,19,16,13];
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
       if(t<9)                 x_v = 2; y_v = 5;
       elseif(t==9 && t<15)    x_v = 5; y_v = 2;
       elseif(t>=16 && t<17)   x_v = 0; y_v = 0;
       elseif(t>=18 && t<=35)  x_v = 2; y_v = -3;             
       end
       
       x_actual(t)=x;        %  para 1
       y_actual(t)=y;        %  para 1
       
       x=x+x_v;
       y=y+y_v;
       
       disp('Actual Traget Location')
       [x,y]                                           % Actual Target Location
       plot(x,y,'gs','LineWidth',2)
       
       ylabel('y-Axis[meter]','FontName','Times','Fontsize',14,'LineWidth',2);
       xlabel('x-Axis[meter]','FontName','Times','Fontsize',14,'LineWidth',2);
       legend('Anchor Location','Actual Target Location','Trilateration based Estimation','SVR based Estimation','SVR+KF based Estimation','Location','SouthEast')
       hold on
       
% Actual Distances from Anchors required to generate RSSI Values
       d1 = sqrt( (14-x)^2 + (8-y)^2);
       d2 = sqrt( (25-x)^2 + (30-y)^2);
       d3 = sqrt( (35-x)^2 + (45-y)^2);
       d4 = sqrt( (37-x)^2 + (80-y)^2);
       d5 = sqrt( (50-x)^2 + (65-y)^2);
       d6 = sqrt( (70-x)^2 + (70-y)^2);
       d7 = sqrt( (62-x)^2 + (42-y)^2);
       d8 = sqrt( (85-x)^2 + (70-y)^2);
       d9 = sqrt( (92-x)^2 + (40-y)^2);
       d10 = sqrt( (68-x)^2 + (18-y)^2);
       d11 = sqrt( (59-x)^2 + (80-y)^2);
       d12 = sqrt( (48-x)^2 + (50-y)^2);
       d13 = sqrt( (32-x)^2 + (41-y)^2);
       d14 = sqrt( (10-x)^2 + (40-y)^2);
       d15 = sqrt( (67-x)^2 + (32-y)^2);    
       
% Generate RSSI Values at 4 Anchor Nodes which are at d1, d2, d3 & d4 distances respectively from Moving Target     
       % Use  RSSI = - (10*n*log10(d) + A)  and  d= antilog(-(RSSI + A)/(10*n))
          
       RSS = lognormalshadowing(n,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,Pr0);
       
       RSS_1(t)= RSS(1);
       RSS_2(t)= RSS(2);
       RSS_3(t)= RSS(3);                        
       RSS_4(t)= RSS(4);
       RSS_5(t)= RSS(5);
       RSS_6(t)= RSS(6);
       RSS_7(t)= RSS(7);                        
       RSS_8(t)= RSS(8);
       RSS_9(t)= RSS(9);
       RSS_10(t)= RSS(10);
       RSS_11(t)= RSS(11);                        
       RSS_12(t)= RSS(12);
       RSS_13(t)= RSS(13);
       RSS_14(t)= RSS(14);                        
       RSS_15(t)= RSS(15);
         
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
       
       RSS_new_vector1 = [RSS(1) RSS(2) RSS(3)];         
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
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in x estimates [meter]','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on    
  end
  legend('Error in Trilateration based Estimation','Error in SVR based Estimation','Error in SVR+KF based Estimation','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions  
          
    plot(t,error_y_SVR(t),'k+','LineWidth',2) 
    plot(t,error_y_kfG(t),'r+','LineWidth',2)    
    plot(t,error_y_Trilateration(t),'bo','LineWidth',2)
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in y estimates [meter]','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on    
  end
 legend('Error in Trilateration based Estimation','Error in SVR based Estimation','Error in SVR+KF based Estimation','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions     
         
    plot(t,error_xy_SVR(t),'k+','LineWidth',2) 
    plot(t,error_xy_kfG(t),'r+','LineWidth',2)   
    plot(t,error_xy_Trilateration(t),'bo','LineWidth',2) 
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in x-y estimates [meter]','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on    
  end
 legend('Error in Trilateration based Estimation','Error in SVR based Estimation','Error in SVR+KF based Estimation','Location','NorthWest')
  
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
 plotregression(x_actual, Trilateration_x,'Regression using Trilateration', x_actual,SVR_x,'Regression using SVR')
 
 f8 = figure(8);
 plotregression(y_actual, Trilateration_y,'Regression using Trilateration',y_actual,SVR_y,'Regression using SVR')
 
 