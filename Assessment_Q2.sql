-- Step 1: Define a Common Table Expression (CTE) to calculate frequency metrics per month

WITH CTE AS
(
	SELECT

-- Create a label to extract all the months covered in the dataset by combining the monthname and year
		CONCAT(MONTHNAME(S.transaction_date), YEAR(S.transaction_date)) AS individual_months,

-- Estimating the average number of distinct users for each month
		COUNT(DISTINCT U.id) as customer_count,

-- Estimating the average number of transactions per customer for each month
		COUNT(DISTINCT(S.transaction_reference)) / COUNT(DISTINCT U.id) as avg_tran,

-- Categorising based on the average number of transactions per customer
	   CASE 
			WHEN COUNT(DISTINCT(S.transaction_reference)) / COUNT(DISTINCT U.id) >= 10 THEN 'High Frequency'
			WHEN COUNT(DISTINCT(S.transaction_reference)) / COUNT(DISTINCT U.id) >= 3
				AND COUNT(DISTINCT(S.transaction_reference)) / COUNT(DISTINCT U.id) < 10
					THEN 'Medium Frequency'
			ELSE 'Low Frequency'
		END AS frequency_category
	FROM 
		savings_savingsaccount S
	LEFT JOIN
		users_customuser U on S.owner_id = U.id
	GROUP BY
		 individual_months
)
-- Step 2: Aggregate the CTE results by frequency category
SELECT
	frequency_category,
    
-- Estimating the total number of customers in this frequency group across all months
    SUM(customer_count) AS customer_count,
    
-- Estimating the monthly average transactions per customer in each frequency group
    ROUND(AVG(avg_tran), 2) AS avg_transaction_per_month
FROM 
	CTE
GROUP BY
	frequency_category;
    