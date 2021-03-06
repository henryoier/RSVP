function sFiles = import_rawfile(RawFiles,SubjectName);
% function sFiles = import_rawfile(RawFile,SubjectName);

% Script generated by Brainstorm v3.2 (20-Jun-2014)

% Input files
sFiles = [];

% Process: Create link to raw file
sFiles = bst_process(...
    'CallProcess', 'process_import_data_raw', ...
    sFiles, [], ...
    'subjectname', SubjectName{1}, ...
    'datafile', {RawFiles{1}, 'FIF'}, ...
    'channelreplace', 1, ...
    'channelalign', 0);


% OPTIONAL: bandpassfilter data
% Process: Low-pass:100Hz
sFiles = bst_process('CallProcess', 'process_bandpass', ...
    sFiles, [], ...
    'highpass', 0, ...
    'lowpass', 100, ...
    'mirror', 1, ...
    'sensortypes', 'MEG, EEG', ...
    'read_all', 1);


% Process: Events: Read from channel
sFiles = bst_process(...
    'CallProcess', 'process_evt_read', ...
    sFiles, [], ...
    'stimchan', 'STI101', ...
    'trackmode', 1, ...  % Value: detect the changes of channel value
    'zero', 0);

% Process: Import MEG/EEG: Events
sFiles = bst_process(...
    'CallProcess', 'process_import_data_event', ...
    sFiles, [], ...
    'subjectname', SubjectName{1}, ...
    'condition', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92', ...
    'eventname', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92', ...
    'timewindow', [-10000, 100000], ...
    'epochtime', [-0.2, 1.1], ...
    'createcond', 1, ...
    'ignoreshort', 1, ...
    'usectfcomp', 1, ...
    'usessp', 1, ...
    'freq', [], ...
    'baseline', [-0.2, -0.001]);


