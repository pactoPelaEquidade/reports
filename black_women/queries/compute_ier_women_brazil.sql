BEGIN
CREATE TEMP TABLE table_indexrs (ano INT64, cbo STRING, index_rs FLOAT64, rem_media FLOAT64)
AS
(SELECT
ano,
cbo,
pacto_equidade.compute_indexrs(black_prop, prop_negra) AS index_rs,
rem_media
FROM
((SELECT 
ano, 
cbo, 
COALESCE(branca, 0) AS branca, 
COALESCE(preta, 0) AS preta,
COALESCE(parda, 0) AS parda,
COALESCE(branca, 0)+COALESCE(preta, 0)+COALESCE(parda, 0) AS total,
(COALESCE(preta, 0)+COALESCE(parda, 0))/(COALESCE(branca, 0)+COALESCE(preta, 0)+COALESCE(parda, 0)) AS black_prop,
rem_media
FROM `pacto-equidade.pacto_equidade.pivoted_rais_women_brazil`) AS A 
LEFT JOIN (
SELECT*, 0.5*SAFE_DIVIDE(preta+parda, preta+parda+branca) AS prop_negra
FROM
(SELECT year,
    SUM(branca) AS branca,
    SUM(preta) AS preta,
    SUM(parda) AS parda,
FROM `pacto-equidade.pacto_equidade_staging.populacao`
GROUP BY year
ORDER BY year)
  ) AS B
  ON A.ano=B.year));

CREATE TEMP TABLE wage_prop (ano INT64, cbo STRING, index_rs FLOAT64, wage_prop_nao_lideranca FLOAT64, wage_prop_gerencia FLOAT64, wage_prop_diretoria FLOAT64)
AS
SELECT 
COALESCE(A.ano, B.ano, C.ano) AS ano, 
COALESCE(A.cbo, B.cbo, C.cbo) AS cbo,
COALESCE(A.index_rs, B.index_rs, C.index_rs) AS index_rs,
wage_prop_nao_lideranca,
wage_prop_gerencia,
wage_prop_diretoria
  FROM
  ((SELECT *, SAFE_DIVIDE(rem_media,(SUM(rem_media) OVER (PARTITION BY ano))) as wage_prop_nao_lideranca
  FROM table_indexrs
  WHERE SUBSTRING(cbo,1,2)!="12"
  AND SUBSTRING(cbo,1,2)!="14") AS A
  FULL OUTER JOIN
  (SELECT ano,  cbo, index_rs, SAFE_DIVIDE(rem_media,(SUM(rem_media) OVER (PARTITION BY ano))) as wage_prop_gerencia
  FROM table_indexrs
  WHERE SUBSTRING(cbo,1,2)="14") AS B
  ON A.ano=B.ano
  AND A.cbo=B.cbo
  FULL OUTER JOIN
  (SELECT ano,  cbo, index_rs, SAFE_DIVIDE(rem_media,(SUM(rem_media) OVER (PARTITION BY ano))) as wage_prop_diretoria
  FROM table_indexrs
  WHERE SUBSTRING(cbo,1,2)="12") AS C
  ON A.ano=C.ano
  AND A.cbo=C.cbo)
ORDER BY ano,  cbo;
CREATE OR REPLACE TABLE `pacto-equidade.pacto_equidade_analytics.ieer_women_brazil` (ano INT64,IEER_nao_lideranca FLOAT64, IEER_gerencia FLOAT64, IEER_diretoria FLOAT64)
AS
SELECT 
ano,  
SUM(index_rs*wage_prop_nao_lideranca) AS IEER_nao_lideranca,
SUM(index_rs*wage_prop_gerencia) AS IEER_gerencia,
SUM(index_rs*wage_prop_diretoria) AS IEER_diretoria
FROM wage_prop
GROUP BY ano;
END;