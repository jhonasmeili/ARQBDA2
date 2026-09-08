--1
CREATE OR REPLACE VIEW EMP_ST_CLERK
AS SELECT employee_id, last_name, email, hire_date, job_id FROM EMPLOYEES
WHERE JOB_ID = 'ST_CLERK';

--2
CREATE OR REPLACE VIEW EMP_ST_CLERK
AS SELECT employee_id, last_name, email, hire_date, job_id FROM EMPLOYEES
WHERE JOB_ID = 'ST_CLERK'
WITH CHECK OPTION;

--3
INSERT INTO EMP_ST_CLERK VALUES
(40, 'Balls', 'Balls@balls.com', sysdate, 'ST_CLERK');

--4
-- O registro foi inserido na tabela employees e os 
-- campos que não estavam na view foram inseridos com 
-- valor null.

--5
INSERT INTO EMP_ST_CLERK VALUES
(50, 'Carvalho', 'Carvalho@email.com', sysdate, 'IT_PROG');

--6
--Não foi inserido pois não possuia o JOB_ID igual ao necessário

--7
DELETE FROM EMP_ST_CLERK WHERE EMPLOYEE_ID = 40;

--8
-- O empregado incompleto de ID 40 foi removido tanto da view quanto da tabela

--9
CREATE OR REPLACE VIEW DEPT_MAN_VIEW ("Full name", Title, Salary, department) AS
SELECT FIRST_NAME || ' ' || LAST_NAME, JOB_TITLE, SALARY * 12, DEPARTMENT_NAME
FROM EMPLOYEES E, JOBS J, DEPARTMENTS D
WHERE E.JOB_ID = J.JOB_ID
AND D.MANAGER_ID = E.EMPLOYEE_ID;

--10
--É possível, pois views podem cobrir dados de várias tabelas

--11
CREATE OR REPLACE VIEW DEPT_JOB_VIEW ("Department Name",  "Job Title", "Number of Employees") AS
SELECT DEPARTMENT_NAME, JOB_TITLE, COUNT(*)
FROM DEPARTMENTS D JOIN EMPLOYEES E USING(DEPARTMENT_ID) JOIN JOBS J USING(JOB_ID)
GROUP BY DEPARTMENT_NAME, JOB_TITLE;

--12
--Não, pois contem JOIN e função de agregação (GROUP BY)

--
SELECT * FROM EMPLOYEES E JOIN JOBS J USING (JOB_ID) WHERE JOB_TITLE = 'Shipping Clerk';
SELECT * FROM DEPARTMENTS;

SELECT * FROM JOBS;

SELECT * FROM EMPLOYEES;

SELECT * FROM DEPT_MAN_VIEW;

SELECT * FROM DEPT_JOB_VIEW;
