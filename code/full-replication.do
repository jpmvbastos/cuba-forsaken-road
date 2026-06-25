*|==============================================================================
*| TITLE
*| The Forsaken Road
*|
*| AUTHORS
*| João Pedro Bastos
*| Texas Tech University | Joao-Pedro.Bastos@ttu.edu
*|
*| Jamie Bologna Pavlik
*| Texas Tech University | Jamie.Bologna@ttu.edu
*| 
*| Vincent Geloso
*| George Mason University |
*|
*| Function: Replicates all results for the paper
*|
*|==============================================================================


//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------

// Set path to your "Cuba" folder
global path "/Users/jpmvbastos/Library/CloudStorage/Dropbox/Papers/cuba-replication/"


// OPTIONAL: Open log to record results
log using "$path/results/full-replication.smcl", replace

// Installed requires packages if not installed 
* ssc install synth
* ssc install allsynth
* ssc install distinct // required by allsynth
* ssc install elasticregress // required by allsynth
* ssc install sdid
* ssc install sdid_event 
* ssc install rcm 
* ssc install coefplot 
* ssc install eventdd  

// Note: In case of "conformbility error", refer to README file in the package.

//------------------------------------------------------------------------------
// Estimate the GDP results (used later for multiple figures)
//------------------------------------------------------------------------------

di "Estimating Main GDP Results"
do "$path/code/gdp-results.do"

//------------------------------------------------------------------------------
// Estimate the Embargo results (used later for multiple figures)
//------------------------------------------------------------------------------

di "Estimating Main Embargo Results"
do "$path/code/embargo-results.do"

//------------------------------------------------------------------------------
// Figure 1 - Combined comparison of GDP results
//------------------------------------------------------------------------------

di "Replicating Figure 1"
do "$path/code/Figure1.do"

//------------------------------------------------------------------------------
// Figure 2 - Effect of Revolution - Unadjusted GDP (MPD 2023)
//------------------------------------------------------------------------------

di "Replicating Figure 2"
do "$path/code/Figure2.do"

//------------------------------------------------------------------------------
// Figure 3 - p-values - Unadjusted GDP (Maddison 2023)
//------------------------------------------------------------------------------

di "Replicating Figure 3"
do "$path/code/Figure3.do"

//------------------------------------------------------------------------------
// Figure 4 - Effect of Revolution - Adjusted GDP (MPD 2023)
//------------------------------------------------------------------------------

di "Replicating Figure 4"
do "$path/code/Figure4.do"

//------------------------------------------------------------------------------
// Figure 5 - p-values - Adjusted GDP (MPD 2023)
//------------------------------------------------------------------------------

di "Replicating Figure 5"
do "$path/code/Figure5.do"

//------------------------------------------------------------------------------
// Figure 6 - Effect of Revolution - Adj. GDP minus Transf. (MPD 2023)
//------------------------------------------------------------------------------

di "Replicating Figure 6"
do "$path/code/Figure6.do"

//------------------------------------------------------------------------------
// Figure 7 - p-values - Adj. GDP minus Transf. (MPD 2023)
//------------------------------------------------------------------------------

di "Replicating Figure 7"
do "$path/code/Figure7.do"

//------------------------------------------------------------------------------
// Table 1 - Donor Weights for Figures 2-7
//------------------------------------------------------------------------------

di "Skipping Table 1 - LaTeX generated. Estimates provided in other code.""

//------------------------------------------------------------------------------
// Table 2 - Predictor Balance for Figures 2-7
//------------------------------------------------------------------------------

di "Skipping Table 2 - LaTeX generated. Estimates provided in other code."

//------------------------------------------------------------------------------
// Table 3 - Estimates Effects and p-values
//------------------------------------------------------------------------------

di "Skipping Table 3 - LaTeX generated. Estimates provided in other code."

//------------------------------------------------------------------------------
// Figure 8 - Effect of Embargo on Cuba's Trade with US
//------------------------------------------------------------------------------

di "Replicating Figure 8"
do "$path/code/Figure8.do"

//------------------------------------------------------------------------------
// Figure 9 - p-values - Effect of Embargo on Cuba's Trade with US
//------------------------------------------------------------------------------

