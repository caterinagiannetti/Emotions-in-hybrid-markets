
*** Cohen for self

file open summarystat using cohen.tex, write replace
file write summarystat "\begin{tabular}{|r|cc|}" _n
file write summarystat "{\bf Variable}& {\bf cohen}    \\\ \hline" _n


foreach var of varlist mg_playerfelice-mg_self_valence {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Humans", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat "  & [`ld`var'' ,  `ud`var'' ]   \\\"  _n


 }

 

 
foreach var of varlist mg_playerfelice-mg_self_valence {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Equal", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat " &  [ `ld`var'' ,  `ud`var'' ]   \\\"  _n



 }

 
foreach var of varlist mg_playerfelice-mg_self_valence {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Minority", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat " & [ `ld`var'' ,  `ud`var'' ]   \\\"  _n


 }
 
 
 file write summarystat "\end{tabular}" _n
file close summarystat
	
	


****cohen for facial 

file open summarystat using cohen.tex, write replace
file write summarystat "\begin{tabular}{|r|cc|}" _n
file write summarystat "{\bf Variable}& {\bf cohen}    \\\ \hline" _n


foreach var of varlist mg_m_fear-mg_m_valence_check {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Humans", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat "  & [`ld`var'' ,  `ud`var'' ]   \\\"  _n


 }

 

 
foreach var of varlist mg_m_fear-mg_m_valence_check {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Equal", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat " &  [ `ld`var'' ,  `ud`var'' ]   \\\"  _n



 }

 
foreach var of varlist mg_m_fear-mg_m_valence_check {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Minority", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat " & [ `ld`var'' ,  `ud`var'' ]   \\\"  _n


 }
 
 
 file write summarystat "\end{tabular}" _n
file close summarystat
	
	
*********** cohen for phsyio. mg_relative_maxtonic-mg_relative_EDAsymp_HFnu
	
file open summarystat using cohen.tex, write replace
file write summarystat "\begin{tabular}{|r|cc|}" _n
file write summarystat "{\bf Variable}& {\bf cohen}    \\\ \hline" _n


foreach var of varlist mg_relative_maxtonic-mg_relative_EDAsymp_HFnu {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Humans", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat "  & [`ld`var'' ,  `ud`var'' ]   \\\"  _n


 }

 

 
foreach var of varlist mg_relative_maxtonic-mg_relative_EDAsymp_HFnu {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Equal", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat " &  [ `ld`var'' ,  `ud`var'' ]   \\\"  _n



 }

 
foreach var of varlist mg_relative_maxtonic-mg_relative_EDAsymp_HFnu {
esize twosample `var' if ind_obs==1 & round!=0 &  treatment!="Minority", by(treatment)
local cohen`var'=round(r(d),0.001)
local ld`var'=round(r(lb_d),0.001)
local ud`var'=round(r(ub_d),0.001)
*display "cohen `var': `cohen`var'''"
file write summarystat " `var' &  `cohen`var''    \\\"  _n
file write summarystat " & [ `ld`var'' ,  `ud`var'' ]   \\\"  _n


 }
 
 
 file write summarystat "\end{tabular}" _n
file close summarystat
