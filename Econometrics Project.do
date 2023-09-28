*Install asdoc
ssc install asdoc

*Drop Unneccessary Variable
drop CountryCode 

*Generate Code for Countries
egen CountryID = group( CountryName )

*Viewing Data
describe CountryName Time divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight AvgMarrDur Wagegap Divorce


summarize CountryName Time divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight AvgMarrDur Wagegap Divorce

*Set as panel data
xtset CountryID Time
xtdescribe
xtsum CountryID Time divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight AvgMarrDur Wagegap Divorce
****************************************************************
***** Pooled OLS, between, and first differences estimator Model 1*****
****************************************************************

* Pooled OLS estimator
reg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight

predict residuals1, resid
histogram residuals1, kdensity normal
hettest

* Between estimator
xtreg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight, be

* Fixed effects within estimator
xtreg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight, fe robust

* Predict and summarize the individual specific effects a_i
* Stata denotes the individual specific effects as u
predict ai, u
list CountryID Time Divorce ai in 1/9
summarize ai

**************************************
***** Dummy variables regression *****
**************************************

* Sorting data
sort CountryID

* Dummy variables regression with fixed effects
reg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight i.CountryID

*A dummy variable for each CountryID

* R-squared for fixed effects estimator and dummy variables regression
xtreg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight i.CountryID, fe
display e(mss)
display e(rss)
scalar rsquared0=e(mss)/(e(mss)+e(rss))
display rsquared0 


* Random effects estimator
xtreg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight, re robust


********************************************************
***** Hausman test for fixed versus random effects *****
********************************************************
* The Hausman test is used to decide whether to use fixed effects or random effects.
* H0: FE coefficients are not significantly different from the RE coefficients
* Ha: FE coefficients are significantly different from the RE coefficients

* Fixed effects estimator
xtreg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight, fe 
estimates store fixed

* Random effects estimator
xtreg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight, re
estimates store random

* Hausman test for fixed versus random effects
hausman fixed random
hausman fixed random, sigmamore

* Panel correlation test
ssc install xttest2
xtreg Divorce divorceright householdhead jobright Ageatfirstmarrm Ageatfirstmarrf schoolingyrsf schoolingyrsm LFparticipf LFparticipm LFf FertilityRate RemarrRight, fe
xttest2
***************************************************************************
* Graphs
xtline (Divorce)
xtline FertilityRate
xtline AvgMarriageDuration
xtline Ageatfirstmarriagemale Ageatfirstmarriagefemale
xtline Laborforceparticipationrate Laborforcefemale
