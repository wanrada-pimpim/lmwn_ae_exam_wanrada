{{ config ( 
    materialized = "table",
    schema = 'report_customer_service' 
) }}

SELECT
    issue_type,
    issue_sub_type,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolved_minute), 2) AS average_resolved_minute,
FROM {{ ref ('model_datamart_customer_service') }}
WHERE 
    ticket_id IS NOT NULL AND 
    issue_type IN ('food', 'payment')
GROUP BY
    issue_type,
    issue_sub_type