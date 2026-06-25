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
*| Function: Replicates Figure A3
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
import excel "$path/data/Appendix-Materials.xlsx", ///
	sheet("Figure A3") firstrow clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

twoway line MPD2023Rebased year, lpattern(solid) lcolor(black) ///
	|| line Martinez year, lpattern(dash) lcolor(gs10) ///
	|| line DevereuxRebased year, lpattern(dash) lcolor(black) ///
    xlabel(1992(4)2012,  labsize(small)) ///
    ylabel(1(.5)2.5, labsize(small)) ///
    ytitle("GDP per capita index (1992-1994=1)", size(small)) ///
    xtitle("Year", size(small)) ///
    ysize(6.5) xsize(9) ///
	legend(order(1 "MPD 2023" 2 "Martinez" 3 "Devereux") ///
           position(6) rows(2) size(small))
		   
	graph save "$path/figures/FigureA3.gph", replace
	graph export "$path/figures/FigureA3.png", replace
		