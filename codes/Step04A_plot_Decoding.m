clear; clc
ProjectName = 'rsvp';  % 
iitt = 'cross';
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
end

if strcmp(iitt, 'iitt')
    mat_location = [project_location '/Results/total/IITT/mat/'];
    fig_location = [project_location '/Results/total/IITT/fig/'];
end    

if strcmp(iitt, 'cross')
    mat_location = [project_location '/Results/total/CROSS/mat/'];
    fig_location = [project_location '/Results/total/CROSS/fig/'];
end  
%% plot decoding

for i_speed = 1:2
    disp(['Speed = ' num2str(speeds{i_speed})]); 
    
    n_subjects = 7:18;
    
    SubjectName_all = 'rsvp7-18';
    
    %for i_subject = 0; SubjectName = SubjectName_all;
    for i_subject = n_subjects; SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
        disp(['Subject = ' SubjectName]);
        
        if strcmp(iitt, 'ii')
            load([mat_location 'ACCY_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat']);
        end
        
        if strcmp(iitt, 'iitt')
            load([mat_location 'IITT_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat']);
        end
        
        if strcmp(iitt, 'cross')
            if speeds{i_speed} == 1
                load([mat_location 'CROSS_' SubjectName '_train_1_test_2.mat']);
            else
                load([mat_location 'CROSS_' SubjectName '_train_2_test_1.mat']);
            end
        end
        
        if flag_plot_all
            h = Step0A_plot_Data(Result.AccyAll.mean, Result.param, 'AccyAll');
            if strcmp(iitt, 'ii')
                print(h, [fig_location 'ACCY_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_AccyAll.jpg'],'-djpeg','-r0');
            end
            
            if strcmp(iitt, 'iitt')
                print(h, [fig_location 'IITT_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_AccyAll.jpg'],'-djpeg','-r0');
            end
            
            if strcmp(iitt, 'cross')
                print(h, [fig_location 'CROSS_' Result.param.SubjectName '_train_' num2str(Result.param.train_speed) ...
                    '_test_' num2str(Result.param.test_speed) '_AccyAll.jpg'],'-djpeg','-r0');
            end
            close(h);
        end
        
        if flag_plot_within_face
            h = Step0A_plot_Data(Result.Within_Face.mean, Result.param, 'Within Face');
            if strcmp(iitt, 'ii')
                print(h, [fig_location 'ACCY_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Within_Face.jpg'],'-djpeg','-r0');
            end
            
            if strcmp(iitt, 'iitt')
                print(h, [fig_location 'IITT_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Within_Face.jpg'],'-djpeg','-r0');
            end
            
            if strcmp(iitt, 'cross')
                print(h, [fig_location 'CROSS_' Result.param.SubjectName '_train_' num2str(Result.param.train_speed) ...
                    '_test_' num2str(Result.param.test_speed) '_Within_Face.jpg'],'-djpeg','-r0');
            end
            close(h);
        end
        
        if flag_plot_within_nonface
            h = Step0A_plot_Data(Result.Within_Nonface.mean, Result.param, 'Within Nonface');
            if strcmp(iitt, 'ii')
                print(h, [fig_location 'ACCY_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Within_Nonface.jpg'],'-djpeg','-r0');
            end
            
            if strcmp(iitt, 'iitt')
                print(h, [fig_location 'IITT_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Within_Nonface.jpg'],'-djpeg','-r0');
            end
            
            if strcmp(iitt, 'cross')
                print(h, [fig_location 'CROSS_' Result.param.SubjectName '_train_' num2str(Result.param.train_speed) ...
                    '_test_' num2str(Result.param.test_speed) '_Within_Nonface.jpg'],'-djpeg','-r0');
            end
            close(h);
        end
        
        if flag_plot_between
            h = Step0A_plot_Data(Result.Between.mean, Result.param, 'Between');
            if strcmp(iitt, 'ii')
                print(h, [fig_location 'ACCY_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Between.jpg'],'-djpeg','-r0');
            end
            
            if strcmp(iitt, 'iitt')
                print(h, [fig_location 'IITT_' Result.param.SubjectName '_speed_'...
                    num2str(Result.param.speed) '_Between.jpg'],'-djpeg','-r0');
            end
            
            if strcmp(iitt, 'cross')
                print(h, [fig_location 'CROSS_' Result.param.SubjectName '_train_' num2str(Result.param.train_speed) ...
                    '_test_' num2str(Result.param.test_speed) '_Between.jpg'],'-djpeg','-r0');
            end
            close(h);
        end
        
    end        

end
    
disp('All finished!');
%closematlabpool;
