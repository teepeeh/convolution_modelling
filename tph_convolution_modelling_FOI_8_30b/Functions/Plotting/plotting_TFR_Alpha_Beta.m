%% Plotting Conv TFR data

% PLots the time - frew imagsc plots for epsi2 and outcomes 
%% Paths
rmpath(genpath('E:\'));
clear all;
%% Directory
rootFolder = 'E:\tpDATA\tosc_data\tph_convolution_modelling\tph_convolution_modelling_FOI_8_30b';
cd (rootFolder);
% Add Functions
addpath(genpath([rootFolder '\Functions\']));
addpath(genpath([rootFolder '\Data\']));
% Add SPM
spmpath = 'E:\spm12';
addpath(spmpath);
spm('defaults', 'eeg');
% Add EEGLAB
eeglabpath = 'E:\eeglab14_1_2b';
addpath(eeglabpath);
%% FIELD TRIP
% Toolboxes
ftpath = 'E:\fieldtrip-20181024';
% Add FieldTrip
addpath(genpath(ftpath));
ft_defaults;
% Load in template FT file
load('tanx_wavelet_Cont_win_IQR_AB_baselined.mat')
ft_template = Cont_wavelet_win_AB{1, 1};
% Remove FT from path
rmpath(genpath(ftpath));
%% Load each SPM file and save fttimelock to a FieldTrip template
% Groups
expgroup = [20 21 23:43];
expgroup = setdiff(expgroup, [36,37]);
contgroup = [1:19 22 37];
% Conditions
condition_win = 1;
condition_lose = 2;
condition_noresp = 3;
regressor_epsi2 = 4;

% State Anxiety
for i = expgroup
    % Load CONV MODEL continous TF data
    filetag = convertStringsToChars(num2str(i)); % nametag of SPM datafile
    subjfolder = convertStringsToChars(sprintf('participant_%d', i));
    D = spm_eeg_load([rootFolder '\Data\SPM_tf\' subjfolder '\conv_model_atf_d_' filetag '_tosc_spm_cont.mat']);
    % Win
    ft_sta_win = ft_template;
    ft_sta_win.time = D.fttimelock.time;
    ft_sta_win.freq = D.fttimelock.freq;
    ft_sta_win.powspctrm = [];
    ft_sta_win.powspctrm = squeeze(D.fttimelock.powspctrm(condition_win,:,:,:));
    ft_conv_sta_win{i,1} = ft_sta_win;
    clear ft_sta_win
    % Lose
    ft_sta_lose = ft_template;
    ft_sta_lose.time = D.fttimelock.time;
    ft_sta_lose.freq = D.fttimelock.freq;
    ft_sta_lose.powspctrm = [];
    ft_sta_lose.powspctrm = squeeze(D.fttimelock.powspctrm(condition_lose,:,:,:));
    ft_conv_sta_lose{i,1} = ft_sta_lose;
    clear ft_sta_lose
    % Epsi 2
    ft_sta_epsi2 = ft_template;
    ft_sta_epsi2.time = D.fttimelock.time;
    ft_sta_epsi2.freq = D.fttimelock.freq;
    ft_sta_epsi2.powspctrm = [];
    if length(D.conditions) == 4
        ft_sta_epsi2.powspctrm = squeeze(D.fttimelock.powspctrm(regressor_epsi2,:,:,:));
        ft_conv_sta_epsi2{i,1} = ft_sta_epsi2;
    else
        ft_sta_epsi2.powspctrm = squeeze(D.fttimelock.powspctrm(3,:,:,:));
        ft_conv_sta_epsi2{i,1} = ft_sta_epsi2;
    end
    clear ft_sta_epsi2
    clear S D
end
% For any missing participants
ft_conv_sta_win = ft_conv_sta_win(~cellfun('isempty',ft_conv_sta_win));
ft_conv_sta_lose = ft_conv_sta_lose(~cellfun('isempty',ft_conv_sta_lose));
ft_conv_sta_epsi2 = ft_conv_sta_epsi2(~cellfun('isempty',ft_conv_sta_epsi2));

% Contgroup
for i = contgroup
    % Load CONV MODEL continous TF data
    filetag = convertStringsToChars(num2str(i)); % nametag of SPM datafile
    subjfolder = convertStringsToChars(sprintf('participant_%d', i));
    D = spm_eeg_load([rootFolder '\Data\SPM_tf\' subjfolder '\conv_model_atf_d_' filetag '_tosc_spm_cont.mat']);
    % Win
    ft_cont_win = ft_template;
    ft_cont_win.time = D.fttimelock.time;
    ft_cont_win.freq = D.fttimelock.freq;
    ft_cont_win.powspctrm = [];
    ft_cont_win.powspctrm = squeeze(D.fttimelock.powspctrm(condition_win,:,:,:));
    ft_conv_cont_win{i,1} = ft_cont_win;
    clear ft_cont_win
    % Lose
    ft_cont_lose = ft_template;
    ft_cont_lose.time = D.fttimelock.time;
    ft_cont_lose.freq = D.fttimelock.freq;
    ft_cont_lose.powspctrm = [];
    ft_cont_lose.powspctrm = squeeze(D.fttimelock.powspctrm(condition_lose,:,:,:));
    ft_conv_cont_lose{i,1} = ft_cont_lose;
    clear ft_cont_lose
    % Epsi 2
    ft_cont_epsi2 = ft_template;
    ft_cont_epsi2.time = D.fttimelock.time;
    ft_cont_epsi2.freq = D.fttimelock.freq;
    ft_cont_epsi2.powspctrm = [];
    if length(D.conditions) == 4
        ft_cont_epsi2.powspctrm = squeeze(D.fttimelock.powspctrm(regressor_epsi2,:,:,:));
        ft_conv_cont_epsi2{i,1} = ft_cont_epsi2;
    else
        ft_cont_epsi2.powspctrm = squeeze(D.fttimelock.powspctrm(3,:,:,:));
        ft_conv_cont_epsi2{i,1} = ft_cont_epsi2;
    end
    clear ft_cont_epsi2
    clear S D
end
% For any missing participants
ft_conv_cont_win = ft_conv_cont_win(~cellfun('isempty',ft_conv_cont_win));
ft_conv_cont_lose = ft_conv_cont_lose(~cellfun('isempty',ft_conv_cont_lose));
ft_conv_cont_epsi2 = ft_conv_cont_epsi2(~cellfun('isempty',ft_conv_cont_epsi2));
%% Load these fieldtrip convolution files into the grandavaerage

cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
% For plotting
cfg.keepindividual = ('no');
cfg.method         = ('within');

% Controls
grandavg_cont_win = ft_freqgrandaverage(cfg, ft_conv_cont_win{:});
grandavg_cont_lose = ft_freqgrandaverage(cfg, ft_conv_cont_lose{:});
grandavg_cont_epsi2 = ft_freqgrandaverage(cfg, ft_conv_cont_epsi2{:});
% State Anxiety
grandavg_sta_win = ft_freqgrandaverage(cfg, ft_conv_sta_win{:});
grandavg_sta_lose = ft_freqgrandaverage(cfg, ft_conv_sta_lose{:});
grandavg_sta_epsi2 = ft_freqgrandaverage(cfg, ft_conv_sta_epsi2{:});

%% Making DIFF Lose-win
contdiff = grandavg_cont_win;
contdiff.powspctrm = grandavg_cont_lose.powspctrm - grandavg_cont_win.powspctrm;

stadiff = grandavg_sta_win;
stadiff.powspctrm = grandavg_sta_lose.powspctrm - grandavg_sta_win.powspctrm;

%%                              Within Each Group

ChanIndex = find(contains(grandavg_cont_win.label,'FCz'));

% Controls

close all;
% Win
subplot(3,2,1)
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'Win';
cfg.fontsize = 12;
cfg.zlim = 'maxabs'; % [-5, 5];
cfg.channel = grandavg_cont_win.label(ChanIndex);
ft_singleplotTFR(cfg,grandavg_cont_win)
% Lose
subplot(3,2,2)
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'Lose';
cfg.fontsize = 12;
cfg.zlim = 'maxabs'; % [-5, 5];
cfg.channel = grandavg_cont_lose.label(ChanIndex);
ft_singleplotTFR(cfg,grandavg_cont_lose)
% Lose-Win
subplot(3,2,3:4)
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'Lose-Win';
cfg.fontsize = 12;
cfg.zlim = 'maxabs'; % [-4, 4];
cfg.channel = contdiff.label(ChanIndex);
ft_singleplotTFR(cfg,contdiff)
% Epsi2
subplot(3,2,5:6)
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'epsi2';
cfg.fontsize = 12;
cfg.zlim = 'maxabs'; % [-200, 200];
cfg.channel = grandavg_cont_win.label(ChanIndex);
ft_singleplotTFR(cfg,grandavg_cont_epsi2)
% Title
sgtitle('Controls')
% Background Colour
set(gcf,'color','white')

% StA
figure
% Win
subplot(3,2,1)
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'Win';
cfg.fontsize = 12;
cfg.zlim = 'maxabs';
cfg.channel = grandavg_sta_win.label(ChanIndex);
ft_singleplotTFR(cfg,grandavg_sta_win)
% Lose
subplot(3,2,2)
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'Lose';
cfg.fontsize = 12;
cfg.zlim = 'maxabs';
cfg.channel = grandavg_sta_lose.label(ChanIndex);
ft_singleplotTFR(cfg,grandavg_sta_lose)
% Lose-Win
subplot(3,2,3:4)
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'Lose-Win';
cfg.fontsize = 12;
cfg.zlim = 'maxabs';
cfg.channel = stadiff.label(ChanIndex);
ft_singleplotTFR(cfg,stadiff)
% Epsi2
subplot(3,2,5:6)
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'epsi2';
cfg.fontsize = 12;
cfg.zlim = 'maxabs';
cfg.channel = grandavg_sta_win.label(ChanIndex);
ft_singleplotTFR(cfg,grandavg_sta_epsi2)
% Title
sgtitle('State Anxiety')
% Background Colour
set(gcf,'color','white')

%%                              Between Groups on epsi

% epsi
epsi2diff = grandavg_sta_epsi2;
epsi2diff.powspctrm = grandavg_sta_epsi2.powspctrm - grandavg_cont_epsi2.powspctrm;

% Plot
close all;
cfg = [];
% cfg.baseline = 'yes';
cfg.title = 'epsi2';
cfg.fontsize = 12;
cfg.zlim = 'maxabs'; % [-5, 5];
cfg.channel = epsi2diff.label(ChanIndex);
ft_singleplotTFR(cfg,epsi2diff)
% Title
sgtitle('Between Group (StA-Cont)')
% Background Colour
set(gcf,'color','white')

