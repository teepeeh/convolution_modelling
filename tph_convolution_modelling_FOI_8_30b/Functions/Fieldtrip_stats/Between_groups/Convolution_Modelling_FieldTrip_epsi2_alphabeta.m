%% Convolution Sanity Check #2 == epsi 2 between groups

% STATS ON ALPHA-BETA


% Plug in the matrix D.fttimelock.powspctrm for each participant into the
% corresponding field in Fieldtrip and run win versus lose stats in Fieldtrip
% with this convolution results. Make sure you change the sampling rate in
% the template fieldtrip data to 64Hz

%% Paths
rmpath(genpath('E:\tpDATA\tosc_data\tph_convolution_modelling'));
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
% eeglabpath = 'E:\eeglab14_1_2b';
% addpath(eeglabpath);
% FIELD TRIP
ftpath = 'E:\fieldtrip-20181024';
%% FIELD TRIP
% Add FieldTrip
addpath(genpath(ftpath));
ft_defaults;
% Make a template
addpath E:\tpDATA\EEG_data\tanxiety_oscillation_analysis\Wavelet\tanx_osc_30_01_2020\Wavelet\Data;
load('tanx_wavelet_Cont_win_IQR_AB_baselined.mat')
ft_template = Cont_wavelet_win_AB{1, 1};
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
%% Update Paths

rmpath(genpath(spmpath));
addpath(genpath(ftpath));
ft_defaults;

%% Load these fieldtrip convolution files into the grandavaerage

cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
% For plotting
%    cfg.keepindividual = ('no');
% For stats
cfg.keepindividual = ('yes');
cfg.method         = ('within');

grandavg_sta_epsi2 = ft_freqgrandaverage(cfg, ft_conv_sta_epsi2{:});
grandavg_cont_epsi2 = ft_freqgrandaverage(cfg, ft_conv_cont_epsi2{:});

%%                              Permutation testing


%% ROI

load chanlocs.mat

% chanslocs = string(chanlocs)';
% tpchannel_ROI_central_channels = ["Fpz"; "AFz"; "Fz"; "FCz"; "Cz"; "CPz"; "Pz"; "POz"; "Oz"];
% tpchannel_ROI_outside_central_channels = ["F1"; "FC1"; "C1"; "CP1"; "P1"; "P2"; "CP2"; "C2"; "FC2"; "F2"];
% tpchannel_ROI_outside_outside_central_channels = ["Fp1"; "AF3"; "F3"; "FC3"; "C3"; "CP3"; "P3"; "PO3"; "O1"; "O2"; "PO4";...
%     "P4"; "CP4"; "C4"; "FC4"; "F4"; "AF4"; "Fp2"];
% 
% extra_alpha_epsi2_chan = ["AF7"];
% 
% % ROI
% ROI_Central = match_str(chanslocs, tpchannel_ROI_central_channels);
% 
% % ROI outer central
% ROI_outer_central = [tpchannel_ROI_central_channels; tpchannel_ROI_outside_central_channels];
% ROI_Outer_Central = match_str(chanslocs, ROI_outer_central);
% 
% % ROI ALL central
% ROI_central_all = [tpchannel_ROI_central_channels; tpchannel_ROI_outside_central_channels; tpchannel_ROI_outside_outside_central_channels];
% ROI_Central_All = match_str(chanslocs, ROI_central_all);
% 
% % ROI alpha epsi2
% ROI_alpha_epsi2 = [extra_alpha_epsi2_chan; tpchannel_ROI_central_channels; tpchannel_ROI_outside_central_channels; tpchannel_ROI_outside_outside_central_channels];
% ROI_Alpha_Epsi2 = match_str(chanslocs, ROI_alpha_epsi2);

%%                              Neighbours

cfg=[];
cfg_neighb        = [];
cfg_neighb.method = 'distance';
cfg_neighb.layout =  'biosemi64.lay';
neighbours        = ft_prepare_neighbours(cfg_neighb, grandavg_sta_epsi2);
cfg.neighbours    = neighbours;

##########################################################################

