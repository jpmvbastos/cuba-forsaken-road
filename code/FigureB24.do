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
*| Function: Generates SDID estimates for embargo effect; Produces Figure B24
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
* global path ""

// Load Data
use "$path/data/master.dta", clear

tsset id year

// Create sample
keep if latam==1
drop if year<1938 | year>1972
drop if country_moxlad==""

// Define treatment variable for Cuba; required for SDID
gen treatment = 0
replace treatment = 1 if year >=1959 & id == 8

save "$path/data/main-sample.dta", replace

//------------------------------------------------------------------------------
// Organizing Covariates
//------------------------------------------------------------------------------

// Define globals 
global treat_y = 1959

//Define predictor averages by hand.
bysort id: egen urban_av = mean(urban) if year < 1959
bysort id: egen urban_av_covariate = mean(urban_av)

bysort id: egen schooling_av = mean(schooling) if year < 1959
bysort id: egen schooling_av_covariate = mean(schooling_av)

bysort id: egen gdppc23_av = mean(gdppc23) if year < 1959
bysort id: egen gdppc23_av_covariate = mean(gdppc23_av)

local list us_trade us_imports

foreach outcome of local list{
bysort id: egen `outcome'_38av = mean(`outcome') if year == 1938
bysort id: egen `outcome'_38av_covariate = mean(`outcome'_38av)
bysort id: egen `outcome'_41av = mean(`outcome') if year == 1941
bysort id: egen `outcome'_41av_covariate = mean(`outcome'_41av)
bysort id: egen `outcome'_44av = mean(`outcome') if year == 1944
bysort id: egen `outcome'_44av_covariate = mean(`outcome'_44av)
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
bysort id: egen `outcome'_58av = mean(`outcome') if year == 1958
bysort id: egen `outcome'_58av_covariate = mean(`outcome'_58av)
}

global predictors	 = "gdppc23_av_covariate urban_av_covariate schooling_av_covariate"

// Total Trade
//------------------------------------------------------------------------------

global pre_treatment = " us_trade_38av_covariate us_trade_41av_covariate us_trade_44av_covariate us_trade_47av_covariate us_trade_50av_covariate us_trade_53av_covariate us_trade_56av_covariate us_trade_57av_covariate us_trade_58av_covariate"

set seed 1234 
sdid us_trade id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Total Trade with the US") ///
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

graph save g2_1959 "$path/figures/FigureB24-A", replace
graph export "$path/figures/FigureB24-A.png", as(png) replace

set seed 1234 
sdid_event us_trade id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 15 - _n if _n > 15 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 16 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), legend(off) ///
		title(sdid_event) xtitle(Relative time to treatment change) ytitle(Total Trade with US (Effect)) ///
		yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -20 14 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title edits


graph save "$path/figures/FigureB24-B", replace
graph export "$path/figures/FigureB24-B.png", as(png) replace

//clear results
drop res1-res5 time
clear mata

// Exports to the U.S. 
//------------------------------------------------------------------------------

global pre_treatment = " us_imports_38av_covariate us_imports_41av_covariate us_imports_44av_covariate us_imports_47av_covariate us_imports_50av_covariate us_imports_53av_covariate us_imports_56av_covariate us_imports_57av_covariate us_imports_58av_covariate"

set seed 1234 
sdid us_imports id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Total Exports to the US") ///
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

graph save g2_1959 "$path/figures/FigureB24-C", replace
graph export "$path/figures/FigureB24-C.png", as(png) replace

set seed 1234 
sdid_event us_imports id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 15 - _n if _n > 15 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 16 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), ///
		legend(off) title(sdid_event) xtitle(Relative time to treatment change) ///
		ytitle(Total Exports to US (Effect)) yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -20 15 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title editstyle

graph save "$path/figures/FigureB24-D", replace
graph export "$path/figures/FigureB24-D.png", as(png) replace
			 
//clear results

drop res1-res5 time
clear mata
clear all

// Total Trade with World
//------------------------------------------------------------------------------

use "$path/data/master.dta", clear

drop if year<1920 | year>1979

tsset id year

drop if country_moxlad==""

