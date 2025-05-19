SELECT 
	DISTINCT(U.id) AS customer_id,
	CONCAT(U.first_name, " ", U.last_name) AS name,
	TIMESTAMPDIFF(MONTH, U.date_joined, CURDATE()) AS tenure_months,
	COUNT(DISTINCT(S.savings_id)) AS total_transactions,
-- Estimating the CLV
	(COUNT(DISTINCT(S.savings_id)) / TIMESTAMPDIFF(MONTH, U.date_joined, CURDATE())) * 12 * 0.1 AS estimated_clv
FROM 
	users_customuser U
LEFT JOIN
	savings_savingsaccount S ON U.id = S.owner_id
GROUP BY
	customer_id, tenure_months
ORDER BY
	estimated_clv DESC
