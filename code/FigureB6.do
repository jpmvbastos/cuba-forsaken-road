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
*| Function: Replicates Figure B6
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

//------------------------------------------------------------------------------
// Panel A - Total Trade with the US
//------------------------------------------------------------------------------

// Load Data
use "$path/results/jackknife-embargo/us_trade-jackknife-results.dta", clear

global treat_graph = 1958

// Plot
twoway ///
	(line us_trade year, lcolor(midblue) lpattern(solid)) ///
	|| (line us_trade_synth year, lcolor(cranberry) lpattern(dash)) ///
    || (line us_trade_synth_out1 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out3 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out4 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out5 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out6 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out7 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out9 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out10 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out11 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out13 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out15 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out16 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out17 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out20 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth_out21 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_trade_synth year, lcolor(cranberry) lpattern(dash)) /// 
	|| (line us_trade year, lcolor(midblue) lpattern(solid)), /// 
	xline($treat_graph) ///
    xlabel(1938(5)1972, labsize(small)) ///
	ylabel(0(500)2000, labsize(small)) ///
    ytitle("Total Trade with the US (million 1957 USD)", size(small))  ///
	xtitle("Year", size(small)) ///
    ysize(6) xsize(7) ///
    legend(order(1 "Cuba" 2 "Main Synth. Cuba" 3 "Jackknifed SC") ///
           position(6) rows(1) size(small))
		   
graph save "$path/figures/FigureB6-A.gph", replace
graph export "$path/figures/FigureB6-A.png", replace
	
	
//------------------------------------------------------------------------------
// Panel B - P-Values - Total Trade with the US
//------------------------------------------------------------------------------
		
// Load Data
use "$path/results/jackknife-embargo/us_trade-jackknife-pvals.dta", clear

// Plot
twoway ///
	(scatter us_trade_main_pval year, msymbol(O) mcolor(cranberry)) ///
    || (scatter pval_us_trade year, msymbol(O) mcolor(midblue)) ///
	|| (rcap max_pval_us_trade min_pval_us_trade year, lcolor(midblue)) ///
	|| (scatter us_trade_main_pval year, msymbol(O) mcolor(cranberry)), ///
    ytitle("Probability that this would happen by chance", size(small)) ///
    xtitle("Year", size(small)) ///
    ylabel(0(.1)1, labsize(small)) ///
    xlabel(1959(1)1972, angle(90) labsize(small)) ///
	ysize(5) xsize(6)	///
    legend(order(1 "Main {it:p}-value" 2 "Avg. Jackknife {it:p}-value" 3 "Jackknife range") ///
           position(6) rows(1) size(small))
	

graph save "$path/figures/FigureB6-B.gph", replace
graph export "$path/figures/FigureB6-B.png", replace

//------------------------------------------------------------------------------
// Panel C - Cuban Exports to the US // US Imports from Cuba
//------------------------------------------------------------------------------

// Load Data
use "$path/results/jackknife-embargo/us_imports-jackknife-results.dta", clear


// Plot
twoway ///
	(line us_imports year, lcolor(midblue) lpattern(solid)) ///
	|| (line us_imports_synth year, lcolor(cranberry) lpattern(dash)) ///
    || (line us_imports_synth_out1 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out3 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out4 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out5 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out6 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out7 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out9 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out10 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out11 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out13 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out15 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out16 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out17 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out20 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth_out21 year, lcolor(gray%40) lpattern(dash)) ///
    || (line us_imports_synth year, lcolor(cranberry) lpattern(dash)) /// 
	|| (line us_imports year, lcolor(midblue) lpattern(solid)), /// 
	xline($treat_graph) ///
    xlabel(1938(5)1972, labsize(small)) ///
	ylabel(0(500)1500, labsize(small)) ///
    ytitle("Cuban Exports to the US (million 1957 USD)", size(small))  ///
	xtitle("Year", size(small)) ///
    ysize(6) xsize(7) ///
    legend(order(1 "Cuba" 2 "Main Synth. Cuba" 3 "Jackknifed SC") ///
           position(6) rows(1) size(small))
		   