%%                              Early TOI (100-500ms)
%% CFG stats
cfg.channel =  [1:64]; 
cfg.latency = [0.1, 0.5]; 
cfg.frequency = [8 30]; 
cfg.method = 'montecarlo';
cfg.statistic = 'ft_statfun_indepsamplesT';
cfg.correctm = 'cluster';
cfg.clusteralpha = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan = 2;
cfg.neighbours = neighbours; 
cfg.tail = 0;
cfg.clustertail = 0;
cfg.alpha = 0.05;
cfg.numrandomization = 5000;
cfg.clusterthreshold = ('nonparametric_common');
cfg.avgoverfreq = 'yes';
% Design
% Between groups
tptestdesign1 = ones(1,21);
tptestdesign2 = ones(1,21)+1;
tpdesign = cat(2,tptestdesign1, tptestdesign2);
cfg.design = tpdesign; 
cfg.ivar  = 1; 
%  Run Perm
[stat_epsi2_AB_100_500] = ft_freqstatistics(cfg, grandavg_sta_epsi2, grandavg_cont_epsi2);

%%                              STATS PLOTS

% Grand average for plotting
cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
cfg.keepindividual = ('no');
cfg.method         = ('within');
grandavg_P_sta_epsi2 = ft_freqgrandaverage(cfg, ft_conv_sta_epsi2{:});
grandavg_P_cont_epsi2 = ft_freqgrandaverage(cfg, ft_conv_cont_epsi2{:});

%% Getting TIME of clusters

load chanlocs.mat;
cfg = [];
cfg.alpha  = 0.07;
cfg.parameter = 'stat';
cfg.layout = 'biosemi64.lay';

g = ft_clusterplot(cfg, stat_epsi2_AB_100_500);

% Positive Cluster time
Pos1 = 'Positive cluster: 1, pvalue: 0.038192 (x), t = 0.13203 to 0.28047';
stat_epsi2_AB_100_500.significantclusters.Pos1.time = Pos1;
Pos2 = 'Positive cluster: 2, pvalue: 0.05179 (+), t = 0.35859 to 0.49922';
stat_epsi2_AB_100_500.significantclusters.Pos2.time = Pos2;

save('AB_between_stats_100_500_absEpsi2','stat_epsi2_AB_100_500')
%%                  Checking the significant ELECTRODES

% Check Electrodes Manually For Each Cluster
% Positive
% Get the cluster labels
tpsortingit = squeeze(stat_epsi2_AB_100_500.posclusterslabelmat);
X = sum(tpsortingit(:,9:47),2);
% Finding the time points trial by error
%     stat_epsi2_AB_100_500.time(9) 
%     stat_epsi2_AB_100_500.time(47)
minsampl = 25;
chPos = chanlocs(find(X > minsampl));
% Save electrodes
stat_epsi2_AB_100_500.significantclusters.Pos1.chanPos = chPos;

% pos 2 cluster

tpsortingit = squeeze(stat_epsi2_AB_100_500.posclusterslabelmat);
X = sum(tpsortingit(:,67:103),2);
% Finding the time points trial by error
%     stat_epsi2_AB_100_500.time(67) 
%     stat_epsi2_AB_100_500.time(103)
minsampl = 25;
chPos2 = chanlocs(find(X > minsampl));
% Save electrodes
stat_epsi2_AB_100_500.significantclusters.Pos2.chanPos = chPos2;

save('AB_between_stats_100_500_absEpsi2','stat_epsi2_AB_100_500')

%%                          PLOT


%%  epsi 2 - alpha-beta plot

% Data structure
epsi2_diff = grandavg_P_sta_epsi2;
% The difference (lose-win)
epsi2_diff.powspctrm = grandavg_P_sta_epsi2.powspctrm - grandavg_P_cont_epsi2.powspctrm;

%%                      earlier positive cluster

close all;
subplot(2,2,1)
cfg = [];
cfg.xlim             = [0.13 0.28]; 
cfg.ylim             = [8 30]; 
cfg.marker           = 'on';
cfg.colorbar         = 'yes';
cfg.layout           = 'biosemi64.lay';
cfg.shading          = 'flat'; % 'interp'; flat
% cfg.style            = 'both'; % both fill
cfg.comment          = 'no';
cfg.zlim             = 'maxabs';
cfg.markersymbol     = '.';
cfg.markercolor      = [0 0 0]; 
cfg.markersize       = 0.000000000001;
cfg.highlight        = 'on';
cfg.highlightsymbol  = '.'; % possible change to '.'
cfg.highlightsize    = 20;
cfg.highlightchannel = stat_epsi2_AB_100_500.significantclusters.Pos1.chanPos;
cfg.highlightcolor   = [0,0,0];
cfg.colorbar         = 'WestOutside';
% Subplot Version
ft_topoplotTFR(cfg, epsi2_diff);

