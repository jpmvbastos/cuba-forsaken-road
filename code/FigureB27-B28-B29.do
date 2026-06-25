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
*| Function: Traditional DID and Entropy Balanced DID; Produces Figures B27, B28, B29
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
drop if year<1938 | year>1972
drop if country_moxlad==""

// Define treatment variable for Cuba. 
gen treatment = 0
replace treatment = 1 if year >=1959 & id == 8

// Define ever treatment variable for CubaPart2/JDE_Code
gen treat = 0 
replace treat = 1 if id == 8

// Define separate post-treatment parameters.
foreach num of numlist 59/72{
gen treat`num' = 0
replace treat`num' = 1 if year == 19`num' & id == 8
}

// Define separate pre-treatment parameters.
foreach num of numlist 38/58{
gen placebo`num' = 0
replace placebo`num' = 1 if year == 19`num' & id == 8
}

//------------------------------------------------------------------------------
// Organize and Name Variables
//------------------------------------------------------------------------------

// Define globals 
local list us_trade us_imports


// Total Trade with US
//------------------------------------------------------------------------------
cap drop _webal ebal

// No overlap in some years for trade. We use full pre-treatment average.
bysort id: egen us_trade_c = mean(us_trade) if year <= 1957

ebalance treat us_trade_c if year==1957

egen ebal = mean(_webal), by(id)

regress us_trade placebo38-placebo57 treat59-treat72 i.year i.id, cluster(country)
estimates store ustrade

regress us_trade placebo38-placebo57 treat59-treat72 i.year i.id [aw=ebal], cluster(country)
estimates store ustrade_w

// Exports to US
//------------------------------------------------------------------------------
cap drop _webal ebal

// No overlap in some years for trade. We use full pre-treatment average.
bysort id: egen us_imports_c = mean(us_imports) if year <= 1957

ebalance treat us_imports_c if year==1957

egen ebal = mean(_webal), by(id)

regress us_imports placebo38-placebo57 treat59-treat72 i.year i.id, cluster(country)
estimates store usimports

regress us_imports placebo38-placebo57 treat59-treat72 i.year i.id [aw=ebal], cluster(country)
estimates store usimports_w

// Graphing First Two

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

coefplot 	(ustrade, keep(placebo* treat*) drop(_cons) mcolor(dkorange) ciopts(lcolor(dkorange))) ///
			(usimports, keep(placebo* treat*) drop(_cons) mcolor(forest_green) ciopts(lcolor(forest_green))) ///
			,vertical ///
			legend(order(1 "US Trade" 3 "Exports to US") region(lcolor(white)) rows(1) position(6)) ///
			ytitle("Trade (Effect)") ///
			xtitle("Year") ///
			xlabel(`xlab', angle(90)) ///
			xline(20, lpattern(dash) lcolor(black)) ///
			yline(0, lpattern(dash) lcolor(black)) ///
			graphregion(color(white) lcolor(white)) ///
			plotregion(color(white)) 
			
graph save  "$path/figures/FigureB27.gph", replace

graph export "$path/figures/FigureB27.png", as(png) replace
			
			
coefplot 	(ustrade_w, keep(placebo* treat*) drop(_cons) mcolor(dkorange) ciopts(lcolor(dkorange))) ///
			(usimports_w, keep(placebo* treat*) drop(_cons) mcolor(forest_green) ciopts(lcolor(forest_green))) ///
			,vertical ///
			legend(order(1 "US Trade" 3 "Exports to US") region(lcolor(white))rows(1) position(6)) ///
			ytitle("Trade (Effect)") ///
			xtitle("Year") ///
			xlabel(`xlab', angle(90)) ///
			xline(20, lpattern(dash) lcolor(black)) ///
			yline(0, lpattern(dash) lcolor(black)) ///
			graphregion(color(white) lcolor(white)) ///
			plotregion(color(white))
			
graph save  "$path/figures/FigureB28.gph", replace
graph export "$path/figures/FigureB28.png", as(png) replace



// Total Trade with the World
//------------------------------------------------------------------------------
cap drop _webal ebal
clear

// Load Data
use "$path/data/master.dta", clear

tsset id year

save "$path/data/master.dta", replace

// Create sample
keep if latam==1
drop if year<1920 | year>1979
drop if country_moxlad==""

// There's no import deflator for Bolivia
drop if country=="Bolivia"

// Ecuador data beggining in 1927 and it never enters the synthetic,
// so we chose to drop to expand the matching period for ~ 10 years
drop if country_moxlad == "Ecuador"

// Define treatment variable for Cuba. 
gen treatment = 0
replace treatment = 1 if year >=1959 & id == 8

// Define ever treatment variable for CubaPart2/JDE_Code
gen treat = 0 
replace treat = 1 if id == 8

// Define separate post-treatment parameters.
foreach num of numlist 59/79{
gen treat`num' = 0
replace treat`num' = 1 if year == 19`num' & id == 8
}

// Define separate pre-treatment parameters.
foreach num of numlist 20/58{
gen placebo`num' = 0
replace placebo`num' = 1 if year == 19`num' & id == 8
}

// No overlap in some years for trade. We use full pre-treatment average.
bysort id: egen trade_c = mean(trade) if year <= 1957
bysort id: egen gdppc23_c = mean(gdppc23) if year <= 1957

ebalance treat trade_c trade_c gdppc23_c if year==1957

egen ebal = mean(_webal), by(id)

regress trade placebo20-placebo57 treat59-treat79 i.year i.id, cluster(country)
estimates store trade

regress trade placebo20-placebo57 treat59-treat79 i.year i.id [aw=ebal], cluster(country)
estimates store trade_w

// Graphing The Last

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

coefplot 	(trade, keep(placebo* treat*) drop(_cons) mcolor(dkorange) ciopts(lcolor(dkorange))) ///
			(trade_w, keep(placebo* treat*) drop(_cons) mcolor(forest_green) ciopts(lcolor(forest_green))) ///
			,vertical ///
			legend(order(1 "World Trade" 3 "World Trade - Entropy Balanced") region(lcolor(white)) rows(1) position(6)) ///
			ytitle("Trade (Effect)") ///
			xtitle("Year") ///
			xlabel(`xlab', angle(90)) ///
			xline(38, lpattern(dash) lcolor(black)) ///
			yline(0, lpattern(dash) lcolor(black)) ///
			graphregion(color(white) lcolor(white)) ///
			plotregion(color(white)) 
			
graph save  "$path/figures/FigureB29.gph", replace

graph export "$path/figures/FigureB29.png", as(png) replace
			