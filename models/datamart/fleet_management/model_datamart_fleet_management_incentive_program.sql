SELECT
    drivers_master.driver_id,
    drivers_master.bonus_tier,
    driver_log.incentive_program,
    driver_log.applied_date,
    driver_log.delivery_target,
    driver_log.actual_deliveries,
    driver_log.bonus_amount,
    driver_log.bonus_qualified
FROM main.drivers_master
LEFT JOIN main.order_log_incentive_sessions_driver_incentive_logs AS driver_log 
ON drivers_master.driver_id = driver_log.driver_id