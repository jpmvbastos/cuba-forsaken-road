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
*| Function: Replicates Figure B21-A
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-norm-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "Unadjusted GDP per capita index (1958=100)"
global xtitle   = "Year"
global treat_graph  = $treat_y -1

*| Unadjusted GDP per Capita
		   
twoway line gdppc23_norm year if country=="Cuba", lpattern(solid) 	 ///
	|| line gdppc23_synth_norm year if country=="Cuba", lpattern(dash) ///  
	   xline($treat_graph) yline(100, lpattern(dash) lwidth(thin)) ///
	   xlabel(1929(5)1990, labsize(small)) ///
	   ylabel(0(25)200, labsize(small))	 ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6)				 									 ///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) size(small)) 
	   
graph save "$path/figures/FigureB21-A.gph", replace
graph export "$path/figures/FigureB21-A.png", replace



