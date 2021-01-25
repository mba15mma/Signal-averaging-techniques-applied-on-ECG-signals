clear
load ecg_wavs;

max_ecg=length(ecg50hz); % the length of the ecg50hz signal
b=zeros(max_ecg-4,1); % set the length of the averaged vector for ecg50hz signal
for i=1:(max_ecg-4)
      b(i)=(ecg50hz(i)+ecg50hz(i+1)+ecg50hz(i+2)+ecg50hz(i+3)+ecg50hz(i+4))/5;     
end 

max_ecg_emg=length(ecg_emg); % the length of the ecg_emg signal
c=zeros(max_ecg_emg-4,1); % % set the length of the averaged vector for ecg_emg signal
for j=1:(max_ecg_emg-4)
      c(j)=(ecg_emg(j)+ecg_emg(j+1)+ecg_emg(j+2)+ecg_emg(j+3)+ecg_emg(j+4))/5;
end
figure
subplot(2,1,1), plot(ecg_emg,'-b')
title('The ECG\_EMG signal')
xlabel('time [ms]');
ylabel('Voltage [mV]');
xlim([0 3000])
subplot(2,1,2), plot(b,'-r')
title('The ECG signal')
xlabel('time [ms]');
ylabel('Voltage [mV]');
xlim([0 3000])
print -dbitmap fig_a

% the cycle of the ecg50hz has 860 samples (the distance between the peaks)
% Can be measured on the plot or using the matlab function
% http://www.mathworks.com/help/signal/examples/peak-analysis.html
% 
[~,locs_Rwave] = findpeaks(ecg50hz(1:3000),'MinPeakHeight',1.5,'MinPeakDistance',800) 
first_cycle_length_ecg50hz = mean (diff(locs_Rwave))
% locs_Rwave gives the location of the peaks whose MinPeakHeight is higher
% than 1.5 and MinPeakDistance between R waves is higher than 800
[~,locs_Rwave1] = findpeaks(ecg_emg(1:3000),'MinPeakHeight',1.5,'MinPeakDistance',800) 
first_cycle_length_ecg_emg = mean (diff(locs_Rwave1))
% the approximate cycle of the ecg_emg signal has 1096 samples (the distance between the peaks)

l_x1=860; % length of the first cycle of ecg50hz
x1_ecg50hz=ecg50hz(1:l_x1); % first cycle of ecg50hz
l_y1=1096; % length of the first cycle of ecg_emg
y1_ecg_emg=ecg_emg(1:l_y1); % first cycle of ecg_emg

figure % only the first cycle is plotted
subplot(2,1,1), plot(c(1:l_y1),'-b')
title('5-point sliding averaged ECG\_EMG signal')
xlabel('time [ms]');
ylabel('Voltage [mV]');
subplot(2,1,2), plot(b(1:l_x1),'-r')
title('5-point sliding averaged ECG signal')
xlabel('time [ms]');
ylabel('Voltage [mV]');

% plot for point d)
%
av3_x1_ecg50hz=Maria_Albu_function(x1_ecg50hz,3); % averaged ecg50hz signal, length of filter is 3
av10_x1_ecg50hz=Maria_Albu_function(x1_ecg50hz,10);% averaged ecg50hz signal, length of filter is 10

av3_y1_ecg_emg=Maria_Albu_function(y1_ecg_emg,3); % averaged ecg_emg signal, length of filter is 3
av10_y1_ecg_emg=Maria_Albu_function(y1_ecg_emg,10);% averaged ecg_emg signal, length of filter is 10

figure % only the first cycle is plotted
subplot(2,1,1), plot(av3_y1_ecg_emg,'k','Linewidth',1.5)
title('averaged ECG\_EMG signals')
hold on;
plot(av10_y1_ecg_emg,'r','Linewidth',1)
xlabel('time [ms]');
ylabel('Voltage [mV]');
legend('filter length = 3','filter length = 10')
subplot(2,1,2), plot(av3_x1_ecg50hz,'k','Linewidth',1.5)
title('averaged ECG signals')
hold on;
plot(av10_x1_ecg50hz,'r','Linewidth',1)
xlabel('time [ms]');
ylabel('Voltage [mV]');
legend('filter length = 3','filter length = 10')
print -dbitmap fig_d


%%
MinPeakDistance=800;
[averaged_ecg50hz] = Maria_Albu_function2(ecg50hz,MinPeakDistance);
[averaged_ecg_emg] = Maria_Albu_function2(ecg_emg,MinPeakDistance);
figure,
plot(averaged_ecg50hz); 
legend('ECG profile')
xlabel('time [ms]');
ylabel('Voltage [mV]');
print -dbitmap ecg_figh

figure
plot(averaged_ecg_emg,'r');
legend( 'ECG\_EMG profile')
xlabel('time [ms]');
ylabel('Voltage [mV]');
print -dbitmap emg_figh
%%



[~,locs_Rwave1] = findpeaks(ecg_emg,'MinPeakHeight',1.5,'MinPeakDistance',800) 
l_ecg_emg = min (diff(locs_Rwave1));
lung=min(min(locs_Rwave),fix(l_ecg_emg/2)); 
l_locs_Rwave1=length(locs_Rwave1); % number of peaks
matrice=zeros(l_locs_Rwave1,l_ecg_emg);
for i=1:l_locs_Rwave1
    matrice(i,:)=ecg_emg(locs_Rwave1(i)-lung+1:locs_Rwave1(i)+l_ecg_emg-lung);
end

figure
averaged_signal=mean(matrice);
plot(averaged_signal)
xlabel('time [ms]');
ylabel('Voltage [mV]');
title('Averaged ECG\_EMG signal cycle')

[~,locs_Rwave] = findpeaks(ecg50hz,'MinPeakHeight',1.5,'MinPeakDistance',800); 
vec2=min (diff(locs_Rwave));
l_ecg50hz = min (diff(locs_Rwave));
lung2=min(min(locs_Rwave),fix(l_ecg50hz/2)); 
l_locs_Rwave=length(locs_Rwave); % number of peaks
matrice1=zeros(l_locs_Rwave,l_ecg50hz);
for i=1:l_locs_Rwave
    matrice1(i,:)=ecg50hz(locs_Rwave(i)-lung2+1:locs_Rwave(i)+l_ecg50hz-lung2);
end
figure
averaged_signal1=mean(matrice1);
plot(averaged_signal1)
xlabel('time [ms]');
ylabel('Voltage [mV]');
title('Averaged ECG signal cycle')

figure % only the first cycle is plotted
plot(c(1:l_y1),'-b')
title('5-point sliding averaged ECG\_EMG cycle')
xlabel('time [ms]');
ylabel('Voltage [mV]');
print -dbitmap emg_5 % print a bitmap file for the figure

figure, plot(b(1:l_x1),'-r')
title('5-point sliding averaged ECG signal')
xlabel('time [ms]');
ylabel('Voltage [mV]');
print -dbitmap ecg_5 % print a bitmap file for the figure





