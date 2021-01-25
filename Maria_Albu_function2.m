function [averaged_signal] = Maria_Albu_function2(x, MinPeakDistance)
% Inputs:
% x  --> The arbitrary input: ECG or ECG_EMG signals
% MinPeakDistance --> Minimum Peak Distance
% Output:
% averaged_signal --> smoothed signal

len_x=length(x); % find the length of the input signal
val_max=max(x); % Maximum value of the input signal
MinPeakHeight=0.9*val_max; % set the threshold to 90% of the maximum value of the input signal

loc_Rwave=[]; % find the points above the threshold and put them in loc_Rwave vector
for i=1:len_x
    if x(i)>MinPeakHeight;
    loc_Rwave=[loc_Rwave i];    
    end
end

len_locs_Rwave=length(loc_Rwave); % the number of points above the threshold
% find the points above the threshold that are at least at MinPeakDistance from their neighbour
% and put then in the locs_Rwave vector
locs_Rwave=[]; 
for j=1:len_locs_Rwave-1
    if loc_Rwave(j+1)-loc_Rwave(j)>MinPeakDistance
        locs_Rwave=[locs_Rwave loc_Rwave(j)];
    end
end

vec2=min(diff(locs_Rwave)); % the period of peaks is the minimum value of the difference between peaks
lung2=min(min(locs_Rwave),fix(vec2/2));  % set the A value from the left of the peak 
l_locs_Rwave=length(locs_Rwave); % number of found peaks
matrice=zeros(l_locs_Rwave,vec2); % create the matrix where each row is a cycle related to peaks
for i=1:l_locs_Rwave
    matrice(i,:)=x(locs_Rwave(i)-lung2+1:locs_Rwave(i)+vec2-lung2);
end
averaged_signal=mean(matrice); % the average signal cycle
