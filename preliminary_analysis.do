
***change to your directory
cd "/Users/caterinagiannnetti/Dropbox (Salvati)/Michalis/Emotions_measurement/DATA/"
global tab_folder="/Users/caterinagiannnetti/Dropbox (Salvati)/Michalis/Emotions_measurement/DATA/TABLE"

set more off

use dataset_complete_prima_parte.dta, clear

egen treat=group(treatment)
label define treatlabel 1 "Equal" 2 "Humans" 3 "Minority"
label values treat treatlabel

* gen valence self-report
gen self_valence= playerfelice-((playerdisgustato+ playerspaventato + playertriste)/3)

egen group_id=group(sessioncode group)
egen participant_id=group(participantcode)

rename subsessionround_number round


***create an indicator for ind_obs
bys sessioncode group_id round: gen ind_obs=1 if _n==1 & (treatment=="Equal")
bys sessioncode group_id round: replace ind_obs=1 if _n==1 & (treatment=="Humans")
bys sessioncode participantcode round: replace ind_obs=1 if _n==1 & treatment=="Minority" 
/*tab ind_obs if round==1 & treatment=="Humans"
tab ind_obs if round==1 & treatment=="Equal"
tab ind_obs if round==1 & treatment=="Minority"*/


drop _merge
rename groupid_in_subsession groupid

merge n:n treatment sessioncode groupid round using "/Users/caterinagiannnetti/Dropbox (Salvati)/Michalis/Emotions_measurement/DATA/dati_mercato/mex_files/dati_mex.dta"

* partecipanti eliminati /*trattamento minority*/
drop if _merge==2
*_merge=1 round ==0 e un gruppo round 12 non ha fatto trading in humans
*tab sessioncode round  if _merge==1 & round!=0

**average media self-report per gruppo
foreach var of varlist playerfelice-playerannoiato self_valence {
 egen mg_`var'=mean(`var'), by(group_id  round)

 }

eststo clear 
  ***regression
foreach var of varlist playerfelice-playerannoiato self_valence {
 regress mg_`var' ibn.treat if ind_obs==1 & (round==5 | round==10 | round==15), noconstant
 /*equal vs humans*/
 eststo `var'
test _b[1bn.treat]= _b[2.treat] 
/*humans vs minority*/
test  _b[2.treat]= _b[3.treat] 
/*minority vs Equal*/
test  _b[3.treat]= _b[1bn.treat] 
 }
 
 esttab using "$tab_folder/meancomparisons_self.tex",  ar2 nostar label  replace

 eststo clear
 estpost ttest  mg_playerfelice-mg_self_valence if ind_obs==1 & round!=0 &  treatment!="Humans", by(treatment)
eststo EqualMinority
 estpost ttest  mg_playerfelice-mg_self_valence if ind_obs==1 & round!=0 &  treatment!="Equal", by(treatment)
eststo HumansMinority
 estpost ttest  mg_playerfelice-mg_self_valence if ind_obs==1 & round!=0 &  treatment!="Minority", by(treatment)
eststo EqualHumans
esttab using "$tab_folder/self_analysis.tex", replace
 
 
 

**average media facial per gruppo
foreach var of varlist m_fear-m_valence_check {
 sum `var'
 egen mg_`var'=mean(`var'), by(group_id round)

}

 
 eststo clear
 ***regression
foreach var of varlist m_fear-m_valence_check {
 regress mg_`var' ibn.treat if ind_obs==1 & round!=0, noconstant
 eststo `var'
 /*equal vs humans*/
test _b[1bn.treat]= _b[2.treat] 
/*humans vs minority*/
test  _b[2.treat]= _b[3.treat] 
/*minority vs Equal*/
test  _b[3.treat]= _b[1bn.treat] 
 }

 esttab using "$tab_folder/meancomparisons_face.tex",  ar2 nostar label replace
 
 
eststo clear

 estpost ttest  mg_m_fear-mg_m_valence_check if ind_obs==1 & round!=0 &  treatment!="Humans", by(treatment)
eststo EqualMinority
 estpost ttest  mg_m_fear-mg_m_valence_check if ind_obs==1 & round!=0 &  treatment!="Equal", by(treatment)
eststo HumansMinority
 estpost ttest  mg_m_fear-mg_m_valence_check if ind_obs==1 & round!=0 &  treatment!="Minority", by(treatment)
