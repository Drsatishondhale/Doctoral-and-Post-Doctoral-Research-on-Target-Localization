%% WSN Deployment Setting Parameters    
    clear all
    close all
    clc
    
   
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
    axis([0 100 0 100])
    ylabel('y-Axis[meter]','FontName','Times','Fontsize',14,'LineWidth',2);
    xlabel('x-Axis[meter]','FontName','Times','Fontsize',14,'LineWidth',2);
    title('Deployment of Sensor Nodes');
    grid on
    hold on
    
 % Defining veriables
    no_of_positions = 35;     % Total Simulation Period = 35 seconds
            
    %%%%%%%%%%%%%% Initialization of Error Values %%%%%%%%%%%%%%%%%
    RMSE_Trilateration_x= 0; RMSE_Trilateration_y= 0; 
    RMSE_TCgrnn_x = 0; RMSE_TCgrnn_y = 0; 
    RMSE_grnn_x = 0; RMSE_grnn_y = 0; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%% GRNN Setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%A] CGRNN
RSSI_input_Vector = [8.76558350652731,3.96046911504643,-5.59171440388472,-4.86601824135280,-13.5566547554405,-12.2797197549321,-15.1961650778134,-17.6713847850625,-18.6719274586280,-14.0824322450019,-18.1052125569739,-22.1721132740668,-21.4076569435291,-23.2619411820108,-29.7687638926797,-21.1094158588126,-22.5781120491769,-22.1401940631365,-23.9402381565469,-22.4615637937720,-26.5682729575639,-20.7377367385953,-31.4935144095119,-26.1445707178393,-30.0652494402658,-23.7835249340363,-27.5594393201912,-27.6936547020984,-24.4537780046951,-26.7617839256805,-25.2577325948272,-27.6752586302355,-29.0463569135220,-26.7456349931601,-26.6915791397593;0.492431561192975,-2.80983843325883,6.44638481758273,13.6138706068819,10.6496198440745,7.55881362137724,0.350218281853733,-4.51854434103059,-5.88167680198493,-17.4898199676894,-9.09102497303473,-10.6119828127727,-14.7827171899899,-17.1124468192308,-22.7649886061886,-13.5715081042591,-21.4273450142415,-21.8250134924876,-16.7244884575361,-25.0880009379562,-22.3600997382893,-19.9849003628413,-21.7544118907874,-21.8599150905193,-22.0627123148049,-22.6408442449938,-25.7602626718495,-24.1452333175296,-26.0403270810572,-25.1934490715899,-23.6245707337430,-27.3371221196763,-27.9148964046215,-27.7616189562606,-22.5164458109928;-15.9328935488549,-10.4680040620530,-12.6282237634905,-8.01456225913532,-4.80653797455175,-0.877206724822372,3.18818891331796,-0.555857231036930,7.14181505637304,3.89893105662949,0.780192388154213,-4.56018968762180,-11.0265950267487,-9.70588166624938,-13.9917539415743,-12.9904505775541,-10.9220361566966,-16.1823137378647,-18.3943088155281,-14.5701551246503,-12.5052021920662,-13.7462191077444,-15.1656748447466,-12.8804436815712,-17.6411518011176,-17.9071691393642,-20.2010998999879,-16.0207574029435,-20.5555982457265,-18.9685501122483,-21.1415049935329,-21.0443640431948,-22.0549505296436,-25.4736972871393,-24.6554667076574;-26.2921077967440,-24.6140836625716,-21.7536053376397,-15.6247034359231,-22.7594714938599,-17.6793489440180,-12.9026753575713,-12.1940827862496,-11.3348371538268,-14.1606325161388,-13.0678693005440,-9.26062985843250,-13.8506335216680,-12.4704493303647,-12.6977392059391,-14.6914006775212,-11.2019537493613,-17.1592126952577,-12.8558886655808,-15.3953701494308,-19.6692841497955,-19.7240743262164,-16.8945055031655,-18.9073237301769,-27.6683028458830,-19.0020328393922,-21.8627924812713,-26.6728647493198,-26.3592171202036,-27.8184276042296,-15.8484554165846,-28.0447938533737,-28.9976717184478,-28.8614611822963,-22.0361340536214;23.6666666666667,16.3333333333333,16.3333333333333,22.3333333333333,22.3333333333333,22.3333333333333,30.6666666666667,30.6666666666667,38.3333333333333,38.3333333333333,44.3333333333333,52.3333333333333,52.3333333333333,56,59.6666666666667,59.6666666666667,56,56,56,60.6666666666667,60.6666666666667,73.6666666666667,73.6666666666667,73.6666666666667,73.6666666666667,73.6666666666667,75.6666666666667,73.6666666666667,75.6666666666667,75.6666666666667,74,75.6666666666667,75.6666666666667,74,75.6666666666667;26.3333333333333,26,26,37,37,37,38.6666666666667,38.6666666666667,45.3333333333333,45.3333333333333,53.3333333333333,65,65,61.6666666666667,71.6666666666667,71.6666666666667,61.6666666666667,61.6666666666667,61.6666666666667,59,59,38,38,38,38,38,30,38,30,30,33.3333333333333,30,30,33.3333333333333,30;44.5664926214212,13.7941662119955,15.2071322153259,22.0479723315338,20.0791397309116,20.6131553783909,62.4071820251595,152.451773844237,33.2057396597448,40.9893749532563,40.9106464051756,77.0001464477591,63.3308631203055,53.1135990465301,58.7670127968531,58.7460560370790,60.2859698033491,64.8631633624051,60.8449106558535,71.0548482387713,68.4930333854013,70.5646747386538,69.6846704037439,80.2381468635468,76.0432085093699,81.3906974333970,82.9537113426815,78.7483136888787,84.9426778620543,83.3132096794945,77.4133657164849,85.9582591072258,95.9544844653735,77.2118031999156,91.0265845851266;4.02327271243347,18.4530945142894,27.7824240794638,27.2471571757685,36.1551273043996,37.0220502420108,17.6240598432178,-39.7900677205954,48.1813099046196,39.8978231749438,55.3260344833312,52.4405404874947,57.2774097679744,66.9536924809783,63.2280708523986,65.1469751174512,62.3530268472274,58.9685123215505,62.0652033577163,54.6779582670198,54.2153720885086,60.6230158250482,47.5329550559536,33.3455393735263,47.9273262048350,43.8482899910739,31.1347157539383,40.7760224922562,25.0874105096078,31.7171787420403,25.5761516918297,35.3733871742822,7.48197866128344,46.8669041723313,15.3663801712934];
Target = [10,12,14,16,18,20,22,24,26,31,36,41,46,51,56,61,61,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95;10,15,20,25,30,35,40,45,50,52,54,56,58,60,62,64,64,64,61,58,55,52,49,46,43,40,37,34,31,28,25,22,19,16,13];
spread =3.5;
Loc_est_TCGRNN = newgrnn(RSSI_input_Vector,Target,spread);
view(Loc_est_TCGRNN)                      
    
