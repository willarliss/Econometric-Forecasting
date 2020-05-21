* Data cleaning 
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


* Seasonality test
regress del L(1/4).del
predict e1, residuals
tsline e1
ac e1

regress houst L(1/4).houst
predict e2, residuals
tsline e2
ac e2

drop e1 e2


* ADL AIC
regress del b4.q if time>tq(1992q1), r
estimates store ADL00
regress del L.houst b4.q if time>tq(1992q1), r
estimates store ADL01
regress del L(1/2).houst b4.q if time>tq(1992q1), r
estimates store ADL02
regress del L(1/3).houst b4.q if time>tq(1992q1), r
estimates store ADL03
regress del L(1/4).houst b4.q if time>tq(1992q1), r
estimates store ADL04

regress del L.del b4.q if time>tq(1992q1), r
estimates store ADL10
regress del L.del L.houst b4.q if time>tq(1992q1), r
estimates store ADL11
regress del L.del L(1/2).houst b4.q if time>tq(1992q1), r
estimates store ADL12
regress del L.del L(1/3).houst b4.q if time>tq(1992q1), r
estimates store ADL13
regress del L.del L(1/4).houst b4.q if time>tq(1992q1), r
estimates store ADL14

regress del L(1/2).del b4.q if time>tq(1992q1), r
estimates store ADL20
regress del L(1/2).del L.houst b4.q if time>tq(1992q1), r
estimates store ADL21
regress del L(1/2).del L(1/2).houst b4.q if time>tq(1992q1), r
estimates store ADL22
regress del L(1/2).del L(1/3).houst b4.q if time>tq(1992q1), r
estimates store ADL23
regress del L(1/2).del L(1/4).houst b4.q if time>tq(1992q1), r
estimates store ADL24

regress del L(1/3).del b4.q if time>tq(1992q1), r
estimates store ADL30
regress del L(1/3).del L.houst b4.q if time>tq(1992q1), r
estimates store ADL31
regress del L(1/3).del L(1/2).houst b4.q if time>tq(1992q1), r
estimates store ADL32
regress del L(1/3).del L(1/3).houst b4.q if time>tq(1992q1), r
estimates store ADL33
regress del L(1/3).del L(1/4).houst b4.q if time>tq(1992q1), r
estimates store ADL34

regress del L(1/4).del b4.q if time>tq(1992q1), r
estimates store ADL40
regress del L(1/4).del L.houst b4.q if time>tq(1992q1), r
estimates store ADL41
regress del L(1/4).del L(1/2).houst b4.q if time>tq(1992q1), r
estimates store ADL42
regress del L(1/4).del L(1/3).houst b4.q if time>tq(1992q1), r
estimates store ADL43
regress del L(1/4).del L(1/4).houst b4.q if time>tq(1992q1), r
estimates store ADL44

estimates stats ADL00 ADL01 ADL02 ADL03 ADL04 ADL10 ADL11 ADL12 ADL13 ///
ADL14 ADL20 ADL21 ADL22 ADL23 ADL24 ADL30 ADL31 ADL32 ADL33 ADL34 ///
ADL40 ADL41 ADL42 ADL43 ADL44


* Test AIC vs BIC
reg del L(1/4).del L(1/4).houst b4.q, r
dfuller del, lags(4)
dfuller houst, lags(4)
testparm L(1/4).del
testparm L(1/4).houst

reg del L(1/2).del L.houst b4.q, r
dfuller del, lags(2)
dfuller houst, lags(1)
testparm L(1/2).del
test L.houst

reg del L(1/4).del L.houst b4.q, r
dfuller del, lags(4)
dfuller houst, lags(1)
testparm L(1/4).del
test L.houst


* POOS Test
*rolling, recursive window(30) clear: reg del L(1/4).del L(1/4).houst b4.q, r
*rolling, recursive window(30) clear: reg del L(1/2).del L.houst b4.q, r
*rolling, recursive window(30) clear: reg del L(1/4).del L.houst b4.q, r

* Test for break dates
rolling, window(30) clear: reg del L(1/2).del L.houst b4.q, r
tsset start
tsline _b_cons
tsline _stat_3
tsline _stat_1 _stat_2
tsline _stat_1 _stat_2 _stat_3
tsline _stat_4 _stat_5 _stat_6

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

gen break=tq(2007q4)
gen critical=3.15

gen d=time>(break)
gen x1=d*L.del
gen x2=d*L2.del

reg del L(1/4).del b4.q x1 x2, r
test x1 x2

gen hypo=""
replace hypo="REJECT NULL" if r(F)>critical
replace hypo="FAIL TO REJECT NULL" if r(F)<critical
dis r(F) " - " hypo

