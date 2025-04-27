/* Exploratory Data Analysis */

SELECT 
	`Creative Size`,
    SUM(`Viewable Impressions`)/SUM(Impressions) AS viewability_rate,
    ROUND((SUM(`Gross Cost`)*1000 / SUM(`Viewable Impressions`)), 2) AS vcpm,
    ROUND((SUM(`Gross Cost`) / SUM(`Total Conversions`)), 2) AS cpa,
    SUM(Clicks) / SUM(Impressions) AS ctr,
    ROUND(SUM(`Gross Cost`) / SUM(Clicks), 2) AS cpc,
    ROUND(SUM(`Gross Cost`) / SUM(Impressions) * 1000, 2) AS cpm,
    SUM(`Total Conversions`) / SUM(Clicks) AS cvr
FROM data_staging
GROUP BY `Creative Size`
ORDER BY `Creative Size`;

SELECT 
	`Device Make`,
    SUM(`Viewable Impressions`)/SUM(Impressions) AS viewability_rate,
    ROUND((SUM(`Gross Cost`)*1000 / SUM(`Viewable Impressions`)), 2) AS vcpm,
    ROUND((SUM(`Gross Cost`) / SUM(`Total Conversions`)), 2) AS cpa,
    SUM(Clicks) / SUM(Impressions) AS ctr,
    ROUND(SUM(`Gross Cost`) / SUM(Clicks), 2) AS cpc,
    ROUND(SUM(`Gross Cost`) / SUM(Impressions) * 1000, 2) AS cpm,
    SUM(`Total Conversions`) / SUM(Clicks) AS cvr
FROM data_staging
GROUP BY `Device Make`
ORDER BY `Device Make`;

SELECT 
	`Creative Messaging`,
    SUM(`Viewable Impressions`)/SUM(Impressions) AS viewability_rate,
    ROUND((SUM(`Gross Cost`)*1000 / SUM(`Viewable Impressions`)), 2) AS vcpm,
    ROUND((SUM(`Gross Cost`) / SUM(`Total Conversions`)), 2) AS cpa,
    SUM(Clicks) / SUM(Impressions) AS ctr,
    ROUND(SUM(`Gross Cost`) / SUM(Clicks), 2) AS cpc,
    ROUND(SUM(`Gross Cost`) / SUM(Impressions) * 1000, 2) AS cpm,
    SUM(`Total Conversions`) / SUM(Clicks) AS cvr
FROM data_staging
GROUP BY `Creative Messaging`
ORDER BY `Creative Messaging`;

SELECT 
	state,
    SUM(`Viewable Impressions`)/SUM(Impressions) AS viewability_rate,
    ROUND((SUM(`Gross Cost`)*1000 / SUM(`Viewable Impressions`)), 2) AS vcpm,
    ROUND((SUM(`Gross Cost`) / SUM(`Total Conversions`)), 2) AS cpa,
    SUM(Clicks) / SUM(Impressions) AS ctr,
    ROUND(SUM(`Gross Cost`) / SUM(Clicks), 2) AS cpc,
    ROUND(SUM(`Gross Cost`) / SUM(Impressions) * 1000, 2) AS cpm,
    SUM(`Total Conversions`) / SUM(Clicks) AS cvr
FROM data_staging
GROUP BY state
ORDER BY state;



SELECT *
FROM data_staging;