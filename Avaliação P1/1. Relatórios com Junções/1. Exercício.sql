--Executar dentro da conexão TSEAdmin
SELECT NOME_UF, NOME_MUNICIPIO, SIGLA_PARTIDO, VOTOS
FROM UF INNER JOIN MUNICIPIO USING(ID_UF)
LEFT JOIN VOTOS USING (ID_MUNICIPIO)
LEFT JOIN PARTIDO USING (NUMERO_PARTIDO)
ORDER BY NOME_UF, NOME_MUNICIPIO;
--Mostra nome do município, nome da UF a qual pertence, e quantos votos foram contabilizados para quais partidos
--incluindo registros de municípios que ainda não contabilizaram seus votos