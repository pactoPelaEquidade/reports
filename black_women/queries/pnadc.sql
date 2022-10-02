EXPORT DATA
  OPTIONS (
    uri = 'gs://pacto-report-women/pnadc/*.parquet',
    format = 'parquet',
    overwrite = true)
AS (
  SELECT 
    sigla_uf, 
    V4001,
    VD4002,
    VD3005,
    VD2002,
    VD4009,
    VD4016,
    V4039,
    V2009,
    V2007,
    V1022,
    CASE 
      WHEN V2010="1" THEN "Branca"
      WHEN V2010="2" THEN "Negro"
      WHEN V2010="3" THEN "Amarela"
      WHEN V2010="4" THEN "Negro"
      WHEN V2010="5" THEN "Indígena"
      WHEN V2010="9" THEN "Ignorado"
    END AS V2010,
    V1028,
    V403312
  FROM `basedosdados.br_ibge_pnadc.microdados`
  WHERE ano=2022
  AND trimestre=2
)