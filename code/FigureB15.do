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
*| Function: Replicates Figure B15
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-all-lags-results.dta", clear

drop if year<1959
keep if country == "Cuba"

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

// To avoid overlapping p-vals
cap gen year_adj23 = year 
replace year_adj23 = year -.1

cap gen year_transf23 = year 
replace year_transf23 = year +.1
  
twoway (scatter gdppc23_pval year, msymbol(O) mcolor(dkorange)) ///
	|| (scatter adj_mad23_pval year_adj23, msymbol(O) mcolor(forest_green)) ///
    || (scatter adj_transf23_pval year_transf23, msymbol(O) mcolor(midblue)), ///
    ytitle("Probability that this would happen by chance", size(small)) ///
    xtitle("Years since treatment", size(small)) ///
    ylabel(0(.1)1, labsize(small)) ///
    xlabel(1959(1)1989, angle(90) labsize(small)) ///
	   legend(order(1 "Unadjusted GDP" ///
			2 "Adjusted GDP" ///
			3 "Adj. GDP - Soviet Aid") ///
           position(6) rows(1))

graph save "$path/figures/FigureB15.gph", replace
graph export "$path/figures/FigureB15.png", replace




