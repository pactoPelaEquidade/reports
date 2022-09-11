EXPORT DATA
  OPTIONS (
    uri = 'gs://pacto-report-women/data/*.parquet',
    format = 'parquet',
    overwrite = true)
AS (
SELECT sigla_uf, valor_remuneracao_media, subsetor_ibge, cbo_2002, idade, grau_instrucao_apos_2005, sexo, raca_cor
FROM `basedosdados.br_me_rais.microdados_vinculos`
WHERE ano=2020
-- LIMIT 65921194
LIMIT 100000
);
