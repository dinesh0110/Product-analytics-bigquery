--Conversion Funnel

SELECT
event_name,
COUNT(DISTINCT user_pseudo_id) AS users
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name IN (
'session_start',
'view_item',
'add_to_cart',
'begin_checkout',
'purchase'
)
GROUP BY event_name
ORDER BY
CASE event_name
WHEN 'session_start' THEN 1
WHEN 'view_item' THEN 2
WHEN 'add_to_cart' THEN 3
WHEN 'begin_checkout' THEN 4
WHEN 'purchase' THEN 5
END;

--Funnel Conversion Rates

WITH funnel AS (

SELECT

COUNT(DISTINCT IF(event_name='session_start',user_pseudo_id,NULL)) sessions,

COUNT(DISTINCT IF(event_name='view_item',user_pseudo_id,NULL)) viewed,

COUNT(DISTINCT IF(event_name='add_to_cart',user_pseudo_id,NULL)) cart,

COUNT(DISTINCT IF(event_name='begin_checkout',user_pseudo_id,NULL)) checkout,

COUNT(DISTINCT IF(event_name='purchase',user_pseudo_id,NULL)) purchased

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

)

SELECT

sessions,

viewed,

cart,

checkout,

purchased,

ROUND(viewed/sessions*100,2) view_rate,

ROUND(cart/viewed*100,2) cart_rate,

ROUND(checkout/cart*100,2) checkout_rate,

ROUND(purchased/checkout*100,2) purchase_rate

FROM funnel;

--Revenue by Country

SELECT

geo.country,

ROUND(SUM(ecommerce.purchase_revenue),2) revenue

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY country

ORDER BY revenue DESC

LIMIT 15;

--Revenue by Device

SELECT

device.category,

ROUND(SUM(ecommerce.purchase_revenue),2) revenue

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY device.category;

--Top Traffic Sources

SELECT

traffic_source.source,

COUNT(DISTINCT user_pseudo_id) users,

ROUND(SUM(ecommerce.purchase_revenue),2) revenue

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY source

ORDER BY revenue DESC;


--Daily Active Users

SELECT

event_date,

COUNT(DISTINCT user_pseudo_id) dau

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY event_date

ORDER BY event_date;

--Cohort Retention

WITH first_visit AS (

SELECT

user_pseudo_id,

MIN(PARSE_DATE('%Y%m%d',event_date)) first_date

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY user_pseudo_id

),

activity AS (

SELECT

e.user_pseudo_id,

f.first_date,

PARSE_DATE('%Y%m%d',e.event_date) activity_date

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e

JOIN first_visit f

USING(user_pseudo_id)

)

SELECT

DATE_DIFF(activity_date,first_date,DAY) retention_day,

COUNT(DISTINCT user_pseudo_id) users

FROM activity

GROUP BY retention_day

ORDER BY retention_day;

--A/B testing

WITH users AS (

SELECT DISTINCT user_pseudo_id

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

),

assignments AS (

SELECT

user_pseudo_id,

CASE
WHEN MOD(ABS(FARM_FINGERPRINT(user_pseudo_id)),2)=0 THEN 'Variant A'
ELSE 'Variant B'
END AS variant

FROM users

),

purchases AS (

SELECT DISTINCT user_pseudo_id

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE event_name='purchase'

)

SELECT

variant,

COUNT(*) users,

COUNT(p.user_pseudo_id) purchasers,

ROUND(COUNT(p.user_pseudo_id)/COUNT(*)*100,2) conversion_rate

FROM assignments a

LEFT JOIN purchases p

USING(user_pseudo_id)

GROUP BY variant;

--Funnel
WITH funnel AS (
SELECT
COUNT(DISTINCT IF(event_name='session_start',user_pseudo_id,NULL)) sessions,
COUNT(DISTINCT IF(event_name='view_item',user_pseudo_id,NULL)) viewed,
COUNT(DISTINCT IF(event_name='add_to_cart',user_pseudo_id,NULL)) cart,
COUNT(DISTINCT IF(event_name='begin_checkout',user_pseudo_id,NULL)) checkout,
COUNT(DISTINCT IF(event_name='purchase',user_pseudo_id,NULL)) purchased
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)

SELECT 'Session Start' AS Stage, sessions AS Users, 100.00 AS Conversion_Rate FROM funnel
UNION ALL
SELECT 'View Item', viewed, ROUND(viewed/sessions*100,2) FROM funnel
UNION ALL
SELECT 'Add to Cart', cart, ROUND(cart/viewed*100,2) FROM funnel
UNION ALL
SELECT 'Checkout', checkout, ROUND(checkout/cart*100,2) FROM funnel
UNION ALL
SELECT 'Purchase', purchased, ROUND(purchased/checkout*100,2) FROM funnel;


--Traffic
SELECT
    traffic_source.source AS source,
    COUNT(DISTINCT user_pseudo_id) AS users,
    ROUND(SUM(ecommerce.purchase_revenue),2) AS revenue,
    ROUND(
        SUM(ecommerce.purchase_revenue) /
        COUNT(DISTINCT user_pseudo_id),
    2) AS revenue_per_user
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY source
ORDER BY revenue DESC;

--Retention
WITH first_visit AS (
SELECT
    user_pseudo_id,
    MIN(PARSE_DATE('%Y%m%d',event_date)) first_date
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY user_pseudo_id
),

activity AS (
SELECT
    e.user_pseudo_id,
    DATE_DIFF(
        PARSE_DATE('%Y%m%d',e.event_date),
        f.first_date,
        DAY
    ) retention_day
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
JOIN first_visit f
USING(user_pseudo_id)
),

retention AS (
SELECT
    retention_day,
    COUNT(DISTINCT user_pseudo_id) users
FROM activity
GROUP BY retention_day
),

base AS (
SELECT users AS day0_users
FROM retention
WHERE retention_day=0
)

SELECT
    retention_day,
    users,
    ROUND(users/day0_users*100,2) retention_percent
FROM retention
CROSS JOIN base
ORDER BY retention_day;
