CREATE OR REPLACE TRIGGER INSERT_OR_UPDATE_UF_SAFEGUARD
BEFORE INSERT OR UPDATE ON UF
FOR EACH ROW
BEGIN
    IF :NEW.ID_REGIAO = 0 THEN
        IF :NEW.ID_UF !=  0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'NOVA UF NÃO PODE TER O BRASIL COMO ABRANGÊNCIA');
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER INSERT_OR_UPDATE_MUNICIPIO_SAFEGUARD
BEFORE INSERT OR UPDATE ON MUNICIPIO
FOR EACH ROW
BEGIN
    IF :NEW.ID_UF = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'NOV0 MUNICIPIO NÃO PODE TER O BRASIL COMO ABRANGÊNCIA');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER INSERT_OR_UPDATE_CANDIDATO_FORMATTING
BEFORE INSERT OR UPDATE ON CANDIDATO
FOR EACH ROW
DECLARE
    form_uf_id UF.ID_UF%TYPE;
BEGIN
    SELECT ID_UF INTO form_uf_id FROM UF WHERE SIGLA_UF = :NEW.SIGLA_ABRANGENCIA;
    :NEW.ID_ABRANGENCIA := form_uf_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'UF NÃO ENCONTRADA');
END;
/

CREATE OR REPLACE TRIGGER INSERT_OR_UPDATE_VOTO_FORMATTING
BEFORE INSERT OR UPDATE ON VOTO
FOR EACH ROW
DECLARE
    form_uf_id UF.ID_UF%TYPE;
BEGIN
    SELECT ID_UF INTO form_uf_id FROM UF WHERE SIGLA_UF = :NEW.SIGLA_ABRANGENCIA;
    :NEW.ID_ABRANGENCIA := form_uf_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'UF NÃO ENCONTRADA');
END;
/

CREATE OR REPLACE PROCEDURE MUDAR_PARTIDO_CANDIDATO (cpf_candidato_mudar CANDIDATO.CPF_CANDIDATO%TYPE, nr_partido_novo PARTIDO.NUMERO_PARTIDO%TYPE, nr_candidato_novo CANDIDATO.NUMERO_CANDIDATO%TYPE)
IS
    p_abrangencia UF.ID_UF%TYPE;
    p_cargo CARGO.ID_CARGO%TYPE;
    p_alcance INT;
    P_alcance_max INT;
BEGIN
    SELECT ID_ABRANGENCIA, ID_CARGO INTO p_abrangencia, p_cargo FROM CANDIDATO WHERE CPF_CANDIDATO = cpf_candidato_mudar;
    IF p_cargo = 7 OR p_cargo = 8 THEN
        p_alcance := nr_partido_novo * 1000;
        p_alcance_max := p_alcance + 999;
    ELSIF p_cargo = 6 THEN
        p_alcance := nr_partido_novo * 100;
        p_alcance_max := p_alcance + 99;
    END IF;
    
    IF p_cargo = 1 OR p_cargo = 2 OR p_cargo = 3 OR p_cargo = 4 THEN
        IF nr_partido_novo != nr_candidato_novo THEN
            RAISE_APPLICATION_ERROR(-20004, 'PRESIDENTES, GOVERNADORES, E SEUS VICES DEVEM TER O MESMO NÚMERO DO PARTIDO');
        END IF;
    ELSIF p_cargo = 5 OR p_cargo = 9 OR p_cargo = 10 THEN
        IF nr_candidato_novo > 999 OR nr_candidato_novo < 100 THEN
            RAISE_APPLICATION_ERROR(-20005, 'SENADORES E SEUS SUPLENTES DEVEM TER NUMERO ENTRE 100 E 999');
        END IF;
    ELSIF p_cargo = 7 OR p_cargo = 8 THEN
        IF nr_candidato_novo > p_alcance_max OR nr_candidato_novo < p_alcance THEN
            RAISE_APPLICATION_ERROR(-20006, 'DEPUTADOS ESTAUAIS E DISTRITAIS DO PARTIDO ' || nr_partido_novo || ' DEVEM TER NÚMERO ENTRE ' || p_alcance || ' E ' || p_alcance_max);
        END IF;
    ELSIF p_cargo = 6 THEN
        IF nr_candidato_novo > p_alcance_max OR nr_candidato_novo < p_alcance THEN
            RAISE_APPLICATION_ERROR(-20007, 'DEPUTADOS FEDERAIS DO PARTIDO ' || nr_partido_novo || ' DEVEM TER NÚMERO ENTRE ' || p_alcance || ' E ' || p_alcance_max );
        END IF;
    END IF;
    UPDATE CANDIDATO SET NUMERO_CANDIDATO = nr_candidato_novo, NUMERO_PARTIDO = nr_partido_novo WHERE CPF_CANDIDATO = cpf_candidato_mudar AND ID_ABRANGENCIA = p_abrangencia AND ID_CARGO = p_cargo;
END;
/

CREATE OR REPLACE PROCEDURE GERAR_LEGENDAS_PARTIDARIAS
IS
    p_sigla_partido PARTIDO.SIGLA_PARTIDO%TYPE;
    p_sigla_abrangencia UF.SIGLA_UF%TYPE;
    p_verificador INT;
BEGIN
    FOR i IN 10..100 LOOP
        SELECT COUNT(*) INTO p_verificador FROM PARTIDO WHERE NUMERO_PARTIDO = i;
        IF p_verificador = 1 THEN
            SELECT SIGLA_PARTIDO INTO p_sigla_partido FROM PARTIDO WHERE NUMERO_PARTIDO = i;
            FOR j IN 10..100 LOOP
                SELECT COUNT(*) INTO p_verificador FROM UF WHERE ID_UF = j;
                IF p_verificador = 1 THEN
                    SELECT SIGLA_UF INTO p_sigla_abrangencia FROM UF WHERE ID_UF = j;
                    INSERT INTO CANDIDATO (CPF_CANDIDATO,NUMERO_CANDIDATO,ID_CARGO,ID_ABRANGENCIA,SIGLA_ABRANGENCIA,NUMERO_PARTIDO,NOME_CANDIDATO) VALUES (i || j, i, 60, j, p_sigla_abrangencia, i, 'Legenda ' || p_sigla_partido || '-' || p_sigla_abrangencia);
                    INSERT INTO CANDIDATO (CPF_CANDIDATO,NUMERO_CANDIDATO,ID_CARGO,ID_ABRANGENCIA,SIGLA_ABRANGENCIA,NUMERO_PARTIDO,NOME_CANDIDATO) VALUES (i || j || 0, i, 70, j, p_sigla_abrangencia, i, 'Legenda ' || p_sigla_partido || '-' || p_sigla_abrangencia);
                    UPDATE CANDIDATO SET ID_CARGO = 80 WHERE NUMERO_CANDIDATO = i AND ID_CARGO = 70 AND ID_ABRANGENCIA = 53;
                END IF;
            END LOOP;
        END IF;
    END LOOP;
END;
/
    