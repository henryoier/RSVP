% WriteBatch for computer cluster
clear;
serial = 0;

% BatchName = ['S_' num2str(single_number)];
ProjectName = ['rsvp'] % 

%%
% Classifier parameters
FunctionName = 'Step01_SVMClassifier';

% openmind memery size
mem = '5000';
condNum  = 24;

i_subject = 4;
SubjectName = [ProjectName '_' num2str(i_subject, '%.2d')];
speed = 1;

files = dir(['../Openmind/Results/' SubjectName '/mat/IITT/speed_' num2str(speed) '/*IITT*']);

for condA = 1:(condNum - 1)
    for condB = (condA + 1): condNum
        serial = serial + 1;

        % run scripts
        if (serial == 1)
            fileRun = fopen(['run.txt'],'w');
            fprintf(fileRun,'#!/bin/sh\n');
            fprintf(fileRun,'module add mit/matlab/2015a\n');
            fprintf(fileRun,'module add openmind/srun.x11/v1\n');
            fprintf(fileRun,'cd /om/user/shengqin/rsvp/instructions\n');
        end

        flag_find = false;
        
        % batch scripts
        for i_file = 1:length(files)
            if strcmp(files(i_file).name, ['AccuracyIITT_' num2str(speed)...
                    '_' num2str(condA) '_' num2str(condB) '.mat'])
                flag_find = true;
                break;
            end
        end
        
        if ~flag_find
            ProjName = ['S' num2str(i_subject) 'V' num2str(speed) 'A' num2str(condA) 'B' num2str(condB)];

            fileID = fopen([ProjName '.txt'],'w');

            fprintf(fileID,'#!/bin/sh\n');
            fprintf(fileID,'#SBATCH --time=40:00:00\n');
            fprintf(fileID,['#SBATCH --job-name=' ProjName '\n']);
            fprintf(fileID,['#SBATCH --error=' ProjName '.err\n']);
            fprintf(fileID,'cd ..\n');
            RunName = [ '"' FunctionName ' ' num2str(i_subject) ' ' num2str(speed) ' ' num2str(condA) ' ' num2str(condB) '"' ];
            fprintf(fileID,['matlab -nodisplay -singleCompThread -r ' RunName]);
            fclose(fileID);

            % run scripts continue
            fprintf(fileRun, ['sbatch --mem=' mem ' ' ProjName '.txt\n'] );
            %    ' -n ' num2str(100/str2num(permutations([2:end]))) 
        end
    end    
end

% run scripts continue
fprintf(fileRun, ['squeue -u shengqin'] );
fclose(fileRun);
      

%% srun code

% module add mit/matlab/2014a
% module add openmind/srun.x11/v1
% cd /om/user/mfang/RhythmClassifier
% srun -c 5 --mem=88000 matlab -nodisplay -singleCompThread -r "RStep7_AverageSubjectsPost evectorhigh TT 1"



