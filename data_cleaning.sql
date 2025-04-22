SELECT *
FROM data
ORDER BY `Audience Segment`
LIMIT 100;

-- STAGING
CREATE TABLE data_staging
LIKE data;

INSERT data_staging
SELECT *
FROM data;

SELECT *
FROM data_staging; 

-- CLEAN DATA
-- replace foreign symbol to >
SELECT 
  REPLACE(
    REPLACE(
      REPLACE(`Audience Segment`, ' Â» ', '>'),
      'Â» ',
    '>'),
  ' Â»','>') AS cleaned_segment
FROM data_staging;

UPDATE data_staging
SET `Audience Segment` = REPLACE(
  REPLACE(
    REPLACE(`Audience Segment`, ' Â» ', '>'),
    'Â» ',
  '>'),
' Â»','>');

SELECT *
FROM data_staging;

SELECT DISTINCT `Audience Segment`
FROM data_staging
ORDER BY `Audience Segment`;

SELECT
  SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 1), '>', -1) AS level_1,
  SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 2), '>', -1) AS level_2,
  SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 3), '>', -1) AS level_3,
  SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 4), '>', -1) AS level_4,
  SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 5), '>', -1) AS level_5
FROM data_staging;

ALTER TABLE data_staging
ADD COLUMN level_1 VARCHAR(255),
ADD COLUMN level_2 VARCHAR(255),
ADD COLUMN level_3 VARCHAR(255),
ADD COLUMN level_4 VARCHAR(255),
ADD COLUMN level_5 VARCHAR(255);

UPDATE data_staging
SET 
  level_1 = SUBSTRING_INDEX(`Audience Segment`, '>', 1),
  level_2 = CASE 
             WHEN LENGTH(`Audience Segment`) - LENGTH(REPLACE(`Audience Segment`, '>', '')) >= 1
             THEN SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 2), '>', -1)
             ELSE NULL
           END,
  level_3 = CASE 
             WHEN LENGTH(`Audience Segment`) - LENGTH(REPLACE(`Audience Segment`, '>', '')) >= 2
             THEN SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 3), '>', -1)
             ELSE NULL
           END,
  level_4 = CASE 
             WHEN LENGTH(`Audience Segment`) - LENGTH(REPLACE(`Audience Segment`, '>', '')) >= 3
             THEN SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 4), '>', -1)
             ELSE NULL
           END,
  level_5 = CASE 
             WHEN LENGTH(`Audience Segment`) - LENGTH(REPLACE(`Audience Segment`, '>', '')) >= 4
             THEN SUBSTRING_INDEX(SUBSTRING_INDEX(`Audience Segment`, '>', 5), '>', -1)
             ELSE NULL
           END;

SELECT *
FROM data_staging;

ALTER TABLE data_staging
ADD COLUMN city VARCHAR(100),
ADD COLUMN state VARCHAR(100);

UPDATE data_staging
SET 
  city = TRIM(SUBSTRING_INDEX(location, ',', 1)),
  state = TRIM(SUBSTRING_INDEX(location, ',', -1));

