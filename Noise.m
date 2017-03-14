function out = Noise(N_filter,mu,mtlb_noisy,noise)
% Define Adaptive Filter Parameters
weights = zeros(1,N_filter);
% Initialize Filter's Operational inputs
output = zeros(1,length(mtlb_noisy));
err = zeros(1,length(mtlb_noisy));
input = zeros(1,N_filter);
% For Loop to run through the data and filter out noise
for n = 1:length(mtlb_noisy)
      %Get input vector to filter
      for k= 1:N_filter
          if ((n-k)>0)
              input(k) = noise(n-k+1);
          end
      end
   output(n) = weights * input';  %Output of Adaptive Filter
   err(n)  = mtlb_noisy(n) - output(n); %Error Computation
   weights = weights + mu * err(n) * input; %Weights Updating 
end
out=err;