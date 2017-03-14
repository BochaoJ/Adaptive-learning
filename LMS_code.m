load('manatee_signals.mat')
%fs=48000;
%soundsc(test_signal,fs);
% separate 10 train calls.
sep = [0.001,1.5,2.5,3.9,5,6,7,8,9.2,10.5,12]*10^5;
N_filter1=6;
weight=zeros(1,N_filter1);
for i=1:10
    x=train_signal(sep(i):sep(i+1),1);
    X=x(abs(x)>0.0001);
    Y=X;
mu=10^-3;
out1= LMS(N_filter1,X,Y,mu);
weight=weight+out1;
end
weight_ave=weight/10;
out4=LMSplot(N_filter1,X,Y,mu);
plot(1:length(X),out4(:,1)); % learning curve
title('learning curve for filter order of 6')
xlabel('Time point')
ylabel('NMSE')
saveas(gcf,'LMSlc6','jpg');
plot(1:length(X),out4(:,2:7)); % weight track
title('Weights track for filter order of 6')
xlabel('Time point')
ylabel('Weights')
saveas(gcf,'LMSwt6','jpg');

% noise 
X=noise_signal;
Y=X;
N_filter0=3;
out2= LMS(N_filter0,X,Y,mu);

out5=LMSplot(N_filter0,X,Y,mu);
plot(1:30000,out5(:,1)); % learning curve
title('learning curve for filter order of 3')
xlabel('Time point')
ylabel('NMSE')
saveas(gcf,'LMSlc3','jpg');
plot(1:30000,out5(:,2:4)); % weight track
title('Weights track for filter order of 3')
xlabel('Time point')
ylabel('Weights')
saveas(gcf,'LMSwt3','jpg');
%% identify noise in test_signal
plot(test_signal)
title('Test dataset: signals with noise')
xlabel('Time point')
saveas(gcf,'test_signal','jpg');



w0=out2;
w1=weight_ave;
X=test_signal;
pred=identify(N_filter0,N_filter1,X,w0,w1);

%plot(1:1440000,pred(:,1),'r',1:1440000,pred(:,2),'b')
plot(1:1440000,pred(:,1),'r')
title('signals identification')
xlabel('Time point')
ylabel('signal')
saveas(gcf,'pred_signal','jpg');
plot(1:1440000,pred(:,2),'b')
title('noise identification')
xlabel('Time point')
ylabel('noise')
saveas(gcf,'pred_noise','jpg');

w0=out2;
w1=weight_ave;
X=pred(:,1);
X0 = [zeros(1,N_filter0-1) X'];
Y=X;
for i=1:length(X)
    Y(i)=X(i)-flipud(X0(i:N_filter0+(i-1)))*w0';
end
plot(1:1440000,Y,'r')
title('signals with noise cancellation')
xlabel('Time point')
ylabel('signal')
saveas(gcf,'signal_cancel','jpg');

%plot(1:1440000,X,'r',1:1440000,Y,'b')


fs=48000;
soundsc(pred(:,2),fs);
filename='noise.wav';
y=pred(:,2);
audiowrite(filename,y,fs);

filename='signal.wav';
y=pred(:,1);
audiowrite(filename,y,fs);

%plot(data);
%title('signals predicted by Adobe Audition')
%xlabel('Time point')
%ylabel('signal')
%saveas(gcf,'signal_audition','jpg');




