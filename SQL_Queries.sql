-- ===========================================================
-- HR EMPLOYEE ATTRITION ANALYTICS
-- Database: hr_analytics
-- Author: Anusha Sapavath
-- ===========================================================

USE hr_analytics;

-- ===========================================================
-- SECTION 1: OVERVIEW
-- ===========================================================

-- Query 1: Total Number of Employees
SELECT COUNT(*) AS Total_Employees
FROM employee_attrition;

-- Query 2: Employee Count by Attrition Status
SELECT
    Attrition,
    COUNT(*) AS Employee_Count
FROM employee_attrition
GROUP BY Attrition;

-- Query 3: Overall Attrition Rate
SELECT
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percentage
FROM employee_attrition;

-- ===========================================================
-- SECTION 2: DEPARTMENT ANALYSIS
-- ===========================================================

-- Query 4: Employees Left by Department
SELECT
    Department,
    COUNT(*) AS Employees_Left
FROM employee_attrition
WHERE Attrition='Yes'
GROUP BY Department
ORDER BY Employees_Left DESC;

-- Query 5: Department-wise Attrition Rate
SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percentage
FROM employee_attrition
GROUP BY Department
ORDER BY Attrition_Rate_Percentage DESC;

-- Query 6: Average Salary by Department
SELECT
    Department,
    COUNT(*) AS Total_Employees,
    ROUND(AVG(Monthly_Income),2) AS Average_Monthly_Income
FROM employee_attrition
GROUP BY Department
ORDER BY Average_Monthly_Income DESC;

-- Query 7: Departments Having More Than 100 Employees
SELECT
    Department,
    COUNT(*) AS Total_Employees
FROM employee_attrition
GROUP BY Department
HAVING COUNT(*) > 100;

-- Query 8: Average Years at Company by Department
SELECT
    Department,
    ROUND(AVG(Years_At_Company),2) AS Avg_Years
FROM employee_attrition
GROUP BY Department
ORDER BY Avg_Years DESC;

-- ===========================================================
-- SECTION 3: JOB ROLE ANALYSIS
-- ===========================================================

-- Query 9: Employees Left by Job Role
SELECT
    Job_Role,
    COUNT(*) AS Employees_Left
FROM employee_attrition
WHERE Attrition='Yes'
GROUP BY Job_Role
ORDER BY Employees_Left DESC;

-- Query 10: Job Role-wise Attrition Rate
SELECT
    Job_Role,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percentage
FROM employee_attrition
GROUP BY Job_Role
ORDER BY Attrition_Rate_Percentage DESC;

-- Query 11: Average Salary by Job Role
SELECT
    Job_Role,
    COUNT(*) AS Total_Employees,
    ROUND(AVG(Monthly_Income),2) AS Average_Monthly_Income
FROM employee_attrition
GROUP BY Job_Role
ORDER BY Average_Monthly_Income DESC;

-- Query 12: Job Roles with Average Salary Greater Than 10000
SELECT
    Job_Role,
    COUNT(*) AS Total_Employees,
    ROUND(AVG(Monthly_Income),2) AS Average_Monthly_Income
FROM employee_attrition
GROUP BY Job_Role
HAVING AVG(Monthly_Income) > 10000
ORDER BY Average_Monthly_Income DESC;

-- ===========================================================
-- SECTION 4: EMPLOYEE ANALYSIS
-- ===========================================================

-- Query 13: Attrition by Age Group
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,
    COUNT(*) AS Employees_Left
FROM employee_attrition
WHERE Attrition='Yes'
GROUP BY Age_Group
ORDER BY Employees_Left DESC;

-- Query 14: Average Monthly Income by Attrition Status
SELECT
    Attrition,
    COUNT(*) AS Employee_Count,
    ROUND(AVG(Monthly_Income),2) AS Average_Monthly_Income
FROM employee_attrition
GROUP BY Attrition;

-- Query 15: Attrition Rate by Overtime
SELECT
    Over_Time,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percentage
FROM employee_attrition
GROUP BY Over_Time
ORDER BY Attrition_Rate_Percentage DESC;

-- Query 16: Average Salary by Gender
SELECT
    Gender,
    ROUND(AVG(Monthly_Income),2) AS Avg_Salary
FROM employee_attrition
GROUP BY Gender;

-- ===========================================================
-- SECTION 5: SALARY ANALYSIS
-- ===========================================================

-- Query 17: Employees Earning Above Average Salary
SELECT
    Employee_ID,
    Job_Role,
    Department,
    Monthly_Income
FROM employee_attrition
WHERE Monthly_Income >
(
    SELECT AVG(Monthly_Income)
    FROM employee_attrition
)
ORDER BY Monthly_Income DESC;

-- Query 18: Top 10 Highest Paid Employees
SELECT
    Employee_ID,
    Job_Role,
    Department,
    Monthly_Income
FROM employee_attrition
ORDER BY Monthly_Income DESC
LIMIT 10;

-- Query 19: Top 5 Highest Paid Employees
SELECT
    Employee_ID,
    Job_Role,
    Department,
    Monthly_Income
FROM employee_attrition
ORDER BY Monthly_Income DESC
LIMIT 5;

-- ===========================================================
-- SECTION 6: EXPERIENCE ANALYSIS
-- ===========================================================

-- Query 20: Top 5 Most Experienced Employees
SELECT
    Employee_ID,
    Job_Role,
    Total_Working_Years
FROM employee_attrition
ORDER BY Total_Working_Years DESC
LIMIT 5;

-- ===========================================================
-- SECTION 7: WINDOW FUNCTIONS
-- ===========================================================

-- Query 21: Rank Employees by Salary
SELECT
    Employee_ID,
    Job_Role,
    Monthly_Income,
    RANK() OVER(ORDER BY Monthly_Income DESC) AS Salary_Rank
FROM employee_attrition;

-- Query 22: Department-wise Salary Rank
SELECT
    Department,
    Job_Role,
    Monthly_Income,
    DENSE_RANK() OVER(
        PARTITION BY Department
        ORDER BY Monthly_Income DESC
    ) AS Dept_Salary_Rank
FROM employee_attrition;