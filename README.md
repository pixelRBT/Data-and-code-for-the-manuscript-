# Data-and-code-for-the-manuscript-To what extent are the source mixing models accurate: evaluation of the model accuracy and guidelines for the site-specific model selection
Data and codes for the manuscript To what extent are the source mixing models accurate: evaluation of the model accuracy and guidelines for the site-specific model selection
This data includes the isotope mixing scenarios and the machine learning models used in the paper entitled To what extent are the source mixing models accurate: evaluation of the model accuracy and guidelines for the site-specific model selection which have been submitted to the journal Water Resource Research. These scenarios were presumptively created to evaluate the accuracy of the isotope source mixing models, i.e. IsoSource, MixSIR, SIMMR, and MixSIAR. The machine learning models are established for the prediction of model estimation bias in field studies.

Description of the data and file structure
The file random scenarios.xlsx contains each procedure and the final version of the randomly generated mixing scenarios. The script random scenarios.R contains the R code of generating the mixing scenarios in file random scenarios.xlsx. The file machine_learning_script.R and machine_learning_models.Rdata contain the R script and data of the machine learning models, with instructions inside.

random scenarios.xlsx

The five data sheets in this data file are the results of each procedure of random scenario generation.

The first sheet random sources includes the isotope signatures of the ten presumptive sources which are randomly generated from a certain range. The seeds of random sampling are also included.

Abbreviations: δ2H, isotope signature of 2H. δ18O isotope signature of 18O. sd, standard deviation. seed.2H: the random seed used for δ2H and its sd. seed.18O: the random seed used for δ18H and its sd.

The second sheet p vectors includes the actual proportional source contribution (p) of the mixing scenarios. The number of source (NOS) ranged from three to seven. The coefficient of variation of each p vector is also provided.

Abbreviations: NOS, Number of source. p, The actual proportional source contribution of the i source to its mixture designed in the mixing scenarios. CVa, Coefficient of variation of the p vector within each mixing scenario. s1~s7, The sources from No. 1 to No. 7.

The third sheet p vectors sampled by CVa is the  resampling result of the second sheet by extracting one vector from the vectors with same CVa and NOS. The abbreviation of this sheet is the same as the second sheet.

The fourth sheet source combinations includes all the combinations of the presumptive sources with certain NOS. The fifth sheet *resampled mixing scenarios *includes the final mixing scenarios, which combined the result of the second and the fourth sheet and randomly resampled to 500 mixing scenarios.

machine learning models.Rdata

The list 'designs'  includes the machine learning designs with each design containing the machine learning learner, the resampling method, and the regression task. Random forest is used as learner and the optimized hyperparameters have already been set in each learner. 'Subsampling' is used as the resampling method. The target of the task is sqrtBOE and features are CVe, DFC, DFM, IQR, and NOS (these features are factors quantifying the data quality, which the detailed descriptions are in the original article). These 8 designs are used for (also in the order of) IsoSource (solo run), MixSIR (solo run), SIMMR (solo run), MixSIAR (solo run), MixSIR (process error), MixSIAR (process error), SIMMR (process and residual error), and MixSIAR (process and residual error).

The list 'newdat' includes the data used for the prediction of sqrtBOE, each in a form of data.frame. The current 'newdat' in this Rdata file includes the data of the case studies used in the original article, which are data from Chi et al. (2019) (data.frame 1-4), Gai et al. (2023) (data.frame 5 and 6), and Mas et al. (2024) (data.frame 7 and 8). If users need to predict the sqrtBOE of their own data, then  CVe, DFC, DFM, IQR, and NOS calculated from their data should be provided and structured in the same form as the current version of 'newdat'.

The list 'prediction_summary' contains the predicted sqrtBOE. The current version includes the predicted sqrtBOE of the case studies. 

Code/Software
R is required to load the machine_learning_models.Rdata, and also run the machine_learning_script.R and random scenarios.R. Annotations are provided throughout the script.
