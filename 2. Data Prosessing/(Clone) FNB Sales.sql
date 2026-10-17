-- Databricks notebook source
-- DBTITLE 1,Cell 1
--Checking what is in the data--
SELECT*
FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`;


--Renaming columns-
SELECT
    `Date`,
    ROUND(`Sales`,2) AS Sales,
    ROUND(`Cost Of Sales`,2) AS Cost_Of_Sales,
    `Quantity Sold`,
    ROUND(`Sales`/`Quantity Sold`,2) AS daily_sales_price_per_unit
FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`;

--Checking for duplicates
SELECT
`Date`,
COUNT(*) AS Duplicate_CNT
FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`
GROUP BY `Date`
HAVING COUNT(*)>1
ORDER BY COUNT(*) DESC;
--------------------------------------------------------------------------------------
--Cheking for NULL values, zero, negative values

SELECT
  COUNT(*) AS total_rows,
  COUNT_IF(`Date` IS NULL) AS null_dates,
  COUNT_IF(`Sales` IS NULL) AS null_sales,
  COUNT_IF(`Sales` = 0) AS zero_sales,
  COUNT_IF(`Cost Of Sales` IS NULL) AS null_cost,
  COUNT_IF(`Quantity Sold` IS NULL) AS null_qty,
  COUNT_IF(`Quantity Sold` = 0) AS zero_qty,
  COUNT_IF(`Sales` < 0) AS negative_sales
  FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`;











----------------------------------------------------------------------------------------
SELECT
YEAR(TO_DATE(CAST(Date AS TIMESTAMP))) as Year,
MONTH(TO_DATE(CAST(DATE AS TIMESTAMP))) as Month,
DATE_FORMAT(TO_DATE(CAST(Date AS TIMESTAMP)), 'MMMM') as Month_name,
SUM(CAST(`Sales` AS DOUBLE))as Total_Sales
FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`
GROUP BY Year, Month, Month_name
ORDER BY Year ASC,Month ASC;

--Daily sales price per unit
SELECT
    `Date`,
    ROUND(`Sales`,2) AS Sales,
    `Quantity Sold`,
    --Full precise price for calculations(don't round off here)
    `Sales`/`Quantity Sold` AS price_exact,
    --Rounded only for the report
    ROUND(`Sales`/`Quantity Sold`,2) AS price_display
FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`;

---Checking average unit sales price--

SELECT
    ROUND(SUM(`Sales`),2) AS Total_Sales,
    SUM(`Quantity Sold`) AS Total_Qty,
    ROUND(SUM(`Sales`)/SUM(`Quantity Sold`),2) AS average_unit_sale_price
    FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`;

---Daily % gross profit
    SELECT
    `Date`,
    ROUND(`Sales`/`Quantity Sold`,2) AS daily_sales_price_per_unit,
    ROUND(`Cost Of Sales`/`Quantity Sold`,2) AS daily_cost_price_per_unit,
    ROUND((`Sales`-`Cost Of Sales`)/`Quantity Sold`,2) AS daily_gross_profit_per_unit,
    ROUND((`Sales`-`Cost Of Sales`)/`Sales`,2) AS daily_gross_profit_percentage
    FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`
    ORDER BY `Date`;



SELECT
`Date`,
ROUND(`Sales`/`Quantity Sold`,2) AS daily_sales_price_per_unit,
ROUND(`Cost Of Sales`/`Quantity Sold`,2) AS daily_cost_price_per_unit,
ROUND((`Sales`- `Cost Of Sales`)/`Quantity Sold`,2) AS gross_profit_per_unit,
ROUND((`Sales`-`Cost Of Sales`)/`Sales`*100,2) AS daily_pct_gross_per_unit,
ROUND(AVG(`Sales`/`Quantity Sold`)OVER(),2) AS average_unit_sales_price
FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`
ORDER BY `Date`; 

SELECT
  ROUND(AVG(Sales / `Quantity Sold`),0) AS average_unit_sales_price
FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`;



SELECT
  Date,
  Sales / `Quantity Sold` AS daily_sales_price_per_unit,
  AVG(Sales / `Quantity Sold`) OVER () AS average_unit_sales_price,
  (Sales / `Quantity Sold`) - (`Cost Of Sales` / `Quantity Sold`) AS daily_gross_profit_per_unit,
  (((Sales / `Quantity Sold`) - (`Cost Of Sales` / `Quantity Sold`)) / (Sales / `Quantity Sold`)) * 100 AS daily_pct_gross_per_unit
  FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`;
-------------------------------------------------------------------------------------------

WITH cleaned_sales AS (
  -- STEP 1: This inside is the CTE - it cleans first
  SELECT 
    TO_DATE(CAST(`Date` AS TIMESTAMP)) AS Clean_Date,
    YEAR(TO_DATE(CAST(`Date` AS TIMESTAMP))) AS Year,
    MONTH(TO_DATE(CAST(`Date` AS TIMESTAMP))) AS Month,
    DATE_FORMAT(TO_DATE(CAST(`Date` AS TIMESTAMP)), 'MMMM') AS Month_Name,
    `Sales`,
    `Cost Of Sales`,
    `Quantity Sold`
  FROM fnb_sales_catalog.fnb_sales.`1787660127396_sales_case_study_2021_1`
  WHERE `Quantity Sold` != 0 AND `Sales` != 0
)

-- STEP 2: This SELECT uses the CTE
SELECT 
  *,
  ROUND(`Sales` / `Quantity Sold`, 2) AS daily_sales_price_per_unit,
  ROUND(`Cost Of Sales` / `Quantity Sold`, 2) AS daily_cost_price_per_unit,
  ROUND((`Sales` - `Cost Of Sales`) / `Quantity Sold`, 2) AS gross_profit_per_unit,
  ROUND((`Sales` - `Cost Of Sales`) / `Sales` * 100, 2) AS daily_pct_gross_per_unit,
  ROUND(AVG(`Sales` / `Quantity Sold`) OVER(), 2) AS average_unit_sales_price
FROM cleaned_sales
ORDER BY Clean_Date ASC;








---