di "Replicating Figure 9"
do "$path/code/Figure9.do"

//------------------------------------------------------------------------------
// Figure 10 - Effect of Embargo on Cuba's Exports to US
//------------------------------------------------------------------------------

di "Replicating Figure 10"
do "$path/code/Figure10.do"

//------------------------------------------------------------------------------
// Figure 11 - p-values - Effect of Embargo on Cuba's Exports to US
//------------------------------------------------------------------------------

di "Replicating Figure 11"
do "$path/code/Figure11.do"

//------------------------------------------------------------------------------
// Figure 12 - Effect of Embargo on Cuba's Trade with the World
//------------------------------------------------------------------------------

di "Replicating Figure 12"
do "$path/code/Figure12.do"

//------------------------------------------------------------------------------
// Figure 13 - p-values - Effect of Embargo on Cuba's Trade with the World
//------------------------------------------------------------------------------

di "Replicating Figure 13"
do "$path/code/Figure13.do"

//------------------------------------------------------------------------------
di "Skipping Table 6 - LaTeX generated. Estimates provided in other code."
//------------------------------------------------------------------------------

di "Finished replicating main results"

//==============================================================================
// Appendix Results
//==============================================================================

//------------------------------------------------------------------------------
// Appendix A
//------------------------------------------------------------------------------

di "Starting replication of Appendix A"

//------------------------------------------------------------------------------
di "Skipping Tables A1-A2 - No Stata estimates"
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Figure A1 - Comparison of MPD Updates and Devereux (2019)
//------------------------------------------------------------------------------

di "Replicating Figure A1"
do "$path/code/FigureA1.do" 

//------------------------------------------------------------------------------
// Figure A2 - Correction for Data Manipulation using Night Lights
//------------------------------------------------------------------------------

di "Replicating Figure A2"
do "$path/code/FigureA2.do"

//------------------------------------------------------------------------------
// Figure A3 - Comparison of MPD, Devereux (2019), and Martínez (2022)
//------------------------------------------------------------------------------

di "Replicating Figure A3"
do "$path/code/FigureA3.do" 

//------------------------------------------------------------------------------
di "Skipping Figure A4 - LaTeX generated"
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Figure A5 - Soviet Aid as a Share of GDP
//------------------------------------------------------------------------------

di "Replicating Figure A5"
do "$path/code/FigureA5.do" 

//------------------------------------------------------------------------------
di "Skipping Tables A3-A4 - LaTeX generated. Estimates provided in other code."
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Merge Aid simulations to GDP results
//------------------------------------------------------------------------------

di "Merging files for aid simulations"
do "$path/code/soviet-aid-simulations.do" 

//------------------------------------------------------------------------------
// Figure A6 - Soviet Aid as a Share of GDP
//------------------------------------------------------------------------------

di "Replicating Figure A6"
do "$path/code/FigureA6.do" 

//------------------------------------------------------------------------------
di "Finished replicating Appendix A"
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Appendix B
//------------------------------------------------------------------------------

di "Starting replication of Appendix B"

//------------------------------------------------------------------------------
// Estimate the GDP results using MPD 2013 (used later for multiple figures)
//------------------------------------------------------------------------------

di "Estimating GDP Results using MPD 2013 data"
do "$path/code/gdp13-results.do"

//------------------------------------------------------------------------------
// Figure B1 - GDP results using MPD 2013, , Panels A-F
//------------------------------------------------------------------------------

di "Replicating Figure B1-A"
do "$path/code/FigureB1-A.do"

di "Replicating Figure B1-B"
do "$path/code/FigureB1-B.do"

di "Replicating Figure B1-C"
do "$path/code/FigureB1-C.do"

di "Replicating Figure B1-D"
do "$path/code/FigureB1-D.do"

di "Replicating Figure B1-E"
do "$path/code/FigureB1-E.do"

di "Replicating Figure B1-F"
do "$path/code/FigureB1-F.do"

//------------------------------------------------------------------------------
// Table B1 - Donor Weights for Figure B1
//------------------------------------------------------------------------------

di "Skipping Table 1 - LaTeX generated. Estimates provided in other code.""

//------------------------------------------------------------------------------
// Table B2 - Predictor Balance for Figure B1
//------------------------------------------------------------------------------

di "Skipping Table 2 - LaTeX generated. Estimates provided in other code.""

//------------------------------------------------------------------------------
// Estimate the Embargo results using TRADHIST (used later for multiple figures)
//------------------------------------------------------------------------------

di "Estimating Embargo results using TRADHIST data"
do "$path/code/embargo-th-results.do"

//------------------------------------------------------------------------------
// Figure B2 - Embargo results using TRADHIST data, , Panels A-D
//------------------------------------------------------------------------------

di "Replicating Figure B2-A"
do "$path/code/FigureB2-A.do"

di "Replicating Figure B2-B"
do "$path/code/FigureB2-B.do"

di "Replicating Figure B2-C"
do "$path/code/FigureB2-C.do"

di "Replicating Figure B2-D"
do "$path/code/FigureB2-D.do"

//------------------------------------------------------------------------------
// Estimate the GDP results including Puerto Rico 
//------------------------------------------------------------------------------

di "Estimating GDP Results including Puerto Rico"
do "$path/code/gdp-pr-results.do"

//------------------------------------------------------------------------------
// Figure B3 - GDP results including Puerto Rico, Panels A-F
//------------------------------------------------------------------------------

di "Replicating Figure B3-A"
do "$path/code/FigureB1-A.do"

di "Replicating Figure B3-B"
do "$path/code/FigureB1-B.do"

di "Replicating Figure B3-C"
do "$path/code/FigureB1-C.do"

di "Replicating Figure B3-D"
do "$path/code/FigureB3-D.do"

di "Replicating Figure B3-E"
do "$path/code/FigureB3-E.do"

di "Replicating Figure B3-F"
do "$path/code/FigureB3-F.do"

//------------------------------------------------------------------------------
// Table B3 - Donor Weights for Figure B3
//------------------------------------------------------------------------------

di "Skipping Table B3 - LaTeX generated. Estimates provided in other code."

//------------------------------------------------------------------------------
// Table B4 - Predictor Balance for Figure B3
//------------------------------------------------------------------------------

di "Skipping Table B3 - LaTeX generated. Estimates provided in other code."

//------------------------------------------------------------------------------
// Estimate the Jackknifed GDP results (used later for multiple figures)
//------------------------------------------------------------------------------

di "Estimating Jackknifed GDP Results"
do "$path/code/jackknife-gdp.do"


//------------------------------------------------------------------------------
// Figure B4 - Jackknife for GDP
//------------------------------------------------------------------------------

di "Replicating Figure B4" 
do "$path/code/FigureB4.do"

//------------------------------------------------------------------------------
// Figure B5 - Jackknifed P-values for GDP
//------------------------------------------------------------------------------

di "Replicating Figure B5" 
do "$path/code/FigureB5.do"

//------------------------------------------------------------------------------
// Estimate the Jackknifed Embargo results (used later for multiple figures)
//------------------------------------------------------------------------------

di "Estimating Jackknifed Embargo Results"
do "$path/code/jackknife-embargo.do"

//------------------------------------------------------------------------------
// Figure B6 - Jackknife Estimates and P-values for Embargo
//------------------------------------------------------------------------------

di "Replicating Figure B6" 
do "$path/code/FigureB6.do"

//------------------------------------------------------------------------------
// Estimate the results and p-values for Western Donor Pool 
//------------------------------------------------------------------------------

di "Estimating Western Donor Pool Results"
do "$path/code/gdp-results-wdp.do"

//------------------------------------------------------------------------------
// Figure B7 - Western Donor Pool GDP estimates
//------------------------------------------------------------------------------

di "Replicating Figure B7" // CHECK, it should be Figure B23.do //done
do "$path/code/FigureB7.do"

//------------------------------------------------------------------------------
// Figure B8 - P-values for Western Donor Pool GDP estimates
//------------------------------------------------------------------------------

di "Replicating Figure B8" // CHECK, it should be Figure B23.do //done
do "$path/code/FigureB8.do"

//------------------------------------------------------------------------------
// Estimate the results and p-values for Western Donor Pool Normalized
//------------------------------------------------------------------------------

di "Replicating Western Donol Pool Normalized SCM GDP results" 
do "$path/code/gdp-results-wdp-normalized.do"

//------------------------------------------------------------------------------
// Figure B9 - Western Donor Pool Normalized GDP estimates
//------------------------------------------------------------------------------

di "Replicating Figure B9" // CHECK, it should be Figure B23.do //done
do "$path/code/FigureB9.do"

//------------------------------------------------------------------------------
// Figure B10 - P-values for Western Donor Pool Normalized GDP estimates
//------------------------------------------------------------------------------

di "Replicating Figure B10" // CHECK, it should be Figure B23.do //done
do "$path/code/FigureB10.do"

//------------------------------------------------------------------------------
// Estimate Jackknifed Results using Western Donor Pool 
//------------------------------------------------------------------------------
di "Replicating Western Donol Pool GDP results" 
do "$path/code/jackknife-wdp.do"

//------------------------------------------------------------------------------
// Figure B11 - Western Donor Pool Jackknifed GDP estimates and p-values
//------------------------------------------------------------------------------

di "Replicating Figure B11" 
do "$path/code/FigureB11.do"

//------------------------------------------------------------------------------
// Figure B12 - Western Donor Pool SDID GDP estimates and p-values
//------------------------------------------------------------------------------

di "Replicating SDID Western Donor Pool GDP and Produces Figure B12" 
do "$path/code/FigureB12.do"

//------------------------------------------------------------------------------
// Estimate Synthetic Control for Embargo Effects Using Western Donor Pool 
//------------------------------------------------------------------------------
di "Replicating Western Donol Pool Trade results"  
do "$path/code/embargo-results-wdp.do"

//------------------------------------------------------------------------------
// Figure B13 - Western Donor Pool Embargo estimates and p-values (TRADHIST)
//------------------------------------------------------------------------------

di "Replicating Figure B13" 
do "$path/code/FigureB13.do"

//------------------------------------------------------------------------------
// Figure B14 - All-Lags GDP estimates 
//------------------------------------------------------------------------------

di "Replicating Figure B14" 
do "$path/code/FigureB14.do" 

//------------------------------------------------------------------------------
// Figure B15 - P-values for all-lags GDP estimates 
//------------------------------------------------------------------------------

di "Replicating Figure B15" 
do "$path/code/FigureB15.do" 

//------------------------------------------------------------------------------
// Figure B16 - Firpo and Possebom (2018) Confidence Intervals
//------------------------------------------------------------------------------

di "Replicating Figure B16"
do "$path/code/FigureB16-A.do" 
do "$path/code/FigureB16-B.do"
do "$path/code/FigureB16-C.do" 

//------------------------------------------------------------------------------
// Figure B17 - Cattaneo et al. (2021,2025) Prediction Intervals
//------------------------------------------------------------------------------

di "Replicating Figure B17" 
do "$path/code/FigureB17.do" 

//------------------------------------------------------------------------------
// Estimate the Demeaned GDP results (used later for multiple figures)
//------------------------------------------------------------------------------

di "Estimating Demeaned GDP Results"
do "$path/code/gdp-demean-results.do"

//------------------------------------------------------------------------------
// Figure B18- Demeaned SC, Panels A-F
//------------------------------------------------------------------------------

di "Replicating Figure B18"
do "$path/code/FigureB18-A.do"
do "$path/code/FigureB18-B.do"
do "$path/code/FigureB18-C.do"
do "$path/code/FigureB18-D.do"
do "$path/code/FigureB18-E.do"
do "$path/code/FigureB18-F.do" 


//------------------------------------------------------------------------------
// Figure B19 - Bias-Corrected GDP Gaps 
//------------------------------------------------------------------------------

di "Replicating Figure B19" 
do "$path/code/FigureB19.do" 


//------------------------------------------------------------------------------
// Figure B20 - Bias-Corrected Embargo Gaps 
//------------------------------------------------------------------------------

di "Replicating Figure B20" 
do "$path/code/FigureB20-A.do" 
do "$path/code/FigureB20-B.do" 

//------------------------------------------------------------------------------
// Figure B21 - Normalized SCM GDP
//------------------------------------------------------------------------------

di "Replicating Figure B21" 
do "$path/code/FigureB21-A.do"
do "$path/code/FigureB21-B.do"
do "$path/code/FigureB21-C.do"
do "$path/code/FigureB21-D.do"
do "$path/code/FigureB21-E.do"
do "$path/code/FigureB21-F.do"

//------------------------------------------------------------------------------
// Figure B22 - Normalized SCM Embargo
//------------------------------------------------------------------------------

di "Replicating Figure B22" 
do "$path/code/FigureB22-A.do"
do "$path/code/FigureB22-B.do"
do "$path/code/FigureB22-C.do"
do "$path/code/FigureB22-D.do"
do "$path/code/FigureB22-E.do"
do "$path/code/FigureB22-F.do"

//------------------------------------------------------------------------------
// Figure B22 - Normalized SCM Embargo
//------------------------------------------------------------------------------

di "Replicating Figure B22" 
do "$path/code/FigureB22-A.do"
do "$path/code/FigureB22-B.do"
do "$path/code/FigureB22-C.do"
do "$path/code/FigureB22-D.do"
do "$path/code/FigureB22-E.do"
do "$path/code/FigureB22-F.do"

//------------------------------------------------------------------------------
// Estimating SDID Results and producing Figure B23
//------------------------------------------------------------------------------

di "Replicating Western Donol Pool SDID results and Producing Figure B23" 
do "$path/code/FigureB23.do" 


//------------------------------------------------------------------------------
// Estimating SDID Results and producing Figure B24
//------------------------------------------------------------------------------

di "Replicating Figure B24" 
do "$path/code/FigureB24.do"

//------------------------------------------------------------------------------
// Figure B25 and Figure B26 - Unweighted/Entropy Balance DID GDP
//------------------------------------------------------------------------------

di "Replicating Figure B25 and Figure B26" 
do "$path/code/FigureB25-B26.do" 

//------------------------------------------------------------------------------
// Figure B27, Figure B28, and Figure B29 - Unweighted/Entropy Balance DID Trade with US
//------------------------------------------------------------------------------

di "Replicating Figures B27, B28, and B29" 
do "$path/code/FigureB27-B28-B29.do" 

//------------------------------------------------------------------------------
// Figure B30 - Regression Control Method GDP
//------------------------------------------------------------------------------

di "Replicating Figure B30" 
do "$path/code/FigureB30.do" 

//------------------------------------------------------------------------------
// Figure B31 - Regression Control Method Embargo
//------------------------------------------------------------------------------

di "Replicating Figure B31" 
do "$path/code/FigureB31.do" 

//------------------------------------------------------------------------------
di "Finished replicating Appendix B"
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Appendix C
//------------------------------------------------------------------------------

di "Starting replication of Appendix C"

//------------------------------------------------------------------------------
// Estimate the Soviet Bloc collapse results
//------------------------------------------------------------------------------

di "Replicating Soviet Bloc results" 
do "$path/code/gdp-normalize-results-soviet.do"

//------------------------------------------------------------------------------
// Figure C1 - Soviet Bloc Collpase - SCM
//------------------------------------------------------------------------------

di "Replicating Figure C1" 
do "$path/code/FigureC1.do"  

//------------------------------------------------------------------------------
// Figure C2 - Soviet Bloc Collapse - SDID
//------------------------------------------------------------------------------

di "Replicating Figure C2"
do "$path/code/FigureC2.do" 

//------------------------------------------------------------------------------
// Re-estimating Soviet Bloc Collapse - Venezuelan Aid - SCM
// This is needed to produce Figure C3
//------------------------------------------------------------------------------

di "Replicating Fully Adjusted Soviet Bloc Results" 
do "$path/code/full_adjustment-normalize-results-soviet.do"  

//------------------------------------------------------------------------------
// Figure C3 - Soviet Bloc Collapse - Venezuelan Aid - SCM
//------------------------------------------------------------------------------

di "Replicating Figure C3" 
do "$path/code/FigureC3.do"  

//------------------------------------------------------------------------------
// Figure C4 - Soviet Bloc Collapse - Venezuelan Aid - SDID
//------------------------------------------------------------------------------

di "Replicating Figure C4" 
do "$path/code/FigureC4.do"    







 





