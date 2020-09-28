function spmTF = CM_step2_EEG2SPM_TF(rootFolder, eEEGaRej, options)

%% Convolution Modelling Time-Frequency - Step 2
% Written by T. Hein June 2020
% Takes step 1 as input, continous EEG data with only events of interests
% marked and artefacts rejected.

% Make dir for this run

savedir = fullfile([rootFolder + "\Data"], options.convertTF.SPM_prefix);
% Creates a folder if necessary
if ~exist([savedir],'dir')
    mkdir([savedir]);
end

% Add EEG data
addpath(fullfile([rootFolder + "\Data\SPM_tosc_continous"]));

spm('defaults', 'eeg');

for i = options.subj_tot
    cd(savedir);
    %% Subject Number + DIR
    subjdir = ([char(savedir) '\participant_' num2str(i)]);
    % Creates a folder if necessary
    if ~exist([subjdir],'dir')
        mkdir([subjdir]);
    end
    cd(subjdir);
    % Subject Number
    filetag = convertStringsToChars(num2str(i));
    %% Import and convert 2 SPM
    % Initialise SPM structure
    S = [];
    % Load BIOSEMI file to be converted
    S.dataset = eEEGaRej{i};
    % Name SPM file
    filetag = sprintf('%d_tosc_spm_cont', i);
    S.outfile = filetag;
    % Converts to SPM and saves in 'subj' directory
    D = spm_eeg_convert(S);
    %% Downsample
    S = [];
    S.D = D;
    S.fsample_new = options.sampling_freq;
    S.prefix = 'd_';
    Dds = spm_eeg_downsample(S);
    %% Continuous Time Frequency Analysis
    S = [];
    S.D = Dds;
    % Channels
    S.channels = options.convertTF.channels;
    S.frequencies = options.convertTF.tffreq; % Should be 8:18
    S.timewin = options.convertTF.timewin;
    S.method = options.convertTF.method;
    S.settings.ncycles = options.convertTF.settings.ncycles;
    Dtf = spm_eeg_tf(S); % output: continuous TF power
    %% Convert to amplitude
    % Convert power to amplitude
    S = [];
    S.D = Dtf; % [fpath  Dtf.fname];
    S.method = 'Sqrt'; % Square-root transform
    S.prefix = 'a';
    Dtftp = spm_eeg_tf_rescale(S);
    spmTF{i,1} = Dtftp.fname;
    cd(savedir);
    %% Clean up previous files
    % Delete TF frequecny
    tf = Dtf.fullfile;
    delete([tf(1:end-3),'mat']);
    delete([tf(1:end-3),'dat']);
    % Delete Downsampled
    ds = Dds.fullfile;
    delete([ds(1:end-3),'mat']);
    delete([ds(1:end-3),'dat']);
    % Delete Orginal Converted
    filetag_dat = [filetag + ".dat"];
    dnmd = fullfile(subjdir, filetag_dat);
    delete(dnmd);
    filetag_mat = [filetag + ".mat"];
    dnmd = fullfile(subjdir, filetag_mat);
    delete(dnmd);
end

end