%B] GRNN
RSSI_input_Vector1 = [8.76558350652731,3.96046911504643,-5.59171440388472,-4.86601824135280,-13.5566547554405,-12.2797197549321,-15.1961650778134,-17.6713847850625,-18.6719274586280,-14.0824322450019,-18.1052125569739,-22.1721132740668,-21.4076569435291,-23.2619411820108,-29.7687638926797,-21.1094158588126,-22.5781120491769,-22.1401940631365,-23.9402381565469,-22.4615637937720,-26.5682729575639,-20.7377367385953,-31.4935144095119,-26.1445707178393,-30.0652494402658,-23.7835249340363,-27.5594393201912,-27.6936547020984,-24.4537780046951,-26.7617839256805,-25.2577325948272,-27.6752586302355,-29.0463569135220,-26.7456349931601,-26.6915791397593;0.492431561192975,-2.80983843325883,6.44638481758273,13.6138706068819,10.6496198440745,7.55881362137724,0.350218281853733,-4.51854434103059,-5.88167680198493,-17.4898199676894,-9.09102497303473,-10.6119828127727,-14.7827171899899,-17.1124468192308,-22.7649886061886,-13.5715081042591,-21.4273450142415,-21.8250134924876,-16.7244884575361,-25.0880009379562,-22.3600997382893,-19.9849003628413,-21.7544118907874,-21.8599150905193,-22.0627123148049,-22.6408442449938,-25.7602626718495,-24.1452333175296,-26.0403270810572,-25.1934490715899,-23.6245707337430,-27.3371221196763,-27.9148964046215,-27.7616189562606,-22.5164458109928;-15.9328935488549,-10.4680040620530,-12.6282237634905,-8.01456225913532,-4.80653797455175,-0.877206724822372,3.18818891331796,-0.555857231036930,7.14181505637304,3.89893105662949,0.780192388154213,-4.56018968762180,-11.0265950267487,-9.70588166624938,-13.9917539415743,-12.9904505775541,-10.9220361566966,-16.1823137378647,-18.3943088155281,-14.5701551246503,-12.5052021920662,-13.7462191077444,-15.1656748447466,-12.8804436815712,-17.6411518011176,-17.9071691393642,-20.2010998999879,-16.0207574029435,-20.5555982457265,-18.9685501122483,-21.1415049935329,-21.0443640431948,-22.0549505296436,-25.4736972871393,-24.6554667076574;-26.2921077967440,-24.6140836625716,-21.7536053376397,-15.6247034359231,-22.7594714938599,-17.6793489440180,-12.9026753575713,-12.1940827862496,-11.3348371538268,-14.1606325161388,-13.0678693005440,-9.26062985843250,-13.8506335216680,-12.4704493303647,-12.6977392059391,-14.6914006775212,-11.2019537493613,-17.1592126952577,-12.8558886655808,-15.3953701494308,-19.6692841497955,-19.7240743262164,-16.8945055031655,-18.9073237301769,-27.6683028458830,-19.0020328393922,-21.8627924812713,-26.6728647493198,-26.3592171202036,-27.8184276042296,-15.8484554165846,-28.0447938533737,-28.9976717184478,-28.8614611822963,-22.0361340536214];
Target = [10,12,14,16,18,20,22,24,26,31,36,41,46,51,56,61,61,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95;10,15,20,25,30,35,40,45,50,52,54,56,58,60,62,64,64,64,61,58,55,52,49,46,43,40,37,34,31,28,25,22,19,16,13];
spread =3.5;
Loc_est_GRNN = newgrnn(RSSI_input_Vector1,Target,spread);
view(Loc_est_GRNN) 

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
       end
       
       x_actual(t)=x;        %  para 1
       y_actual(t)=y;        %  para 1
       
       x=x+x_v;
       y=y+y_v;
       
       disp('Actual Target Location')
       [x,y]                                           % Actual Target Location
       hplot(x,y,'rs','LineWidth',2)
       
       ylabel('y-Axis[meter]','FontName','Times','Fontsize',14,'LineWidth',2);
       xlabel('x-Axis[meter]','FontName','Times','Fontsize',14,'LineWidth',2);
       legend('Anchor Location','Actual Target Location','Trilateration based Estimation','GRNN based Estimation','TCGRNN based Estimation','Location','SouthEast')
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
       disp('Trilateration Estimated Location and centroid')
       [mobileLoc_est, X, Y] = trilateration(RSS,RSS_s,Pr0,n,networkSize);
   
       X_T = mobileLoc_est(1);
       Y_T = mobileLoc_est(2); 
       Trilateration_estmation= [X_T Y_T]
       Centroid= [X Y]   
       Centroid_1(t)= X;
       Centroid_2(t)= Y;
       
       Trilateration_x(t)=X_T;
       Trilateration_y(t)=Y_T;
       plot(X_T,Y_T,'b+','LineWidth',2)       
       hold on
       
       RSS_new_vector1 = [RSS(1) RSS(2) RSS(3) RSS(4) X Y X_T Y_T]';  
       TCGRNN_Estimated_Loc = sim(Loc_est_TCGRNN, RSS_new_vector1)
     
       TCGRNN_x(t)= TCGRNN_Estimated_Loc(1); 
       TCGRNN_y(t)= TCGRNN_Estimated_Loc(2); 
       plot(TCGRNN_Estimated_Loc(1),TCGRNN_Estimated_Loc(2),'g+','LineWidth',2) 
       hold on
       
       RSS_new_vector2 = [RSS(1) RSS(2) RSS(3) RSS(4)]';  
       GRNN_Estimated_Loc = sim(Loc_est_GRNN, RSS_new_vector2)
     
       GRNN_x(t)= GRNN_Estimated_Loc(1); 
       GRNN_y(t)= GRNN_Estimated_Loc(2); 
       plot(GRNN_Estimated_Loc(1),GRNN_Estimated_Loc(2),'k+','LineWidth',2) 
       hold on
       
