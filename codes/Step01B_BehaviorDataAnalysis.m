clear;clc;
load('C:/Users/sheng/Desktop/Sheng Qin/Project of Sheng/Results/RSVP/behavior_data/rsvp_01/rsvp_01_behavioral_20160129_18.49.01.mat');
addpath(genpath('Functions'));

speeds = [1 3 6 10];

for i_speed=1:size(speeds, 2)
    now_speed = speeds(1, i_speed);
    sub_result = (result.speed == now_speed);
    
    Right = result.right(sub_result);
    RespTime = result.respTime(sub_result);
    RespTime(isnan(RespTime)) = 2;
    RespTime = RespTime(RespTime > 0.1);
      
    Behavior.Accuracy(i_speed) = sum(Right == 1)/size(Right, 1)*100;
    Behavior.RespTime.mean(i_speed) = mean(RespTime);
    Behavior.RespTime.std(i_speed) = std(RespTime);
end

plot_data('errorbar',speeds *1000/60, Behavior.RespTime.mean, Behavior.RespTime.std, 'Duration(ms/picture)','Response Time(s)','Respond Time',1);
plot_data('line',speeds * 1000/60, Behavior.Accuracy, 0, 'Duration(ms/picture)','Accuracy(%)','Accuracy',1);
