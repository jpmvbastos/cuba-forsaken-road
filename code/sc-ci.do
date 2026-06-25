********************************************************************************
// WRAPPER FOR FIRPO-POSSEBOM SCMCS
********************************************************************************
qui do "$path/code/function_SCM-CS_v09_stata.do"
capture program drop scm_ci
program define scm_ci, rclass
    syntax varname, id(varname) timevar(varname) t0(integer) trunit(integer) ///
        [SIGlevel(real 0.10) PRECision(integer 25) EType(string) PHI(real 0)]
    
    if "`etype'" == "" local etype "uniform"
    
    local weight_var `varlist'_Weight
    
    // Get unique IDs and times (sorted)
    quietly levelsof `id', local(all_ids)
    quietly levelsof `timevar', local(all_times)
    local n_units : word count `all_ids'
    local n_times : word count `all_times'
    
    // Find treated unit column number
    local treated_col = 0
    local col = 1
    foreach uid of local all_ids {
        if `uid' == `trunit' {
            local treated_col = `col'
        }
        local ++col
    }
    
    // Find T0 row number
    local t0_row = 0
    local row = 1
    foreach t of local all_times {
        if `t' == `t0' {
            local t0_row = `row'-1
        }
        local ++row
    }

    
    // Create Y matrix (time x units)
    tempname Ymat
    matrix `Ymat' = J(`n_times', `n_units', .)
    local col = 1
    foreach uid of local all_ids {
        local row = 1
        foreach t of local all_times {
            quietly summarize `varlist' if `id' == `uid' & `timevar' == `t'
            matrix `Ymat'[`row', `col'] = r(mean)
            local ++row
        }
        local ++col
    }
    
    // Create weights matrix (donor units x all units)
    tempname weightsmat
    matrix `weightsmat' = J(`n_units'-1, `n_units', .)
    
    // Get minimum year
    quietly summarize `timevar'
    local min_year = r(min)
    
    local col = 1
    foreach uid of local all_ids {
        // Get weights for this unit from weight_var
        tempname weights_j
        matrix `weights_j' = J(`n_units'-1, 1, .)
        
        local weight_row = 1
        quietly count if `id' == `uid' & `timevar' >= `min_year' & `timevar' < `min_year' + `n_units' - 1
        if r(N) > 0 {
            forvalues r = 1/`=`n_units'-1' {
                local yr = `min_year' + `r' - 1
                qui sum `weight_var' if `id' == `uid' & `timevar' == `yr'
                if r(N) > 0 {
                    matrix `weights_j'[`r', 1] = r(mean)
                }
                else {
                    matrix `weights_j'[`r', 1] = 0
                }
            }
        }
        else {
            // If no weights found, set to zero
            forvalues r = 1/`=`n_units'-1' {
                matrix `weights_j'[`r', 1] = 0
            }
        }
        
        // Put weights in the weights matrix
        forvalues r = 1/`=`n_units'-1' {
            matrix `weightsmat'[`r', `col'] = `weights_j'[`r', 1]
        }
        
        local ++col
    }
    
    // Create v vector (all zeros for no sensitivity analysis)
	matrix v = J(1, `n_units', 0)
	

	// Call SCMCS
	SCMCS `Ymat' `weightsmat' `treated_col' `t0_row' `phi' v `precision' `etype' `siglevel'
	
	display("SCMCS run succesful. Finishing wrapper to store results.")
	
	// Copy the matrix returned by SCMCS to a persistent name
	matrix results = r(results)
	
	display "Writing bounds to `varlist'_ci_ub and `varlist'_ci_lb'"

	display as text _newline "{hline 78}"
	display as text "      Confidence Intervals following Firpo and Possebom (2018)"
	display as text "{hline 78}"
	display as text "     Year    |  Estimated Gap   |      Confidence Interval"
	display as text "{hline 78}"

	// Create placeholders
	qui cap drop `varlist'_ci_ub `varlist'_ci_lb
	qui gen `varlist'_ci_ub = `varlist'_synth if id == `trunit'
	qui gen `varlist'_ci_lb = `varlist'_synth if id == `trunit'

	// Loop over all years
	forvalues i = 1/`n_times' {
		local year = `min_year' + `i' - 1

		if `year' >= `t0' {
			
			qui sum `varlist'_gap if year==`year' & id==8
			local value = r(mean)
			local upper = results[`i', 1] 
			local lower = results[`i', 2]

			// Nicely aligned table row
			display as text %10.0f `year' "   |" ///
				as result %12.4f `value' as text "   |  [" ///
				as result %12.4f `lower' as text " , " ///
				as result %12.4f `upper' as text "]"
		}
		else {
			local upper = 0
			local lower = 0
		}
		
		qui replace `varlist'_ci_ub = `upper' if year == `year' & id == `trunit'
		qui replace `varlist'_ci_lb = `lower' if year == `year' & id == `trunit'
	}

	display as text "{hline 78}"
	
    
    // Return results
    return matrix results_`varlist' = results
    
end
