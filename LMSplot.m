function out = LMSplot(N_filter,X,Y,mu)
len = length(X);
X=X';
Y=Y';

X1 = [zeros(1,N_filter-1) X];
w=zeros(1,N_filter);
w_total=zeros(len,N_filter);
for i=1:len
    err = Y(i)-flipud(X1(i:i+N_filter-1))*w';
    w = w + 2*mu*err*flipud(X1(i:i+N_filter-1));
    w_total(i,:)=w;
end
%% Predict
X_total = zeros(len,N_filter);
for i=1:len
    X_total(i,:)= flipud(X1(i:i+N_filter-1));
end
d= X_total*w_total(1:30000,:)';
%% NMSE
NMSE=zeros(1,30000);
for i=1:30000
NMSE(i)=sum((Y-d(:,i)').^2)/sum(Y.^2);
end
fprintf('the identification accuracy NMSE is %f\n',NMSE(30000));
out=[NMSE',w_total(1:30000,:)];
    

