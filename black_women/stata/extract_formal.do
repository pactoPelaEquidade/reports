import delimited /home/dell/Documents/pacto/reports/black_women/data/pnadc.csv, clear

* Controlando a idade
gen idade = v2009
keep if idade >=14 & idade<=65
* Deixando apenas ocupados na base de dados
keep if vd4002==1

* Controlando missings de rendimento e horas
gen rendimento = vd4016
gen horas = v4039
drop if rendimento ==.
drop if horas==.

// formal vs informal
gen formal = 1 if vd4009==1 | vd4009==3 | vd4009==5 | vd4009==7
replace formal = 0 if vd4009==2 | vd4009==4 | vd4009==6 | vd4009==9
keep if formal!=.
table v2010 v2007 formal [iw=v1028], replace
export delimited /home/dell/Documents/pacto/reports/black_women/data/formal_informal.csv, replace

import delimited /home/dell/Documents/pacto/reports/black_women/data/pnadc.csv, clear

* Controlando a idade
gen idade = v2009
keep if idade >=14 & idade<=65
table v2010 v2007 vd4002 [iw=v1028], replace
export delimited /home/dell/Documents/pacto/reports/black_women/data/empregados_desempregados.csv, replace
