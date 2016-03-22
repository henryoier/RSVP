clear;clc;
addpath(genpath('Functions'));

speeds = [1 2];

load('C:/Users/sheng/Desktop/Sheng Qin/Project of Sheng/Results/RSVP/behavior_data/rsvp_06/rsvp_06_behavioral_20160311_18.34.15_all.mat');
for i_block = 1:12
    for i_speed=1:1
        now_speed = speeds(1, i_speed);
        Right_Face = 0;
        Right_Nonface = 0;
        Count_Face = 0;
        Count_Nonface = 0;

        for i_trial = 1:size(trial, 2)
            if floor((i_trial - 1)/Block_Size + 1) == i_block
                if result.speed(i_trial) == now_speed
                    if result.right(i_trial) == 1
                        if trial(i_trial).type == 1 %face
                            Right_Face = Right_Face + 1;
                            Count_Face = Count_Face + 1;
                        else
                            Right_Nonface = Right_Nonface + 1;
                            Count_Nonface = Count_Nonface + 1;
                        end
                    else
                        if trial(i_trial).type == 1 %face
                            Count_Face = Count_Face + 1;
                        else
                            Count_Nonface = Count_Nonface + 1;
                        end
                    end
                end
            end
    %         RespTime = result.respTime(sub_result);
    %         RespTime(isnan(RespTime)) = 2;
    %         RespTime = RespTime(RespTime > 0.1);
        end

        Behavior.Accuracy_Face(i_block) = Right_Face/Count_Face*100;
        Behavior.Accuracy_Nonface(i_block) = Right_Nonface/Count_Nonface*100;

%         Behavior.Accuracy_Face(i_speed) = Right_Face/Count_Face*100;
%         Behavior.Accuracy_Nonface(i_speed) = Right_Nonface/Count_Nonface*100;
        %Behavior.RespTime.mean(i_speed) = mean(RespTime);
        %Behavior.RespTime.std(i_speed) = std(RespTime);
    end
end

%plot_data('errorbar',speeds *1000/60, Behavior.RespTime.mean, Behavior.RespTime.std, 'Duration(ms/picture)','Response Time(s)','Respond Time',1);
plot_data('line',1:12, [Behavior.Accuracy_Face; Behavior.Accuracy_Nonface], 0, 'Block number','Accuracy(%)','Accuracy',1,{'Face','Nonface'});
%plot_data('line',speeds * 1000/60, Behavior.Accuracy_Nonface, 0, 'Duration(ms/picture)','Accuracy(%)','Accuracy',1);

