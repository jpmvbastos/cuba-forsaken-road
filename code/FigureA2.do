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
*| Function: Replicates Figure A2
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
import excel "$path/data/Appendix-Materials.xlsx", ///
	sheet("Figure A2") firstrow clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

twoway line GDPPCUNADJ year, lpattern(solid) lcolor(gs10) ///
	|| line GDPPCADJ year, lpattern(solid) lcolor(black) ///
    xlabel(1990(5)2010,  labsize(small)) ///
    ylabel(1000(1000)5000, labsize(small)) ///
    ytitle("GDP per capita (in 2005 USD)", size(small)) ///
    xtitle("Year", size(small)) ///
    ysize(6.5) xsize(9) ///
	legend(order(1 "Official Data" 2 "Adjusted using satellite NTL") ///
           position(6) rows(2) size(small))
		   
	graph save "$path/figures/FigureA2.gph", replace
	graph export "$path/figures/FigureA2.png", replace
		