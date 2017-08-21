/*
List of employees (employee id and employee name) having no entry in employee_expenses
file.
*/

-- load the employee details file using the given schema
employee_details = LOAD '../input/employee_details.txt' USING PigStorage(',') AS 
				(id:int, name:chararray, salary:int, rating: int);

-- load the employee expenses file using the given schema
employee_expenses = LOAD '../input/employee_expenses.txt' USING PigStorage('\t') AS 
							(emp_id:int, expenses:int);

/*
extract only the employee ids in the employee_expenses relation. 
THis relation may contain more than one row for emp_id. So find the distinct 
list of employee ids uing the distinct operator
*/
empids_distinct = DISTINCT (FOREACH employee_expenses GENERATE emp_id);

/*
perform a left outer join of employee_details relation and empids_distinct relation using the employee id. 
This will give all those tuples which have a matching employee id in the expenses relation. This will also give 
those tuples who do not have a matching employee id in the employee_expenses relation. For such tuples, the 
fields for the employee_expenses relation will be null
*/
employee_details_expenses = JOIN employee_details by id LEFT, empids_distinct by emp_id;

/*
As explained earlier, the left outer join will also give those tuples who do not have a matching employee id 
in the employee_expenses relation. For such tuples, the fields for the employee_expenses relation will be null. 
So, if we filter the joined relation based on this condition we will get those employees which have no entry in the 
employee_expenses table. Also, since we want only emp id and name, project only those fields using the FOREACH .. GENERATE
*/
employees_not_having_expense = FOREACH (FILTER employee_details_expenses BY emp_id IS NULL) GENERATE id, name;

-- store the output in the file system
STORE employees_not_having_expense INTO '../output/task_e' USING PigStorage(',');


