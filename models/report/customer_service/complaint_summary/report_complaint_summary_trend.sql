{{ config ( 
    materialized = "table",
    schema = 'report_customer_service' 
) }}

WITH ISSUE_YEAR_MONTH AS (
    SELECT
        STRFTIME(opened_datetime, '%Y-%m') AS issue_year_month,
        ticket_id,
        resolved_minute
    FROM {{ ref ('model_datamart_customer_service') }}
    WHERE ticket_id IS NOT NULL
)
SELECT
    issue_year_month,
    COUNT(*) AS count_issue,
    ROUND(AVG(resolved_minute), 2) AS average_resolved_minute
FROM ISSUE_YEAR_MONTH
GROUP BY issue_year_month