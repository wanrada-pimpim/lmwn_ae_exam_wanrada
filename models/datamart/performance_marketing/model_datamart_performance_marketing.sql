{{ config ( 
    materialized = "table",
    schema = 'model_datamart' 
) }}

SELECT
    order_transactions.order_id,
    order_transactions.order_datetime,
    order_transactions.total_amount,
    order_transactions.order_status,
    order_transactions.customer_id,
    campaign_master.campaign_id,
    campaign_master.campaign_name,
    campaign_master.start_date AS campaign_start_date,
    campaign_master.end_date AS campaign_end_date,
    campaign_master.campaign_type,
    campaign_master.objective,
    campaign_master.channel,
    campaign_master.budget,
    campaign_interactions.interaction_datetime,
    campaign_interactions.event_type,
    campaign_interactions.platform,
    campaign_interactions.ad_cost,
    customers_master.customer_segment,
    customers_master.status AS customer_status,
    campaign_interactions.is_new_customer
FROM {{ source ('source_transactions', 'order_transactions') }}
LEFT JOIN {{ source ('source_transactions', 'campaign_interactions') }}
ON order_transactions.order_id = campaign_interactions.order_id
LEFT JOIN {{ source ('source_masters', 'campaign_master') }}
ON campaign_interactions.campaign_id = campaign_master.campaign_id
LEFT JOIN {{ source ('source_masters', 'customers_master') }}
ON order_transactions.customer_id = customers_master.customer_id