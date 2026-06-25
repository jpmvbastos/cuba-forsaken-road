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
*| Function: Generates synthetic control estimates for GDP
*| - Output gdp-results.dta will be used for several figures later
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
keep if latam==1
drop if year<1928 | year>1989
drop if country_moxlad==""

// Define globals 
global treat_y = 1959
global predictors	 = "urban schooling"

// Unadjusted GDP
//------------------------------------------------------------------------------

allsynth gdppc23 gdppc23(1957) gdppc23(1956) gdppc23(1953) ///
	gdppc23(1950) gdppc23(1947)  gdppc23(1940)  gdppc23(1935) ///
	$predictors, trunit(8) trperiod($treat_y) ///
	  unitnames(country_moxlad) resultsperiod($x_axis) ///
	  pvalues(rmspe) bcorrect(merge ridge)  ///
	  transform(gdppc23 $predictors, demean) ///
	  keep($path/results/gdppc23-demean-results.dta, replace)

// Adjusted Maddison
//------------------------------------------------------------------------------


allsynth adj_mad23 adj_mad23(1957) adj_mad23(1956) adj_mad23(1953) ///
	adj_mad23(1950) adj_mad23(1947)  adj_mad23(1940)  adj_mad23(1935) ///
    $predictors $pre_treatment, trunit(8) trperiod($treat_y) ///
	  unitnames(country_moxlad) resultsperiod($x_axis) ///
	  pvalues(rmspe) bcorrect(merge ridge)  ///
	  transform(adj_mad23 $predictors, demean) ///
	  keep($path/results/adj_mad23-demean-results.dta, replace)	 
			 

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

allsynth adj_transf23 adj_transf23(1957) adj_transf23(1956) ///
	adj_transf23(1953) adj_transf23(1950) adj_transf23(1947) ///
	adj_transf23(1940)  adj_transf23(1935) $predictors, ///
	trunit(8) trperiod($treat_y) ///
	  unitnames(country_moxlad) resultsperiod($x_axis) ///
	  pvalues(rmspe) bcorrect(merge ridge) ///
	  transform(adj_transf23 $predictors, demean) ///
	  keep($path/results/adj_transf23-demean-results.dta, replace) 

	  
//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

keep countrycode country id latam former_ussr communist year ///
	gdppc23 adj_mad23 adj_transf23 schooling urban

foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-demean-results.dta", clear
	
	drop unique_W N
	 
	rename _Y_treated `var'_demean
	rename _time year // Rename to match main file's merge key
	rename _Y_treated_bc `var'_bc
	rename _Y_synthetic_bc `var'_synth_bc
	rename _Y_synthetic `var'_synth_demean
	rename _W_Weight `var'_Weight
	rename _Co_Number `var'_donor_lab
	
	foreach v in gap gap_bc rmspe rmspe_rank rmspe_bc rmspe_bc_rank p p_bc {
		rename `v' `var'_`v'
	}
   
    save `temp_results' // Save the edited file temporarily
	
	restore // Restore the main data
	
	// Merge the edited tempfile into the main data
	merge 1:1 id year using `temp_results'
	drop _merge // Clean up after merge
}

//------------------------------------------------------------------------------
// Remean the synthetic control and compute p-values
//------------------------------------------------------------------------------

levelsof adj_transf23_donor_lab if ///
	adj_transf23_Weight!=0 & country=="Cuba", ///
	local(donors)
	
cap drop *pre_mean
	
foreach var in gdppc23 adj_mad23 adj_transf23 {
	cap drop `var'_synth
	gen `var'_pre_mean = .
	gen `var'_synth = .
	scalar w_mean_`var' = 0
	foreach i of local donors {
		// Get mean of variable for each donor
		qui sum `var' if id==`i' & year<1959
		scalar mean_`var'_`i' = r(mean)
		replace `var'_pre_mean = mean_`var'_`i' if id==`i'
		// Get weight of each donor
		qui sum `var'_Weight if `var'_donor_lab==`i' & country=="Cuba"
		scalar w_`var'_`i' = r(mean)
		// Because it sum to 1, we can simply add the fractions
		scalar w_mean_`var' = w_mean_`var' + (mean_`var'_`i' * w_`var'_`i')
		display(w_mean_`var')
	}
	
	replace `var'_synth = `var'_synth_demean + w_mean_`var' ///
			if country=="Cuba"
			
	// Compute p-values following Galliani and Quirstoff
	qui distinct country
	scalar J = r(ndistinct)
	gen `var'_pval = (`var'_rmspe_rank - 1) / (J - 1)
	gen `var'_pval_bc = (`var'_rmspe_bc_rank - 1) / (J - 1)
	
}


save "$path/results/gdp-demean-results.dta", replace




