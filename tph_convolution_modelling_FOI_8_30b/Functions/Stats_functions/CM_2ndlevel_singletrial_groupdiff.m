function CM_2ndlevel_singletrial_groupdiff(secondLevelDir, imagePaths1, imagePaths2, regressors, conditions)
% Adapted from TNUEEG_2NDLEVEL_SINGLETRIAL_GROUPDIFF Computes statistics for
% differences in the effects of single-trial (modelbased) regressors between
% conditions or groups in a between-subject design, using a 2-sample t-test.

%   Computes an F-contrast per (modelbased) single-trial regressor and
%   saves the SPM.mat, the conimages and a results report (pdf) per
%   regressor in the factorial design directory.

%   IN:     secondLevelDir  - directory (string) for saving the SPM.mat
%           imagePaths1     - list (cell array) of subjectwise directory
%                           names (strings) where beta images from 1st
%                           level stats can be found (group 1)
%           imagePaths2     - same for group 2
%           regressors      - a cell array list of regressor names
%                               (strings)
%           conditions      - (optional) a 2x1 cell array list of condition
%                           or group names - currently unused!
%   OUT:    --

% Number of subjects
nSubjects1 = size(imagePaths1, 1);
nSubjects2 = size(imagePaths2, 1);

% Prepare SPM
spm('defaults', 'EEG');
spm_jobman('initcfg');

regressorName = char(regressors);

% Create a new folder for each regressor
factorialDesignDir = fullfile(secondLevelDir, regressorName);
if ~exist(factorialDesignDir, 'dir')
    mkdir(factorialDesignDir);
end

% Set image paths
scans1 = imagePaths1;
scans2 = imagePaths2;


% Create and run the job - one test per regressor
job = CM_getjob_2ndlevel_2sample_ttest(factorialDesignDir, scans1, scans2);
spm_jobman('run', job);

end