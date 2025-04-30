{{ config ( 
    materialized = "table",
    schema = 'report_performance_marketing' 
) }}

WITH FIRST_RETARGETING_CAMPAIGN_PURCHASE AS (
    SELECT 
        customer_id,
        MIN(order_datetime) AS first_retargeting_purchase_datetime
    FROM {{ ref ('model_datamart_performance_marketing') }}
    WHERE campaign_type = 'retargeting' AND customer_segment = 'inactive'
    GROUP BY customer_id
)
, LAST_PURCHASE_BEFORE_RETARGETING AS (
    SELECT
        before.customer_id,
        MAX(before.order_datetime) AS last_purchase_before_retargeting_datetime,
        after.first_retargeting_purchase_datetime
    FROM {{ ref ('model_datamart_performance_marketing') }} AS before
    LEFT JOIN FIRST_RETARGETING_CAMPAIGN_PURCHASE AS after
    ON  before.customer_id = after.customer_id AND
        before.order_datetime < after.first_retargeting_purchase_datetime
    GROUP BY 
        before.customer_id,
        after.first_retargeting_purchase_datetime
)
SELECT
    ROUND(AVG(DATE_DIFF('day', last_purchase_before_retargeting_datetime, first_retargeting_purchase_datetime)), 2) AS days_gap_returned_customer
FROM LAST_PURCHASE_BEFORE_RETARGETING