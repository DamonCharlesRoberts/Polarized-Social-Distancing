* Can Stata Run That Many Observations?
* Final Dataset:
use "~/Dropbox/Spatial COVID 19/Cleaned Data/finaldata.dta"

* Converting From Dataset cleaned in R (Can ignore)
cd "/Users/damonroberts/Dropbox/Spatial COVID 19/Cleaned Data/"

import delimited finaldataset.csv

rename median_percentage_time_home percenthome
rename lesscollege_pct percentcollege
rename clf_unemploy_pct percentunemployed

* Create Measure of Partisanship of Gov. to see if important control
gen sixteengdif_n = real(sixteengdif)
gen govparty = .
replace govparty = 0 if sixteengdif_n < 0
replace govparty = 1 if sixteengdif_n > 0
replace govparty = 5 if sixteengdif_n == 0 //*Cool, no observations that match this
reg percenthome partycontrol

gen govparty1 = . 
replace govparty1 = 0 if statex == "AL"
replace govparty1 = 0 if statex == "AK"
replace govparty1 = 0 if statex == "AZ"
replace govparty1 = 0 if statex == "AR"
replace govparty1 = 1 if statex == "CA"
replace govparty1 = 1 if statex == "CO"
replace govparty1 = 1 if statex == "CT"
replace govparty1 = 1 if statex == "DE"
replace govparty1 = 0 if statex == "FL"
replace govparty1 = 0 if statex == "GA"
replace govparty1 = 1 if statex == "HI"
replace govparty1 = 0 if statex == "ID"
replace govparty1 = 1 if statex == "IL"
replace govparty1 = 0 if statex == "IN"
replace govparty1 = 0 if statex == "IA"
replace govparty1 = 1 if statex == "KS"
replace govparty1 = 1 if statex == "KY"
replace govparty1 = 1 if statex == "LA"
replace govparty1 = 1 if statex == "ME"
replace govparty1 = 0 if statex == "MD"
replace govparty1 = 0 if statex == "MA"
replace govparty1 = 1 if statex == "MI"
replace govparty1 = 1 if statex == "MN"
replace govparty1 = 0 if statex == "MS"
replace govparty1 = 0 if statex == "MO"
replace govparty1 = 1 if statex == "MT"
replace govparty1 = 0 if statex == "NE"
replace govparty1 = 1 if statex == "NV"
replace govparty1 = 0 if statex == "NH"
replace govparty1 = 1 if statex == "NJ"
replace govparty1 = 1 if statex == "NM"
replace govparty1 = 1 if statex == "NY"
replace govparty1 = 1 if statex == "NC"
replace govparty1 = 0 if statex == "ND"
replace govparty1 = 0 if statex == "OH"
replace govparty1 = 0 if statex == "OK"
replace govparty1 = 1 if statex == "OR"
replace govparty1 = 1 if statex == "PA"
replace govparty1 = 1 if statex == "RI"
replace govparty1 = 0 if statex == "SC"
replace govparty1 = 0 if statex == "SD"
replace govparty1 = 0 if statex == "TN"
replace govparty1 = 0 if statex == "TX"
replace govparty1 = 0 if statex == "UT"
replace govparty1 = 0 if statex == "VT"
replace govparty1 = 1 if statex == "VA"
replace govparty1 = 1 if statex == "WA"
replace govparty1 = 0 if statex == "WV"
replace govparty1 = 1 if statex == "WI"
replace govparty1 = 0 if statex == "WY"

* New Measure of Partisanship Control - 2016 Presidential Voteshare
gen totalpresvotes = d16+r16
gen partycontrol1 = d16/totalpresvotes


* 2012 Presidential Voteshare
gen totalpresvotes12 = d12+r12
gen partycontrol12 = d12/totalpresvotes12

* Regressions *
reg percenthome partycontrol percentcollege

reg percenthome partycontrol percentcollege percentunemployed

reg percenthome partycontrol percentcollege percentunemployed median_hh_inc, cluster(fips)
reg percenthome partycontrol percentcollege percentunemployed govparty day, cluster(fips)
xtset week
xtreg percenthome partycontrol percentcollege percentunemployed govparty

*STATA, what a workhorse! It can do it. The results are statistically significant.



* With Fixed effects for state

tab state_fips, gen(statevar)

