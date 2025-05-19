-- Step 1: Get the latest transaction per owner
WITH latest_transactions AS (
    SELECT
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM
        savings_savingsaccount
    GROUP BY
        owner_id
)

-- Step 2: Join with the original tables to get full details
SELECT 
    P.id AS plan_id,
    S.owner_id,
    CASE
        WHEN P.is_regular_savings = 1 THEN 'Savings'
        WHEN P.is_a_fund = 1 THEN 'Investment'
    END AS types,
    S.transaction_date AS last_transaction_date,

-- Calculating inactivity dates as the number of days between the last transaction date and the current date
    DATEDIFF(CURDATE(), S.transaction_date) AS inactivity_days 
FROM
    savings_savingsaccount S
JOIN
    latest_transactions LT ON S.owner_id = LT.owner_id AND S.transaction_date = LT.last_transaction_date
LEFT JOIN
    plans_plan P ON P.id = S.plan_id
LEFT JOIN
	users_customuser U ON U.id = S.owner_id
WHERE

-- specifying only transactions that are either a savings plan or an investment plan
    (P.is_a_fund = 1 OR P.is_regular_savings = 1)
    
--  Specifying only active accounts
	AND
     U.is_active = 1
 
--  Specifying only account transactions in the last 1 year (365 days).
    AND
    DATEDIFF(CURDATE(), S.transaction_date) >  365;
