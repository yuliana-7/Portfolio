select *
from coviddeaths
order by location, date;

select *
from covidvaccinations
order by location, date;

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by location, date;

-- Death rate compared to total cases in the UK
select location, date, total_cases, total_deaths, 
       round(((total_deaths*1.0)/(total_cases*1.0)*100), 2) as mortality_rate
from coviddeaths
where location like '%United%Kingdom%'
order by location, date;

-- What percentage of population caught COVID in the UK
select location, date, total_cases, population, 
       (total_cases*1.0)/(population*1.0)*100 as infection_rate
from coviddeaths
where location like '%United%Kingdom%'
order by location, date;

-- Countries with the highest infection rate compared to population
select location, population,
       max(total_cases) as highest_cases, 
       (max(total_cases)*1.0)/(population*1.0)*100 as infection_rate
from coviddeaths
where continent <> '' and total_cases is not null
group by location, population
order by infection_rate desc;

-- Continents with the highest infection rate compared to population
select location, population, 
       max(total_cases) as highest_cases, 
       (max(total_cases)*1.0)/(population*1.0)*100 as infection_rate
from coviddeaths
where total_deaths is not null and location in ('Europe', 'North America', 'Asia', 'South America', 'Africa', 'Oceania')
group by location, population
order by infection_rate desc;

-- Countries with the highest total deaths
select location, 
       max(total_deaths) as highest_deaths
from coviddeaths
where continent <> ''  and total_deaths is not null
group by location
order by highest_deaths desc;

-- Continents with the highest total deaths
select location as continent, 
       max(total_deaths) as highest_deaths
from coviddeaths
where location in ('Europe', 'North America', 'Asia', 'South America', 'Africa', 'Oceania')
group by location
order by highest_deaths desc;

-- Countries with the highest death rate compared to population
select location, population,
       max(total_deaths) as highest_deaths, 
       (max(total_deaths)*1.0)/(population*1.0)*100 as death_rate
from coviddeaths
where continent <> '' and total_deaths is not null
group by location, population
order by death_rate desc;

-- Continents with the highest death rate compared to population
select location as continent, population, 
       max(total_deaths) as highest_deaths, 
       (max(total_deaths)*1.0)/(population*1.0)*100 as death_rate
from coviddeaths
where total_deaths is not null and location in ('Europe', 'North America', 'Asia', 'South America', 'Africa', 'Oceania')
group by location, population
order by death_rate desc;

-- Global death rate
select date, 
       sum(new_cases) as new_cases, 
       sum(new_deaths) as new_deaths, 
       (sum(new_deaths) * 1.0) / (sum(new_cases) * 1.0) * 100 as mortality_rate
from coviddeaths
where continent <> ''
group by date
order by date;

--Total population vs vaccinations
with totalvac as (
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
       SUM(cv.new_vaccinations) over (partition by cd.location order by cd.location, cd.date) as total_vaccinated
from coviddeaths cd
join covidvaccinations cv
using(location, date)
where cd.continent <> ''
order by location, date
)

select continent, location, date, population, new_vaccinations, total_vaccinated,
       (total_vaccinated/population) * 100 as percentage_vaccinated
from totalvac
order by location, date;