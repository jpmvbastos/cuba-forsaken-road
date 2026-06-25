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
*| Function: Generates synthetic control estimates for Trade and Western Donor Pool
*| - Output embargo-th-results-wdp.dta will be used for several figures later
*| –
*|==============================================================================

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
ereturn clear
clear results
clear mata 
clear matrix 

// Install packages if necessary (they have been installed in the main file)
* ssc install synth
* ssc install synth_runner
* ssc install allsynth
* ssc install distinct // required by allsynth
* ssc install elasticregress // required by allsynth

// Adjust path if running this file by itself
* global path ""

//------------------------------------------------------------------------------
// Load and Clean Data
//------------------------------------------------------------------------------

// Adjust path if running this file by itself
* global path ""


// Load Data
use "$path/data/tradedata_wdp.dta" ,clear


// Create sample
drop if year<1928 | year>1989 

sort c year
tsset c year

save "$path/results/embargo-th-results-wdp.dta", replace

// Define globals 
global treat_y = 1959
global predictors	 = "adj_mad23 schooling urban"
global x_axis		 = "1928(1)1989"

//------------------------------------------------------------------------------
// Total Trade with the US
//------------------------------------------------------------------------------

allsynth us_trade /// Outcome
	us_trade(1958) us_trade(1956) /// Lags
	us_trade(1953) us_trade(1951) us_trade(1947) ///
	us_trade(1944) us_trade(1941) us_trade(1938) ///
	$predictors, /// Predictors 
	trunit(4) trperiod($treat_y) ///
	unitnames(country) resultsperiod($x_axis) ///
	pvalues(rmspe) ///
	keep($path/results/us_trade-results-wdp.dta, replace)

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/us_trade-wdp.dta", ///
	replace mlab(none)
	
//------------------------------------------------------------------------------
// Total Trade with the World
//------------------------------------------------------------------------------

//Belgium, Netherlands, and Italy missing total trade data

drop if country == "Belgium"
drop if country == "Italy"
drop if country == "Netherlands"

global x_axis		 = "1928(1)1989"

allsynth total_trade /// Outcome
	total_trade(1958) total_trade(1956) total_trade(1953) ///
	total_trade(1951) total_trade(1947) total_trade(1944) ///
	total_trade(1941) total_trade(1938) $predictors, ///
	trunit(4) trperiod($treat_y) ///
	unitnames(country) ///
	resultsperiod($x_axis) ///
	pvalues(rmspe)  ///
	keep($path/results/total_trade-results-wdp.dta, replace)
	
	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/total_trade-wdp.dta", ///
	replace mlab(none)


//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

use "$path/results/embargo-th-results-wdp.dta", clear

keep c country year ///
	gdppc23 adj_mad23 adj_transf23 ///
	schooling urban /// 
	us_trade total_trade

foreach var in us_trade total_trade {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-results-wdp.dta", clear
	
	cap drop unique_W
	drop _Y_treated // This would be repeated 
	
	cap rename _time year // Rename to match main file's merge key
	cap rename _Y_treated_bc `var'_bc
	cap rename _Y_synthetic_bc `var'_synth_bc
	cap rename _Y_synthetic `var'_synth
	cap rename _W_Weight `var'_Weight
	cap rename _Co_Number `var'_donor_lab
	cap rename N N_`var'
	
	// Create a sample tag 
	gen sample_`var' = 1
	
	foreach v in gap gap_bc rmspe rmspe_rank rmspe_bc rmspe_bc_rank p p_bc {
		cap rename `v' `var'_`v'
	}
   
    save `temp_results', replace // Save the edited file temporarily
	
	restore // Restore the main data
	
	// Merge the edited tempfile into the main data
	qui merge 1:1 c year using `temp_results'
	drop _merge // Clean up after merge
}


//------------------------------------------------------------------------------
// Calculate Standardized p-values 
//------------------------------------------------------------------------------

foreach var in us_trade total_trade {
	
	// Compute p-values following Galliani and Quirstoff
	qui distinct country if sample_`var'==1
	scalar J = r(ndistinct)
	cap gen `var'_pval = (`var'_rmspe_rank - 1) / (J - 1)
	cap gen `var'_pval_bc = (`var'_rmspe_bc_rank - 1) / (J - 1)
	
}

save "$path/results/embargo-th-results-wdp.dta", replace

