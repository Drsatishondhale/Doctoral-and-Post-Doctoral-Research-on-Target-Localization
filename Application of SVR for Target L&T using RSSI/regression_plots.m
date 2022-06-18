 %%%%%% Regression Analysis %%%%%%%%%%%%%%%%%
f9 = figure(9);

 Cyt = corrcoef(trad_x,x_actual);
 R_trad_x  = Cyt(2,1)
 plot(trad_x,x_actual,'r')
 hold on 

 Cyt = corrcoef(kf_x,x_actual);
 R_kf_x  = Cyt(2,1)
 plot(kf_x,x_actual,'b')
 hold on
 
 Cyt = corrcoef(ukf_x,x_actual);
 R_ukf_x  = Cyt(2,1)
 plot(ukf_x,x_actual,'k')
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  %%%%%% Regression Analysis %%%%%%%%%%%%%%%%%
f10 = figure(10);

 Cyt = corrcoef(trad_y,y_actual);
 R_trad_y  = Cyt(2,1)
plot(trad_y,y_actual,'r')
hold on 

 Cyt = corrcoef(kf_y,y_actual);
 R_kf_y  = Cyt(2,1)
 plot(kf_y,y_actual,'b')
 hold on
 
 Cyt = corrcoef(ukf_y,y_actual);
 R_ukf_y  = Cyt(2,1)
 plot(ukf_y,y_actual,'k')
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%