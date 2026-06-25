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

// Load Data
use "$path/data/master.dta", clear

keep if latam==1

// Create sample
drop if year<1922 | year>1989 

drop if country=="" // No predictor data
drop if country=="Puerto Rico" | /// no trade data
	country=="Barbados" | /// Data starts in 1950
	country=="Guatemala" | /// gaps between 1942-1945 -- too much to interpolate
	country=="Honduras" | /// gaps between 1939-1941
	country=="Costa Rica" /// gaps between 1939 and 1945 

sort id year
tsset id year

save "$path/results/embargo-th-results.dta", replace

// Define globals 
global treat_y = 1959
global predictors	 = "adj_mad23 schooling urban"
global x_axis		 = "1922(1)1989"

//------------------------------------------------------------------------------
// Total Trade with the US
//------------------------------------------------------------------------------

allsynth us_trade_th /// Outcome
	us_trade_th(1958) us_trade_th(1956) /// Lags
	us_trade_th(1953) us_trade_th(1951) us_trade_th(1947) ///
	us_trade_th(1944) us_trade_th(1941) us_trade_th(1938) ///
	$predictors, /// Predictors 
	trunit(8) trperiod($treat_y) ///
	unitnames(country) resultsperiod($x_axis) ///
	pvalues(rmspe) ///
	keep($path/results/us_trade_th-results.dta, replace)

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/us-trade-th.dta", ///
	replace mlab(none)
	
//------------------------------------------------------------------------------
// Total Trade with the World
//------------------------------------------------------------------------------

// Clean Data

drop if year<1932 // Nicaragua Uruguay and El Salvador have missing data before that

global x_axis		 = "1932(1)1989"

allsynth trade_th /// Outcome
	trade_th(1958) trade_th(1956) trade_th(1953) ///
	trade_th(1951) trade_th(1947) trade_th(1944) ///
	trade_th(1941) trade_th(1938) $predictors, ///
	trunit(8) trperiod($treat_y) ///
	unitnames(country) ///
	resultsperiod($x_axis) ///
	pvalues(rmspe)  ///
	keep($path/results/trade_th-results.dta, replace)
	
	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/trade-th.dta", ///
	replace mlab(none)


//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

use "$path/results/embargo-th-results.dta", clear

keep countrycode country id year ///
	gdppc23 adj_mad23 adj_transf23 ///
	schooling urban /// 
	us_trade_th trade_th

foreach var in us_trade_th trade_th {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-results.dta", clear
	
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
	qui merge 1:1 id year using `temp_results'
	drop _merge // Clean up after merge
}


//------------------------------------------------------------------------------
// Calculate Standardized p-values 
//------------------------------------------------------------------------------

foreach var in us_trade_th trade_th {
	
	// Compute p-values following Galliani and Quirstoff
	qui distinct country if sample_`var'==1
	scalar J = r(ndistinct)
	cap gen `var'_pval = (`var'_rmspe_rank - 1) / (J - 1)
	cap gen `var'_pval_bc = (`var'_rmspe_bc_rank - 1) / (J - 1)
	
}

save "$path/results/embargo-th-results.dta", replace

