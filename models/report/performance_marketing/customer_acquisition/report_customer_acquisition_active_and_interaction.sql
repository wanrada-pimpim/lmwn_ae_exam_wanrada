{{ config ( 
    materialized = "table",
    schema = 'report_performance_marketing' 
) }}

WITH NEW_CUSTOMER AS (
    SELECT DISTINCT
        customer_id
    FROM {{ ref ('model_datamart_performance_marketing') }}
    WHERE is_new_customer IS TRUE
)
, PURCHASE_DATE AS (
	SELECT
		customer_id,
		MIN(order_datetime) AS first_purchase_datetime,
		MIN(CASE WHEN is_new_customer IS TRUE THEN order_datetime ELSE NULL END) AS first_campaign_purchase_datetime,
		MAX(order_datetime) AS latest_purchase_datetime
	FROM {{ ref ('model_datamart_performance_marketing') }}
	WHERE customer_id IN (
		SELECT customer_id
		FROM NEW_CUSTOMER
	)
	GROUP BY customer_id
)
, TIME_GAP AS (
	SELECT
		customer_id,
		DATE_DIFF('day', first_purchase_datetime, first_campaign_purchase_datetime) AS day_before_first_campaign_purchase,
		DATE_DIFF('day', first_campaign_purchase_datetime, latest_purchase_datetime) AS day_after_first_campaign_purchase
	FROM PURCHASE_DATE
)
SELECT
	ROUND(AVG(day_before_first_campaign_purchase), 2) AS average_day_before_first_campaign_purchase,
	ROUND(AVG(day_after_first_campaign_purchase), 2) AS average_day_after_first_campaign_purchase
FROM TIME_GAP