txt = '130-280 ms';
t = text(0,0,txt);
t.FontSize = 20;

set(gca,'FontSize',20);
set(gcf,'color','white');


hold on;
subplot(2,2,3);
%                         Later positive cluster
cfg = [];
cfg.xlim             = [0.35 0.49]; 
cfg.ylim             = [8 30]; 
cfg.marker           = 'on';
cfg.colorbar         = 'yes';
cfg.layout           = 'biosemi64.lay';
cfg.shading          = 'flat'; % 'interp'; flat
% cfg.style            = 'both'; % both fill
cfg.comment          = 'no';
cfg.zlim             = 'maxabs';
cfg.markersymbol     = '.';
cfg.markercolor      = [0 0 0]; 
cfg.markersize       = 0.000000000001;
cfg.highlight        = 'on';
cfg.highlightsymbol  = '.'; % possible change to '.'
cfg.highlightsize    = 20;
cfg.highlightchannel = stat_epsi2_AB_100_500.significantclusters.Pos2.chanPos;
cfg.highlightcolor   = [0,0,0];
cfg.colorbar         = 'WestOutside';
% Subplot Version
ft_topoplotTFR(cfg, epsi2_diff);

set(gca,'FontSize',20);
set(gcf,'color','white');

txt = '350-499 ms';
t = text(0,0,txt);
t.FontSize = 20;

txt2 = 'Fz';
t2 = text(0,0,txt2);
t2.FontSize = 20;

hold on;
subplot(2,2,[4]);

% SINGLE PLOT for AVERAGE
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout       = 'biosemi64.lay';
cfg.baselinetype = 'absolute';
cfg.maskstyle    = 'saturation';
cfg.ylim         = [8 12];
cfg.xlim         = [-0.2 2]; 
cfg.zlim         = 'maxabs';
cfg.channel      = 'Fz';
cfg.title        = 'Alpha-Beta (StA-Cont) \epsilon2';
ylabel('Alpha')
ft_singleplotTFR(cfg, epsi2_diff);
set(gca,'FontSize',20);
set(gcf,'color','white');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

subplot(2,2,[2]);

% SINGLE PLOT for AVERAGE
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout       = 'biosemi64.lay';
cfg.baselinetype = 'absolute';
cfg.maskstyle    = 'saturation';
cfg.ylim         = [13 30];
cfg.xlim         = [-0.2 2]; 
cfg.zlim         = 'maxabs';
cfg.channel      = 'Fz';
cfg.title        = 'Fz';
ylabel('Beta')
ft_singleplotTFR(cfg, epsi2_diff);
set(gca,'FontSize',20);
set(gcf,'color','white');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);


##########################################################################



%%                              Later TOI (1000-1600ms)


%%                              Neighbours

cfg=[];
cfg_neighb        = [];
cfg_neighb.method = 'distance';
cfg_neighb.layout =  'biosemi64.lay';
neighbours        = ft_prepare_neighbours(cfg_neighb, grandavg_sta_epsi2);
cfg.neighbours    = neighbours;
%% CFG stats
cfg.channel =  [1:64]; 
cfg.latency = [1, 1.6]; 
cfg.frequency = [8 30]; 
cfg.method = 'montecarlo';
cfg.statistic = 'ft_statfun_indepsamplesT';
cfg.correctm = 'cluster';
cfg.clusteralpha = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan = 2;
cfg.neighbours = neighbours; 
cfg.tail = 0;
cfg.clustertail = 0;
cfg.alpha = 0.05;
cfg.numrandomization = 5000;
cfg.clusterthreshold = ('nonparametric_common');
cfg.avgoverfreq = 'yes';
% Design
% Between groups
tptestdesign1 = ones(1,21);
tptestdesign2 = ones(1,21)+1;
tpdesign = cat(2,tptestdesign1, tptestdesign2);
cfg.design = tpdesign; 
cfg.ivar  = 1; 

