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
*| Function: Replicates Figure B13
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/embargo-th-results-wdp.dta", clear

keep if year>=1928 & year<=1992

//------------------------------------------------------------------------------
// Plot 1
//------------------------------------------------------------------------------

// Graph Setup
global ytitle	= "Total Trade with the US (in million GBP)"
global xtitle   = "Year"
global treat_graph  = $treat_y - 1
	   
// Total Trade with the US
twoway line us_trade year if country=="Cuba", lpattern(solid) lcolor(midblue) ///
	|| line us_trade_synth  year if country=="Cuba", lpattern(dash) lcolor(cranberry) ///
	xline($treat_graph, lpattern(dash) lcolor(black))	 ///
	xlabel(1928(5)1989, labsize(small)) ///
	ylabel(0(500)2500, labsize(small)) ///
	ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	ysize(5) xsize(6)	///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) size(small) region(color(white) lcolor(none)))  ///
	   		   	ylab(, grid glpattern(dash)) ///
	xlab(, grid glpattern(dash)) ///
    graphregion(margin(r+10) color(white) lcolor(white)) ///
	plotregion(color(white)) ///
	   
graph save "$path/figures/FigureB13-A.gph", replace
graph export "$path/figures/FigureB13-A.png", replace

//------------------------------------------------------------------------------
// Plot 2
//------------------------------------------------------------------------------

// Graph stup
global xtitle = "Year"
global ytitle	= "Probability this would happen by chance"

// Standardized p-values plot

twoway scatter us_trade_pval year if country=="Cuba" & year>=1959 & year<=1992, ///
	   mcolor(midblue) ///
	   xlabel(1959(1)1989, angle(90) labsize(small)) ///
	   ylabel(0(.1)1) ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6)	///
	   legend(off) ///
	   	ylab(, grid glpattern(dash)) ///
		xlab(, grid glpattern(dash)) ///
		graphregion(margin(r+10) color(white) lcolor(white)) ///
		plotregion(color(white)) ///
	   
graph save "$path/figures/FigureB13-B.gph", replace
graph export "$path/figures/FigureB13-B.png", replace



//------------------------------------------------------------------------------
// Plot 3
//------------------------------------------------------------------------------


// Graph Setup
global ytitle	= "Total Trade with the World (in million GBP)"
global xtitle   = "Year"
global treat_graph  = $treat_y - 1
	   
// Total Trade with the US
twoway line total_trade year if country=="Cuba", lpattern(solid) lcolor(midblue) ///
	|| line total_trade_synth  year if country=="Cuba", lpattern(dash) lcolor(cranberry) ///
	xline($treat_graph, lpattern(dash) lcolor(black))	 ///
	xlabel(1928(5)1989, labsize(small)) ///
	ylabel(0(500)3500, labsize(small)) ///
	ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	ysize(5) xsize(6)	///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) size(small) region(color(white) lcolor(none)))  ///
	   		   	ylab(, grid glpattern(dash)) ///
	xlab(, grid glpattern(dash)) ///
    graphregion(margin(r+10) color(white) lcolor(white)) ///
	plotregion(color(white)) ///
	   
graph save "$path/figures/FigureB13-C.gph", replace
graph export "$path/figures/FigureB13-C.png", replace


//------------------------------------------------------------------------------
// Plot 4
//------------------------------------------------------------------------------

// Graph stup
global xtitle = "Year"
global ytitle	= "Probability this would happen by chance"

// Standardized p-values plot

twoway scatter total_trade_pval year if country=="Cuba" & year>=1959 & year<=1992, ///
	   mcolor(midblue) ///
	   xlabel(1959(1)1989, angle(90) labsize(small)) ///
	   ylabel(0(.1)1) ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6)	///
	   legend(off) ///
	   	ylab(, grid glpattern(dash)) ///
		xlab(, grid glpattern(dash)) ///
		graphregion(margin(r+10) color(white) lcolor(white)) ///
		plotregion(color(white)) ///
	   
graph save "$path/figures/FigureB13-D.gph", replace
graph export "$path/figures/FigureB13-D.png", replace
