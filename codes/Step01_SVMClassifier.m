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
ProjectName = 'rsvp';
SubjectName = 'rsvp_01';  % 'grating03 to grating 16'
iitt = 'ii';                % 'ii' 'iitt' --- image-image-time-time mode off/on
permutations = 'p1000';       % 'p10'
group = 'groupall';    	% 'groupall' 'grouptest' 'group1'
clusterflag = '0';          % '0' for single pc, '1' for cluster
speeds = {1,3,6,10};

addpath(genpath('Functions')); % add path of functions

param.trial_bin_size = 25;  % SVM parameter, group size

%% parameters
parameters_classifer;
parameters_analysis;

%% Run SVM clissifer
tic;
disp(['Subject = ' SubjectName]);
for i_speed = 1:length(speeds)
    disp(['Speed = ' i_speed]);
    condA = ['Face_' num2str(speeds{i_speed})];
    condB = ['Non-face_' num2str(speeds{i_speed})];
    
    param.onset_time = 0 - 5 * param.framesec * speeds{i_speed};
    param.offset_time = 0 + 6 * param.framesec * speeds{i_speed};
    param.speed = speeds{i_speed};
    
    if(strcmp(iitt,'ii')) 
        [AccuracyMEG ,Weight,param] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
    end
    if(strcmp(iitt,'iitt')) 
        [AccuracyIITT,Weight,param] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
    end
    save(['Results/Accuracy_' num2str(speeds{i_speed})], 'AccuracyMEG','Weight','param');
end
    
disp('All finished!');
toc
%closematlabpool;
