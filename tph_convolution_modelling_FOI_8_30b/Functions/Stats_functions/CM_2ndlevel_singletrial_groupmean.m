function CM_2ndlevel_singletrial_groupmean(statsSaveDir, imagePaths, regressor)
% Adapted from TNUEEG_2NDLEVEL_SINGLETRIAL_GROUPMEAN 
% Computes 2nd level statistics for convolved TF data using a one-sample 
% t-test within one group.

%   IN:     statsSaveDir      - directory (string) for saving the SPM.mat
%           imagePaths          - list (cell array) of subjectwise
%                               directory names (strings) where beta images
%                               from 1st level stats can be found
%           regressor          - regressor name(strings)
%   OUT:    --

% how many subjects do we use
nSubjects = numel(imagePaths);

% prepare spm
spm('defaults', 'EEG');
spm_jobman('initcfg');

regressorName = char(regressor);
% open a new folder for each regressor
factorialDesignDir = fullfile(statsSaveDir, regressorName);

scans = imagePaths';
%% Create and run the job - one test per regressor
job = CM_getjob_2ndlevel_onesample_ttest(factorialDesignDir, scans, regressorName);
spm_jobman('run', job);
end