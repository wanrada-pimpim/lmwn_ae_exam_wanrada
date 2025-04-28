SELECT
    order_transactions.order_id,
    support_tickets.ticket_id,
    support_tickets.issue_type,
    support_tickets.issue_sub_type,
    support_tickets.opened_datetime,
    support_tickets.resolved_datetime,
    date_diff('minute', support_tickets.opened_datetime, support_tickets.resolved_datetime) AS resolved_minute,
    support_tickets.status AS issue_status,
    support_tickets.compensation_amount,
    support_tickets.csat_score,
    order_transactions.driver_id,
    restaurants_master.name AS restaurant_name
FROM main.order_transactions
LEFT JOIN main.support_tickets 
ON order_transactions.order_id = ae_exam_db.main.support_tickets.order_id
LEFT JOIN main.restaurants_master 
ON order_transactions.restaurant_id = restaurants_master.restaurant_id