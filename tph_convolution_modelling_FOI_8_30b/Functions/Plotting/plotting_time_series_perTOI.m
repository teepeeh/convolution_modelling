%% Plotting time series with SEM on convolution data

%% Remove paths
rmpath(genpath('E:\tpDATA\MATLAB_Scripts\tanx_osc\SPM\tph_convolution_modelling'));
clear all;
%% Directory
rootFolder = 'E:\tpDATA\tosc_data\tph_convolution_modelling\tph_convolution_modelling_FOI_8_30b';
cd (rootFolder);
% Add Functions
addpath(genpath([rootFolder '\Functions\']));
addpath(genpath([rootFolder '\Data\']));
% Add SPM
spmpath = 'E:\spm12';
% FIELD TRIP
ftpath = 'E:\fieldtrip-20181024';
%% Make a Fieldtrip template for SPM data
load('tanx_wavelet_Cont_win_IQR_AB_baselined.mat')
ft_template = Cont_wavelet_win_AB{1, 1};
%% Load each SPM file and save fttimelock to a FieldTrip template
% Exp groups
expgroup = [20 21 23:43];
expgroup = setdiff(expgroup, [36,37]);
contgroup = [1:19 22 37];
% Convolution conditions
condition_win = 1;
condition_lose = 2;
condition_noresp = 3;
regressor_epsi2 = 4;
%% Choose regressor + time window
% Epsilon 2 cases
case1 = 'epsilon2 early alpha-beta';
case2 = 'epsilon2 late alpha-beta';

%% RUN
mycase = case2;
% Remove FT
rmpath(genpath(ftpath));
% add SPM
addpath(spmpath);
spm('defaults', 'eeg');
% Run
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

switch mycase
    case 'epsilon2 early alpha-beta'
        frequency = [8 25];
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
            StA_bl{i,1}.powspctrm = StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end);
            StA_bl{i,1}.powspctrm = nanmean(StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
            % Controls
            Cont_bl{i,1} = ft_conv_cont_epsi2{i};
            Cont_bl{i,1}.time = Cont_bl{i,1}.time([bl_start:bl_end]);
            Cont_bl{i,1}.powspctrm = Cont_bl{i,1}.powspctrm(:,:,bl_start:bl_end);
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
        frequency = [8 25];
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
            StA_bl{i,1}.powspctrm = StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end);
            StA_bl{i,1}.powspctrm = nanmean(StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
            % Controls
            Cont_bl{i,1} = ft_conv_cont_epsi2{i};
            Cont_bl{i,1}.time = Cont_bl{i,1}.time([bl_start:bl_end]);
            Cont_bl{i,1}.powspctrm = Cont_bl{i,1}.powspctrm(:,:,bl_start:bl_end);
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
        
end

%% FT grand avaerage
% Keeping individuals
cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
cfg.foilim         = frequency; % [14 24];
cfg.keepindividual = ('no'); % PLotting
cfg.method         = ('within');
% Baseline
grandavg_sta_bl = ft_freqgrandaverage(cfg, StA_bl{:});
grandavg_cont_bl = ft_freqgrandaverage(cfg, Cont_bl{:});
% Activation
grandavg_sta_act = ft_freqgrandaverage(cfg, StA_act{:});
grandavg_cont_act = ft_freqgrandaverage(cfg, Cont_act{:});
%% Colours
ccE = [32,178,170]/255;
ccC = [0, 0, 0]/255;
%% Plot Data = CONT

%Cont Act
contact = squeeze(mean(grandavg_cont_act.powspctrm(:,:,:),2));
contstd = std(contact);
contact = squeeze(mean(contact(:,:),1));
% Cont BL
contbl = squeeze(mean(grandavg_cont_bl.powspctrm(:,:,:),2));
contbl = squeeze(mean(contbl(:,:),1));
% Y-AXIS (SEM)
contsem = contstd/(sqrt(21));
% Time
timecontact = grandavg_cont_act.time;
timecontbl = grandavg_cont_bl.time;

%sta Act
staact = squeeze(mean(grandavg_sta_act.powspctrm(:,:,:),2));
stastd = std(staact);
staact = squeeze(mean(staact(:,:),1));
% sta BL
stabl = squeeze(mean(grandavg_sta_bl.powspctrm(:,:,:),2));
stabl = squeeze(mean(stabl(:,:),1));
% Y-AXIS (SEM)
stasem = stastd/(sqrt(21));
% Time
timestaact = grandavg_sta_act.time;
timestabl = grandavg_sta_bl.time;

%% PLotting Cont
close all
figsize = [100 100 1080 800];
figure('Renderer', 'painters', 'Position', figsize);

% Controls
% Time course
contplot = plot(timecontact, contact,'Color',ccC,'LineWidth',3,'DisplayName','Controls');
hold on
% SEM
xk = timecontact';
yk=contact';
dyk=abs(contsem)';
fill([xk;flipud(xk)],[yk-dyk;flipud(yk+dyk)],ccC,'linestyle','none','FaceAlpha',0.25);

cont_baseline_plot = plot(timecontbl, contbl,'--','Color',ccC,'LineWidth',3,'DisplayName','Controls');

% StA
% Time course
staplot = plot(timestaact, staact,'Color',ccE,'LineWidth',3,'DisplayName','State anxiety');
hold on
% SEM
xk = timestaact';
yk=staact';
dyk=abs(stasem)';
fill([xk;flipud(xk)],[yk-dyk;flipud(yk+dyk)],ccE,'linestyle','none','FaceAlpha',0.25);
staplot = plot(timestaact, staact,'Color',ccE,'LineWidth',3,'DisplayName','State anxiety');

sta_baseline_plot = plot(timestabl, stabl,'--','Color',ccE,'LineWidth',3,'DisplayName','Controls');

% Calibrate plot
xlabel('Time (sec)');
set(gca,'FontSize',25);
set(gcf,'color','white');

legend([staplot, sta_baseline_plot, contplot, cont_baseline_plot],{'StA Activation', 'StA Baseline' 'Cont Activation', 'Cont Baseline'})
legend boxoff;

% Title

switch mycase
    case 'epsilon2 early alpha-beta'
        ylabel('|\epsilon_2| early alpha-beta (STD)');
    case 'epsilon2 late alpha-beta'
        ylabel('|\epsilon_2| late alpha-beta (STD)');
end