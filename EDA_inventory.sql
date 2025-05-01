/* Exploratory Data Analysis */

-- CALCULATED BENCHMARKS
SELECT SUM(`Gross Cost`) / SUM(`Total Conversions`) AS avg_cpa
FROM data_staging;

SELECT SUM(`Gross Cost`) / SUM(Clicks) AS avg_cpc
FROM data_staging;

SELECT (SUM(`Gross Cost`) / SUM(`Impressions`)) * 1000 AS avg_cpm
FROM data_staging;

SELECT *
FROM data_staging;

-- EXCHANGE KPIs
SELECT 
	Exchange,
    ROUND(AVG(`Viewable Impressions`/Impressions), 4) AS viewability_rate,
    ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
    ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
    ROUND(AVG(Clicks/Impressions), 4) AS ctr,
    ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
    ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
    ROUND(AVG(`Total Conversions`/Clicks), 4) AS cvr
FROM data_staging
GROUP BY Exchange
ORDER BY viewability_rate DESC;


-- EXCHANGE KPIs WITH NORMALIZED SCORE
-- Viewability rate at 30%
-- vCPM at 20%
-- The rest at 10% each
WITH metrics AS (
	SELECT 
		Exchange,
		ROUND(AVG(`Viewable Impressions`/Impressions), 4) AS viewability_rate,
		ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
		ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
		ROUND(AVG(Clicks/Impressions), 4) AS ctr,
		ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
		ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
		ROUND(AVG(`Total Conversions`/Clicks), 4) AS cvr
	FROM data_staging
	GROUP BY Exchange
),
min_max AS (
	SELECT 
		MIN(viewability_rate) AS min_view,
		MAX(viewability_rate) AS max_view,
		MIN(vcpm) AS min_vcpm,
		MAX(vcpm) AS max_vcpm,
		MIN(cpa) AS min_cpa,
		MAX(cpa) AS max_cpa,
		MIN(ctr) AS min_ctr,
		MAX(ctr) AS max_ctr,
		MIN(cpc) AS min_cpc,
		MAX(cpc) AS max_cpc,
		MIN(cpm) AS min_cpm,
		MAX(cpm) AS max_cpm,
		MIN(cvr) AS min_cvr,
		MAX(cvr) AS max_cvr
	FROM metrics
)
SELECT 
	m.*,
    ROUND(
		((m.viewability_rate - mm.min_view) / (mm.max_view - mm.min_view)) * 0.3 +
		((mm.max_vcpm - m.vcpm) / (mm.max_vcpm - mm.min_vcpm)) * 0.2 +
		((mm.max_cpa - m.cpa) / (mm.max_cpa - mm.min_cpa)) * 0.1 +
		((m.ctr - mm.min_ctr) / (mm.max_ctr - mm.min_ctr)) * 0.1 +
		((mm.max_cpc - m.cpc) / (mm.max_cpc - mm.min_cpc)) * 0.1 +
		((mm.max_cpm - m.cpm) / (mm.max_cpm - mm.min_cpm)) * 0.1 +
		((m.cvr - mm.min_cvr) / (mm.max_cvr - mm.min_cvr)) * 0.1,
		2
	) AS normalized_score
FROM metrics m
CROSS JOIN min_max mm
ORDER BY normalized_score DESC;


-- PUBLISHER KPIs
SELECT 
	`App/URL` AS publisher,
	ROUND(AVG(`Viewable Impressions`/Impressions), 4) AS viewability_rate,
    ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
    ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
    ROUND(AVG(Clicks/Impressions), 4) AS ctr,
    ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
    ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
    ROUND(AVG(`Total Conversions`/Clicks), 4) AS cvr
FROM data_staging
GROUP BY publisher
HAVING 
    vcpm < 80
ORDER BY viewability_rate DESC;

