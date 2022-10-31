/*
COVID-19 Data Exploration
SQL flavour used: PostgreSQL
Skills used: Joins, CTEs, Window Functions, Aggregate Functions
*/

-- Select data that we will start with
SELECT location, date, total_cases, new_cases, total_deaths, population
  FROM coviddeaths
 ORDER BY location, date;

-- Death rate compared to total cases in the UK
SELECT location, date, total_cases, total_deaths, 
       ROUND(((total_deaths*1.0)/(total_cases*1.0)*100), 2) AS mortality_rate
  FROM coviddeaths
 WHERE location LIKE '%United%Kingdom%'
 ORDER BY location, date;

-- What percentage of population caught COVID in the UK
SELECT location, date, total_cases, population, 
       (total_cases*1.0)/(population*1.0)*100 AS infection_rate
  FROM coviddeaths
 WHERE location LIKE '%United%Kingdom%'
 ORDER BY location, date;

-- Countries with the highest infection rate compared to population
SELECT location, population,
       MAX(total_cases) AS highest_cases, 
       (MAX(total_cases)*1.0)/(population*1.0)*100 AS infection_rate
  FROM coviddeaths
 WHERE continent <> '' AND total_cases IS NOT NULL
 GROUP BY location, population
 ORDER BY infection_rate DESC;

-- Continents with the highest infection rate compared to population
SELECT location, population, 
       MAX(total_cases) AS highest_cases, 
       (MAX(total_cases)*1.0)/(population*1.0)*100 AS infection_rate
  FROM coviddeaths
 WHERE total_deaths IS NOT NULL AND location IN ('Europe', 'North America', 'Asia', 'South America', 'Africa', 'Oceania')
 GROUP BY location, population
 ORDER BY infection_rate DESC;

-- Countries with the highest total deaths
SELECT location, 
       MAX(total_deaths) AS highest_deaths
  FROM coviddeaths
 WHERE continent <> ''  AND total_deaths IS NOT NULL
 GROUP BY location
 ORDER BY highest_deaths DESC;

-- Continents with the highest total deaths
SELECT location AS continent, 
       MAX(total_deaths) AS highest_deaths
  FROM coviddeaths
 WHERE location IN ('Europe', 'North America', 'Asia', 'South America', 'Africa', 'Oceania')
 GROUP BY location
 ORDER BY highest_deaths DESC;

-- Countries with the highest death rate compared to population
SELECT location, population,
       MAX(total_deaths) AS highest_deaths, 
       (MAX(total_deaths)*1.0)/(population*1.0)*100 AS death_rate
  FROM coviddeaths
 WHERE continent <> '' AND total_deaths IS NOT NULL
 GROUP BY location, population
 ORDER BY death_rate DESC;

-- Continents with the highest death rate compared to population
SELECT location AS continent, population, 
       MAX(total_deaths) AS highest_deaths, 
       (MAX(total_deaths)*1.0)/(population*1.0)*100 AS death_rate
  FROM coviddeaths
 WHERE total_deaths IS NOT NULL AND location IN ('Europe', 'North America', 'Asia', 'South America', 'Africa', 'Oceania')
 GROUP BY location, population
 ORDER BY death_rate DESC;

-- Global death rate
SELECT date, 
       SUM(new_cases) AS new_cases, 
       SUM(new_deaths) AS new_deaths, 
       (SUM(new_deaths) * 1.0) / (SUM(new_cases) * 1.0) * 100 AS mortality_rate
  FROM coviddeaths
 WHERE continent <> ''
 GROUP BY date
 ORDER BY date;

--Total population vs vaccinations
WITH totalvac AS (
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
       SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS total_vaccinated
  FROM coviddeaths cd
  JOIN covidvaccinations cv
 USING(location, date)
 WHERE cd.continent <> ''
 ORDER BY location, date
)

SELECT continent, location, date, population, new_vaccinations, total_vaccinated,
       (total_vaccinated/population) * 100 AS percentage_vaccinated
  FROM totalvac
 ORDER BY location, date;
