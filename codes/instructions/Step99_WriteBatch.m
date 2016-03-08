% WriteBatch for computer cluster
clear;
serial = 0;

% BatchName = ['S_' num2str(single_number)];
BatchName = 'E_';
ProjectName = ['rsvp'] % 

%%
% Classifier parameters
FunctionName = 'Step01_SVMClassifier';

% openmind memery size
mem = '5000';

for condA = 1:1
    for condB = 10:10
        serial = serial + 1;

        % run scripts
        if (serial == 1)
            fileRun = fopen([BatchName '___run.txt'],'w');
            fprintf(fileRun,'#!/bin/sh\n');
            fprintf(fileRun,'module add mit/matlab/2015a\n');
            fprintf(fileRun,'module add openmind/srun.x11/v1\n');
            fprintf(fileRun,'cd /om/user/shengqin/rsvp/instructions\n');
        end

        % batch scripts

        ProjName = [BatchName 'S4' 'A' num2str(condA) 'B' num2str(condB)];

        fileID = fopen([ProjName '.txt'],'w');

        fprintf(fileID,'#!/bin/sh\n');
        fprintf(fileID,'#SBATCH --time=40:00:00\n');
        fprintf(fileID,['#SBATCH --job-name=' ProjName '\n']);
        fprintf(fileID,['#SBATCH --error=' ProjName '.err\n']);
        fprintf(fileID,'cd ..\n');
        RunName = [ '"' FunctionName ' ' condA ' ' condB '"' ];
        fprintf(fileID,['matlab -nodisplay -singleCompThread -r ' RunName]);
        fclose(fileID);

        % run scripts continue
        fprintf(fileRun, ['sbatch --mem=' mem ' ' ProjName '.txt\n'] );
%             ' -n ' num2str(100/str2num(permutations([2:end]))) 

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



