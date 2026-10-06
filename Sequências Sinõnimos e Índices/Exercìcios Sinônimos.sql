--1
CREATE SYNONYM HISTORICO FOR REGISTRO.historico_escolar;

--O usuário deve ter o privilégio CREATE PUBLIC SYNONYM, um privilégio de sistema

--2
GRANT SELECT ON vw_salarios_gerais TO usuario_auditoria;
CREATE SYNONYM salarios FOR vw_salarios_gerais;

--3
--O oracle procura pelo nome de um objeto em 3 etapas, objetos em um schema, sinônimos privados, depois públicos (e por ultimo outros schemas, caso se aplique)
--Utilizando-se do nome clientes, o primeiro objeto a ser encontrado seria o da própria tabela, ocultando então o sinônimo público

--4
CREATE PUBLIC SYNONYM vportugal FOR vendas@link_portugal;
--Caso a tabela vendas seja renomeada ou excluida, o sinônimo vai parar de funcionar, necessitando ser corrigido ou excluido

