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

tsset id year

// Create sample
keep if latam==1
drop if country_moxlad==""
drop if year<1938 | year>1972

// Define globals 
global treat_y = 1959
global predictors	 = "gdppc23 schooling urban"
global x_axis		 = "1938(1)1972"

//------------------------------------------------------------------------------
// Total Trade with the US
//------------------------------------------------------------------------------

allsynth us_trade /// Outcome
	us_trade(1957) us_trade(1956) /// Lags
	us_trade(1953) us_trade(1950) us_trade(1947) ///
	us_trade(1944) us_trade(1941) us_trade(1938) ///
	$predictors, /// Predictors 
	trunit(8) trperiod($treat_y) ///
	unitnames(country_moxlad) resultsperiod($x_axis) ///
	pvalues(rmspe) transform(us_trade, normalize) ///
	keep($path/results/us_trade-norm-results.dta, replace)

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/us-trade-norm.dta", ///
	replace mlab(none)


//------------------------------------------------------------------------------
// Cuba Exports to US / US Imports from Cuba
//------------------------------------------------------------------------------

// Let's create $1 of imports if it is zero. Otherwise normalization will divide
// by zero and return "transform(us_imports,  normalize) is specified but 
// us_imports does not exist as a variable in the data set. 
// Specified at least one variable in the data set r(198);"

replace us_imports = 0.001 if us_imports==0 

allsynth us_imports   /// Outcome
	us_imports(1957) us_imports(1956) /// Lags
	us_imports(1953) us_imports(1950) us_imports(1947) ///
	us_imports(1944) us_imports(1941) us_imports(1938) ///
	$predictors, /// Predictors 
	trunit(8) trperiod($treat_y) ///
	unitnames(country_moxlad) resultsperiod($x_axis) ///
	pvalues(rmspe) transform(us_imports, normalize) ///
	keep($path/results/us_imports-norm-results.dta, replace)

	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/us-imports-norm.dta", ///
	replace mlab(none)
	
	
//------------------------------------------------------------------------------
// Total Trade with the World
//------------------------------------------------------------------------------

// Load and Clean Data

use "$path/data/master.dta", clear

tsset id year

drop if country_moxlad==""

// There's no import deflator for Bolivia
drop if country=="Bolivia"

// Ecuador data beggining in 1927 and it never enters the synthetic,
// so we chose to drop to expand the matching period for ~ 10 years
drop if country_moxlad == "Ecuador"

drop if year<1920 | year>1979

global x_axis		 = "1920(1)1979"

allsynth trade /// Outcome
	trade(1957) trade(1956) trade(1953) ///
	trade(1950) trade(1947) trade(1944) trade(1941) ///
	trade(1938) trade(1935) trade(1932) trade(1929) ///
	gdppc23 schooling(1950) schooling(1940) ///
	urban(1955) urban(1950), ///
	trunit(8) trperiod($treat_y) ///
	unitnames(country_moxlad) ///
	resultsperiod($x_axis) ///
	pvalues(rmspe) transform(trade, normalize) ///
	keep($path/results/trade-norm-results.dta, replace)
	
	mat V = e(V_matrix)
	esttab mat(V) using "$path/results/v-matrix/trade-norm.dta", ///
	replace mlab(none)


//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

use "$path/data/master.dta", clear

// Keep only trade sample
keep if latam==1
keep if year>=1920 & year<=1979
drop if country_moxlad==""


keep countrycode country id latam former_ussr communist year ///
	gdppc23 adj_mad23 adj_transf23 schooling urban trade /// 
	us_trade us_imports


foreach var in trade us_trade us_imports {
	
	tempfile temp_results // Declare a temporary file name
	
	preserve // Preserve the main data in memory
	
	// Load the allsynth output file
	use "$path/results/`var'-norm-results.dta", clear
	
	cap drop unique_W
	cap rename _Y_treated `var'_norm
	
	cap rename _time year // Rename to match main file's merge key
	cap rename _Y_synthetic `var'_synth_norm
	cap rename _W_Weight `var'_Weight
	cap rename _Co_Number `var'_donor_lab
	cap rename N N_`var'
	
	// Create a sample tag 
	gen sample_`var' = 1
	
	foreach v in gap rmspe rmspe_rank rmspe_bc_rank p {
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

foreach var in trade us_trade us_imports {
	
	// Compute p-values following Galliani and Quirstoff
	qui distinct country if sample_`var'==1
	scalar J = r(ndistinct)
	cap gen `var'_pval = (`var'_rmspe_rank - 1) / (J - 1)
	
}

save "$path/results/embargo-norm-results.dta", replace

