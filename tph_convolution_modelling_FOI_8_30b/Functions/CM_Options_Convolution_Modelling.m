
%% Convolution Modelling - Settings Options

% Written by T. Hein June 2020
% Use this script to set all the options for convolution modelling
% functions included in 'tp_ConvModel.m'

%% Total Subj
options.subj_tot = [1:43];

%% Step1 - Events and Artefact Rejection
% Define the events to keep from preprocessed EEG data
options.events_artefacts.tp_events = [140:142 240 241:242];
% Artefact Rejection Index Name
options.events_artefacts.aRejindex = ('GLM_aRej_osc_gamma_index_IQRx1_5.mat');
options.events_artefacts.aRej10index = ('EEGLAB_gamma_fix_10_aRej.mat');
options.events_artefacts.aRej14index = ('EEGLAB_gamma_fix_14_aRej.mat');
options.events_artefacts.aRej28index = ('EEGLAB_gamma_fix_28_aRej.mat');
options.events_artefacts.aRej30index = ('EEGLAB_gamma_fix_30_aRej.mat');
options.events_artefacts.aRej39index = ('EEGLAB_gamma_fix_39_aRej.mat');


%% Step2 - Convert 2 SPM and TF analysis
% Analysis Name
options.convertTF.SPM_prefix = 'SPM_tf';
% Set the desired sampling freq for the TF amplitude data
options.sampling_freq = 256;
% Set time-freq analysis freq range
options.convertTF.tffreq = [8:2:30];
options.convertTF.channels = {'EEG'};
options.convertTF.timewin = [-Inf Inf];
options.convertTF.method = 'morlet';
options.convertTF.settings.ncycles = 5;
% cfg.width      = 7;  % GAMMA [30:2:100]
% cfg.width      = 5;  % BETA  [8:2:30]
% cfg.width      = 3;  % ALPHA [8:2:30]
% cfg.width      = 2;  % THETA [4:1:8]
%% Convolution Modelling
% Data DIR
options.conv.data_dir = [rootFolder '\Data\SPM_tf\'];
% Convolution Modelling time window of analysis
options.conv.toi = [-200 2000];
% Sensor analysis (EEG for all sensors, or e.g. Cz for one)
options.conv.sensors = 'EEG';
% Order of Fourier-Basis (how many sine & cosine functions)
options.conv.ofb = 12;

%% Images & Smoothing (for SPM)

options.conversion.mode = 'cont_time_freq';
options.conversion.space = 'sensor';
% Set time window for smoothing + analysis
options.conversion.convTimeWindow = [100 500];
options.conversion.convPrefix = 'toi_100_500_foi_8_30b';
% Smoothing Kernal
options.conversion.smooKernel = [16 16 0];
options.conversion.chans = 'EEG';
options.conversion.mode = 'scalp x time'; 

%% Stats options (for SPM)
% Subjs for analysis 
options.stats.subj.ALLsubjs = [1:43];
expgroup = [20 21 23:43];
options.stats.subj.expgroup = setdiff(expgroup, [36,37]);
options.stats.subj.contgroup = [1:19 22 37];

options.stats.conditionName    = 'Undefined'; % name (string) of the
% epochs in D which we want to use in the GLM
options.stats.design        = 'epsilon';
switch options.stats.design
    case 'epsilon'
        options.stats.regressors = {'epsi2', 'epsi3'};
    case 'PE_precision'
        options.stats.regressors = {'delta1', 'pi2', 'delta2', 'pi3'};
    case 'PE_uncertainty'
        options.stats.regressors = {'delta1', 'sigma2', 'delta2', 'sigma3'};
end
options.stats.pValueMode = 'peakFWE'; % 'peakFWE', 'clusterFWE' - also
% only relevant for 2nd level GLM

options.stats.between.regressors = {'epsi2', 'epsi3'};
options.stats.between.conditions = {'experimental (state anxiety)', 'control'};
