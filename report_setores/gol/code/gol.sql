(
WITH first_table AS -- gol
(SELECT
    cnpj,
    CASE 
        WHEN occupation_group = 'Diretoria'     THEN 'diretoria'
        WHEN occupation_group = 'Gerência'      THEN 'gerencia'
        WHEN occupation_group = 'Não-Liderança' THEN 'nao_lideranca'
    END AS grupo, 
    ieer,
    ieer_ponderado
FROM `pacto-equidade.pacto_equidade_analytics.gol`
)
SELECT 
    cnpj,
    ROUND(ieer_diretoria,     3) AS ieer_diretoria,
    ROUND(ieer_gerencia,      3) AS ieer_gerencia,
    ROUND(ieer_nao_lideranca, 3) AS ieer_nao_lideranca,
    ROUND(ieer_ponderado,     3) AS ieer_ponderado	
FROM first_table
PIVOT 
    (MAX(ieer) AS ieer FOR grupo IN ('diretoria', 'gerencia', 'nao_lideranca'))
)

UNION ALL

(

WITH first_table AS -- gol filiais

(    
    SELECT
        cnpj,
        CASE
            WHEN occupation_group = 'Diretoria'     THEN 'diretoria'
            WHEN occupation_group = 'Gerência'      THEN 'gerencia'
            WHEN occupation_group = 'Não-Liderança' THEN 'nao_lideranca' 
        END AS grupo,
        ieer
FROM `pacto-equidade.pacto_equidade.gol_filiais` 
)
SELECT 
    cnpj,
    ROUND(ieer_diretoria,     3) AS ieer_diretoria,  
    ROUND(ieer_gerencia,      3) AS ieer_gerencia,
    ROUND(ieer_nao_lideranca, 3) AS ieer_nao_lideranca,
    ROUND((ieer_diretoria + ieer_gerencia + ieer_nao_lideranca)/3, 2) AS ieer_ponderado
FROM first_table
    PIVOT 
    (MAX (ieer) AS ieer FOR grupo IN ('diretoria', 'gerencia', 'nao_lideranca'))
)