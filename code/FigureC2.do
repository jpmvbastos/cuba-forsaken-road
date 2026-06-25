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
*| Function: Generates SDID estimates and graphs for Figure C2
*|==============================================================================

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
ereturn clear
clear results
clear mata 
clear matrix 
clear ado

// Install packages if necessary
* ssc install synth
* ssc install synth_runner
* ssc install allsynth
* ssc install distinct // required by allsynth
* ssc install elasticregress // required by allsynth
* ssc install sdid
* ssc install sdid_event

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/data/master.dta", clear

tsset id year


// Create sample
keep if country == "Cuba" | former_ussr == 1 | communist == 1
drop if year<1980 | year>2017

//Some countries missing schooling data
drop if country == "Turkmenistan"
drop if country == "Albania"
drop if country == "Mongolia"

// Define treatment variable for Cuba; required for SDID
gen treatment = 0
replace treatment = 1 if year >=1991 & id == 8

//------------------------------------------------------------------------------
// Main Results: GDP
//------------------------------------------------------------------------------

// Define globals 
global treat_y = 1991

//Define predictor averages by hand.
bysort id: egen urban_av = mean(urban) if year < 1991
bysort id: egen urban_av_covariate = mean(urban_av)

bysort id: egen schooling_av = mean(schooling) if year < 1991
bysort id: egen schooling_av_covariate = mean(schooling_av)

local list gdppc23 adj_mad23 adj_transf23

foreach outcome of local list{
bysort id: egen `outcome'_80av = mean(`outcome') if year == 1980
bysort id: egen `outcome'_80av_covariate = mean(`outcome'_80av)
bysort id: egen `outcome'_84av = mean(`outcome') if year == 1984
bysort id: egen `outcome'_84av_covariate = mean(`outcome'_84av)
bysort id: egen `outcome'_87av = mean(`outcome') if year == 1987
bysort id: egen `outcome'_87av_covariate = mean(`outcome'_87av)
bysort id: egen `outcome'_89av = mean(`outcome') if year == 1989
bysort id: egen `outcome'_89av_covariate = mean(`outcome'_89av)
}

global predictors	 = "urban_av_covariate schooling_av_covariate"

// Undjusted Maddison GDP
//------------------------------------------------------------------------------

global pre_treatment = "gdppc23_80av_covariate gdppc23_84av_covariate  gdppc23_87av_covariate gdppc23_89av_covariate"

set seed 1234 
sdid gdppc23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Raw GDP per capita") ///
		legend(position(6) ring(1) region(lcolor(white))) ///
		xline(1990, lpattern(dash) lcolor(black)) ///
		graphregion(color(white) lcolor(white)) ///
		plotregion(color(white) lcolor(white)))
		
//Manual Edits of Graph to Make Consistent with Rest of Paper
gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit plotregion1.plot2.style.editstyle line(color(midblue)) editcopy
// plot2 color

gr_edit plotregion1.plot1.style.editstyle line(color(cranberry)) editcopy
// plot1 color

gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Synthetic Cuba
// label[1] edits

gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Cuba
// label[2] edits

gr_edit plotregion2.plot3.style.editstyle area(shadestyle(color(gs10))) editcopy
gr_edit plotregion2.plot3.style.editstyle area(linestyle(color(gs10))) editcopy
// plot3 color

gr_edit plotregion2._xylines[1].Delete
// line[1] (x) edits

gr_edit xaxis1.reset_rule 1980 2017 5 , tickset(major) ruletype(range) 
// xaxis1 edits

graph save g2_1991 "$path/figures/FigureC2-A", replace
graph export "$path/figures/FigureC2-A.png", as(png) replace

set seed 1234 
sdid_event gdppc23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 28 - _n if _n > 28 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 28 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), ///
		legend(off) title(sdid_event) xtitle(Relative time to treatment change) ///
		ytitle(Unadjusted GDP per capita (Effect)) yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -10 30 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title edits


