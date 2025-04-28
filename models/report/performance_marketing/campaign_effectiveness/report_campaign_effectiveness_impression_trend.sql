WITH DATE_TRANSFORMATION AS (
	SELECT
	    campaign_name,
	    strftime(interaction_datetime, '%Y-%m') AS interaction_year_month,
	    event_type
	FROM model_datamart.model_datamart_performance_marketing
    WHERE campaign_id IS NOT NULL
)
SELECT
    campaign_name,
    interaction_year_month,
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS count_impression,
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS count_click,
    SUM(CASE WHEN event_type = 'conversion' THEN 1 ELSE 0 END) AS count_conversion
FROM DATE_TRANSFORMATION
GROUP BY
    campaign_name,
    interaction_year_month