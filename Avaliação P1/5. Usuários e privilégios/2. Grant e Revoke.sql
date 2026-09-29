--Executar apenas após executar o Exercício 4
--Executar dentro da conexão TSEAdmin
GRANT SELECT ON votos_por_uf TO TSEAuditoria;
--Estabelecimento de permissão para visualizar a view

REVOKE DELETE ON VOTOS FROM TSEAuditoria;
--Remoção da permissão delete do usuário TSEAuditoria em uma tabela crítica do sistema