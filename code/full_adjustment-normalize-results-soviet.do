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
*| - Output full_adjustment-normalize-soviet-results.dta will be used for several figures later
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


//Venezuelan subsidies

import delimited "$path/data/VenezuelanSubsidies.csv", clear 
sort year
save "$path/data/VenezuelanSubsidies.dta", replace
clear

// Load Data
use "$path/data/master.dta", clear

sort year

//Merge Venezuelan Subsidies
merge year using "$path/data/VenezuelanSubsidies.dta"
drop _merge
replace v_subsidies = . if country != "Cuba"

tsset id year

// Generate Full Adjustment Variable; Takes out both Soviet and Venezuelan Subsidies (Soviet part only matters for pre-treatment period)
gen full_adjustment = adj_transf23
replace full_adjustment = adj_transf23 - v_subsidies*adj_transf23 if year > 2003 & country == "Cuba"

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

global pre_treatment = "full_adjustment(1980) full_adjustment(1984) full_adjustment(1987) full_adjustment(1989)"

allsynth full_adjustment $predictors $pre_treatment, trunit(8) trperiod($treat_y) ///
	  unitnames(country) resultsperiod($x_axis) ///
	  pvalues(rmspe) ///
	  transform(full_adjustment, normalize) ///
	  keep($path/results/full_adjustment-normalize-results-soviet.dta, replace)

 
  
//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

keep countrycode country id latam former_ussr communist year ///
	full_adjustment schooling urban

foreach var in full_adjustment {
	
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


foreach var in full_adjustment {
	
	// Compute p-values following Galliani and Quirstoff
	qui distinct country
	scalar J = r(ndistinct)
	gen `var'_pval = (`var'_rmspe_rank - 1) / (J - 1)
	
	
}



save "$path/results/full_adjustment-normalize-soviet-results.dta", replace




