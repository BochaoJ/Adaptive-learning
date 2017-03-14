function out = RLS(N_filter,sigma,X,Y)
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
for i=1:len
   d(i) = fliplr(X1(i:i+N_filter-1))*w';
end

%% plot 
%figure,
plot(1:len,Y','b',1:len,d','r');
%desired_signal = Y';
%filtered_signal = d';
%legend('desired signal','filtered signal','Location','NorthWest');
%saveas(gcf,'RLSoutput','jpg');
%% NMSE
NMSE = sum((Y-d).^2)/sum(Y.^2);
fprintf('the identification accuracy NMSE is %f\n',NMSE);
out=w;
    

