-- Checking out the whole data
select *
from [dbo].[Sheet1$]
order by location, date


-- Extracting the important columns that we will be working with
select continent, location, date, population, new_cases, total_cases, new_deaths, total_deaths, people_vaccinated, total_vaccinations
from [dbo].[Sheet1$]
order by location, date


-- Not selecting the continents (with null continent values) from the location column, since we are only interested in working with the countries
select continent, location, date, population, new_cases, total_cases, new_deaths, total_deaths, people_vaccinated, total_vaccinations
from [dbo].[Sheet1$]
where continent is not null
order by location, date


-- Checking out each country's total cases
select location,  population, max(total_cases) as latest_total_cases
from [dbo].[Sheet1$]
where continent is not null and total_cases is not null
group by location, population
order by 1,2


-- Checking out the infektion rate per country
select location,  population, max(total_cases) as latest_total_cases, max(total_cases)/population *100 as infection_rate_percent
from [dbo].[Sheet1$]
where continent is not null and total_cases is not null
group by location, population
order by 4 desc


-- Checking out the survival rate of germany after the infection (the max(cast(total_deaths as int)) is used because there is a problem with the data type in the total deaths column)
select location,  population, max(total_cases) as latest_total_cases, max(cast(total_deaths as int)) as latest_total_deaths, 1 - (max(cast(total_deaths as int))/max(total_cases))  as survival_rate
from [dbo].[Sheet1$]
where continent is not null and total_cases is not null and total_deaths is not null and location = 'germany'
group by location, population
order by 5 desc


-- Extracting World Covid Data
select location,  population, max(cast(total_deaths as int)) as latest_total_deaths, max(total_cases) as latest_total_cases, ((1 - max(cast(total_deaths as int))/population )*100) as survival_rate_percent
from [dbo].[Sheet1$]
where location = 'World'
group by location, population


-- Comparing the different continents we have in the data
--select location,  population, max(total_cases) as latest_total_cases, max(cast(total_deaths as int)) as latest_total_deaths, max(total_cases)/population as infection_rate, 1 - (max(total_deaths)/max(total_cases))  as survival_rate
--from [dbo].[Sheet1$]
--where continent is null and population is not null and location != 'World'
--group by location, population
--order by 6 desc

-- we have to delete a couple of unimportant rows in order to compare the continents
delete from [dbo].[Sheet1$]
where location in ('High income', 'Low income', 'Upper middle income', 'Lower middle income', 'European Union')

select location,  population, max(total_cases) as latest_total_cases, max(cast(total_deaths as int)) as latest_total_deaths, max(total_cases)/population as infection_rate, 1 - (max(total_deaths)/max(total_cases))  as survival_rate
from [dbo].[Sheet1$]
where continent is null and population is not null and location != 'World'
group by location, population
order by 3 desc


-- Checking The vaccination 
select location, population, max(cast(people_fully_vaccinated as bigint)) as people_fully_vaccinated, max(cast(people_fully_vaccinated as bigint))/population *100 as vaccination_rate
from [dbo].[Sheet1$]
where people_fully_vaccinated is not null and population is not null and continent is not null
group by location, population
order by 3 desc
