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
*| Function: Replicates Figure B4
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

//------------------------------------------------------------------------------
// Jackknifed GDP Estimates
//------------------------------------------------------------------------------

// Load Data
use "$path/results/jackknife-gdp/jackknife-gdp-results.dta", clear

// Graph Setup

global ytitle	= "GDP per capita"
global xtitle   = "Year"
global treat_graph  = $treat_y -1

twoway ///
    (line gdppc23 year, lcolor(dkorange) lpattern(solid)) ///
    || (line adj_mad23 year, lcolor(forest_green) lpattern(solid)) ///
    || (line adj_transf23 year, lcolor(midblue) lpattern(solid)) ///
	|| (line adj_transf23_synth year, lcolor(cranberry) lpattern(solid)) ///
    || (line adj_transf23_synth_out1 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out3 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out4 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out5 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out6 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out7 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out9 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out10 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out11 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out13 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out15 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out16 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out17 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out20 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_out21 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_transf23_synth year, lcolor(cranberry) lpattern(solid)) ///
    || (line adj_transf23 year, lcolor(midblue) lpattern(solid)), ///
	xline($treat_graph) ///
    xlabel(1928(5)1990, labsize(small)) ///
    ylabel(1000(1000)6000, labsize(small)) ///
    ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
    ysize(5) xsize(6) ///
    legend(order(1 "Unadjusted" 2 "Adjusted" 3 "Adj. minus Soviet aid" ///
	4 "Main Synth. Control" 5 "Jackknifed SC") //////
           position(6) rows(2) size(small))
		   
graph save "$path/figures/FigureB4.gph", replace
graph export "$path/figures/FigureB4.png", replace
	
	
