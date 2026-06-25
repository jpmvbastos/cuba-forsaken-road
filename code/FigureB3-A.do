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
*| Function: Replicates Figure B3-A
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-pr-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "GDP per capita"
global xtitle   = "Year"
global treat_graph  = $treat_y -1

*| Unadjusted GDP per Capita
		   
global ytitle	= "Unadjusted GDP per capita"
twoway line gdppc23	   year if country=="Cuba", lpattern(solid) 						 ///
	|| line gdppc23_synth    year if country=="Cuba", lpattern(dash) ///  
	   xline($treat_graph)		 ///
	   xlabel(1928(5)1990, labsize(small)) ///
	   ylabel(1000(1000)7000, labsize(small))											 ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6)				 									 ///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) size(small)) 
	   
graph save "$path/figures/FigureB3-A.gph", replace
graph export "$path/figures/FigureB3-A.png", replace



