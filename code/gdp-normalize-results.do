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
global path "/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Papers/Cuba"

// Load Data
use "$path/data/master.dta", clear

tsset id year

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

allsynth gdppc23 ///
	gdppc23(1957) gdppc23(1956) gdppc23(1953) ///
	gdppc23(1950) gdppc23(1947)  gdppc23(1940) ///
	gdppc23(1935) $predictors, trunit(8) trperiod($treat_y) ///
	  unitnames(country_moxlad) resultsperiod($x_axis) ///
	  pvalues(rmspe)  ///
	  transform(gdppc23, normalize) ///
	  keep($path/results/gdppc23-norm-results.dta, replace)

// Adjusted Maddison
//------------------------------------------------------------------------------

allsynth adj_mad23 ///
	adj_mad23(1957) adj_mad23(1956) adj_mad23(1953) ///
	adj_mad23(1950) adj_mad23(1947)  adj_mad23(1940) ///
	adj_mad23(1935) $predictors, trunit(8) trperiod($treat_y) ///
	  unitnames(country_moxlad) resultsperiod($x_axis) ///
	  pvalues(rmspe)  ///
	  transform(adj_mad23, normalize) ///
	  keep($path/results/adj_mad23-norm-results.dta, replace)	 
			 

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

allsynth adj_transf23 ///
	adj_transf23(1957) adj_transf23(1956) adj_transf23(1953) ///
	adj_transf23(1950) adj_transf23(1947)  adj_transf23(1940)  ///
	adj_transf23(1935) $predictors, trunit(8) trperiod($treat_y) ///
	  unitnames(country_moxlad) resultsperiod($x_axis) ///
	  pvalues(rmspe) ///
	  transform(adj_transf23, normalize) ///
	  keep($path/results/adj_transf23-norm-results.dta, replace) 

	  
//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

keep countrycode country id latam former_ussr communist year ///
	gdppc23 adj_mad23 adj_transf23 schooling urban

foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-norm-results.dta", clear
	
	drop unique_W N
	 
	rename _Y_treated `var'_norm
	rename _time year // Rename to match main file's merge key
	rename _Y_synthetic `var'_synth_norm
	rename _W_Weight `var'_Weight
	rename _Co_Number `var'_donor_lab
	
	foreach v in gap rmspe rmspe_rank rmspe_bc_rank p {
		cap rename `v' `var'_`v'
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


save "$path/results/gdp-norm-results.dta", replace




