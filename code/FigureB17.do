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
*| Function: Replicates Figure B17
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/scpi-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global xtitle   = "Year"
global treat_graph  = $treat_y -1

// Just for better plot
replace gdppc23_ci_low = gdppc23_synth if year==1958
replace gdppc23_ci_up = gdppc23_synth if year==1958

*| Unadjusted GDP per Capita
		   
global ytitle	= "Unadjusted GDP per capita"
twoway rarea gdppc23_ci_low gdppc23_ci_up year, ///
		fcolor(cranberry%15) lcolor(cranberry*0.1) ///
	|| line gdppc23_synth year, lpattern(dashed) lcolor(cranberry) ///
	|| line gdppc23	year, lpattern(solid) lcolor(stblue)	///
	xline($treat_graph)	 xlabel(1928(5)1990, labsize(small)) ///
	ylabel(1000(1000)7000, labsize(small)) ///
	   ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6)	///
	   legend(label(1 "90% CI") label(2 "Cuba") label(3 "Synthetic Cuba") ///
	   position(6) rows(1)) name(gdppc23, replace)
	   
graph save "$path/figures/FigureB17-A.gph", replace
graph export "$path/figures/FigureB17-A.png", replace


// Just for better plot
replace adj_mad23_ci_low = adj_mad23_synth if year==1958
replace adj_mad23_ci_up = adj_mad23_synth if year==1958

*| Adjusted GDP per Capita
		   
global ytitle	= "Adjusted per capita"
twoway rarea adj_mad23_ci_low adj_mad23_ci_up year, ///
		fcolor(cranberry%15) lcolor(cranberry*0.1) ///
	|| line adj_mad23_synth year, lpattern(dashed) lcolor(cranberry) ///
	|| line adj_mad23	year, lpattern(solid) lcolor(stblue)	///
	xline($treat_graph)	 xlabel(1928(5)1990, labsize(small)) ///
	ylabel(1000(1000)7000, labsize(small)) ///
	   ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6)	///
	   legend(label(1 "90% CI") label(2 "Cuba") label(3 "Synthetic Cuba") ///
	   position(6) rows(1)) name(adj_mad23, replace)
	   
graph save "$path/figures/FigureB17-B.gph", replace
graph export "$path/figures/FigureB17-B.png", replace

	   
// Just for better plot
replace adj_transf23_ci_low = adj_mad23_synth if year==1958
replace adj_transf23_ci_up = adj_mad23_synth if year==1958

*| Adjusted GDP per Capita - Soviet Aid
		   
global ytitle	= "Adjusted per capita minus Soviet aid"
twoway rarea adj_transf23_ci_low adj_transf23_ci_up year, ///
		fcolor(cranberry%15) lcolor(cranberry*0.1) ///
	|| line adj_transf23_synth year, lpattern(dashed) lcolor(cranberry) ///
	|| line adj_transf23	year, lpattern(solid) lcolor(stblue)	///
	xline($treat_graph)	 xlabel(1928(5)1990, labsize(small)) ///
	ylabel(1000(1000)7000, labsize(small)) ///
	   ytitle($ytitle) xtitle($xtitle) ysize(5) xsize(6)	///
	   legend(label(1 "90% CI") label(2 "Cuba") label(3 "Synthetic Cuba") ///
	   position(6) rows(1)) name(adj_transf23, replace)
	  
graph save "$path/figures/FigureB17-C.gph", replace
graph export "$path/figures/FigureB17-C.png", replace

