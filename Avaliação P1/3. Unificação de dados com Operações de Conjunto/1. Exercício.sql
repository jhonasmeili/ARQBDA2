--Executar dentro da conexão TSEAdmin
SELECT ID_REGIAO AS "ID", NOME_REGIAO AS "Nome"FROM REGIAO
UNION
SELECT ID_UF, NOME_UF FROM UF
UNION
SELECT ID_MUNICIPIO, NOME_MUNICIPIO FROM MUNICIPIO;
--Retorna uma tabela com todas as subdivisões (ID e nome) que podem ter votos contabilizados