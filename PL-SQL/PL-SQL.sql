BEGIN
DBMS_OUTPUT.PUT_LINE('Hello world! v2');
END;
/

DECLARE
msg VARCHAR2(100) := 'Hello World! v3';
BEGIN
DBMS_OUTPUT.put_line(msg);
END;
/

DECLARE
MSG VARCHAR2(100);
BEGIN
MSG := '&INPUT';
DBMS_OUTPUT.PUT_LINE('Hello '|| MSG);
END;
/

SET SERVEROUTPUT ON
DECLARE
sobrenome VARCHAR2(20);
BEGIN
SELECT last_name INTO sobrenome
FROM HR.EMPLOYEES
WHERE employee_id = 100;
DBMS_OUTPUT.PUT_LINE('O sobrenome do empregado
é ' || sobrenome);
END;
/

SET SERVEROUTPUT ON
DECLARE
sobrenome VARCHAR2(20);
BEGIN
SELECT last_name INTO sobrenome
FROM EMPLOYEES
WHERE employee_id = 100;
DBMS_OUTPUT.PUT_LINE('O sobrenome do empregado
é ' || sobrenome);
END;
/

DECLARE
min_sal hr.employees.salary%TYPE;
max_sal min_sal%TYPE;
deptno hr.employees.department_id%TYPE := 60;
BEGIN
SELECT MIN(salary), MAX(salary)
INTO min_sal, max_sal
FROM hr.employees
WHERE department_id = deptno;
DBMS_OUTPUT.PUT_LINE ('O menor salário do
departamento ' || deptno || ' é ' ||
min_sal || ' e o maior salário é ' || max_sal);
END;
/

