{{ config ( 
    materialized = "table",
    schema = 'report_performance_marketing' 
) }}

WITH CALCULATION AS (
    SELECT
        campaign_name,
        COUNT(DISTINCT CASE WHEN is_new_customer IS TRUE THEN customer_id ELSE NULL END) AS count_new_customer,
        SUM(ad_cost) AS total_ad_cost
    FROM {{ ref ('model_datamart_performance_marketing') }}
    WHERE campaign_id IS NOT NULL
    GROUP BY campaign_name
)
SELECT
    campaign_name,
    count_new_customer,
    total_ad_cost,
    ROUND(total_ad_cost / count_new_customer, 2) AS cost_per_acquired_customer
FROM CALCULATION