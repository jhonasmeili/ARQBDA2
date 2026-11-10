ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
SET SERVEROUTPUT ON;

--1
CREATE OR REPLACE FUNCTION fn_total_municipios_uf(id_uf_f tab_uf.id_uf%TYPE) RETURN INT
IS
    total NUMBER;
BEGIN
    SELECT COUNT(*) INTO total FROM tab_municipio WHERE id_uf = id_uf_f;
    RETURN total;
END;
/

BEGIN
    DBMS_OUTPUT.put_line(fn_total_municipios_uf(35));
END;
/

--2
CREATE OR REPLACE FUNCTION fn_uf_pertence_regiao(id_uf_f tab_uf.id_uf%TYPE, id_regiao_f tab_regiao.id_regiao%TYPE) RETURN INT
IS
    verifica NUMBER;
BEGIN
    SELECT COUNT(*) INTO verifica FROM tab_uf WHERE id_uf = id_uf_f AND id_regiao = id_regiao_f;
    IF verifica > 0 THEN
        RETURN 1;
    END IF;
    RETURN 0;
END;
/

BEGIN
    DBMS_OUTPUT.put_line(fn_uf_pertence_regiao(11, 1));
END;
/

--3
CREATE OR REPLACE FUNCTION fn_get_localizacao_extenso(id_municipio_f tab_municipio.id_municipio%TYPE) RETURN VARCHAR2
IS
    nome_municipio VARCHAR2(50);
    nome_uf VARCHAR2(50);
    resultado VARCHAR2(100);
BEGIN
    SELECT tab_municipio.nome, tab_uf.nome INTO nome_municipio, nome_uf FROM tab_municipio INNER JOIN tab_uf USING (id_uf) WHERE id_municipio = id_municipio_f;
    SELECT nome_municipio || ' - ' || nome_uf INTO resultado FROM DUAL;
    RETURN resultado;
END;
/

BEGIN
    DBMS_OUTPUT.put_line(fn_get_localizacao_extenso(3503208));
END;
/

--4
CREATE OR REPLACE FUNCTION fn_qtd_municipios_homonimos(nome_municipio tab_municipio.nome%TYPE) RETURN INT
IS
    resultado INT;
BEGIN
    SELECT COUNT(*) INTO resultado FROM tab_municipio WHERE nome = nome_municipio;
    RETURN resultado;
END;
/

BEGIN
    DBMS_OUTPUT.put_line(fn_qtd_municipios_homonimos('Bom Jesus'));
END;
/

--5
CREATE OR REPLACE FUNCTION fn_regiao_por_municipio(id_municipio_f tab_municipio.id_municipio%TYPE) RETURN VARCHAR2
IS
    resultado tab_regiao.nome%TYPE;
BEGIN
    SELECT tab_regiao.nome INTO resultado FROM tab_municipio INNER JOIN tab_uf USING (id_uf) INNER JOIN tab_regiao USING (id_regiao) WHERE id_municipio = id_municipio_f;
    RETURN resultado;
END;
/

BEGIN
    DBMS_OUTPUT.put_line(fn_regiao_por_municipio(2927408));
END;
/

--6
CREATE OR REPLACE PROCEDURE pr_inserir_municipio (id_municipio_p tab_municipio.id_municipio%TYPE, nome_municipio tab_municipio.nome%TYPE, id_uf_p tab_uf.id_uf%TYPE)
IS
    teste tab_uf.id_uf%TYPE;
BEGIN
    SELECT id_uf INTO teste FROM tab_uf WHERE id_uf = id_uf_p;
    INSERT INTO tab_municipio (id_municipio, nome, id_uf) VALUES (id_municipio_p, nome_municipio, id_uf_p);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'UF Inexistente');
END;
/

EXECUTE pr_inserir_municipio(35001, 'Joânia', 60);
EXECUTE pr_inserir_municipio(60001, 'Elefantia', 60);

SELECT  * FROM tab_municipio WHERE id_municipio = 35001;
SELECT  * FROM tab_municipio WHERE id_municipio = 60001;

--7
CREATE OR REPLACE PROCEDURE pr_migrar_municipios_uf(id_uf_in tab_uf.id_uf%TYPE, id_uf_out tab_uf.id_uf%TYPE)
IS
BEGIN
    SAVEPOINT sv_pr_migrar_municipios_uf;
    UPDATE tab_municipio SET id_uf = id_uf_out WHERE id_uf = id_uf_in;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT sv_pr_migrar_municipios_uf;
        RAISE_APPLICATION_ERROR(-20002, 'Erro desconhecido');
END;
/

SELECT * FROM tab_uf;
SELECT COUNT(*) FROM tab_municipio WHERE id_uf = 32;
SELECT COUNT(*) FROM tab_municipio WHERE id_uf = 31;

EXECUTE pr_migrar_municipios_uf(32, 31);

--8
CREATE OR REPLACE PROCEDURE pr_dashboard_regiao(id_regiao_in tab_regiao.id_regiao%TYPE)
IS
    v_nome_regiao tab_regiao.nome%TYPE;
    v_total_ufs NUMBER;
    v_total_municipios NUMBER;
BEGIN
    SELECT tab_regiao.nome, COUNT(DISTINCT id_uf), COUNT(DISTINCT id_municipio) INTO v_nome_regiao, v_total_ufs, v_total_municipios FROM tab_regiao LEFT JOIN tab_uf USING (id_regiao) LEFT JOIN tab_municipio USING (id_uf) WHERE id_regiao = id_regiao_in GROUP BY tab_regiao.nome;
    DBMS_OUTPUT.PUT_LINE(v_nome_regiao);
    DBMS_OUTPUT.PUT_LINE(v_total_ufs);
    DBMS_OUTPUT.PUT_LINE(v_total_municipios);
END;
/

EXECUTE pr_dashboard_regiao(5);

--9
CREATE OR REPLACE PROCEDURE pr_excluir_regiao_cascata(id_regiao_in tab_regiao.id_regiao%TYPE)
IS
BEGIN
    DELETE FROM tab_municipio WHERE id_uf IN(SELECT id_uf FROM tab_regiao LEFT JOIN tab_uf USING (id_regiao) WHERE id_regiao = id_regiao_in);
    DELETE FROM tab_uf WHERE id_regiao = id_regiao_in;
    DELETE FROM tab_regiao WHERE id_regiao = id_regiao_in;
END;
/

SELECT COUNT(*) FROM tab_municipio;
SELECT * FROM tab_uf;
SELECT * FROM tab_regiao;
EXECUTE pr_excluir_regiao_cascata(1);

--10
CREATE OR REPLACE PROCEDURE pr_normalizar_nomes_municipios
IS
BEGIN
    UPDATE tab_municipio SET nome = UPPER(TRIM(nome));
END;
/

EXECUTE pr_normalizar_nomes_municipios;
SELECT * FROM tab_municipio;