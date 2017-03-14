function out = RLSplot(N_filter,sigma,X,Y)
len = length(X);
X=X';
Y=Y';
X1 = [zeros(1,N_filter-1) X];
w=zeros(1,N_filter);
w_total=zeros(len,N_filter);
R_inv=100*sigma*eye(N_filter);
for i=1:len
    err = Y(i)-fliplr(X1(i:i+N_filter-1))*w';
    z=R_inv*fliplr(X1(i:i+N_filter-1))';
    Q=fliplr(X1(i:i+N_filter-1))*z;
    w=w+err*1/(1+Q)*z';
    w_total(i,:)=w;
    R_inv=R_inv-1/(1+Q)*z*z';
    
end
%% Predict
X_total = zeros(len,N_filter);
for i=1:len
    X_total(i,:)=fliplr(X1(i:i+N_filter-1));
end
d= X_total*w_total';
%% NMSE
NMSE=zeros(1,len);
for i=1:len
NMSE(i)=sum((Y-d(:,i)').^2)/sum(Y.^2);
end
out=[NMSE',w_total];