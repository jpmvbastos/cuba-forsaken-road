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
*| Function: Merges Soviet Aid Simulation GDP columns into gdp-results.dta
*| - Imports 4 adjusted GDP series from Soviet Aid Simulations.xlsx
*| - Merges into the main SCM results panel (Cuba rows only)
*| - Output: gdp-soviet-sim-results.dta
*|==============================================================================

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
clear all

// Adjust path if running this file by itself
* global path ""

//------------------------------------------------------------------------------
// Import Soviet Aid Simulations from Excel
//------------------------------------------------------------------------------
import excel "$path/data/Soviet Aid Simulations.xlsx", ///
	sheet("Sheet2") firstrow clear

// Save as temporary file
tempfile soviet_sim
save `soviet_sim'

//------------------------------------------------------------------------------
// Merge with GDP results panel
//------------------------------------------------------------------------------

use "$path/results/gdp-results.dta", clear

keep if country=="Cuba"

// Merge: Cuba-only simulation data into full 16-country panel
// Non-Cuba rows will have missing values for the 4 simulation columns
merge m:1 country year using `soviet_sim'
drop _merge

// Use adj_transf23 because it is the same before the aid starts in 1961
foreach var in gdp_agt1 gdp_alt1 gdp_amix {
	replace `var' = adj_transf23 if year<1961
}

//------------------------------------------------------------------------------
// Save merged dataset
//------------------------------------------------------------------------------

save "$path/results/gdp-soviet-sim-results.dta", replace
