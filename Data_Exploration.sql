/*
Covid 19 Data Exploration of India
Skills used: Joins, Format Functions, Aggregate Functions, Creating Views, Converting Data Types
*/



SELECT * FROM Portfolio_Project_1..covid_death
ORDER BY location,date;


SELECT * FROM Portfolio_Project_1..covid_vaccination
ORDER BY location,date;



-- Selecting the Data that we are going to be starting with



SELECT * FROM Portfolio_Project_1..covid_death
WHERE continent LIKE 'Asia' AND location LIKE 'India'
ORDER BY date ASC;


SELECT * FROM Portfolio_Project_1..covid_vaccination
WHERE continent LIKE 'Asia' AND location LIKE 'India'
ORDER BY date ASC;



-- Date of the first case in India



SELECT TOP 1 FORMAT(date,'dd,MMMM,yyy') AS date_of_first_case,total_cases AS num_of_cases FROM Portfolio_Project_1..covid_death
WHERE continent LIKE 'Asia' AND location LIKE 'India' 
ORDER BY date ASC;



-- Joining both the tables(covid_death and covid_vaccination)



SELECT * FROM Portfolio_Project_1..covid_death AS death
JOIN Portfolio_Project_1..covid_vaccination AS vacc
ON death.continent=vacc.continent AND
death.location=vacc.location AND
death.date=vacc.date 
WHERE death.location like 'India' 
ORDER BY death.date ASC;



-- Total Cases vs Total Deaths in India (Visualised using Tableau)
-- Shows the likelihood of dying if you contract covid in India



SELECT location,date,total_cases,total_deaths,ROUND((CAST(total_deaths AS INT)/total_cases*100),4) as death_percentage
FROM Portfolio_Project_1..covid_death
WHERE continent LIKE 'Asia' AND location LIKE 'India'
ORDER BY date ASC;



-- Maximum Death Percentage till given date(2022-05-03) in the dataset in India



SELECT location,FORMAT(date,'dd,MMMM,yyy') AS date,total_cases,total_deaths,ROUND((CAST(total_deaths AS INT)/total_cases*100),4) as max_death_percentage FROM Portfolio_Project_1..covid_death
WHERE ROUND((CAST(total_deaths AS INT)/total_cases*100),4) = (SELECT MAX(ROUND((CAST(total_deaths AS INT)/total_cases*100),4)) as max_death_percentage
FROM Portfolio_Project_1..covid_death
WHERE continent LIKE 'Asia' AND location LIKE 'India') AND location like 'India';



-- Total Cases vs Population in India (Visualised using Tableau)
-- Shows what percentage of population has been once infected with Covid-19 in India



SELECT location,FORMAT(date,'dd,MM,yyy') as dates,total_cases,population,ROUND((total_cases/population) * 100,4) as once_infected_percentage
FROM Portfolio_Project_1..covid_death
WHERE continent LIKE 'Asia' AND location LIKE 'India'
ORDER BY date ASC;



-- Covid infections detected per month vs total cases



SELECT year=DATEPART(YEAR,date),month=DATEPART(MONTH,date),SUM(new_cases) AS covid_infections_detected_per_month,MAX(total_cases) as total_cases from
Portfolio_Project_1..covid_death
WHERE location like 'India'
GROUP BY DATEPART(YEAR,date),DATEPART(MONTH,date)
ORDER BY DATEPART(YEAR,date),DATEPART(MONTH,date);



-- Covid infections detected per month vs total cases and deaths detected per month vs total deaths



SELECT year=DATEPART(YEAR,date),month=DATEPART(MONTH,date),SUM(new_cases) AS covid_infections_detected_per_month,MAX(total_cases) as total_cases,SUM(CAST(new_deaths AS INT)) AS deaths_detected_per_months,
MAX(CAST(total_deaths AS INT)) AS total_deaths  from
Portfolio_Project_1..covid_death
WHERE location like 'India'
GROUP BY DATEPART(YEAR,date),DATEPART(MONTH,date)
ORDER BY DATEPART(YEAR,date),DATEPART(MONTH,date);



-- Vaccination administered per month

SELECT year=DATEPART(YEAR,date),month=DATEPART(MONTH,date),SUM(CAST(new_vaccinations AS INT)) AS vaccination_administered_per_month
from Portfolio_Project_1..covid_vaccination
WHERE location like 'India'
GROUP BY DATEPART(YEAR,date),DATEPART(MONTH,date)
ORDER BY DATEPART(YEAR,date),DATEPART(MONTH,date);



-- Vaccinations administered per month vs Covid infections detected per month (Visualised using Tableau)

SELECT year=DATEPART(YEAR,death.date),month=DATEPART(MONTH,death.date),SUM(death.new_cases) AS covid_infections_detected_per_month,
SUM(CAST(vacc.new_vaccinations AS INT)) AS vaccination_administered_per_month
from
Portfolio_Project_1..covid_death as death
JOIN Portfolio_Project_1..covid_vaccination as vacc
ON death.continent=vacc.continent AND
death.location=vacc.location AND
death.date=vacc.date 
WHERE death.location like 'India' 
GROUP BY DATEPART(YEAR,death.date),DATEPART(MONTH,death.date)
ORDER BY DATEPART(YEAR,death.date),DATEPART(MONTH,death.date);
