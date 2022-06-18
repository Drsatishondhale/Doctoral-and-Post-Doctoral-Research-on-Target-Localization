function [ X_kalman,Y_kalman, X_kf] = kf( X,P,X_T,Y_T,velocity_est,t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   
       % Kalman Filter Configuration Parameters
       x_ini = 10; y_ini = 20;
       x_v = 0; y_v = 0;    % velocities
       dt = 1;  % time interval of 1 second
       
       %X = [x_ini; y_ini; x_v; y_v];
       A = [1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];
       B = [(1/2)*dt^2  0; 0 (1/2)*dt^2; dt 0; 0 dt];
       dt=1;
       U = [3.5; 3.5];            % Control Input (acceleration)
       var_x = 2; var_y = 2; var_x_v = 0; var_y_v = 0;     % Variance in process
       %P = [0.25 0 0  0; 0 0.04 0 0; 0 0 0.02 0; 0 0 0 0.01];   % Process Covariance Matrix
       R = [2.2 0 0 0     ; 0 1.2 0 0; 0 0 0.9 0; 0 0 0 0.5];
       %R = [0.00001 0 0 0;   0  0.00001 0 0;  0  0 0.00001 0; 0 0 0 0.00001]; 
       %R = 0.1*eye(4);
       %Q = eye(4);
       sig = 1;
       Q = sig*[(1/3)*dt^3  0  (1/2)*dt^2  0; 0  (1/3)*dt^3  0  (1/2)*dt^2; (1/2)*dt^2  0  dt  0;  0  (1/2)*dt^2  0  dt];
       H = eye(4);
       I = eye(4);

   % Prediction Stage
       X = A*X + B*U + [randn;randn;randn;randn];            % + W=0    % System `Equation
       P = A*P*A'; + Q; % Q process noise covariance matrix
       
     % Update Stage  
       X_meas = [X_T; Y_T; velocity_est(1); velocity_est(2)];             % Observation Equation
       Y = H*X_meas + [randn;randn;randn;randn];
       K = (P*H)/((H*P*H')+ R);
       disp('Kalman Filter State Location')
       X = X + K*(Y-(H*X))
       
       X_kf = X;
       X_kalman=X(1);
       Y_kalman=X(2);
       P = (I - (K*H))*P;

end