[stat_epsi2_AB_1000_1600] = ft_freqstatistics(cfg, grandavg_sta_epsi2, grandavg_cont_epsi2);

%%                              STATS PLOTS

% Grand average for plotting
cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
cfg.keepindividual = ('no');
cfg.method         = ('within');
grandavg_P_sta_epsi2 = ft_freqgrandaverage(cfg, ft_conv_sta_epsi2{:});
grandavg_P_cont_epsi2 = ft_freqgrandaverage(cfg, ft_conv_cont_epsi2{:});

%% Getting TIME of clusters

load chanlocs.mat;
cfg = [];
cfg.alpha  = 0.06;
cfg.parameter = 'stat';
cfg.layout = 'biosemi64.lay';

g = ft_clusterplot(cfg, stat_epsi2_AB_1000_1600);

% Positive Cluster time
Pos1 = 'Positive cluster: 1, pvalue: 0.028794 (x), t = 1.218 to 1.5578';
stat_epsi2_AB_1000_1600.significantclusters.Pos1.time = Pos1;

save('AB_between_stats_1000_1600_absEpsi2','stat_epsi2_AB_1000_1600')


%%                  Checking the significant ELECTRODES

% EARLY
tpsortingit = squeeze(stat_epsi2_AB_1000_1600.posclusterslabelmat);
X = sum(tpsortingit(:,58:100),2);
% Finding the time points trial by error
%     stat_epsi2_AB_1000_1600.time(58) 
%     stat_epsi2_AB_1000_1600.time(100)
minsampl = 25;
chPos = chanlocs(find(X > minsampl));
% Save electrodes
stat_epsi2_AB_1000_1600.significantclusters.Pos1.chanPos_EARLY = chPos;

% LATER

tpsortingit = squeeze(stat_epsi2_AB_1000_1600.posclusterslabelmat);
X = sum(tpsortingit(:,100:144),2);
% Finding the time points trial by error
%     stat_epsi2_AB_1000_1600.time(100) 
%     stat_epsi2_AB_1000_1600.time(144)
minsampl = 25;
chPos2 = chanlocs(find(X > minsampl));
% Save electrodes
stat_epsi2_AB_1000_1600.significantclusters.Pos1.chanPos_LATER = chPos2;


save('AB_between_stats_1000_1600_absEpsi2','stat_epsi2_AB_1000_1600')


%%                          PLOT


%%  epsi 2 - alpha-beta plot

% Data structure
epsi2_diff = grandavg_P_sta_epsi2;
% The difference (lose-win)
epsi2_diff.powspctrm = grandavg_P_sta_epsi2.powspctrm - grandavg_P_cont_epsi2.powspctrm;

%%                      earlier positive cluster
close all;
subplot(2,2,1)
cfg = [];
cfg.xlim             = [1.22 1.38]; 
cfg.ylim             = [8 30]; 
cfg.marker           = 'on';
cfg.colorbar         = 'yes';
cfg.layout           = 'biosemi64.lay';
cfg.shading          = 'flat'; % 'interp'; flat
% cfg.style            = 'both'; % both fill
cfg.comment          = 'no';
cfg.zlim             = 'maxabs';
cfg.markersymbol     = '.';
cfg.markercolor      = [0 0 0]; 
cfg.markersize       = 0.000000000001;
cfg.highlight        = 'on';
cfg.highlightsymbol  = '.'; % possible change to '.'
cfg.highlightsize    = 20;
cfg.highlightchannel = stat_epsi2_AB_1000_1600.significantclusters.Pos1.chanPos_EARLY;
cfg.highlightcolor   = [0,0,0];
cfg.colorbar         = 'WestOutside';
% Subplot Version
ft_topoplotTFR(cfg, epsi2_diff);

txt = '1220-1380 ms';
t = text(0,0,txt);
t.FontSize = 20;

set(gca,'FontSize',20);
set(gcf,'color','white');