graph save "$path/figures/FigureC2-B", replace
graph export "$path/figures/FigureC2-B.png", as(png) replace

//clear results
drop res1-res5 time
clear mata

// Adjusted Maddison
//------------------------------------------------------------------------------

global pre_treatment = "adj_mad23_80av_covariate adj_mad23_84av_covariate  adj_mad23_87av_covariate adj_mad23_89av_covariate"

set seed 1234 
sdid adj_mad23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Adjusted GDP per capita") ///
		legend(position(6) ring(1) region(lcolor(white))) ///
		xline(1991, lpattern(dash) lcolor(black)) ///
		graphregion(color(white) lcolor(white)) ///
		plotregion(color(white) lcolor(white)))

//Manual Edits of Graph to Make Consistent with Rest of Paper
gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit plotregion1.plot2.style.editstyle line(color(midblue)) editcopy
// plot2 color

gr_edit plotregion1.plot1.style.editstyle line(color(cranberry)) editcopy
// plot1 color

gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Synthetic Cuba
// label[1] edits

gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Cuba
// label[2] edits

gr_edit plotregion2.plot3.style.editstyle area(shadestyle(color(gs10))) editcopy
gr_edit plotregion2.plot3.style.editstyle area(linestyle(color(gs10))) editcopy
// plot3 color

gr_edit plotregion2._xylines[1].Delete
// line[1] (x) edits

gr_edit xaxis1.reset_rule 1980 2018 5 , tickset(major) ruletype(range) 
// xaxis1 edits

graph save g2_1991 "$path/figures/FigureC2-C", replace
graph export "$path/figures/FigureC2-C.png", as(png) replace

set seed 1234 
sdid_event adj_mad23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 28 - _n if _n > 28 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 28 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), ///
		legend(off) title(sdid_event) xtitle(Relative time to treatment change) ///
		ytitle(Adjusted GDP per capita (Effect)) yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -10 30 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title editstyle

graph save "$path/figures/FigureC2-D", replace
graph export "$path/figures/FigureC2-D.png", as(png) replace
			 
//clear results

drop res1-res5 time
clear mata

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

global pre_treatment = "adj_transf23_80av_covariate adj_transf23_84av_covariate  adj_transf23_87av_covariate adj_transf23_89av_covariate"

set seed 1234 
sdid adj_transf23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Adjusted GDP less Soviet Aid") ///
		legend(position(6) ring(1) region(lcolor(white))) ///
		xline(1991, lpattern(dash) lcolor(black)) ///
		graphregion(color(white) lcolor(white)) ///
		plotregion(color(white) lcolor(white)))

//Manual Edits of Graph to Make Consistent with Rest of Paper
gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit plotregion1.plot2.style.editstyle line(color(midblue)) editcopy
// plot2 color

gr_edit plotregion1.plot1.style.editstyle line(color(cranberry)) editcopy
// plot1 color

gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Synthetic Cuba
// label[1] edits

gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Cuba
// label[2] edits

gr_edit plotregion2.plot3.style.editstyle area(shadestyle(color(gs10))) editcopy
gr_edit plotregion2.plot3.style.editstyle area(linestyle(color(gs10))) editcopy
// plot3 color

gr_edit plotregion2._xylines[1].Delete
// line[1] (x) edits

gr_edit xaxis1.reset_rule 1980 2018 5 , tickset(major) ruletype(range) 
// xaxis1 edits

graph save g2_1991 "$path/figures/FigureC2-E", replace
graph export "$path/figures/FigureC2-E.png", as(png) replace

set seed 1234 
sdid_event adj_transf23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 28 - _n if _n > 28 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 28 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), ///
		legend(off) title(sdid_event) xtitle(Relative time to treatment change) ///
		ytitle(Adjusted GDP less Soviet Aid (Effect)) yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -10 30 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title editstyle

graph save "$path/figures/FigureC2-F", replace
graph export "$path/figures/FigureC2-F.png", as(png) replace
			 
//clear results

drop res1-res5 time
clear mata

