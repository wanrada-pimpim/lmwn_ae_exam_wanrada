SELECT
    drivers_master.driver_id,
    drivers_master.region,
    drivers_master.vehicle_type,
    drivers_master.driver_rating,
    order_transactions.order_id,
    order_transactions.order_status,
    order_transactions.delivery_zone,
    order_transactions.pickup_datetime,
    order_transactions.delivery_datetime,
    date_diff('minute', order_transactions.pickup_datetime, order_transactions.delivery_datetime) AS delivery_minute,
    order_transactions.is_late_delivery,
    support_tickets.issue_type,
    support_tickets.issue_sub_type
FROM main.drivers_master
LEFT JOIN main.order_transactions 
ON drivers_master.driver_id = order_transactions.driver_id
LEFT JOIN main.support_tickets 
ON order_transactions.order_id = support_tickets.order_id