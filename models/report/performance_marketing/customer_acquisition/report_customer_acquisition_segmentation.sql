{{ config ( 
    materialized = "table",
    schema = 'report_performance_marketing' 
) }}

SELECT
    campaign_name,
    channel,
    platform,
    COUNT(*) AS count_customer_acquisition
FROM {{ ref ('model_datamart_performance_marketing') }}
WHERE is_new_customer IS TRUE
GROUP BY 
    campaign_name,
    channel,
    platform