graph save "$path/figures/FigureB6-C.gph", replace
graph export "$path/figures/FigureB6-C.png", replace
	
	
//------------------------------------------------------------------------------
// Panel D - P-Values - Cuban Exports to the US // US Imports from Cuba
//------------------------------------------------------------------------------
		
// Load Data
use "$path/results/jackknife-embargo/us_imports-jackknife-pvals.dta", clear

// Plot
twoway ///
	(scatter us_imports_main_pval year, msymbol(O) mcolor(cranberry)) ///
    || (scatter pval_us_imports year, msymbol(O) mcolor(midblue)) ///
	|| (rcap max_pval_us_imports min_pval_us_imports year, lcolor(midblue)) ///
	|| (scatter us_imports_main_pval year, msymbol(O) mcolor(cranberry)), ///
    ytitle("Probability that this would happen by chance", size(small)) ///
    xtitle("Year", size(small)) ///
    ylabel(0(.1)1, labsize(small)) ///
    xlabel(1959(1)1972, angle(90) labsize(small)) ///
	ysize(5) xsize(6)	///
    legend(order(1 "Main {it:p}-value" 2 "Avg. Jackknife {it:p}-value" 3 "Jackknife range") ///
           position(6) rows(1) size(small))
	

graph save "$path/figures/FigureB6-D.gph", replace
graph export "$path/figures/FigureB6-D.png", replace


//------------------------------------------------------------------------------
// Panel E - Total Trade with the World
//------------------------------------------------------------------------------

// Load Data
use "$path/results/jackknife-embargo/trade-jackknife-results.dta", clear


// Plot
twoway ///
	(line trade year, lcolor(midblue) lpattern(solid)) ///
	|| (line trade_synth year, lcolor(cranberry) lpattern(dash)) ///
    || (line trade_synth_out1 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out4 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out5 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out6 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out7 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out10 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out11 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out13 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out15 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out16 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out17 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out20 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth_out21 year, lcolor(gray%40) lpattern(dash)) ///
    || (line trade_synth year, lcolor(cranberry) lpattern(dash)) /// 
	|| (line trade year, lcolor(midblue) lpattern(solid)), /// 
	xline($treat_graph) ///
    xlabel(1920(5)1979, labsize(small)) ///
	ylabel(0(2000)14000, labsize(small)) ///
    ytitle("Total Trade with the World (million 1957 USD)", size(small))  ///
	xtitle("Year", size(small)) ///
    ysize(6) xsize(7) ///
    legend(order(1 "Cuba" 2 "Main Synth. Cuba" 3 "Jackknifed SC") ///
           position(6) rows(1) size(small))
		   
graph save "$path/figures/FigureB6-E.gph", replace
graph export "$path/figures/FigureB6-E.png", replace
	
	
//------------------------------------------------------------------------------
// Panel F - P-Values - Total Trade with the World
//------------------------------------------------------------------------------
		
// Load Data
use "$path/results/jackknife-embargo/trade-jackknife-pvals.dta", clear

// Plot
twoway ///
	(scatter trade_main_pval year, msymbol(O) mcolor(cranberry)) ///
    || (scatter pval_trade year, msymbol(O) mcolor(midblue)) ///
	|| (rcap max_pval_trade min_pval_trade year, lcolor(midblue)) ///
	|| (scatter trade_main_pval year, msymbol(O) mcolor(cranberry)), ///
    ytitle("Probability that this would happen by chance", size(small)) ///
    xtitle("Year", size(small)) ///
    ylabel(0(.1)1, labsize(small)) ///
    xlabel(1959(1)1979, angle(90) labsize(small)) ///
	ysize(5) xsize(6)	///
    legend(order(1 "Main {it:p}-value" 2 "Avg. Jackknife {it:p}-value" 3 "Jackknife range") ///
           position(6) rows(1) size(small))

graph save "$path/figures/FigureB6-F.gph", replace
graph export "$path/figures/FigureB6-F.png", replace


