-- PUBLISHER KPIs WITH NORMALIZED SCORE
-- Viewability rate at 30%
-- vCPM at 20%
-- The rest at 10% each
WITH metrics AS (
	SELECT 
		`App/URL` AS publisher,
		ROUND(AVG(`Viewable Impressions`/Impressions), 4) AS viewability_rate,
		ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
		ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
		ROUND(AVG(Clicks/Impressions), 4) AS ctr,
		ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
		ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
		ROUND(AVG(`Total Conversions`/Clicks), 4) AS cvr
	FROM data_staging
    GROUP BY publisher
),
min_max AS (
	SELECT 
		MIN(viewability_rate) AS min_view,
		MAX(viewability_rate) AS max_view,
		MIN(vcpm) AS min_vcpm,
		MAX(vcpm) AS max_vcpm,
		MIN(cpa) AS min_cpa,
		MAX(cpa) AS max_cpa,
		MIN(ctr) AS min_ctr,
		MAX(ctr) AS max_ctr,
		MIN(cpc) AS min_cpc,
		MAX(cpc) AS max_cpc,
		MIN(cpm) AS min_cpm,
		MAX(cpm) AS max_cpm,
		MIN(cvr) AS min_cvr,
		MAX(cvr) AS max_cvr
	FROM metrics
)
SELECT 
	m.*,
    ROUND(
		((m.viewability_rate - mm.min_view) / (mm.max_view - mm.min_view)) * 0.3 +
		((mm.max_vcpm - m.vcpm) / (mm.max_vcpm - mm.min_vcpm)) * 0.2 +
		((mm.max_cpa - m.cpa) / (mm.max_cpa - mm.min_cpa)) * 0.1 +
		((m.ctr - mm.min_ctr) / (mm.max_ctr - mm.min_ctr)) * 0.1 +
		((mm.max_cpc - m.cpc) / (mm.max_cpc - mm.min_cpc)) * 0.1 +
		((mm.max_cpm - m.cpm) / (mm.max_cpm - mm.min_cpm)) * 0.1 +
		((m.cvr - mm.min_cvr) / (mm.max_cvr - mm.min_cvr)) * 0.1,
		2
	) AS normalized_score
FROM metrics m
CROSS JOIN min_max mm
HAVING 
    vcpm < 80
ORDER BY normalized_score DESC;


-- PUBLISHER & EXCHANGE KPIs
SELECT 
		`App/URL` AS publisher,
		Exchange,
		ROUND(AVG(`Viewable Impressions`/Impressions), 4) AS viewability_rate,
		ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
		ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
		ROUND(AVG(Clicks/Impressions), 4) AS ctr,
		ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
		ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
		ROUND(AVG(`Total Conversions`/Clicks), 4) AS cvr
FROM data_staging
GROUP BY `App/URL`, Exchange
HAVING 
	viewability_rate > 0.6 
    AND vcpm < 80
ORDER BY `App/URL`;


-- PUBLISHER AND EXCHANGE KPIs WITH NORMALIZED SCORE
-- Viewability rate at 30%
-- vCPM at 20%
-- The rest at 10% each
WITH metrics AS (
	SELECT 
		`App/URL` AS publisher,
		Exchange,
		ROUND(AVG(`Viewable Impressions`/Impressions), 4) AS viewability_rate,
		ROUND(AVG(`Gross Cost`*1000 / `Viewable Impressions`), 2) AS vcpm,
		ROUND((AVG(`Gross Cost`/`Total Conversions`)), 2) AS cpa,
		ROUND(AVG(Clicks/Impressions), 4) AS ctr,
		ROUND(AVG(`Gross Cost`/Clicks), 2) AS cpc,
		ROUND(AVG(`Gross Cost`/Impressions) * 1000, 2) AS cpm,
		ROUND(AVG(`Total Conversions`/Clicks), 4) AS cvr
  FROM data_staging
  GROUP BY publisher, Exchange
),
min_max AS (
	SELECT 
		MIN(viewability_rate) AS min_view,
		MAX(viewability_rate) AS max_view,
		MIN(vcpm) AS min_vcpm,
		MAX(vcpm) AS max_vcpm,
		MIN(cpa) AS min_cpa,
		MAX(cpa) AS max_cpa,
		MIN(ctr) AS min_ctr,
		MAX(ctr) AS max_ctr,
		MIN(cpc) AS min_cpc,
		MAX(cpc) AS max_cpc,
		MIN(cpm) AS min_cpm,
		MAX(cpm) AS max_cpm,
		MIN(cvr) AS min_cvr,
		MAX(cvr) AS max_cvr
	FROM metrics
)
SELECT 
	m.*,
    ROUND(
		((m.viewability_rate - mm.min_view) / (mm.max_view - mm.min_view)) * 0.3 +
		((mm.max_vcpm - m.vcpm) / (mm.max_vcpm - mm.min_vcpm)) * 0.2 +
		((mm.max_cpa - m.cpa) / (mm.max_cpa - mm.min_cpa)) * 0.1 +
		((m.ctr - mm.min_ctr) / (mm.max_ctr - mm.min_ctr)) * 0.1 +
		((mm.max_cpc - m.cpc) / (mm.max_cpc - mm.min_cpc)) * 0.1 +
		((mm.max_cpm - m.cpm) / (mm.max_cpm - mm.min_cpm)) * 0.1 +
		((m.cvr - mm.min_cvr) / (mm.max_cvr - mm.min_cvr)) * 0.1,
		2
	) AS normalized_score
FROM metrics m
CROSS JOIN min_max mm
HAVING
	viewability_rate > 0.6 
    AND vcpm < 80
ORDER BY normalized_score DESC;




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
