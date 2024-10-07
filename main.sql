SELECT *
FROM covid_deaths
ORDER BY 1, 2
LIMIT 100


-- Looking at Total Cases vs Total Deaths
-- Shows likehood of dying if you contract covid in your country
SELECT
    date,
    total_cases,
    total_deaths,
    ROUND(total_deaths::NUMERIC/total_cases::NUMERIC,7)*100 AS DeathPercentage
FROM covid_deaths
WHERE 
    total_cases IS NOT NULL AND total_deaths IS NOT NULL AND
    location = 'Brazil'
ORDER BY DeathPercentage DESC
LIMIT 5


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT
    date,
    total_cases,
    population,
    ROUND(total_cases::NUMERIC/population::NUMERIC,7)*100 AS Percentage
FROM covid_deaths
WHERE 
    total_cases IS NOT NULL AND
    location = 'Brazil'
ORDER BY Percentage DESC
LIMIT 5


-- Looking at Countries with Highest Infection Rate compare
SELECT
    location,
    population,
    MAX (total_cases) AS HighestInfectionCount,
    MAX(ROUND((total_cases::NUMERIC/population::NUMERIC),2)*100) as RateInfection
FROM covid_deaths
WHERE total_cases IS NOT NULL AND continent IS NOT NULL
GROUP BY location, population
ORDER BY RateInfection DESC
LiMIT 10


-- Looking at Countries with Highest Death Percentage Rate compare
SELECT
    location,
    ROUND(MAX(total_deaths::NUMERIC/total_cases::NUMERIC*100),2) AS DeathPercentage
FROM covid_deaths
WHERE total_cases IS NOT NULL AND
     total_deaths IS NOT NULL AND 
     continent IS NOT NULL AND
     total_cases > 50
GROUP BY location
ORDER BY DeathPercentage DESC
LiMIT 10


-- Showing Countries with Highest Death Count per Population
SELECT
    location,
    MAX(total_deaths) AS Highest_Death_Count
FROM covid_deaths
WHERE total_cases IS NOT NULL AND 
    total_deaths IS NOT NULL
    AND continent IS NOT NULL
GROUP BY location
ORDER BY Highest_Death_Count DESC
LiMIT 10


-- Let's break things down by continent
SELECT
    location,
    MAX(total_deaths) AS HighestDeathCount
FROM covid_deaths
WHERE total_cases IS NOT NULL AND 
    total_deaths IS NOT NULL
    AND continent IS NULL
GROUP BY location
ORDER BY HighestDeathCount DESC


-- Showing continents with highest deaths count per population
-- Showing Countries with Highest Death Count per Population
SELECT
    continent,
    MAX(total_deaths) AS HighestDeathCount
FROM covid_deaths
WHERE total_cases IS NOT NULL AND 
    total_deaths IS NOT NULL
    AND continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount DESC


-- GLOBAL NUMBERS
SELECT
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    ROUND(SUM(new_deaths)/SUM(new_cases)*100,5) AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1


-- Looking at Total Population vs Vaccinations
-- USE CTE
WITH PopvsVac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.Population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeolpleVaccinated
    FROM covid_deaths AS dea
    JOIN covid_vaccination AS vac ON dea.location = vac.location AND vac.date = vac.date
    WHERE dea.continent IS NOT NULL
)

SELECT 
    *,
    (RollingPeolpleVaccinated/population)*100
FROM PopvsVac
LIMIT 10



-- TEMP TABLE

CREATE TABLE PercentPopulationVAccinated (
    continent VARCHAR(255),
    location VARCHAR(255),
    date TIMESTAMP,
    population NUMERIC,
    new_vaccinations NUMERIC,
    RollingPeolpleVaccinated NUMERIC
);
INSERT INTO PercentPopulationVAccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.Population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS RollingPeolpleVaccinated
FROM covid_deaths AS dea
JOIN covid_vaccination AS vac ON dea.location = vac.location AND vac.date = vac.date
WHERE dea.continent IS NOT NULL;


SELECT 
    *,
    (RollingPeolpleVaccinated/population)*100
FROM PercentPopulationVAccinated
LIMIT 10


-- Vaccinations in Brazil
SELECT
    date,
    total_vaccinations::NUMERIC
FROM covid_vaccination
WHERE total_vaccinations IS NOT NULL
ORDER BY total_vaccinations DESC
LiMIT 5


-- Vaccinations in other countries
SELECT 
    vac.location,
    MAX(vac.total_vaccinations)::NUMERIC AS total_vaccination,
    MAX(total_deaths) AS death_count
FROM covid_vaccination AS vac
JOIN covid_deaths AS dea ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    vac.total_vaccinations IS NOT NULL AND
    vac.continent IS NOT NULL AND
    dea.total_deaths IS NOT NULL
GROUP BY vac.location
ORDER BY total_vaccination DESC
LIMIT 10