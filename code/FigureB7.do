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
*| Function: Replicates Figure B7
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-results-wdp.dta", clear

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
global treat_graph  = $treat_y -1

cap gen gdppc23_lbl = round(gdppc23)
cap gen adj_mad23_synth_lbl = round(adj_mad23_synth)
cap gen adj_mad23_lbl = round(adj_mad23)
cap gen adj_transf23_lbl = round(adj_transf23)

twoway ///
    (line adj_mad23_synth year if country == "Cuba", lpattern(dash) lcolor(cranberry)) ///
    || (line gdppc23 year if country == "Cuba", lpattern(solid) lcolor(dkorange)) ///
    || (line adj_mad23 year if country == "Cuba", lpattern(solid) lcolor(forest_green)) ///
    || (line adj_transf23 year if country == "Cuba", lpattern(solid) lcolor(midblue)) ///
    || (scatter adj_mad23_synth year if country == "Cuba" & year == 1972, ///
        msymbol(O) mcolor(cranberry) mlabel(adj_mad23_synth_lbl) mlabcolor(cranberry) ///
        legend(label(6 ""))) ///
   , ///
    xline($treat_graph, lpattern(dash)) ///
    xlabel(1928(5)1989) ///
    ylabel(1000(5000)17000) ///
    ytitle($ytitle) ///
    xtitle($xtitle) ///
	ylab(, grid glpattern(dash)) ///
	xlab(, grid glpattern(dash)) ///
    graphregion(margin(r+10) color(white) lcolor(white)) ///
	plotregion(color(white)) ///
    legend(order(1 "$label1" 2 "$label2" 3 "$label3" 4 "$label4") ///
           position(6) rows(2) region(color(white) lcolor(none)))

graph save "$path/figures/FigureB7.gph", replace
graph export "$path/figures/FigureB7.png", replace

cap drop *_lbl



