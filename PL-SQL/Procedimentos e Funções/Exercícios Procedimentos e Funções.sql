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