{{ config ( 
    materialized = "table",
    schema = 'report_customer_service' 
) }}

WITH ISSUE_FLAG AS (
    SELECT
        driver_id,
        CASE
            WHEN issue_type IS NULL AND issue_sub_type IS NULL THEN 'No issue'
            WHEN issue_type IN ('delivery', 'rider') THEN 'Driver-related issue'
            ELSE 'Other issue'
        END AS driver_related_issue_flag,
        ticket_id,
        order_id
    FROM {{ ref ('model_datamart_customer_service') }}
)
SELECT
    driver_id,
    SUM(CASE WHEN driver_related_issue_flag = 'Driver-related issue' THEN 1 ELSE 0 END) AS count_driver_related_issue,
    SUM(CASE WHEN driver_related_issue_flag = 'Other issue' THEN 1 ELSE 0 END) AS count_other_issue,
    COUNT(*) AS total_order,
    ROUND(SUM(CASE WHEN driver_related_issue_flag = 'Driver-related issue' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS percent_driver_related_issue
FROM ISSUE_FLAG
GROUP BY driver_id