hold on;
subplot(2,2,3);
%                         Later positive cluster
cfg = [];
cfg.xlim             = [1.38 1.55]; 
cfg.ylim             = [8 30]; 
cfg.marker           = 'on';
cfg.colorbar         = 'yes';
cfg.layout           = 'biosemi64.lay';
cfg.shading          = 'flat'; % 'interp'; flat
% cfg.style            = 'both'; % both fill
cfg.comment          = 'no';
cfg.zlim             = 'maxabs';
cfg.markersymbol     = '.';
cfg.markercolor      = [0 0 0]; 
cfg.markersize       = 0.000000000001;
cfg.highlight        = 'on';
cfg.highlightsymbol  = '.'; % possible change to '.'
cfg.highlightsize    = 20;
cfg.highlightchannel = stat_epsi2_AB_1000_1600.significantclusters.Pos1.chanPos_LATER;
cfg.highlightcolor   = [0,0,0];
cfg.colorbar         = 'WestOutside';
% Subplot Version
ft_topoplotTFR(cfg, epsi2_diff);

set(gca,'FontSize',20);
set(gcf,'color','white');

txt = '1380-1550 ms';
t = text(0,0,txt);
t.FontSize = 20;

txt2 = 'Fz';
t2 = text(0,0,txt2);
t2.FontSize = 20;

hold on;
subplot(2,2,[4]);

% SINGLE PLOT for AVERAGE
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout       = 'biosemi64.lay';
cfg.baselinetype = 'absolute';
cfg.maskstyle    = 'saturation';
cfg.ylim         = [8 12];
cfg.xlim         = [-0.2 2]; 
cfg.zlim         = 'maxabs';
cfg.channel      = 'Fz';
cfg.title        = 'Alpha-Beta (StA-Cont) \epsilon2';
ylabel('Alpha')
ft_singleplotTFR(cfg, epsi2_diff);
set(gca,'FontSize',20);
set(gcf,'color','white');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

subplot(2,2,[2]);

% SINGLE PLOT for AVERAGE
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout       = 'biosemi64.lay';
cfg.baselinetype = 'absolute';
cfg.maskstyle    = 'saturation';
cfg.ylim         = [13 30];
cfg.xlim         = [-0.2 2]; 
cfg.zlim         = 'maxabs';
cfg.channel      = 'Fz';
ylabel('Beta')
ft_singleplotTFR(cfg, epsi2_diff);
set(gca,'FontSize',20);
set(gcf,'color','white');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);



##########################################################################



%%                              ALL TOI (100-1600ms)

%% CFG stats
cfg.channel =  [1:64]; 
cfg.latency = [0.1, 1.6]; 
cfg.frequency = [8 30]; 
cfg.method = 'montecarlo';
cfg.statistic = 'ft_statfun_indepsamplesT';
cfg.correctm = 'cluster';
cfg.clusteralpha = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan = 2;
cfg.neighbours = neighbours; 
cfg.tail = 0;
cfg.clustertail = 0;
cfg.alpha = 0.05;
cfg.numrandomization = 5000;
cfg.clusterthreshold = ('nonparametric_common');
cfg.avgoverfreq = 'yes';
% Design
% Between groups
tptestdesign1 = ones(1,21);
tptestdesign2 = ones(1,21)+1;
tpdesign = cat(2,tptestdesign1, tptestdesign2);
cfg.design = tpdesign; 
cfg.ivar  = 1; 
%  Run Perm
[stat_epsi2_AB_100_1600] = ft_freqstatistics(cfg, grandavg_sta_epsi2, grandavg_cont_epsi2);

%%                              STATS PLOTS

% Grand average for plotting
cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
cfg.keepindividual = ('no');
cfg.method         = ('within');
grandavg_P_sta_epsi2 = ft_freqgrandaverage(cfg, ft_conv_sta_epsi2{:});
grandavg_P_cont_epsi2 = ft_freqgrandaverage(cfg, ft_conv_cont_epsi2{:});

%% Getting TIME of clusters

load chanlocs.mat;
cfg = [];
cfg.alpha  = 0.07;
cfg.parameter = 'stat';
cfg.layout = 'biosemi64.lay';

g = ft_clusterplot(cfg, stat_epsi2_AB_100_1600);

% Positive Cluster time
Pos1 = 'Positive cluster: 1, pvalue: 0.054389 (+), t = 1.218 to 1.5578';
stat_epsi2_AB_100_1600.significantclusters.Pos1.time = Pos1;

