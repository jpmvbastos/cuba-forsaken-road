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
*| Function: Replicates Figure B2-A
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/embargo-th-results.dta", clear

keep if year>=1922 & year<=1992

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

// Graph Setup
global ytitle	= "Total Trade with the US (in million GBP)"
global xtitle   = "Year"
global treat_graph  = $treat_y - 1
	   
// Total Trade with the US
twoway line us_trade_th year if country=="Cuba", lpattern(solid)  ///
	|| line us_trade_th_synth  year if country=="Cuba", lpattern(dash) ///
	xline($treat_graph)	 ///
	xlabel(1922(5)1992, labsize(small)) ///
	ylabel(0(500)2500, labsize(small)) ///
	ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	ysize(5) xsize(6)	///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) size(small))  
	   
graph save "$path/figures/FigureB2-A.gph", replace
graph export "$path/figures/FigureB2-A.png", replace



