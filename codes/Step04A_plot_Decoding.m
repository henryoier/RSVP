clear; clc
ProjectName = 'rsvp';  % 
iitt = 'ii';
speeds = {1,2};
project_location = ['/dataslow/sheng/' ProjectName];
addpath(genpath('Functions')); % add path of functions

flag_plot_all = 1;
flag_plot_within_face = 1;
flag_plot_within_nonface = 1;
flag_plot_between = 1;

if strcmp(iitt, 'ii')
    mat_location = [project_location '/Results/total/ACCY/mat/'];
    fig_location = [project_location '/Results/total/ACCY/fig/'];
else
    mat_location = [project_location '/Results/total/IITT/mat/'];
    fig_location = [project_location '/Results/total/IITT/fig/'];
end    
%% plot decoding

for i_speed = 1:2
    disp(['Speed = ' num2str(speeds{i_speed})]); 
    
    n_subjects = 8:8;
    
    SubjectName_all = '2rsvp78';
    
    for i_subject = 0; SubjectName = SubjectName_all;
    %for i_subject = n_subjects; SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
        disp(['Subject = ' SubjectName]);
        
        if strcmp(iitt, 'ii')
            load([mat_location 'ACCY_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat']);
        else
            load([mat_location 'IITT_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat']);
        end
        if flag_plot_all
            h = Step0A_plot_Data(Result.AccyAll.mean, Result.param, 'AccyAll');
            if strcmp(iitt, 'ii')
                print(h, [fig_location 'ACCY_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_AccyAll.jpg'],'-djpeg','-r0');
            else
                print(h, [fig_location 'IITT_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_AccyAll.jpg'],'-djpeg','-r0');
            end
            close(h);
        end
        
        if flag_plot_within_face
            h = Step0A_plot_Data(Result.Within_Face.mean, Result.param, 'Within Face');
            if strcmp(iitt, 'ii')
                print(h, [fig_location 'ACCY_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Within_Face.jpg'],'-djpeg','-r0');
            else
                print(h, [fig_location 'IITT_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Within_Face.jpg'],'-djpeg','-r0');
            end
            close(h);
        end
        
        if flag_plot_within_nonface
            h = Step0A_plot_Data(Result.Within_Nonface.mean, Result.param, 'Within Nonface');
            if strcmp(iitt, 'ii')
                print(h, [fig_location 'ACCY_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Within_Nonface.jpg'],'-djpeg','-r0');
            else
                print(h, [fig_location 'IITT_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Within_Nonface.jpg'],'-djpeg','-r0');
            end
            close(h);
        end
        
        if flag_plot_between
            h = Step0A_plot_Data(Result.Between.mean, Result.param, 'Between');
            if strcmp(iitt, 'ii')
                print(h, [fig_location 'ACCY_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Between.jpg'],'-djpeg','-r0');
            else
                print(h, [fig_location 'IITT_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Between.jpg'],'-djpeg','-r0');
            end
            close(h);
        end
        
    end        

end
    
disp('All finished!');
%closematlabpool;
