{{ config ( 
    materialized = "table",
    schema = 'report_performance_marketing' 
) }}

SELECT
    campaign_name,
    COUNT(DISTINCT customer_id) AS count_previously_active_customers,
    SUM(total_amount) AS total_spending
FROM {{ ref ('model_datamart_performance_marketing') }}
WHERE campaign_type = 'retargeting' AND customer_segment = 'inactive'
GROUP BY campaign_name