clear all
import fred DRSFRMACBN HOUSTNSA, aggregate(quarterly, eop)
rename DRSFRMACBN del
rename HOUSTNSA houst
label var del "Delinquency Rate on Single Family Mortgages"
label var houst "Housing Starts"
drop daten datestr

tsmktim time, start(1959q1)
tsset time
order time
keep if time>tq(1990q4)
keep if time<tq(2019q3)
tsappend, add(4)

gen q=quarter(dofq(time))
gen q1=(q==1)
gen q2=(q==2)
gen q3=(q==3)

reg del L(1/4).del L.houst q1 q2 q3
predict y1
predict sf1, stdf
gen y1L=y1-1.96*sf1
gen y1U=y1+1.96*sf1

reg del L(2/5).del L2.houst q1 q2 q3
predict y2
predict sf2, stdf
gen y2L=y2-1.96*sf2
gen y2U=y2+1.96*sf2

reg del L(3/6).del L3.houst q1 q2 q3
predict y3
predict sf3, stdf
gen y3L=y3-1.96*sf3
gen y3U=y3+1.96*sf3

reg del L(4/7).del L4.houst q1 q2 q3
predict y4
predict sf4, stdf
gen y4L=y4-1.96*sf4
gen y4U=y4+1.96*sf4

egen p=rowfirst(y1 y2 y3 y4)
egen pL=rowfirst(y1L y2L y3L y4L) if time>tq(2019q1)
egen pU=rowfirst(y1U y2U y3U y4U) if time>tq(2019q1)

label var p "Forecast"
label var pL "Lower-bound CI"
label var pU "Upper-bound CI"
label var del "Delinquency rate"
tsline del p pL pU if time>tq(1999q4), lpattern(solid shortdash dash dash)
list time del p pL pU if time>tq(2019q1)
