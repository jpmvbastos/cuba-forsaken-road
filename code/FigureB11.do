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
*| Function: Replicates Figure B11
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

//------------------------------------------------------------------------------
// Panel A - Unadjusted GDP per capita (1958=100)
//------------------------------------------------------------------------------

// Load Data
use "$path/results/jackknife-wdp/gdppc23-norm-jackknife-results.dta", clear


// Plot
twoway ///
	(line gdppc23_norm year, lcolor(midblue) lpattern(solid)) ///
	|| (line gdppc23_synth_norm year, lcolor(cranberry) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out2 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out3 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out5 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out6 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out7 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line gdppc23_synth_norm_out8 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out9 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out10 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out11 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line gdppc23_synth_norm_out12 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out13 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line gdppc23_synth_norm_out14 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out15 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out16 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm_out17 year, lcolor(gray%40) lpattern(dash)) ///
    || (line gdppc23_synth_norm year, lcolor(cranberry) lpattern(dash)) /// 
	|| (line gdppc23_norm year, lcolor(midblue) lpattern(solid)), /// 
	xline($treat_graph) ///
    xlabel(1928(5)1989, labsize(small)) ///
	ylabel(0(50)250, labsize(small)) ///
    ytitle("Unadjusted GDP per capita (1958=100)", size(small))  ///
	xtitle("Year", size(small)) ///
    ysize(6) xsize(7) ///
    legend(order(1 "Cuba" 2 "Main Synth. Cuba" 3 "Jackknifed SC") ///
           position(6) rows(1) size(small))
		   
graph save "$path/figures/FigureB11-A.gph", replace
graph export "$path/figures/FigureB11-A.png", replace
	
	
//------------------------------------------------------------------------------
// Panel B - P-Values - Unadjusted GDP per capita (1958=100)
//------------------------------------------------------------------------------
		
// Load Data
use "$path/results/jackknife-wdp/gdppc23-jackknife-pvals.dta", clear

// Plot
twoway ///
	(scatter gdppc23_main_pval year, msymbol(O) mcolor(cranberry)) ///
    || (scatter pval_gdppc23 year, msymbol(O) mcolor(midblue)) ///
	|| (rcap max_pval_gdppc23 min_pval_gdppc23 year, lcolor(midblue)) ///
	|| (scatter gdppc23_main_pval year, msymbol(O) mcolor(cranberry)), ///
    ytitle("Probability that this would happen by chance", size(small)) ///
    xtitle("Year", size(small)) ///
    ylabel(0(.1)1, labsize(small)) ///
    xlabel(1959(1)1989, angle(90) labsize(small)) ///
	ysize(5) xsize(6)	///
    legend(order(1 "Main {it:p}-value" 2 "Avg. Jackknife {it:p}-value" 3 "Jackknife range") ///
           position(6) rows(1) size(small))
	

graph save "$path/figures/FigureB11-B.gph", replace
graph export "$path/figures/FigureB11-B.png", replace

//------------------------------------------------------------------------------
// Panel C - Adjusted GDP per capita (1958=100)
//------------------------------------------------------------------------------

// Load Data
use "$path/results/jackknife-wdp/adj_mad23-norm-jackknife-results.dta", clear

// Plot
twoway ///
	(line adj_mad23_norm year, lcolor(midblue) lpattern(solid)) ///
	|| (line adj_mad23_synth_norm year, lcolor(cranberry) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out2 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out3 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out5 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out6 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out7 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_mad23_synth_norm_out8 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_mad23_synth_norm_out9 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out10 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out11 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_mad23_synth_norm_out12 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out13 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_mad23_synth_norm_out14 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out15 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out16 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm_out17 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_mad23_synth_norm year, lcolor(cranberry) lpattern(dash)) /// 
	|| (line adj_mad23_norm year, lcolor(midblue) lpattern(solid)), /// 
	xline($treat_graph) ///
    xlabel(1928(5)1989, labsize(small)) ///
	ylabel(0(50)300, labsize(small)) ///
    ytitle("Adjusted GDP per capita (1958=100)", size(small))  ///
	xtitle("Year", size(small)) ///
    ysize(6) xsize(7) ///
    legend(order(1 "Cuba" 2 "Main Synth. Cuba" 3 "Jackknifed SC") ///
           position(6) rows(1) size(small))
		   
