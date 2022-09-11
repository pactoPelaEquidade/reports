EXPORT DATA
  OPTIONS (
    uri = 'gs://pacto-report-women/education_groups/*.parquet',
    format = 'parquet',
    overwrite = true)
AS (
WITH microdados as (
  SELECT ano, education
  FROM
  (SELECT ano, sexo, raca_cor, grau_instrucao_apos_2005
  FROM `basedosdados.br_me_rais.microdados_vinculos`
  WHERE sexo='2'
  AND ano>=2010
  AND (raca_cor='4' OR raca_cor='8')) AS A
  LEFT JOIN (
    SELECT chave, 
    CASE 
      WHEN valor='MEDIO COMPL' THEN 'medio_completo'
      WHEN valor='5.A CO FUND' THEN 'primario_completo'
      WHEN valor='FUND COMPL' THEN 'fundamental_completo'
      WHEN valor='SUP. COMP' THEN 'superior_completo'
      WHEN valor='ATE 5.A INC' THEN 'primario_incompleto'
      WHEN valor='6. A 9. FUND' THEN 'fundamental_incompleto'
      WHEN valor='MEDIO INCOMP' THEN 'medio_incompleto'
      WHEN valor='SUP. INCOMP' THEN 'superior_incompleto'
      WHEN valor='ANALFABETO' THEN 'analfabeto'
      WHEN valor='MESTRADO' THEN 'mestrado'
      WHEN valor='DOUTORADO' THEN 'doutorado'
    ELSE 'nao_informado'
    END AS education
    FROM `basedosdados.br_me_rais.dicionario`
    WHERE nome_coluna='grau_instrucao_apos_2005'
  ) AS B
  ON A.grau_instrucao_apos_2005=B.chave
)

SELECT *
FROM microdados
PIVOT (COUNT(*) FOR education IN ('medio_completo', 'primario_completo', 'fundamental_completo', 'superior_completo', 'primario_incompleto', 'fundamental_incompleto', 'medio_incompleto', 'superior_incompleto', 'analfabeto', 'mestrado', 'doutorado'))
ORDER BY ano)

