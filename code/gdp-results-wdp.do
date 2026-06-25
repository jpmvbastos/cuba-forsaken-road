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
*| Function: Generates synthetic control estimates for GDP - for WESTERN Donor Pool
*| - Output gdp-results-wdp.dta will be used for several figures later
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
global path ""

// Load Data
use "$path/data/western_dp.dta", clear

tsset c year

save "$path/data/western_dp.dta", replace

// Create sample
drop if year<1928 | year>1989

save "$path/data/wdp-sample.dta", replace

//------------------------------------------------------------------------------
// Main Results: GDP
//------------------------------------------------------------------------------

// Define globals 
global treat_y = 1959
global predictors	 = "urban schooling"

local donors : list c - 4

// Unadjusted GDP
//------------------------------------------------------------------------------


global pre_treatment = "gdppc23(1957) gdppc23(1956) gdppc23(1953) gdppc23(1950) gdppc23(1947)  gdppc23(1940)  gdppc23(1935)"

allsynth gdppc23 $predictors $pre_treatment, trunit(4) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe)   ///
	  keep($path/results/gdppc23-results-wdp.dta, replace)

	  mat V = e(V_matrix)
	  esttab mat(V) using "$path/results/v-matrix/gdppc23_wdp.dta", ///
	  replace mlab(none)

// Adjusted Maddison 
//------------------------------------------------------------------------------

global pre_treatment = "adj_mad23(1957) adj_mad23(1956) adj_mad23(1953) adj_mad23(1950) adj_mad23(1947)  adj_mad23(1940)  adj_mad23(1935)"

allsynth adj_mad23 $predictors $pre_treatment, trunit(4) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe)  ///
	  keep($path/results/adj_mad23-results-wdp.dta, replace)	 

	  mat V = e(V_matrix)
	  esttab mat(V) using "$path/results/v-matrix/adj_mad23_wdp.dta", replace mlab(none)
			 

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

global pre_treatment = "adj_transf23(1957) adj_transf23(1956) adj_transf23(1953) adj_transf23(1950) adj_transf23(1947)  adj_transf23(1940)  adj_transf23(1935)"

allsynth adj_transf23 $predictors $pre_treatment, trunit(4) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe)   ///
	  keep($path/results/adj_transf23-results-wdp.dta, replace) 

	  mat V = e(V_matrix)
	  esttab mat(V) using "$path/results/v-matrix/adj_transf23_wdp.dta", replace mlab(none)

//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

keep country c year ///
	gdppc23 adj_mad23 adj_transf23 schooling urban

foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-results-wdp.dta", clear
	
	drop unique_W N
	drop _Y_treated // This would be repeated 
	
	rename _time year // Rename to match main file's merge key
	rename _Y_synthetic `var'_synth
	rename _W_Weight `var'_Weight
	rename _Co_Number `var'_donor_lab
	
	foreach v in gap rmspe rmspe_rank p  {
		rename `v' `var'_`v'
	}
   
    save `temp_results' // Save the edited file temporarily
	
	restore // Restore the main data
	
	// Merge the edited tempfile into the main data
	qui merge 1:1 c year using `temp_results'
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
	gen `var'_pval_bc = (`var'_rmspe_bc_rank - 1) / (J - 1)
	
	
}


save "$path/results/gdp-results-wdp.dta", replace

