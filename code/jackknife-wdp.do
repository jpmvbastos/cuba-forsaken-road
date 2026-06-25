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
*| Function: Generates jackknifed SCM estimates for GDP, Western donor sample
*| - Output jackknife-wdp.dta will be used for plotting later
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
// Total Trade with the US
//------------------------------------------------------------------------------

// Define globals 
global treat_y = 1959
global x_axis		 = "1928(1)1989"

// Load data 
use "$path/data/western_dp.dta", clear

levelsof c, local(donors)

foreach j of local donors {
	
	// Skip Cuba
	if `j' == 4 {
		continue 
	}
	
	else {
	
	// Load Data
	use "$path/data/western_dp.dta", clear

	tsset c year
	
	// Create sample
	drop if year<1928 | year>1989

	// Drop the country
	drop if c==`j'

	// Unadjusted GDP per capita
	//--------------------------------------------------------------------------

	allsynth gdppc23 /// Outcome
		gdppc23(1957) gdppc23(1956) gdppc23(1953) ///
		gdppc23(1950) gdppc23(1947)  gdppc23(1940)  ///
		gdppc23(1935) ///
		$predictors, /// Predictors 
		trunit(4) trperiod($treat_y) ///
		unitnames(country) resultsperiod($x_axis) ///
		pvalues(rmspe)  transform(gdppc23, normalize) ///
		keep($path/results/jackknife-wdp/gdppc23-wdp-out`j'.dta, replace)

		mat V = e(V_matrix)
		esttab mat(V) using "$path/results/v-matrix/gdppc23-wdp-out`j'.dta", ///
		replace mlab(none)
		
	// Adjusted GDP per capita
	//--------------------------------------------------------------------------
		
	allsynth adj_mad23 /// Outcome
		adj_mad23(1957) adj_mad23(1956) adj_mad23(1953) ///
		adj_mad23(1950) adj_mad23(1947)  adj_mad23(1940)  ///
		adj_mad23(1935) ///
		$predictors, /// Predictors 
		trunit(4) trperiod($treat_y) ///
		unitnames(country) resultsperiod($x_axis) ///
		pvalues(rmspe)  transform(adj_mad23, normalize) ///
		keep($path/results/jackknife-wdp/adj_mad23-wdp-out`j'.dta, replace)

		mat V = e(V_matrix)
		esttab mat(V) using "$path/results/v-matrix/adj_mad23-wdp-out`j'.dta", ///
		replace mlab(none)
		
	// Adjusted GDP per capita minus transfers
	//--------------------------------------------------------------------------
	allsynth adj_transf23 /// Outcome
		adj_transf23(1957) adj_transf23(1956) adj_transf23(1953) ///
		adj_transf23(1950) adj_transf23(1947)  adj_transf23(1940) ///
		adj_transf23(1935) ///
		$predictors, /// Predictors 
		trunit(4) trperiod($treat_y) ///
		unitnames(country) resultsperiod($x_axis) ///
		pvalues(rmspe) transform(adj_transf23, normalize) ///
		keep($path/results/jackknife-wdp/adj_transf23-wdp-out`j'.dta, replace)

		mat V = e(V_matrix)
		esttab mat(V) using "$path/results/v-matrix/adj_transf23-wdp-out`j'.dta", ///
		replace mlab(none)
	
	
	}
}	


//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

foreach var in gdppc23 adj_mad23 adj_transf23 {
    
	// Load placeholder data
    use "$path/results/gdp-norm-wdp-results.dta", clear 
    keep country c year `var' `var'_norm `var'_synth_norm `var'_pval
    
	// Keep only Cuba and relevant years
	keep if c==4
	
	// Declare temp file to store cleaned data
    tempfile to_merge 

    foreach j in 2 3 5 6 7 8 9 10 11 12 13 14 15 16 17  {
			
		preserve 
	
		// Load Data
		use "$path/results/jackknife-wdp/`var'-wdp-out`j'.dta", clear
		keep if c==4
		
		cap drop unique_W
		rename _time year
			
		// Compute p-values following Galliani and Quirstoff
		qui sum N 
		scalar J = r(mean)
		cap gen `var'_pval_out`j' = (rmspe_rank - 1) / (J - 1)
		
		cap drop p 
		cap drop _Y_treated
		
		// Rename variables
		rename _Y_synthetic `var'_synth_norm_out`j'
		
		foreach v in gap rmspe N _Co_Number _W_Weight rmspe_rank {
			cap rename `v' `var'_`v'_out`j'
		}
		
		// Save the cleaned data
		save `to_merge', replace
		
		restore
		
		// Merge to main dataset
		qui merge 1:1 c year using `to_merge'
		drop _merge
		}

	save "$path/results/jackknife-wdp/`var'-norm-jackknife-results.dta", replace
    
	} 


//------------------------------------------------------------------------------
// Create dataset for plotting p-values
//------------------------------------------------------------------------------

foreach var in gdppc23 adj_mad23 adj_transf23 {
	
	use "$path/results/jackknife-wdp/`var'-norm-jackknife-results.dta", replace
	
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
	
	save "$path/results/jackknife-wdp/`var'-jackknife-pvals.dta", replace
	
}
	