% calculate velocities in X & Y Directions
       
          velocity_est= velocity(X_T,Y_T,t);       
          s = [x; y; 0; 0];                                           % State of the system at time 't'
          X = s;                                       % state with noise                 
      hold on
      
      % Error Analysis of algorithm
% ---> Part 1 : RMSE Analysis
       RMSE_Trilateration_x = RMSE_Trilateration_x + (X_T - x)^2 ;
       RMSE_Trilateration_y = RMSE_Trilateration_y +  (Y_T - y)^2;                   
       RMSE_TCgrnn_x = RMSE_TCgrnn_x + (TCGRNN_Estimated_Loc(1) - x)^2 ;
       RMSE_TCgrnn_y = RMSE_TCgrnn_y + (TCGRNN_Estimated_Loc(2) - y)^2;
       RMSE_grnn_x = RMSE_grnn_x + (GRNN_Estimated_Loc(1) - x)^2 ;
       RMSE_grnn_y = RMSE_grnn_y + (GRNN_Estimated_Loc(2) - y)^2;
       
% ---> Part 2 : Calculation of Absolute Errors 
     
     % a) For Trilateration based Technique
       error_x_Trilateration(t) = abs((x - X_T));
       error_y_Trilateration(t) = abs((y - Y_T));
       error_xy_Trilateration(t) =((error_x_Trilateration(t) + error_y_Trilateration(t))/2);
       
     % b) For TCGRNN based Estimation
       error_x_TCgrnn(t) = abs((x - TCGRNN_Estimated_Loc(1)));                      
       error_y_TCgrnn(t) = abs((y - TCGRNN_Estimated_Loc(2)));
       error_xy_TCgrnn(t) =((error_x_TCgrnn(t) + error_y_TCgrnn(t))/2);
       
     % c) For GRNN based Estimation
       error_x_grnn(t) = abs((x - GRNN_Estimated_Loc(1)));                      
       error_y_grnn(t) = abs((y - GRNN_Estimated_Loc(2)));
       error_xy_grnn(t) =((error_x_grnn(t) + error_y_grnn(t))/2);
    end
      
    % Average Error in x & y  coordinates
      avg_error_xy_Trilateration = 0; avg_error_xy_TCgrnn = 0; avg_error_xy_grnn = 0;
      
    for t = 1:no_of_positions
      avg_error_xy_Trilateration=avg_error_xy_Trilateration + (error_xy_Trilateration(t)/no_of_positions);
      avg_error_xy_TCgrnn=avg_error_xy_TCgrnn + (error_xy_TCgrnn(t)/no_of_positions);
      avg_error_xy_grnn=avg_error_xy_grnn + (error_xy_grnn(t)/no_of_positions);
    end
    
     disp('Average Localization Errors :')
     avg_error_xy_Trilateration
     avg_error_xy_TCgrnn
     avg_error_xy_grnn
     
     disp('RMSE Errors :')
     RMSE_Trilateration_x = sqrt(RMSE_Trilateration_x/no_of_positions)
     RMSE_Trilateration_y = sqrt(RMSE_Trilateration_y/no_of_positions)          
     RMSE_Trilateration_avg = (RMSE_Trilateration_x + RMSE_Trilateration_y)/2       
     
     RMSE_TCgrnn_x = sqrt(RMSE_TCgrnn_x/no_of_positions)
     RMSE_TCgrnn_y = sqrt(RMSE_TCgrnn_y/no_of_positions)
     RMSE_TCgrnn_avg = (RMSE_TCgrnn_x + RMSE_TCgrnn_y)/2
     
     RMSE_grnn_x = sqrt(RMSE_grnn_x/no_of_positions)
     RMSE_grnn_y = sqrt(RMSE_grnn_y/no_of_positions)
     RMSE_grnn_avg = (RMSE_grnn_x + RMSE_grnn_y)/2
     
