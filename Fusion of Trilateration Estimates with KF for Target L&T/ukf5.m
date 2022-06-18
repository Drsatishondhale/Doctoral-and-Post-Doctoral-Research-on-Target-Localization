function [ X_ukf ] = ukf5( X,P,Z )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

   dt= 1;
   A = [1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];
   H = eye(4);
   R = [2.2 0 0 0     ; 0 1.2 0 0; 0 0 0.9 0; 0 0 0 0.5];
   %R = [0.00001 0 0 0;   0  0.00001 0 0;  0  0 0.00001 0; 0 0 0 0.00001];
   %Q = eye(4);
    dt=1;
   sig = 1;
   Q = sig*[(1/3)*dt^3  0  (1/2)*dt^2  0; 0  (1/3)*dt^3  0  (1/2)*dt^2; (1/2)*dt^2  0  dt  0;  0  (1/2)*dt^2  0  dt];
   
   
   L=numel(X);                                 %numer of states
   m=numel(Z);                                 %numer of measurements
   alpha=1e-3;                                 %default, tunable
   ki=0;                                       %default, tunable
   beta=2;                                     %default, tunable
   lambda=alpha^2*(L+ki)-L;                    %scaling factor
   c=L+lambda;                                 %scaling factor
   Wm=[lambda/c 0.5/c+zeros(1,2*L)];           %weights for means
   Wc=Wm;
   Wc(1)=Wc(1)+(1-alpha^2+beta);               %weights for covariance
   c=sqrt(c);
  
  % Sigma Point Calculation 
  %X=sigmas(x,P,c);                            %sigma points around x
  D = c*chol(P)';
  Y = X(:,ones(1,numel(X)));
  X = [X Y+D Y-D]; 
  
  [x1,X1,P1,X2]=ut(A,X,Wm,Wc,L,Q);          %unscented transformation of process
  [z1,Z1,P2,Z2]=ut(H,X1,Wm,Wc,m,R);       %unscented transformation of measurments

  P12=X2*diag(Wc)*Z2';                        %transformed cross-covariance
  K=P12*inv(P2);
  X=x1+K*(Z-z1);                              %state update
  X_ukf = X;
  P=P1-K*P12';                                %covariance update
end


