-- Calculate death percent per cases

select location , date , total_cases , total_deaths , [Death percent] = ( total_deaths / total_cases ) * 100
from [covid 19 project].[dbo].[Death]
-- where location like '%German%' and continent is not null
order by 1,2



-- Calculate infected percent per population

select location , date , total_cases , population , [infected percent] = ( total_cases / population ) * 100
from [covid 19 project].[dbo].[Death]
-- where location like '%German%' and continent is not null
order by 1,2 desc



-- Comparing the highest percent of infected people between countries and find the highest one

select location , max(total_cases) as 'HighestInfectedNum' , population , [HighestInfectedPercent] = max( total_cases / population ) * 100
from [covid 19 project].[dbo].[Death]
 where continent is not null
group by location , population
order by [HighestInfectedPercent] desc



-- Calculating Total Death Number per each coutry and find the highest one 

select location , [TotalDeathNumberBycoutry] = Max(cast(total_deaths as int))
from [covid 19 project].[dbo].[Death]
 where continent is not null
group by location 
order by TotalDeathNumberBycoutry desc



-- Calculating Total Death Number per each continent and find highest one 

select continent , [TotalDeathNumberByContinent] = Max(cast(total_deaths as int))
from [covid 19 project].[dbo].[Death]
where continent is not null
group by continent 
order by TotalDeathNumberByContinent desc


-- world total cases number, deaths number and percent  by date

select date , sum(new_cases) as 'total cases today' , sum(cast(new_deaths as int)) as 'total deaths today' 
,'Death percent today' = SUM(CAST(new_deaths as int)) / sum(new_cases) * 100
from [covid 19 project].dbo.Death
where continent is not null
group by date
having  sum(new_cases) != 0
order by date


-- world total cases number, deaths number and percent From the beginning of the pandemic until now

select sum(new_cases) as 'total cases' , sum(cast(new_deaths as int)) as 'total deaths' 
,'Death percent' = SUM(CAST(new_deaths as int)) / sum(new_cases) * 100
from [covid 19 project].dbo.Death
where continent is not null



-- Calculate rolling people vaccinated

select dea.date, dea.continent , dea.location , dea.population , new_vaccinations ,
'RollingpPopleVaccinated' = SUM(cast(new_vaccinations as float )) over (partition by dea.location order by dea.date)
from [covid 19 project].dbo.Death dea
join [covid 19 project].dbo.Vaccination vac
 on dea.date = vac.date
  and dea.location = vac.location
 where dea.continent is not null
 order by 3,1


  -- Calulate percent of vaccinated people in previous query by using CTE to perform calculation on partition
  
  ;      --this semicolon because of with statement

 with perpopvac( date , continent , location , population , vaccination , RollingPeopleVaccinated)
 as
 (
 select dea.date, dea.continent , dea.location , dea.population , new_vaccinations ,
'RollingpPopleVaccinated' = SUM(cast(new_vaccinations as float )) over (partition by dea.location Order by dea.date)
from [covid 19 project].dbo.Death dea
join [covid 19 project].dbo.Vaccination vac
 on dea.date = vac.date
  and dea.location = vac.location
 where dea.continent is not null
)
select * , 'PercentPopulationVaccinated' = (RollingPeopleVaccinated / population) *100
from perpopvac 
order by 3,1