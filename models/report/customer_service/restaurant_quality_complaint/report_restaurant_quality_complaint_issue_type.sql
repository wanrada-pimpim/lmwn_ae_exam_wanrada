SELECT
    issue_type,
    issue_sub_type,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolved_minute), 2) AS average_resolved_minute,
FROM model_datamart.model_datamart_customer_service
WHERE 
    ticket_id IS NOT NULL AND 
    issue_type IN ('food', 'payment')
GROUP BY
    issue_type,
    issue_sub_type