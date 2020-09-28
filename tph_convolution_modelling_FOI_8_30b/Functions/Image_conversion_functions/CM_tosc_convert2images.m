function images = CM_tosc_convert2images(D, options)
% From TNUEEG_CONVERT2IMAGES = Now converts a continous time-frequency dataset into a 3D image
%   IN:     D           - preprocessed data set 
%           options     - the struct that holds all analysis options
%   OUT:    images      - the 3D images, one per condition in the original
%                       data set D
S.D = D;
S.mode = options.conversion.mode;
S.conditions = cell(1, 0);
S.timewin = options.conversion.convTimeWindow; % conversion was missing
S.channels = options.conversion.chans;
S.prefix = [options.conversion.convPrefix '_'];
images = spm_eeg_convert2images(S);
end

