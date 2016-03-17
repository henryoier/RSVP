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
    savefile_location = [file_location ProjectName '/Results/total/IITT/mat/'];
end

%% Merge all results
tic;
for i_subject = 7:7
    SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
    disp(['Subject = ' SubjectName]);
    if strcmp(iitt, 'ii')
        mat_location = [file_location ProjectName '/Results/' SubjectName '/mat/ACCY/'];
    else
        mat_location = [file_location ProjectName '/Results/' SubjectName '/mat/IITT/'];
    end
    
    for i_speed = 1:1
        disp(['Speed = ' num2str(speeds{i_speed})]);    
        
        %% Time Decoding
        if strcmp(iitt, 'ii')
            load([mat_location 'Accuracy_' num2str(speeds{i_speed}) '.mat']);

            Result.param = param;

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
            for t = 1:size(AccuracyMEG, 3)
                Result.AccyAll.matrix(:,:,t) = AccuracyMEG(:,:,t);
                Result.Within_Face.matrix(:,:,t) = AccuracyMEG(:,:,t) .* selected_within_face;
                Result.Within_Nonface.matrix(:,:,t) = AccuracyMEG(:,:,t) .* selected_within_nonface;
                Result.Between.matrix(:,:,t) = AccuracyMEG(:,:,t) .* selected_between;

                Result.AccyAll.mean(:,t) = squeeze(sum(sum(Result.AccyAll.matrix(:,:,t)))) / n_selected_all;
                Result.Within_Face.mean(:,t) = squeeze(sum(sum(Result.Within_Face.matrix(:,:,t)))) / n_selected_within_face;
                Result.Within_Nonface.mean(:,t) = squeeze(sum(sum(Result.Within_Nonface.matrix(:,:,t)))) / n_selected_within_nonface;
                Result.Between.mean(:,t) = squeeze(sum(sum(Result.Between.matrix(:,:,t)))) / n_selected_between;
            end

            save([savefile_location 'ACCY_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat'], 'Result');
            clear Result;
        else
            load([mat_location 'AccuracyIITT_' num2str(speeds{i_speed}) '.mat']);

            Result.param = param;

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
            
            Accy = zeros(condNum, condNum, length(param.Time), length(param.Time));
            Within_Face = zeros(condNum, condNum, length(param.Time), length(param.Time));
            Within_Nonface = zeros(condNum, condNum, length(param.Time), length(param.Time));
            Between = zeros(condNum, condNum, length(param.Time), length(param.Time));
            
            Accy_mean = zeros(length(param.Time), length(param.Time));
            Within_Face_mean = zeros(length(param.Time), length(param.Time));
            Within_Nonface_mean = zeros(length(param.Time), length(param.Time));
            Between_mean = zeros(length(param.Time), length(param.Time));
            %% transform accuracy
            for t1 = 1:size(AccuracyIITT, 3)
                if ~rem(t1, 100)
                    disp(['t1 = ' num2str(t1)]);
                end
                    
                for t2 = 1:size(AccuracyIITT, 4)
                    Accy(:,:,t1,t2) = AccuracyIITT(:,:,t1,t2);
                    Within_Face(:,:,t1,t2) =  AccuracyIITT(:,:,t1,t2) .* selected_within_face;
                    Within_Nonface(:,:,t1,t2) = AccuracyIITT(:,:,t1,t2) .* selected_within_nonface;
                    Between(:,:,t1,t2) =  AccuracyIITT(:,:,t1,t2) .* selected_between;
                    
                    Accy_mean(t1,t2) = squeeze(sum(sum(Accy(:,:,t1,t2)))) / n_selected_all;
                    Within_Face_mean(t1,t2) = squeeze(sum(sum(Within_Face(:,:,t1,t2)))) / n_selected_within_face;
                    Within_Nonface_mean(t1,t2) = squeeze(sum(sum(Within_Nonface(:,:,t1,t2)))) / n_selected_within_nonface;
                    Between_mean(t1,t2) = squeeze(sum(sum(Between(:,:,t1,t2)))) / n_selected_between;
                 
%                     Result.AccyAll.matrix(:,:,t1,t2) = AccuracyIITT(:,:,t1,t2);
%                     Result.Within_Face.matrix(:,:,t1,t2) = AccuracyIITT(:,:,t1,t2) .* selected_within_face;
%                     Result.Within_Nonface.matrix(:,:,t1,t2) = AccuracyIITT(:,:,t1,t2) .* selected_within_nonface;
%                     Result.Between.matrix(:,:,t1,t2) = AccuracyIITT(:,:,t1,t2) .* selected_between;
% 
%                     Result.AccyAll.mean(t1,t2) = squeeze(sum(sum(Result.AccyAll.matrix(:,:,t1,t2)))) / n_selected_all;
%                     Result.Within_Face.mean(t1,t2) = squeeze(sum(sum(Result.Within_Face.matrix(:,:,t1,t2)))) / n_selected_within_face;
%                     Result.Within_Nonface.mean(t1,t2) = squeeze(sum(sum(Result.Within_Nonface.matrix(:,:,t1,t2)))) / n_selected_within_nonface;
%                     Result.Between.mean(t1,t2) = squeeze(sum(sum(Result.Between.matrix(:,:,t1,t2)))) / n_selected_between;
               end
            end
            
            Result.AccyAll.matrix = Accy;
            Result.Within_Face.matrix = Within_Face;
            Result.Within_Nonface.matrix = Within_Nonface;
            Result.Between.matrix = Between;
            
            Result.AccyAll.mean = Accy_mean;
            Result.Within_Face.mean = Within_Face_mean;
            Result.Within_Nonface.mean = Within_Nonface_mean;
            Result.Between.mean = Between_mean;
            
            clear Accy Accy_mean Within_Face Within_Face_mean Within_Nonface Within_Nonface_mean Between Between_mean;
            save([savefile_location 'IITT_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat'], 'Result');
            clear Result;
        end
    end
end
    
disp('All finished!');
toc
%closematlabpool;
