function out = LMS(N_filter,X,Y,mu)
len=length(X);
X=X';
Y=Y';
X1 = [zeros(1,N_filter-1) X];
w=zeros(1,N_filter);  
for i=1:len
    err = Y(i)-flipud(X1(i:i+N_filter-1))*w';
    w = w + 2*mu*err*flipud(X1(i:i+N_filter-1));
end
%% Predict
for i=1:len
   d(i) = flipud(X1(i:N_filter+(i-1)))*w';
end
%% NMSE
NMSE = sum((Y-d).^2)/sum(Y.^2);
fprintf('the identification accuracy NMSE is %f\n',NMSE);
out=w;
    

