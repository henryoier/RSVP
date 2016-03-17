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

param.trial_bin_size = 7;  % SVM parameter, group size

%% parameters
parameters_classifer;
parameters_analysis;

%% Run SVM clissifer
tic;
for i_subject = 7:7
    SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
    disp(['Subject = ' SubjectName]);
    param.SubjectName = SubjectName;
    
    for i_speed = 1:2
        disp(['Speed = ' num2str(speeds{i_speed})]);
        param.onset_time = 0 - 5 * param.framesec * speeds{i_speed};
        param.offset_time = 0 + 6 * param.framesec * speeds{i_speed};
        param.speed = speeds{i_speed};

        for i_condA = 1:(condNum - 1)
            for i_condB = (i_condA + 1):condNum
                
                condA = speeds{i_speed} * 100 + i_condA;
                condB = speeds{i_speed} * 100 + i_condB;
                disp([num2str(condA) '_versus_' num2str(condB)]);

                param.condA = i_condA;
                param.condB = i_condB;
                
                if(strcmp(iitt,'ii')) 
                    [AccuracyMEG(i_condA,i_condB, :) ,Weight,param] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
                    save(['Results/' SubjectName '/mat/ACCY/Accuracy_' num2str(speeds{i_speed})], 'AccuracyMEG','param');
                end
                if(strcmp(iitt,'iitt')) 
                    [AccuracyIITT(i_condA,i_condB,:,:),Weight,param] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
                    save(['Results/' SubjectName '/mat/IITT/AccuracyIITT_' num2str(speeds{i_speed})], 'AccuracyIITT','param');
                end
            end
        end
        
        if strcmp(iitt, 'ii')
            AccuracyMEG(condNum,:,:) = zeros(condNum, length(param.Time));
            AccuracyMEG = permute(AccuracyMEG, [2 1 3]);
            save(['Results/' SubjectName '/mat/ACCY/Accuracy_' num2str(speeds{i_speed})], 'AccuracyMEG','param');
            clear AccuracyMEG;
        end
        
        if strcmp(iitt, 'iitt')
            AccuracyIITT(condNum,:,:,:) = zeros(condNum, length(param.Time), length(param.Time));
            AccuracyIITT = permute(AccuracyIITT, [2 1 3 4]);
            save(['Results/' SubjectName '/mat/IITT/AccuracyIITT_' num2str(speeds{i_speed})], 'AccuracyIITT','param');
            clear AccuracyIITT;
        end
    end
end
    
disp('All finished!');
toc
%closematlabpool;
