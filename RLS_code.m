load('manatee_signals.mat')
%fs=48000;
soundsc(test_signal,fs);
% separate 10 train calls.
sep = [0.001,1.5,2.5,3.9,5,6,7,8,9.2,10.5,12]*10^5;
N_filter1=6;
weight=zeros(1,N_filter1);
for i=1:10
    x=train_signal(sep(i):sep(i+1),1);
    X=x(abs(x)>0.0001);
    Y=X;
sigma=0.0005;
out1=RLS(N_filter1,sigma,X,Y);
weight=weight+out1;
end
weight_ave=weight/10;

% noise 
X=noise_signal;
Y=X;
N_filter0=3;
out2=RLS(N_filter0,sigma,X,Y);

%% identify noise in test_signal
w0=out2;
w1=weight_ave;
X=test_signal;
pred=identify(N_filter0,N_filter1,X,w0,w1);

%plot(1:1440000,pred(:,1),'r',1:1440000,pred(:,2),'b')
plot(1:1440000,pred(:,1),'r')
plot(1:1440000,pred(:,2),'b')
fs=48000;
soundsc(pred(:,1),fs);
filename='noise.wav';
y=pred(:,2);
audiowrite(filename,y,fs);

filename='signal.wav';
y=pred(:,1);
audiowrite(filename,y,fs);


filename='train_signal.wav';
y=train_signal;
audiowrite(filename,y,fs);

filename='noise_signal.wav';
y=noise_signal;
audiowrite(filename,y,fs);

filename='test_signal.wav';
y=test_signal;
audiowrite(filename,y,fs);






