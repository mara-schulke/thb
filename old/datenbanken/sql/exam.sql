-- Mara Schulke, 20215853

-- Tragen Sie Ihren Vor- und Nachnamen und die Matrikelnummer in der 1. Zeile ein!
-- Tragen Sie Ihre Anfragen immer direkt unter den Aufgaben ein.
-- Schließen Sie jede Anfrage mit einem Semikolon ';' ab!
-- Verändern Sie die Kommentare nicht!
-- Für jede Abfrage gibt es 3 Punkte.

set schema 'klausur';

-- 01.  Geben Sie die Liste aller Kunden (Kartennr, Vorname, Nachname) aus,
--      deren Nachname mit F beginnt!

SELECT kartennummer, vorname, nachname FROM kundenkarte
WHERE nachname LIKE 'F%';

-- 02.  Geben Sie die GTIN, die Bezeichnung und den Lagerbestand aller Waren aus!

SELECT gtin, bezeichnung, lagerbestand FROM ware;

-- 03.  Geben Sie für alle abgelaufenen Artikel (mhd < '2021-01-25') den Wert (anzahl*preis) an!
--      (gtin, bezeichnung, lagerbestand, wert)

SELECT gtin, mhd, bezeichnung, (lagerbestand * preis) AS wert FROM ware
WHERE mhd < '2021-01-25';

-- 04.  Wie viele unterschiedliche Artikel sind noch im Lager?

SELECT DISTINCT count(gtin) FROM ware; -- Falls sie nur die Anzahl der Typen meinen

SELECT DISTINCT sum(lagerbestand) * count(gtin) AS unterschiedliche_artikel_anzahl
FROM ware; -- Falls sie den Lagerbestand * Anzahl der Artikel meinen;

-- 05.  Geben Sie die Liste aller Waren an! Sortieren Sie absteigend nach dem Lagerbestand und ggf. aufsteigend nach dem Preis
--      (gtin, bezeichnung, preis, lagerbestand)

SELECT gtin, bezeichnung, preis, lagerbestand FROM ware
ORDER BY lagerbestand DESC, preis ASC;

-- 06.  Welches Produkt ist am häufigsten am Lager (bezeichnung, lagerbestand)

SELECT * FROM ware
WHERE lagerbestand = (SELECT max(lagerbestand) FROM ware);

-- 07.  Geben Sie alle Positionen zum Einkaufnr 3511 an! (GTIN, Bezeichnung, Preis, Anzahl)

SELECT ware.gtin, bezeichnung, preis, anzahl FROM ware
JOIN gekauft ON ware.gtin = gekauft.gtin
WHERE gekauft.einkaufnr = 3511;

-- 08.  Geben Sie für alle Kunden an, wie oft sie eingekauft haben! (vorname, nachname, anzahl der einkaeufe)

SELECT vorname, nachname, count(einkauf.einkaufnr) FROM kundenkarte
JOIN einkauf ON kundenkarte.kartennummer = einkauf.kartennummer
GROUP BY kundenkarte.kartennummer;

-- 09.  Geben Sie zu jedem Einkauf an Kasse 3 den Gesamtwert des Einkaufs an!
--      (Datum, Uhrzeit, Wert des Einkaufs, ggf. Vorname, ggf. Nachname)

SELECT datum, uhrzeit, sum(preis) AS wert, nachname, vorname FROM einkauf
LEFT JOIN kundenkarte ON kundenkarte.kartennummer = einkauf.kartennummer
JOIN gekauft ON einkauf.einkaufnr = gekauft.einkaufnr
JOIN ware ON gekauft.gtin = ware.gtin
WHERE kasse_nr = 3
GROUP BY einkauf.einkaufnr, kundenkarte.kartennummer;

-- 10.  Geben Sie zu jedem Einkauf an Kasse 3 den Gesamtwert des Einkaufs an!
--      Berücksichtigen Sie nur Einkäufe über 100 EUR!
--      (Datum, Uhrzeit, Wert des Einkaufs, ggf. Vorname, ggf. Nachname)

SELECT datum, uhrzeit, sum(preis) AS wert, nachname, vorname FROM einkauf
LEFT JOIN kundenkarte ON kundenkarte.kartennummer = einkauf.kartennummer
JOIN gekauft ON einkauf.einkaufnr = gekauft.einkaufnr
JOIN ware ON gekauft.gtin = ware.gtin
WHERE kasse_nr = 3
GROUP BY einkauf.einkaufnr, kundenkarte.kartennummer
HAVING sum(preis) > 100;

-- 11.  Welche Kunden (Kundenkartennr, Vorname, Nachname) haben 2020 nicht eingekauft?

SELECT kundenkarte.kartennummer, vorname, nachname FROM kundenkarte
JOIN einkauf ON kundenkarte.kartennummer = einkauf.kartennummer
WHERE datum BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY kundenkarte.kartennummer
HAVING count(einkaufnr) = 0;

-- Ab hier folgen Zusatzaufgaben, jeweils 2 Punkte
-- 21. (Zusatz) Wieviele Positionen enthält ein durchschnittlicher Kassenzettel (Einkauf)? (2 Nachkommastellen)

SELECT round(avg(einkäufe.anzahl_artikel), 2) FROM (
    SELECT count(ware.gtin) anzahl_artikel
    FROM ware
    JOIN gekauft ON ware.gtin = gekauft.gtin
    GROUP BY einkaufnr
) einkäufe;

-- 22. (Zusatz) Welcher Kunde hat am häufigsten eingekauft? (vorname, nachname, anzahl)
--      mal sehen, wer das rausbekommt

-- Geht wahrscheinlich mit einer nested query weinger, oder?
SELECT nachname, vorname, count(einauf.einkaufnr) AS anzahl FROM kundenkarte
JOIN einkauf ON kundenkarte.kartennummer = einkauf.kartennummer
GROUP BY kundenkarte.kartennummer
HAVING count(einkauf.einkaufnr) = (
    SELECT max(einkäufe.anzahl) FROM (
        SELECT count(einkaufnr) AS anzahl FROM einkauf
        WHERE kartennummer IS NOT NULL
        GROUP BY kartennummer
    ) einkäufe
);

