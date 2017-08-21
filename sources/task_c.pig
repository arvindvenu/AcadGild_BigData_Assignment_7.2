/*
Employee (employee id and employee name) with maximum expense
(In case two employees have same expense, employee with name coming first in dictionary
should get preference)
*/

-- load the employee details file using the given schema
employee_details = LOAD '../input/employee_details.txt' USING PigStorage(',') AS (id:int, name:chararray, salary:int, rating: int);

-- load the employee expenses file using the given schema
employee_expenses = LOAD '../input/employee_expenses.txt' USING PigStorage('\t') AS (emp_id:int, expenses:int);

/*
some employees may have more than one row for expenses. 
So, first group by emp id and then sum the expenses in each group
*/

-- below statement does grouping by employee id
employee_expenses_grouped = GROUP employee_expenses BY emp_id;

-- below statement does summation of expenses for each group(i.e. each employee id)
employee_expenses_grouped_summed = FOREACH employee_expenses_grouped GENERATE 
		group AS emp_id, SUM(employee_expenses.expenses) AS expenses;

-- join employee details with employee expenses relation based on the employee id
employee_details_expenses = JOIN employee_details BY id, 
				employee_expenses_grouped_summed BY emp_id;

-- now sort the list in descending order of expenses
employees_sorted_by_expenses = ORDER employee_details_expenses BY expenses DESC, name ASC;

/*
from the sorted list, retrieve only the 1st row to find the employee with maximum expense 
and finally extract only id and name from the row
*/
employee_with_max_expense = FOREACH (LIMIT employees_sorted_by_expenses 1) GENERATE id,name;

-- store the output in the file system
STORE employee_with_max_expense INTO '../output/task_c' USING PigStorage(',');


