/*
Top 3 employees (employee id and employee name) with highest salary, whose employee id
is an odd number.
(In case two employees have same salary, employee with name coming first in dictionary
should get preference)
*/

-- load the employee details file using the given schema
employee_details = LOAD '../input/employee_details.txt' USING PigStorage(',') AS 
				(id:int, name:chararray, salary:int, rating: int);

/*
filter for all employees who have odd employee id 
(i.e. reminder hwen divided by 2 should be 1)
*/
employees_with_odd_empid = FILTER employee_details BY id % 2 == 1;

-- sort the filtered list in descending order of rating
employees_sorted_by_rating = ORDER employees_with_odd_empid BY rating DESC, name ASC;

--limit the sorted list to 3 records so that we get the employee with the top 3 ratings
top_3_employees = LIMIT employees_sorted_by_rating 3;
STORE top_3_employees INTO '../output/task_b' USING PigStorage(',');