eststo EqualHumans
esttab using "$tab_folder/face_analysis.tex", replace
 
 
 
 
 
 **** physio data
 xtset participant_id round
 
gen byte baseround = 1 if round == 0 
gen EDAsymp_HF=edasymp/hf
gen EDAsymp_HFnu=edasymp/hfnu

foreach var of varlist maxtonic-sd2 EDAsymp_HF EDAsymp_HFnu {
 
bysort participant_id (baseround) : gen relative_`var' = `var' - `var'[1]
 }
 

**average media facial per gruppo
foreach var of varlist relative_maxtonic-relative_EDAsymp_HFnu {
 sum `var'
 egen mg_`var'=mean(`var'), by(group_id round)

 } 
 eststo clear
  ***regression
foreach var of varlist relative_maxtonic-relative_EDAsymp_HFnu{
 regress `var' ibn.treat if ind_obs==1 & round!=0, noconstant
 eststo `var'
 /*equal vs humans*/
test _b[1bn.treat]= _b[2.treat] 
/*humans vs minority*/
test  _b[2.treat]= _b[3.treat] 
/*minority vs Equal*/
test  _b[3.treat]= _b[1bn.treat] 
 }


esttab using "$tab_folder/meancomparisons_physio.tex",  ar2 nostar label replace

   
eststo clear
 estpost ttest mg_relative_maxtonic-mg_relative_EDAsymp_HFnu  if ind_obs==1 & round!=0 &  treatment!="Humans", by(treatment)
eststo EqualMinority
 estpost ttest  mg_relative_maxtonic-mg_relative_EDAsymp_HFnu if ind_obs==1 & round!=0 &  treatment!="Equal", by(treatment)
eststo HumansMinority
 estpost ttest  mg_relative_maxtonic-mg_relative_EDAsymp_HFnu if ind_obs==1 & round!=0 &  treatment!="Minority", by(treatment)
eststo EqualHumans
esttab using "$tab_folder/physio_analysis.tex", replace



**check correlation among measures




****dati di mercato

generate FV_A=(15-round+1)*0.12 + 1.80
generate FV_B=(15-round+1)*0 + 2.80

gen RAD_A=  average_priceA - FV_A
gen RAD_B=  average_priceB - FV_B

 eststo clear
 estpost ttest  RAD_A RAD_B if ind_obs==1 & round!=0 &  treatment!="Humans", by(treatment)
eststo EqualMinority
 estpost ttest  RAD_A RAD_B if ind_obs==1 & round!=0 &  treatment!="Equal", by(treatment)
eststo HumansMinority
 estpost ttest  RAD_A RAD_B if ind_obs==1 & round!=0 &  treatment!="Minority", by(treatment)
eststo EqualHumans
esttab using "$tab_folder/market_analysis.tex", replace




**********************************
* mediation analysis			 *
**********************************
rename RAD_B rad_b
rename RAD_A rad_a


keep if ind_obs==1 & round!=0
tab treat, gen(treat)

*set trace on

