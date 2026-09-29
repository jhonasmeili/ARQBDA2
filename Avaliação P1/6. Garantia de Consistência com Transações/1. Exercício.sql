--Executar dentro da conexão TSEAdmin
--Alteração do número de um partido
INSERT INTO PARTIDO VALUES (18, (SELECT SIGLA_PARTIDO FROM PARTIDO WHERE NUMERO_PARTIDO = 13), (SELECT NOME_PARTIDO FROM PARTIDO WHERE NUMERO_PARTIDO = 13));
--Criação do novo registro do partido, com sigla e nome iguais, mas com o novo número
UPDATE VOTOS SET NUMERO_PARTIDO = 18 WHERE NUMERO_PARTIDO = 13;
--Atualização dos registros na tabela voto para o novo numero de seu respectivo partido
DELETE FROM PARTIDO WHERE NUMERO_PARTIDO = 13;
--Exclusão do registro antigo do partido

SELECT * FROM PARTIDO;
SELECT * FROM VOTOS;
--Visualização e verificação

COMMIT;
--Commit
--ROLLBACK deve ser executado caso o número antigo do partido seja digitado incorrertamente, de forma alterar os registros de outro partido
--Ou caso o número novo do partido seja digitado incorretamente, de forma a alterar os registros de outro partido, ou a simplesmente passar os registros para um número inválido

