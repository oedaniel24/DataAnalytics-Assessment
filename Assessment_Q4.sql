SELECT 
    U.id AS customer_id,
    CONCAT(U.first_name, ' ', U.last_name) AS name,
    TIMESTAMPDIFF(MONTH, U.date_joined, CURDATE()) AS tenure_months,
  
    -- Count distinct transactions for the customer
    COUNT(DISTINCT S.savings_id) AS total_transactions,

    -- CLV formula: (transactions/tenure) * 12 * profit_per_transaction
    ROUND(
        (COUNT(S.savings_id) / NULLIF(TIMESTAMPDIFF(MONTH, U.date_joined, CURDATE()), 0)) * 12 * 0.1,
        2
    ) AS estimated_clv
FROM 
    users_customuser U
LEFT JOIN
    savings_savingsaccount S ON U.id = S.owner_id
GROUP BY
    customer_id, name, tenure_months
ORDER BY
    estimated_clv DESC;
