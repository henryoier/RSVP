function Step01_SVMClassifier()
%function Step01_SVMClassifier(ProjectName,SubjectName,RhythmMode,SensorMode,iitt,permutations,group,clusterflag)
% SVM Decoding, adapted from Mingtong, RM Cichy & D Pantazis
%
% Step01_SVMClassifier(ProjectName,SubjectName,RhythmMode,SensorMode,iitt,permutations,group,clusterflag) 
% 
%===================================================================
%   Input:
%       ProjectName     -   default is rsvp
%       SubjectName     -   rsvp_01 - rsvp_XX 
%       iitt            -   'ii', outputs image(condition)-image(condition) decoding accuracy;
%                           'iitt', outputs image-image-time-time decoding accuracy
%       permutations    -   SVM parameter
%       group           -   split all pairs into several groups, then run each group separately
%       clusterflag     -   run scripts locally or OPENMIND computer cluster
%
%--------------------------------------------------------------------
%   Output:
%       mat files       -   decoding accuracy & SVM weight distribution & parameters
%       AccuracyMEG     -   decoding accuracy, condition * condition * time = 6 * 6 * 1901ms
%                           / AccuracyIITT: decoding accuracy, condition * condition * time * time = 6 * 6 * 1901ms * 1901ms
%       Weight          -   SVM parameter, condition * condition * time (* time) = 6 * 6 * 1901ms (* 1901ms)
% 
%====================================================================
%   Version 1.0 -- Feb./2016
%   
%   Writtlen by Sheng Qin(shengqin [AT] mit (DOT) edu)
%

clear; clc
ProjectName = 'rsvp';  % 'grating03 to grating 16'
iitt = 'ii';                % 'ii' 'iitt' --- image-image-time-time mode off/on
permutations = 'p100';       % 'p10'
% 'groupall' 'grouptest' 'group1'
clusterflag = '0';          % '0' for single pc, '1' for cluster
speeds = {1,2};
condNum = 24;

addpath(genpath('Functions')); % add path of functions
addpath(genpath('/dataslow/sheng/Previous Work By Mingtong/libsvm-3.18'));

param.trial_bin_size = 6;  % SVM parameter, group size

%% parameters
parameters_classifer;
parameters_analysis;

condAs = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,18,18,18,18,18,18,19,19,19,19,19,20,20,20,20,21,21,21,22,22,23];
condBs = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,11,12,13,14,15,16,17,18,19,20,21,22,23,24,12,13,14,15,16,17,18,19,20,21,22,23,24,13,14,15,16,17,18,19,20,21,22,23,24,14,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,16,17,18,19,20,21,22,23,24,17,18,19,20,21,22,23,24,18,19,20,21,22,23,24,19,20,21,22,23,24,20,21,22,23,24,21,22,23,24,22,23,24,23,24,24];
%% Run SVM clissifer
tic;
for i_subject = 19:19
    SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
    disp(['Subject = ' SubjectName]);
    param.SubjectName = SubjectName;
    
    for i_speed = 1:2
        disp(['Speed = ' num2str(speeds{i_speed})]);
        param.onset_time = 0 - 5 * param.framesec * speeds{i_speed};
        param.offset_time = 0 + 6 * param.framesec * speeds{i_speed};
        param.speed = speeds{i_speed};

        for cond = 1:1
            i_condA = condAs(cond);
            i_condB = condBs(cond);
            
            condA = speeds{i_speed} * 100 + i_condA;
            condB = speeds{i_speed} * 100 + i_condB;
            disp([num2str(condA) '_versus_' num2str(condB)]);

            if(strcmp(iitt,'ii')) 
                [AccuracyMEG_temp(cond, :),Weight, Time] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
            end
            if(strcmp(iitt,'iitt')) 
                [AccuracyIITT_temp(cond,:,:),Weight, Time] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
            end
            param.Time = Time;
        end
        
        parfor cond = 2:length(condAs)
            i_condA = condAs(cond);
            i_condB = condBs(cond);
            
            condA = speeds{i_speed} * 100 + i_condA;
            condB = speeds{i_speed} * 100 + i_condB;
            disp([num2str(condA) '_versus_' num2str(condB)]);

            if(strcmp(iitt,'ii')) 
                [AccuracyMEG_temp(cond, :),Weight, other_Time] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
            end
            if(strcmp(iitt,'iitt')) 
                [AccuracyIITT_temp(cond,:,:),Weight, other_Time] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
            end
        end
        
        if strcmp(iitt, 'ii')
            AccuracyMEG = zeros(condNum, condNum, length(param.Time));
            cond = 0;
            for i_condA = 1:(condNum - 1)
                for i_condB = (i_condA + 1):condNum
                    cond = cond + 1;
                    AccuracyMEG(i_condA, i_condB, :) = AccuracyMEG_temp(cond, :);
                end
            end
            AccuracyMEG = permute(AccuracyMEG, [2 1 3]);
%             AccuracyMEG(condNum,:,:) = zeros(condNum, length(param.Time));
%             AccuracyMEG = permute(AccuracyMEG, [2 1 3]);
             save(['Results/' SubjectName '/mat/ACCY/Accuracy_' num2str(speeds{i_speed})], 'AccuracyMEG','param');
             clear AccuracyMEG AccuracyMEG_temp;
        end
%         
        if strcmp(iitt, 'iitt')
            AccuracyIITT = zeros(condNum, condNum, length(param.Time), length(param.Time));
            cond = 0;
            for i_condA = 1:(condNum - 1)
                for i_condB = (i_condA + 1):condNum
                    cond = cond + 1;
                    AccuracyMEG(i_condA, i_condB, :, :) = AccuracyMEG_temp(cond, :, :);
                end
            end
%             AccuracyIITT(condNum,:,:,:) = zeros(condNum, length(param.Time), length(param.Time));
%             AccuracyIITT = permute(AccuracyIITT, [2 1 3 4]);
             save(['Results/' SubjectName '/mat/IITT/AccuracyIITT_' num2str(speeds{i_speed})], 'AccuracyIITT','param');
             clear AccuracyIITT AccuracyIITT_temp;
        end

    end
end
    
disp('All finished!');
toc
%closematlabpool;
