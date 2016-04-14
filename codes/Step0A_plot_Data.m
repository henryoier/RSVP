function [h, h_stat] = Step0A_plot_Data(Data, param, title_info)

flag_save = 1;
flag_smooth = 0;
smooth_vector = ones(1,50)/50;
Time = param.Time;

YMIN = 40;
YMAX = 80;

h = figure('color', [1 1 1]); hold on; 
text_size = 12;
title_text = [strrep(param.SubjectName, '_', ' ') ' ' title_info ' Duration:' num2str(round(param.speed * param.framesec * 1000)) ' ms/picture'];

if (flag_save) 
    set(h,'Position',[1 1 1400 900]); 
    set(h,'PaperPositionMode','auto');
    % set(h_Diff, 'Position', get(0,'ScreenSize'));
    % set(h_Diff, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 32 18]);
end

if strcmp(param.iitt, 'ii') 
    plot_Data = Data.mean;
    
    Time = Time * 1000;
    %plot_Data = plot_Data(plot_Time);

    % smooth accuracy data, not significant time data
    if ( flag_smooth ) 
        plot_Data = conv(plot_Data,smooth_vector,'same');
    end

    fill([Time, fliplr(Time)], [Data.mean - Data.std, fliplr(Data.mean + Data.std)],...
        [135 206 250] / 255 , 'linestyle', 'none');
    
    plot(Time,plot_Data,'LineWidth',1.5,'Color',[0 0 0]);

    axis([min(Time),max(Time),YMIN,YMAX]);
    if (YMIN>=0) line('XData', [min(Time),max(Time)], 'YData', [50 50], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[204/255 102/255 0]); end
    if (YMIN<0) line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[204/255 102/255 0]); end

    line('XData', [0 0], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[0 0 1]);
    line('XData', [0 + param.speed * param.framesec 0 + param.speed * param.framesec] * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[0 0 1]);

    line('XData', [param.onset_time param.onset_time] * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[204/255 102/255 0])
    line('XData', [param.offset_time param.offset_time] * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[204/255 102/255 0])
    
    % plot significant time
    if (isfield(Data, 'stat_time'))
        if size(Data.stat_time, 2) > 0
            stat_stime = Data.stat_time;

            %line(Time(stat_stime),48,'Marker', 'o','Markersize', 2, 'color', [0 0 0]);

            line( Time(stat_stime),YMAX - 1, 'Marker', 'o','Markersize', 2, 'color', [135 206 250] / 255 );

            %
            % stat_ttest = Data.stat_ttest;
            % line(Time(stat_ttest>0),30,'Marker', 'o' , 'Color','k');
            %
            % stat_pvalue = Data.stat_pvalue;
            % line(Time(stat_pvalue>0),25,'Marker', 'o' , 'Color','k');
        end
       
        h_stat = [];
    end
    
    title(title_text, 'FontSize', text_size)
    xlabel('Time(ms)');
    ylabel('Accuracy(%)');
    set(gca,'xtick', -1000:200:2400);
    set(gca,'FontSize',text_size);
end

if strcmp(param.iitt, 'iitt')
    Time = Time * 1000;
    
    imagesc(Time, Time, Data.mean);colorbar;colormap(jet);
    set(gca, 'YDir', 'normal');
    axis equal;axis([min(Time) max(Time) min(Time) max(Time)]);
    
    line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 3, 'Color',[0 0 0]);
    line('XData', [min(Time),max(Time)], 'YData', [param.onset_time param.onset_time] * 1000, 'LineStyle', '-', 'LineWidth', 3, 'Color',[128/255 128/255 128/255]);
    line('XData', [min(Time),max(Time)], 'YData', [param.offset_time param.offset_time] * 1000, 'LineStyle', '-', 'LineWidth', 3, 'Color',[128/255 128/255 128/255]);
    line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[0 0 0]);
    line('XData', [param.onset_time param.onset_time] * 1000, 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[128/255 128/255 128/255]);
    line('XData', [param.offset_time param.offset_time] * 1000, 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[128/255 128/255 128/255]);
    
    title(title_text, 'FontSize', text_size)
    xlabel('Training Time(ms)');
    ylabel('Testing Time(ms)');
    set(gca,'xtick', -1000:200:2400);
    set(gca,'FontSize',text_size);
    
    
end

if strcmp(param.iitt, 'cross')
    title_text = [strrep(param.SubjectName, '_', ' ') ' ' title_info ' train speed: '...
        num2str(param.train_speed) ' test speed: ' num2str(param.test_speed)];

    plot_Data = Data.mean;
    
    Time = Time * 1000;
    %plot_Data = plot_Data(plot_Time);

    % smooth accuracy data, not significant time data
    if ( flag_smooth ) 
        plot_Data = conv(plot_Data,smooth_vector,'same');
    end

    fill([Time, fliplr(Time)], [Data.mean - Data.std, fliplr(Data.mean + Data.std)],...
        [135 206 250] / 255 , 'linestyle', 'none');
    
    plot(Time,plot_Data,'LineWidth',1.5,'Color',[0 0 0]);
    
    axis([min(Time),max(Time),YMIN,YMAX]);
    if (YMIN>=0) line('XData', [min(Time),max(Time)], 'YData', [50 50], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[204/255 102/255 0]); end
    if (YMIN<0) line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[204/255 102/255 0]); end

    line('XData', [0 0], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[0 0 1]);

    line('XData', [0-5 * param.train_speed 0-5 * param.train_speed] * param.framesec * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[0 1 0])
    line('XData', [0-5 * param.test_speed 0-5 * param.test_speed] * param.framesec * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[1 0 0])
    line('XData', [6 * param.train_speed 6 * param.train_speed] * param.framesec * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[0 1 0])
    line('XData', [6 * param.test_speed 6 * param.test_speed] * param.framesec * 1000, 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.0, 'Color',[1 0 0])
    
     % plot significant time
    if (isfield(Data, 'stat_time'))
        if size(Data.stat_time, 2) > 0
            stat_stime = Data.stat_time;

            %line(Time(stat_stime),48,'Marker', 'o','Markersize', 2, 'color', [0 0 0]);

            line( Time(stat_stime),YMAX - 1, 'Marker', 'o','Markersize', 2, 'color', [135 206 250] / 255 );

            %
            % stat_ttest = Data.stat_ttest;
            % line(Time(stat_ttest>0),30,'Marker', 'o' , 'Color','k');
            %
            % stat_pvalue = Data.stat_pvalue;
            % line(Time(stat_pvalue>0),25,'Marker', 'o' , 'Color','k');
        end
        
        h_stat = [];
    end
    
    title(title_text, 'FontSize', text_size)
    xlabel('Time(ms)');
    ylabel('Accuracy(%)');
    set(gca,'xtick', -1000:200:2400);
    set(gca,'FontSize',text_size);
end

%print(h, ['Results/' param.SubjectName '/graph/' param.SubjectName '_TimeDecoding_speed_' num2str(param.speed)],'-djpeg','-r0');
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


