# convolution_modelling 'tph_convolution_modelling_FOI_8_30b'
State anxiety oscillations project 2020 - convolution modelling code for alpha-beta [8-30Hz]

Download and open tp_ConvModel.m (this is the 'launch' page where you can addpaths and execute various functions in sequence). 

In tp_ConvModel.m,  add your directory into RootFolder. 

To run the convolution model, download the seperate data file here: 

And add this folder 'SPM_tf' to the Data directory. 

SPM_tf contains participant 1's continuous time frequency data in amplitude.

To run convolution modelling on this, run:

1) Open and edit CM_Options_Convolution_Modelling (line 24 in tp_ConvModel.m) to be for subject 1 only. (Line 9). 
2) Run CM_Options_Convolution_Modelling
3) Run Step 4 (line 49 in tp_ConvModel.m) which is 'CM_step4_Convolution_Modelling(rootFolder, options);'

This will save the convolution model data to Data>SPM_tf>participant_1

FYI: Fieldtrip statistics and plots are run manually from scripts inside [FUNCTIONS>Fieldtrip_stats] & [FUNCTIONS>Plotting]. These are also referenced in tp_ConvModel.m on line 53-61. 
