--Total Event
SELECT
    event_name,
    COUNT(*) AS total_events
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_name
ORDER BY total_events DESC;


--Count Users
SELECT
COUNT(DISTINCT user_pseudo_id) AS users
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--Count Sessions
SELECT
COUNTIF(event_name='session_start') AS sessions
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

--Daily Activity
SELECT
event_date,
COUNT(*) AS events
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_date
ORDER BY event_date;

--Explore Devices
SELECT
device.category,
COUNT(*) AS events
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY device.category
ORDER BY events DESC;

--Explore Countries
SELECT
geo.country,
COUNT(*) AS events
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY geo.country
ORDER BY events DESC
LIMIT 20;

--Explore Traffic Sources
SELECT
traffic_source.source,
COUNT(*) AS events
FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY traffic_source.source
ORDER BY events DESC;