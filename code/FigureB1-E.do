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
*| Function: Replicates Figure B1-E
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp13-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "Adj. GDP per capita minus Soviet aid"
global xtitle   = "Year"
global treat_graph  = $treat_y -1
	   
*| Adjusted GDP per capita minus Transfers
twoway line adj_transf13	   year if country=="Cuba", lpattern(solid)  ///
	|| line adj_transf13_synth    year if country=="Cuba", lpattern(dash) ///
	xline($treat_graph)	 ///
	xlabel(1929(5)1990, labsize(small)) ///
	ylabel(1000(1000)6000, labsize(small)) ///
	ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	ysize(5) xsize(6)	///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) size(small))  
	   
graph save "$path/figures/FigureB1-E.gph", replace
graph export "$path/figures/FigureB1-E.png", replace



