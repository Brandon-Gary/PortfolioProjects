SELECT *
FROM CovidDeaths
--WHERE continent IS NOT NULL  (This is done because some locations were not countries)
ORDER BY 3,4

SELECT *
FROM covidvaccinations
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date

-- MODIFYING DATATYPE OF A COLUMN
--ALTER TABLE CovidDeaths
--ALTER COLUMN total_cases float (Reminder that float allows for decimals)


-- Total Cases vs Total Deaths in the United States

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location = 'United States'
ORDER BY location, date

--Total Cases vs Population in the United States

SELECT location, date, population, total_cases, (total_cases/population)*100 as PopPercentContractingCovid
FROM CovidDeaths
WHERE location = 'United States'
ORDER BY location, date

--Viewing countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PopPercentContractingCovid
FROM CovidDeaths
GROUP BY location, population
ORDER BY PopPercentContractingCovid DESC

--Viewing Countries with Highest Death Count Per Population

SELECT location, population, MAX(total_deaths) as TotalDeathCount, MAX((total_deaths/population))*100 as PercentPopulationDeath
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationDeath DESC

--By Continent...

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc


-- Global Numbers (on days when new cases is not 0)
SELECT date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL AND new_cases != 0
GROUP BY date
ORDER BY 1,2

-- Death Percentage as total to present day
SELECT SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL AND new_cases != 0
ORDER BY 1,2


--Looking at total population vs vaccination
--USING CTE
WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingTotalVaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingTotalVaccinations
FROM CovidDeaths Dea
JOIN CovidVaccinations Vac
	ON Dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingTotalVaccinations/Population)*100
FROM PopvsVac


--Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingTotalVaccinations numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingTotalVaccinations
FROM CovidDeaths Dea
JOIN CovidVaccinations Vac
	ON Dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingTotalVaccinations/Population)*100
FROM #PercentPopulationVaccinated



-- Creating View to Store Data for future visualization
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingTotalVaccinations
FROM CovidDeaths Dea
JOIN CovidVaccinations Vac
	ON Dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated




