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
clear; clc;
ProjectName = 'rsvp';  % 'grating03 to grating 16'
iitt = 'ii';                % 'ii' 'iitt' --- image-image-time-time mode off/on
speeds = {1,2};
condNum = 24;
project_location = ['/dataslow/sheng/' ProjectName];
addpath(genpath('Functions')); % add path of functions


nperm = 1000;
alpha = 0.05;
tail = 'twotail';
cluster_th = 0.05;

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
    n_subjects = 7:19;
    
    SubjectName_all = 'rsvp7-19';
    
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
            temp_Result.Within_Face(n_subject, :) = Result.Within_Face.mean;
            temp_Result.Within_Nonface(n_subject, :) = Result.Within_Nonface.mean;
            temp_Result.Between(n_subject, :) = Result.Between.mean;
        
            new_Param = Result.param;
        end
        
        clear Result;
        
        Result.param = new_Param;
        
        % Statistic significant analysis
        Result.param.stat.nperm = nperm;
        Result.param.stat.alpha = alpha;
        Result.param.stat.tail = tail;
        Result.param.stat.cluster_th = cluster_th;   %perform cluster size tests

        [SignificantTimes_AccyAll] = permutation_cluster_1sample(temp_Result.AccyAll - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Within_Face] = permutation_cluster_1sample(temp_Result.Within_Face - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Within_Nonface] = permutation_cluster_1sample(temp_Result.Within_Nonface - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Between] = permutation_cluster_1sample(temp_Result.Between - 50, nperm, cluster_th, alpha);
     
        Result.AccyAll.mean = mean(temp_Result.AccyAll);
        Result.AccyAll.std = std(temp_Result.AccyAll);
        Result.AccyAll.stat_time = SignificantTimes_AccyAll;
        
        Result.Within_Face.mean = mean(temp_Result.Within_Face);
        Result.Within_Face.std = std(temp_Result.Within_Face);
        Result.Within_Face.stat_time = SignificantTimes_Within_Face;
        
        Result.Within_Nonface.mean = mean(temp_Result.Within_Nonface);
        Result.Within_Nonface.std = std(temp_Result.Within_Nonface);
        Result.Within_Nonface.stat_time = SignificantTimes_Within_Nonface;
        
        Result.Between.mean = mean(temp_Result.Between);
        Result.Between.std = std(temp_Result.Between);
        Result.Between.stat_time = SignificantTimes_Between;
        
        Result.param.SubjectName = SubjectName_all;
        save([mat_location 'ACCY_' SubjectName_all '_speed_' num2str(speeds{i_speed}) '.mat'], 'Result');
    end
    
    if strcmp(iitt, 'iitt')
        for i_subject = n_subjects
            
            if i_subject == 9
                continue;
            end
            
            SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
            disp(['Subject = ' SubjectName]);
            n_subject = n_subject + 1;
            
            load([mat_location 'IITT_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat']);

            temp_Result.param = Result.param;

            temp_Result.AccyAll(n_subject, :, :) = Result.AccyAll.mean;
            temp_Result.Within_Face(n_subject, :, :) = Result.Within_Face.mean;
            temp_Result.Within_Nonface(n_subject, :, :) = Result.Within_Nonface.mean;
            temp_Result.Between(n_subject, :, :) = Result.Between.mean;
            
            new_Param = Result.param;
        end
        
        clear Result;
        
        Result.param = new_Param;
        
        % Statistic significant analysis
        Result.param.stat.nperm = nperm;
        Result.param.stat.alpha = alpha;
        Result.param.stat.tail = tail;
        Result.param.stat.cluster_th = cluster_th;   %perform cluster size tests

        [SignificantTimes_AccyAll] = permutation_cluster_1sample_2dim(temp_Result.AccyAll - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Within_Face] = permutation_cluster_1sample_2dim(temp_Result.Within_Face - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Within_Nonface] = permutation_cluster_1sample_2dim(temp_Result.Within_Nonface - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Between] = permutation_cluster_1sample_2dim(temp_Result.Between - 50, nperm, cluster_th, alpha);    
        
        Result.AccyAll.mean = squeeze(mean(temp_Result.AccyAll));
        Result.AccyAll.stat_time = SignificantTimes_AccyAll;
        
        Result.Within_Face.mean = squeeze(mean(temp_Result.Within_Face));
        Result.Within_Face.stat_time = SignificantTimes_Within_Face;
        
        Result.Within_Nonface.mean = squeeze(mean(temp_Result.Within_Nonface));
        Result.Within_Nonface.stat_time = SignificantTimes_Within_Nonface;
        
        Result.Between.mean = squeeze(mean(temp_Result.Between));
        Result.Between.stat_time = SignificantTimes_Between;
        
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
            temp_Result.Within_Face(n_subject, :) = Result.Within_Face.mean;
            temp_Result.Within_Nonface(n_subject, :) = Result.Within_Nonface.mean;
            temp_Result.Between(n_subject, :) = Result.Between.mean;
        
            new_Param = Result.param;
        end
        
        clear Result;
        
        Result.param = new_Param;
        
        % Statistic significant analysis
        Result.param.stat.nperm = nperm;
        Result.param.stat.alpha = alpha;
        Result.param.stat.tail = tail;
        Result.param.stat.cluster_th = cluster_th;   %perform cluster size tests

        [SignificantTimes_AccyAll] = permutation_cluster_1sample(temp_Result.AccyAll - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Within_Face] = permutation_cluster_1sample(temp_Result.Within_Face - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Within_Nonface] = permutation_cluster_1sample(temp_Result.Within_Nonface - 50, nperm, cluster_th, alpha);
        [SignificantTimes_Between] = permutation_cluster_1sample(temp_Result.Between - 50, nperm, cluster_th, alpha);
     
        Result.AccyAll.mean = mean(temp_Result.AccyAll);
        Result.AccyAll.std = std(temp_Result.AccyAll);
        Result.AccyAll.stat_time = SignificantTimes_AccyAll;
        
        Result.Within_Face.mean = mean(temp_Result.Within_Face);
        Result.Within_Face.std = std(temp_Result.Within_Face);
        Result.Within_Face.stat_time = SignificantTimes_Within_Face;
        
        Result.Within_Nonface.mean = mean(temp_Result.Within_Nonface);
        Result.Within_Nonface.std = std(temp_Result.Within_Nonface);
        Result.Within_Nonface.stat_time = SignificantTimes_Within_Nonface;
        
        Result.Between.mean = mean(temp_Result.Between);
        Result.Between.std = std(temp_Result.Between);
        Result.Between.stat_time = SignificantTimes_Between;
        
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
