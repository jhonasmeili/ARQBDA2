SELECT department_name
FROM departments D
WHERE NOT EXISTS
(SELECT *
 FROM employees E
 WHERE D.department_id = E.department_id)
ORDER BY department_name;

SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM countries;
SELECT * FROM locations;

--1
Select first_name, last_name, hire_date
FROM employees
WHERE last_name <> 'Zlotkey'
AND department_id =
(SELECT department_id
FROM employees
WHERE last_name = 'Zlotkey');

--2
Select first_name, last_name, hire_date
FROM employees
WHERE hire_date >
(SELECT hire_date
FROM employees
WHERE last_name = 'Davies');

--3
Select last_name
from employees E, departments D
Where e.employee_id = d.manager_id;

Select last_name
from employees
where employee_id = ANY 
(Select manager_id from departments);

--4
Select last_name, job_id
From employees
Where department_id NOT IN
(Select department_id from departments
Where department_name like '%Sales%');

--5
Select last_name, salary
From employees
Where salary < ANY
(Select salary From employees
Where job_id = 'ST_MAN');

--6
Select last_name, salary
From employees
Where salary > ALL
(Select salary From employees
Where department_id = 50);

--7
Select first_name, last_name, salary
From employees
Where job_id =
(Select job_id from employees
Where last_name = 'Zlotkey')
AND salary > 
(Select salary from employees
Where last_name = 'Zlotkey');

--8
Select country_id
From countries
Where country_id IN
    (Select country_id
    From locations
    Where location_id IN
        (Select location_id from departments));
        
--9
Select department_name
from departments
Where location_id IN
(Select location_id From locations
Where city = 'Seattle');

--10
Select * From employees
Where salary >
(Select salary from employees
Where last_name = 'Lorentz')
AND department_id =
(Select department_id from employees
Where last_name = 'Abel');

--11
Select * From employees
Where job_id = 
(Select job_id from employees
Where last_name = 'Rajs')
AND hire_date >
(Select hire_date from employees
Where last_name = 'Davies');

--12
Select last_name, salary, department_id From employees
Where salary IN
    (Select MIN(salary) from employees
    Group by department_id);
        
--13
Select * From employees
Where salary < ALL
    (Select salary From employees
    Where department_id =
        (Select department_id From departments
        Where department_name = 'IT'));

--14
Select first_name, last_name, department_id, manager_id
From employees Where employee_id <> 141
AND manager_id =
(Select manager_id From employees Where employee_id = 141)
AND department_id =
(Select department_id From employees Where employee_id = 141);