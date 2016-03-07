%
% Transform original resutls to ACCY structure and save
% Modified in analytical groups
%==========================================================================
% process:
%       one decoding accuracy file
% ouput:
%       one decoding accuracy file with different structure
%==========================================================================
% Written by Sheng Qin (shengqin [AT] mit (DOT) edu)
% 
% Version 1.0 -- Mar. 2016 
%
clear; clc
ProjectName = 'rsvp';  % 'grating03 to grating 16'
iitt = 'ii';                % 'ii' 'iitt' --- image-image-time-time mode off/on
speeds = {1,2};
condNum = 24;
file_location = ['/dataslow/sheng/'];
addpath(genpath('Functions')); % add path of functions

if strcmp(iitt, 'ii')
    savefile_location = [file_location ProjectName '/Results/total/ACCY/mat/'];
else
end

%% Merge all results
tic;
for i_subject = 4:5
    SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
    disp(['Subject = ' SubjectName]);
    mat_location = [file_location ProjectName '/Results/' SubjectName '/mat/'];
    
    for i_speed = 1:length(speeds)
        disp(['Speed = ' num2str(speeds{i_speed})]);    
        load([mat_location 'Accuracy_' num2str(speeds{i_speed}) '.mat']);
        
        Result.param = param;
        Result.weight = Weight;
      
        %% face vs non-face (between)
        selected_between = [zeros(condNum/2) zeros(condNum/2);ones(condNum/2) zeros(condNum/2)];
        n_selected_between = sum(sum(selected_between));

        %% within
        selected_all = tril(ones(condNum), -1);
        selected_within =  selected_all - selected_between;
        selected_within_face = [selected_within(1:condNum/2,1:condNum/2) zeros(condNum/2);
            zeros(condNum/2) zeros(condNum/2)];
        selected_within_nonface = selected_within - selected_within_face;
        
        n_selected_within_face = sum(sum(selected_within_face));
        n_selected_within_nonface = sum(sum(selected_within_nonface));
        n_selected_all = sum(sum(selected_all));

        %% transform accuracy
        for t = 1:size(AccuracyMEG.matrix, 3)
            Result.AccyAll.matrix(:,:,t) = AccuracyMEG.matrix(:,:,t);
            Result.Within_Face.matrix(:,:,t) = AccuracyMEG.matrix(:,:,t) .* selected_within_face;
            Result.Within_Nonface.matrix(:,:,t) = AccuracyMEG.matrix(:,:,t) .* selected_within_nonface;
            Result.Between.matrix(:,:,t) = AccuracyMEG.matrix(:,:,t) .* selected_between;

            Result.AccyAll.mean(:,t) = squeeze(sum(sum(Result.AccyAll.matrix(:,:,t)))) / n_selected_all;
            Result.Within_Face.mean(:,t) = squeeze(sum(sum(Result.Within_Face.matrix(:,:,t)))) / n_selected_within_face;
            Result.Within_Nonface.mean(:,t) = squeeze(sum(sum(Result.Within_Nonface.matrix(:,:,t)))) / n_selected_within_nonface;
            Result.Between.mean(:,t) = squeeze(sum(sum(Result.Between.matrix(:,:,t)))) / n_selected_between;
        end
        
        save([savefile_location 'ACCY_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat'], 'Result');
        clear Result;
    end
end
    
disp('All finished!');
toc
%closematlabpool;
