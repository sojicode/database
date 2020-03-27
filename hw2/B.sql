-- 1. [2pt] Retrieve the names of all employees who work on at least one of the projects. 
-- (In other words, look at the list of projects given in the PROJECT table, 
-- and retrieve the names of all employees who work on at least one of them.) 

select distinct lname, fname
from employee, works_on
where ssn = essn and pno >= 1;


-- 2. [2pt] For each department, retrieve the department number, department name, 
-- and the average salary of all employees working in that department.  
-- Order the output by department number in ascending order. 

select dnumber, dname, avg(salary)
from (
    select ssn, salary, dname, dnumber
    from employee, department
    where dno = dnumber
)
group by dname, dnumber
order by dnumber;

-- 3. [3pt] List the last names of all department managers who have no dependents. 

select lname from employee, department where ssn = mgr_ssn
minus
select lname from employee, dependent where ssn = essn;

-- 4. [3pt] Determine the department that has the employee with the lowest salary among all employees. 
-- For this department retrieve the names of all employees. Write one query for this question. 

select dno, lname, fname 
from employee 
where dno in (select dno from employee where salary = (select min(salary) from employee));


-- 5. [3pt] Find the total number of employees and the total number of dependents for every department 
-- (the number of dependents for a department is the sum of the number of dependents 
-- for each employee working for that department). 
-- Return the result as department name, total number of employees, and total number of dependents.

-- new table but not included total dno/ dname
select dno, count(ssn) as total_Employee, sum(total_Dependent) as total_Dependent
from (select * from employee) e1, 
     (select essn, count(dependent_name) as total_Dependent from dependent group by essn) e2 
where e1.ssn = e2.essn
group by dno;

-- count total employee
select dname, count(ssn) as total_Employee
from department, employee
where dnumber = dno 
group by dname;

-- get the dname but not the total
select dname, count(ssn) as total_Employee, Coalesce(sum(total_Dependent), 0) as total_Dependent
from department, employee, (select essn, count(dependent_name) as total_Dependent from dependent group by essn)
where dnumber = dno and ssn = essn
group by dname;


------final
select dname, count(ssn) as total_Employee, Coalesce(sum(total_Dependent), 0) as total_Dependent
from department, employee
left outer join (select essn, count(dependent_name) as total_Dependent from dependent group by essn) depe on ssn = essn
where dnumber = dno
group by dname;


-- 6. [2pt] Retrieve the names of employees whose salary is within $20,000 of the salary of the employee 
-- who is paid the most in the company 
-- (e.g., if the highest salary in the company is $80,000, retrieve the names of all employees that make at least $60,000).

select fname, lname, salary
from employee
where salary >= (select max(salary) from employee) - 20000;




