********************************************************************************
********************************************************************************
********* Int. Macro and Trade. 		****************************************
********* Assignment 3: Table 1 		****************************************
********* Jose M. Quintero 				****************************************
********************************************************************************
********************************************************************************

clear all
* Change directory
cd "/Users/josemiguelquinteroholguin/Library/CloudStorage/Dropbox/UChicago/2nd Year Classes/Int.-Macro-and-Trade/Assignment 3"

* Import data
import delimited Data/Detroit.csv, clear

* Generate logarithmic variables
foreach vars of varlist flows distance_google_miles duration_minutes {
	* Create log versions 
	gen ln_`vars' = log(`vars')
}

* Generate Stata table
tempname panelA // Creates matrix for coefficient
tempname starsA // Create matrix for stars

timer clear

********************************************
********** Table 1: Panel A ****************
********************************************

*----------------------------------------- *
* ---- Regression in logs using reg ------ *
*----------------------------------------- *
timer on 1
quietly reg ln_flows ln_distance_google_miles i.home_id i.work_id
timer off 1
* Save Regression in matrix
mat `panelA' = (nullmat(`panelA'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles] \ e(r2), e(N))) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix from gold instrument 
if(`p'<=0.1 & `p'>0.05) mat `starsA' = (nullmat(`starsA'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `starsA' = (nullmat(`starsA'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `starsA' = (nullmat(`starsA'),(3,0\0,0\0,0))
else  mat `starsA' = (nullmat(`starsA'),(0,0\0,0\0,0))

*----------------------------------------- *
* ----- Regression using xtreg ----------- * 
*----------------------------------------- *
xtset work_id
timer on 2
quietly xtreg ln_flows ln_distance_google_miles i.home_id, fe
timer off 2
* Save Regression in matrix
mat `panelA' = (nullmat(`panelA'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles] \ e(r2), e(N))) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix from gold instrument 
if(`p'<=0.1 & `p'>0.05) mat `starsA' = (nullmat(`starsA'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `starsA' = (nullmat(`starsA'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `starsA' = (nullmat(`starsA'),(3,0\0,0\0,0))
else  mat `starsA' = (nullmat(`starsA'),(0,0\0,0\0,0))

*----------------------------------------- *
* ----- Regression using areg ------------ * 
*----------------------------------------- *
timer on 3
quietly areg ln_flows ln_distance_google_miles i.home_id, absorb(work_id)
timer off 3 
* Save Regression in matrix
mat `panelA' = (nullmat(`panelA'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles] \ e(r2), e(N))) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix from gold instrument 
if(`p'<=0.1 & `p'>0.05) mat `starsA' = (nullmat(`starsA'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `starsA' = (nullmat(`starsA'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `starsA' = (nullmat(`starsA'),(3,0\0,0\0,0))
else  mat `starsA' = (nullmat(`starsA'),(0,0\0,0\0,0))

*-------------------------------------------- *
* ----- Regression using reghdfe ------------ * 
*-------------------------------------------- *
timer on 4
quietly reghdfe ln_flows ln_distance_google_miles, absorb(work_id home_id)
timer off 4
* Save Regression in matrix
mat `panelA' = (nullmat(`panelA'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles] \ e(r2), e(N))) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix from gold instrument 
if(`p'<=0.1 & `p'>0.05) mat `starsA' = (nullmat(`starsA'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `starsA' = (nullmat(`starsA'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `starsA' = (nullmat(`starsA'),(3,0\0,0\0,0))
else  mat `starsA' = (nullmat(`starsA'),(0,0\0,0\0,0))
* List timers
timer list 
* Add timer to panel A
mat `panelA' = (nullmat(`panelA') \ (r(t1),.,r(t2),.,r(t3),.,r(t4),.))

mat list `panelA'
mat list `starsA'

********************************************
********** Table 1: Panel B ****************
********************************************

* Clear timers for panel B
timer clear 

* Generate Stata table
tempname panelB // Creates matrix for coefficient
tempname starsB // Create matrix for stars

*----------------------------------------- *
* ---- Regression in logs using reg ------ *
*----------------------------------------- *
timer on 1
quietly reg ln_flows ln_duration_minutes i.home_id i.work_id
timer off 1
* Save Regression in matrix
mat `panelB' = (nullmat(`panelB'),(_b[ln_duration_minutes], _se[ln_duration_minutes]\ e(r2), e(N))) // Add coefficient, standard deviation and time 
* Matrix of stars 
local t = _b[ln_duration_minutes]/_se[ln_duration_minutes] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix from gold instrument 
if(`p'<=0.1 & `p'>0.05) mat `starsB' = (nullmat(`starsB'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `starsB' = (nullmat(`starsB'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `starsB' = (nullmat(`starsB'),(3,0\0,0\0,0))
else  mat `starsB' = (nullmat(`starsB'),(0,0\0,0\0,0))

*----------------------------------------- *
* ----- Regression using xtreg ----------- * 
*----------------------------------------- *
xtset work_id
timer on 2
quietly xtreg ln_flows ln_duration_minutes i.home_id, fe
timer off 2
* Save Regression in matrix
mat `panelB' = (nullmat(`panelB'),(_b[ln_duration_minutes], _se[ln_duration_minutes]\ e(r2), e(N))) // Add coefficient, standard deviation and time 
* Matrix of stars 
local t = _b[ln_duration_minutes]/_se[ln_duration_minutes] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix from gold instrument 
if(`p'<=0.1 & `p'>0.05) mat `starsB' = (nullmat(`starsB'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `starsB' = (nullmat(`starsB'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `starsB' = (nullmat(`starsB'),(3,0\0,0\0,0))
else  mat `starsB' = (nullmat(`starsB'),(0,0\0,0\0,0))

*----------------------------------------- *
* ----- Regression using areg ------------ * 
*----------------------------------------- *
timer on 3
quietly areg ln_flows ln_duration_minutes i.home_id, absorb(work_id)
timer off 3 
* Save Regression in matrix
mat `panelB' = (nullmat(`panelB'),(_b[ln_duration_minutes], _se[ln_duration_minutes]\ e(r2), e(N))) // Add coefficient, standard deviation and time 
* Matrix of stars 
local t = _b[ln_duration_minutes]/_se[ln_duration_minutes] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix from gold instrument 
if(`p'<=0.1 & `p'>0.05) mat `starsB' = (nullmat(`starsB'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `starsB' = (nullmat(`starsB'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `starsB' = (nullmat(`starsB'),(3,0\0,0\0,0))
else  mat `starsB' = (nullmat(`starsB'),(0,0\0,0\0,0))

*-------------------------------------------- *
* ----- Regression using reghdfe ------------ * 
*-------------------------------------------- *
timer on 4
quietly reghdfe ln_flows ln_duration_minutes, absorb(work_id home_id)
timer off 4
* Save Regression in matrix
mat `panelB' = (nullmat(`panelB'),(_b[ln_duration_minutes], _se[ln_duration_minutes]\ e(r2), e(N))) // Add coefficient, standard deviation and time 
* Matrix of stars 
local t = _b[ln_duration_minutes]/_se[ln_duration_minutes] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix from gold instrument 
if(`p'<=0.1 & `p'>0.05) mat `starsB' = (nullmat(`starsB'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `starsB' = (nullmat(`starsB'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `starsB' = (nullmat(`starsB'),(3,0\0,0\0,0))
else  mat `starsB' = (nullmat(`starsB'),(0,0\0,0\0,0))
* List timers
timer list 

* Add timer to panel B
mat `panelB' = (nullmat(`panelB') \ (r(t1),.,r(t2),.,r(t3),.,r(t4),.))
* List matrix 
mat list `panelB'
mat list `starsB'

*****************************************************
****** Table 1: Export Results **********************
*****************************************************

mat table1  = (`panelA' \ `panelB')
mat stars	= (`starsA' \ `starsB')

mat list table1 

* Export matrix as table
frmttable using "Tables/table1", tex replace s(table1) sd(3) sub(1) hlines(101{0}1001) fragment /// Table, decimals, sub for std in parenthesis and horizontal lines
ctitles("", "log(Flows)", "", "", "" \"Dependent", "(1)", "(2)", "(3)", "(4)" \ "\textit{Panel A: Distance in Google Miles}", "", "", "", "") /// Column titles
    multicol(1,2,4;3,1,5;9,1,5) /// Multicolumn (row, starting column, how much columns to combine; )
	rtitles("Distance" \ "" \ "$ R^2$" \ "$ N$" \ "Time (Seconds)" \ "\textit{Panel B: Distance in Google Minutes}" \ "Distance" \ "" \ "$ R^2$" \ "$ N$" \ "Time (Seconds)" \ "") ///
	addrow("Origin FE","Y","Y","Y","Y" \ "Destination FE","Y","Y","Y","Y" \ "Stata Command.","reg","xtreg", "aref","reghdfe") ///
	annotate(stars) asymbol("$ ^*$", "$ ^{**}$", "$ ^{***}$")


*****************************************************
****** Table 2: The Role of 0 ***********************
*****************************************************



* Generate alternative measures
gen ln_flows2 = log(flows+1)
gen ln_flows3 = log(flows+0.01)

* Create modified flow
gen temp = 1e-10*flows*(home_id==work_id)
bys home_id: egen w_flow = max(temp)
drop temp 
gen ln_flows4 = ln_flows
replace ln_flows4 = log(w_flow) if flows==0

* Initialize matrix
tempname table2
tempname stars2
timer clear 
*-------------------------------------------- *
* ----- Regression ommiting 0's  ------------ * 
*-------------------------------------------- *

* Run log-lin regression
quietly reg ln_flows ln_distance_google_miles i.home_id 
hettest

* Save Regression in matrix
mat `table2' = (nullmat(`table2'),(_b[ln_distance_google_miles], _se[ln_distance_google_miles]\ r(chi2), r(p) )) // Add coefficient, standard deviation and time 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value

* Predict residuals for plot
*predict u_i if flows!=0, r 
*predict fitted if flows!=0, xb 

* Calculate time using the actual function for horse race
timer on 1
quietly reghdfe ln_flows ln_distance_google_miles, absorb(work_id home_id)
timer off 1 


* Add stars to matrix 
if(`p'<=0.1 & `p'>0.05) mat `stars2' = (nullmat(`stars2'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `stars2' = (nullmat(`stars2'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `stars2' = (nullmat(`stars2'),(3,0\0,0\0,0))
else  mat `stars2' = (nullmat(`stars2'),(0,0\0,0\0,0))

* Grpah of predicted values to study heteroskedasticity 
*twoway (scatter u_i fitted, mc(maroon) mlc(black)), plotregion(fcolor(white)) /// 
*graphregion(fcolor(white)) xti("Fitted Values") legend(off) ///
*ylabel(,nogrid format(%3.2f)) xlabel(,format(%3.2f)) yline(0, lc(black) lp(dash))
*graph export "Figures/residual_plot.pdf", replace

*-------------------------------------------- *
* ---- Regression ommiting 0s & log(x+1) ---- * 
*-------------------------------------------- *

* Calculate time using the actual function for horse race
timer on 2
quietly reghdfe ln_flows2 ln_distance_google_miles if flows!=0, absorb(work_id home_id)
timer off 2

* Save Regression in matrix
mat `table2' = (nullmat(`table2'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles]\.,.)) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix 
if(`p'<=0.1 & `p'>0.05) mat `stars2' = (nullmat(`stars2'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `stars2' = (nullmat(`stars2'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `stars2' = (nullmat(`stars2'),(3,0\0,0\0,0))
else  mat `stars2' = (nullmat(`stars2'),(0,0\0,0\0,0))

*-------------------------------------------- *
* ----------- Regression log(x+1) ----------- * 
*-------------------------------------------- *

* Calculate time using the actual function for horse race
timer on 3
quietly reghdfe ln_flows2 ln_distance_google_miles, absorb(work_id home_id)
timer off 3

* Save Regression in matrix
mat `table2' = (nullmat(`table2'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles]\.,.)) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix 
if(`p'<=0.1 & `p'>0.05) mat `stars2' = (nullmat(`stars2'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `stars2' = (nullmat(`stars2'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `stars2' = (nullmat(`stars2'),(3,0\0,0\0,0))
else  mat `stars2' = (nullmat(`stars2'),(0,0\0,0\0,0))

*-------------------------------------------- *
* --------- Regression log(x+0.01) ---------- * 
*-------------------------------------------- *

* Calculate time using the actual function for horse race
timer on 4
quietly reghdfe ln_flows3 ln_distance_google_miles, absorb(work_id home_id)
timer off 4

* Save Regression in matrix
mat `table2' = (nullmat(`table2'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles]\.,.)) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix 
if(`p'<=0.1 & `p'>0.05) mat `stars2' = (nullmat(`stars2'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `stars2' = (nullmat(`stars2'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `stars2' = (nullmat(`stars2'),(3,0\0,0\0,0))
else  mat `stars2' = (nullmat(`stars2'),(0,0\0,0\0,0))


*-------------------------------------------- *
* -------- Regression modified flow --------- * 
*-------------------------------------------- *

* Calculate time using the actual function for horse race
timer on 5
quietly reghdfe ln_flows4 ln_distance_google_miles, absorb(work_id home_id)
timer off 5

* Save Regression in matrix
mat `table2' = (nullmat(`table2'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles]\.,.)) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix 
if(`p'<=0.1 & `p'>0.05) mat `stars2' = (nullmat(`stars2'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `stars2' = (nullmat(`stars2'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `stars2' = (nullmat(`stars2'),(3,0\0,0\0,0))
else  mat `stars2' = (nullmat(`stars2'),(0,0\0,0\0,0))


*-------------------------------------------- *
* ------ Regression poisson hdfe flow ------- * 
*-------------------------------------------- *

* Calculate time using the actual function for horse race
timer on 6
poi2hdfe flows ln_distance_google_miles, id1(work_id) id2(home_id)
timer off 6

* Save Regression in matrix
mat `table2' = (nullmat(`table2'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles]\.,.)) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix 
if(`p'<=0.1 & `p'>0.05) mat `stars2' = (nullmat(`stars2'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `stars2' = (nullmat(`stars2'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `stars2' = (nullmat(`stars2'),(3,0\0,0\0,0))
else  mat `stars2' = (nullmat(`stars2'),(0,0\0,0\0,0))

*-------------------------------------------- *
* ------ Regression poisson hdfe flow ------- * 
*-------------------------------------------- *

* Calculate time using the actual function for horse race
timer on 7
quietly ppmlhdfe flows ln_distance_google_miles, absorb(work_id home_id)
timer off 7

* Save Regression in matrix
mat `table2' = (nullmat(`table2'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles]\.,.)) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix 
if(`p'<=0.1 & `p'>0.05) mat `stars2' = (nullmat(`stars2'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `stars2' = (nullmat(`stars2'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `stars2' = (nullmat(`stars2'),(3,0\0,0\0,0))
else  mat `stars2' = (nullmat(`stars2'),(0,0\0,0\0,0))


*-------------------------------------------- *
* ------ Regression poisson hdfe flow ------- * 
*-------------------------------------------- *

* Calculate time using the actual function for horse race
timer on 8
ppmlhdfe flows ln_distance_google_miles if flows!=0, absorb(work_id home_id)
timer off 8

* Save Regression in matrix
mat `table2' = (nullmat(`table2'),(_b[ln_distance_google_miles] , _se[ln_distance_google_miles]\.,.)) // Add coefficient, standard deviation 
* Matrix of stars 
local t = _b[ln_distance_google_miles]/_se[ln_distance_google_miles] // t-value
local p = 2*ttail(e(df_r),abs(`t')) // p-value
* Add stars to matrix 
if(`p'<=0.1 & `p'>0.05) mat `stars2' = (nullmat(`stars2'),(1,0\0,0\0,0))
else if(`p'<=0.05 & `p'>0.01)  mat `stars2' = (nullmat(`stars2'),(2,0\0,0\0,0))
else if(`p'<=0.01)  mat `stars2' = (nullmat(`stars2'),(3,0\0,0\0,0))
else  mat `stars2' = (nullmat(`stars2'),(0,0\0,0\0,0))

timer list 
* Add running time to table 2
mat `table2' = (nullmat(`table2') \ (r(t1),.,r(t2),.,r(t3),.,r(t4),.,r(t5),.,r(t6),.,r(t7),.,r(t8),.))


mat list `table2'
mat list `stars2' 



* Export matrix as table
frmttable using "Tables/table2", tex replace s(`table2') sd(3) sub(1) hlines(101{0}1) fragment /// Table, decimals, sub for std in parenthesis and horizontal lines
ctitles("", "$ F$(Flows)", "", "", "", "", "", ""," "\"Dependent", "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)") /// Column titles
    multicol(1,2,7) /// Multicolumn (row, starting column, how much columns to combine; )
	rtitles("Distance (Google Miles)" \ "" \ "Breusch–Pagan $ \chi^2$" \ "" \ "Time (Seconds)" \ "") ///
	addrow("Origin FE","Y","Y","Y","Y","Y","Y","Y","Y" \ "Destination FE","Y","Y","Y","Y","Y","Y","Y","Y") ///
	annotate(`stars2') asymbol("$ ^*$", "$ ^{**}$", "$ ^{***}$")


* Last regression 

timer clear

timer on 1
reghdfe ln_flows ln_distance_google_miles, absorb(work_id home_id) vce(r) 
timer off 1

timer list 

