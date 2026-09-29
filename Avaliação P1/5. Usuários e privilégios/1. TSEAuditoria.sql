--Executar dentro da conexão system
DROP USER TSEAuditoria CASCADE;
CREATE USER TSEAuditoria IDENTIFIED BY tseaud;
GRANT CONNECT, CREATE SESSION TO TSEAuditoria;
--Usuário de auditoria com baixos privilégios

GRANT DELETE ON TSEAdmin.VOTOS TO TSEAuditoria;
--Permissão concedida para próposito de revogação