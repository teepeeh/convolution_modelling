function CM_step4_Convolution_Modelling(rootFolder, options)

%% Convolution Modelling Time-Frequency - Step 4: Convolution Modelling in SPM
% Written by T. Hein June 2020
% Load IR and SPM TF amplitude data and run convolution modelling using
% outcomes (win, lose) and HGF quantiites (epsi2, epsi3)
addpath(genpath([rootFolder '\Data\SPM_tf\']));
% SPM default EEG setup
spm('defaults', 'eeg');
for n = options.subj_tot
    
    %% DIR for Conv Data
    convdatadir = fullfile(rootFolder,'\Data\SPM_tf');
    %% Subject Number + DIR
    subjdir = ([options.conv.data_dir 'participant_' num2str(n)]);
    cd(subjdir);
    % Subject Number
    filetag = convertStringsToChars(num2str(n));
    %% Load continuous EEG file and onsets/events
    % Load data
    D = spm_eeg_load([subjdir '\atf_d_' filetag '_tosc_spm_cont.mat']); 
    % Load IR Wrapper vectors/matrix
    wrapper = (['IR_wrapper_sr' num2str(options.sampling_freq) '.mat']);
    sample_rate_dir = (['sr', num2str(options.sampling_freq)]);
    load(fullfile(rootFolder,'\Data\IR_designmatrix\', sample_rate_dir, wrapper));
    %% Simple IR in each modality (collapsed across choices):
    condmat = cell2mat(IR_wrapper.IR_designmatrix.outcomes(n));
    names = IR_wrapper.IR_designmatrix.key;
    % Here you can shift all onsets in the speficied condition by fixed amount
    % e.g. for outcome responses, we may wish to look at pre-response activity.
    SHIFTconds = [];
    SHIFT = 0;
    %% Optional: parametric modulators (of onset regressors; to modulate 'height' of stick functions)
    modcs = [];     % None
    pmodnames = {}; % Names of modulators
    ppmod = [];     % Samples x Modulator
    %%  General specifications for convolution
    matlabbatch = {};
    % Specify EEG data file
    matlabbatch{1}.spm.meeg.modelling.convmodel.sess.D = {[subjdir '\' D.fname]};
    % Order of Fourier-Basis (how many sine & cosine functions)
    matlabbatch{1}.spm.meeg.modelling.convmodel.bases.fourier.order = options.conv.ofb; % in LITVAK it was 22 basis functions 11 sines 11 cosines
    % Time window of analysis
    matlabbatch{1}.spm.meeg.modelling.convmodel.timing.timewin = options.conv.toi;
    % Channels for analysis
    matlabbatch{1}.spm.meeg.modelling.convmodel.channels{1}.type = options.conv.sensors;  
    %%  Session Conditions
    %   Script the above specified design to the convolution batch (quasi~automatic)
    for i = 1:size(condmat,2)
        % Name of outcome (win, lose, no resp; or, can be any IR)
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).name = names{i};
        % Obtain onset times (in samples) from D:
        ind = logical(condmat(:,i));
        % Onset times in seconds
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).define.manual.onset = D.time(ind);
        % Shifts onsets for specific responses (if specified above: line 81)
        if ismember(i, SHIFTconds)
            matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).define.manual.onset = D.time(ind)+SHIFT;
        end
        % Duration (for some reason 0)
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).define.manual.duration = 0;
        % Time modulations
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).tmod = 0;
        % If additionally parametric modulations of the stimulus ('stick') functions were specified, put them here:
        if ismember(i, modcs)
            matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).pmod(1).name = pmodnames{i};
            matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).pmod(1).param = ppmod(ind,i);
            matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).pmod(1).poly = 1;
        else
            matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).pmod=struct('name', {}, 'param', {}, 'poly', {});
        end
        % Orth(ogonal?)
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.cond(i).orth = 0;
    end
    
    matlabbatch{1}.spm.meeg.modelling.convmodel.sess.regress = struct('name', {}, 'val', {});
    %% Continuous (non-convolved) regressors:
    % e.g. we might include eye-channel activity as a co-variate:
    % matlabbatch{1}.spm.meeg.modelling.convmodel.sess.regress(1).name = D.chanlabels{65}; % VEOG
    % matlabbatch{1}.spm.meeg.modelling.convmodel.sess.regress(1).val = D(65,:,1);
    % matlabbatch{1}.spm.meeg.modelling.convmodel.sess.regress(2).name = D.chanlabels{66}; % HEOG
    % matlabbatch{1}.spm.meeg.modelling.convmodel.sess.regress(2).val = D(66,:,1);
    % Could also add your own custom convolution here (cf. El convolutor)
    %% Convolved continuous regressors (with the basis set) 
    % e.g. You might try to model the 'IR' of eye-motion for which you would
    % use the continous values from EOG channels.
    
    % Here I try to model the IR of precision-weighted prediction errors (in
    % 'peri-outcome' time).
    
    for k = str2double(filetag)
        subj_regressors = cell2mat(IR_wrapper.HGF_designmatrix.HGF(k));
        
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.convregress (1).name = IR_wrapper.HGF_designmatrix.key{1}; % epsi2
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.convregress (1).val = subj_regressors(:,1);
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.convregress (2).name = IR_wrapper.HGF_designmatrix.key{2}; % epsi3
        matlabbatch{1}.spm.meeg.modelling.convmodel.sess.convregress (2).val = subj_regressors(:,2);
        % And here add the outcomes (win, lose, no response)
        %     matlabbatch{1}.spm.meeg.modelling.convmodel.sess.convregress (3).name = IR_wrapper.HGF_designmatrix.key{3}; % Outcome
        %     matlabbatch{1}.spm.meeg.modelling.convmodel.sess.convregress (3).val = subj_regressors(:,3);
    end
    %% Unused specs (leave at default value)
    matlabbatch{1}.spm.meeg.modelling.convmodel.sess.hpf = 10; %high-pass filter (s)
    matlabbatch{1}.spm.meeg.modelling.convmodel.sess.multi = {''};
    matlabbatch{1}.spm.meeg.modelling.convmodel.timing.units = 'secs';
    matlabbatch{1}.spm.meeg.modelling.convmodel.timing.utime = 1;
    matlabbatch{1}.spm.meeg.modelling.convmodel.sess.multi_reg = {''};
    matlabbatch{1}.spm.meeg.modelling.convmodel.volt = 1;
    matlabbatch{1}.spm.meeg.modelling.convmodel.sess.savereg = 0; % 1: saves non-convolved regressors
    matlabbatch{1}.spm.meeg.modelling.convmodel.prefix = 'conv_model_';
    %% Save Batch
    % save([svdr filesep 'tosc_batch_conv_model.mat'],'matlabbatch'); % save batch (can be loaded and reviewed in SPM batch editor)
    %% RUN
    spm('defaults', 'EEG');
    spm_jobman('initcfg');
    % Run
    job = matlabbatch;
    spm_jobman('run', job);
   
    clear job matlabbatch condmat D filetag ind
    
end