-- Check for Nulls
SELECT
  SUM(CASE WHEN `Creative Size` IS NULL THEN 1 ELSE 0 END) AS creative_size_nulls,
  SUM(CASE WHEN `Creative Messaging` IS NULL THEN 1 ELSE 0 END) AS creative_messaging_nulls,
  SUM(CASE WHEN `App/URL` IS NULL THEN 1 ELSE 0 END) AS app_url_nulls,
  SUM(CASE WHEN `Exchange` IS NULL THEN 1 ELSE 0 END) AS exchange_nulls,
  SUM(CASE WHEN `Device Make` IS NULL THEN 1 ELSE 0 END) AS device_make_nulls,
  SUM(CASE WHEN `Impressions` IS NULL THEN 1 ELSE 0 END) AS impressions_nulls,
  SUM(CASE WHEN `Clicks` IS NULL THEN 1 ELSE 0 END) AS clicks_nulls,
  SUM(CASE WHEN `Viewable Impressions` IS NULL THEN 1 ELSE 0 END) AS viewable_impressions_nulls,
  SUM(CASE WHEN `Measurable Impressions` IS NULL THEN 1 ELSE 0 END) AS measurable_impressions_nulls,
  SUM(CASE WHEN `Total Conversions` IS NULL THEN 1 ELSE 0 END) AS total_conversions_nulls,
  SUM(CASE WHEN `Gross Cost` IS NULL THEN 1 ELSE 0 END) AS gross_cost_nulls,
  SUM(CASE WHEN `level_1` IS NULL THEN 1 ELSE 0 END) AS level_1_nulls,
  SUM(CASE WHEN `level_2` IS NULL THEN 1 ELSE 0 END) AS level_2_nulls,
  SUM(CASE WHEN `level_3` IS NULL THEN 1 ELSE 0 END) AS level_3_nulls,
  SUM(CASE WHEN `level_4` IS NULL THEN 1 ELSE 0 END) AS level_4_nulls,
  SUM(CASE WHEN `level_5` IS NULL THEN 1 ELSE 0 END) AS level_5_nulls,
  SUM(CASE WHEN `city` IS NULL THEN 1 ELSE 0 END) AS city_nulls,
  SUM(CASE WHEN `state` IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM data_staging;

/* DATA CLEANING */

-- Remove Duplicates
-- Standardize the Data
-- NULL Values or blank values
-- Remove Any Columns or Rows

-- CHECK FOR DUPLICATES / MISSPELLINGS
SELECT DISTINCT `Creative Size` FROM data_staging ORDER BY `Creative Size`;
SELECT DISTINCT `Creative Messaging` FROM data_staging ORDER BY `Creative Messaging`;
SELECT DISTINCT `App/URL` FROM data_staging ORDER BY `App/URL`;
SELECT DISTINCT `Exchange` FROM data_staging ORDER BY `Exchange`;
SELECT DISTINCT `Device Make` FROM data_staging ORDER BY `Device Make`;
SELECT DISTINCT `level_1` FROM data_staging ORDER BY `level_1`;

SELECT level_1 
FROM data_staging;

SELECT level_1 
FROM data_staging
WHERE level_1 IN ('Media & Entertainment', 'Media and Entertainment');

UPDATE data_staging
SET level_1 = 'Media and Entertainment'
WHERE level_1 = 'Media & Entertainment';

SELECT DISTINCT `level_2` FROM data_staging ORDER BY `level_2`;

SELECT DISTINCT level_2, level_3, level_4, level_5
FROM data_staging
WHERE level_2 LIKE 'Demo%';

UPDATE data_staging
SET level_2 = 'Demographic'
WHERE level_2 IN ('Demo', 'Demographics');

SELECT DISTINCT `level_3` FROM data_staging ORDER BY `level_3`;

SELECT DISTINCT level_3, level_4, level_5
FROM data_staging
WHERE level_3 LIKE 'Arts%';

UPDATE data_staging
SET level_3 = 'Arts and Entertainment'
WHERE level_3 = 'Arts & Entertainment';

SELECT DISTINCT level_3, level_4, level_5
FROM data_staging
WHERE level_3 LIKE 'Destination%';

SELECT DISTINCT level_3, level_4, level_5
FROM data_staging
WHERE level_3 LIKE 'Electronics%';

SELECT DISTINCT level_3, level_4, level_5
FROM data_staging
WHERE level_3 LIKE 'Food%';

UPDATE data_staging
SET level_3 = 'Food and Drink'
WHERE level_3 = 'Food & Drink';

SELECT DISTINCT level_3, level_4, level_5
FROM data_staging
WHERE level_3 LIKE 'Restaurant%';

SELECT DISTINCT `level_4` FROM data_staging ORDER BY `level_4`;
SELECT DISTINCT `level_5` FROM data_staging ORDER BY `level_5`;
SELECT DISTINCT `city` FROM data_staging ORDER BY `city`;
SELECT DISTINCT `state` FROM data_staging ORDER BY `state`;

-- Drop columns
ALTER TABLE data_staging
DROP COLUMN `Audience Segment`,
DROP COLUMN `Location`;

SELECT *
FROM data;

SELECT *
FROM data_staging;