save('AB_between_stats_100_1600_absEpsi2','stat_epsi2_AB_100_1600')
%%                  Checking the significant ELECTRODES

% Early part of cluster ( t = 1.218 - 1.49)

tpsortingit = squeeze(stat_epsi2_AB_100_1600.posclusterslabelmat);
X = sum(tpsortingit(:,287:357),2);
% Finding the time points trial by error
%     stat_epsi2_AB_100_1600.time(287) 
%     stat_epsi2_AB_100_1600.time(357)
minsampl = 25;
chPos = chanlocs(find(X > minsampl));

% Save electrodes
stat_epsi2_AB_100_1600.significantclusters.Pos1.chanPos_Early = chPos;

% Later part of cluster

tpsortingit = squeeze(stat_epsi2_AB_100_1600.posclusterslabelmat);
X = sum(tpsortingit(:,357:374),2);
% Finding the time points trial by error
%     stat_epsi2_AB_100_1600.time(330) 
%     stat_epsi2_AB_100_1600.time(374)
minsampl = 25;
chPos = chanlocs(find(X > minsampl));
% Save electrodes
stat_epsi2_AB_100_1600.significantclusters.Pos1.chanPos_Later = chPos;


save('AB_between_stats_100_1600_absEpsi2','stat_epsi2_AB_100_1600')

%%                          PLOT


%%  epsi 2 - alpha-beta plot

% Data structure
epsi2_diff = grandavg_P_sta_epsi2;
% The difference (lose-win)
epsi2_diff.powspctrm = grandavg_P_sta_epsi2.powspctrm - grandavg_P_cont_epsi2.powspctrm;

%%                      earlier positive cluster

close all;

subplot(2,2,1)
cfg = [];
cfg.xlim             = [1.2 1.45]; 
cfg.ylim             = [8 30]; 
cfg.marker           = 'on';
cfg.colorbar         = 'yes';
cfg.layout           = 'biosemi64.lay';
cfg.shading          = 'flat'; % 'interp'; flat
% cfg.style            = 'both'; % both fill
cfg.comment          = 'no';
cfg.zlim             = 'maxabs';
cfg.markersymbol     = '.';
cfg.markercolor      = [0 0 0]; 
cfg.markersize       = 0.000000000001;
cfg.highlight        = 'on';
cfg.highlightsymbol  = '.'; % possible change to '.'
cfg.highlightsize    = 20;
cfg.highlightchannel = stat_epsi2_AB_100_1600.significantclusters.Pos1.chanPos_Early;
cfg.highlightcolor   = [0,0,0];
cfg.colorbar         = 'WestOutside';
% Subplot Version
ft_topoplotTFR(cfg, epsi2_diff);


txt = '1200-1400 ms';
t = text(0,0,txt);
t.FontSize = 20;

set(gca,'FontSize',20);
set(gcf,'color','white');

hold on

subplot(2,2,3)
cfg = [];
cfg.xlim             = [1.5 1.6]; 
cfg.ylim             = [8 30]; 
cfg.marker           = 'on';
cfg.colorbar         = 'yes';
cfg.layout           = 'biosemi64.lay';
cfg.shading          = 'flat'; % 'interp'; flat
% cfg.style            = 'both'; % both fill
cfg.comment          = 'no';
cfg.zlim             = 'maxabs';
cfg.markersymbol     = '.';
cfg.markercolor      = [0 0 0]; 
cfg.markersize       = 0.000000000001;
cfg.highlight        = 'on';
cfg.highlightsymbol  = '.'; % possible change to '.'
cfg.highlightsize    = 20;
cfg.highlightchannel = stat_epsi2_AB_100_1600.significantclusters.Pos1.chanPos_Later;
cfg.highlightcolor   = [0,0,0];
cfg.colorbar         = 'WestOutside';
ft_topoplotTFR(cfg, epsi2_diff);

set(gca,'FontSize',20);
set(gcf,'color','white');


txt = '1400-1560 ms';
t = text(0,0,txt);
t.FontSize = 20;


hold on;

subplot(2,2,[4]);

