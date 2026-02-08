* STATA CODE
* Don't forget to install causaldata with ssc install causaldata, if you haven't yet.
ssc install causaldata
which causaldata
* C:\Users\wxs2002\ado\plus\c\causaldata.ado
* *! causaldata v.0.1.7 causaldata package information screen. 25oct2024 by Nick CH-K
help causaldata
cd "D:\StataProjects\The Effect-An Introduction to Research Design and Causality\data_sets\"
causaldata Mroz.dta, use clear download
describe lfp
label list lfp
codebook lfp
* Keep just working women
keep if lfp==1
describe lwg
codebook lwg
* Get unlogged earnings
g earn = exp(lwg)
* Drop negative other earnings
describe inc
codebook inc
list inc if inc < 0
drop if inc < 0

* 1. Draw a scatterplot
twoway scatter earn inc, yscale(log) xscale(log)
twoway scatter lwg loginc

* 2. Get the conditional mean college attendance
* Note the syntax is different in older versions of Stata, see help table
table wc, stat(mean earn)

* 3. Get the conditional mean by bins
* Get the cut variable with ten groups
egen inc_cut = cut(inc), group(10) label
table inc_cut, stat(mean earn)

* 4. Draw the LOESS and linear regression curves
* Creat the logs manually for the fitted lines
g loginc = log(inc)
twoway (scatter lwg loginc)(lowess lwg loginc)
twoway (scatter lwg loginc)(lfit lwg loginc)

* 5. Run a linear regression, by itself and including controls
reg lwg loginc
reg lwg loginc wc k5