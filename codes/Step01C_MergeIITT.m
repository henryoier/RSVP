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

%% Merge all IITT results
tic;
for i_subject = 6:6
    SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
    disp(['Subject = ' SubjectName]);
    
    mat_location = [file_location ProjectName '/Results/' SubjectName '/mat/IITT/'];
    
    for i_speed = 2:2
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
    end
end
    
disp('All finished!');
toc
%closematlabpool;
