--Dataset Date Range
SELECT
  MIN(event_date) AS first_day,
  MAX(event_date) AS last_day
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;


--Number of Users
SELECT
COUNT(DISTINCT user_pseudo_id) AS unique_users
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--Total Events
SELECT
COUNT(*) AS total_events
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--– Events Per User
SELECT
ROUND(COUNT(*) / COUNT(DISTINCT user_pseudo_id),2)
AS avg_events_per_user
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

-- Event Distribution
SELECT
event_name,
COUNT(*) AS total
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name
ORDER BY total DESC;


--Device Distribution
SELECT
device.category,
COUNT(DISTINCT user_pseudo_id) users
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY device.category
ORDER BY users DESC;

--Browser Distribution
SELECT
device.web_info.browser,
COUNT(*) events
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY device.web_info.browser
ORDER BY events DESC
LIMIT 15;

--Operating Systems
SELECT
device.operating_system,
COUNT(*) events
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY device.operating_system
ORDER BY events DESC;

--Countries
SELECT
geo.country,
COUNT(DISTINCT user_pseudo_id) users
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY geo.country
ORDER BY users DESC
LIMIT 20;

--Traffic Sources
SELECT
traffic_source.source,
COUNT(DISTINCT user_pseudo_id) users
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY traffic_source.source
ORDER BY users DESC;


--Missing User IDs
SELECT
COUNTIF(user_pseudo_id IS NULL) missing_users
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;


--Duplicate Events
SELECT
user_pseudo_id,
event_timestamp,
event_name,
COUNT(*)
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY
user_pseudo_id,
event_timestamp,
event_name
HAVING COUNT(*) > 1
LIMIT 20;

--Revenue Events
SELECT
event_name,
SUM(ecommerce.purchase_revenue) revenue
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name;

-- Nested Event Parameters
SELECT
event_name,
event_params
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
LIMIT 5;

