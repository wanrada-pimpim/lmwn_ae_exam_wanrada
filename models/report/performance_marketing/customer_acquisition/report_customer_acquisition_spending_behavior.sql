WITH NEW_CUSTOMERS AS (
    SELECT DISTINCT
        campaign_id,
        customer_id
    FROM model_datamart.model_datamart_performance_marketing    
    WHERE is_new_customer IS TRUE
)
, TOTAL_CUSTOMER_SPENDING AS (
	SELECT
    	campaign_name,
    	customer_id,
    	SUM(total_amount) AS total_spending
	FROM model_datamart.model_datamart_performance_marketing
	WHERE CONCAT(campaign_id, '|', customer_id) IN (
	    SELECT CONCAT(campaign_id, '|', customer_id)
	    FROM NEW_CUSTOMERS
	)
	GROUP BY 
		campaign_name,
    	customer_id
)
SELECT
    campaign_name,
    ROUND(AVG(total_spending), 2) AS average_spending_per_new_customer
FROM TOTAL_CUSTOMER_SPENDING
GROUP BY campaign_name