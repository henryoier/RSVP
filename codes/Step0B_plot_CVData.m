function h = Step0A_plot_CVData(Data, param_train, param_test)

flag_save = 1;
flag_smooth = 1;
smooth_vector = ones(1,50)/50;
if size(param_train.Time, 2) < size(param_test.Time, 2)
    param = param_train;
else
    param = param_test;
end
Time = param.Time;

YMIN = min(Data);
YMAX = max(Data);

h = figure('color', [1 1 1]); hold on; 
text_size = 13;
title_text = [param_train.SubjectName([1:4 6:7]) ' train speed:' num2str(param_train.speed) ' test speed:' num2str(param_test.speed)];

if (flag_save) 
    set(h,'Position',[1 1 1400 900]); 
    set(h,'PaperPositionMode','auto');
    text_size = 13;
    % set(h_Diff, 'Position', get(0,'ScreenSize'));
    % set(h_Diff, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 32 18]);
end

plot_Data = Data;

Time = Time * 1000;
%plot_Data = plot_Data(plot_Time);

% smooth accuracy data, not significant time data
if ( flag_smooth ) 
    plot_Data = conv(plot_Data,smooth_vector,'same');
end

plot(Time,plot_Data,'LineWidth',1.5,'Color',[0 0 0]);

axis([min(Time),max(Time),YMIN,YMAX]);
if (YMIN>=0) line('XData', [min(Time),max(Time)], 'YData', [50 50], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[204/255 102/255 0]); end
if (YMIN<0) line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[204/255 102/255 0]); end

line('XData', [0 0], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[0 0 1]);
line('XData', [param_train.onset_time param_train.onset_time] * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[0 1 0]);
line('XData', [param_train.offset_time param_train.offset_time] * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[0 1 0]);
line('XData', [param_test.onset_time param_test.onset_time] * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[1 0 0]);
line('XData', [param_test.offset_time param_test.offset_time] * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[1 0 0]);

title(title_text, 'FontSize', text_size)
xlabel('Time(ms)');
ylabel('Accuracy(%)');
set(gca,'xtick', -1000:200:2400);
set(gca,'FontSize',text_size);

print(h, ['Results/' param.SubjectName '/graph/' param.SubjectName '_CrossClassification_trainspeed_' num2str(param_train.speed) '_testspeed_' num2str(param_test.speed)],'-djpeg','-r0');
% % % 
% close all;
% h = figure; text_size = 13;
% plot_Data = Data{1}.mean;
% if ( flag_smooth )
%     plot_Data = conv(plot_Data,smooth_vector,'same');
% end
% plot(Time,plot_Data,Data{1}.color,'LineWidth',3);
% 
% set(h,'Position',[100 100 1200 800]); 
% axis([ -0.2, 1.5, 41, 90]); box off;grid off; 
% line('XData', [-0.2, 1.5], 'YData', [50 50], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0]); 
% line('XData', [0 0], 'YData', [40, 90], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
% line('XData', [0.8 0.8], 'YData', [40, 90], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
% 
% stat_stime = Data{1}.stat_stime;
% line(Time(stat_stime),[45],'Marker', 'o','Markersize', 2, 'color',Data{1}.color(1));
% % set(gca,'xtick',[]);set(gca,'ytick',[]);


