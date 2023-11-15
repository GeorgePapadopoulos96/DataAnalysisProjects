--Covid Death Percentage, if you get covid what are the changes you will die
select Location, Date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
From CovidProject.dbo.CovidDeaths
--WHERE CovidProject.dbo.CovidDeaths.Location = 'Greece'
ORDER BY 1,2

-- Country with the Highest Infection Rate
SELECT Location, population, MAX(CONVERT(float,total_cases)) as TotalCases, MAX((CONVERT(FLOAT, total_cases)/NULLIF(population,0)))*100 as PopulationInfectedPerc
From CovidProject.dbo.CovidDeaths
GROUP BY LOCATION, population
order by PopulationInfectedPerc DESC

-- Deaths per Country
SELECT Location, MAX(CONVERT(float, total_deaths)) as Total_Deaths
From CovidProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY LOCATION
order by Total_Deaths desc

-- Deaths per Continent
SELECT Location as Continent, MAX(CONVERT(float, total_deaths)) as Total_Deaths
From CovidProject.dbo.CovidDeaths
WHERE continent is null 
AND location <> 'Upper middle income' AND location <> 'High income'  AND location <> 'Lower middle income' AND location <> 'Low income' 
GROUP BY LOCATION
order by Total_Deaths desc

-- Deaths per class
SELECT Location, MAX(CONVERT(float, total_deaths)) as Total_Deaths
From CovidProject.dbo.CovidDeaths
WHERE continent is null 
AND (location = 'Upper middle income' OR location = 'High income'  or location = 'Lower middle income' or location = 'Low income') 
GROUP BY LOCATION
order by Total_Deaths desc

--deaths to cases per day
SELECT date, 
SUM(new_cases) as total_cases, 
SUM(CONVERT(int, new_deaths)) as total_deaths, 
SUM(cast(new_deaths as int))/NULLIF(SUM(new_cases),0) * 100 as DeathPercentage
From CovidProject.dbo.CovidDeaths
WHERE continent is null 
AND location <> 'Upper middle income' 
AND location <> 'High income' 
AND location <> 'Lower middle income' 
AND location <> 'Low income' 
GROUP BY date
order by date, total_cases desc

--total cases to deaths percentage
SELECT SUM(new_cases) as total_cases, 
SUM(CONVERT(int, new_deaths)) as total_deaths, 
SUM(cast(new_deaths as int))/NULLIF(SUM(new_cases),0) * 100 as DeathPercentage
From CovidProject.dbo.CovidDeaths
WHERE continent is null 
AND location <> 'Upper middle income' 
AND location <> 'High income' 
AND location <> 'Lower middle income' 
AND location <> 'Low income' 
order by total_cases desc


-------------------------------------------------------
---- new vaccinations per day
Select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date , CovidDeaths.population, CovidVaccinations.new_vaccinations
FROM CovidProject.dbo.CovidDeaths as CovidDeaths
JOIN CovidProject.dbo.CovidVaccinations as CovidVaccinations
	ON CovidDeaths.location = CovidVaccinations.location
	AND CovidDeaths.date = CovidVaccinations.date
WHERE CovidDeaths.continent is not null

-- Total Vaccinated Population
CREATE VIEW TotalVaccinatedPopulation as
Select CovidDeaths.continent, 
CovidDeaths.location, CovidDeaths.date , 
CovidDeaths.population, 
CovidVaccinations.people_fully_vaccinated,
(CovidVaccinations.people_fully_vaccinated/CovidDeaths.population) * 100 as PopulationVaccinatedPerc
FROM CovidProject.dbo.CovidDeaths as CovidDeaths
JOIN CovidProject.dbo.CovidVaccinations as CovidVaccinations
	ON CovidDeaths.location = CovidVaccinations.location
	AND CovidDeaths.date = CovidVaccinations.date
WHERE CovidDeaths.continent is not null

SELECT * 
FROM TotalVaccinatedPopulation

select * from CovidProject.dbo.CovidVaccinations