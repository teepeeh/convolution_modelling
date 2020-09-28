function IRs = CM_step3_Impulse_Response_Matrix(rootFolder, options)

%% Convolution Modelling Time-Frequency - Step 3: creating impulase response (wrapper)
% Written by T. Hein June 2020
% Load EEG files and artefact rejection and downsamples to create a matric
% of impulase responses and computational model regressor responses from
% the 'SPM_tosc_conttinous' files and behavioural data.


%% IR matrix

% Design matrix (pre-convolution), in which each column codes one outcome type / condition of interest:
% Load artefact rejection index
load(options.events_artefacts.aRejindex);
% Starts EEGLAB
eeglab; close all;

%% SAVE

% DIR for impulse response matrices
sample_rate_dir = (['sr', num2str(options.sampling_freq)]);
svdir = char([rootFolder + "\Data\IR_designmatrix"]);
% Creates a folder if necessary
if ~exist([svdir],'dir')
    mkdir([svdir]);
end
% DIR for specific sampling frequency
svdir = fullfile(svdir, sample_rate_dir);
% Creates a folder if necessary
if ~exist([svdir],'dir')
    mkdir([svdir]);
end

cd(svdir);

%% RUN

for n = options.subj_tot
    % Input file name
    fn = sprintf('%d_tosc_aRej.set',n);
    % Load EEG file
    EEG = pop_loadset(fn);
    % Downsample to same as SPM final conv modelling
    EEG = pop_resample(EEG, options.sampling_freq);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create matrix for impulse responses
    outcomes = zeros(size(EEG.data,2),3,'single');
    outcomes_key = {'win';'lose';'no response'};
    % Create Matrix for HGF regressors
    HGF =  zeros(size(EEG.data,2),3,'single');
    HGF_key = {'epsi2';'epsi3';'outcome'};
    % Getting event lables
    tpevents =  {EEG.event.type}';
    tpevents = cellfun(@str2double, tpevents);
    % Getting event latencies
    tplats =  {EEG.event.latency}';
    tplats = cell2mat(tplats);
    
    % Getting regressors subject's 3-lev HGF
    % Load behavioural data
    fname = sprintf('tanx_%d.mat',n);
    load (fname);
    r = player_struct.tapas.est;
    clear epsi2 epsi3 rt outcome;
    % HGF - epsi2
    epsi2(:,1) = r.traj.epsi(:,2);
    epsi2 = epsi2; % This was abs(epsi2)
    % HGF - epsi3
    epsi3(:,1) = r.traj.epsi(:,3);
    % Outcome - Win [1] / Lose [0]
    outcome(:,1) = vertcat(player_struct.experiment_data_block1(:,11),player_struct.experiment_data_block2(:,11));
    
    % Here need to add in deleting the aRej
    aRej = GLM_aRej_osc_gamma_index_IQRx1_5{1, n};
    epsi2(aRej) = [];
    epsi3(aRej) = [];
    outcome(aRej) = [];
    
    % RUN outcomes/regressors according to latencies
    for i = 1:size(tpevents,1)
        if isequal(tpevents(i),140) || isequal(tpevents(i),240)
            lat = tplats(i);
            outcomes(round(lat),1) = 1;
            HGF(round(lat),1) = epsi2(i);
            HGF(round(lat),2) = epsi3(i);
            HGF(round(lat),3) = outcome(i);
        elseif isequal(tpevents(i),141) || isequal(tpevents(i),241)
            lat = tplats(i);
            outcomes(round(lat),2) = 1;
            HGF(round(lat),1) = epsi2(i);
            HGF(round(lat),2) = epsi3(i);
            HGF(round(lat),3) = outcome(i);
        else
            lat = tplats(i);
            outcomes(round(lat),3) = 1;
            HGF(round(lat),1) = epsi2(i);
            HGF(round(lat),2) = epsi3(i);
            HGF(round(lat),3) = outcome(i);
        end
    end
    
    % Compiling
    IR_wrapper.IR_designmatrix.outcomes{n} = outcomes;
    IR_wrapper.IR_designmatrix.key = outcomes_key;
    IR_wrapper.HGF_designmatrix.HGF{n} = HGF;
    IR_wrapper.HGF_designmatrix.key = HGF_key;
    % Saving
    save([svdir + "\IR_wrapper_" + sample_rate_dir + ".mat"] ,'IR_wrapper');
    % Clearing
    clear EEG tpevents lat outcomes tplats fn HGF
end

end