graph save "$path/figures/FigureB11-C.gph", replace
graph export "$path/figures/FigureB11-C.png", replace
	
	
//------------------------------------------------------------------------------
// Panel D - P-Values - Adjusted GDP per capita (1958=100)
//------------------------------------------------------------------------------
		
// Load Data
use "$path/results/jackknife-wdp/adj_mad23-jackknife-pvals.dta", clear

// Plot
twoway ///
	(scatter adj_mad23_main_pval year, msymbol(O) mcolor(cranberry)) ///
    || (scatter pval_adj_mad23 year, msymbol(O) mcolor(midblue)) ///
	|| (rcap max_pval_adj_mad23 min_pval_adj_mad23 year, lcolor(midblue)) ///
	|| (scatter adj_mad23_main_pval year, msymbol(O) mcolor(cranberry)), ///
    ytitle("Probability that this would happen by chance", size(small)) ///
    xtitle("Year", size(small)) ///
    ylabel(0(.1)1, labsize(small)) ///
    xlabel(1959(1)1989, angle(90) labsize(small)) ///
	ysize(5) xsize(6)	///
    legend(order(1 "Main {it:p}-value" 2 "Avg. Jackknife {it:p}-value" 3 "Jackknife range") ///
           position(6) rows(1) size(small))
	

graph save "$path/figures/FigureB11-D.gph", replace
graph export "$path/figures/FigureB11-D.png", replace


//------------------------------------------------------------------------------
// Panel E - Adj. GDP per capita minus Soviet aid (1958=100)
//------------------------------------------------------------------------------

// Load Data
use "$path/results/jackknife-wdp/adj_transf23-norm-jackknife-results.dta", clear


// Plot
twoway ///
	(line adj_transf23_norm year, lcolor(midblue) lpattern(solid)) ///
	|| (line adj_transf23_synth_norm year, lcolor(cranberry) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out2 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out3 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out5 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out6 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out7 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_transf23_synth_norm_out8 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_transf23_synth_norm_out9 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out10 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out11 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_transf23_synth_norm_out12 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out13 year, lcolor(gray%40) lpattern(dash)) ///
	|| (line adj_transf23_synth_norm_out14 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out15 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out16 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm_out17 year, lcolor(gray%40) lpattern(dash)) ///
    || (line adj_transf23_synth_norm year, lcolor(cranberry) lpattern(dash)) /// 
	|| (line adj_transf23_norm year, lcolor(midblue) lpattern(solid)), /// 
	xline($treat_graph) ///
    xlabel(1928(5)1989, labsize(small)) ///
	ylabel(0(50)300, labsize(small)) ///
    ytitle("Adj. GDP per capita minus Soviet aid (1958=100)", size(small))  ///
	xtitle("Year", size(small)) ///
    ysize(6) xsize(7) ///
    legend(order(1 "Cuba" 2 "Main Synth. Cuba" 3 "Jackknifed SC") ///
           position(6) rows(1) size(small))
		   
graph save "$path/figures/FigureB11-E.gph", replace
graph export "$path/figures/FigureB11-E.png", replace
	
	
//------------------------------------------------------------------------------
// Panel F - P-Values - Adj. GDP per capita minus Soviet aid (1958=100)
//------------------------------------------------------------------------------
		
// Load Data
use "$path/results/jackknife-wdp/adj_transf23-jackknife-pvals.dta", clear

// Plot
twoway ///
	(scatter adj_transf23_main_pval year, msymbol(O) mcolor(cranberry)) ///
    || (scatter pval_adj_transf23 year, msymbol(O) mcolor(midblue)) ///
	|| (rcap max_pval_adj_transf23 min_pval_adj_transf23 year, lcolor(midblue)) ///
	|| (scatter adj_transf23_main_pval year, msymbol(O) mcolor(cranberry)), ///
    ytitle("Probability that this would happen by chance", size(small)) ///
    xtitle("Year", size(small)) ///
    ylabel(0(.1)1, labsize(small)) ///
    xlabel(1959(1)1989, angle(90) labsize(small)) ///
	ysize(5) xsize(6)	///
    legend(order(1 "Main {it:p}-value" 2 "Avg. Jackknife {it:p}-value" 3 "Jackknife range") ///
           position(6) rows(1) size(small))

graph save "$path/figures/FigureB11-F.gph", replace
graph export "$path/figures/FigureB11-F.png", replace


















