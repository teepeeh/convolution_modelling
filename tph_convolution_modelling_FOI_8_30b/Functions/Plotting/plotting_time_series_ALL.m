%% Time series plot for frequency response 

% This plots the time series between groups for epsi2 (without a baseline plotted)
%% Remove paths
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
%% RUN
% Remove FT
rmpath(genpath(ftpath));
% add SPM
addpath(spmpath);
spm('defaults', 'eeg');
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

%% Trying to add in baseline

% Epsi2
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
    e2_StA_bl{i,1} = ft_conv_sta_epsi2{i};
    e2_StA_bl{i,1}.time  = e2_StA_bl{i,1}.time([bl_start:bl_end]);
    e2_StA_bl{i,1}.powspctrm = e2_StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end);
    e2_StA_bl{i,1}.powspctrm = nanmean(e2_StA_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
    % Controls
    e2_Cont_bl{i,1} = ft_conv_cont_epsi2{i};
    e2_Cont_bl{i,1}.time = e2_Cont_bl{i,1}.time([bl_start:bl_end]);
    e2_Cont_bl{i,1}.powspctrm = e2_Cont_bl{i,1}.powspctrm(:,:,bl_start:bl_end);
    e2_Cont_bl{i,1}.powspctrm = nanmean(e2_Cont_bl{i,1}.powspctrm(:,:,bl_start:bl_end),3);
end

% Repmat Baseline
for i = 1:21
    e2base_repmat_sta = (e2_StA_bl{i,1}.powspctrm);
    e2base_repmat_cont = (e2_Cont_bl{i,1}.powspctrm);
    for n = 2:length([bl_start:bl_end])
        e2_StA_bl{i,1}.powspctrm(:,:,n) = repmat(e2base_repmat_sta, [1,1]);
        e2_Cont_bl{i,1}.powspctrm(:,:,n) = repmat(e2base_repmat_cont, [1,1]);
    end
    clear e2base_repmat_sta e2base_repmat_cont
end

% Activation
actTOI = [0 2]; %in seconds, careful, fieldtrip time field is in seconds
act_start = find(min(abs(actTOI(1) - mytime)) == abs(actTOI(1)  - mytime));
act_end = find(min(abs(actTOI(2) - mytime)) == abs(actTOI(2)  - mytime));
for i = 1:21
    % State anxiety
    e2_StA_act{i,1} = ft_conv_sta_epsi2{i};
    e2_StA_act{i,1}.time = ft_conv_sta_epsi2{i,1}.time([act_start:act_end]);
    e2_StA_act{i,1}.powspctrm = e2_StA_act{i,1}.powspctrm(:,:,[act_start:act_end]);
    % Controls
    e2_Cont_act{i,1} = ft_conv_cont_epsi2{i};
    e2_Cont_act{i,1}.time = ft_conv_cont_epsi2{i,1}.time([act_start:act_end]);
    e2_Cont_act{i,1}.powspctrm = e2_Cont_act{i,1}.powspctrm(:,:,[act_start:act_end]);
end

%% Update FT Path
rmpath(spmpath);
addpath(genpath(ftpath));
ft_defaults;

%% Load these fieldtrip convolution files into the grandavaerage

cfg = [];
cfg.channel = [1:64];
cfg.latency        = ('all');
cfg.keepindividual = ('no');
cfg.method         = ('within');

% Epsi2
% BL
grandavg_e2_sta_bl = ft_freqgrandaverage(cfg, e2_StA_bl{:});
grandavg_e2_cont_bl = ft_freqgrandaverage(cfg, e2_Cont_bl{:});
% Act
grandavg_e2_sta_act = ft_freqgrandaverage(cfg, e2_StA_act{:});
grandavg_e2_cont_act = ft_freqgrandaverage(cfg, e2_Cont_act{:});

%% Colours
ccE = [32,178,170]/255;
ccC = [0, 0, 0]/255;
%% Plot Data = EPSI 2

% SEM 
%Cont Act
contact = squeeze(mean(grandavg_e2_cont_act.powspctrm(:,:,:),2));
contstd = std(contact);
contact = squeeze(mean(contact(:,:),1));
% Y-AXIS (SEM)
contsem = contstd/(sqrt(21));
% Time
timecontact = grandavg_e2_cont_act.time;

%Cont BL
contBL = squeeze(mean(grandavg_e2_cont_bl.powspctrm(:,:,:),2));
contBLstd = std(contBL);
contBL = squeeze(mean(contBL(:,:),1));
% Y-AXIS (SEM)
contBLsem = contBLstd/(sqrt(21));

% End value for BL
endval = contact(1);
bl_len = length(contBL)-10;
contBL2 = contBL(1:bl_len);
contBL2(length(contBL2)+1:length(contBL)) = linspace(contBL2(bl_len-1),endval,10);

% End value for SEM BL
endval = contsem(1);
bl_len = length(contBLsem)-10;
contsem2 = contBLsem(1:bl_len);
contsem2(length(contsem2)+1:length(contBLsem)) = linspace(contsem2(bl_len-1),endval,10);


% Sta Act
staact = squeeze(mean(grandavg_e2_sta_act.powspctrm(:,:,:),2));
stastd = std(staact);
staact = squeeze(mean(staact(:,:),1));
% Y-AXIS (SEM)
stasem = stastd/(sqrt(21));
% Time
timestaact = grandavg_e2_sta_act.time;

% StA BL
staBL = squeeze(mean(grandavg_e2_sta_bl.powspctrm(:,:,:),2));
staBLstd = std(staBL);
staBL = squeeze(mean(staBL(:,:),1));
% Y-AXIS (SEM)
staBLsem = staBLstd/(sqrt(21));

% End value for BL
endval = staact(1);
bl_len = length(staBL)-10;
staBL2 = staBL(1:bl_len);
staBL2(length(staBL2)+1:length(staBL)) = linspace(staBL2(bl_len-1),endval,10);

% End value for SEM BL
endval = stasem(1);
bl_len = length(staBLsem)-10;
stasem2 = staBLsem(1:bl_len);
stasem2(length(stasem2)+1:length(staBLsem)) = linspace(stasem2(bl_len-1),endval,10);

%                                   PLOT
close all
figsize = [100 100 1080 800];
figure('Renderer', 'painters', 'Position', figsize);
%                                   StA
% Time course
staplot = plot(timestaact, staact,'Color',ccE,'LineWidth',3,'DisplayName','State anxiety');
hold on
% SEM
xk = timestaact';
yk=staact';
dyk=abs(stasem)';
fill([xk;flipud(xk)],[yk-dyk;flipud(yk+dyk)],ccE,'linestyle','none','FaceAlpha',0.25);
staplot = plot(timestaact, staact,'Color',ccE,'LineWidth',3,'DisplayName','State anxiety');
% BASELINE
staBLplot = plot(grandavg_e2_sta_bl.time, staBL2 ,'Color',ccE,'LineWidth',3,'DisplayName','StA Baseline');
% SEM
xk = grandavg_e2_sta_bl.time';
yk=staBL2';
dyk=abs(stasem2)';
fill([xk;flipud(xk)],[yk-dyk;flipud(yk+dyk)],ccE,'linestyle','none','FaceAlpha',0.25);
hold on

%                                   Cont
% Time course
contplot = plot(timecontact, contact,'Color',ccC,'LineWidth',3,'DisplayName','Controls');
hold on
% SEM
xk = timecontact';
yk=contact';
dyk=abs(contsem)';
fill([xk;flipud(xk)],[yk-dyk;flipud(yk+dyk)],ccC,'linestyle','none','FaceAlpha',0.25);
%BASELINE CONT
contBLplot = plot(grandavg_e2_cont_bl.time, contBL2 ,'Color',ccC,'LineWidth',3,'DisplayName','Cont Baseline');
% SEM
xk = grandavg_e2_cont_bl.time';
yk=contBL2';
dyk=abs(contsem2)';
fill([xk;flipud(xk)],[yk-dyk;flipud(yk+dyk)],ccC,'linestyle','none','FaceAlpha',0.25);

% Calibrate plot
xlabel('Time (sec)');
set(gca,'FontSize',25);
set(gcf,'color','white');

legend([contplot, staplot],{'Controls','State Anxiety'})
legend boxoff;

title(['|\epsilon_2| (\alpha \beta ) \muV'])
% Hand tweak
ylabel('|\epsilon_2| (STD)');
% ylim([-1500 1500])
xlim([-0.2 2]);