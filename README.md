# Introduction

This project aims to analyze some aspects related to covid, I will focus my analysis in my country, Brazil. Both the dataset and the code are available.

## What is the highest Death Percentage in Brazil?

To identify the Death Percetage of Brazil I filtered by the location "Brazil" and divided the total deaths by the total cases of covid.
```sql
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
```
The highest death percentage is around 6.99%, recorded on 12/05/2020.
| Date                | Total Cases | Total Deaths | Death Percentage |
|---------------------|-------------|--------------|------------------|
| 2020-05-12 | 178,214     | 12,461       | 6.9921600        |
| 2020-05-13 | 190,137     | 13,240       | 6.9634000        |
| 2020-05-02 | 97,100      | 6,761        | 6.9629200        |
| 2020-05-01 | 92,202      | 6,412        | 6.9543000        |
| 2020-04-28 | 73,235      | 5,083        | 6.9406700        |

*Table of Top 5 highest deaths percentage from covid in Brazil*

## What Percentage of the Population was sick?

To identify the Percentage of the Population I filtered by the location "Brazil" and divided the total cases by the total pupulation.
```sql
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
```
In 30/04/2021 about 6.89% of the population in Brazil was sick. It means aronud 14645343 people was affected.
| Date       | Total Cases | Population  | Percentage  |
|------------|-------------|-------------|-------------|
| 2021-04-30 | 14659011    | 212559409   | 6.8964300   |
| 2021-04-29 | 14590678    | 212559409   | 6.8642800   |
| 2021-04-28 | 14521289    | 212559409   | 6.8316400   |
| 2021-04-27 | 14441563    | 212559409   | 6.7941300   |
| 2021-04-26 | 14369423    | 212559409   | 6.7601900   |

*Table of Top 5 percentage of population that was sick*

## What about other countries?

This time I don't filtered by the location.

### 1. Death Percentage

I did the same as the previously case, ordering by the percentage obtained.
```sql
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
```
Countries with weaker healthcare systems or those heavily impacted in early pandemic stages tend to show higher death percentages. Wealthier nations with robust healthcare systems have lower percentages, though they still faced significant challenges.
![Death Percentage by country](/assets/death_percentage.png)
*Bar graph visualizing the top 10 coutries with the highest death  percentage by covid*


### 2. Percentage of Population

I did the same as the previously case, ordering by the percentage obtained.
```sql
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
```
Smaller nations tend to have higher infection rates, likely due to population density and quicker virus spread. In contrast, large nations like the United States have lower percentages despite higher total case counts.

![Top Infection Rates](/assets/percentage_of_population.webp)
*Bar graph visualizing the top 10 coutries with the highest infection rate by covid; ChatGPT generated this graph from my SQL query results*

## What are the Countries with Highest Death Count?

To analyze this I ordered by death cases.
```sql
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
```
Insights from data:
- **United States** has the highest death count, with **576,232** deaths, reflecting the significant toll of COVID-19 on the country, especially in the early stages before vaccinations were widely available.

- **Brazil** follows with **403,781** deaths, showing the heavy impact the pandemic had on South America, particularly in countries with large populations and varying levels of healthcare preparedness.

- **Mexico (216,907)** and **India (211,853)** have similarly high death counts, reflecting the challenges faced by large, densely populated countries, where controlling the virus and accessing healthcare posed major difficulties.

- European countries such as the **United Kingdom**, **Italy**, **Russia**, **France**, and **Germany** have death counts between 78,216 and 127,775. This range shows that despite advanced healthcare systems, the early waves of the pandemic still caused significant fatalities.

- **Spain** has the lowest count in the list with **78,216** deaths, but still a considerable number, indicating that no country was spared the severe impacts of COVID-19.
![Death Count](/assets/death_count.png)
*Bar graph visualizing the top 10 coutries with the highest death count by covid*

## What about Vaccinations?

Let's compare the results obtained above with the vaccinations that ocurred in each country.

### Brazil

To identify the vaccination ocurred in Brazil I filtered by the total vaccinations.
```sql
SELECT
    date,
    total_vaccinations::NUMERIC
FROM covid_vaccination
WHERE total_vaccinations IS NOT NULL
ORDER BY total_vaccinations DESC
LiMIT 5
```
The data reports that 1134333474 people was vacinated.
| Date       | Total Vaccinations |
|------------|--------------------|
| 2021-04-30 | 1134333474         |
| 2021-04-29 | 1112320708         |
| 2021-04-28 | 1087696981         |
| 2021-04-27 | 1065139208         |
| 2021-04-26 | 1045370981         |

*Top 5 highest number of vaccination in Brazil*

### Other Countries

I did the same as the previously case.
```sql
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
```
Insights from the Data:

1. Total Vaccinations:
- **China** leads with the highest total vaccinations at **265,064,000**, significantly ahead of other countries.
- The **United States** follows with **240,159,677** vaccinations, demonstrating a robust vaccination effort.
- **India** has **151,998,107** vaccinations, reflecting its large population and the efforts to vaccinate a significant portion of it.
- Countries like **Brazil** and **Germany** have relatively lower totals, with **42,698,862** and **28,774,580** vaccinations, respectively.

2.  Death Count:
- The **United States** has the highest death count at **576,232**, which is a stark reminder of the pandemic's impact.
- **Brazil** and **India** also report high death counts at **403,781** and **211,853**, respectively, indicating that despite vaccination efforts, the virus had a severe toll on these populations.
- **China** stands out with a very low death count of only **4,845**, suggesting effective management and control measures during the pandemic.

3. Comparison:
- Notably, the countries with the highest total vaccinations do not always correspond with the lowest death counts. For instance, while the **United States** and **Brazil** have high vaccination totals, they also have the highest death counts, indicating challenges in managing the virus despite vaccination efforts.
- In contrast, **China** has a high vaccination rate and low death count, pointing towards effective public health policies and measures.
![Vaccination Plot](/assets/vaccinations_plot.png)
*Bar graphs visualyzing both the top 10 countries with highest total vaccination and the death count due COVIC-19.*


# Conclusion

Brazil has faced a great challenger due COVID-19. It has the second largest number of total deaths up to the count of the time, with an average death percentage compared to countries like Yemen and France.
Even though the number of deaths is among the highest in the world, the percentage of the population affected is not in the top 10.

Brazil has one of the biggest number of vaccinations due to it's population, comparing it to other countries, Brazil and United States stand out from it's number of deaths despite their high number of vaccines.