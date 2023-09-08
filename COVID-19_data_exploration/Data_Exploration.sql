--Total cases vs total deaths
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases) * 100 as DeathsPercentagePL
FROM Covid_data..CovidDeaths
WHERE location = 'Poland'

--Higest death ratio
SELECT TOP 1 location, date, total_cases, total_deaths, population, (total_deaths/total_cases) * 100 as DeathsPercentagePL
FROM Covid_data..CovidDeaths
WHERE location = 'Poland'
ORDER BY DeathsPercentagePL DESC 


--Percentage of population who got covid in Poland
SELECT location, date, total_cases, population, (total_cases/population) * 100 as TotalPercentage
FROM Covid_data..CovidDeaths
WHERE location = 'Poland'
ORDER BY 1,2


--Countries with highest infection rate compared to population
SELECT location,  MAX(total_cases) AS HigestInfeCount, population, MAX((total_cases/population)) * 100 as TotalPercentage
FROM Covid_data..CovidDeaths
GROUP BY location, population
ORDER BY TotalPercentage DESC


--Higest deaths count per population by country
SELECT location,  MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM Covid_data..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Higest deaths count per population by country
SELECT continent,  MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM Covid_data..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Sum of vaccined people by country
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast (v.new_vaccinations as int)) OVER (Partition by d.location)
FROM  Covid_data..CovidDeaths d
JOIN Covid_data..CovidVaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent is not null
ORDER BY 2,5




--Biggest new case number in each country
SELECT location, "Higest_case_num"
FROM (
  SELECT location,
         MAX(new_cases) OVER (PARTITION BY location) AS "Higest_case_num",
         ROW_NUMBER() OVER (PARTITION BY location ORDER BY new_cases DESC) AS row_num
  FROM Covid_data..CovidDeaths
) ranked_data
WHERE row_num = 1
ORDER BY location ASC;

--Determining if a country has a high level of vaccinated population 
WITH VaccinationData AS (
    SELECT d.location,
           (SUM(v.new_vaccinations) OVER (PARTITION BY d.location) / d.population * 100) AS "Vaccined_Percent"
    FROM Covid_data..CovidDeaths d
    JOIN Covid_data..CovidVaccinations v 
    ON d.location = v.location
    AND d.date = v.date
    WHERE v.new_vaccinations IS NOT NULL
)
SELECT DISTINCT location,
       "Vaccined_Percent",
       CASE
           WHEN "Vaccined_Percent" > 70 THEN 'HIGH'
           WHEN "Vaccined_Percent" BETWEEN 40 AND 70 THEN 'MEDIUM'
           ELSE 'LOW'
       END AS "Vaccined_level"
FROM VaccinationData
ORDER BY location DESC;


