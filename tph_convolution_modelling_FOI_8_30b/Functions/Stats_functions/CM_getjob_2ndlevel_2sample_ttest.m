function [ job ] = CM_getjob_2ndlevel_2sample_ttest(facdir, scans1, scans2)

% Adpated from TNUEEG_GETJOB_2NDLEVEL_2SAMPLE_TTEST 
% Creates a job for running a two-sample t-test on the 2nd level for 
% testing differences in an effect across groups.

%   IN:     facdir      - directory (string) for saving the SPM.mat
%           scans1      - cell array list of image filenames, including paths, group1
%           scans2      - cell array list of image filenames, including paths, group2
%   OUT:    job         - the job for the 2nd level statistics that can be
%                       run using the spm_jobman


% job 1: factorial design
job{1}.spm.stats.factorial_design.dir = {facdir};

job{1}.spm.stats.factorial_design.des.t2.scans1 = scans1;
job{1}.spm.stats.factorial_design.des.t2.scans2 = scans2;

job{1}.spm.stats.factorial_design.des.t2.dept = 0;
job{1}.spm.stats.factorial_design.des.t2.variance = 1;
job{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
job{1}.spm.stats.factorial_design.des.t2.ancova = 0;

job{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
job{1}.spm.stats.factorial_design.masking.im = 1;
job{1}.spm.stats.factorial_design.masking.em = {''};
job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
job{1}.spm.stats.factorial_design.globalm.glonorm = 1;

% job 2: estimate factorial design
job{2}.spm.stats.fmri_est.spmmat(1) = ...
    cfg_dep('Factorial design specification: SPM.mat File', ...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('.','spmmat'));
job{2}.spm.stats.fmri_est.write_residuals = 0;
job{2}.spm.stats.fmri_est.method.Classical = 1;

end