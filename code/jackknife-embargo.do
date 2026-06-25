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
*| Function: Generates jackknifed SCM estimates for the effect of the embargo
*| - Output jackknife-embargo.dta will be used for plotting later
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
global predictors	 = "gdppc23 schooling urban"
global x_axis		 = "1938(1)1972"

foreach j in 1 3 4 5 6 7 9 10 11 13 15 16 17 20 21 {

	// Load Data
	use "$path/data/master.dta", clear

	tsset id year

	// Create sample
	keep if latam==1
	drop if country_moxlad==""
	drop if year<1938 | year>1972

	// Drop the country
	drop if id==`j'

	// Total Trade with the US
	//--------------------------------------------------------------------------

	allsynth us_trade /// Outcome
		us_trade(1958) us_trade(1957) us_trade(1956) /// Lags
		us_trade(1953) us_trade(1950) us_trade(1947) ///
		us_trade(1944) us_trade(1941) us_trade(1938) ///
		$predictors, /// Predictors 
		trunit(8) trperiod($treat_y) ///
		unitnames(country_moxlad) resultsperiod($x_axis) ///
		pvalues(rmspe)  ///
		keep($path/results/jackknife-embargo/us_trade-out-`j'.dta, replace)

		mat V = e(V_matrix)
		esttab mat(V) using "$path/results/v-matrix/us-trade-out-`j'.dta", ///
		replace mlab(none)
			
	// Cuba Exports to US / US Imports from Cuba
	//--------------------------------------------------------------------------
	
	allsynth us_imports /// Outcome
		us_imports(1958) us_imports(1957) us_imports(1956) /// Lags
		us_imports(1953) us_imports(1950) us_imports(1947) ///
		us_imports(1944) us_imports(1941) us_imports(1938) ///
		$predictors, /// Predictors 
		trunit(8) trperiod($treat_y) ///
		unitnames(country_moxlad) resultsperiod($x_axis) ///
		pvalues(rmspe)  ///
		keep($path/results/jackknife-embargo/us_imports-out-`j'.dta, replace)

		mat V = e(V_matrix)
		esttab mat(V) using "$path/results/v-matrix/us-imports-out-`j'.dta", ///
		replace mlab(none)
		
}

//------------------------------------------------------------------------------
// Total Trade with the World
//------------------------------------------------------------------------------

global x_axis = "1920(1)1979"

// Remove 3 (Bolivia) and 9 (Ecuador) due to incomplete data
foreach j in 1 4 5 6 7 10 11 13 15 16 17 20 21 {

	use "$path/data/master.dta", clear

	tsset id year

	drop if country_moxlad=="" 

	// There's no import deflator for Bolivia
	// Ecuador data beggining in 1927 and it never enters the synthetic,
	// so we chose to drop to expand the matching period for ~ 10 years
	drop if country=="Bolivia"
	drop if country_moxlad == "Ecuador"

	drop if year<1920 | year>1979
	
	// Drop the country
	drop if id==`j'
	
	// Estimate synthetic control
	
	allsynth trade /// Outcome
		trade(1958) trade(1957) trade(1956) trade(1953) ///
		trade(1950) trade(1947) trade(1944) trade(1941) ///
		trade(1938) trade(1935) trade(1932) trade(1929) ///
		gdppc23 schooling(1950) schooling(1940) ///
		urban(1955) urban(1950), ///
		trunit(8) trperiod($treat_y) ///
		unitnames(country_moxlad) ///
		resultsperiod($x_axis) ///
		pvalues(rmspe)  ///
		keep($path/results/jackknife-embargo/trade-out-`j'.dta, replace)
		
		mat V = e(V_matrix)
		esttab mat(V) using "$path/results/v-matrix/trade-out-`j'.dta", ///
		replace mlab(none)
}	

	


//------------------------------------------------------------------------------
// Clean and merge data
//------------------------------------------------------------------------------

foreach var in trade us_imports us_trade {
    
	// Load placeholder data
    use "$path/results/embargo-results.dta", clear
    keep id year `var'_synth `var'_pval
    
	// Keep only Cuba and relevant years
	keep if id==8
	keep if `var'_synth!=.
	
		
	// Declare temp file to store cleaned data
    tempfile to_merge     

    foreach j in 1 3 4 5 6 7 9 10 11 13 15 16 17 20 21 {
		
		// Ignore units 3 and 9 for total trade
		if "`var'"=="trade" & (`j'==3 | `j'==9) {
			continue
		}
		
		else {
			
			preserve 
        
			// Load Data
			use "$path/results/jackknife-embargo/`var'-out-`j'.dta", clear
			keep if id==8
			
			cap drop unique_W
			rename _time year
			
			// Keep the outcome variable for Cuba just for the first iteration
			if `j' == 1{
				rename _Y_treated `var'
			}
			
			else {
				drop _Y_treated
			}
				
			// Compute p-values following Galliani and Quirstoff
			qui sum N 
			scalar J = r(mean)
			cap gen `var'_pval_out`j' = (rmspe_rank - 1) / (J - 1)
			
			drop p 
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
    } 
     
    save "$path/results/jackknife-embargo/`var'-jackknife-results.dta", replace
	
}

//------------------------------------------------------------------------------
// Create dataset for plotting p-values
//------------------------------------------------------------------------------

foreach var in trade us_imports us_trade {
	
	use "$path/results/jackknife-embargo/`var'-jackknife-results.dta", clear
	
	keep if year >= 1959 & `var'!=.
	
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
	
	save "$path/results/jackknife-embargo/`var'-jackknife-pvals.dta", replace
	
}
	

