function h = Step0A_plot_Data(Data, param)

flag_save = 1;
flag_smooth = 1;
smooth_vector = ones(1,50)/50;
Time = param.Time;

YMIN = min(Data);
YMAX = max(Data);

h = figure; hold on; 
text_size = 13;

box on; grid on; 

if (flag_save) 
    set(h,'Position',[1 1 1400 900]); 
    set(h,'PaperPositionMode','auto');
    text_size = 13;
    % set(h_Diff, 'Position', get(0,'ScreenSize'));
    % set(h_Diff, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 32 18]);
end

plot_Data = Data;
    
% smooth accuracy data, not significant time data
if ( flag_smooth ) 
    plot_Data = conv(plot_Data,smooth_vector,'same');
end

plot_Time = Time > (param.onset_time - param.baseline) &...
    Time < (param.offset_time + param.inter);

Time = Time(plot_Time);
plot_Data = plot_Data(plot_Time);

plot(Time,plot_Data','LineWidth',2);

axis([min(Time),max(Time),YMIN,YMAX]);
if (YMIN>=0) line('XData', [min(Time),max(Time)], 'YData', [50 50], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0]); end
if (YMIN<0) line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0]); end
line('XData', [0 0], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
line('XData', [param.onset_time param.onset_time], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
line('XData', [param.offset_time param.offset_time], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
title(title_text, 'FontSize', text_size)
set(gca,'FontSize',text_size);


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


