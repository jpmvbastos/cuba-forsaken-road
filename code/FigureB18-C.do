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
*| Function: Replicates Figure B18-C
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-demean-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "Adjusted GDP per capita"
global xtitle   = "Year"
global treat_graph  = $treat_y -1

cap drop _shift*
gen _shift = adj_mad23 - adj_mad23_demean
gen _shift_synth = adj_mad23_synth_demean + _shift

// Get midpoint for intercept 
qui sum _shift_synth if country=="Cuba" & year==1934
scalar up = r(mean)

qui sum adj_mad23_synth if country=="Cuba" & year==1934
scalar low = r(mean)

global intercept_point = (up + low) / 2
global intercept : display %9.2f (up - low)



*| Adjusted GDP per Capita
twoway (line adj_mad23 year if country=="Cuba", lpattern(solid) lcolor(midblue)) ///
	|| (line _shift_synth year if country=="Cuba", lpattern(dash) lcolor(cranberry)) ///
	|| (line adj_mad23_synth year if country=="Cuba", lpattern(dash) lcolor(cranberry*.5)) ///
	|| (rarea _shift_synth gdppc23_synth year if country=="Cuba", ///
	color(gs14%30) legend(label(4 ""))) ///
	|| (pcbarrow _shift_synth year gdppc23_synth year if country=="Cuba" & year==1934, ///
		lpattern(dash) lwidth(thin) lcolor(cranberry) mcolor(cranberry) legend(label(5 ""))), ///
	   xline($treat_graph) xlabel(1928(5)1990, labsize(small)) ///
	   ylabel(2000(1000)7000, labsize(small)) ///
	   text($intercept_point 1934 "Intercept = $intercept", ///
	   color(cranberry) size(vsmall) placement(ne)) ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6) ///
	   legend(order(1 "Cuba" 2 "Synth. Cuba (re-leveled)" ///
	   3 "Synth. Cuba (original)") ///
           position(6) rows(1) size(small))
	
cap drop *shift
	   
graph save "$path/Figures/FigureB18-C.gph", replace
graph export "$path/Figures/FigureB18-C.png", replace



