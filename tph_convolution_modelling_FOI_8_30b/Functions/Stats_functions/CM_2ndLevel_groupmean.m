function CM_2ndLevel_groupmean(rootFolder, options)
%% T. Hein SPM/GLM/Convolution Modelling - 2nd Level Stats - Within
% Version: Lenovo (MATLAB 2019b) Written June 2020

%% Save Dir
% Directory for saving the SPM.mat
save_dir = [rootFolder + "\Stats\epsis\onesample_t_within\"];
% Make folder for saving
if ~exist ([save_dir],'dir')
    mkdir ([save_dir]);
end
%%                              All Subjects
% Directory for saving the SPM.mat
save_dir = [rootFolder + "\Stats\epsis\onesample_t_within\All\"];
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
%%                              All Subjects
for i = options.stats.subj.ALLsubjs
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
    All_epsi2_scan{:,i} = fullfile(subj_images_dir, cond_epsi2);
    All_epsi3_scan{:,i} = fullfile(subj_images_dir, cond_epsi3);
    clear subj_images_dir
end

% Clear empty cells if any
All_epsi2_scan = All_epsi2_scan(~cellfun('isempty',All_epsi2_scan));
All_epsi3_scan = All_epsi3_scan(~cellfun('isempty',All_epsi3_scan));

% Run 2nd-Level Stats
% Epsi2
regressor = {'epsi2'};
CM_2ndlevel_singletrial_groupmean( save_dir, All_epsi2_scan, regressor )
% Epsi 3
regressor = {'epsi3'};
CM_2ndlevel_singletrial_groupmean( save_dir, All_epsi3_scan, regressor )

%%                      Group based 2nd Level Stats

%% Control Group

%% Save Dir
% Directory for saving the SPM.mat
save_dir = [rootFolder + "\Stats\epsis\onesample_t_within\Cont\"];
% Time of interest for analysis (savedir + data)
toi = options.conversion.convPrefix;
save_dir = fullfile(save_dir, toi);
% Make folder for saving
if ~exist ([save_dir],'dir')
    mkdir ([save_dir]);
end

save_dir = convertStringsToChars(save_dir);
%% Images
clear group_images;

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
Cont_epsi2_scan = Cont_epsi2_scan(~cellfun('isempty',Cont_epsi2_scan));
Cont_epsi3_scan = Cont_epsi3_scan(~cellfun('isempty',Cont_epsi3_scan));

% Run 2nd-Level Stats
% Epsi2
regressor = {'epsi2'};
CM_2ndlevel_singletrial_groupmean( save_dir, Cont_epsi2_scan, regressor )
% Epsi 3
regressor = {'epsi3'};
CM_2ndlevel_singletrial_groupmean( save_dir, Cont_epsi3_scan, regressor )



%% State Anxiety Group

% Save Dir
% Directory for saving the SPM.mat
save_dir = [rootFolder + "\Stats\epsis\onesample_t_within\StA\"];
% Time of interest for analysis (savedir + data)
toi = options.conversion.convPrefix;
save_dir = fullfile(save_dir, toi);
% Make folder for saving
if ~exist ([save_dir],'dir')
    mkdir ([save_dir]);
end

save_dir = convertStringsToChars(save_dir);
%% Images
clear group_images;

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
StA_epsi2_scan = StA_epsi2_scan(~cellfun('isempty',StA_epsi2_scan));
StA_epsi3_scan = StA_epsi3_scan(~cellfun('isempty',StA_epsi3_scan));

% Run 2nd-Level Stats
% Epsi2
regressor = {'epsi2'};
CM_2ndlevel_singletrial_groupmean( save_dir, StA_epsi2_scan, regressor )
% Epsi 3
regressor = {'epsi3'};
CM_2ndlevel_singletrial_groupmean( save_dir, StA_epsi3_scan, regressor )

end