% SINGLE PLOT for AVERAGE
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout       = 'biosemi64.lay';
cfg.baselinetype = 'absolute';
cfg.maskstyle    = 'saturation';
cfg.ylim         = [8 12];
cfg.xlim         = [-0.2 2]; 
cfg.zlim         = 'maxabs';
cfg.channel      = 'Fz';
cfg.title        = 'Alpha-Beta (StA-Cont) \epsilon2';
ylabel('Alpha')
ft_singleplotTFR(cfg, epsi2_diff);
set(gca,'FontSize',20);
set(gcf,'color','white');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

subplot(2,2,[2]);

% SINGLE PLOT for AVERAGE
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout       = 'biosemi64.lay';
cfg.baselinetype = 'absolute';
cfg.maskstyle    = 'saturation';
cfg.ylim         = [13 30];
cfg.xlim         = [-0.2 2]; 
cfg.zlim         = 'maxabs';
cfg.channel      = 'Fz';
cfg.title        = 'Fz';
ylabel('Beta')
ft_singleplotTFR(cfg, epsi2_diff);
set(gca,'FontSize',20);
set(gcf,'color','white');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);



##########################################################################


%%                              MID TOI (500-1000ms)
%% CFG stats
cfg.channel =  [1:64]; 
cfg.latency = [0.5, 1]; 
cfg.frequency = [8 30]; 
cfg.method = 'montecarlo';
cfg.statistic = 'ft_statfun_indepsamplesT';
cfg.correctm = 'cluster';
cfg.clusteralpha = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan = 2;
cfg.neighbours = neighbours; 
cfg.tail = 0;
cfg.clustertail = 0;
cfg.alpha = 0.05;
cfg.numrandomization = 5000;
cfg.clusterthreshold = ('nonparametric_common');
cfg.avgoverfreq = 'yes';
% Design
% Between groups
tptestdesign1 = ones(1,21);
tptestdesign2 = ones(1,21)+1;
tpdesign = cat(2,tptestdesign1, tptestdesign2);
cfg.design = tpdesign; 
cfg.ivar  = 1; 
%  Run Perm
[stat_epsi2_AB_500_1000] = ft_freqstatistics(cfg, grandavg_sta_epsi2, grandavg_cont_epsi2);

%%                              STATS PLOTS

% Grand average for plotting
cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
cfg.keepindividual = ('no');
cfg.method         = ('within');
grandavg_P_sta_epsi2 = ft_freqgrandaverage(cfg, ft_conv_sta_epsi2{:});
grandavg_P_cont_epsi2 = ft_freqgrandaverage(cfg, ft_conv_cont_epsi2{:});

%% Getting TIME of clusters

load chanlocs.mat;
cfg = [];
cfg.alpha  = 0.07;
cfg.parameter = 'stat';
cfg.layout = 'biosemi64.lay';

g = ft_clusterplot(cfg, stat_epsi2_AB_500_1000);

% Positive Cluster time
Pos1 = 'Positive cluster: 1, pvalue: 0.039192 (x), t = 0.13203 to 0.28437';
stat_epsi2_AB_500_1000.significantclusters.Pos1.time = Pos1;
Pos2 = 'Positive cluster: 2, pvalue: 0.04959 (x), t = 0.35469 to 0.49922';
stat_epsi2_AB_500_1000.significantclusters.Pos2.time = Pos2;
%%                  Checking the significant ELECTRODES

% Check Electrodes Manually For Each Cluster
% Positive
% Get the cluster labels
tpsortingit = squeeze(stat_epsi2_AB_500_1000.posclusterslabelmat);
X = sum(tpsortingit(:,9:47),2);
% Finding the time points trial by error
%     stat_epsi2_AB_500_1000.time(9) 
%     stat_epsi2_AB_500_1000.time(47)
minsampl = 25;
chPos = chanlocs(find(X > minsampl));
% Save electrodes
stat_epsi2_AB_500_1000.significantclusters.Pos1.chanPos = chPos;

% pos 2 cluster

tpsortingit = squeeze(stat_epsi2_AB_500_1000.posclusterslabelmat);
X = sum(tpsortingit(:,67:103),2);
% Finding the time points trial by error
%     stat_epsi2_AB_500_1000.time(67) 
%     stat_epsi2_AB_500_1000.time(103)
minsampl = 25;
chPos2 = chanlocs(find(X > minsampl));
% Save electrodes
stat_epsi2_AB_500_1000.significantclusters.Pos2.chanPos = chPos2;

