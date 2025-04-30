{{ config ( 
    materialized = "table",
    schema = 'report_customer_service' 
) }}

SELECT
    issue_type,
    issue_sub_type,
    COUNT(*) AS count_tickets,
    AVG(resolved_minute) AS average_resolved_minute,
    SUM(CASE WHEN issue_status <> 'resolved' THEN 1 ELSE 0 END) AS count_unresolved_tickets,
    SUM(compensation_amount) AS total_compensation
FROM {{ ref ('model_datamart_customer_service') }}
WHERE ticket_id IS NOT NULL
GROUP BY
    issue_type,
    issue_sub_type