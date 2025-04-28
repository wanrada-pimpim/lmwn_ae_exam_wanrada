SELECT
    campaign_name,
    customer_segment,
    COUNT(DISTINCT customer_id) AS count_customers,
    COUNT(DISTINCT order_id) AS count_orders,
    SUM(total_amount) AS total_revenue,
    SUM(ad_cost) AS total_ad_cost
FROM model_datamart.model_datamart_performance_marketing
WHERE campaign_type = 'retargeting'
GROUP BY
    campaign_name,
    customer_segment