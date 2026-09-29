--Executar dentro da conexão system
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

drop user TSEAdmin cascade;
create user TSEAdmin identified by tseroot;
grant all privileges to TSEAdmin;
--Administrador geral do sistema, possui posse das tabelas
--Também incluido como parte do Exercício 5
