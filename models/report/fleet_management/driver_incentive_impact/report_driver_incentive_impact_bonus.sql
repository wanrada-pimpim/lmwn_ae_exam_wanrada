SELECT
    driver_id,
    bonus_tier,
    SUM(bonus_amount) AS total_bonus_amount
FROM model_datamart.model_datamart_fleet_management_incentive_program
WHERE bonus_qualified IS TRUE
GROUP BY
    driver_id,
    bonus_tier