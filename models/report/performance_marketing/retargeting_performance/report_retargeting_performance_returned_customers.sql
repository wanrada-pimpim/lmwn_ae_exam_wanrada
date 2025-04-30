{{ config ( 
    materialized = "table",
    schema = 'report_performance_marketing' 
) }}

WITH RETARGETING_ORDER AS (
	SELECT
	    campaign_name,
	    customer_id,
	    COUNT(DISTINCT order_id) AS total_retargeting_order
	FROM {{ ref ('model_datamart_performance_marketing') }}
	WHERE campaign_type = 'retargeting' AND customer_segment = 'inactive'
	GROUP BY 
		campaign_name,
		customer_id
)
, RETURNED_CUSTOMER AS (
	SELECT
		campaign_name,
		SUM(CASE WHEN total_retargeting_order > 1 THEN 1 ELSE 0 END) AS count_returned_customers,
		COUNT(*) AS count_retargeting_customers
	FROM RETARGETING_ORDER
	GROUP BY campaign_name
)
SELECT
	campaign_name,
	count_returned_customers,
	count_retargeting_customers,
	ROUND(AVG(count_returned_customers / count_retargeting_customers * 100), 2) AS percent_returned_customers
FROM RETURNED_CUSTOMER
GROUP BY
	campaign_name,
	count_returned_customers,
	count_retargeting_customers