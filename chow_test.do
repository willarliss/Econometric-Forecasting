/*
clear all
import fred DRSFRMACBN HOUSTNSA, aggregate(quarterly, eop)
tsmktim time, start(1959q1)
tsset time
order time
rename DRSFRMACBN del
rename HOUSTNSA houst
label var del "Delinquency Rate on Single Family Mortgages"
label var houst "Housing Starts"
drop daten datestr
keep if time>tq(1990q4)
keep if time<tq(2019q3)
gen q=quarter(dofq(time))
gen q1=(q==1)
gen q2=(q==2)
gen q3=(q==3)
*/

gen break=tq(2011q4)
gen critical=5.86

***

gen d=time>(break)
gen x1=d*L.del
gen x2=d*L2.del

reg del L(1/2).del b4.q x1 x2 d, r
test x1 x2

gen hypo=""
replace hypo="REJECT NULL" if r(F)>critical
replace hypo="FAIL TO REJECT NULL" if r(F)<critical
dis r(F) " - " hypo

drop hypo x1 x2 break d critical
