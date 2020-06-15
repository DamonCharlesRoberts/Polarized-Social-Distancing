******** Cleaning MITELECTIONS DATA*******

/* Use this dataset to calculate county-level partisanship based on past 
elections: President, Gubenatorial, Senate, and House.*/

cd "/Users/damonroberts/Dropbox/Spatial COVID 19"

import delimited MITElectionLab.csv

*STATA is annoying and keeps getting rid of leading zeros

format fips %05.0f

* Calculate partisanship based on past elections
/* Damon, keep in mind:
Should expect that in countys with more democratic support will be higher */

gen sixteenpdif = d16-r16 // *'16 Presidential election
gen twelvepdif = d12-r12 // *'12 Presidential election
tab dsen16
gen dsen16_n = real(dsen16)
tab rsen16
gen rsen16_n = real(rsen16)
gen sixteensdif = dsen16_n-rsen16_n // *'16 Senate election
tab dhouse16
gen dhouse16_n = real(dhouse16)
tab rhouse16
gen rhouse16_n = real(rhouse16)
gen sixteenhdif = dhouse16_n-rhouse16_n //*16 House election
tab dgov16 
gen dgov16_n = real(dgov16)
tab rgov16
gen rgov16_n = real(rgov16)
gen sixteengdif = dgov16_n-rgov16_n //*'16 Gubanatorial election
tab dgov14
gen dgov14_n = real(dgov14)
tab rgov14
gen rgov14_n = real(rgov14)
gen fourteengdif = dgov14_n-rgov14_n //*'14 Gubanatorial election

egen sum = rowtotal(sixpdif-fourteengdif)
/* Doesn't seem like there is a good way to get an average to create a categoric
-al variable on just how Democratic or how Republican it is. 
I want to divide by the number of columns and then use cutpoints, but I don't
want to divide each row by the same number of columns if there is no data in that
particular election... */

gen partycontrol = .
replace partycontrol = 0 if sum < 0
replace partycontrol = 1 if sum > 0
replace partycontrol = 4 if sum == 0 // *Just in case there is a complete tie.


