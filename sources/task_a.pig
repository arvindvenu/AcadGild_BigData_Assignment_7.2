/* 
Top 5 employees (employee id and employee name) with highest rating.
(In case two employees have same rating, employee with name coming first in dictionary
should get preference)
*/

-- load the employee details file using the given schema
employee_details = LOAD '../input/employee_details.txt' USING PigStorage(',') AS 
				(id:int, name:chararray, salary:int, rating: int);

/*
sort the employees in decending order of the rating field. For those employees 
who have same rating sort them in alphabetical order of name
*/
employees_sorted_by_rating = ORDER employee_details BY rating DESC, name ASC;

-- to get the top 5 employees, select only 5 records from the sorted list
top_5_employees = LIMIT employees_sorted_by_rating 5;

-- store the output in the file system
STORE top_5_employees INTO '../output/task_a' USING PigStorage(',');
