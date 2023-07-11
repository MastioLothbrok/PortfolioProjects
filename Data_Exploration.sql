/*
Covid 19 Data Exploration 
*/

--Data review
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject..CovidDeaths
ORDER BY 1,2


--Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases) * 100 as DeathsPercentagePL
FROM CovidProject..CovidDeaths
WHERE location = 'Poland'

--Higest death ratio
SELECT TOP 1 location, date, total_cases, total_deaths, population, (total_deaths/total_cases) * 100 as DeathsPercentagePL
FROM CovidProject..CovidDeaths
WHERE location = 'Poland'
ORDER BY DeathsPercentagePL DESC 


--Percentage of population who got Covid in Poland
SELECT location, date, total_cases, population, (total_cases/population) * 100 as TotalPercentage
FROM CovidProject..CovidDeaths
WHERE location = 'Poland'
ORDER BY 1,2


--Countries with Highest Infection Rate compared to Population
SELECT location,  MAX(total_cases) AS HigestInfeCount, population, MAX((total_cases/population)) * 100 as TotalPercentage
FROM CovidProject..CovidDeaths
GROUP BY location, population
ORDER BY TotalPercentage DESC


--Higest Deaths Count per Population by Country
SELECT location,  MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Higest Deaths Count per Population by Country
SELECT continent,  MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Total Population vs Vaccinations
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
FROM  CovidProject..CovidDeaths d
JOIN CovidProject..CovidVaccinations v
ON d.location = v.location
AND d.date = v.date
WHERE d.continent is not null
ORDER BY 2,3






