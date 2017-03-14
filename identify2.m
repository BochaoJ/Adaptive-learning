function out =identify2(N_filter0,N_filter1,X,w0,w1)
if length(X)>1440000
    X=X(2:end,:);
end
pred_noise = X;
pred_signal = pred_noise;
w_size=2880;
for j=1:(1440000/w_size)
seq=w_size*(j-1)+1:w_size*j;
X_seq=X(seq);
len=length(X_seq);
X_seq=X_seq';
X0 = [zeros(1,N_filter0-1) X_seq];
X1 = [zeros(1,N_filter1-1) X_seq];
d1=zeros(1,len);
d2=zeros(1,len);
for i=1:len
   d1(i) = X0(i:N_filter0+(i-1))*w0';
   d2(i) = X1(i:N_filter1+(i-1))*w1';
end
diff1=sum(abs(d1-X_seq));
diff2=sum(abs(d2-X_seq));
if diff1<diff2
    pred_signal(seq,1)=0;
else
    pred_noise(seq,1)=0;
end
end
out=[pred_signal pred_noise];
end

