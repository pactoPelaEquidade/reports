CREATE OR REPLACE TABLE `pacto-equidade.pacto_equidade.pivoted_rais_women_brazil` (ano INT64, cbo STRING, branca INT64, preta INT64, parda INT64, indigena INT64, rem_media FLOAT64)
AS
SELECT 
A.ano as ano, 
cbo, 
COALESCE(branca,0) AS branca,
COALESCE(parda,0) AS parda,
COALESCE(preta,0) AS preta,
COALESCE(indigena,0) AS indigena,
rem_media
FROM 
    (SELECT ano,  cbo_2002 as cbo, COUNT(raca_cor) as branca
    FROM `basedosdados.br_me_rais.microdados_vinculos` 
    WHERE raca_cor='2'
    AND ano>=2010
    AND cbo_2002 IS NOT NULL 
    GROUP BY ano, cbo_2002) AS A
LEFT JOIN
    (SELECT ano,  cbo_2002, COUNT(raca_cor) as indigena
    FROM `basedosdados.br_me_rais.microdados_vinculos` 
    WHERE raca_cor='1'
    AND ano>=2010
    AND cbo_2002 IS NOT NULL 
    GROUP BY ano, cbo_2002) AS B
ON A.ano =B.ano
AND A.cbo = B.cbo_2002
LEFT JOIN
    (SELECT 
    ano,  cbo_2002, COUNT(raca_cor) as parda
    FROM `basedosdados.br_me_rais.microdados_vinculos` 
    WHERE raca_cor='8'
    AND sexo='2'
    AND ano>=2010
    AND cbo_2002 IS NOT NULL 
    GROUP BY ano,  cbo_2002) AS C
ON A.ano =C.ano
AND A.cbo = C.cbo_2002
LEFT JOIN
    (SELECT 
    ano,  cbo_2002, COUNT(raca_cor) as preta
    FROM `basedosdados.br_me_rais.microdados_vinculos` 
    WHERE raca_cor='4'
    AND sexo='2'
    AND ano>=2010
    AND cbo_2002 IS NOT NULL 
    GROUP BY ano,  cbo_2002) AS D
ON A.ano =D.ano
AND A.cbo = D.cbo_2002
LEFT JOIN 
    (SELECT 
    ano,  cbo_2002, AVG(valor_remuneracao_media) as rem_media
    FROM `basedosdados.br_me_rais.microdados_vinculos` 
    WHERE cbo_2002 IS NOT NULL
    AND ano>=2010
    GROUP BY ano,  cbo_2002) AS E
ON A.ano =E.ano
AND A.cbo = E.cbo_2002
ORDER BY ano, cbo