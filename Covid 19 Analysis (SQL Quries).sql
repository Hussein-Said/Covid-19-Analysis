/* Portfolio Project Covid 19 Analysis */

Select *
From PortfolioProject..CovidDeaths


-- The Daily Cases and Death Percentage Per Country

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covidDeaths
where continent is not null 
order by 1,2


-- The Infected Percentage of Population

Select Location, date, Population, total_cases, (CONVERT(Numeric, total_cases) / NULLIF(CONVERT(Numeric, population), 0)) *100 AS PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
order by 1,2


-- The Highest Infection Rate For Every Population

Select Location, Population, MAX(total_cases) AS HighestInfection, MAX((total_cases/population))*100 AS PopulationInfectionPercentage
From PortfolioProject..CovidDeaths
Group By Location, Population
Order By PopulationInfectionPercentage DESC


-- The Highest Infection Rate Daily For Every Population Per 

Select Location, Population,date, MAX(total_cases) AS HighestInfection, MAX((total_cases/population))*100 AS PopulationInfectionPercentage
From PortfolioProject..CovidDeaths
Group By Location, Population,date
Order By PopulationInfectionPercentage DESC


-- The Highest Death Cases For Every Country's Population

Select Location, Population, MAX(total_deaths) AS HighestDeaths, MAX((total_deaths/population))*100 AS PopulationDeathsPercentage
From PortfolioProject..CovidDeaths
Group By Location, Population
Order By PopulationDeathsPercentage DESC


-- The Highest Death Cases For Each Country

Select Location, MAX(total_deaths) AS HighestDeaths
From PortfolioProject..CovidDeaths
Where continent is not null
Group By Location
Order By HighestDeaths DESC


-- The Total Death Cases Per Continent

Select Continent, MAX(total_deaths) AS HighestDeaths
From PortfolioProject..CovidDeaths
Where continent is not null
Group By Continent
Order By HighestDeaths DESC


-- Overall Worldwide Covid Deaths, Total Cases and Death Percentage

Select SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2


-- Total Vaccinations For Each Population

Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations
From PortfolioProject..CovidDeaths AS Dea
Join PortfolioProject..CovidVaccinations AS Vac
	ON Dea.location = Vac.location
	And Dea.date = Vac.date
Where Dea.continent is not null
order by 2,3


-- Accumulated Vaccinations Numbers 

Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(Vac.new_vaccinations) Over (Partition By Dea.location Order By Dea.location, Dea.date) AS AccumulatedVaccinatedPeople
From PortfolioProject..CovidDeaths AS Dea
Join PortfolioProject..CovidVaccinations AS Vac
	ON Dea.location = Vac.location
	And Dea.date = Vac.date
Where Dea.continent is not null
order by 2,3


-- Applying CTE 

With VaccinationvsPopulation (continent,location ,date ,population ,new_vaccinations, AccumulatedVaccinatedPeople) 
AS(
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(CONVERT(float,Vac.new_vaccinations)) Over (Partition By Dea.location Order By Dea.location, Dea.date) AS AccumulatedVaccinatedPeople
From PortfolioProject..CovidDeaths AS Dea
Join PortfolioProject..CovidVaccinations AS Vac
	ON Dea.location = Vac.location
	And Dea.date = Vac.date
Where Dea.continent is not null
)
Select *, (AccumulatedVaccinatedPeople/population)*100
From VaccinationvsPopulation








