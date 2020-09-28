%% # 3 Within group tests FIELDTRIP on convolution data

%% UPDATED:

% for combined alpha and beta stats ++ only the significant comparisons
%(epsi2 late alpha-beta, epsi3 early and late alpha-beta)

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


%% Update FT Path
rmpath(spmpath);
addpath(genpath(ftpath));
ft_defaults;

%% Extracting data based on TOI = new powspctrm + time
%% Choose regressor + time window
% For loop
% cases = {'epsilon2 late alpha-beta';'epsilon3 late alpha-beta';'epsilon3 early alpha-beta'};
cases = {'epsilon2 early alpha-beta','epsilon2 late alpha-beta','epsilon2 all alpha-beta'};
%% RUN  //  k = case number 
for k = 1
    % mycase = case1;
    mycase = cell2mat(cases(k));
    switch mycase
        case 'epsilon2 early alpha-beta'
            frequency = [8 30]; % [8 25];
            % Baseline
            % TOI using time
            mytime = ft_conv_sta_epsi2{1}.time; % time vector in ms  -200:2000 ms in one participant
            blTOI = [-0.2 0]; % Seconds
            bl_start = find(min(abs(blTOI(1) - mytime)) == abs(blTOI(1)  - mytime));
            bl_end = find(min(abs(blTOI(2) - mytime)) == abs(blTOI(2)  - mytime));
            % Extract data
            for i = 1:21
                % State anxiety
                StA_bl{i,1} = ft_conv_sta_epsi2{i};
                StA_bl{i,1}.time  = StA_bl{i,1}.time([bl_start:bl_end]);
                StA_bl{i,1}.powspctrm = nanmean(StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
                % Controls
                Cont_bl{i,1} = ft_conv_cont_epsi2{i};
                Cont_bl{i,1}.time = Cont_bl{i,1}.time([bl_start:bl_end]);
                Cont_bl{i,1}.powspctrm = nanmean(Cont_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
            end
            
            % Activation
            actTOI = [0.1 0.5]; %in seconds, careful, fieldtrip time field is in seconds
            act_start = find(min(abs(actTOI(1) - mytime)) == abs(actTOI(1)  - mytime));
            act_end = find(min(abs(actTOI(2) - mytime)) == abs(actTOI(2)  - mytime));
            for i = 1:21
                % State anxiety
                StA_act{i,1} = ft_conv_sta_epsi2{i};
                StA_act{i,1}.time = ft_conv_sta_epsi2{i,1}.time([act_start:act_end]);
                StA_act{i,1}.powspctrm = StA_act{i,1}.powspctrm(:,:,[act_start:act_end]);
                % Controls
                Cont_act{i,1} = ft_conv_cont_epsi2{i};
                Cont_act{i,1}.time = ft_conv_cont_epsi2{i,1}.time([act_start:act_end]);
                Cont_act{i,1}.powspctrm = Cont_act{i,1}.powspctrm(:,:,[act_start:act_end]);
            end
            
            % Repmat Baseline
            for i = 1:21
                base_repmat_sta = (StA_bl{i,1}.powspctrm);
                base_repmat_cont = (Cont_bl{i,1}.powspctrm);
                for n = 2:length([act_start:act_end])
                    StA_bl{i,1}.powspctrm(:,:,n) = repmat(base_repmat_sta, [1,1]);
                    Cont_bl{i,1}.powspctrm(:,:,n) = repmat(base_repmat_cont, [1,1]);
                end
                clear base_repmat_sta base_repmat_cont
            end
            
            % Baseline time
            for i = 1:21
                StA_bl{i,1}.time = StA_act{i,1}.time;
                Cont_bl{i,1}.time = Cont_act{i,1}.time;
            end
            
        case 'epsilon2 late alpha-beta'
            frequency = [8 30];
            % Baseline
            % TOI using time
            mytime = ft_conv_sta_epsi2{1}.time; % time vector in ms  -200:2000 ms in one participant
            blTOI = [-0.2 0]; % Seconds
            bl_start = find(min(abs(blTOI(1) - mytime)) == abs(blTOI(1)  - mytime));
            bl_end = find(min(abs(blTOI(2) - mytime)) == abs(blTOI(2)  - mytime));
            % Extract data
            for i = 1:21
                % State anxiety
                StA_bl{i,1} = ft_conv_sta_epsi2{i};
                StA_bl{i,1}.time  = StA_bl{i,1}.time([bl_start:bl_end]);
                StA_bl{i,1}.powspctrm = nanmean(StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
                % Controls
                Cont_bl{i,1} = ft_conv_cont_epsi2{i};
                Cont_bl{i,1}.time = Cont_bl{i,1}.time([bl_start:bl_end]);
                Cont_bl{i,1}.powspctrm = nanmean(Cont_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
            end
            
            % Activation
            actTOI = [0.5 1.5]; %in seconds, careful, fieldtrip time field is in seconds
            act_start = find(min(abs(actTOI(1) - mytime)) == abs(actTOI(1)  - mytime));
            act_end = find(min(abs(actTOI(2) - mytime)) == abs(actTOI(2)  - mytime));
            for i = 1:21
                % State anxiety
                StA_act{i,1} = ft_conv_sta_epsi2{i};
                StA_act{i,1}.time = ft_conv_sta_epsi2{i,1}.time([act_start:act_end]);
                StA_act{i,1}.powspctrm = StA_act{i,1}.powspctrm(:,:,[act_start:act_end]);
                % Controls
                Cont_act{i,1} = ft_conv_cont_epsi2{i};
                Cont_act{i,1}.time = ft_conv_cont_epsi2{i,1}.time([act_start:act_end]);
                Cont_act{i,1}.powspctrm = Cont_act{i,1}.powspctrm(:,:,[act_start:act_end]);
            end
            
            % Repmat Baseline
            for i = 1:21
                base_repmat_sta = (StA_bl{i,1}.powspctrm);
                base_repmat_cont = (Cont_bl{i,1}.powspctrm);
                for n = 2:length([act_start:act_end])
                    StA_bl{i,1}.powspctrm(:,:,n) = repmat(base_repmat_sta, [1,1]);
                    Cont_bl{i,1}.powspctrm(:,:,n) = repmat(base_repmat_cont, [1,1]);
                end
                clear base_repmat_sta base_repmat_cont
            end
            
            % Baseline time
            for i = 1:21
                StA_bl{i,1}.time = StA_act{i,1}.time;
                Cont_bl{i,1}.time = Cont_act{i,1}.time;
            end
            
            
        case 'epsilon2 all alpha-beta'
            frequency = [8 30];
            % Baseline
            % TOI using time
            mytime = ft_conv_sta_epsi2{1}.time; % time vector in ms  -200:2000 ms in one participant
            blTOI = [-0.2 0]; % Seconds
            bl_start = find(min(abs(blTOI(1) - mytime)) == abs(blTOI(1)  - mytime));
            bl_end = find(min(abs(blTOI(2) - mytime)) == abs(blTOI(2)  - mytime));
            % Extract data
            for i = 1:21
                % State anxiety
                StA_bl{i,1} = ft_conv_sta_epsi2{i};
                StA_bl{i,1}.time  = StA_bl{i,1}.time([bl_start:bl_end]);
                StA_bl{i,1}.powspctrm = nanmean(StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
                % Controls
                Cont_bl{i,1} = ft_conv_cont_epsi2{i};
                Cont_bl{i,1}.time = Cont_bl{i,1}.time([bl_start:bl_end]);
                Cont_bl{i,1}.powspctrm = nanmean(Cont_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
            end
            
            % Activation
            actTOI = [0.1 1.6]; %in seconds, careful, fieldtrip time field is in seconds
            act_start = find(min(abs(actTOI(1) - mytime)) == abs(actTOI(1)  - mytime));
            act_end = find(min(abs(actTOI(2) - mytime)) == abs(actTOI(2)  - mytime));
            for i = 1:21
                % State anxiety
                StA_act{i,1} = ft_conv_sta_epsi2{i};
                StA_act{i,1}.time = ft_conv_sta_epsi2{i,1}.time([act_start:act_end]);
                StA_act{i,1}.powspctrm = StA_act{i,1}.powspctrm(:,:,[act_start:act_end]);
                % Controls
                Cont_act{i,1} = ft_conv_cont_epsi2{i};
                Cont_act{i,1}.time = ft_conv_cont_epsi2{i,1}.time([act_start:act_end]);
                Cont_act{i,1}.powspctrm = Cont_act{i,1}.powspctrm(:,:,[act_start:act_end]);
            end
            
            % Repmat Baseline
            for i = 1:21
                base_repmat_sta = (StA_bl{i,1}.powspctrm);
                base_repmat_cont = (Cont_bl{i,1}.powspctrm);
                for n = 2:length([act_start:act_end])
                    StA_bl{i,1}.powspctrm(:,:,n) = repmat(base_repmat_sta, [1,1]);
                    Cont_bl{i,1}.powspctrm(:,:,n) = repmat(base_repmat_cont, [1,1]);
                end
                clear base_repmat_sta base_repmat_cont
            end
            
            % Baseline time
            for i = 1:21
                StA_bl{i,1}.time = StA_act{i,1}.time;
                Cont_bl{i,1}.time = Cont_act{i,1}.time;
            end
    end
    
    %% FT grand avaerage
    % Keeping individuals
    cfg = [];
    cfg.channel = [1:64];
    cfg.latency        = ('all');
    cfg.keepindividual = ('yes');
    cfg.method         = ('within');
    % Baseline
    grandavg_sta_bl = ft_freqgrandaverage(cfg, StA_bl{:});
    grandavg_cont_bl = ft_freqgrandaverage(cfg, Cont_bl{:});
    % Activation
    grandavg_sta_act = ft_freqgrandaverage(cfg, StA_act{:});
    grandavg_cont_act = ft_freqgrandaverage(cfg, Cont_act{:});
    %% STATS
    
    switch mycase
        case 'epsilon2 early alpha-beta'
            
            % STA
            cfg = [];
            cfg.channel          = [1:64];
            cfg.method           = 'montecarlo';
            cfg.frequency        = frequency;
            cfg.statistic        = 'ft_statfun_depsamplesT'; % 'ft_statfun_depsamplesT'; ft_statfun_actvsblT
            cfg.correctm         = 'cluster';
            cfg.clusteralpha     = 0.05;
            cfg.clusterstatistic = 'maxsum';
            cfg.minnbchan        = 2;
            cfg.tail             = 0;
            cfg.clustertail      = 0;
            cfg.alpha            = 0.05;
            cfg.numrandomization = 5000;
            % Neighbours
            cfg_neighb.method    = 'distance';
            cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, StA_act{1});
            cfg.avgoverfreq = 'yes';
            % Groups
            % Design
            subj = 21;
            design = zeros(2,2*subj);
            for i = 1:subj
                design(1,i) = i;
            end
            for i = 1:subj
                design(1,subj+i) = i;
            end
            design(2,1:subj)        = 1;
            design(2,subj+1:2*subj) = 2;
            cfg.design = design;
            cfg.uvar  = 1;
            cfg.ivar  = 2;
            % Stats
            [stats_StA_absEpsi2_early_AB] = ft_freqstatistics(cfg, grandavg_sta_act, grandavg_sta_bl);
            [stats_Cont_absEpsi2_early_AB] = ft_freqstatistics(cfg, grandavg_cont_act, grandavg_cont_bl);
            
        case 'epsilon2 late alpha-beta'
            
            % STA
            cfg = [];
            cfg.channel          = [1:64];
            cfg.method           = 'montecarlo';
            cfg.frequency        = frequency;
            cfg.statistic        = 'ft_statfun_depsamplesT'; % 'ft_statfun_depsamplesT'; ft_statfun_actvsblT
            cfg.correctm         = 'cluster';
            cfg.clusteralpha     = 0.05;
            cfg.clusterstatistic = 'maxsum';
            cfg.minnbchan        = 2;
            cfg.tail             = 0;
            cfg.clustertail      = 0;
            cfg.alpha            = 0.05;
            cfg.numrandomization = 5000;
            % Neighbours
            cfg_neighb.method    = 'distance';
            cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, StA_act{1});
            cfg.avgoverfreq = 'yes';
            % Groups
            % Design
            subj = 21;
            design = zeros(2,2*subj);
            for i = 1:subj
                design(1,i) = i;
            end
            for i = 1:subj
                design(1,subj+i) = i;
            end
            design(2,1:subj)        = 1;
            design(2,subj+1:2*subj) = 2;
            cfg.design = design;
            cfg.uvar  = 1;
            cfg.ivar  = 2;
            % Stats
            [stats_StA_absEpsi2_late_AB] = ft_freqstatistics(cfg, grandavg_sta_act, grandavg_sta_bl);
            [stats_Cont_absEpsi2_late_AB] = ft_freqstatistics(cfg, grandavg_cont_act, grandavg_cont_bl);
            
            clear frequency mytime blTOI bl_start bl_end ...
                actTOI act_start act_end design filetag
            
            
            
        case 'epsilon2 all alpha-beta'
            
            % STA
            cfg = [];
            cfg.channel          = [1:64];
            cfg.method           = 'montecarlo';
            cfg.frequency        = frequency;
            cfg.statistic        = 'ft_statfun_depsamplesT'; % 'ft_statfun_depsamplesT'; ft_statfun_actvsblT
            cfg.correctm         = 'cluster';
            cfg.clusteralpha     = 0.05;
            cfg.clusterstatistic = 'maxsum';
            cfg.minnbchan        = 2;
            cfg.tail             = 0;
            cfg.clustertail      = 0;
            cfg.alpha            = 0.05;
            cfg.numrandomization = 5000;
            % Neighbours
            cfg_neighb.method    = 'distance';
            cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, StA_act{1});
            cfg.avgoverfreq = 'yes';
            % Groups
            % Design
            subj = 21;
            design = zeros(2,2*subj);
            for i = 1:subj
                design(1,i) = i;
            end
            for i = 1:subj
                design(1,subj+i) = i;
            end
            design(2,1:subj)        = 1;
            design(2,subj+1:2*subj) = 2;
            cfg.design = design;
            cfg.uvar  = 1;
            cfg.ivar  = 2;
            % Stats
            [stats_StA_absEpsi2_all_AB] = ft_freqstatistics(cfg, grandavg_sta_act, grandavg_sta_bl);
            [stats_Cont_absEpsi2_all_AB] = ft_freqstatistics(cfg, grandavg_cont_act, grandavg_cont_bl);
            
            clear frequency mytime blTOI bl_start bl_end ...
                actTOI act_start act_end design filetag
    end
end

%%                              STATS PLOT DATA

% Grand average for plotting
cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
cfg.keepindividual = ('no');
cfg.method         = ('within');
% Baseline
grandavg_sta_bl = ft_freqgrandaverage(cfg, StA_bl{:});
grandavg_cont_bl = ft_freqgrandaverage(cfg, Cont_bl{:});
% Activation
grandavg_sta_act = ft_freqgrandaverage(cfg, StA_act{:});
grandavg_cont_act = ft_freqgrandaverage(cfg, Cont_act{:});
% For plotting TFR
% Basline
grandavg_sta_bl_plot = ft_freqgrandaverage(cfg, StA_bl{:});
grandavg_cont_bl_plot = ft_freqgrandaverage(cfg, Cont_bl{:});
% Activation
grandavg_sta_act_plot = ft_freqgrandaverage(cfg, StA_act{:});
grandavg_cont_act_plot = ft_freqgrandaverage(cfg, Cont_act{:});

data_diff_sta = grandavg_sta_act;
data_diff_sta.powspctrm = grandavg_sta_act.powspctrm - grandavg_sta_bl.powspctrm;
% Plot
data_diff_sta_plot = grandavg_sta_act;
data_diff_staplot.powspctrm = grandavg_sta_act_plot.powspctrm - grandavg_sta_bl_plot.powspctrm;

data_diff_cont = grandavg_cont_act;
data_diff_cont.powspctrm = grandavg_cont_act.powspctrm - grandavg_cont_bl.powspctrm;
% Plot
data_diff_cont_plot = grandavg_cont_act;
data_diff_contplot.powspctrm = grandavg_cont_act_plot.powspctrm - grandavg_cont_bl_plot.powspctrm;

%% Getting TIME of clusters

load chanlocs.mat;

switch mycase
    case 'epsilon2 early alpha-beta'
        cfg = [];
        cfg.alpha  = 0.05;
        cfg.parameter = 'stat';
        cfg.layout = 'biosemi64.lay';
        
        % % Epsi 2
        % stats_StA_abseEpsi2_early_AB;
        
        g = ft_clusterplot(cfg, stats_StA_absEpsi2_early_AB);
        
        cfg = [];
        cfg.alpha  = 0.1;
        cfg.parameter = 'stat';
        cfg.layout = 'biosemi64.lay';
        g = ft_clusterplot(cfg, stats_Cont_absEpsi2_early_AB);
        
    case 'epsilon2 late alpha-beta'
        cfg = [];
        cfg.alpha  = 0.05;
        cfg.parameter = 'stat';
        cfg.layout = 'biosemi64.lay';
        g = ft_clusterplot(cfg, stats_StA_absEpsi2_late_AB);
        g = ft_clusterplot(cfg, stats_Cont_absEpsi2_late_AB);
        
    case 'epsilon2 all alpha-beta'
        cfg = [];
        cfg.alpha  = 0.05;
        cfg.parameter = 'stat';
        cfg.layout = 'biosemi64.lay';
        g = ft_clusterplot(cfg, stats_StA_absEpsi2_all_AB);
        g = ft_clusterplot(cfg, stats_Cont_absEpsi2_all_AB);
end

% Cluster times

switch mycase
    case 'epsilon2 early alpha-beta'
        Pos1 = 'Positive cluster: 1, pvalue: 0.024595 (x), t = 0.16328 to 0.27266';
        stats_StA_absEpsi2_early_AB.significantclusters.Pos1.time = Pos1;
        Neg1 = 'Negative cluster: 1, pvalue: 0.086983 (+), t = 0.43281 to 0.49922';
        stats_Cont_absEpsi2_early_AB.significantclusters.Neg1.time = Neg1;
        
    case 'epsilon2 late alpha-beta'
        Neg1 = 'Negative cluster: 1, pvalue: 0.0027994 (*), t = 0.59688 to 1.0188';
        stats_StA_absEpsi2_late_AB.significantclusters.Neg1.time = Neg1;
        Neg1 = 'Negative cluster: 1, pvalue: 0.00019996 (*), t = 0.49922 to 1.1555';
        stats_Cont_absEpsi2_late_AB.significantclusters.Neg1.time = Neg1;
        
    case 'epsilon2 all alpha-beta'
        Neg1 = 'Negative cluster: 1, pvalue: 0.0027994 (*), t = 0.59688 to 1.0188';
        stats_StA_absEpsi2_all_AB.significantclusters.Neg1.time = Neg1;
        Neg1 = 'Negative cluster: 1, pvalue: 0.00019996 (*), t = 0.425 to 1.1555';
        stats_Cont_absEpsi2_all_AB.significantclusters.Neg1.time = Neg1;
end

%%                  Checking the significant ELECTRODES

switch mycase
    
    case 'epsilon2 early alpha-beta'
        
%                           Early alpha-beta

% StA
% Get the cluster labels
tpsortingit = squeeze(stats_StA_absEpsi2_early_AB.posclusterslabelmat);
X = sum(tpsortingit(:,17:45),2);
% Finding the time points trial by error
% Epsi 2 = t = 0.16328 to 0.27266
%     stats_StA_absEpsi2_early_AB.time(17)
%     stats_StA_absEpsi2_early_AB.time(45)

minsampl = 25;
chPos = chanlocs(find(X > minsampl));
% epsi2_chans = chPos;
% epsi2_chans = epsi2_chans(~cellfun('isempty',epsi2_chans));
% Save electrodes
stats_StA_absEpsi2_early_AB.significantclusters.Pos1.chanPos = chPos;

% Controls 
% Get the cluster labels
tpsortingit = squeeze(stats_Cont_absEpsi2_early_AB.negclusterslabelmat);
X = sum(tpsortingit(:,86:103),2);
% Finding the time points trial by error
%    stats_Cont_absEpsi2_early_AB.time(86)
%    stats_Cont_absEpsi2_early_AB.time(103)
minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
% Save electrodes
stats_Cont_absEpsi2_early_AB.significantclusters.Neg1.chanNeg = chNeg;

case 'epsilon2 late alpha-beta'
    
%                           Late alpha beta

% StA EARLY
% Get the cluster labels // t = 0.59688 to 0.8 // 
tpsortingit = squeeze(stats_StA_absEpsi2_late_AB.negclusterslabelmat);
X = sum(tpsortingit(:,26:80),2);
% Finding the time points trial by error
% Epsi 2 = t = 0.16328 to 0.27266
%     stats_StA_absEpsi2_late_AB.time(26)
%     stats_StA_absEpsi2_late_AB.time(80)

minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
stats_StA_absEpsi2_late_AB.significantclusters.Neg1.chanNeg_EARLY = chNeg;

% StA LATER
% Get the cluster labels // t = 0.8 to 1.0188
tpsortingit = squeeze(stats_StA_absEpsi2_late_AB.negclusterslabelmat);
X = sum(tpsortingit(:,80:132),2);
% Finding the time points trial by error
% Epsi 2 = t = 0.16328 to 0.27266
%     stats_StA_absEpsi2_late_AB.time(80)
%     stats_StA_absEpsi2_late_AB.time(132)

minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
stats_StA_absEpsi2_late_AB.significantclusters.Neg1.chanNeg_LATER = chNeg;


% Cont EARLY
% Get the cluster labels //  t = 0.499 to 0.825
tpsortingit = squeeze(stats_Cont_absEpsi2_late_AB.negclusterslabelmat);
X = sum(tpsortingit(:,1:84),2);
% Finding the time points trial by error
%    stats_Cont_absEpsi2_late_AB.time(1)
%    stats_Cont_absEpsi2_late_AB.time(122)
minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
% Save electrodes
stats_Cont_absEpsi2_late_AB.significantclusters.Neg1.chanNeg_EARLY = chNeg;

% Cont LATER overall time = t = 0.49922 to 1.150
% Get the cluster labels //  t = 0.825 to 1.150
tpsortingit = squeeze(stats_Cont_absEpsi2_late_AB.negclusterslabelmat);
X = sum(tpsortingit(:,84:168),2);
% Finding the time points trial by error
%    stats_Cont_absEpsi2_late_AB.time(84)
%    stats_Cont_absEpsi2_late_AB.time(168)
minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
% Save electrodes
stats_Cont_absEpsi2_late_AB.significantclusters.Neg1.chanNeg_LATER = chNeg;


case 'epsilon2 all alpha-beta'
    
%                           ALL alpha beta

% StA EARLY
% Get the cluster labels // t = 0.59688 to 0.8 // 
tpsortingit = squeeze(stats_StA_absEpsi2_all_AB.negclusterslabelmat);
X = sum(tpsortingit(:,128:180),2);
% Finding the time points trial by error
% Epsi 2 = t = 0.16328 to 0.27266
%     stats_StA_absEpsi2_all_AB.time(128)
%     stats_StA_absEpsi2_all_AB.time(180)

minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
stats_StA_absEpsi2_all_AB.significantclusters.Neg1.chanNeg_EARLY = chNeg;

% StA LATER
% Get the cluster labels // t = 0.8 to 1.0188
tpsortingit = squeeze(stats_StA_absEpsi2_all_AB.negclusterslabelmat);
X = sum(tpsortingit(:,180:235),2);
% Finding the time points trial by error
% Epsi 2 = t = 0.16328 to 0.27266
%     stats_StA_absEpsi2_all_AB.time(128)
%     stats_StA_absEpsi2_all_AB.time(235)

minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
stats_StA_absEpsi2_all_AB.significantclusters.Neg1.chanNeg_LATER = chNeg;


% Cont EARLY
% Get the cluster labels //  t = 0.425 to 1.1555
tpsortingit = squeeze(stats_Cont_absEpsi2_all_AB.negclusterslabelmat);
X = sum(tpsortingit(:,84:122),2);
% Finding the time points trial by error
%    stats_Cont_absEpsi2_all_AB.time(84)
%    stats_Cont_absEpsi2_all_AB.time(122)
minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
% Save electrodes
stats_Cont_absEpsi2_all_AB.significantclusters.Neg1.chanNeg_EARLY = chNeg;

% Cont LATER
% Get the cluster labels //  t = 0.425 to 1.1555
tpsortingit = squeeze(stats_Cont_absEpsi2_all_AB.negclusterslabelmat);
X = sum(tpsortingit(:,122:271),2);
% Finding the time points trial by error
%    stats_Cont_absEpsi2_all_AB.time(84)
%    stats_Cont_absEpsi2_all_AB.time(271)
minsampl = 25;
chNeg = chanlocs(find(X > minsampl));
% Save electrodes
stats_Cont_absEpsi2_all_AB.significantclusters.Neg1.chanNeg_LATER = chNeg;

end

%% PLOTS


switch mycase
    case 'epsilon2 early alpha-beta'
        
        %%                          StA Plot
        close all;
        cfg = [];
        cfg.xlim             = [0.16 0.28];
        cfg.ylim             = [8 25];
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
        cfg.highlightchannel = stats_StA_absEpsi2_early_AB.significantclusters.Pos1.chanPos; 
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        subplot(2,2,[1,3]);
        ft_topoplotTFR(cfg, data_diff_sta);
        % Font size
        set(gca,'FontSize',25);
        % background colour
        set(gcf,'color','white');
        % Text on figure
        txt = '160-280 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25; 
        hold on;
        % Next subplot
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
        cfg.title        = 'Alpha-Beta (StA-Cont) |\epsilon2|';
        ylabel('Alpha')
        ft_singleplotTFR(cfg, data_diff_sta);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        % Next subplot
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
        ft_singleplotTFR(cfg, data_diff_sta);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        
        %%                              Controls Plot
        
        % StA Plot
        close all;
        cfg = [];
        cfg.xlim             = [0.43 0.49];
        cfg.ylim             = [8 25];
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
        cfg.highlightchannel = stats_Cont_absEpsi2_early_AB.significantclusters.Neg1.chanNeg;
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        subplot(2,2,[1,3]);
        ft_topoplotTFR(cfg, data_diff_cont);
        
        set(gca,'FontSize',25);
        set(gcf,'color','white');
        
        txt = '430-499 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
        
        txt = '\muV';
        t = text(0.6,0.6,txt);
        t.FontSize = 20;
        
        txt2 = 'Pz';
        t2 = text(0.6,0.6,txt2);
        t2.FontSize = 25;
        
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
        cfg.channel      = 'Pz';
        cfg.title        = 'Alpha-Beta (StA-Cont) |\epsilon2|';
        ylabel('Alpha')
        ft_singleplotTFR(cfg, data_diff_cont);
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
        cfg.channel      = 'Pz';
        cfg.title        = 'Pz';
        ylabel('Beta')
        ft_singleplotTFR(cfg, data_diff_cont);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        
    case 'epsilon2 late alpha-beta'
        
        %%                          StA Plot
        close all;
        % Early posterior part
        subplot(2,2,1);
        cfg = [];
        cfg.xlim             = [0.59 0.8];
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
        cfg.highlightchannel = stats_StA_absEpsi2_late_AB.significantclusters.Neg1.chanNeg_EARLY; % stats_StA_ep2_late_AB.significantclusters.Pos1.chanPos; % epsi2_chans
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        ft_topoplotTFR(cfg, data_diff_sta);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        hold on
        
        txt = '590-800 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
        
        % Late anterior part
        subplot(2,2,3);
        cfg = [];
        cfg.xlim             = [0.8 1.020];
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
        cfg.highlightchannel = stats_StA_absEpsi2_late_AB.significantclusters.Neg1.chanNeg_LATER; % stats_StA_ep2_late_AB.significantclusters.Pos1.chanPos; % epsi2_chans
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        ft_topoplotTFR(cfg, data_diff_sta);
        
        set(gca,'FontSize',25);
        set(gcf,'color','white');
        
        txt = '800-1020 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
                
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
        cfg.title        = 'Alpha-Beta (StA) |\epsilon2|';
        ylabel('Alpha')
        ft_singleplotTFR(cfg, data_diff_sta);
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
        ft_singleplotTFR(cfg, data_diff_sta);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        
        %%                              Controls Plot
        
        close all;
        % Early posterior part
        subplot(2,2,1);
        cfg = [];
        cfg.xlim             = [0.499 0.825];
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
        cfg.highlightchannel = stats_Cont_absEpsi2_late_AB.significantclusters.Neg1.chanNeg_EARLY;
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        ft_topoplotTFR(cfg, data_diff_cont);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        hold on
        
        txt = '500-825 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
        
        % Late anterior part
        subplot(2,2,3);
        cfg = [];
        cfg.xlim             = [0.825 1.150];
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
        cfg.highlightchannel = stats_Cont_absEpsi2_late_AB.significantclusters.Neg1.chanNeg_LATER; % stats_StA_ep2_late_AB.significantclusters.Pos1.chanPos; % epsi2_chans
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        ft_topoplotTFR(cfg, data_diff_cont);
        
        set(gca,'FontSize',25);
        set(gcf,'color','white');
        
        txt = '825-1150 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
                
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
        cfg.title        = 'Alpha-Beta (Cont) |\epsilon2|';
        ylabel('Alpha')
        ft_singleplotTFR(cfg, data_diff_cont);
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
        ft_singleplotTFR(cfg, data_diff_cont);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        
        
    case 'epsilon2 all alpha-beta'
        
        %%                          StA Plot
        close all;
        % Early posterior part
        subplot(2,2,1);
        cfg = [];
        cfg.xlim             = [0.58 0.8];
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
        cfg.highlightchannel = stats_StA_absEpsi2_all_AB.significantclusters.Neg1.chanNeg_EARLY; % stats_StA_ep2_late_AB.significantclusters.Pos1.chanPos; % epsi2_chans
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        ft_topoplotTFR(cfg, data_diff_sta);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        hold on
        
        % Late anterior part
        subplot(2,2,3);
        cfg = [];
        cfg.xlim             = [0.8 1];
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
        cfg.highlightchannel = stats_StA_absEpsi2_all_AB.significantclusters.Neg1.chanNeg_LATER; % stats_StA_ep2_late_AB.significantclusters.Pos1.chanPos; % epsi2_chans
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        ft_topoplotTFR(cfg, data_diff_sta);
        
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        
        txt = '800-1000 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
        
        txt = '599-800 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
        
        txt = '\muV';
        t = text(0.6,0.6,txt);
        t.FontSize = 20;
        
        txt2 = 'Fz';
        t2 = text(0.6,0.6,txt2);
        t2.FontSize = 25;
        
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
        cfg.title        = 'Alpha-Beta (StA) \epsilon2';
        ylabel('Alpha')
        ft_singleplotTFR(cfg, data_diff_sta);
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
        cfg.title = 'Fz';
        ft_singleplotTFR(cfg, data_diff_sta);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        
        %%                              Controls Plot
        
        close all;
        % Early posterior part
        subplot(2,2,1);
        cfg = [];
        cfg.xlim             = [0.42 0.57];
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
        cfg.highlightchannel = stats_Cont_absEpsi2_all_AB.significantclusters.Neg1.chanNeg_EARLY; % stats_StA_ep2_late_AB.significantclusters.Pos1.chanPos; % epsi2_chans
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        ft_topoplotTFR(cfg, data_diff_cont);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        hold on
        
        % Late anterior part
        subplot(2,2,3);
        cfg = [];
        cfg.xlim             = [0.57 1.155];
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
        cfg.highlightchannel = stats_Cont_absEpsi2_all_AB.significantclusters.Neg1.chanNeg_LATER; % stats_StA_ep2_late_AB.significantclusters.Pos1.chanPos; % epsi2_chans
        cfg.highlightcolor   = [0,0,0];
        cfg.colorbar         = 'WestOutside';
        % Subplot Version
        ft_topoplotTFR(cfg, data_diff_cont);
        
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        
        txt = '570-1150 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
        
        txt = '425-570 ms';
        t = text(0.6,0.6,txt);
        t.FontSize = 25;
        
        txt = '\muV';
        t = text(0.6,0.6,txt);
        t.FontSize = 20;
        
        txt2 = 'Fz';
        t2 = text(0.6,0.6,txt2);
        t2.FontSize = 25;
        
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
        cfg.channel      = 'Pz';
        cfg.title        = 'Alpha-Beta (Cont) \epsilon2';
        ylabel('Alpha')
        ft_singleplotTFR(cfg, data_diff_cont);
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
        cfg.channel      = 'Pz';
        cfg.title = 'Pz';
        ylabel('Beta')
        ft_singleplotTFR(cfg, data_diff_cont);
        set(gca,'FontSize',20);
        set(gcf,'color','white');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
end