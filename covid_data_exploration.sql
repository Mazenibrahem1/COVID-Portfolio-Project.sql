/*
COVID-19 Data Exploration Project

This SQL script performs comprehensive data exploration and analysis on COVID-19 datasets
to uncover insights about infection rates, death rates, vaccination progress, and global trends.

Skills Demonstrated:
- Joins and Complex Queries
- Common Table Expressions (CTEs)
- Temporary Tables
- Window Functions
- Aggregate Functions
- Data Type Conversions
- Creating Views for Data Visualization

Author: Mazen Ibrahim
Database: Microsoft SQL Server
Tables Used: CovidDeaths, CovidVaccinations
*/

-- =====================================================
-- SECTION 1: INITIAL DATA EXPLORATION
-- =====================================================

-- Overview of the CovidDeaths dataset
-- Filtering out rows where continent is null to focus on country-level data
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 3, 4;


-- Select core data columns for initial analysis
-- Focus on location, date, cases, deaths, and population
SELECT 
    Location, 
    date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2;


-- =====================================================
-- SECTION 2: DEATH RATE ANALYSIS
-- =====================================================

-- Calculate death percentage (likelihood of dying if contracting COVID)
-- Example focused on United States data
SELECT 
    Location, 
    date, 
    total_cases,
    total_deaths, 
    (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
    AND continent IS NOT NULL 
ORDER BY 1, 2;


-- =====================================================
-- SECTION 3: INFECTION RATE ANALYSIS
-- =====================================================

-- Calculate infection rate as percentage of population
-- Shows what percentage of population has been infected with COVID
SELECT 
    Location, 
    date, 
    Population, 
    total_cases,  
    (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;


-- Countries with highest infection rate compared to population
-- Identifies countries most affected relative to their population size
SELECT 
    Location, 
    Population, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;


-- =====================================================
-- SECTION 4: MORTALITY ANALYSIS BY COUNTRY
-- =====================================================

-- Countries with highest death count per population
-- Ranking countries by total deaths to identify most impacted nations
SELECT 
    Location, 
    MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY Location
ORDER BY TotalDeathCount DESC;


-- =====================================================
-- SECTION 5: CONTINENTAL ANALYSIS
-- =====================================================

-- Continental breakdown of death counts
-- Showing continents with the highest death count per population
SELECT 
    continent, 
    MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- =====================================================
-- SECTION 6: GLOBAL STATISTICS
-- =====================================================

-- Global COVID-19 numbers summary
-- Aggregate statistics showing worldwide totals and death percentage
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_deaths, 
    SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2;


-- =====================================================
-- SECTION 7: VACCINATION ANALYSIS
-- =====================================================

-- Total Population vs Vaccinations
-- Shows percentage of population that has received at least one COVID vaccine
-- Using window function to calculate rolling vaccination count
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(INT,vac.new_vaccinations)) OVER (
        PARTITION BY dea.Location 
        ORDER BY dea.location, dea.Date
    ) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2, 3;


-- =====================================================
-- SECTION 8: ADVANCED CALCULATIONS USING CTE
-- =====================================================

-- Using Common Table Expression (CTE) to perform calculations on partition by results
-- Calculate vaccination percentage using rolling vaccination count
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(INT,vac.new_vaccinations)) OVER (
            PARTITION BY dea.Location 
            ORDER BY dea.location, dea.Date
        ) AS RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL 
)
SELECT 
    *, 
    (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM PopvsVac;


-- =====================================================
-- SECTION 9: TEMPORARY TABLE APPROACH
-- =====================================================

-- Using Temporary Table to perform calculations on partition by results
-- Alternative approach to CTE for complex calculations
DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(INT,vac.new_vaccinations)) OVER (
        PARTITION BY dea.Location 
        ORDER BY dea.location, dea.Date
    ) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

-- Query the temporary table with vaccination percentage calculation
SELECT 
    *, 
    (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM #PercentPopulationVaccinated;


-- =====================================================
-- SECTION 10: VIEW CREATION FOR VISUALIZATION
-- =====================================================

-- Creating a view to store data for later visualizations
-- This view can be used by BI tools like Tableau, Power BI, etc.
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(INT,vac.new_vaccinations)) OVER (
        PARTITION BY dea.Location 
        ORDER BY dea.location, dea.Date
    ) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- =====================================================
-- END OF COVID-19 DATA EXPLORATION
-- =====================================================

/*
SUMMARY OF INSIGHTS GENERATED:
1. Death rates by country and over time
2. Infection rates as percentage of population
3. Countries most affected by COVID-19
4. Continental comparison of COVID-19 impact
5. Global statistics and trends
6. Vaccination progress and coverage analysis
7. Rolling vaccination counts and percentages

This analysis provides a comprehensive view of the COVID-19 pandemic's
impact across different geographical regions and time periods.
*/

