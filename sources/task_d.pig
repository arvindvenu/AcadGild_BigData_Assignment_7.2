/*
List of employees (employee id and employee name) having entries in employee_expenses
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
THis relation may contain more than one tuple for emp_id. So find the 
distinct list of employee ids uing the distinct operator
*/
empids_distinct = DISTINCT (FOREACH employee_expenses GENERATE emp_id);

/*
perform an inner join of employee_details relation and empids_distinct relation using the employee id. 
This will give all those tuples which have a matching employee id in the employee_expenses relation
*/
employee_details_expenses = JOIN employee_details BY id, empids_distinct BY emp_id;

-- from the joined table extract only emp id and name
employee_details_projected = FOREACH employee_details_expenses GENERATE id, name;

--store the output in the file system
STORE employee_details_projected INTO '../output/task_d' USING PigStorage(',');


