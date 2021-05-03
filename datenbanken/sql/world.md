# World DB Exercises

## Using count, get the number of cities in the USA

```sql
SELECT count(*) FROM city
WHERE country_code = 'USA';
```

## Find out what the population and average life expectancy for people in Argentina (ARG) is

```sql
SELECT population, life_expectancy FROM country
WHERE code = 'ARG';
```

## Using `IS NOT NULL`, `ORDER BY` and `LIMIT`, what country has the highest life expectancy?

```sql
SELECT name, life_expectancy FROM country
WHERE life_expectancy IS NOT NULL
ORDER BY life_expectancy DESC
LIMIT 1;
```

## Using `LEFT JOIN ON`, what is the capital of Spain (ESP)?

```sql
SELECT * FROM city
LEFT JOIN country ON country.capital = city.id
WHERE code = 'ESP';
```

## Using `LEFT JOIN ON`, list all the languages spoken in the 'Southeast Asia' region

```sql
SELECT * FROM country_language
LEFT JOIN country ON country.code = country_language.country_code
WHERE country.continent = 'Asia' AND country.region = 'Southeast Asia';
```

## Select 25 cities around the world that start with the letter 'F' in a single SQL query.

```sql
SELECT name FROM city
WHERE name LIKE 'F%'
ORDER BY name
LIMIT 25;
```

## Show the name, continent and population of every country whose population is under 100000. Order your results by population from highest to lowest.

```sql
SELECT name, continent, population FROM country
WHERE population < 100000
ORDER BY population DESC;
```

## Show the name and population of every country in the continent of Oceania whose population is at or above 20000. Order your results by country name.

```sql
SELECT name, population FROM country
WHERE continent = 'Oceania' AND population >= 2000
ORDER BY name;
```

## Display a list of every continent and present the list in alphabetical order.

```sql
SELECT DISTINCT continent FROM country
ORDER BY continent;
```

## Of all the countries located in Asia, which has the highest life expectancy?

```sql
SELECT name, life_expectancy FROM country
WHERE continent = 'Asia' AND life_expectancy IS NOT NULL
ORDER BY life_expectancy DESC
LIMIT 1;
```

## Display the name, continent and population of every country in Europe and Asia. Order the results by continent and then by country name within the continent.

```sql
SELECT name, continent, population FROM country
WHERE continent = 'Europe' OR continent = 'Asia'
ORDER BY continent, name;
```

## Display the name, continent and population of all countries with 'island' in thier name.

```sql
SELECT name, continent, population FROM country
WHERE LOWER(name) LIKE '%island%';
```

## Display a list of countries that have gained their independence since 1950.

```sql
SELECT name, indep_year FROM country
WHERE indep_year > 1950;
```

## Show the top ten countries with the highest gross national product (GNP).

```sql
SELECT name, gnp FROM country
ORDER BY gnp DESC
LIMIT 10;
```

## Show for each region of the world the countries in that region ranked by highest to lowest surface area; order the continents alphabetically.

```sql
SELECT name, surface_area FROM country
ORDER BY surface_area DESC, continents;
```

## Display a list of the ten highest populated cities in the world.

```sql
SELECT name, population FROM country
ORDER BY population DESC
LIMIT 10;
```

## Show all countries of europe

## Show all countries which start with 'N'

## What is the population of the biggest city?

## Show all cities which have over 1000000 citizens

## Which countries have more than 50 million citizens?

## Show all countries where the population density is greater than 100 citizens / qkm

## Which countries are in the region 'Polynesia'?

## Which countries have a identical name and localname?

## How many citizens are living in Africa?

## In which country is Jirja located?

## Whats the capital of Azerbaijan?

## Show all cities which have over 1000000 citizens in Asia

## Which countries are speaking Uzbek?

## Which cities are located in Bolivia?

## Which cities are located in Caribbean?

## How many citizens has the biggest capital?

## Show all countries which are located in Asia with more than 5.000.000 citizens or in Europe with more than 3.000.000 citizens.

## Which country has the most citizens?

## In which country do 10 or more percent of the population live in the capital?

## Show all countries where more than 5% of the population speaks german

## How many citizens are living in Africa?

## How many countries have less than 20.000.000 citizens?

## Show the number of countries a language is spoken in

## Show the number of countries where a language is spoken by more than 10% of the population

## List all countries and the number of thier cities with over 1.000.000 citizens

## List all countries with have more than 5 cities which have at least 1.000.000 citizens

## Show all languages which are spoken in more than 5 countries where at least 10% of the citizens speak them

## Which countries speak more than 4 languages?

## Which countries have more than two official languages?

## Which countries speak 'Uzbek' but not 'Ukrainian'?

## Which countries speak a language which is spoken is sweden?

## Which countries have a offical language which is spoken in sweden?

## Show the population density for all countries in Asia

## Calculate the population density of Europe

## Calculate the population density for each continent

## Which countries have a higher population density than germany?

## Find all city names which occur more than once
