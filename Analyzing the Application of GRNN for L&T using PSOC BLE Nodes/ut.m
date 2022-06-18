function [ y,Y,P,Y1 ] = ut( A,X,Wm,Wc,n,R )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
 L=size(X,2);
 y=zeros(n,1);
 Y=zeros(n,L);
 for k=1:L                   
    Y(:,k)=A*(X(:,k));       
    y=y+Wm(k)*Y(:,k);       
 end
 Y1=Y-y(:,ones(1,L));
 P=Y1*diag(Wc)*Y1'+R; 

end

