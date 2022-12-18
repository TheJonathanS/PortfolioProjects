--select *
--from CovidDeaths$
--order by 3,4

--select *
--from CovidVaccinations$
--order by 3,4

select Location, date, total_cases,new_cases,total_deaths,population
from CovidDeaths$
order by 1,2

--Looking at Total Cases vs Total Deaths

select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location = 'Costa Rica'
order by 1,2

--Looking at Total Cases vs Population
--Shows What Percentage of population got COVID

select Location, date,Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths$
where location = 'Costa Rica'
order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population

select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths$
--where location = 'Costa Rica'
group by Location,Population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count Per Population

select Location, max(cast(Total_Deaths as int)) as TotalDeathCount
from CovidDeaths$
--where location = 'Costa Rica'
where continent is not null
group by Location
order by TotalDeathCount desc

--Continent

select location, max(cast(Total_Deaths as int)) as TotalDeathCount
from CovidDeaths$
--where location = 'Costa Rica'
where continent is null
group by location
order by TotalDeathCount desc 

--Showing continents with the highest death count per population


select continent, max(cast(Total_Deaths as int)) as TotalDeathCount
from CovidDeaths$
--where location = 'Costa Rica'
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Numbers

select date, sum(new_cases) as TotalNewCases, SUM(cast(new_deaths as int)) as NewDeaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths$
--where location = 'Costa Rica'
where continent is not null
group by date
order by 1,2

--Looking at Total Population vs Vaccinations


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleCount/population)*100
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Use CTE

With PopvsVac (Continent, Location, Date, population, new_vaccinations, RollingPeopleVaccinated) 
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac




--Temp Table
DROP table if exists  #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated