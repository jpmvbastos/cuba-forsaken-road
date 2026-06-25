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
*| Function: Generates synthetic control estimates for GDP for Soviet Sample
*| - Output gdp-normalize-soviet-results.dta will be used for several figures later
*| –
*|==============================================================================

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
ereturn clear
clear results
clear mata 
clear matrix 
clear ado

// Install packages if necessary
* ssc install synth
* ssc install synth_runner
* ssc install allsynth
* ssc install distinct // required by allsynth
* ssc install elasticregress // required by allsynth

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/data/master.dta", clear

tsset id year

// Replace data for control countries, since there's no adjustment for them
replace adj_mad23 = gdppc23 if country != "Cuba"
replace adj_transf23 = gdppc23 if country != "Cuba"

//------------------------------------------------------------------------------
// Main Results: GDP
//------------------------------------------------------------------------------

// Create sample
keep if country == "Cuba" | former_ussr == 1 | communist == 1
drop if year<1980 | year>2017

//Some countries missing schooling data
drop if country == "Turkmenistan"
drop if country == "Albania"
drop if country == "Mongolia"

// Define globals 
global treat_y = 1991
global predictors	 = "urban schooling"
global x_axis		 = "1980(1)2017"
// Unadjusted GDP
//------------------------------------------------------------------------------

global pre_treatment = "gdppc23(1980) gdppc23(1984) gdppc23(1987) gdppc23(1989)"

allsynth gdppc23 $predictors $pre_treatment, trunit(8) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe) ///
	  transform(gdppc23, normalize) ///
	  keep($path/results/gdppc23-normalize-results-soviet.dta, replace)

// Adjusted Maddison
//------------------------------------------------------------------------------

global pre_treatment = "adj_mad23(1980) adj_mad23(1984) adj_mad23(1987) adj_mad23(1989)"

allsynth adj_mad23 $predictors $pre_treatment, trunit(8) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe) ///
	  transform(adj_mad23, normalize) ///
	  keep($path/results/adj_mad23-normalize-results-soviet.dta, replace)

	  

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

global pre_treatment = "adj_transf23(1980) adj_transf23(1984) adj_transf23(1987) adj_transf23(1989)"

allsynth adj_transf23 $predictors $pre_treatment, trunit(8) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe) ///
	  transform(adj_transf23, normalize) ///
	  keep($path/results/adj_transf23-normalize-results-soviet.dta, replace)
 

	  
//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

keep countrycode country id latam former_ussr communist year ///
	gdppc23 adj_mad23 adj_transf23 schooling urban

foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-normalize-results-soviet.dta", clear
	
	drop unique_W N
	rename _Y_treated `var'_index
	rename _time year // Rename to match main file's merge key
	rename _Y_synthetic `var'_synth
	rename _W_Weight `var'_Weight
	rename _Co_Number `var'_donor_lab
	
	foreach v in gap rmspe rmspe_rank p {
		rename `v' `var'_`v'
	}
   
    save `temp_results' // Save the edited file temporarily
	
	restore // Restore the main data
	
	// Merge the edited tempfile into the main data
	merge 1:1 id year using `temp_results'
	drop _merge // Clean up after merge
}


//------------------------------------------------------------------------------
// Calculate Standardized p-values 
//------------------------------------------------------------------------------


foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	// Compute p-values following Galliani and Quirstoff
	qui distinct country
	scalar J = r(ndistinct)
	gen `var'_pval = (`var'_rmspe_rank - 1) / (J - 1)
	
	
}



save "$path/results/gdp-normalize-soviet-results.dta", replace




