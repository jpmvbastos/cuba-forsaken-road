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
*| Function: Replicates Figure B16-B
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "Gap in Adjusted GDP per capita"
global xtitle   = "Year"
global treat_graph  = $treat_y -1

*| Unadjusted GDP per Capita
		   
twoway rarea adj_mad23_ci_lb adj_mad23_ci_ub year if country=="Cuba", ///
		fcolor(cranberry%15) lcolor(cranberry*0.1) ///
	|| line adj_mad23_gap year if country=="Cuba", lpattern(solid) lcolor(stblue)		 ///
	xline($treat_graph)	 xlabel(1928(5)1990, labsize(small)) ///
	ylabel(-6000(1000)2000, labsize(small)) yline(0) ///
	   ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6)	///
	   legend(label(1 "90% CI") label(2 "Cuba") label(3 "Synthetic Cuba") ///
	   position(6) rows(1)) 
	   
graph save "$path/figures/FigureB16-B.gph", replace
graph export "$path/figures/FigureB16-B.png", replace



