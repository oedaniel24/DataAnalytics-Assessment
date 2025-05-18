-- Select relevant user and financial data for users who have both savings and investment accounts
SELECT 
    U.id AS owner_id,
    CONCAT(U.first_name, ' ', U.last_name) AS name,

    -- Count of savings accounts the user owns
    (
        SELECT COUNT(*) 
        FROM savings_savingsaccount 
        WHERE owner_id = U.id
    ) AS savings_count,

    -- Count of investment plans the user owns
    (
        SELECT COUNT(*) 
        FROM plans_plan 
        WHERE owner_id = U.id
    ) AS investment_count,
    
    -- Total deposit amount from both savings and investments
    -- Each subquery returns the sum of amounts, defaulting to 0 if no records are found
    -- The result is rounded to 2 decimal places
    ROUND(
        COALESCE(
            (SELECT SUM(amount) FROM savings_savingsaccount WHERE owner_id = U.id), 
            0
        ) + 
        COALESCE(
            (SELECT SUM(amount) FROM plans_plan WHERE owner_id = U.id), 
            0
        ),
        2
    ) AS total_deposits
FROM
    users_customuser U

-- Filter: Only include users who have at least one savings account and at least one investment plan
WHERE
    EXISTS (
        SELECT 1 
        FROM savings_savingsaccount 
        WHERE owner_id = U.id
    )
    AND EXISTS (
        SELECT 1 
        FROM plans_plan 
        WHERE owner_id = U.id
    )
    
-- sort by the total deposits
ORDER BY
	total_deposits DESC;
