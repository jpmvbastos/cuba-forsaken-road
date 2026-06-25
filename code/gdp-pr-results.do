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
*| Function: Generates synth. control estimates for GDP, including Puerto Rico
*| - Output gdp-pr-results.dta will be used for several figures later
*|
*|==============================================================================

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
ereturn clear
clear results
clear mata 
clear matrix 
clear ado

// Install packages if necessary (they have been installed in the main file)
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

// Create sample
keep if latam==1
drop if year<1928 | year>1989

replace country_moxlad="Puerto Rico" if country=="Puerto Rico"
drop if country_moxlad=="" 
global x_axis = "1928(1)1989"



//------------------------------------------------------------------------------
// Main Results: GDP
//------------------------------------------------------------------------------

// Define globals 
global treat_y = 1959
global predictors	 = "urban" // No data on schooling for PR, only difference

// Unadjusted GDP
//------------------------------------------------------------------------------

allsynth gdppc23 gdppc23(1957) gdppc23(1956) gdppc23(1953) ///
	gdppc23(1950) gdppc23(1947)  gdppc23(1940)  gdppc23(1935) ///
	$predictors, trunit(8) trperiod($treat_y) ///
	unitnames(country_moxlad) resultsperiod($x_axis) ///
	pvalues(rmspe) bcorrect(merge ridge)  ///
	keep($path/results/gdppc23-pr-results.dta, replace)

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/gdppc23-pr.dta", ///
	replace mlab(none)

// Adjusted Maddison
//------------------------------------------------------------------------------

allsynth adj_mad23 adj_mad23(1957) adj_mad23(1956) adj_mad23(1953) ///
	adj_mad23(1950) adj_mad23(1947)  adj_mad23(1940)  adj_mad23(1935) ///
	$predictors, trunit(8) trperiod($treat_y) ///
	unitnames(country_moxlad) resultsperiod($x_axis) ///
	pvalues(rmspe) bcorrect(merge ridge) ///
	keep($path/results/adj_mad23-pr-results.dta, replace)	 

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/adj_mad23-pr.dta", replace mlab(none)
			 

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

allsynth adj_transf23 adj_transf23(1957) adj_transf23(1956) ///
	adj_transf23(1953) adj_transf23(1950) adj_transf23(1947) ///
	adj_transf23(1940)  adj_transf23(1935) $predictors, ///
	trunit(8) trperiod($treat_y) ///
	unitnames(country_moxlad) ///
	resultsperiod($x_axis) ///
	pvalues(rmspe) bcorrect(merge ridge) ///
	keep($path/results/adj_transf23-pr-results.dta, replace) 

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/adj_transf23-pr.dta", ///
		replace mlab(none)

//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

keep countrycode country id latam former_ussr communist year ///
	gdppc23 adj_mad23 adj_transf23 schooling urban

foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-pr-results.dta", clear
	
	drop unique_W N
	drop _Y_treated // This would be repeated 
	
	rename _time year // Rename to match main file's merge key
	rename _Y_treated_bc `var'_bc
	rename _Y_synthetic_bc `var'_synth_bc
	rename _Y_synthetic `var'_synth
	rename _W_Weight `var'_Weight
	rename _Co_Number `var'_donor_lab
	
	foreach v in gap gap_bc rmspe rmspe_rank rmspe_bc rmspe_bc_rank p p_bc {
		rename `v' `var'_`v'
	}
   
    save `temp_results' // Save the edited file temporarily
	
	restore // Restore the main data
	
	// Merge the edited tempfile into the main data
	qui merge 1:1 id year using `temp_results'
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


save "$path/results/gdp-pr-results.dta", replace

