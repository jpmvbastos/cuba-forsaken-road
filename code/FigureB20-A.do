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
*| Function: Replicates Figure B20-A
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/embargo-bc-results.dta", clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

*| Graph Setup
global xtitle   = "Year"
global label1	= "Total Trade with the US"
global label2   = "Exports to US"
global label3   = "Total Trade with the World"
global treat_graph  = $treat_y -1

// Trade with US
		   
global ytitle	= "Bias-Corrected Causal Effect (in million 1957 USD)"
twoway line us_trade_gap_bc year if country=="Cuba" ///
		& year>=1938 & year<=1972, lcolor(cranberry) ///
	|| line us_imports_gap_bc year if country=="Cuba" ///
		& year>=1938 & year<=1972, lcolor(stblue) ///
	xline($treat_graph)	 yline(0) ///
	xlabel(1938(5)1972, angle(90) labsize(small)) ///
	ylabel(-2000(500)1000, labsize(small)) ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6) ///
	   legend(order(1 "Total Trade with US" 2 "Exports to US") ///
           position(6) rows(1) size(small)) name(bc, replace)
		   
*| Graph Setup
global ytitle	= "Probability this would happen by chance"
global xtitle   = "Year"
global treat_graph  = $treat_y -1		 

twoway scatter us_trade_pval_bc year if country=="Cuba"	///
		& year>=1959 & year<=1972, msymbol(O) mcolor(cranberry) ///
	|| scatter us_imports_pval_bc year if country=="Cuba" ///
		& year>=1959 & year<=1972, msymbol(O)  mcolor(stblue) ///
	   xlabel(1959(1)1972, angle(90) labsize(small)) ///
	   ylabel(0(.1)1, labsize(small))				 ///
	   ytitle($ytitle, size(small)) ///
	   xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6)	///
	   legend(order(1 "Total Trade with US" 2 "Exports to US") ///
           position(6) rows(1) size(small)) name(bc_pval, replace)
	   
graph combine bc bc_pval, ysize(5) xsize(10)

graph save "$path/figures/FigureB20-A.gph", replace
graph export "$path/figures/FigureB20-A.png", replace



