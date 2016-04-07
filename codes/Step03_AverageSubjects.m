%==========================================================================
% process:
%       all decoding accuracy files
% ouput:
%       averaged files of all subjects
%==========================================================================
% Written by Sheng Qin (shengqin [AT] mit (DOT) edu)
% 
% Version 1.0 -- Mar. 2016 
%
clear; clc
ProjectName = 'rsvp';  % 'grating03 to grating 16'
iitt = 'cross';                % 'ii' 'iitt' --- image-image-time-time mode off/on
speeds = {1,2};
condNum = 24;
project_location = ['/dataslow/sheng/' ProjectName];
addpath(genpath('Functions')); % add path of functions

if strcmp(iitt, 'ii')
    mat_location = [project_location '/Results/total/ACCY/mat/'];
end

if strcmp(iitt, 'iitt')
    mat_location = [project_location '/Results/total/IITT/mat/'];
end

if strcmp(iitt, 'cross')
    mat_location = [project_location '/Results/total/CROSS/mat/'];
end

%% Merge all results
tic;
for i_speed = 1:2
    disp(['Speed = ' num2str(speeds{i_speed})]); 
    
    n_subject = 0;
    n_subjects = 7:18;
    
    SubjectName_all = 'rsvp7-18';
    
    if strcmp(iitt, 'ii')
        for i_subject = n_subjects
            
            if i_subject == 9
                continue;
            end
            
            SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
            disp(['Subject = ' SubjectName]);
            n_subject = n_subject + 1;
            
            load([mat_location 'ACCY_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat']);

            temp_Result.param = Result.param;

            temp_Result.AccyAll(n_subject, :) = Result.AccyAll.mean;
            temp_Result.AccyAll_matrix(n_subject, :, :, :) = Result.AccyAll.matrix;
            temp_Result.Within_Face(n_subject, :) = Result.Within_Face.mean;
            temp_Result.Within_Face_matrix(n_subject, :, :, :) = Result.Within_Face.matrix;
            temp_Result.Within_Nonface(n_subject, :) = Result.Within_Nonface.mean;
            temp_Result.Within_Nonface_matrix(n_subject, :, :, :) = Result.Within_Nonface.matrix;
            temp_Result.Between(n_subject, :) = Result.Between.mean;
            temp_Result.Between_matrix(n_subject, :, :, :) = Result.Between.matrix;
        end
        
        Result.AccyAll.mean = mean(temp_Result.AccyAll);
        Result.AccyAll.matrix = squeeze(mean(temp_Result.AccyAll_matrix));

        Result.Within_Face.mean = mean(temp_Result.Within_Face);
        Result.Within_Face.matrix = squeeze(mean(temp_Result.Within_Face_matrix));

        Result.Within_Nonface.mean = mean(temp_Result.Within_Nonface);
        Result.Within_Nonface.matrix = squeeze(mean(temp_Result.Within_Nonface_matrix));

        Result.Between.mean = mean(temp_Result.Between);
        Result.Between.matrix = squeeze(mean(temp_Result.Between_matrix));
        
        Result.param.SubjectName = SubjectName_all;
        save([mat_location 'ACCY_' SubjectName_all '_speed_' num2str(speeds{i_speed}) '.mat'], 'Result');
    end
    
    if strcmp(iitt, 'iitt')
        for i_subject = n_subjects    
            SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
            disp(['Subject = ' SubjectName]);
            n_subject = n_subject + 1;
            
            load([mat_location 'IITT_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat']);

            temp_Result.param = Result.param;

            temp_Result.AccyAll(n_subject, :, :) = Result.AccyAll.mean;
            temp_Result.Within_Face(n_subject, :, :) = Result.Within_Face.mean;
            temp_Result.Within_Nonface(n_subject, :, :) = Result.Within_Nonface.mean;
            temp_Result.Between(n_subject, :, :) = Result.Between.mean;

        end
        
        Result.AccyAll.mean = squeeze(mean(temp_Result.AccyAll));
        Result.Within_Face.mean = squeeze(mean(temp_Result.Within_Face));
        Result.Within_Nonface.mean = squeeze(mean(temp_Result.Within_Nonface));
        Result.Between.mean = squeeze(mean(temp_Result.Between));
        
        Result.param.SubjectName = SubjectName_all;
        save([mat_location 'IITT_' SubjectName_all '_speed_' num2str(speeds{i_speed}) '.mat'], 'Result');
    end
    
    if strcmp(iitt, 'cross')
        for i_subject = n_subjects
            
            if i_subject == 9
                continue;
            end
            
            SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
            disp(['Subject = ' SubjectName]);
            n_subject = n_subject + 1;
            
            if speeds{i_speed} == 1
                load([mat_location 'CROSS_' SubjectName '_train_1_test_2.mat']);
            else
                load([mat_location 'CROSS_' SubjectName '_train_2_test_1.mat']);
            end
            
            temp_Result.param = Result.param;

            temp_Result.AccyAll(n_subject, :) = Result.AccyAll.mean;
            temp_Result.AccyAll_matrix(n_subject, :, :, :) = Result.AccyAll.matrix;
            temp_Result.Within_Face(n_subject, :) = Result.Within_Face.mean;
            temp_Result.Within_Face_matrix(n_subject, :, :, :) = Result.Within_Face.matrix;
            temp_Result.Within_Nonface(n_subject, :) = Result.Within_Nonface.mean;
            temp_Result.Within_Nonface_matrix(n_subject, :, :, :) = Result.Within_Nonface.matrix;
            temp_Result.Between(n_subject, :) = Result.Between.mean;
            temp_Result.Between_matrix(n_subject, :, :, :) = Result.Between.matrix;
        end
        
        Result.AccyAll.mean = mean(temp_Result.AccyAll);
        Result.AccyAll.matrix = squeeze(mean(temp_Result.AccyAll_matrix));

        Result.Within_Face.mean = mean(temp_Result.Within_Face);
        Result.Within_Face.matrix = squeeze(mean(temp_Result.Within_Face_matrix));

        Result.Within_Nonface.mean = mean(temp_Result.Within_Nonface);
        Result.Within_Nonface.matrix = squeeze(mean(temp_Result.Within_Nonface_matrix));

        Result.Between.mean = mean(temp_Result.Between);
        Result.Between.matrix = squeeze(mean(temp_Result.Between_matrix));
        
        Result.param.SubjectName = SubjectName_all;
        
        if speeds{i_speed} == 1
            save([mat_location 'CROSS_' SubjectName_all '_train_1_test_2.mat'], 'Result');
        else
            save([mat_location 'CROSS_' SubjectName_all '_train_2_test_1.mat'], 'Result');
        end
    end
    
    clear temp_Result;
end
    
disp('All finished!');
toc
%closematlabpool;
