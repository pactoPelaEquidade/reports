WITH microdados as (
  SELECT ano,
  CASE
    WHEN idade>=14 AND idade<=19 THEN 'A'
    WHEN idade>=20 AND idade<=24 THEN 'B'
    WHEN idade>=25 AND idade<=29 THEN 'C'
    WHEN idade>=30 AND idade<=34 THEN 'D'
    WHEN idade>=35 AND idade<=39 THEN 'E'
    WHEN idade>=40 AND idade<=44 THEN 'F'
    WHEN idade>=45 AND idade<=54 THEN 'G'
    WHEN idade>=54 AND idade<=59 THEN 'H'
    WHEN idade>=60 THEN 'I'
    ELSE 'nao_informado'
  END
  AS age_group
  FROM `basedosdados.br_me_rais.microdados_vinculos`
  WHERE sexo='2'
  AND ano>=2010
  AND (raca_cor='4' OR raca_cor='8'))

SELECT *
FROM microdados
PIVOT (COUNT(*) FOR age_group IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'))
ORDER BY ano