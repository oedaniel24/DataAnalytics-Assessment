# DataAnalytics-Assessment
This repository contain my submission for the Cowrywise Data Analyst assessment 

## Question 1
I started by selecting from the users table (users_customuser) and giving it an alias U for brevity. For each user, I grabbed their ID and concatenated their first and last names to create a full name. And then, for each user in our main query, a subquery counts all the savings accounts by matching the owner_id column in the savings table to the current user's ID.  The same process is done for the investment plan.  After this,  subqueries  were applied to sum up all amounts for each product type;  the SUMS are wrapped in COALESCE functions to handle NULLs, and it is then rounded up to 2 decimal  places.

An Exist operator is used to check if the user has at least one savings account and at least one investment plan. Finally, I sorted the results by total deposits in descending order, showing users with the highest combined deposits first

### Challenges
I had initially attempted to use joins and common table expressions to build the query, but that solution was unoptimised, took a long time to run due to the size of the table, and returned an error.


## Question 2



