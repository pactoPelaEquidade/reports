CREATE TEMP TABLE microdados (sexo STRING, cor STRING, subsetor_ibge STRING, valor_remuneracao_media FLOAT64)
AS
(SELECT
CASE
	WHEN sexo='1' THEN 'Homem'
	WHEN sexo='2'THEN 'Mulher'
	ELSE 'Outro'
END AS sexo,
CASE
  WHEN raca_cor='2' THEN 'Branca'
  WHEN raca_cor='4' THEN 'Negro'
  WHEN raca_cor='8' THEN 'Negro'
  ELSE 'Outro'
END AS cor,
CASE
	WHEN subsetor_ibge='01' THEN 'Extrativa mineral'
	WHEN subsetor_ibge='02' THEN 'Indústria de produtos minerais nao metálicos'
	WHEN subsetor_ibge='03' THEN 'Indústria metalúrgica'
	WHEN subsetor_ibge='04' THEN 'Indústria mecânica'
	WHEN subsetor_ibge='05' THEN 'Indústria do material elétrico e de comunicaçoes'
	WHEN subsetor_ibge='06' THEN 'Indústria do material de transporte'
	WHEN subsetor_ibge='07' THEN 'Indústria da madeira e do mobiliário'
	WHEN subsetor_ibge='08' THEN 'Indústria do papel, papelao, editorial e gráfica'
	WHEN subsetor_ibge='09' THEN 'Ind. da borracha, fumo, couros, peles, similares, ind. diversas'
	WHEN subsetor_ibge='10' THEN 'Ind. química de produtos farmacêuticos, veterinários, perfumaria'
	WHEN subsetor_ibge='11' THEN 'Indústria têxtil do vestuário e artefatos de tecidos'
	WHEN subsetor_ibge='12' THEN 'Indústria de calçados'
	WHEN subsetor_ibge='13' THEN 'Indústria de produtos alimentícios, bebidas e álcool etílico'
	WHEN subsetor_ibge='14' THEN 'Serviços industriais de utilidade pública'
	WHEN subsetor_ibge='15' THEN 'Construçao civil'
	WHEN subsetor_ibge='16' THEN 'Comércio varejista'
	WHEN subsetor_ibge='17' THEN 'Comércio atacadista'
	WHEN subsetor_ibge='18' THEN 'Instituiçoes de crédito, seguros e capitalizaçao'
	WHEN subsetor_ibge='19' THEN 'Com. e administraçao de imóveis, valores mobiliários, serv. Técnico'
	WHEN subsetor_ibge='20' THEN 'Transportes e comunicaçoes'
	WHEN subsetor_ibge='21' THEN 'Serv. de alojamento, alimentaçao, reparaçao, manutençao, redaçao'
	WHEN subsetor_ibge='22' THEN 'Serviços médicos, odontológicos e veterinários'
	WHEN subsetor_ibge='23' THEN 'Ensino'
	WHEN subsetor_ibge='24' THEN 'Administraçao pública direta e autárquica'
	WHEN subsetor_ibge='25' THEN 'Agricultura, silvicultura, criaçao de animais, extrativismo vegetal'
	WHEN subsetor_ibge='26' THEN 'Ignorado'
END AS subsetor_ibge,
valor_remuneracao_media
FROM `basedosdados.br_me_rais.microdados_vinculos` 
WHERE ano=2020
AND raca_cor NOT IN ('9', '-1')
AND sexo IN ('1', '2')
AND grau_instrucao_apos_2005 IN ('9', '10', '11'));

EXPORT DATA
  OPTIONS (
    uri = 'gs://pacto-report-women/setor_superior/*.parquet',
    format = 'parquet',
    overwrite = true) AS
(
SELECT pop_group, subsetor_ibge, COUNT(*) AS total, ANY_VALUE(mean_wage) AS mean_wage
FROM (
SELECT 
CONCAT(sexo, '-', cor) AS pop_group, 
subsetor_ibge,
AVG(valor_remuneracao_media) OVER (PARTITION BY subsetor_ibge) AS mean_wage
FROM microdados
WHERE cor !='Outro')
GROUP BY pop_group, subsetor_ibge
LIMIT 100)



