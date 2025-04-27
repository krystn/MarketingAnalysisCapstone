/* Exploratory Data Analysis */

-- EXCHANGE KPIs
SELECT 
	Exchange,
    SUM(`Viewable Impressions`)/SUM(Impressions) AS viewability_rate,
    ROUND((SUM(`Gross Cost`)*1000 / SUM(`Viewable Impressions`)), 2) AS vcpm,
    ROUND((SUM(`Gross Cost`) / SUM(`Total Conversions`)), 2) AS cpa,
    SUM(Clicks) / SUM(Impressions) AS ctr,
    ROUND(SUM(`Gross Cost`) / SUM(Clicks), 2) AS cpc,
    ROUND(SUM(`Gross Cost`) / SUM(Impressions) * 1000, 2) AS cpm,
    SUM(`Total Conversions`) / SUM(Clicks) AS cvr
FROM data_staging
GROUP BY Exchange
HAVING 
	SUM(Impressions) > 10000 
	AND SUM(`Viewable Impressions`) / SUM(Impressions) > 0.5
    AND vcpm < 80
ORDER BY ctr DESC;

-- PUBLISHER KPIs
SELECT 
	`App/URL` AS publisher,
    SUM(`Viewable Impressions`) / SUM(Impressions) AS viewability_rate,
    ROUND((SUM(`Gross Cost`)*1000 / SUM(`Viewable Impressions`)), 2) AS vcpm,
    ROUND((SUM(`Gross Cost`) / SUM(`Total Conversions`)), 2) AS cpa,
    SUM(Clicks) / SUM(Impressions) AS ctr,
    ROUND(SUM(`Gross Cost`) / SUM(Clicks), 2) AS cpc,
    ROUND(SUM(`Gross Cost`) / SUM(Impressions) * 1000, 2) AS cpm,
    SUM(`Total Conversions`) / SUM(Clicks) AS cvr
FROM data_staging
GROUP BY `App/URL`
HAVING 
	SUM(Impressions) > 10000 
	AND viewability_rate > 0.6 
    AND vcpm < 80
ORDER BY ctr DESC;


SELECT *
FROM data_staging;