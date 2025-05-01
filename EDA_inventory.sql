/* Exploratory Data Analysis */

-- EXCHANGE KPIs
SELECT 
	Exchange,
    AVG(`Viewable Impressions`/Impressions) AS viewability_rate,
    ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
    ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
    AVG(Clicks/Impressions) AS ctr,
    ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
    ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
    AVG(`Total Conversions`/Clicks) AS cvr
FROM data_staging
GROUP BY Exchange
ORDER BY viewability_rate DESC;


-- PUBLISHER KPIs
SELECT 
	`App/URL` AS publisher,
    AVG(`Viewable Impressions`/Impressions) AS viewability_rate,
    ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
    ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
    AVG(Clicks/Impressions) AS ctr,
    ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
    ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
    AVG(`Total Conversions`/Clicks) AS cvr
FROM data_staging
GROUP BY publisher
HAVING 
    vcpm < 80
ORDER BY viewability_rate DESC;


-- PUBLISHER & EXCHANGE KPIs
SELECT 
	`App/URL` AS publisher,
    Exchange,
    AVG(`Viewable Impressions`/Impressions) AS viewability_rate,
    ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
    ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
    AVG(Clicks/Impressions) AS ctr,
    ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
    ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
    AVG(`Total Conversions`/Clicks) AS cvr
FROM data_staging
GROUP BY `App/URL`, Exchange
HAVING 
	viewability_rate > 0.6 
    AND vcpm < 80
ORDER BY `App/URL`;


SELECT publisher, exchange_count
FROM (
	SELECT `App/URL` AS publisher, COUNT(DISTINCT Exchange) AS exchange_count
    FROM data_staging
    GROUP BY `App/URL`
) AS sub
WHERE exchange_count > 1
ORDER BY exchange_count DESC;


SELECT *
FROM data_staging;