%%                          PLOT


%%  epsi 2 - alpha-beta plot

% Data structure
epsi2_diff = grandavg_P_sta_epsi2;
% The difference (lose-win)
epsi2_diff.powspctrm = grandavg_P_sta_epsi2.powspctrm - grandavg_P_cont_epsi2.powspctrm;

%%                      earlier positive cluster
close all;
subplot(2,2,1)
cfg = [];
cfg.xlim             = [0.13 0.28]; 
cfg.ylim             = [8 30]; 
cfg.marker           = 'on';
cfg.colorbar         = 'yes';
cfg.layout           = 'biosemi64.lay';
cfg.shading          = 'flat'; % 'interp'; flat
% cfg.style            = 'both'; % both fill
cfg.comment          = 'no';
cfg.zlim             = 'maxabs';
cfg.markersymbol     = '.';
cfg.markercolor      = [0 0 0]; 
cfg.markersize       = 0.000000000001;
cfg.highlight        = 'on';
cfg.highlightsymbol  = '.'; % possible change to '.'
cfg.highlightsize    = 20;
cfg.highlightchannel = stat_epsi2_AB_500_1000.significantclusters.Pos1.chanPos;
cfg.highlightcolor   = [0,0,0];
cfg.colorbar         = 'WestOutside';
% Subplot Version
ft_topoplotTFR(cfg, epsi2_diff);

txt = '130-280 ms';
t = text(0,0,txt);
t.FontSize = 20;

set(gca,'FontSize',20);
set(gcf,'color','white');


hold on;
subplot(2,2,3);
%                         Later positive cluster
cfg = [];
cfg.xlim             = [0.35 0.49]; 
cfg.ylim             = [8 30]; 
cfg.marker           = 'on';
cfg.colorbar         = 'yes';
cfg.layout           = 'biosemi64.lay';
cfg.shading          = 'flat'; % 'interp'; flat
% cfg.style            = 'both'; % both fill
cfg.comment          = 'no';
cfg.zlim             = 'maxabs';
cfg.markersymbol     = '.';
cfg.markercolor      = [0 0 0]; 
cfg.markersize       = 0.000000000001;
cfg.highlight        = 'on';
cfg.highlightsymbol  = '.'; % possible change to '.'
cfg.highlightsize    = 20;
cfg.highlightchannel = stat_epsi2_AB_500_1000.significantclusters.Pos2.chanPos;
cfg.highlightcolor   = [0,0,0];
cfg.colorbar         = 'WestOutside';
% Subplot Version
ft_topoplotTFR(cfg, epsi2_diff);

set(gca,'FontSize',20);
set(gcf,'color','white');

txt = '350-499 ms';
t = text(0,0,txt);
t.FontSize = 20;

txt2 = 'Fz';
t2 = text(0,0,txt2);
t2.FontSize = 20;

hold on;
subplot(2,2,[4]);

% SINGLE PLOT for AVERAGE
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout       = 'biosemi64.lay';
cfg.baselinetype = 'absolute';
cfg.maskstyle    = 'saturation';
cfg.ylim         = [8 12];
cfg.xlim         = [-0.2 2]; 
cfg.zlim         = 'maxabs';
cfg.channel      = 'Fz';
cfg.title        = 'Alpha-Beta (StA-Cont) \epsilon2';
ylabel('Alpha')
ft_singleplotTFR(cfg, epsi2_diff);
set(gca,'FontSize',20);
set(gcf,'color','white');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

subplot(2,2,[2]);

% SINGLE PLOT for AVERAGE
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout       = 'biosemi64.lay';
cfg.baselinetype = 'absolute';
cfg.maskstyle    = 'saturation';
cfg.ylim         = [13 30];
cfg.xlim         = [-0.2 2]; 
cfg.zlim         = 'maxabs';
cfg.channel      = 'Fz';
ylabel('Beta')
ft_singleplotTFR(cfg, epsi2_diff);
set(gca,'FontSize',20);
set(gcf,'color','white');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
