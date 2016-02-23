function [Accuracy,Weight,param_out] = svm_contrast_conditions_perm(subject,conditionsA,conditionsB,param)
% function [Accuracy,Weight,param_out] = svm_contrast_conditions_perm(subject,conditionsA,conditionsB,param)
%
% Apply SVM classifier on MEG trials with supervised learning. Uses trial subaverages and permutations
%
% % Example:
%   clear; clc;
%   subject = 'rsvp_01';
%   conditionsA = {'Face_1'};
%   conditionsB = {'Non-face_1'};
%   param.brainstorm_db = '/dataslow/sheng/rsvp/brainstorm_db/rsvp/data';
%   param.data_type = 'MEG';
%   param.num_permutations = 100;
%   param.trial_bin_size = 25;
%   param.f_lowpass = 30;
%   param.iitt = 'ii';
%   param.trial_number = 300;
%
%   Author: Dimitrios Pantazis & Mingtong Fang & Sheng Qin

% initialize
num_permutations = param.num_permutations;
brainstorm_db = param.brainstorm_db;
trial_bin_size = param.trial_bin_size;

%% load data (force equal number of trials per condition) (single float)
[trial_raw,param] = load_trials(brainstorm_db,subject,conditionsA,conditionsB,param);
Time = param.Time;

ntimes = size(trial_raw{1}{1},2);
ntrials = min([length(trial_raw{1}) length(trial_raw{2})]);
if ntrials < param.trial_number
    param.trial_number = ntrials;
end

%% correct for baseline std
baseline_range = Time < param.onset_time;
for i = 1:2 %for both groups
    for j = 1:ntrials
        trial_raw{i}{j} = trial_raw{i}{j} ./ repmat( std(trial_raw{i}{j}(:,baseline_range)')',1,ntimes );
    end
end
clear i j;

nchannels = size(trial_raw{1}{1}, 1);

%% get labels for train and test groups
nsamples = floor(ntrials/param.trial_bin_size);
param.trial_cluster_number = nsamples;
samples = reshape([1:nsamples*trial_bin_size],trial_bin_size,nsamples)';
train_label = [ones(1,nsamples-1) 2*ones(1,nsamples-1)];
test_label = [1 2];

if strcmp(param.iitt,'ii') AccuracyMEG_sum = zeros(1,ntimes); end
if strcmp(param.iitt,'iitt') AccuracyIITT_sum = zeros(ntimes,ntimes); end
Weight_sum = zeros(nchannels,ntimes);
rng('shuffle'); % seeds the random number generator based on the current time

%% perform decoding
for p = 1:num_permutations
    if rem(p,10)==1
        disp(['permutaions: ' num2str(p) ' / ' num2str(num_permutations)]);
    end

    %randomize samples
    perm_ndxA = randperm(nsamples*trial_bin_size);
    perm_ndxB = randperm(nsamples*trial_bin_size);
    perm_samplesA = perm_ndxA(samples);
    perm_samplesB = perm_ndxB(samples);
    
    %create train samples: 6_train_number * 306_sensors * 1901_Time
    train_trialsA = average_structure2(trial_raw{1}(perm_samplesA(1:nsamples-1,:)));
    train_trialsB = average_structure2(trial_raw{2}(perm_samplesB(1:nsamples-1,:)));
    train_trials = [train_trialsA;train_trialsB];
    %create test samples
    test_trialsA = double(average_structure(trial_raw{1}(perm_samplesA(end,:))));
    test_trialsB = double(average_structure(trial_raw{2}(perm_samplesB(end,:))));
    test_trials = reshape([test_trialsA test_trialsB],[nchannels,ntimes,2]);
    test_trials = permute(test_trials,[3 1 2]);
         
    if (p == 1) param.SVM_vector_length = size(train_trials,2); end
    parfor tndx_train = 1:ntimes
        
        if strcmp(param.iitt,'ii')  % ncondtitions-ncondtitions-time matric
            % libsvm-3.18
            model = svmtrain(train_label',train_trials(:,:,tndx_train),'-s 0 -t 0 -q');
            [predicted_label, Accuracy_tmp, decision_values] = svmpredict(test_label', test_trials(:,:,tndx_train), model);
            AccuracyMEG_sum(tndx_train) = AccuracyMEG_sum(tndx_train) + Accuracy_tmp(1);
        end
        
%         if strcmp(param.iitt,'iitt') % ncondtitions-ncondtitions-time-time matric
%             model = svmtrain(train_label',train_trials(:,:,tndx_train),'-s 0 -t 0 -q');
%             for tndx_test = 1:ntimes
%                 [predicted_label, Accuracy_tmp, decision_values] = svmpredict(test_label', test_trials(:,:,tndx_test), model);
%                 AccuracyIITT_sum(tndx_train,tndx_test) = AccuracyIITT_sum(tndx_train,tndx_test) + Accuracy_tmp(1);
%             end
%         end

        % save weight parameters of SVM
        Weight_sum(:,tndx_train) = Weight_sum(:,tndx_train) + (model.sv_coef' * model.SVs)';
%         model.sv_coef' * model.SVs * test_trials(:,:,tndx_train)' - 1; % group 1 if value < 1;
    end
end


if strcmp(param.iitt,'ii') Accuracy = AccuracyMEG_sum / num_permutations; end
if strcmp(param.iitt,'iitt') Accuracy = AccuracyIITT_sum / num_permutations; end
Weight = Weight_sum / num_permutations;
param_out = param;
