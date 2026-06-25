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
*| Function: Replicates Figure 1
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global label1	= "Synthetic Cuba"
global label2	= "Unadjusted GDP"
global label3   = "Adjusted GDP"
global label4   = "Adj. GDP - Soviet Aid"

*| Combined with Markers

global ytitle	= "GDP per capita"
global xtitle   = "Year"
global treat_graph  = 1958

twoway ///
    (line adj_mad23_synth year if country == "Cuba", ///
		lpattern(dash) lcolor(cranberry)) ///
    || (line gdppc23 year if country == "Cuba", ///
		lpattern(solid) lcolor(dkorange)) ///
    || (line adj_mad23 year if country == "Cuba", ///
		lpattern(solid) lcolor(forest_green)) ///
    || (line adj_transf23 year if country == "Cuba", ///
		lpattern(solid) lcolor(midblue)), ///
    xline($treat_graph) ///
    xlabel(1928(5)1990,  labsize(small)) ///
    ylabel(1000(1000)6000, labsize(small)) ///
    ytitle($ytitle, size(small)) ///
    xtitle($xtitle, size(small)) ///
    ysize(6.5) xsize(8) ///
    graphregion(margin(r+10)) ///
    legend(order(1 "$label1" 2 "$label2" 3 "$label3" 4 "$label4") ///
           position(6) rows(2) size(small))

graph save "$path/figures/Figure1.gph", replace
graph export "$path/figures/Figure1.png", replace




