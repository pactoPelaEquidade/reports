EXPORT DATA
  OPTIONS (
    uri = 'gs://pacto-report-women/wage_gap/*.parquet',
    format = 'parquet',
    overwrite = true) AS
SELECT *
FROM (
    WITH microdados AS (
    SELECT 
    ano, 
    CASE
      WHEN sexo='1' THEN 'Homem'
      WHEN sexo='2' THEN 'Mulher'
      ELSE 'other'
    END AS sexo,
    CASE
      WHEN raca_cor='1' THEN 'Indigena'
      WHEN raca_cor='2' THEN 'Branca'
      WHEN raca_cor='4' THEN 'Negro'
      WHEN raca_cor='8' THEN 'Negro'
      ELSE 'other'
    END AS cor,
    valor_remuneracao_media
    FROM `basedosdados.br_me_rais.microdados_vinculos`
    WHERE ano>=2010
    AND raca_cor IN ('1', '2', '4', '8')
    AND sexo IN ('1', '2')
  )
  SELECT *
  FROM (
    SELECT 
    ano, 
    CONCAT(sexo, '_',cor) AS extrato,
    valor_remuneracao_media,
    FROM microdados
    ORDER BY ano, extrato)
  PIVOT (AVG(valor_remuneracao_media) FOR extrato IN ("Homem_Negro", "Mulher_Branca", "Mulher_Indigena", "Homem_Indigena", "Mulher_Negro", "Homem_Branca"))
  ORDER BY ano
)
LIMIT 11