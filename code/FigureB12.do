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
*| Function: Generates SDID estimates and Produces Figure B12
*|==============================================================================

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
ereturn clear
clear results
clear mata 
clear matrix 
clear ado

graph set window fontface "Times New Roman"

// Install packages if necessary
* ssc install synth
* ssc install synth_runner
* ssc install allsynth
* ssc install distinct // required by allsynth
* ssc install elasticregress // required by allsynth
* ssc install sdid
* ssc install sdid_event

// Adjust path if running this file by itself
global path ""

// Load Data
use "$path/data/western_dp.dta", clear

// Create sample
drop if year<1928 | year>1989

save "$path/data/wdp-sample.dta", replace

//------------------------------------------------------------------------------
// Main Results: GDP
//------------------------------------------------------------------------------

// Define treatment variable for Cuba; required for SDID
gen treatment = 0
replace treatment = 1 if year >=1959 & c == 4
rename c id

// Define globals 
global treat_y = 1959

//Define predictor averages by hand.
bysort id: egen urban_av = mean(urban) if year < 1959
bysort id: egen urban_av_covariate = mean(urban_av)

bysort id: egen schooling_av = mean(schooling) if year < 1959
bysort id: egen schooling_av_covariate = mean(schooling_av)

local list gdppc23 adj_mad23 adj_transf23

foreach outcome of local list{
bysort id: egen `outcome'_35av = mean(`outcome') if year == 1935
bysort id: egen `outcome'_35av_covariate = mean(`outcome'_35av)
bysort id: egen `outcome'_40av = mean(`outcome') if year == 1940
bysort id: egen `outcome'_40av_covariate = mean(`outcome'_40av)
bysort id: egen `outcome'_47av = mean(`outcome') if year == 1947
bysort id: egen `outcome'_47av_covariate = mean(`outcome'_47av)
bysort id: egen `outcome'_50av = mean(`outcome') if year == 1950
bysort id: egen `outcome'_50av_covariate = mean(`outcome'_50av)
bysort id: egen `outcome'_53av = mean(`outcome') if year == 1953
bysort id: egen `outcome'_53av_covariate = mean(`outcome'_53av)
bysort id: egen `outcome'_56av = mean(`outcome') if year == 1956
bysort id: egen `outcome'_56av_covariate = mean(`outcome'_56av)
bysort id: egen `outcome'_57av = mean(`outcome') if year == 1957
bysort id: egen `outcome'_57av_covariate = mean(`outcome'_57av)
}

global predictors	 = "urban_av_covariate schooling_av_covariate"

// Undjusted Maddison GDP
//------------------------------------------------------------------------------

global pre_treatment = "gdppc23_35av_covariate gdppc23_40av_covariate  gdppc23_47av_covariate gdppc23_50av_covariate gdppc23_53av_covariate gdppc23_56av_covariate gdppc23_57av_covariate"

set seed 1234 
sdid gdppc23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Raw GDP per capita") ///
		legend(position(6) ring(1) region(lcolor(white))) ///
		xline(1958, lpattern(dash) lcolor(black)) ///
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

gr_edit xaxis1.reset_rule 1928 1989 5 , tickset(major) ruletype(range) 
// xaxis1 edits

graph save g2_1959 "$path/figures/FigureB12-A", replace
graph export "$path/figures/FigureB12-A.png", as(png) replace

set seed 1234 
sdid_event gdppc23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 32 - _n if _n > 32 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 33 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), ///
		legend(off) title(sdid_event) xtitle(Relative time to treatment change) ///
		ytitle(Unadjusted GDP per capita (Effect)) yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -30 30 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title edits


graph save "$path/figures/FigureB12-B", replace
graph export "$path/figures/FigureB12-B.png", as(png) replace

//clear results
drop res1-res5 time
clear mata

// Adjusted Maddison
//------------------------------------------------------------------------------

global pre_treatment = "adj_mad23_35av_covariate adj_mad23_40av_covariate  adj_mad23_47av_covariate adj_mad23_50av_covariate adj_mad23_53av_covariate adj_mad23_56av_covariate adj_mad23_57av_covariate"

set seed 1234 
sdid adj_mad23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Adjusted GDP per capita") ///
		legend(position(6) ring(1) region(lcolor(white))) ///
		xline(1958, lpattern(dash) lcolor(black)) ///
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

gr_edit xaxis1.reset_rule 1928 1989 5 , tickset(major) ruletype(range) 
// xaxis1 edits

graph save g2_1959 "$path/figures/FigureB12-C", replace
graph export "$path/figures/FigureB12-C.png", as(png) replace

set seed 1234 
sdid_event adj_mad23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 32 - _n if _n > 32 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 33 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), ///
		legend(off) title(sdid_event) xtitle(Relative time to treatment change) ///
		ytitle(Adjusted GDP per capita (Effect)) yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -30 30 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title editstyle

graph save "$path/figures/FigureB12-D", replace
graph export "$path/figures/FigureB12-D.png", as(png) replace
			 
//clear results

drop res1-res5 time
clear mata

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

global pre_treatment = "adj_transf23_35av_covariate adj_transf23_40av_covariate  adj_transf23_47av_covariate adj_transf23_50av_covariate adj_transf23_53av_covariate adj_transf23_56av_covariate adj_transf23_57av_covariate"

set seed 1234 
sdid adj_transf23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Adjusted GDP less Soviet Aid") ///
		legend(position(6) ring(1) region(lcolor(white))) ///
		xline(1958, lpattern(dash) lcolor(black)) ///
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

gr_edit xaxis1.reset_rule 1928 1989 5 , tickset(major) ruletype(range) 
// xaxis1 edits

graph save g2_1959 "$path/figures/FigureB12-E", replace
graph export "$path/figures/FigureB12-E.png", as(png) replace

set seed 1234 
sdid_event adj_transf23 id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 32 - _n if _n > 32 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 33 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), ///
		legend(off) title(sdid_event) xtitle(Relative time to treatment change) ///
		ytitle(Adjusted GDP less Soviet Aid (Effect)) yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -30 30 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title editstyle

graph save "$path/figures/FigureB12-F", replace
graph export "$path/figures/FigureB12-F.png", as(png) replace
			 
//clear results

drop res1-res5 time
clear mata
