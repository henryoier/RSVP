%
% Transform original IITT resutls to IITT structure and save
% Modified in analytical groups
%==========================================================================
% process:
%       one Time-Time decoding accuracy file
% ouput:
%       one Time-Time decoding accuracy file with different structure
%==========================================================================
% Written by Sheng Qin (shengqin [AT] mit (DOT) edu)
% 
% Version 1.0 -- Mar. 2016 
%
clear; clc
ProjectName = 'rsvp';  % 'rsvp_04 to rsvp..'
iitt = 'iitt';                % 'ii' 'iitt' --- image-image-time-time mode off/on
speeds = {1,2};
condNum = 24;
file_location = ['/dataslow/sheng/'];
addpath(genpath('Functions')); % add path of functions

condAs = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,18,18,18,18,18,18,19,19,19,19,19,20,20,20,20,21,21,21,22,22,23];
condBs = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,11,12,13,14,15,16,17,18,19,20,21,22,23,24,12,13,14,15,16,17,18,19,20,21,22,23,24,13,14,15,16,17,18,19,20,21,22,23,24,14,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,16,17,18,19,20,21,22,23,24,17,18,19,20,21,22,23,24,18,19,20,21,22,23,24,19,20,21,22,23,24,20,21,22,23,24,21,22,23,24,22,23,24,23,24,24];

%% Merge all IITT results
tic;
for i_subject = 19:19
    SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
    disp(['Subject = ' SubjectName]);
    
    mat_location = [file_location ProjectName '/Results/' SubjectName '/mat/IITT/'];
    
    for i_speed = 1:2
        disp(['Speed = ' num2str(speeds{i_speed})]);
        for condA = 1:(condNum -1)
            for condB = (condA + 1):condNum   
                disp([num2str(condA) ' vs ' num2str(condB)]);
                load([mat_location 'speed_' num2str(speeds{i_speed}) '/AccuracyIITT_' num2str(speeds{i_speed})...
                    '_' num2str(condA) '_' num2str(condB) '.mat']);

                temp_AccuracyIITT(condA, condB, :, :) = AccuracyIITT;
            end       
        end
        temp_AccuracyIITT(condNum,:,:,:) = zeros(condNum,length(param.Time),length(param.Time));
        AccuracyIITT = permute(temp_AccuracyIITT, [2 1 3 4]);
        save([mat_location 'AccuracyIITT_' num2str(speeds{i_speed}) '.mat'], 'AccuracyIITT','param');
        clear AccuracyIITT temp_AccuracyIITT;
    end
end
    
disp('All finished!');
toc
%closematlabpool;
