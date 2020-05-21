clear all
import fred DRSFRMACBN HOUSTNSA UNRATE PERMIT OUTMS, aggregate(quarterly, eop)
rename DRSFRMACBN del
rename HOUSTNSA houst
drop daten datestr

tsmktim time, start(1948q1)
tsset time
order time
keep if time>tq(1990q4)
keep if time<tq(2019q3)

gen q=quarter(dofq(time))

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

/*

estimates clear

reg del L(1/4).del L(1/2).UNRATE b4.q, r
estimates store uARDL42
reg del L(1/2).del L(1/2).UNRATE b4.q, r
estimates store uARDL22
reg del L(1/4).del L(1/3).OUTMS b4.q, r
estimates store mARDL43
reg del L(1/4).del L.OUTMS b4.q, r
estimates store mARDL41
reg del L(1/4).del L(1/4).PERMIT b4.q, r
estimates store pARDL44
reg del L(1/2).del L.PERMIT b4.q, r
estimates store pARDL21
reg del L(1/4).del L(1/4).HOUST b4.q, r
estimates store hARDL44
reg del L(1/2).del L.HOUST b4.q, r
estimates store hARDL21

estimates stats uARDL42 uARDL22 mARDL43 mARDL41 pARDL44 pARDL21 hARDL44 hARDL21
