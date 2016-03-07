
function compute_subject_accuracy_between_within_classification(sub,permutations,special_tag)
% sub : distinguish SubjectName, 4, 5, 8, 10, 11, 12, 13, 14, 15, 16, 17,
% 18, 19, 21, 22, 23
% permutations : times of SVM computing
% permu_idx : an index for seeds
% analysis_label:
%   'individual' : bin_size unchanged, [ 8 * 9 * Time ] * 2 task,
%   'task' : bin_size = bin_size / 9, 1 *Time
%   'identity' : bin_size = bin_size / 3, [ 2 * 3 * Time] * 2 task
%   'gaze' : bin_size = bin_size / 3, [ 2 * 3 * Time] * 2 task
% special_tag : designed by users

decoding_pool = {'identity', 'gaze'};

% Initialization
stimuli_num = 9;
permu_idx = '1';
data_type = 'MEG';
bin_size = 9;% bin_size : the number of each average group
addpath(genpath(pwd));% add path to current folder
SubjectName = ['face_' num2str(str2num(sub),'%02d')];% generate SubjectName

% SVM parameters Initialization
%param.brainstorm_db = '/dataslow/jingkai/JingLi/brainstorm_db/face2/data/';
param.brainstorm_db = '/datafast/jingkai/brainstorm_db/face_jingkai/data/';
param.data_type = data_type;
param.f_lowpass = 30;
param.num_permutations = str2num(permutations);
param.trial_bin_size = bin_size;
param.stimuli_num = stimuli_num;

param.trial_bin_size = bin_size;
identity_o1 = [1,2,3,4,5,6,7,8,9];
identity_o2 = identity_o1 + stimuli_num;
identity_order = [identity_o1,identity_o2];% gaze_is =[1~18]
gaze_o1 = [1,4,7,2,5,8,3,6,9];
gaze_o2 = gaze_o1 + stimuli_num;
gaze_order = [gaze_o1,gaze_o2];
order(1,:) = identity_order;
order(2,:) = gaze_order;

% for decoding_number = 1:length(decoding_pool)
%     for groupA = 1:3
%             a = clock;% get current time
%             seed = str2num(permu_idx)*floor(a(6));% generate random see
%             for groupB = 1:(groupA-1)
%                 disp(['subject' sub ' task' num2str(decoding_number) ' feature' num2str(groupA) '_vs_feature' num2str(groupB)]);
%                 for x_memberA = 1:3 %task1_memberA
%                     for y_memberA = 1:3 %task2_memberA
%                         for x_memberB = 1:3
%                             for y_memberB = 1:3
%                                 [Accuracy(decoding_number,groupA,groupB,x_memberA,y_memberA,x_memberB,y_memberB,:),Time] = svm_contrast_conditions_perm_classification(SubjectName,{num2str(order(decoding_number,3*(groupA-1)+x_memberA))},{num2str(order(decoding_number,3*(groupB-1)+x_memberB))},{num2str(order(decoding_number,3*(groupA-1)+y_memberA+9))},{num2str(order(decoding_number,3*(groupB-1)+y_memberB+9))},param);                    
%                             end
%                         end
%                     end
%                 end
%             end
%     end
% end

for decoding_number = 1:2
    for groupA = 1:9
        a = clock;% get current time
        seed = str2num(permu_idx)*floor(a(6));% generate random see
        for groupB = 1:(groupA-1) 
            condA_train = {num2str(order(decoding_number,groupA))};
            condB_train = {num2str(order(decoding_number,groupB))};
            condA_test = {num2str(order(decoding_number,groupA+9))};
            condB_test = {num2str(order(decoding_number,groupB+9))};
            disp(['subject' sub ' task' num2str(decoding_number) ' feature' num2str(groupA) '_vs_feature' num2str(groupB)]);
            [Accuracy(decoding_number,groupA,groupB,:),Time] = svm_contrast_conditions_perm_classification(SubjectName,condA_train,condB_train,condA_test,condB_test,param);                    
        end
    end
end
 
save(['/home/jingkai/Documents/MATLAB/Jingkai_Chen/Analysis_scripts/classifier/Results_c/Accuracy_LibSVM_Sub' num2str(str2num(sub),'%02d') '_' 'MEG' '_classification_reverse_' 'p' permutations '_' special_tag '_between&within.mat'],'Accuracy','param','Time');

