--Base Events Model
WITH base_events AS (
SELECT
    user_pseudo_id,
    event_name,
    event_date,

    TIMESTAMP_MICROS(event_timestamp) AS event_time,

    device.category AS device,

    geo.country,

    traffic_source.source,

    ecommerce.purchase_revenue

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)

SELECT *
FROM base_events
LIMIT 20;

--User Dimension
WITH base_events AS (

SELECT
user_pseudo_id,
event_name,
TIMESTAMP_MICROS(event_timestamp) event_time,
device.category device,
geo.country country,
traffic_source.source source

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

)

SELECT

user_pseudo_id,

MIN(event_time) first_seen,

ANY_VALUE(device) device,

ANY_VALUE(country) country,

ANY_VALUE(source) acquisition_source,

COUNT(*) total_events

FROM base_events

GROUP BY user_pseudo_id

LIMIT 100;


--Understand Sessions
SELECT

user_pseudo_id,

(
SELECT value.int_value
FROM UNNEST(event_params)
WHERE key='ga_session_id'
) AS session_id,

event_name,

TIMESTAMP_MICROS(event_timestamp) event_time

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

LIMIT 20;

--Create Session Table
WITH sessions AS (

SELECT

user_pseudo_id,

(
SELECT value.int_value
FROM UNNEST(event_params)
WHERE key='ga_session_id'
) session_id,

TIMESTAMP_MICROS(event_timestamp) event_time,

event_name

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

)

SELECT

user_pseudo_id,

session_id,

MIN(event_time) session_start,

MAX(event_time) session_end,

COUNT(*) events_in_session

FROM sessions

WHERE session_id IS NOT NULL

GROUP BY
user_pseudo_id,
session_id

LIMIT 100;

--Calculate Session Duration
WITH sessions AS (

SELECT

user_pseudo_id,

(
SELECT value.int_value
FROM UNNEST(event_params)
WHERE key='ga_session_id'
) session_id,

TIMESTAMP_MICROS(event_timestamp) event_time

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

)

SELECT

user_pseudo_id,

session_id,

TIMESTAMP_DIFF(

MAX(event_time),

MIN(event_time),

SECOND

) AS session_duration_seconds

FROM sessions

WHERE session_id IS NOT NULL

GROUP BY
user_pseudo_id,
session_id

LIMIT 100;

--Session Statistics
WITH sessions AS (

SELECT

user_pseudo_id,

(
SELECT value.int_value
FROM UNNEST(event_params)
WHERE key='ga_session_id'
) session_id,

TIMESTAMP_MICROS(event_timestamp) event_time

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

),

session_summary AS (

SELECT

user_pseudo_id,

session_id,

TIMESTAMP_DIFF(

MAX(event_time),

MIN(event_time),

SECOND

) duration

FROM sessions

WHERE session_id IS NOT NULL

GROUP BY
user_pseudo_id,
session_id

)

SELECT

COUNT(*) total_sessions,

ROUND(AVG(duration),2) avg_session_duration,

MAX(duration) longest_session,

MIN(duration) shortest_session

FROM session_summary;

--Events Per Session
WITH sessions AS (

SELECT

user_pseudo_id,

(
SELECT value.int_value
FROM UNNEST(event_params)
WHERE key='ga_session_id'
) session_id,

event_name

FROM
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

)

SELECT

session_id,

COUNT(*) total_events

FROM sessions

WHERE session_id IS NOT NULL

GROUP BY session_id

ORDER BY total_events DESC

LIMIT 20;

