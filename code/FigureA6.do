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
*| Function: Replicates Figure A6
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-soviet-sim-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "Adj. GDP per capita minus Soviet aid"
global xtitle   = "Year"
global treat_graph  = $treat_y -1
	   
*| Adjusted GDP per capita minus Transfers
twoway line adj_transf23_synth year, lpattern(dash) lcolor(cranberry)  ///
	|| line adj_transf23 year, lpattern(sold) lcolor(midblue) ///
	|| line gdp_agt1 year if year>=1961, lcolor(midgreen) ///  
	|| line gdp_alt1 year if year>=1961, lcolor(dkorange) ///
	|| line gdp_amix year if year>=1961, lpattern(shortdash) lcolor(maroon) ///
	xline($treat_graph)	 ///
	xlabel(1928(5)1990, labsize(small)) ///
	ylabel(1000(1000)6000, labsize(small)) ///
	ytitle($ytitle, size(small)) ///
	xtitle($xtitle, size(small)) ///
	ysize(5) xsize(6)	///
	   legend(label(1 "Synthetic Cuba") label(2 "Baseline (A=1)") ///
			  label(3 "Soviet Aid (A>1)") label(4 "Soviet Aid (A<1)") ///
			  label(5 "Soviet Aid varying with {it:t}") ///
	   position(6) rows(2) size(small))  
	   
graph save "$path/figures/FigureA6.gph", replace
graph export "$path/figures/FigureA6.png", replace



