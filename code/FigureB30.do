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
*| Function: Regression Control Method; Replications Figure B30
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

// Adjust path if running this file by itself
* global path ""

// Load Data
use "$path/data/master.dta", clear

tsset id year

// Create sample
keep if latam==1
drop if year<1928 | year>1989
drop if country_moxlad==""

// Define treatment variable for Cuba. 
gen treatment = 0
replace treatment = 1 if year >=1959 & id == 8

// Define ever treatment variable for CubaPart2/JDE_Code
gen treat = 0 
replace treat = 1 if id == 8

// Define separate post-treatment parameters.
foreach num of numlist 59/89{
gen treat`num' = 0
replace treat`num' = 1 if year == 19`num' & treatment == 1
}

// Define separate pre-treatment parameters.
foreach num of numlist 28/58{
gen placebo`num' = 0
replace placebo`num' = 1 if year == 19`num' & id == 8
}

save "$path/data/main-sample.dta", replace

//------------------------------------------------------------------------------
// Set up
//------------------------------------------------------------------------------

// Define globals 
local list gdppc23 adj_mad23 adj_transf23


// Main Results: GDP
//------------------------------------------------------------------------------

rcm gdppc23 ,trunit(8) trperiod(1959) placebo(unit cutoff(1))

graph close eff eff_pboUnit ratio_pboUnit pvalTwo_pboUnit pvalRight_pboUnit pvalLeft_pboUnit

// Manual Graph Edits to Make Graphs Consistent with Scheme in Paper

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
// pred color

gr_edit title.draw_view.setstyle, style(no)
// title edits

gr_edit plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
// line[1] (x) pattern

gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit xaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit xaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// xaxis1 edits

gr_edit yaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// yaxis1 pattern

gr_edit legend.style.editstyle boxstyle(linestyle(color(white))) editcopy
// legend color

gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Cuba
// label[1] edits

gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Counterfactual Cuba
// label[2] edits

gr_edit yaxis1.title.text = {}
gr_edit yaxis1.title.text.Arrpush Raw GDP per capita
// title edits

gr_edit plotregion1.plot1.style.editstyle line(color(midblue)) editcopy
// plot1 color

gr_edit plotregion1.plot2.style.editstyle line(color(cranberry)) editcopy
// plot2 color

graph save pred "$path/figures/FigureB30-A", replace
graph export "$path/figures/FigureB30-A.png", as(png) replace
graph close pred

qui rcm gdppc23 ,trunit(8) trperiod(1959) placebo(unit cutoff(1))

graph close pred eff eff_pboUnit ratio_pboUnit pvalTwo_pboUnit pvalRight_pboUnit 

// Manual Graph Edits to Make Graphs Consistent with Scheme in Paper

gr_edit title.draw_view.setstyle, style(no)
// title edits

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
// pvalLeft_pboUnit color

gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit plotregion1._xylines[1].draw_view.setstyle, style(no)
// line[1] (y) edits

gr_edit plotregion1._xylines[2].draw_view.setstyle, style(no)
// line[2] (y) edits

gr_edit xaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit xaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// xaxis1 edits

gr_edit yaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// yaxis1 pattern

gr_edit yaxis1.title.text = {}
gr_edit yaxis1.title.text.Arrpush Probability that this would happen by chance
// title edits

gr_edit plotregion1.plot1.style.editstyle marker(fillcolor(stblue)) editcopy
gr_edit plotregion1.plot1.style.editstyle marker(linestyle(color(stblue))) editcopy
// plot1 edits

gr_edit plotregion1.plot1.style.editstyle line(color(none)) editcopy
// plot1 color

graph save pvalLeft_pboUnit "$path/figures/FigureB30-B" ,replace
graph export "$path/figures/FigureB30-B.png", as(png) replace
graph close pvalLeft_pboUnit


// Adjusted Maddison
//------------------------------------------------------------------------------

rcm adj_mad23 ,trunit(8) trperiod(1959) placebo(unit cutoff(1))
graph close eff eff_pboUnit ratio_pboUnit pvalTwo_pboUnit pvalRight_pboUnit pvalLeft_pboUnit

// Manual Graph Edits to Make Graphs Consistent with Scheme in Paper

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
// pred color

gr_edit title.draw_view.setstyle, style(no)
// title edits

gr_edit plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
// line[1] (x) pattern

gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit xaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit xaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// xaxis1 edits

gr_edit yaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// yaxis1 pattern

gr_edit legend.style.editstyle boxstyle(linestyle(color(white))) editcopy
// legend color

gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Cuba
// label[1] edits

gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Counterfactual Cuba
// label[2] edits