xtset week
xtreg percenthome partycontrol percentcollege percentunemployed govparty rural_pct nonwhite_pct total_population age65andolder_pct statevar1-statevar44 if day < 72
estimates store model1
esttab model1, se stats(N r2, label(Observations R-Squared)) label, using "/Users/damonroberts/Dropbox/Spatial COVID 19/table1.rtf", replace
esttab using "/Users/damonroberts/Dropbox/Spatial COVID 19/table1.rtf", replace ///
	order(partycontrol govparty total_population rural_pct nonwhite_pct age65andolder_pct percentcollege percentunemployed) b(2) se(2) r2(4) starlevels(* 0.1 ** 0.05 *** 0.01) ///
	nogap onecell numbers("Model ") nomti   ///
	coeflabels(partycontrol "County Partisanship" govparty "Governor's Party" total_population "County Population" rural_pct "Percent of County as Rural" nonwhite_pct "Percent non-white" age65andolder_pct "Percent Age 65 or Older" percentcollege "Percent of those with less than a College Education" percentunemployed "Percent Unemployed (2018)" _cons "Constant") ///
	title({\b Table 1.} {\i Time at Home and County's Partisanship}) 
	

* Model 2 - Second DV (Median dwell time)

xtset week
xtreg median_non_home_dwell_time partycontrol percentcollege percentunemployed govparty rural_pct nonwhite_pct total_population age65andolder_pct statevar1-statevar44 if day < 72
estimates store model2

*Table for the models
esttab model1 model2, se stats(N r2, label(Observations R-Squared)) label, using "/Users/damonroberts/Dropbox/Spatial COVID 19/table3.rtf", replace

*  SPATIAL MODELS (Need help) *

* Download spmat by doing net install st0292.pkg

* Use spreg package for MLM and Spatial 2SLS Models

* Install spmap

* Need file to create contiguity matrix

import delimited "/Users/damonroberts/Dropbox/Spatial COVID 19/AWS Data (Messy Data)/safegraph_open_census_data/metadata/cbg_fips_codes.csv"

save "fipscodes.dta"

use "fipscodes.dta"


/* Can't only use FIPS codes to calculate contiguity matrix. Try using the code 
described here: 
https://www.stata.com/training/webinar_series/spatial-autoregressive-models/spatial/resource/workflow_example.html
*/
cd "/Users/damonroberts/Dropbox/Spatial COVID 19/Cleaned Data/tl_2016_us_county"
spshape2dta tl_2016_us_county

use tl_2016_us_county, clear

describe

generate fips = real(STATEFP + COUNTYFP)
bysort fips: assert _N == 1
assert fips !=.
spset fips, modify replace
spset, modify coordsys(latlong, miles)

* Include Geospatial coordinates for the Counties (DON'T NEED TO RUN THIS AGAIN)

cd "/Users/damonroberts/Dropbox/Spatial COVID 19/Cleaned Data"

import delimited finaldataset.csv, clear
describe

merge m:1 fips using tl_2016_us_county

keep if _merge == 3

drop _merge

save finaldata, replace
* This all worked, cool! Now to create W matrix.


* Analysis - where I need help

reg percenthome partycontrol percentcollege percentunemployed median_hh_inc
* Since it is panel, we need to just specify one time period to create the W matrix
* Using last page:  https://www.stata.com/manuals/spspmatrixcreate.pdf
use finaldata
isid _ID day
duplicates report _ID day
duplicates list _ID day
duplicates tag _ID day, gen(isdup)
edit if isdup
drop isdup
xtset _ID day //* error repeated time values within panel
spbalance // * Doesn't work
spset
spmatrix create contiguity W if day == 1, replace // *I'm totally stuck here






* Model 1 Redone

reg percenthome i.partycontrol1 c.week i.partycontrol1#c.week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day < 72, cluster(fips)
estimates store model3

reg percenthome partycontrol1 week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72, cluster(fips)
estimates store model4

esttab model3 model4, se stats(N r2, label(Observations R-Squared)) label, using "/Users/damonroberts/Dropbox/Spatial COVID 19/model1redone.rtf", replace


* Model 2 Redone


reg median_non_home_dwell_time i.partycontrol1 c.week i.partycontrol1#c.week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day < 72, cluster(fips)
estimates store model5

reg median_non_home_dwell_time partycontrol1 week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72,cluster(fips)
estimates store model6

esttab model5 model6, se stats(N r2, label(Observations R-Squared)) label, using "/Users/damonroberts/Dropbox/Spatial COVID 19/model2redone.rtf", replace


esttab model4 model6, se stats(N r2, label(Observations R-Squared)) label, using "/Users/damonroberts/Dropbox/Spatial COVID 19/table4.rtf", replace


* Include County level Data on # of COVID Cases

merge m:m day fips using finaldata.dta
keep if _merge == 3


* Model 1 Reredone
reg percenthome partycontrol1 week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72, cluster(fips)
estimates store model7

* Model 2 Reredone

reg median_non_home_dwell_time partycontrol1 week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72,cluster(fips)
estimates store model8

esttab model7 model8, se stats(N r2, label(Observations R-Squared)) label, using "/Users/damonroberts/Dropbox/Spatial COVID 19/modelreredone.rtf", replace

* Include Geographic size of county
import delimited cbg_geographic_data.csv
save census_geography.dta
rename origin_census_block_group census_block_group
merge m:1 census_block_group using census_geography.dta

* This all was for naught. Seems like data won't work.



****** 3 Operationalizations of Main IV ***************
*Dummy Measure*
reg percenthome partycontrol week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72, cluster(fips)
estimates store model9

reg median_non_home_dwell_time partycontrol week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72,cluster(fips)
estimates store model10

* 2016 President Voteshare*
reg percenthome partycontrol1 week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72, cluster(fips)
estimates store model11

reg median_non_home_dwell_time partycontrol1 week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72,cluster(fips)
estimates store model12

* 2012 President Voteshare*
reg percenthome partycontrol12 week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72, cluster(fips)
estimates store model13

reg median_non_home_dwell_time partycontrol12 week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct if day <72,cluster(fips)
estimates store model14


esttab model9 model10 model11 model12 model13 model14, se stats(N r2, label(Observations R-Squared)) order(partycontrol partycontrol1 partycontrol12 govparty1 week percentcollege percentunemployed rural_pct nonwhite_pct total_population age65andolder_pct) label, using "/Users/damonroberts/Dropbox/Spatial COVID 19/sixmodels.rtf", replace


label var partycontrol "Democratic Control Dummy"
label var partycontrol1 "2016 Democratic Voteshare"
label var partycontrol12 "2012 Democratic Voteshare"
label var percenthome "% Time Spent at Home"
label var median_non_home_dwell_time "Median Time (in minutes) not at Home"
label var week "Week"
label var percentcollege "% Less than a College Education"
label var percentunemployed "% Unemployed"
label var govparty1 "% Governor's Party"
label var rural_pct "% Rural"
label var nonwhite_pct "% Nonwhite"
label var age65andolder_pct "% Aged 65 and Older"
coefplot (model9, label(Democratic Control Dummy)) (model11, label(2016 Democratic Voteshare)) (model13, label(2012 Democratic Voteshare)), drop(_cons week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct) xline(0) graphregion(color(white))  ti("Figure 1.County Partisanship on % Time at Home", size(medium))
coefplot (model10, label(Democratic Control Dummy)) (model12, label(2016 Democratic Voteshare)) (model14, label(2012 Democratic Voteshare)), drop(_cons week percentcollege percentunemployed govparty1 rural_pct nonwhite_pct total_population age65andolder_pct) xline(0) graphregion(color(white)) ti("Figure 2.County Partisanship on Median Time not at Home", size(medium))
coefplot model9 model11 model13, horizontal drop(_cons) xline(0) graphregion(color(white)) pstyle(p1) ti ("County Partisanship on % Time at Home")
coefplot model10 model12 model14, horizontal drop(_cons) xline(0) graphregion(color(white)) pstyle(p1) ti ("County Partisanship on Median Time not at Home")


* Descriptives * 
sum partycontrol
estimates store desc1
sum partycontrol1
estimates store desc2
sum partycontrol2
estimates store desc3

estpost summarize percenthome median_non_home_dwell_time partycontrol partycontrol1 partycontrol12, listwise
esttab, cells("mean sd min max") nomtitle nonumber, using "/Users/damonroberts/Dropbox/Spatial COVID 19/summarystats.rtf", replace
