function [trial, Time] = load_trials(brainstorm_db,subject,conditionsA,conditionsB,param,ndx_trials)
%   [DESCRIPTION]
%
%   [trial, Time] = load_trials(brainstorm_db,subject,conditionsA,conditionsB,param,ndx_trials)
% 
%=============================================
%   input:
%       brainstorm_db   -   brainstorm database
%       subject         -   subject name
%       conditionA/B    -   conditions in brainstorm database, eg: groupA = {'11a' '13a'};
%                           (the function forces equal number of trials in each group)
%       data_type       -   'MEG','GRAD','MAG','EEG', or 'MEG EEG' etc
%       f_lowpass       -   low pass frequency for data filtering
% 
%       ndx_trials      -   [1:100]; % [1:100]: select first 100 trials; []: select all
%
%----------------------------------------------
%    output:
%       trial           -   trial number
%       param           -   parameters
%        
%============================================== 
%   example:
%
%========================================
%   Adapted from Mingtong
%
%   version 1.0 -- Feb./2016
%
%   written by Sheng Qin(shengqin [AT] mit (DOT) edu)

% handling wrong parameter
if ~exist('ndx_trials')
    ndx_trials = [];
end

data_type = param.data_type;
f_lowpass = param.f_lowpass;

flag_B = ~isempty(conditionsB{1}); % whether to load the second condition trials

%% find proper channels

% get channel index (assume common channel structure per subject)

channelfile = [brainstorm_db, '/', subject, '/@default_study/channel_vectorview306_acc1.mat'];
file_channel = load(channelfile);
channel_index = get_channel_index(file_channel,data_type);

%% get filenames
n_conditions = length(conditionsA);
filesA = [];
filesB = [];

for c = 1:n_conditions
    
    fA = dir([brainstorm_db '/' subject '/' conditionsA{c} '/*trial*.mat']);
    
    %if (~size(fA,1)) error('myError: No files while loading trials A'); end
    
    if(flag_B)
        fB = dir([brainstorm_db '/' subject '/' conditionsB{c} '/*trial*.mat']);
    end
    
    if(flag_B) 
        n(c) = min([length(fA) length(fB)]); %force number of files to be the same
    else
        n(c) = length(fA);
    end
    
    if (length(ndx_trials))
        n(c) = length(ndx_trials);
        fA = fA(ndx_trials);
        if(flag_B)
            fB = fB(ndx_trials); 
        end
    end
    
    for i = 1:n(c)
        fA(i).dir = [brainstorm_db '/' subject '/' conditionsA{c} '/'];
        if(flag_B)
            fB(i).dir = [brainstorm_db '/' subject '/' conditionsB{c} '/']; 
        end
    end
    filesA = [filesA ; fA(1:n(c))];
    if(flag_B) filesB = [filesB ; fB(1:n(c))]; end
end

%% design low pass filter
tempA = load([filesA(1).dir filesA(1).name]);
order = max(100,round(size(tempA.Time,2)/10)); %keep one 10th of the timepoints as model order
Fs = 1000; %hard set sampling frequency 1kHz
h = filter_design('lowpass',f_lowpass,order,Fs,0);

%% load data
for f = 1:length(filesA)
    %disp(['Loading file ' num2str(f) ' of ' num2str(length(filesA))]);
    tempA=load([filesA(f).dir filesA(f).name]);
    if(flag_B) 
        tempB=load([filesB(f).dir filesB(f).name]); 
    end
    
    trial{1}{f} = filter_apply(tempA.F(channel_index,:),h); %smooth over time
    trial{1}{f} = single(trial{1}{f});
    if(flag_B)
        trial{2}{f} = filter_apply(tempB.F(channel_index,:),h); %smooth over time   
        trial{2}{f} = single(trial{2}{f});
    end
end

Time = tempA.Time;

if(~flag_B)
    trial = trial{1};
end