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
*| Function: Replicates Figure 4
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "Adjusted GDP per capita"
global xtitle   = "Year"
global treat_graph  = $treat_y -1

*| Adjusted GDP per capita
twoway line adj_mad23 year if country=="Cuba", lpattern(solid) 	 ///
	|| line adj_mad23_synth year if country=="Cuba", lpattern(dash) ///
	   xline($treat_graph)		 ///
	   xlabel(1928(5)1990, labsize(small)) ///
	   ylabel(1000(1000)6000, labsize(small))	 ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6)	///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") size(small) ///
	   position(6) rows(1))  
	   
graph save "$path/figures/Figure4.gph", replace
graph export "$path/figures/Figure4.png", replace



