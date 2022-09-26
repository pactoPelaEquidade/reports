EXPORT DATA
  OPTIONS (
    uri = 'gs://pacto-report-women/data/*.parquet',
    format = 'parquet',
    overwrite = true)
AS (
  SELECT 
    sigla_uf, 
    V4002 AS is_ocupado, 
    VD3005 AS education, 
    V2009 AS age, 
    V2007 AS male,
    V2010 AS color,
    V1028 AS peso,
  FROM `basedosdados.br_ibge_pnadc.microdados`
  WHERE ano=2022
  AND trimestre=2
)