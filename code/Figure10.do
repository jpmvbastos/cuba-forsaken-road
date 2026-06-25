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
*| Function: Replicates Figure 10
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/embargo-results.dta", clear

keep if year>=1938 & year<=1972

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

// Graph Setup
global ytitle	= "Cuban Exports to the US (million 1957 USD)"
global xtitle   = "Year"
global treat_graph  = $treat_y -1
	   
// Cuban Exports to the US / US Imports from Cuba
twoway line us_imports year if country=="Cuba", lpattern(solid)  ///
	|| line us_imports_synth  year if country=="Cuba", lpattern(dash) ///
	xline($treat_graph)	 ///
	xlabel(1938(5)1972, labsize(small)) ///
	ylabel(0(200)1000, labsize(small)) ///
	ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	ysize(5) xsize(6)	///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) size(small))  
	   
graph save "$path/figures/Figure10.gph", replace
graph export "$path/figures/Figure10.png", replace



