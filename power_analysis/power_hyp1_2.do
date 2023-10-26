use "/Users/caterinagiannnetti/Dropbox (Salvati)/Michalis/Emotions_measurement/DATA/do_files/Power_Hyp4/dataset_hyp4.dta", clear


******* HYP 1
sum rad_a  if treatment=="Humans"
sum rad_a if treatment=="Minority"
sum rad_a if treatment=="Equal"


power twomeans 0.35 1.94
power twomeans 1.30 1.94
power twomeans 1.30 1.94, power(0.95)

*******HYP 2

sum mg_relative_meantonic if treatment=="Humans"
sum mg_relative_meantonic if treatment=="Minority"
sum mg_relative_meantonic if treatment=="Equal"

power twomeans 0.37 0.36
power twomeans 0.36 0.65
power twomeans 0.36 0.65, power(0.95)

sum mg_relative_ampsum if treatment=="Humans"
sum mg_relative_ampsum if treatment=="Minority"
sum mg_relative_ampsum  if treatment=="Equal"


power twomeans -2.91 -8.76
power twomeans -7.24 -8.76
power twomeans -7.24 -8.76, power(0.95)


sum mg_relative_edasymp if treatment=="Humans"
sum mg_relative_edasymp if treatment=="Minority"
sum mg_relative_edasymp if treatment=="Equal"


power twomeans 4.927 6.165
power twomeans 3.069 4.927 
power twomeans 3.069 4.927, power(0.95)
