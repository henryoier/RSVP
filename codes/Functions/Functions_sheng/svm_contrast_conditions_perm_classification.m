function [Accuracy, Weight, Time_train_out, Time_test_out] = svm_contrast_conditions_perm_classification(subject,conditionsA_train,conditionsB_train,conditionsA_test,conditionsB_test,param_train, param_test)
% function [accuracy,Time] = svm_contrast_conditions_perm(subject,conditionsA,conditionsB,param)
%
% Apply SVM classifier on MEG trials with supervised learning. Uses trial
% subaverages and permutations
%
% Example:
%   %parameters
%   param.brainstorm_db = 'D:\MYPROJECTS11\project_rapid_images_Molly_Carl\Data\HagmannRSVP\data\';
%   param.data_type = 'MEG';
%   param.smooth_size = 15;
%   param.num_permutations = 30;
%   param.trial_bin_size = 5;
%
% Author: Dimitrios Pantazis, Jingkai Chen

%% initialization
num_permutations = param_train.num_permutations;
trial_bin_size = param_train.trial_bin_size;
f_lowpass = param_train.f_lowpass;
brainstorm_db = param_train.brainstorm_db;
data_type = param_train.data_type;

% train data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load data (force equal number of trials per condition)
[trial_train,Time_train] = load_trials(brainstorm_db,subject,conditionsA_train,conditionsB_train,param_train);

ntimes_train = size(trial_train{1}{1},2);
ntrials_train = min([length(trial_train{1}) length(trial_train{2})]);
nchannels_train = size(trial_train{1}{1},1);

%% correct for baseline std
baseline_range = Time_train < param_train.onset_time;
for i = 1:2 %for both groups
    for j = 1:ntrials_train
        trial_train{i}{j} = trial_train{i}{j} ./ repmat( std(trial_train{i}{j}(:,baseline_range)')',1,ntimes_train );
    end
end

%get labels for train
nsamples_train = floor(ntrials_train/trial_bin_size);
samples_train = reshape([1:nsamples_train*trial_bin_size],trial_bin_size,nsamples_train)';
train_label = [ones(1,nsamples_train) 2*ones(1,nsamples_train)];
%test_label = [1 2];

%test data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load data (force equal number of trials per condition)
[trial_test, Time_test] = load_trials(brainstorm_db,subject,conditionsA_test,conditionsB_test,param_test);

ntimes_test = size(trial_test{1}{1},2);
ntrials_test = min([length(trial_test{1}) length(trial_test{2})]);
nchannels_test = size(trial_test{1}{1},1);

%correct for baseline std
baseline_range = Time_test < param_test.onset_time;
for i = 1:2 %for both groups
    for j = 1:ntrials_test
        trial_test{i}{j} = trial_test{i}{j} ./ repmat( std(trial_test{i}{j}(:,baseline_range)')',1,ntimes_test);
    end
end

Time_train_out = Time_train;
Time_test_out = Time_out;

%get labels for test
nsamples_test = floor(ntrials_test/trial_bin_size);
samples_test = reshape([1:nsamples_test*trial_bin_size],trial_bin_size,nsamples_test)';
test_label = [ones(1,nsamples_test) 2*ones(1,nsamples_test)];

if size(Time_train, 2) < size(Time_test, 2)
    ntimes = size(Time_train, 2);
    Time_test = find(Time_test >= Time_train(1, 1) & Time_test <= Time_train(1, ntimes));
    Time_train = 1:1:ntimes;
else
    ntimes = size(Time_test, 2);
    Time_train = find(Time_train >= Time_test(1, 1) & Time_train <= Time_test(1, ntimes));
    Time_test = 1:1:ntimes;
end
nchannels = nchannels_train;

%test_label = [1 2];
Weight_sum = zeros(nchannels, ntimes);
rng('shuffle'); % seeds the random number generator based on the current time

%% perform decoding
%matlabpool(2);
AccuracyMEG_sum = zeros(1, ntimes);

train_trialsA = zeros(nsamples_train,nchannels,ntimes);
train_trialsB = zeros(nsamples_train,nchannels,ntimes);
test_trialsA = zeros(nsamples_test,nchannels,ntimes);
test_trialsB = zeros(nsamples_test,nchannels,ntimes);

for p = 1:num_permutations

    %randomize samples
    perm_ndx_train = randperm(nsamples_train*trial_bin_size)';
    perm_samples_train = perm_ndx_train(samples_train);
    perm_ndx_test = randperm(nsamples_test*trial_bin_size)';
    perm_samples_test = perm_ndx_test(samples_test);
    
    %create train samples
    train_trialsA = average_structure2(trial_train{1}(perm_samples_train(1:nsamples_train,:)));
    train_trialsB = average_structure2(trial_train{2}(perm_samples_train(1:nsamples_train,:)));
    train_trials = [train_trialsA;train_trialsB];

    %create test samples
    test_trialsA = average_structure2(trial_test{1}(perm_samples_test(1:nsamples_test,:)));
    test_trialsB = average_structure2(trial_test{2}(perm_samples_test(1:nsamples_test,:)));
    test_trials = [test_trialsA;test_trialsB];
    
    if (p==1) param_train.SVM_vector_length = size(train_trials, 2);end
    for tndx = 1:ntimes
        
        %model = svmtrain(train_trials(:,:,tndx), train_label','method','LS');
        %group = svmclassify(model,test_trials(:,:,tndx));
        %accuracy = sum([test_label - group']==0)/2 * 100;
        %Accuracy(p,tndx) = accuracy;
        
        %use train trials
        model = svmtrain(train_label',train_trials(:,:,tndx),'-s 0 -t 0 -q');
        
        %use test trials
        [predicted_label, Accuracy_tmp, decision_values] = svmpredict(test_label', test_trials(:,:,tndx), model);
        AccuracyMEG_sum(tndx) = AccuracyMEG_sum(tndx) + Accuracy_tmp(1);
        
        Weight_sum(:, tndx) = Weight_sum(:,tndx) + (model.sv_coef' * model.SVs)';
    end
end
%matlabpool close

%save and plot results
Accuracy = AccuracyMEG_sum / num_permutations;
Weight = Weight_sum / num_permutations;
