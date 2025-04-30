{{ config ( 
    materialized = "table",
    schema = 'report_customer_service' 
) }}

SELECT
    issue_type,
    issue_sub_type,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolved_minute), 2) AS average_resolved_minute,
    ROUND(AVG(csat_score), 2) AS average_csat_score
FROM {{ ref ('model_datamart_customer_service') }}
WHERE 
    ticket_id IS NOT NULL AND 
    issue_type IN ('delivery', 'rider')
GROUP BY
    issue_type,
    issue_sub_type