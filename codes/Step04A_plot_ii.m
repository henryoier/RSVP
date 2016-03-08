clear; clc
ProjectName = 'rsvp';  % 
speeds = {1,2};
project_location = ['/dataslow/sheng/' ProjectName];
addpath(genpath('Functions')); % add path of functions

if strcmp(iitt, 'ii')
    mat_location = [project_location '/Results/total/ACCY/mat/'];
else
end


%% Merge all results

for i_speed = 1:length(speeds)
    disp(['Speed = ' num2str(speeds{i_speed})]); 
    
    n_subjects = 4:5;
    
    SubjectName_all = '2rsvp45';
    
    if strcmp(iitt, 'ii')
        for i_subject = n_subjects
            
            SubjectName = ['rsvp_' num2str(i_subject, '%.2d')];
            disp(['Subject = ' SubjectName]);
       
            
            load([mat_location 'ACCY_' SubjectName '_speed_' num2str(speeds{i_speed}) '.mat']);

            temp_Result.param = Result.param;
        end
        
       save([mat_location 'ACCY_' SubjectName_all '_speed_' num2str(speeds{i_speed}) '.mat'], 'Result');
    end
    
    if strcmp(iitt, 'iitt')
    end

end
    
disp('All finished!');
toc
%closematlabpool;
