WITH ISSUE_FLAG AS (
    SELECT
        restaurant_name,
        CASE
            WHEN issue_type IS NULL AND issue_sub_type IS NULL THEN 'No issue'
            WHEN issue_type IN ('food', 'payment') THEN 'Restaurant-related issue'
            ELSE 'Other issue'
        END AS restaurant_related_issue_flag,
        ticket_id,
        order_id,
        compensation_amount
    FROM model_datamart.model_datamart_customer_service
)
SELECT
    restaurant_name,
    SUM(CASE WHEN restaurant_related_issue_flag = 'Restaurant-related issue' THEN 1 ELSE 0 END) AS count_restaurant_related_issue,
    SUM(CASE WHEN restaurant_related_issue_flag = 'Other issue' THEN 1 ELSE 0 END) AS count_other_issue,
    COUNT(*) AS total_order,
    ROUND(SUM(CASE WHEN restaurant_related_issue_flag = 'Restaurant-related issue' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS percent_restaurant_related_issue,
    SUM(compensation_amount) AS total_compensation_amount
FROM ISSUE_FLAG
GROUP BY restaurant_name