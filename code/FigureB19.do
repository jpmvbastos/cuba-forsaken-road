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
*| Function: Replicates Figure B19
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/gdp-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global ytitle	= "GDP per capita"
global xtitle   = "Year"
global label1	= "Unadjusted GDP"
global label2   = "Adjusted GDP"
global label   = "Adj. GDP - Soviet Aid"
global treat_graph  = $treat_y -1

*| Unadjusted GDP per Capita
		   
global ytitle	= "Estimated Causal Effect on GDP per capita"
twoway line gdppc23_gap_bc year if country=="Cuba", ///
	 lcolor(dkorange) ///
	|| line adj_mad23_gap_bc year if country=="Cuba", ///
		 lcolor(forest_green) ///
	|| line adj_transf23_gap_bc	year if country=="Cuba", ///
		 lcolor(stblue) ///
	xline($treat_graph)	 yline(0) ///
	xlabel(1928(5)1990, angle(90) labsize(small)) ///
	ylabel(-4000(1000)1000, labsize(small)) ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6) ///
	   legend(order(1 "$label1" 2 "$label2" 3 "$label3") ///
           position(6) rows(1) size(small)) name(bc, replace) nodraw
		   
*| Graph Setup
global ytitle	= "Probability this would happen by chance"
global xtitle   = "Year"
global treat_graph  = $treat_y -1		 

// To avoid overlapping p-vals
cap gen lead_adj23 = year -.15
cap gen lead_transf23 = year +.15 

twoway scatter gdppc23_pval_bc year if country=="Cuba"	///
		& year>=1959, msymbol(O) mcolor(dkorange) ///
	|| scatter adj_mad23_pval_bc lead_adj23 if country=="Cuba" ///
		& year>=1959, msymbol(O)  mcolor(forest_green) ///
	|| scatter adj_transf23_pval_bc lead_transf23 if country=="Cuba" ///
		& year>=1959, msymbol(O) mcolor(stblue) ///
	   xlabel(1959(1)1990, angle(90) labsize(small)) ///
	   ylabel(0(.1)1, labsize(small))				 ///
	   ytitle($ytitle, size(small)) ///
	   xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6)	///
	   legend(label(1 "Unadjusted GDP") label(2 "Adjusted GDP") ///
	   label(3 "Adjusted GDP minus aid") ///
	   position(6) rows(1) size(small)) ///
	   name(bc_pval, replace) nodraw
	   
graph combine bc bc_pval, ysize(5) xsize(10)
	   
cap drop lead_*
	   
graph save "$path/figures/FigureB19.gph", replace
graph export "$path/figures/FigureB19.png", replace



