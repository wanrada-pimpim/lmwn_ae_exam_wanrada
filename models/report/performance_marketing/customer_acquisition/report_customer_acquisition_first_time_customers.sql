{{ config ( 
    materialized = "table",
    schema = 'report_performance_marketing' 
) }}

SELECT
    campaign_name,
    COUNT(DISTINCT CASE WHEN is_new_customer IS TRUE THEN customer_id ELSE NULL END) AS count_new_customers,
    SUM(CASE WHEN is_new_customer IS TRUE THEN ad_cost ELSE 0 END) AS total_customer_acquisition_cost,
    SUM(ad_cost) AS total_ad_cost
FROM {{ ref ('model_datamart_performance_marketing') }}
WHERE campaign_id IS NOT NULL
GROUP BY campaign_name