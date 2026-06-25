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
*| Function: Replicates Figure A5
*|==============================================================================

// Setup

// Adjust path if running this file by itself
* global path "YOUR_PATH_HERE"

// Load Data
use "$path/data/master.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "Soviet and Eastern Bloc Aid as share of GDP"
global xtitle   = "Year"

*| Soviet aid
twoway bar transfers year if country=="Cuba" & year>=1960 & year<=1990 ///
	|| scatter transfers year if country=="Cuba" & year>=1960 & year<=1990, ///
		mlab(transfers) mlabsize(*0.8) mlabcolor(black) mlabposition(12) ///
		mcolor(none) mlabgap(*1.1) ///
		xlabel(1960(5)1990)  ///
		ytitle($ytitle) xtitle($xtitle) ///
		ysize(5) xsize(8) ///
		legend(off)  
	   
graph save "$path/figures/FigureA5.gph", replace
graph export "$path/figures/FigureA5.png", replace