eststo clear
capture program drop te_direct te_indirect te_total
program te_direct, eclass
     quietly estat teffects
    mat b = r(direct)
    mat V = r(V_direct)
    local N = e(N)
    ereturn post b V, obs(`N')
    ereturn local cmd te_direct
    est store direct
end


program te_indirect, eclass
    quietly estat teffects
    mat b = r(indirect)
    mat V = r(V_indirect)
    ereturn post b V
    ereturn local cmd te_indirect
    est store indirect
end



program te_total, eclass
    quietly estat teffects
    mat b = r(total)
    mat V = r(V_total)
    ereturn post b V
    ereturn local cmd te_total
    est store total
end


eststo clear

***lf_hf

sem (rad_a <- mg_relative_lf_hf treat1 treat2) (mg_relative_lf_hf <-  treat1 treat2) 
est store maina
est store direct

est restore maina
te_indirect
est store indirect

est restore maina
te_total
est store total


estout  direct indirect  total using "$tab_folder/mediationlfhf.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccccccc}\hline\hline )  replace 


eststo clear

sem (rad_b <- mg_relative_lf_hf treat1 treat2) (mg_relative_lf_hf <-  treat1 treat2) 

est store mainb
est store direct

est restore mainb
te_indirect
est store indirect

est restore mainb
te_total
est store total


estout  direct indirect  total using "$tab_folder/mediationlfhf.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})   append

eststo clear

*****edasymp

sem (rad_a <- mg_relative_edasymp treat1 treat2) (mg_relative_edasymp <-  treat1 treat2) 
est store maina
est store direct

est restore maina
te_indirect
est store indirect

est restore maina
te_total
est store total


estout  direct indirect  total using "$tab_folder/mediationedasymp.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccccccc}\hline\hline )  replace 


sem (rad_b <- mg_relative_edasymp treat1 treat2) (mg_relative_edasymp <-  treat1 treat2) 
est store mainb
est store direct

est restore mainb
te_indirect
est store indirect

est restore mainb
te_total
est store total

estout  direct indirect  total using "$tab_folder/mediationedasymp.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})   append










eststo clear
*****meantonic

sem (rad_a <- mg_relative_meantonic treat1 treat2) (mg_relative_meantonic <-  treat1 treat2) 
est store maina
est store direct

est restore maina
te_indirect
est store indirect

est restore maina
te_total
est store total


estout  direct indirect  total using "$tab_folder/mediationmeantonic.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccccccc}\hline\hline )  replace 


sem (rad_b <- mg_relative_meantonic treat1 treat2) (mg_relative_meantonic <-  treat1 treat2) 
est store mainb
est store direct

est restore mainb
te_indirect
est store indirect

est restore mainb
te_total
est store total

estout  direct indirect  total using "$tab_folder/mediationmeantonic.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})   append




eststo clear
*****edasymp_hfnu

sem (rad_a <- mg_relative_EDAsymp_HFnu treat1 treat2) (mg_relative_EDAsymp_HFnu <-  treat1 treat2) 
est store maina
est store direct

est restore maina
te_indirect
est store indirect

est restore maina
te_total
est store total


estout  direct indirect  total using "$tab_folder/mediationedasymp_hfnu.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccccccc}\hline\hline )  replace 


sem (rad_b <- mg_relative_EDAsymp_HFnu treat1 treat2) (mg_relative_EDAsymp_HFnu <-  treat1 treat2) 
est store mainb
est store direct

est restore mainb
te_indirect
est store indirect

est restore mainb
te_total
est store total

estout  direct indirect  total using "$tab_folder/mediationedasymp_hfnu.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})   append



eststo clear
*****edasymp_valence

sem (rad_a <- mg_m_valence treat1 treat2) (mg_m_valence <-  treat1 treat2) 
est store maina
est store direct

est restore maina
te_indirect
est store indirect

est restore maina
te_total
est store total


estout  direct indirect  total using "$tab_folder/mediationvalence.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccccccc}\hline\hline )  replace 


sem (rad_b <- mg_m_valence treat1 treat2) (mg_m_valence <-  treat1 treat2) 
est store mainb
est store direct

est restore mainb
te_indirect
est store indirect

est restore mainb
te_total
est store total

estout  direct indirect  total using "$tab_folder/mediationvalence.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})   append



eststo clear
*****edasymp_anger

sem (rad_a <- mg_m_anger treat1 treat2) (mg_m_anger <-  treat1 treat2) 
est store maina
est store direct

est restore maina
te_indirect
est store indirect

est restore maina
te_total
est store total


estout  direct indirect  total using "$tab_folder/anger.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 ) prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccccccc}\hline\hline )  replace 


sem (rad_b <- mg_m_anger treat1 treat2) (mg_m_anger <-  treat1 treat2) 
est store mainb
est store direct

est restore mainb
te_indirect
est store indirect

est restore mainb
te_total
est store total

estout  direct indirect  total using "$tab_folder/anger.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})   append

*****************************
******testing hypothesis 3 **
*****************************

gen mg_m_valencesq=mg_m_valence^2
*set more on

eststo clear


 ***regression per treatment
 

foreach var of varlist  mg_relative_meantonic mg_relative_ampsum  mg_relative_edasymp {
 regress `var'  c.mg_m_valence##c.mg_m_valence if ind_obs==1 & treatment=="Humans",  noconstant
 /*equal vs humans*/
 eststo `var'
 
 
 sum `var' if ind_obs==1 & treatment=="Humans"
 local x_min=r(min)
 local x_max=r(max)
 local delta=trunc(r(sd))/2

*margins, dydx(mg_m_valence) at(mg_m_valence=(`x_min'(`delta')`x_max')) 
*marginsplot
*more
regress `var' mg_m_valence mg_m_valencesq if ind_obs==1 & treatment=="Humans",  noconstant
utest mg_m_valence mg_m_valencesq

  }
 estout   using "$tab_folder/valence.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )  prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lcccccc}\hline\hline \multicolumn{7}{l}{Overall}\tabularnewline )  replace 

 
 foreach var of varlist  mg_relative_meantonic mg_relative_ampsum  mg_relative_edasymp {
 regress `var'  c.mg_m_valence##c.mg_m_valence if ind_obs==1 & treatment=="Equal", noconstant
 /*equal vs humans*/
 eststo  `var'
 
  sum `var' if ind_obs==1 & treatment=="Equal"
 local x_min=r(min)
 local x_max=r(max)
 local delta=trunc(r(sd))/2

*margins, dydx(mg_m_valence) at(mg_m_valence=(`x_min'(`delta')`x_max')) 
*marginsplot
more
regress `var' mg_m_valence mg_m_valencesq if ind_obs==1 & treatment=="Equal", noconstant
utest mg_m_valence mg_m_valencesq
  }
 estout   using "$tab_folder/valence.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 ) append 
 *append prehead( \multicolumn{7}{l}{Equal}\tabularnewline)  
 
 foreach var of varlist  mg_relative_meantonic mg_relative_ampsum  mg_relative_edasymp {
 regress `var'  c.mg_m_valence##c.mg_m_valence if ind_obs==1 & treatment=="Minority", noconstant
 /*equal vs humans*/
 eststo `var'
  sum `var' if ind_obs==1 & treatment=="Minority"
 local x_min=r(min)
 local x_max=r(max)
 local delta=trunc(r(sd))/2

*margins, dydx(mg_m_valence) at(mg_m_valence=(`x_min'(`delta')`x_max')) 
*marginsplot
more
regress `var' mg_m_valence mg_m_valencesq if ind_obs==1 & treatment=="Minority", noconstant
utest mg_m_valence mg_m_valencesq
  }
  estout   using "$tab_folder/valence.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 ) append 
  *prehead( \multicolumn{7}{l}{AI-Majority}\tabularnewline)  postfoot(\end{tabular}   \end{table}) substitute(mgrelative )  


******testing hypothesis 3 - correlate
eststo clear
estpost correlate  mg_m_valence mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Humans",  bonferroni
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )    prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccc}\hline\hline )  replace 
estpost correlate  mg_m_valence mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Equal",  bonferroni 
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )   append
estpost correlate  mg_m_valence mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Minority",  bonferroni 
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})  append


eststo clear
estpost correlate  mg_m_valence_check mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Humans",  bonferroni
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )    prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccc}\hline\hline )  replace 
estpost correlate  mg_m_valence_check mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Equal",  bonferroni 
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )   append
estpost correlate  mg_m_valence_check mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Minority",  bonferroni 
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})  append

******phsyio and self

eststo clear
estpost correlate  mg_self_valence mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Humans",  bonferroni
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )    prehead( \begin{table}[htbp]\centering \caption{Estimation results:}\begin{tabular}{lccc}\hline\hline )  replace 
estpost correlate  mg_self_valence mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Equal",  bonferroni 
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )   append
estpost correlate  mg_self_valence mg_relative_lf_hf mg_relative_edasymp  mg_relative_EDAsymp_HF  if ind_obs==1 & treatment=="Minority",  bonferroni 
estout   using "$tab_folder/corr.tex",   style(tex) cells(b(star fmt(3)) se(par fmt(2)))  starlevels(* 0.10 ** 0.05 *** 0.01 )  postfoot(\hline \hline \footnotesize{*p<0.10,** p<0.05, ***p<0.01} \end{tabular}   \end{table})  append





regress mg_relative_ampsum c.mg_m_valence##c.mg_m_valence if ind_obs==1 & treatment=="Humans"
*predict yhat
twoway (line yhat  mg_m_valence if treatment=="Humans" & ind_obs==1, sort(mg_m_valence)) (scatter mg_relative_ampsum  mg_m_valence if treatment=="Humans" & ind_obs==1,  sort(mg_m_valence))
margins, dydx(mg_m_valence) at(mg_m_valence=(-0.20(0.05)0.20)) 
marginsplot


