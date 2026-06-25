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
*| Function: Replicates Figure B10
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-results-wdp-n.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

// Graph stup
global xtitle = "Year"
global ytitle	= "Probability that this would happen by chance"

global label1	= "Unadjusted GDP"
global label2   = "Adjusted GDP"
global label3   = "Adj. GDP - Soviet Aid"

// Standardized p-values plot

twoway (scatter gdppc23_pval year if country=="Cuba" & year>=1959, mcolor(dkorange)) ///
       (scatter adj_mad23_pval year if country=="Cuba" & year>=1959, mcolor(forest_green)) ///
       (scatter adj_transf23_pval year if country=="Cuba" & year>=1959, mcolor(midblue)) ///
       , ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6) ///
	   xlabel(1959(1)1990, angle(90) labsize(small)) ///
	   ylabel(0(0.1)1) ///
	   legend(order(1 "$label1" 2 "$label2" 3 "$label3" ) ///
           position(6) rows(1) region(color(white) lcolor(none))) ///
		   	ylab(, grid glpattern(dash)) ///
	xlab(, grid glpattern(dash)) ///
    graphregion(margin(r+10) color(white) lcolor(white)) ///
	plotregion(color(white)) ///
	  
	   
graph save "$path/figures/FigureB10.gph", replace
graph export "$path/figures/FigureB10.png", replace



