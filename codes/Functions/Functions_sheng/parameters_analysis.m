% parameters_analysis;

if clusterflag
    param.brainstorm_db = ['[CLUSTER PATH]' ProjectName '/data'];
else
    param.brainstorm_db = ['/dataslow/sheng/rsvp/brainstorm_db/' ProjectName '/data'];
end

param.data_type = 'MEG';
param.ProjectName = ProjectName;
param.SubjectName = SubjectName;
param.f_lowpass = 30;
param.latency = 0.026; % video latency 
param.framesec = 1/60; % seconds per frame in the projecter 
param.trial_number = 9999; % initializa a number and then will be changed.
param.baseline = 0.3; % the length of the baseline.
param.inter = 1.5; % the decision time, or the interstimulus time.