% Plotting Absolute Errors of KF & UKF based Tracking

f2 = figure(2);
  for t =1:no_of_positions  
    
    plot(t,error_x_TCgrnn(t),'g+','LineWidth',2)
    plot(t,error_x_grnn(t),'k+','LineWidth',2)
    plot(t,error_x_Trilateration(t),'bo','LineWidth',2)      
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in x estimates [meter]','FontName','Times','Fontsize',14,'LineWidth',2)
    hold on    
  end
  legend('Error in Trilateration based Estimation','Error in TCGRNN based Estimation','Error in GRNN based Estimation','Location','NorthWest')
  
  f3 = figure(3);  
  for t =1:no_of_positions  
    
    plot(t,error_y_TCgrnn(t),'g+','LineWidth',2) 
    plot(t,error_y_grnn(t),'k+','LineWidth',2)  
    plot(t,error_y_Trilateration(t),'bo','LineWidth',2)    %,'Markersize',2,'MarkerEdgeColor','g')     
    xlabel('Time [sec]','FontName','Times','Fontsize',14, 'LineWidth',2) 
    ylabel('Error in y estimates [m]','FontName','Times','Fontsize',14, 'LineWidth',2)    
  hold on
  end
  legend('Error in Trilateration based Estimation','Error in TCGRNN based Estimation','Error in GRNN based Estimation','Location','NorthWest')
  
  f4 = figure(4);  
  for t =1:no_of_positions     
    
    plot(t,error_xy_TCgrnn(t),'g+','LineWidth',2)
    plot(t,error_xy_grnn(t),'k+','LineWidth',2)
    plot(t,error_xy_Trilateration(t),'bo','LineWidth',2)    %,'Markersize',2,'MarkerEdgeColor','g')      
    xlabel('Time [sec]','FontName','Times','Fontsize',14,'LineWidth',2) 
    ylabel('Error in xy estimates [m]','FontName','Times','Fontsize',14,'LineWidth',2)    
  hold on
  end
  legend('Error in Trilateration based Estimation','Error in TCGRNN based Estimation','Error in GRNN based Estimation','Location','NorthWest')  
  
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
 plotregression(x_actual, Trilateration_x,'Regression using Trilateration', x_actual,TCGRNN_x,'Regression using TCGRNN')
 
 f8 = figure(8);
 plotregression(y_actual, Trilateration_y,'Regression using Trilateration',y_actual,TCGRNN_y,'Regression using TCGRNN')

 f9 = figure(9);
 plotregression(x_actual, GRNN_x,'Regression using GRNN', x_actual,TCGRNN_x,'Regression using TCGRNN')
 
 f10 = figure(10);
 plotregression(y_actual, GRNN_y,'Regression using GRNN',y_actual,TCGRNN_y,'Regression using TCGRNN')