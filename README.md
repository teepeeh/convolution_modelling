# convolution_modelling 'tph_convolution_modelling_FOI_8_30b'
State anxiety oscillations project 2020 - convolution modelling code for alpha-beta [8-30Hz]

Download and open tp_ConvModel.m (this is the 'launch' page where you can addpaths and execute various functions in sequence). 

In tp_ConvModel.m,  add your directory into RootFolder. 

To run the convolution model, download the seperate data file here: 

And add this folder 'SPM_tf' to the Data directory. 

SPM_tf contains participant 1's continuous time frequency data in amplitude.

To run convolution modelling on this, run:

1) CM_Options_Convolution_Modelling from tp_ConvModel.m
3) Step 4 - Convolution Modelling = CM_step4_Convolution_Modelling(rootFolder, options);

Fieldtrip statistics and plots are run manually from scripts inside [FUNCTIONS>Fieldtrip_stats] & [FUNCTIONS>Plotting]. These are also referenced in tp_ConvModel.m on line 53-61. 