// There's no import deflator for Bolivia
drop if country=="Bolivia"

// Ecuador data beggining in 1927 and it never enters the synthetic,
// so we chose to drop to expand the matching period for ~ 10 years
drop if country_moxlad == "Ecuador"

// Define treatment variable for Cuba; required for SDID
gen treatment = 0
replace treatment = 1 if year >=1959 & id == 8

// Define globals 
global treat_y = 1959

//Define predictor averages by hand.
bysort id: egen urban_av = mean(urban) if year < 1959
bysort id: egen urban_av_covariate = mean(urban_av)

bysort id: egen schooling_av = mean(schooling) if year < 1959
bysort id: egen schooling_av_covariate = mean(schooling_av)

bysort id: egen gdppc23_av = mean(gdppc23) if year < 1959
bysort id: egen gdppc23_av_covariate = mean(gdppc23_av)

local list trade

foreach outcome of local list{
bysort id: egen `outcome'_29av = mean(`outcome') if year == 1929
bysort id: egen `outcome'_29av_covariate = mean(`outcome'_29av)
bysort id: egen `outcome'_32av = mean(`outcome') if year == 1932
bysort id: egen `outcome'_32av_covariate = mean(`outcome'_32av)
bysort id: egen `outcome'_35av = mean(`outcome') if year == 1935
bysort id: egen `outcome'_35av_covariate = mean(`outcome'_35av)
bysort id: egen `outcome'_38av = mean(`outcome') if year == 1938
bysort id: egen `outcome'_38av_covariate = mean(`outcome'_38av)
bysort id: egen `outcome'_41av = mean(`outcome') if year == 1941
bysort id: egen `outcome'_41av_covariate = mean(`outcome'_41av)
bysort id: egen `outcome'_44av = mean(`outcome') if year == 1944
bysort id: egen `outcome'_44av_covariate = mean(`outcome'_44av)
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
bysort id: egen `outcome'_58av = mean(`outcome') if year == 1958
bysort id: egen `outcome'_58av_covariate = mean(`outcome'_58av)
}

global pre_treatment = "trade_29av_covariate trade_32av_covariate trade_35av_covariate trade_38av_covariate trade_41av_covariate trade_44av_covariate trade_47av_covariate trade_50av_covariate trade_53av_covariate trade_56av_covariate trade_57av_covariate trade_58av_covariate"

set seed 1234 
sdid trade id year treatment, covariates( $predictors $pre_treatment) vce(placebo) reps(100) ///
		method(sdid) graph g2_opt(ytitle("Total Trade with the World") ///
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

graph save g2_1959 "$path/figures/FigureB24-E", replace
graph export "$path/figures/FigureB24-E.png", as(png) replace

set seed 1234 
sdid_event trade id year treatment, covariates( $predictors $pre_treatment) vce(placebo) brep(100) placebo(all) method(sdid) 

  mat res = e(H)
        svmat res
        gen time = _n - 1 if !missing(res1)
        replace time = 21 - _n if _n > 21 & !missing(res1)
		replace time = . if time == 0  //This is the ATT for the whole period
		replace time = time - 1 if _n < 22 & !missing(res1)
        sort time
        twoway (rarea res3 res4 time, lc(gs10) fc(gs11%50)) (scatter res1 time, mc(midblue) ms(d)), ///
		legend(off) title(sdid_event) xtitle(Relative time to treatment change) ///
		ytitle(Total Trade with the World (Effect)) yline(0, lc(cranberry) lp(-)) /// 
		xline(0, lc(black) lp(solid)) ///
		graphregion(color(white) lcolor(none) ) ///
		plotregion(color(white) lcolor(none) )

//Manual Edits of Graph to Make Consistent with Rest of Paper

gr_edit xaxis1.reset_rule -40 20 5 , tickset(major) ruletype(range) 
// xaxis1 edits

gr_edit title.draw_view.setstyle, style(no)
// title editstyle

graph save "$path/figures/FigureB24-F", replace
graph export "$path/figures/FigureB24-F.png", as(png) replace
			 
//clear results

drop res1-res5 time
clear mata

