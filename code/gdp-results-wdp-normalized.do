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
*| - Output gdp-results-wdp-n.dta will be used for several figures later
*| – Normalized
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
global predictors	 = "urban_index schooling_index"

// Normalize data to 1958

bysort c (year): gen gdppc23_index = gdppc23/gdppc23[31]
bysort c (year): gen adj_mad23_index = adj_mad23/adj_mad23[31]
bysort c (year): gen adj_transf23_index = adj_transf23/adj_transf23[31]
bysort c (year): gen urban_index = urban/urban[33]
bysort c (year): gen schooling_index = schooling/schooling[33]

// Unadjusted GDP
//------------------------------------------------------------------------------


global pre_treatment = "gdppc23_index(1957) gdppc23_index(1956) gdppc23_index(1953) gdppc23_index(1950) gdppc23_index(1947)  gdppc23_index(1940)  gdppc23_index(1935)"

allsynth gdppc23_index $predictors $pre_treatment, trunit(4) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe)   ///
	  keep($path/results/gdppc23-results-wdp-n.dta, replace)

	  mat V = e(V_matrix)
	  esttab mat(V) using "$path/results/v-matrix/gdppc23_wdp_n.dta", ///
	  replace mlab(none)

// Adjusted Maddison 
//------------------------------------------------------------------------------

global pre_treatment = "adj_mad23_index(1957) adj_mad23_index(1956) adj_mad23_index(1953) adj_mad23_index(1950) adj_mad23_index(1947)  adj_mad23_index(1940)  adj_mad23_index(1935)"

allsynth adj_mad23_index $predictors $pre_treatment, trunit(4) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe)  ///
	  keep($path/results/adj_mad23-results-wdp-n.dta, replace)	 

	  mat V = e(V_matrix)
	  esttab mat(V) using "$path/results/v-matrix/adj_mad23_wdp_n.dta", replace mlab(none)
			 

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

global pre_treatment = "adj_transf23_index(1957) adj_transf23_index(1956) adj_transf23_index(1953) adj_transf23_index(1950) adj_transf23_index(1947)  adj_transf23_index(1940)  adj_transf23_index(1935)"

allsynth adj_transf23_index $predictors $pre_treatment, trunit(4) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe)  ///
	  keep($path/results/adj_transf23-results-wdp-n.dta, replace) 

	  mat V = e(V_matrix)
	  esttab mat(V) using "$path/results/v-matrix/adj_transf23_wdp_n.dta", replace mlab(none)

//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

keep country c year ///
	gdppc23_index adj_mad23_index adj_transf23_index schooling_index urban_index

foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-results-wdp-n.dta", clear
	
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
	
	
}


save "$path/results/gdp-results-wdp-n.dta", replace

