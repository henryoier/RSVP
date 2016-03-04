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
mat_location = ['/dataslow/sheng'];

addpath(genpath('Functions')); % add path of functions

%% Run SVM clissifer
tic;
for i_subject = 4:5
    SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
    disp(['Subject = ' SubjectName]);
 
    for i_speed = 2:length(speeds)
        disp(['Speed = ' num2str(speeds{i_speed})]);
        
        load('')
    end
end
    
disp('All finished!');
toc
%closematlabpool;
