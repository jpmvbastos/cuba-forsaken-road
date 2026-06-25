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
*| Function: Replicates Figure C1
*|==============================================================================

// Adjust path if running this file by itself
* global path ""


// Load Data
use "$path/results/gdp-normalize-soviet-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global xtitle   = "Year"
global treat_graph  = $treat_y -1

*| Unadjusted GDP per Capita
		   
global ytitle	= "Unadjusted GDP per capita"
twoway line gdppc23_index	   year if country=="Cuba", lpattern(solid) lcolor(midblue)					 ///
	|| line gdppc23_synth    year if country=="Cuba", lpattern(dash) lcolor(cranberry) ///
	   xline($treat_graph, lpattern(dash) lcolor(black))		 ///
	   xlabel(1980(5)2018) 	ylabel(60(40)200)											 ///
	   ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6)				 									 ///
	  legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) region(color(white) lcolor(none))) ///
	   ylab(, grid glpattern(dash)) ///
	   xlab(, grid glpattern(dash)) ///
       graphregion(margin(r+10) color(white) lcolor(white)) ///
	   plotregion(color(white)) 
	   
graph save "$path/figures/FigureC1-A.gph", replace
graph export "$path/figures/FigureC1-A.png", replace


//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global xtitle   = "Year"
global treat_graph  = $treat_y -1

*| Unadjusted GDP per Capita
		   
global ytitle	= "Adjusted GDP per capita"
twoway line adj_mad23_index	   year if country=="Cuba", lpattern(solid) lcolor(midblue)					 ///
	|| line adj_mad23_synth    year if country=="Cuba", lpattern(dash) lcolor(cranberry) ///
	   xline($treat_graph, lpattern(dash) lcolor(black))		 ///
	   xlabel(1980(5)2018) 	ylabel(60(40)200)											 ///
	   ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6)				 									 ///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) region(color(white) lcolor(none))) ///
	   ylab(, grid glpattern(dash)) ///
	   xlab(, grid glpattern(dash)) ///
       graphregion(margin(r+10) color(white) lcolor(white)) ///
	   plotregion(color(white)) 
	   
graph save "$path/figures/FigureC1-C.gph", replace
graph export "$path/figures/FigureC1-C.png", replace

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global xtitle   = "Year"
global treat_graph  = $treat_y -1

*| Unadjusted GDP per Capita
		   
global ytitle	= "Adjusted GDP minus Soviet Aid"
twoway line adj_transf23_index	   year if country=="Cuba", lpattern(solid) lcolor(midblue)						 ///
	|| line adj_transf23_synth    year if country=="Cuba", lpattern(dash) lcolor(cranberry) ///
	   xline($treat_graph, lpattern(dash) lcolor(black))		 ///
	   xlabel(1980(5)2018) 	ylabel(60(40)200)											 ///
	   ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6)				 									 ///
	   legend(label(1 "Cuba") label(2 "Synthetic Cuba") ///
	   position(6) rows(1) region(color(white) lcolor(none))) ///
	   ylab(, grid glpattern(dash)) ///
	   xlab(, grid glpattern(dash)) ///
       graphregion(margin(r+10) color(white) lcolor(white)) ///
	   plotregion(color(white)) 
	   
graph save "$path/figures/FigureC1-E.gph", replace
graph export "$path/figures/FigureC1-E.png", replace

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

// Graph stup
global xtitle = "Year"
global ytitle	= "Probability that this would happen by chance"


// Standardized p-values plot

twoway (scatter gdppc23_pval year if country=="Cuba" & year>=1991, mcolor(midblue)) ///
             , ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6) ///
	   xlabel(1991(1)2018, angle(90) labsize(small)) ///
	   ylabel(0(0.1)1) ///
	  legend(off) ///
		   	ylab(, grid glpattern(dash)) ///
	xlab(, grid glpattern(dash)) ///
    graphregion(margin(r+10) color(white) lcolor(white)) ///
	plotregion(color(white)) ///
	  
	   
graph save "$path/figures/FigureC1-B.gph", replace
graph export "$path/figures/FigureC1-b.png", replace


//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

// Graph stup
global xtitle = "Year"
global ytitle	= "Probability that this would happen by chance"


// Standardized p-values plot

twoway (scatter adj_mad23_pval year if country=="Cuba" & year>=1991, mcolor(midblue)) ///
             , ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6) ///
	   xlabel(1991(1)2018, angle(90) labsize(small)) ///
	   ylabel(0(0.1)1) ///
	  legend(off) ///
		   	ylab(, grid glpattern(dash)) ///
	xlab(, grid glpattern(dash)) ///
    graphregion(margin(r+10) color(white) lcolor(white)) ///
	plotregion(color(white)) ///
	  
	   
graph save "$path/figures/FigureC1-D.gph", replace
graph export "$path/figures/FigureC1-D.png", replace


//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------


// Graph stup
global xtitle = "Year"
global ytitle	= "Probability that this would happen by chance"


// Standardized p-values plot

twoway (scatter adj_transf23_pval year if country=="Cuba" & year>=1991, mcolor(midblue)) ///
             , ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6) ///
	   xlabel(1991(1)2018, angle(90) labsize(small)) ///
	   ylabel(0(0.1)1) ///
	  legend(off) ///
		   	ylab(, grid glpattern(dash)) ///
	xlab(, grid glpattern(dash)) ///
    graphregion(margin(r+10) color(white) lcolor(white)) ///
	plotregion(color(white)) ///
	  
	   
graph save "$path/figures/FigureC1-F.gph", replace
graph export "$path/figures/FigureC1-F.png", replace

