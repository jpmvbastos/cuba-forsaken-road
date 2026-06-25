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
*| Function: Replicates Figure B20-B
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/results/embargo-bc-results.dta", clear

// Trade with World
		   
global ytitle	= "Bias-Corrected Causal Effect (in million 1957 USD)"
twoway line trade_gap_bc year if country=="Cuba", ///
	xline($treat_graph)	 yline(0) ///
	xlabel(1920(5)1979, angle(90) labsize(small)) ///
	ylabel(-3000(1000)3000, labsize(small)) ///
	   ytitle($ytitle, size(small)) xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6) name(bc, replace)
		   
		   
// Graph Setup
global ytitle	= "Probability this would happen by chance"
global xtitle   = "Year"
global treat_graph  = $treat_y -1		 

// P-val Trade with World
twoway scatter trade_pval_bc year if country=="Cuba"	///
		& year>=1959 & year<=1979, msymbol(O) mcolor(stblue) ///
	   xlabel(1959(1)1979, angle(90) labsize(small)) ///
	   ylabel(0(.1)1, labsize(small))				 ///
	   ytitle($ytitle, size(small)) ///
	   xtitle($xtitle, size(small)) ///
	   ysize(5) xsize(6) name(bc_pval, replace)
	   
graph combine bc bc_pval, ysize(5) xsize(10)	  
	   
graph save "$path/figures/FigureB20-B.gph", replace
graph export "$path/figures/FigureB20-B.png", replace
