function [smoothed] = Maria_Albu_function(x, Nl)
% Inputs:
% x  --> The arbitrary input signal
% Nl --> filter length
% Output:
% smoothed --> smoothed signal

max_x=length(x); % find the length of the input signal
smoothed=zeros(max_x-Nl+1,1); % % set the length of the smoothed signal
for j=1:max_x-Nl+1
      smoothed(j)=mean(x(j:j+Nl-1));
end


