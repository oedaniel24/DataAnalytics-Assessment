# DataAnalytics-Assessment
This repository contain my submission for the Cowrywise Data Analyst assessment 

## Question 1
I started by selecting from the users table (users_customuser) and giving it an alias U for brevity. For each user, I grabbed their ID and concatenated their first and last names to create a full name. And then, for each user in our main query, a subquery counts all the savings accounts by matching the owner_id column in the savings table to the current user's ID.  The same process is done for the investment plan.  After this,  subqueries  were applied to sum up all amounts for each product type;  the SUMS are wrapped in COALESCE functions to handle NULLs, and it is then rounded up to 2 decimal  places.

An Exist operator is used to check if the user has at least one savings account and at least one investment plan. Finally, I sorted the results by total deposits in descending order, showing users with the highest combined deposits first

### Challenges
I had initially attempted to use joins and common table expressions to build the query, but that solution was unoptimised, took a long time to run due to the size of the table, and returned an error.


## Question 2
Created this query  in  2 steps, first was a  month analysis CTE that performed the following tasks:
1. Time Period Identification:
  a. Creates a month-year label by concatenating the month name and year from each transaction date
  b. This produces groups like "January2024", "February2024", etc.

2. Counts distinct users who had transactions in each month

3. Transaction Frequency Calculation:
  a. Counts unique transaction references (preventing duplicate counting)
  b. Divides by the number of distinct customers to get average transactions per customer
  c. This calculation represents how many transactions an average customer makes in that month

4. Uses a CASE statement to assign categories based on the average transaction count:
≥10 transactions → "High Frequency"
3-9 transactions → "Medium Frequency"
≤2 transactions → "Low Frequency"

5. Data Source and Relationship:
  a. Pulls transaction data from savings_savingsaccount table
  b. Links to customer information using a LEFT JOIN to users_customuser
  c. This preserves all transactions, even if user information might be incomplete

6. Groups all metrics by the month-year identifier

Second step, aggregated the query by category

### Challenges
I struggled to understand what was meant by per customer, per month, because the data covered multiple years. So I was unsure if I was to aggregate all the months across all the years at first




