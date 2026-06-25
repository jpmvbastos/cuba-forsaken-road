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
*| Function: Traditional DID and Entropy Balanced DID; Produces Figures B25 and B26
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
// Main Results: GDP
//------------------------------------------------------------------------------

// Define globals 
local list gdppc23 adj_mad23 adj_transf23


// Total Trade with US
//------------------------------------------------------------------------------
cap drop _webal ebal

// Convergence in entropy balancing is not achieved with more than two lagged outcomes. We use first and last.
local numlist 1935 1957 
foreach num of local numlist  {
gen gdppc23_`num' = gdppc23 if year == `num'
bysort id: egen gdppc23_`num'_c = mean(gdppc23_`num')
	}

ebalance treat gdppc23_1935_c gdppc23_1957_c if year==1957

egen ebal = mean(_webal), by(id)

regress gdppc23 placebo28-placebo57 treat59-treat89 i.year i.id, cluster(country)
estimates store unadjusted

regress gdppc23 placebo28-placebo57 treat59-treat89 i.year i.id [aw=ebal], cluster(country)
estimates store unadjusted_w

// Exports to US
//------------------------------------------------------------------------------
cap drop _webal ebal

// Convergence in entropy balancing is not achieved with more than two lagged outcomes. We use first and last.
local numlist 1935 1957 
foreach num of local numlist  {
gen adj_mad23_`num' = adj_mad23 if year == `num'
bysort id: egen adj_mad23_`num'_c = mean(adj_mad23_`num')
	}

ebalance treat adj_mad23_1935_c adj_mad23_1957_c if year==1957

egen ebal = mean(_webal), by(id)

regress adj_mad23 placebo28-placebo57 treat59-treat89 i.year i.id, cluster(country)
estimates store adjusted

regress adj_mad23 placebo28-placebo57 treat59-treat89 i.year i.id [aw=ebal], cluster(country)
estimates store adjusted_w

// Total Trade with the World
//------------------------------------------------------------------------------
cap drop _webal ebal

// Convergence in entropy balancing is not achieved with more than two lagged outcomes. We use first and last.
local numlist 1935 1957 
foreach num of local numlist  {
gen adj_transf23_`num' = adj_transf23 if year == `num'
bysort id: egen adj_transf23_`num'_c = mean(adj_transf23_`num')
	}

ebalance treat adj_transf23_1935_c adj_transf23_1957_c if year==1957

egen ebal = mean(_webal), by(id)

regress adj_transf23 placebo28-placebo57 treat59-treat89 i.year i.id, cluster(country)
estimates store adjusted_transfers

regress adj_transf23 placebo28-placebo57 treat59-treat89 i.year i.id [aw=ebal], cluster(country)
estimates store adjusted_transfers_w

// Graphing 
local labs
foreach c of varlist placebo* treat* {
    local year = substr("`c'", -2, 2)
    local labs `labs' `c' = "`year'"
}

matrix b = e(b)
local all : colnames b

// Collect only the placebo/treat coefs, in order
local sel
foreach c of local all {
    if regexm("`c'","^(placebo|treat)") {
        local sel `sel' `c'
    }
}

// Build x-axis labels: position -> year, but only every 10th
local pos 0
local xlab
foreach c of local sel {
    local ++pos
    local year = substr("`c'", -2, 2)

    if mod(`pos' - 1, 10) == 0 {
        local xlab `xlab' `pos' "`year'"
    }
}

coefplot 	(unadjusted, keep(placebo* treat*) drop(_cons) mcolor(dkorange) ciopts(lcolor(dkorange))) ///
			(adjusted, keep(placebo* treat*) drop(_cons) mcolor(forest_green) ciopts(lcolor(forest_green))) ///
			(adjusted_transfers, keep(placebo* treat*) drop(_cons) mcolor(midblue) ciopts(lcolor(midblue))) ///
			,vertical ///
			legend(order(1 "Unadjusted GDP" 3 "Adjusted GDP" 5 "Adj. GDP - Soviet Aid") region(lcolor(white)) rows(1) position(6)) ///
			ytitle("GDP per capita") ///
			xtitle("Year") ///
			xlabel(`xlab', angle(90)) ///
			xline(30, lpattern(dash) lcolor(black)) ///
			yline(0, lpattern(dash) lcolor(black)) ///
			graphregion(color(white) lcolor(white)) ///
			plotregion(color(white)) 
			
graph save  "$path/figures/FigureB25.gph", replace

graph export "$path/figures/FigureB25.png", as(png) replace
			
			
coefplot 	(unadjusted_w, keep(placebo* treat*) drop(_cons) mcolor(dkorange) ciopts(lcolor(dkorange))) ///
			(adjusted_w, keep(placebo* treat*) drop(_cons) mcolor(forest_green) ciopts(lcolor(forest_green))) ///
			(adjusted_transfers_w, keep(placebo* treat*) drop(_cons) mcolor(midblue) ciopts(lcolor(midblue))) ///
			,vertical ///
			legend(order(1 "Unadjusted GDP" 3 "Adjusted GDP" 5 "Adj. GDP - Soviet Aid") region(lcolor(white)) rows(1) position(6)) ///
			ytitle("GDP per capita") ///
			xtitle("Year") ///
			xlabel(`xlab', angle(90)) ///
			xline(30, lpattern(dash) lcolor(black)) ///
			yline(0, lpattern(dash) lcolor(black)) ///
			graphregion(color(white) lcolor(white)) ///
			plotregion(color(white))
			
graph save  "$path/figures/FigureB26.gph", replace
graph export "$path/figures/FigureB26.png", as(png) replace

