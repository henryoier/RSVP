function h = plot_data( X, Y, STD, title_text, flag_save)
%PLOT_ERRORBAR Summary of this function goes here
%   Detailed explanation goes here

h = figure('Color', [1 1 1]);

if flag_save
    set(h,'Position',[1 1 800 600]);
    set(h, 'PaperPositionMode','auto');
    text_size = 13;
end

% Create axes
axes1 = axes('Parent',h);

% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[0 1]);
box(axes1,'off');
hold(axes1,'on');

errorbar(X, Y, STD,'Marker','square','LineStyle','-.');
title(title_text, 'FontSize', text_size);
end

