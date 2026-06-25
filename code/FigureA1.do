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
*| Function: Replicates Figure A1
*|==============================================================================

// Adjust path if running this file by itself
* global path ""

// Load Data
import excel "$path/data/Appendix-Materials.xlsx", ///
	sheet("Appendix Figure A1") firstrow clear

//------------------------------------------------------------------------------
// Plot
//------------------------------------------------------------------------------

twoway line mpd2010 Year, lpattern(solid) lcolor(black) ///
	|| line mpd2018 Year, lpattern(solid) lcolor(gs10) ///
	|| line mpd2020 Year, lpattern(dash) lcolor(black) ///
	|| line adj_mad23 Year, lpattern(dash) lcolor(gs10) ///
	xline(1959) text(2.1 1959 "Revolution", size(vsmall)) ///
	xline(1989) text(2.1 1989 "Collapse of USSR", size(vsmall)) ///
	yline(1) text(1.05 1934 "1959=1", size(vsmall)) ///
    xlabel(1929(10)2009,  labsize(small)) ///
    ylabel(.5(0.5)2, labsize(small)) ///
    ytitle("GDP per capita Index (1959=1)", size(small)) ///
    xtitle("Year", size(small)) ///
    ysize(6.5) xsize(9) ///
	legend(order(1 "MPD 2010 and 2013" 2 "MPD 2018" ///
			3 "MPD 2020 and 2023" 4 "MPD 2023 + Devereux's Adjustments") ///
           position(6) rows(2) size(small))
		   
	graph save "$path/figures/FigureA1.gph", replace
	graph export "$path/figures/FigureA1.png", replace
		