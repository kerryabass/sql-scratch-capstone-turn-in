SELECT COUNT(DISTINCT utm_source) as source
FROM page_visits;

SELECT COUNT(DISTINCT utm_campaign) as campaign
FROM page_visits;

SELECT DISTINCT utm_source, 
    utm_campaign
FROM page_visits;

SELECT DISTINCT page_name
FROM page_visits;

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY 1)
SELECT utm_campaign,
    COUNT (first_touch_at) as first_touch_count
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;



WITH last_touch AS (
    SELECT user_id,
				MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY 1)
SELECT utm_campaign,
    COUNT (last_touch_at) as last_touch_count
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;

/*
The following query is an alternative method to calculate last touch. By including utm_campaign in the first SELECT query, a JOIN is not required.
*/
WITH last_touch AS (
    SELECT user_id, 
  			utm_campaign,
				MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY 1)
SELECT utm_campaign,
    COUNT (last_touch_at) as last_touch_count
FROM last_touch lt
GROUP BY 1
ORDER BY 2 DESC;
/*
END
*/

SELECT COUNT(DISTINCT user_id) as visitors_purchased
FROM page_visits
WHERE page_name = '4 - purchase';

WITH last_touch_purchased AS (
    SELECT user_id,
				MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY 1)
SELECT utm_campaign,
    COUNT (last_touch_at) as last_touch_count_purchased
FROM last_touch_purchased lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY 1)
SELECT utm_campaign,
    COUNT (first_touch_at) as most_common_first_touch
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
      
WITH last_touch AS (
    SELECT user_id,
				MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY 1)
SELECT utm_campaign,
    COUNT (last_touch_at) as most_common_last_touch
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

WITH last_touch_purchased AS (
    SELECT user_id,
				MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY 1)
SELECT utm_campaign,
    COUNT (last_touch_at) as most_last_touch_on_purchase_page
FROM last_touch_purchased lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
