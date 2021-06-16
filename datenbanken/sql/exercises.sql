-- Geben Sie alle Länder und deren Oberfläche aus!

SELECT countryname, surfacearea FROM country;

-- Geben Sie alle Länder Europas aus!

SELECT countryname FROM country
JOIN continent ON country.continentid = continent.continentid
WHERE continentname = 'Europe';

-- Geben Sie alle Länder aus, die mit "N" beginnen!

SELECT countryname FROM country
WHERE countryname LIKE 'N%';

-- Wieviel Einwohner hat die groesste Stadt?

SELECT max(population) FROM city;

-- Geben Sie alle Millionenstädte an!

SELECT cityname FROM city WHERE population > 1000000;

-- In welchen Ländern leben mehr als 50 Millionen Einwohner?

SELECT cityname FROM city WHERE population > 1000000;

-- Wieviele Sprachen gibt es?

SELECT count(languagename) FROM language;

-- In welchen Ländern ist die Lebenserwartung höher als 70 Jahre und die Fläche größer als 100.000 qkm?

SELECT countryname FROM country
WHERE lifeexpectancy > 70 AND surfacearea > 100000;

-- In welchen Ländern ist die Lebenserwartung höher als 70 Jahre oder die
-- Fläche größer als 100.000 qkm?

SELECT countryname FROM country
WHERE lifeexpectancy > 70 OR surfacearea > 100000;

-- In wievielen Ländern ist die Lebenserwartung höher als 70 Jahre und die Fläche größer als 100.000 qkm?

SELECT count(countryname) FROM country
WHERE lifeexpectancy > 70 AND surfacearea > 100000;

-- In welchen Ländern ist die Bevölkerungsdichte grösser als 100 Ew/qkm?

SELECT countryname FROM country
WHERE (population / surfacearea) > 100;

-- Welche Länder liegen in der Region "Polynesia"?

SELECT countryname FROM country
WHERE (population / surfacearea) > 100;

-- Bei welchen Ländern ist der Name und der lokale Name identisch?

SELECT countryname FROM country
WHERE (population / surfacearea) > 100;

-- Wieviele Einwohner wohnen in Africa?

SELECT countryname FROM country
WHERE (population / surfacearea) > 100;

-- In welchem Land liegt "Jirja"?



-- Welche Städte liegen in Germany?

-- Wieviele Städte liegen in Germany?

-- Wieviele Millionenstädte liegen in Deutschland?

-- Wie heisst die Hauptstadt von "Azerbaijan"?

-- Geben Sie für jede Stadt an, in welchem Land sie liegt.

-- Geben Sie für jede Stadt an, in welchem Land und auf welchem Kontinent sie liegt.

-- Geben Sie für jede Stadt, die mit 'C' beginnt, an, in welchem Land und auf welchem Kontinent sie liegt.

-- Welche Städte liegen in Bolivia?

-- Welche Städte liegen in der Region "Caribbean"?

-- Geben Sie alle Millionenstädte Asiens aus!

-- In welchen Ländern wird "Uzbek" gesprochen?

-- Wieviel Einwohner hat die groesste Hauptstadt?

-- Geben Sie alle Länder aus, die in Asien liegen und mehr als 5 Millionen Einwohner haben oder in Europa liegen und mehr als 3 Millionen Einwohner haben!

-- In welchem Land wohnen die meisten Einwohner?



-- In welchen Ländern leben mehr als 10% der Einwohner in der Hauptstadt?

-- In wievielen Ländern leben mehr als 10% der Einwohner in der Hauptstadt?

-- Geben Sie alle Länder aus, in denen mehr als 5% der Einwohner deutsch sprechen!

-- Berechnen Sie die Bevölkerungsdichte Europas!

-- Berechnen Sie die Bevölkerungsdichte je Kontinent!

-- Wieviele Länder mit weniger als 20 Mio Einwohners gibt es?

-- Geben Sie für alle Sprachen an, in wievielen Ländern Sie gesprochen werden!

-- Geben Sie für alle Sprachen an, in wievielen Ländern mehr als 10% der Einwohner diese Sprache sprechen!

-- Geben Sie für alle Länder die Anzahl der Millionenstädt an!

-- Geben Sie alle Länder an, die mehr als 5 Millionenstädte haben!

-- Geben Sie alle Sprachen an, die in mehr als 5 Ländern von jeweils mehr als 10% der Einwohner gesprochen werden!

-- In welchen Ländern werden mehr als vier Sprachen gesprochen?

-- In welchen Ländern werden mehr als zwei offizielle Sprachen gesprochen?

-- In welchen Ländern wird "Uzbek" gesprochen, aber nicht 'Ukrainian'?

-- In welchen Ländern wird eine Sprache gesprochen, die auch in Sweden gesprochen wird?

-- In welchen Ländern ist eine in Sweden gesprochene Sprache Amtssprache?

-- Geben Sie die Bevölkerungsdichte für alle Länder Asiens aus!

-- Welche Länder haben eine grössere Bevölkerungsdichte als Deutschland?

-- Finden Sie alle Städtenamen, die es mehrmals gibt! 

