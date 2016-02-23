% SVM Cross Classification
%===================================================================

clear; clc
ProjectName = 'rsvp';
SubjectName = 'rsvp_03';  % 'grating03 to grating 16'
iitt = 'ii';                % 'ii' 'iitt' --- image-image-time-time mode off/on
permutations = 'p100';       % 'p10'
group = 'groupall';    	% 'groupall' 'grouptest' 'group1'
clusterflag = '0';          % '0' for single pc, '1' for cluster
speeds = {1,2,3};

addpath(genpath('Functions')); % add path of functions

param.trial_bin_size = 49;  % SVM parameter, group size

%% parameters
parameters_classifer;
parameters_analysis;

%% Run SVM clissifer
tic;
for train_speed = 3:3
    
    condA_train = ['Face_' num2str(speeds{train_speed})];
    condB_train = ['Non-face_' num2str(speeds{train_speed})];
    param_train = param;
    param_train.onset_time = 0 - 5 * param_train.framesec * speeds{train_speed};
    param_train.offset_time = 0 + 6 * param_train.framesec * speeds{train_speed};
    param_train.speed = speeds{train_speed};
        
    for test_speed = 1:length(speeds)
        disp(['Train_Speed = ' num2str(speeds{train_speed}) ...
                ' Test_Speed = ' num2str(speeds{test_speed})]);
            
        condA_test = ['Face_' num2str(speeds{test_speed})];
        condB_test = ['Non-face_' num2str(speeds{test_speed})];
        
        param_test = param;
        param_test.onset_time = 0 - 5 * param_test.framesec * speeds{test_speed};
        param_test.offset_time = 0 + 6 * param_test.framesec * speeds{test_speed};
        param_test.speed = speeds{test_speed};

        [AccuracyMEG ,Weight,param_train, param_test] = svm_contrast_conditions_perm_classification(SubjectName,{num2str(condA_train)},{num2str(condB_train)},{num2str(condA_test)},{num2str(condB_test)}, param_train, param_test); 

       
        save(['Results/' SubjectName '/mat/Accuracy_train_' num2str(speeds{train_speed}) '_test_' num2str(speeds{test_speed})], 'AccuracyMEG','Weight','param_train','param_test');
    end
end
    
disp('All finished!');
toc
%closematlabpool;
