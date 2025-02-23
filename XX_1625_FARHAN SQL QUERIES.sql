/*
--QUERIES
1.	List all employees who are getting the lowest salary of each dept 
2.	List all employees whose salary is greater than average salary of all employees
3.	SQL Query to find 2nd highest salary with empno
4.  DOB (CALCULATE THE AGE) 
5. age > 40 YEARS 
6. HIRE DATE (DOJ) FORMAT THE DATE USING TO_CHAR/TO_DATE - 12th of January, 2024  and 12 Jan 2024 
7. full name - merge first name, middle name, last name . if middle name is null, the output should not print a blank space inbetween first and last name. 
8. which department is having minimum of employees . */

--Q1--LIST ALL EMPLOYEES WHO ARE GETTING LOWEST SALARY OF EACH DEPARTMENT

SELECT
    P.PERSON_ID,
    PN.FIRST_NAME,
    PN.MIDDLE_NAME,
    PN.LAST_NAME,
    D.DEPT_NAME,
    S.SALARY
FROM
    XX_1625_PERSON_TABLE P,
    XX_1625_PERSON_DETAILS_TABLE PN,
    XX_1625_SALARY_TABLE S,
    XX_1625_DEPARTMENT_TABLE D
WHERE
    P.PERSON_ID = PN.PERSON_ID
    AND P.PERSON_ID = S.PERSON_ID
    AND P.DEPT_ID = D.DEPT_ID
    AND S.SALARY IN 
    (
        SELECT
            MIN(SAL.SALARY)
        FROM
            XX_1625_PERSON_TABLE P2,
            XX_1625_SALARY_TABLE SAL
        WHERE
            P2.PERSON_ID = SAL.PERSON_ID
        GROUP BY
            P2.DEPT_ID
    )
ORDER BY
    D.DEPT_NAME;
    
    
select min(salary) from XX_1625_SALARY_TABLE;    

-- 2.	List all employees whose salary is greater than average salary of all employees

SELECT 
    PN.FIRST_NAME || ' ' || TRIM(NVL(PN.MIDDLE_NAME || ' ', '')) || PN.LAST_NAME AS EMP_NAME,
    S.SALARY AS SALARY
FROM
    XX_1625_PERSON_DETAILS_TABLE PN,
    XX_1625_SALARY_TABLE S
WHERE 
    S.PERSON_ID = PN.PERSON_ID
    AND S.SALARY > (SELECT AVG(SAL.SALARY) FROM XX_1625_SALARY_TABLE SAL)
ORDER BY 
    S.SALARY;
    
--Q 3. SQL Query to find 2nd highest salary with empno

SELECT
    PN.FIRST_NAME || ' ' || NVL(PN.MIDDLE_NAME, '') || ' ' || PN.LAST_NAME AS EMP_NAME,
    S.SALARY AS SALARY,
    PN.PERSON_ID
FROM
    XX_1625_Person_Details_Table PN,
    XX_1625_SALARY_TABLE S
WHERE
    PN.PERSON_ID = S.PERSON_ID
AND
    S.SALARY = (
        SELECT MAX(SALARY)
        FROM XX_1625_SALARY_TABLE
        WHERE SALARY < (SELECT MAX(SALARY) FROM XX_1625_SALARY_TABLE)
    );

SELECT MAX(SALARY)
FROM XX_1625_SALARY_TABLE
WHERE SALARY < (SELECT MAX(SALARY) FROM XX_1625_SALARY_TABLE);


--Q 4 DOB (CALCULATE THE AGE) 


SELECT
    P.PERSON_ID,
    PN.FIRST_NAME || ' ' || NVL(PN.MIDDLE_NAME, '') || ' ' || PN.LAST_NAME AS EMP_NAME,
    TRUNC(MONTHS_BETWEEN(SYSDATE, P.DOB) / 12) AS AGE
FROM
    XX_1625_PERSON_TABLE P,
    XX_1625_PERSON_DETAILS_TABLE PN
WHERE 
    P.PERSON_ID = PN.PERSON_ID;
    

-- Q.5 age > 40 YEARS 


SELECT
    P.PERSON_ID,
    PN.FIRST_NAME || ' ' || NVL(PN.MIDDLE_NAME, '') || ' ' || PN.LAST_NAME AS EMP_NAME,
    TRUNC(MONTHS_BETWEEN(SYSDATE, P.DOB) / 12) AS AGE
FROM
    XX_1625_PERSON_TABLE P,
    XX_1625_PERSON_DETAILS_TABLE PN
WHERE 
    P.PERSON_ID = PN.PERSON_ID
    AND TRUNC(MONTHS_BETWEEN(SYSDATE, P.DOB) / 12) > 40;
    
--Q.6 HIRE DATE (DOJ) FORMAT THE DATE USING TO_CHAR/TO_DATE - 12th of January, 2024  and 12 Jan 2024 


SELECT
    TO_CHAR(HIRE_DATE, 'DD Mon YYYY') AS HIRE_DATE_SHORT_FORMAT,
    TO_CHAR(HIRE_DATE, 'DDth "of" Month, YYYY') AS HIRE_DATE_FULL_FORMAT
FROM
    XX_1625_PERSON_TABLE; 

--Q.7 full name - merge first name, middle name, last name . if middle name is null, the output should not print a blank space inbetween first and last name. 

SELECT
    PN.FIRST_NAME || NVL(PN.MIDDLE_NAME, '') || PN.LAST_NAME AS FULL_NAME
FROM
    XX_1625_PERSON_DETAILS_TABLE PN;


--Q .8 which department is having minimum of employees .

SELECT
    DEPT_ID AS DEPARTMENT_ID,
    DEPT_NAME AS DEPARTMENT_NAME,
    PERSON_COUNT
FROM (
    SELECT
        D.DEPT_ID,
        D.DEPT_NAME,
        COUNT(P.PERSON_ID) AS PERSON_COUNT
    FROM
        XX_1625_DEPARTMENT_TABLE D,
        XX_1625_PERSON_TABLE P
    WHERE
        D.DEPT_ID = P.DEPT_ID(+)
    GROUP BY
        D.DEPT_ID,
        D.DEPT_NAME
)
WHERE
    PERSON_COUNT = (
        SELECT MIN(COUNT(P2.PERSON_ID))
        FROM
            XX_1625_PERSON_TABLE P2
        GROUP BY
            P2.DEPT_ID
    );