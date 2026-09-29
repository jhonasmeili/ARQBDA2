--Executar dentro da conexão TSEAdmin
CREATE OR REPLACE VIEW votos_por_uf AS SELECT NOME_UF AS UF, NOME_PARTIDO AS "Partido", SUM(VOTOS) AS "Total de Votos"
FROM UF INNER JOIN MUNICIPIO USING (ID_UF)
INNER JOIN VOTOS USING(ID_MUNICIPIO)
INNER JOIN PARTIDO USING (NUMERO_PARTIDO)
GROUP BY NOME_UF, NOME_PARTIDO;
--Cria uma view que agrega todos os votos em um partido por estado
--Garante uma visão geral sobre os resultados das votações em cada estado

SELECT * FROM votos_por_uf;
--Vizualisa os dados da view





