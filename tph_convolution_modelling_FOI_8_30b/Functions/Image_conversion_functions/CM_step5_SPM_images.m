function CM_step5_SPM_images(rootFolder, options)

%% Convolution Modelling Time-Frequency - Step 5: Converts to SPM images + smoothes data
% Written by T. Hein June 2020
% Loads 'conv_model_atf_d_%d_tosc_spm_cont.dat' and converts to images and
% then smoothes in line with options. 

% SPM default EEG setup
spm('defaults', 'eeg');

%% Run
for i = options.subj_tot
    %% DIR for Conv Data
    convdatadir = fullfile(rootFolder,'\Data\SPM_tf');
    %% Subject Number + DIR
    subjdir = ([options.conv.data_dir 'participant_' num2str(i)]);
    cd(subjdir);
    % Subject Number
    filetag = convertStringsToChars(num2str(i));
    % Load CONV MODEL continous TF data
    D = spm_eeg_load([subjdir '\conv_model_atf_d_' filetag '_tosc_spm_cont.mat']);
    %% Images
    % Both unsmoothed and smoothed images share a DIR given  in filetag
    % Conversion 2 images
    images = CM_tosc_convert2images(D, options);
    % Smoothing
    CM_tosc_smooth_images(images, options);
    clear S D images     
end

end
