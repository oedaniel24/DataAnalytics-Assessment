-- Step 1: Get all active savings and investment accounts
WITH active_accounts AS (
    SELECT
        P.id AS plan_id,
        owner_id,
        CASE
            WHEN is_regular_savings = 1 THEN 'Savings'
            WHEN is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type
    FROM
        plans_plan P
    JOIN
        users_customuser U ON P.owner_id = U.id
    WHERE
        (P.is_regular_savings = 1 OR P.is_a_fund = 1)
        AND U.is_active = 1
),
-- Step 2: Find the latest transaction date for each account, if any
latest_transactions AS (
    SELECT
        S.plan_id,
        MAX(S.transaction_date) AS last_transaction_date
    FROM
        savings_savingsaccount S
    GROUP BY
        S.plan_id
)
-- Step 3: Combine account data with transaction data to identify inactive accounts
SELECT 
    A.plan_id,
    A.owner_id,
    A.type,
    COALESCE(LT.last_transaction_date, 'Never') AS last_transaction_date,
    CASE
        WHEN LT.last_transaction_date IS NULL THEN 999 -- For accounts with no transactions ever
        ELSE DATEDIFF(CURDATE(), LT.last_transaction_date)
    END AS inactivity_days
FROM
    active_accounts A
LEFT JOIN
    latest_transactions LT ON A.plan_id = LT.plan_id
WHERE
    -- Either no transactions ever (LEFT JOIN resulted in NULL)
    LT.last_transaction_date IS NULL
    OR
    -- Or last transaction is older than 365 days
    DATEDIFF(CURDATE(), LT.last_transaction_date) > 365
ORDER BY
    inactivity_days DESC;
