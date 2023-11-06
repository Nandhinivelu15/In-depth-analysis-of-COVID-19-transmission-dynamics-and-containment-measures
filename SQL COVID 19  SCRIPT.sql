-- *********************
-- IMPORTING CSV file to MYSQL
-- *********************

-- Replace all blanks with 0 in the CSV
-- in CSV convert dates to YYYY-MM-DD format and import it as TEXT
-- Take all values of int as bigint


use covid_project;

SELECT * FROM owid_covid_data;
-- ****** Handling Missing Values ****** ---

-- Clearly, OWiD have performed a series of aggregations based on criteria such as income, or general aggregations (for example on the continent level).Since they may prove to be useful later on, there is no reason to discard them. The null values can simply be set equal to the 'OWID' value, in order to be able to invoke them later on if we need to.

-- *********************
-- EXPLORATION
-- *********************
SELECT * FROM owid_covid_data;

SELECT continent, count(*) FROM owid_covid_data GROUP BY 1;

SELECT location, count(*) 
FROM owid_covid_data WHERE continent = 'OWID'
GROUP BY 1;

SELECT count(*) FROM owid_covid_data WHERE location = 'World';

SELECT * FROM owid_covid_data WHERE location = 'World';


-- ****** Exploratory analysis *******-- 

-- How many lines does the dataset have?
SELECT COUNT(*)
FROM owid_covid_data; 

-- Countries --
SELECT COUNT(distinct location) as Countries
FROM owid_covid_data;

-- continents--
SELECT COUNT(distinct continent) as Countinents
FROM owid_covid_data;



-- ******************************
-- SLIDE 1
-- TOTAL Deaths
-- ******************************
SELECT MAX(total_cases), MAX(total_deaths) FROM owid_covid_data WHERE location = 'World';


-- ******************************
-- SLIDE 2
-- Growth in Cases and New Cases
-- ******************************
SELECT date, total_cases, new_cases FROM owid_covid_data WHERE location = 'World' order by 1;


-- ******************************
-- SLIDE 3
-- Growth in Death and New Cases
-- ******************************

SELECT date, new_deaths FROM owid_covid_data WHERE location = 'World' order by 1;


-- ******************************
-- SLIDE 4
-- Growth in Death and Vaccinations
-- ******************************

SELECT date, total_vaccinations FROM owid_covid_data WHERE location = 'World' order by 1;


-- ******************************
-- Rough Work
SELECT * FROM covid_data WHERE location in 
('High income','Low income','Lower middle income','Upper middle income');

-- Some Metrics
-- Spread: Total Cases / Population
-- Death Rate: Death / Population
-- Vaccination efforts: Vaccination / Population


-- ******************************
-- SLIDE 5
-- SPREAD by INCOME LEVEL
-- ******************************

SELECT location as income_level, MAX(total_cases) / MAX(population) * 100 as spread
FROM owid_covid_data WHERE location in 
('High income','Low income','Lower middle income','Upper middle income')
GROUP by 1 ORDER BY 2 DESC;



-- ******************************
-- SLIDE 6
-- SPREAD, Death & Vaccinations by Continent
-- ******************************

-- SPREAD
SELECT continent, MAX(total_cases) / MAX(population) * 100 as spread
FROM owid_covid_data  WHERE continent <> 'OWID'
GROUP by 1 ORDER BY 2 DESC;

-- Death Rate
SELECT continent, MAX(total_deaths) / MAX(population) * 100 as d_rate
FROM owid_covid_data  WHERE continent <> 'OWID'
GROUP by 1 ORDER BY 2 DESC;

-- Vaccination Rate
SELECT continent, MAX(total_vaccinations) / MAX(population) as v_rate
FROM owid_covid_data  WHERE continent <> 'OWID'
GROUP by 1 ORDER BY 2 DESC;



-- ******************************
-- SLIDE 7
-- SPREAD Country
-- ******************************
SELECT location, MAX(total_cases) / MAX(population) * 100 as spread, MAX(population) as pop
FROM owid_covid_data  WHERE continent <> 'OWID'
GROUP by 1 
HAVING pop > 100000000
ORDER BY 2 DESC;



-- ******************************
-- Rough Work
SELECT location, MAX(total_cases) / MAX(population) * 100 as spread
FROM owid_covid_data  WHERE continent <> 'OWID'
GROUP by 1;

-- *******************************
-- SLIDE 8
-- Distribution of Spread (Histogram)
-- *******************************


SELECT 
	CASE 
		WHEN spread < 5 THEN "1. 0 to 5"
        WHEN spread < 10 THEN "2. 5 to 10"
        WHEN spread < 15 THEN "3. 10 to 15"
        WHEN spread < 20 THEN "4. 15 to 20"
        WHEN spread < 25 THEN "5. 20 to 25"
        WHEN spread < 30 THEN "6. 25 to 30"
        WHEN spread < 35 THEN "7. 30 to 35"
        WHEN spread < 40 THEN "8. 35 to 40"
        
	ELSE "9. > 40"
    END as spread_flag, count(location)
FROM
(SELECT location, MAX(total_cases) / MAX(population) * 100 as spread
FROM owid_covid_data  WHERE continent <> 'OWID'
GROUP by 1) as temp
GROUP by 1;


-- *******************************
-- SLIDE 9
-- SPREAD vs GDP
-- *******************************


SELECT location, MAX(total_cases) / MAX(population) * 100 as spread, max(gdp_per_capita) as gdp_per_capita
FROM owid_covid_data  WHERE continent <> 'OWID'
GROUP by 1;


-- *******************************
-- SLIDE 10
-- SPREAD vs GDP
-- *******************************

SELECT location, MAX(total_deaths) / MAX(population) * 100 as d_rate, max(gdp_per_capita) as gdp_per_capita
FROM owid_covid_data  WHERE continent <> 'OWID'
GROUP by 1;
