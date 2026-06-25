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
drop if country_moxlad==""

// Define globals 
global treat_y = 1959
global predictors = "urban schooling"
global x_axis = "1928(1)1989"

//------------------------------------------------------------------------------
// Main Results: GDP
//------------------------------------------------------------------------------


// Unadjusted GDP
//------------------------------------------------------------------------------

allsynth gdppc23 ///
	gdppc23(1957) gdppc23(1956) gdppc23(1955) gdppc23(1954) ///
	gdppc23(1953) gdppc23(1952) gdppc23(1951) gdppc23(1950)	///
	gdppc23(1949) gdppc23(1948) gdppc23(1947) gdppc23(1946) ///
	gdppc23(1945) gdppc23(1944) gdppc23(1943) gdppc23(1942) ///
	gdppc23(1941) gdppc23(1940) gdppc23(1939) gdppc23(1938) ///
	gdppc23(1937) gdppc23(1936) gdppc23(1935) gdppc23(1934) ///
	gdppc23(1933) gdppc23(1932) gdppc23(1931) gdppc23(1930) ///
	gdppc23(1929) gdppc23(1928), trunit(8) trperiod($treat_y) ///
	resultsperiod($x_axis) ///
	pvalues(rmspe)  ///
	keep($path/results/gdppc23-all-lags-results.dta, replace)

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/gdppc23-all-lags.dta", ///
	replace mlab(none)

// Adjusted Maddison
//------------------------------------------------------------------------------

allsynth adj_mad23 ///
	adj_mad23(1957) adj_mad23(1956) adj_mad23(1955) adj_mad23(1954) ///
	adj_mad23(1953) adj_mad23(1952) adj_mad23(1951) adj_mad23(1950)	///
	adj_mad23(1949) adj_mad23(1948) adj_mad23(1947) adj_mad23(1946) ///
	adj_mad23(1945) adj_mad23(1944) adj_mad23(1943) adj_mad23(1942) ///
	adj_mad23(1941) adj_mad23(1940) adj_mad23(1939) adj_mad23(1938) ///
	adj_mad23(1937) adj_mad23(1936) adj_mad23(1935) adj_mad23(1934) ///
	adj_mad23(1933) adj_mad23(1932) adj_mad23(1931) adj_mad23(1930) ///
	adj_mad23(1929) adj_mad23(1928), trunit(8) trperiod($treat_y) ///
	resultsperiod($x_axis) ///
	pvalues(rmspe) ///
	keep($path/results/adj_mad23-all-lags-results.dta, replace)	 

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/adj_mad23-all-lags.dta", ///
		replace mlab(none)
			 

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

allsynth adj_transf23 ///
	adj_transf23(1957) adj_transf23(1956) adj_transf23(1955) adj_transf23(1954) ///
	adj_transf23(1953) adj_transf23(1952) adj_transf23(1951) adj_transf23(1950)	///
	adj_transf23(1949) adj_transf23(1948) adj_transf23(1947) adj_transf23(1946) ///
	adj_transf23(1945) adj_transf23(1944) adj_transf23(1943) adj_transf23(1942) ///
	adj_transf23(1941) adj_transf23(1940) adj_transf23(1939) adj_transf23(1938) ///
	adj_transf23(1937) adj_transf23(1936) adj_transf23(1935) adj_transf23(1934) ///
	adj_transf23(1933) adj_transf23(1932) adj_transf23(1931) adj_transf23(1930) ///
	adj_transf23(1929) adj_transf23(1928), trunit(8) trperiod($treat_y) ///	
	resultsperiod($x_axis) ///
	pvalues(rmspe) ///
	keep($path/results/adj_transf23-all-lags-results.dta, replace) 

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/adj_transf23-all-lags.dta", ///
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
	use "$path/results/`var'-all-lags-results.dta", clear
	
	drop unique_W N
	drop _Y_treated // This would be repeated 
	
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
}

save "$path/results/gdp-all-lags-results.dta", replace

