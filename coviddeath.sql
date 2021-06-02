select *
from coviddeath
;
select *
from covidvaccinations
;
select location, date, total_cases, new_cases, total_deaths, population
from coviddeath
order by 1,2
;
-- Overall Death Percentage
select location, date, total_cases, total_deaths, round((total_deaths/total_cases) * 100,2) as deathPercentatge
from coviddeath
where location = 'United States' 
order by 2
;
-- Counties with the highest infection rate
select location, population, max(total_cases) as highestInfectionCount, round(max(total_cases)/population * 100,2) as deathPercentatge
from coviddeath
group by location, population
order by deathPercentatge DESC 
;
-- Counties with the highest death count
select location, max(total_deaths + 0) as maxDeathCnt
from coviddeath
where continent != ''
group by location
order by 2 desc
;
-- Continents with the highest death count
select continent, max(total_deaths + 0) as maxDeathCnt
from coviddeath
where continent != ''
group by continent
order by 2 desc
;
select location, max(total_deaths + 0) as maxDeathCnt
from coviddeath
where continent = ''
group by location
order by 2 desc
;
-- Global new cases & new deaths
select date, sum(new_cases) as newCaseTotal, sum(new_deaths) as newDeathTotal
from coviddeath
where continent != ''
group by date
order by 1
;
-- Total vaccination/total populatioin 
select sum(b.total_vaccinations)/sum(a.population) * 100 as vacRate 
from coviddeath a
join covidvaccinations b
on a.location = b.location and a.date = b.date
;
-- 
select a.continent, a.location, a.date, a.population, b.new_vaccinations, sum(b.new_vaccinations) over (partition by a.location order by a.date) as vacTotal
from coviddeath a
join covidvaccinations b
on a.location = b.location and a.date = b.date
where a.continent != ''
order by 2,3
;
with cte as (
select a.continent, a.location, a.date, a.population, b.new_vaccinations, sum(b.new_vaccinations) over (partition by a.location order by a.date) as vacTotal
from coviddeath a
join covidvaccinations b
on a.location = b.location and a.date = b.date
where a.continent != ''
order by 2,3
)
select continent, location, date, population, vacTotal, (vacTotal/population)*100 as vacRate
from cte
;
-- create view for data visualization
create view percentPopulationVaccinated as 
select a.continent, a.location, a.date, a.population, b.new_vaccinations, sum(b.new_vaccinations) over (partition by a.location order by a.date) as vacTotal
from coviddeath a
join covidvaccinations b
on a.location = b.location and a.date = b.date
where a.continent != ''
order by 2,3
