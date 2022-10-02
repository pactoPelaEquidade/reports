import delimited /home/dell/Documents/pacto/reports/black_women/data/pnadc.csv, clear

* Controlando a idade
gen idade = v2009
keep if idade >=14 & idade<=65
* Deixando apenas ocupados na base de dados
keep if vd4002==1
* Deixando apenas os Assalariados
tab vd4009
drop if vd4009>=8

* Controlando missings de rendimento e horas
gen rendimento = vd4016
gen horas = v4039
drop if rendimento ==.
drop if horas==.
sum rendimento horas

//BRASIL
preserve
collapse (mean) rendimento [iw=v1028], by(v2010 v2007)
export delimited /home/dell/Documents/pacto/reports/black_women/data/rendimento_cor_sexo_brasil.csv, replace
restore

//REGIOES AGG
preserve
collapse (mean) rendimento [iw=v1028], by(v2010 regiao)
export delimited /home/dell/Documents/pacto/reports/black_women/data/rendimento_cor_regions.csv, replace
restore

//REGIOES MALE-FEMALE
preserve
collapse (mean) rendimento [iw=v1028], by(v2010 v2007 regiao)
export delimited /home/dell/Documents/pacto/reports/black_women/data/rendimento_cor_sexo_regions.csv, replace
restore

// //CENTILES
// preserve
// keep if v2010=="Branca" | v2010=="Negro"
// egen inc100 = xtile(rendimento), by(v2010 v2007) p(1(1)99)
// collapse (max) rendimento [iw=v1028], by(inc100 v2010 v2007)
// export delimited /home/dell/Documents/pacto/reports/black_women/data/rendimento_centis.csv, replace
// restore
//
// //DECIS
// preserve
// keep if v2010=="Branca" & v2007==1
// egen inc100 = xtile(rendimento), p(10(10)90)
// collapse (mean) rendimento [iw=v1028], by(inc100)
// export delimited /home/dell/Documents/pacto/reports/black_women/data/rendimento_decis.csv, replace
// restore

sum rendimento [aweigh=v1028] if v2010=="Branca" & v2007==1, detail
sum rendimento [aweigh=v1028] if v2010=="Branca" & v2007==2, detail
sum rendimento [aweigh=v1028] if v2010=="Negro" & v2007==1, detail
sum rendimento [aweigh=v1028] if v2010=="Negro" & v2007==2, detail

