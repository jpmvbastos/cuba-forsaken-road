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
*| Function: Generates jackknifed SCM estimates for GDP
*| - Output jackknife-gdp.dta will be used for plotting later
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
// Jackknifed GDP Results
//------------------------------------------------------------------------------

// Global Setup
global treat_y       = "1959"
global x_axis		 = "1928(1)1989"
global predictors	 = "urban schooling"

foreach j in 1 3 4 5 6 7 9 10 11 13 15 16 17 20 21 {
	
	// Load Data
	qui use "$path/data/master.dta", clear
	
	// Save the name of the country that is dropped 
	qui levelsof country if id == `j', local(cname)
	qui gen dropped_out`j' = `" `cname' "'
	
	// Create sample
	quietly {
	drop if year<1928 | year>1989
	keep if latam==1
	drop if country_moxlad==""
	tsset id year
	
	// Drop the country
	drop if id==`j'
	
	}

	// Unadjusted GDP per capita
	//--------------------------------------------------------------------------

	allsynth gdppc23 /// Outcome
		gdppc23(1957) gdppc23(1956) gdppc23(1953) ///
		gdppc23(1950) gdppc23(1947)  gdppc23(1940)  ///
		gdppc23(1935) ///
		$predictors, /// Predictors 
		trunit(8) trperiod($treat_y) ///
		unitnames(country) resultsperiod($x_axis) ///
		pvalues(rmspe)  ///
		keep($path/results/jackknife-gdp/gdppc23-out`j'.dta, replace)

		qui mat V = e(V_matrix)
		qui esttab mat(V) using "$path/results/v-matrix/gdppc23-out`j'.dta", ///
		replace mlab(none)
		
	// Adjusted GDP per capita
	//--------------------------------------------------------------------------
		
	allsynth adj_mad23 /// Outcome
		adj_mad23(1957) adj_mad23(1956) adj_mad23(1953) ///
		adj_mad23(1950) adj_mad23(1947)  adj_mad23(1940)  ///
		adj_mad23(1935) ///
		$predictors, /// Predictors 
		trunit(8) trperiod($treat_y) ///
		unitnames(country) resultsperiod($x_axis) ///
		pvalues(rmspe)  ///
		keep($path/results/jackknife-gdp/adj_mad23-out`j'.dta, replace)

		qui mat V = e(V_matrix)
		qui esttab mat(V) using "$path/results/v-matrix/adj_mad23-out`j'.dta", ///
		replace mlab(none)
		
	// Adjusted GDP per capita minus transfers
	//--------------------------------------------------------------------------
	
	allsynth adj_transf23 /// Outcome
		adj_transf23(1957) adj_transf23(1956) adj_transf23(1953) ///
		adj_transf23(1950) adj_transf23(1947)  adj_transf23(1940) ///
		adj_transf23(1935) ///
		$predictors, /// Predictors 
		trunit(8) trperiod($treat_y) ///
		unitnames(country) resultsperiod($x_axis) ///
		pvalues(rmspe) ///
		keep($path/results/jackknife-gdp/adj_transf23-out`j'.dta, replace)

		qui mat V = e(V_matrix)
		qui esttab mat(V) using "$path/results/v-matrix/adj_transf23-out`j'.dta", ///
		replace mlab(none)
	
	}

//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

foreach var in gdppc23 adj_mad23 adj_transf23 {
    
	// Load placeholder data
    use "$path/results/gdp-results.dta", clear 
    keep country id year `var' `var'_synth `var'_pval
    
	// Keep only Cuba and relevant years
	keep if id==8
	
	// Declare temp file to store cleaned data
    tempfile to_merge 

    foreach j in 1 3 4 5 6 7 9 10 11 13 15 16 17 20 21 {
			
		preserve 
	
		// Load Data
		use "$path/results/jackknife-gdp/`var'-out`j'.dta", clear
		keep if id==8
		
		cap drop unique_W
		rename _time year
			
		// Compute p-values following Galliani and Quirstoff
		qui sum N 
		scalar J = r(mean)
		cap gen `var'_pval_out`j' = (rmspe_rank - 1) / (J - 1)
		
		cap drop p 
		cap drop _Y_treated
		
		// Rename variables
		rename _Y_synthetic `var'_synth_out`j'
		
		foreach v in gap rmspe N _Co_Number _W_Weight rmspe_rank {
			cap rename `v' `var'_`v'_out`j'
		}
		
		// Save the cleaned data
		save `to_merge', replace
		
		restore
		
		// Merge to main dataset
		qui merge 1:1 id year using `to_merge'
		drop _merge
		}

	save "$path/results/jackknife-gdp/`var'-jackknife-results.dta", replace
    
	} 

	
// Merge all files 
use "$path/results/gdp-results.dta", clear 

keep country id year
keep if id==8

merge 1:1 id year using "$path/results/jackknife-gdp/gdppc23-jackknife-results.dta"
drop _merge 

merge 1:1 id year using"$path/results/jackknife-gdp/adj_mad23-jackknife-results.dta"
drop _merge 

merge 1:1 id year using"$path/results/jackknife-gdp/adj_transf23-jackknife-results.dta"
drop _merge 

save "$path/results/jackknife-gdp/jackknife-gdp-results.dta", replace


//------------------------------------------------------------------------------
// Create dataset for plotting p-values
//------------------------------------------------------------------------------

use "$path/results/gdp-results.dta", clear 

keep country id year 
keep if id==8


foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	use "$path/results/jackknife-gdp/`var'-jackknife-results.dta", replace
	
	keep if year >= 1959 & year<=1989
	
	keep year `var'_pval `var'_pval_out* 
	
	rename `var'_pval `var'_main_pval
	
	reshape long `var'_pval_out, i(year `var'_main_pval) j(out)
	
	// Get the average and distribution of p-values
	collapse ///
    (mean) `var'_pval_out ///
    (max) max_pval_`var' = `var'_pval_out ///
	(min) min_pval_`var' = `var'_pval_out, ///
    by(year `var'_main_pval)

	cap rename `var'_pval_out pval_`var'
	
	save "$path/results/jackknife-gdp/`var'-jackknife-pvals.dta", replace
	
}

// Merge all files 
use "$path/results/jackknife-gdp/gdppc23-jackknife-pvals.dta", clear 

merge 1:1 year using"$path/results/jackknife-gdp/adj_mad23-jackknife-pvals.dta"
drop _merge 

merge 1:1 year using"$path/results/jackknife-gdp/adj_transf23-jackknife-pvals.dta"
drop _merge 

save "$path/results/jackknife-gdp/gdp-jackknife-pvals.dta", replace

