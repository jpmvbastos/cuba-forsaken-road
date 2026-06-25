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
*| Function: Replicates Figure B5
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/jackknife-gdp/gdp-jackknife-pvals.dta", clear

// Create offset years to prevent overlapping plots
cap gen year_adj23 = year 
replace year_adj23 = year -.2

cap gen year_transf23 = year 
replace year_transf23 = year +.2

//------------------------------------------------------------------------------
// P-Values Jackknifed GDP Estimates
//------------------------------------------------------------------------------

// The first three lines are just to generate the generic marker legend
// They will be hidden in the plot area by plotting subsequent lines on top
// The next three lines generate generic color legends and plot main pvals
// Then we plot the avg. jackknife pvalues
// Then we plot the ranges 

// Plot
twoway (scatter gdppc23_main_pval year, msymbol(O) mcolor(black)) ///
    || (scatter pval_gdppc23 year, msymbol(X) msize(large) mcolor(black)) ///
	|| (rspike max_pval_gdppc23 min_pval_gdppc23 year, lcolor(black)) ///
	|| (scatter gdppc23_main_pval year, msymbol(O) mcolor(dkorange)) ///
	|| (scatter adj_mad23_main_pval year_adj23, msymbol(O) mcolor(forest_green)) ///
	|| (scatter adj_transf23_main_pval year_transf23, msymbol(O) mcolor(midblue)) ///
	|| (scatter pval_gdppc23 year, msymbol(X) msize(large) mcolor(dkorange)) ///
	|| (scatter pval_adj_mad23 year_adj23, msymbol(X) msize(large) mcolor(forest_green)) ///
	|| (scatter pval_adj_transf23 year_transf23, msymbol(X) msize(large) mcolor(midblue)) ///
    || (rspike max_pval_gdppc23 min_pval_gdppc23 year, lcolor(dkorange)) ///
	|| (rspike max_pval_adj_mad23 min_pval_adj_mad23 year_adj23, lcolor(forest_green)) ///
	|| (rspike max_pval_adj_transf23 min_pval_adj_transf23 year_transf23, lcolor(midblue)), ///
    ytitle("Probability that this would happen by chance", size(small)) ///
    xtitle("Year", size(small)) ///
    ylabel(0(.1)1, labsize(small)) ///
    xlabel(1959(1)1989, angle(90) labsize(small)) ///
    legend(order(1 "Main {it:p}-value" /// Appear in black, just for symbol legend
		2 "Avg. Jackknife {it:p}-value" /// Appear in black, just for symbol legend
		3 "Jackknife range" /// Appear in black, just for symbol legend
		4 "Unadjusted GDP" /// Appear in yellow, for color legend
		5 "Adjusted GDP" /// Appear in green, for color legend
		6 "Adjusted GDP - Soviet aid") /// Appear in blue, for color legend
           position(6) rows(2) size(small))
		   
graph save "$path/figures/FigureB5.gph", replace
graph export "$path/figures/FigureB5.png", replace

		   

