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