gr_edit yaxis1.title.text = {}
gr_edit yaxis1.title.text.Arrpush Adjusted GDP per capita
// title edits

gr_edit plotregion1.plot1.style.editstyle line(color(midblue)) editcopy
// plot1 color

gr_edit plotregion1.plot2.style.editstyle line(color(cranberry)) editcopy
// plot2 color

graph save pred "$path/figures/FigureB30-C", replace
graph export "$path/figures/FigureB30-C.png", as(png) replace
graph close pred

qui rcm adj_mad23 ,trunit(8) trperiod(1959) placebo(unit cutoff(1))

graph close pred eff eff_pboUnit ratio_pboUnit pvalTwo_pboUnit pvalRight_pboUnit 

// Manual Graph Edits to Make Graphs Consistent with Scheme in Paper

gr_edit title.draw_view.setstyle, style(no)
// title edits

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
// pvalLeft_pboUnit color

gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit plotregion1._xylines[1].draw_view.setstyle, style(no)
// line[1] (y) edits

gr_edit plotregion1._xylines[2].draw_view.setstyle, style(no)
// line[2] (y) edits

gr_edit xaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit xaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// xaxis1 edits

gr_edit yaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// yaxis1 pattern

gr_edit yaxis1.title.text = {}
gr_edit yaxis1.title.text.Arrpush Probability that this would happen by chance
// title edits

gr_edit plotregion1.plot1.style.editstyle marker(fillcolor(stblue)) editcopy
gr_edit plotregion1.plot1.style.editstyle marker(linestyle(color(stblue))) editcopy
// plot1 edits

gr_edit plotregion1.plot1.style.editstyle line(color(none)) editcopy
// plot1 color

graph save pvalLeft_pboUnit "$path/figures/FigureB30-D" ,replace
graph export "$path/figures/FigureB30-D.png", as(png) replace
graph close pvalLeft_pboUnit

// Adjusted Maddison Minus Transfers
//------------------------------------------------------------------------------

rcm adj_transf23 ,trunit(8) trperiod(1959) placebo(unit cutoff(1))
graph close eff eff_pboUnit ratio_pboUnit pvalTwo_pboUnit pvalRight_pboUnit pvalLeft_pboUnit

// Manual Graph Edits to Make Graphs Consistent with Scheme in Paper

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
// pred color

gr_edit title.draw_view.setstyle, style(no)
// title edits

gr_edit plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
// line[1] (x) pattern

gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit xaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit xaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// xaxis1 edits

gr_edit yaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// yaxis1 pattern

gr_edit legend.style.editstyle boxstyle(linestyle(color(white))) editcopy
// legend color

gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Cuba
// label[1] edits

gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Counterfactual Cuba
// label[2] edits

gr_edit yaxis1.title.text = {}
gr_edit yaxis1.title.text.Arrpush Adjusted GDP per capita less Soviet Transfers
// title edits

gr_edit plotregion1.plot1.style.editstyle line(color(midblue)) editcopy
// plot1 color

gr_edit plotregion1.plot2.style.editstyle line(color(cranberry)) editcopy
// plot2 color

graph save pred "$path/figures/FigureB30-E", replace
graph export "$path/figures/FigureB30-E.png", as(png) replace
graph close pred

qui rcm adj_transf23 ,trunit(8) trperiod(1959) placebo(unit cutoff(1))

graph close pred eff eff_pboUnit ratio_pboUnit pvalTwo_pboUnit pvalRight_pboUnit 

// Manual Graph Edits to Make Graphs Consistent with Scheme in Paper

gr_edit title.draw_view.setstyle, style(no)
// title edits

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
// pvalLeft_pboUnit color

gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Year
// title edits

gr_edit plotregion1._xylines[1].draw_view.setstyle, style(no)
// line[1] (y) edits

gr_edit plotregion1._xylines[2].draw_view.setstyle, style(no)
// line[2] (y) edits

gr_edit xaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit xaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// xaxis1 edits

gr_edit yaxis1.style.editstyle majorstyle(gridstyle(linestyle(pattern(dash)))) editcopy
// yaxis1 pattern

gr_edit yaxis1.title.text = {}
gr_edit yaxis1.title.text.Arrpush Probability that this would happen by chance
// title edits

gr_edit plotregion1.plot1.style.editstyle marker(fillcolor(stblue)) editcopy
gr_edit plotregion1.plot1.style.editstyle marker(linestyle(color(stblue))) editcopy
// plot1 edits

gr_edit plotregion1.plot1.style.editstyle line(color(none)) editcopy
// plot1 color

graph save pvalLeft_pboUnit "$path/figures/FigureB30-F" ,replace
graph export "$path/figures/FigureB30-F.png", as(png) replace
graph close pvalLeft_pboUnit

