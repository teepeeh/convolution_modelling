function CM_2ndLevel_groupDiff(rootFolder, options)
%% T. Hein SPM/GLM/Convolution Modelling - 2nd Level Stats - Within
% Version: Lenovo (MATLAB 2019b) Written June 2020

%% Save Dir
% Directory for saving the SPM.mat
save_dir = [rootFolder + "\Stats\epsis\twosample_t_group\"];
% Make folder for saving
if ~exist ([save_dir],'dir')
    mkdir ([save_dir]);
end

% Directory for saving the SPM.mat
save_dir = [rootFolder + "\Stats\epsis\twosample_t_group\"];
% Time of interest for analysis (savedir + data)
toi = options.conversion.convPrefix;
save_dir = fullfile(save_dir, toi);
% Make folder for saving
if ~exist ([save_dir],'dir')
    mkdir ([save_dir]);
end

save_dir = convertStringsToChars(save_dir);
% Images
clear group_images;

%%                      Group based 2nd Level Stats

%% Control Group

% Images

for i = options.stats.subj.contgroup
    % DIR for Conv Data
    convdatadir = fullfile(rootFolder,'\Data\SPM_tf');
    % Subject Number + DIR
    % Subject data dir
    subjdir = ([options.conv.data_dir 'participant_' num2str(i)]);
    % Subject Number
    filetag = convertStringsToChars(num2str(i));
    % Images DIR
    subj_images_dir = ([subjdir '\' toi '_conv_model_atf_d_' filetag '_tosc_spm_cont']); 
    % Conditions to load for analysis
    cond_epsi2 = ('smoothed_condition_epsi2.nii,1');
    cond_epsi3 = ('smoothed_condition_epsi3.nii,1');
    % Cont Scas
    Cont_epsi2_scan{:,i} = fullfile(subj_images_dir, cond_epsi2);
    Cont_epsi3_scan{:,i} = fullfile(subj_images_dir, cond_epsi3);
    clear subj_images_dir
end

% Clear empty cells
Cont_epsi2_scan = Cont_epsi2_scan(~cellfun('isempty',Cont_epsi2_scan))';
Cont_epsi3_scan = Cont_epsi3_scan(~cellfun('isempty',Cont_epsi3_scan))';

%% State Anxiety Group

% Images

for i = options.stats.subj.expgroup
    % DIR for Conv Data
    convdatadir = fullfile(rootFolder,'\Data\SPM_tf');
    % Subject Number + DIR
    % Subject data dir
    subjdir = ([options.conv.data_dir 'participant_' num2str(i)]);
    % Subject Number
    filetag = convertStringsToChars(num2str(i));
    % Images DIR
    subj_images_dir = ([subjdir '\' toi '_conv_model_atf_d_' filetag '_tosc_spm_cont']); 
    % Conditions to load for analysis
    cond_epsi2 = ('smoothed_condition_epsi2.nii,1');
    cond_epsi3 = ('smoothed_condition_epsi3.nii,1');
    % Cont Scas
    StA_epsi2_scan{:,i} = fullfile(subj_images_dir, cond_epsi2);
    StA_epsi3_scan{:,i} = fullfile(subj_images_dir, cond_epsi3);
    clear subj_images_dir
end

% Clear empty cells
StA_epsi2_scan = StA_epsi2_scan(~cellfun('isempty',StA_epsi2_scan))';
StA_epsi3_scan = StA_epsi3_scan(~cellfun('isempty',StA_epsi3_scan))';

%% Run 2-sampple t-test

% Epsi2
regressors = options.stats.between.regressors{1};
conditions = options.stats.between.conditions;
CM_2ndlevel_singletrial_groupdiff( save_dir, StA_epsi2_scan, Cont_epsi2_scan, regressors, conditions )

% Epsi3
regressors = options.stats.between.regressors{2};
conditions = options.stats.between.conditions;
CM_2ndlevel_singletrial_groupdiff( save_dir, StA_epsi3_scan, Cont_epsi3_scan, regressors, conditions )

end


