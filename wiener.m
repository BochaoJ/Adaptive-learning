function out = wiener(N_filter,N_window,X,Y)
% filter of order and windows size
len=length(X);
X=X';
Y=Y';
t = len/N_window;
w_n = zeros(1,N_filter)'; 
for n=1:t
x0 = X(1+(n-1)*N_window: n*N_window);
y0 = Y(1+(n-1)*N_window: n*N_window);

x = [zeros(1,N_filter-1),x0];
for i=1:N_filter
   xr(i) = 1/N_window*x(1:N_window)*x(i:(i-1)+N_window)';
end
for i=1:N_filter
   for j=1:N_filter
       R(i,j) = xr(abs(i-j)+1);
   end
end
for i=1:N_filter
    P(i)= 1/N_window*x0(1:N_window-i+1)*y0(i:N_window)';
end
w_n = inv(R)*P'+w_n;
end
w_n = flipud(w_n);
w = w_n/t;
%% Predict
x1 = [zeros(1,N_filter-1) X];
for i=1:len
   d(i) = x1(i:N_filter+(i-1))*w;
end
%% NMSE
NMSE = sum((Y-d).^2)/sum(Y.^2);
%% calculate WSNR
fprintf('the identification accuracy NMSE is %f\n',NMSE);
out=w';
