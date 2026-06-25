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
*| Function: Replicates Figure B40-2F
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/embargo-norm-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

// Graph stup
global xtitle = "Year"
global ytitle	= "Probability this would happen by chance"

// Standardized p-values plot

twoway scatter trade_pval year if country=="Cuba" & year>=1959 & year<=1979, ///
	   xlabel(1959(1)1979, angle(90) labsize(small)) ///
	   ylabel(0(.1)1) ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6)	///
	   legend(off) 
	   
graph save "$path/figures/FigureB22-F.gph", replace
graph export "$path/figures/FigureB22-F.png", replace



