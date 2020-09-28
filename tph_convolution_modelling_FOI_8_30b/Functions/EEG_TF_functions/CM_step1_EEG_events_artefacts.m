function eEEGaRej = CM_step1_EEG_events_artefacts(rootFolder, options)

%% Convolution Modelling Time-Frequency - Step 1 
% Written by T. Hein June 2020
% Selects events of interest defined by 'tp_events' and deletes all other
% event lables. Then, rejects artefacts based on the artefact index
% 'GLM_aRej_osc_gamma_index_IQRx1_5'
cd([rootFolder '\Data']);
% Load artefact rejection index
load(options.events_artefacts.aRejindex);
load(options.events_artefacts.aRej10index);
load(options.events_artefacts.aRej14index);
load(options.events_artefacts.aRej28index);
load(options.events_artefacts.aRej30index);
load(options.events_artefacts.aRej39index);

% Starts EEGLAB
eeglab; close all;

for i = options.subj_tot
    core_EEG = sprintf('%d_I64efMerged.set',i);
    eeg_out_label = sprintf('%d_tosc_aRej.set',i);
    eeg_out_path = char([rootFolder + "\Data\SPM_tosc_continous"]); 
    % Creates a folder if necessary
    if ~exist([eeg_out_path],'dir')
        mkdir([eeg_out_path]);
    end
    %Load
    EEG = pop_loadset(core_EEG);
    % Process
    EEG = eeg_checkset( EEG );
    EEG = pop_selectevent( EEG, 'type',options.events_artefacts.tp_events,'deleteevents','on');
    % Dealing with boundaries/NaNs
    tpevents =  {EEG.event.type}';
    tpevents = cellfun(@str2double, tpevents);
    % Find the Lose events
    findB = isnan(tpevents);
    findB = find(findB == 1);
    EEG = pop_editeventvals(EEG,'delete',findB);
    % Artefact rejection
    aRej = GLM_aRej_osc_gamma_index_IQRx1_5{1, i};
    if i == 10
        aRej = EEGLAB_gamma_fix_10_aRej;
    elseif i == 14
        aRej = EEGLAB_gamma_fix_14_aRej;
    elseif i == 28
        aRej = EEGLAB_gamma_fix_28_aRej;
    elseif i == 30
        aRej = EEGLAB_gamma_fix_30_aRej;
    elseif i == 39
        aRej = EEGLAB_gamma_fix_39_aRej;        
    end
    EEG = pop_editeventvals(EEG,'delete',aRej);
    % Save
    EEG = pop_saveset(EEG,eeg_out_label,eeg_out_path);
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    eEEGaRej{i,1} = eeg_out_label;
    clearvars -except datadir spmpath eeglabpath EEGOUTpath GLM_aRej_osc_gamma_index_IQRx1_5 rootFolder tp_events eEEGaRej options EEGLAB_gamma_fix_14_aRej EEGLAB_gamma_fix_28_aRej EEGLAB_gamma_fix_30_aRej EEGLAB_gamma_fix_10_aRej EEGLAB_gamma_fix_39_aRej
end
end