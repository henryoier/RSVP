% SVM Cross Classification
%===================================================================

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
for i_subject = 7:18
    SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
    disp(['Subject = ' SubjectName]);
    param.SubjectName = SubjectName;
    
    for train_speed = 1:2
        disp(['Speed = ' num2str(speeds{train_speed})]);
        param_train = param;
        param_train.onset_time = 0 - 5 * param_train.framesec * speeds{train_speed};
        param_train.offset_time = 0 + 6 * param_train.framesec * speeds{train_speed};
        param_train.speed = speeds{train_speed};
        
        for test_speed = 1:2
            if test_speed == train_speed
                continue;
            end
            disp(['Speed = ' num2str(speeds{test_speed})]);
            param_test = param;
            param_test.onset_time = 0 - 5 * param_test.framesec * speeds{test_speed};
            param_test.offset_time = 0 + 6 * param_test.framesec * speeds{test_speed};
            param_test.speed = speeds{test_speed};
            
            for cond = 1:1
                i_condA = condAs(cond);
                i_condB = condBs(cond);

                condA_train = speeds{train_speed} * 100 + i_condA;
                condB_train = speeds{train_speed} * 100 + i_condB;
                condA_test = speeds{test_speed} * 100 + i_condA;
                condB_test = speeds{test_speed} * 100 + i_condB;
                
                if(strcmp(iitt,'ii')) 
                    [AccuracyMEG_temp(cond, :),Weight, Time_train, Time_test] = svm_contrast_conditions_perm_classification(SubjectName,{num2str(condA_train)},{num2str(condB_train)},{num2str(condA_test)},{num2str(condB_test)}, param_train, param_test);  
                end
                param_train.Time = Time_train;
                param_test.Time = Time_test;
            end

            parfor cond = 2:length(condAs)
                i_condA = condAs(cond);
                i_condB = condBs(cond);

                condA_train = speeds{train_speed} * 100 + i_condA;
                condB_train = speeds{train_speed} * 100 + i_condB;
                condA_test = speeds{test_speed} * 100 + i_condA;
                condB_test = speeds{test_speed} * 100 + i_condB;

                disp([num2str(condA_train) '_versus_' num2str(condB_train)]);
                if(strcmp(iitt,'ii')) 
                    [AccuracyMEG_temp(cond, :),Weight, otherTime] = svm_contrast_conditions_perm_classification(SubjectName,{num2str(condA_train)},{num2str(condB_train)},{num2str(condA_test)},{num2str(condB_test)}, param_train, param_test);  
                end
            end

            if strcmp(iitt, 'ii')
                AccuracyMEG = zeros(condNum, condNum, size(AccuracyMEG_temp, 2));
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
                 mkdir(['Results/' SubjectName '/mat/'],'CROSS');
                 save(['Results/' SubjectName '/mat/CROSS/Cross_train_' num2str(speeds{train_speed}) '_test_' num2str(speeds{test_speed})], 'AccuracyMEG','param_train','param_test');
                 clear AccuracyMEG AccuracyMEG_temp;
            end
        end
    end
end
    
disp('All finished!');
toc
%closematlabpool;

