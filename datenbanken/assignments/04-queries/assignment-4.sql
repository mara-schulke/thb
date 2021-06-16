-- Maximilian Schulke, 20215853


-- Tragen Sie Ihren Vor- und Nachnamen und die Matrikelnummer in der 1. Zeile ein!

-- Tragen Sie Ihre Anfragen immer direkt unter den Aufgaben ein.

-- Schließen Sie jede Anfrage mit einem Semikolon ';' ab!

-- Verändern Sie die Kommentare nicht!

-- Für jede Abfrage gibt es 3 Punkte.


set schema 'music_db';


-- 01.     Listen Sie die Informationen zu allen nicht jugendfreien Songs auf. (Spalte Explicit auf true).

SELECT * FROM song WHERE explicit = true;

-- 02.     Geben Sie eine Liste nach folgendem Schema an: Name des Albums, Name des Künstlers, Erscheinungsjahr. 
--         Ordnen Sie diese Liste nach dem Erscheinungsjahr und dem Künstlernamen.

SELECT title, artist.name, publishingyear FROM album
JOIN artist ON artist.artistid = album.artistid
ORDER BY publishingyear, artist.name;

-- 03.    Listen Sie die Namen aller Alben von Künstlern aus den USA auf. Geben Sie zusätzlich den Namen des 
--        Künstlers an, der dieses Album veröffentlicht hat.

SELECT title, artist.name, publishingyear FROM album
JOIN artist ON artist.artistid = album.artistid
ORDER BY publishingyear, artist.name;

-- 04.    Listen Sie alle Informationen über die Songs aus der Playlist 'Melancholie' auf.

SELECT * FROM song
JOIN playlist_song ps on song.songid = ps.songid
JOIN playlist on ps.playlistid = playlist.playlistid
WHERE playlist.name = 'Melancholie';

-- 05.     Listen Sie alle Songs (Spalten Title und Length) vom Album 'ZENIT RR'.

SELECT song.title, length FROM song
JOIN album ON song.albumid = album.albumid
WHERE album.title = 'ZENIT RR';

-- 06.    Geben Sie die Namen der Künstler des Genres 'german hip hop' an.

SELECT artist.name FROM artist
JOIN genre on artist.genreid = genre.genreid
WHERE genre.name = 'german hip hop';

-- 07.    Erstellen Sie eine Liste 'Songtitel', 'Künstlername' mit allen Songs von dem Künstler 'Juice WRLD'

SELECT title, artist.name FROM song
JOIN song_artist ON song.songid = song_artist.songid
JOIN artist ON song_artist.artistid = artist.artistid
WHERE artist.name = 'Juice WRLD';

-- 08.    Geben Sie alle Songinformationen der Songs von dem Album '? (Deluxe)' auf, die 
--        kürzer als 2:30Min (150 Sekunden) sind.

SELECT song.* FROM song
JOIN album ON song.albumid = album.albumid
WHERE album.title = '? (Deluxe)' AND length < 150;

-- 09.    Ermitteln Sie die durchschnittliche Länge eines Songs. Runden sie auf einen ganzzahligen Wert. 
--        (Bitte vor Aufgabe 19 bearbeiten)

SELECT round(avg(length)) FROM song; -- 214 Sekunden

-- 10.    Listen Sie die Namen aller Songs auf, die mit 'S' beginnen und von einem deutschen Künstler gesungen werden.

SELECT title FROM song
JOIN song_artist ON song.songid = song_artist.songid
JOIN artist ON song_artist.artistid = artist.artistid
WHERE title LIKE 'S%' and artist.nationality = 'Germany';

-- 11.    Listen Sie zu jedem Künstler den Namen und die Anzahl ihrer Songs auf. Die Spalte mit den Anzahl der 
--        Songs soll 'Songanzahl' heißen.

SELECT name, count(songid) Songanzahl FROM artist
JOIN song_artist ON artist.artistid = song_artist.artistid
GROUP BY artist.artistid;

-- 12.    Listen Sie zu jedem Künstler den Namen und die Anzahl ihrer Songs auf. Die Spalte mit den Anzahl der 
--        Songs soll 'Songanzahl' heißen. Es sollen nur die Künstler angegeben werden, die mindestens 4 Songs haben.

SELECT name, count(songid) Songanzahl FROM artist
JOIN song_artist ON artist.artistid = song_artist.artistid
GROUP BY artist.artistid
HAVING count(songid) >= 4;

-- 13.    Geben Sie eine Liste mit den Namen der Playlisten, der Anzahl der dazugehörigen Songs und der Länge der 
--        Playlist in Sekunden an.

SELECT name, count(song.songid) AS song_count, sum(song.length) AS length FROM playlist
JOIN playlist_song ON playlist.playlistid = playlist_song.playlistid
JOIN song ON playlist_song.songid = song.songid
GROUP BY playlist.playlistid;

-- 14.    Geben Sie eine Liste mit den Namen der Playlisten, der Anzahl der dazugehörigen Songs und der Länge der 
--        Playlist in Sekunden an. Berücksichtigen Sie nur Playlists mit mindestens 10 Einträgen.

SELECT name, count(song.songid) AS song_count, sum(song.length) AS length FROM playlist
JOIN playlist_song ON playlist.playlistid = playlist_song.playlistid
JOIN song ON playlist_song.songid = song.songid
GROUP BY playlist.playlistid
HAVING count(song.songid) >= 10;

-- 15.    Geben Sie eine Liste mit den Namen der Playlisten, der Anzahl der dazugehörigen Songs und der Länge der 
--        Playlist in Sekunden an. Berücksichtigen Sie nur Playlists mit mindestens 10 Einträgen und nur jugendfreie Songs.

SELECT name, count(song.songid) as song_count, sum(song.length) as length FROM playlist
JOIN playlist_song ON playlist.playlistid = playlist_song.playlistid
JOIN song ON playlist_song.songid = song.songid
WHERE song.explicit = false
GROUP BY playlist.playlistid
HAVING count(song.songid) >= 10;

-- 16.    Listen Sie den Namen und das Veröffentlichungsdatum aller Alben auf, die von Interpreten des 
--        'alternative metal'-Genres und nach 2008 veröffentlicht wurden.

SELECT title FROM album
JOIN artist ON album.artistid = artist.artistid
JOIN genre ON artist.genreid = genre.genreid
WHERE genre.name = 'alternative metal' AND album.publishingyear > 2008;

-- 17.    Geben Sie die Namen aller Künstler an, die mehr als 2 Alben in unserer Datenbank gespeichert haben.

SELECT artist.name FROM artist
JOIN album ON artist.artistid = album.artistid
GROUP BY artist.name
HAVING count(albumid) > 2;

-- 18.    Geben Sie alle Informationen zu den Alben an, die in den Jahren 2005 bis 2012 erschienen sind.
--        Ordnen Sie diese Liste absteigend nach dem Erscheinungsjahr.

SELECT * FROM album
WHERE publishingyear BETWEEN 2005 AND 2012
ORDER BY publishingyear DESC;

-- 19.    Fügen Sie den jugendfreien Song 'Last Christmas', mit der Länge 267 hinzu. Hinweis: Die SongId müssen 
--        Sie nicht mit angeben. (Bitte Aufgabe 9 zu erst bearbeiten)

INSERT INTO song (title, length, explicit) VALUES ('Last Christmas', 267, false);

-- 20.    Wie lauten die Namen der Genres, denen kein Künstler in unserer Datenbank zugeordnet ist?

SELECT genre.name FROM genre
LEFT OUTER JOIN artist ON genre.genreid = artist.genreid
GROUP BY genre.genreid
HAVING count(artistid) = 0;

-- 21.    Geben Sie die Anzahl der Songs von Künstlern an, die nicht aus den 'USA' kommen.

SELECT count(song.songid) FROM song
JOIN song_artist ON song.songid = song_artist.songid
JOIN artist ON song_artist.artistid = artist.artistid
WHERE artist.nationality != 'USA';

-- 22.    Listen Sie die Namen aller Alben auf, wo der Künstler bereits verstorben ist und das Album mindestens 12 Songs enthält.

SELECT album.title FROM album
JOIN artist ON album.artistid = artist.artistid
JOIN song ON album.albumid = song.albumid
WHERE alive = false
GROUP BY album.albumid
HAVING count(song.songid) >= 12;

-- 23.    Wie lang ist der längste Song?

SELECT max(length) FROM song;

-- 24.     Wie ist der Titel des neuesten Albums?

-- Gibt alle neuen Alben zurück

SELECT title FROM album
WHERE publishingyear = (SELECT max(publishingyear) FROM album);

-- Alternative: Gibt maximal 1 neustes Album zurück

SELECT title FROM album
WHERE publishingyear = (SELECT max(publishingyear) FROM album)
LIMIT 1;

-- 25.    Listen Sie die Namen aller Songs auf bei denen mindestens 3 Künstler mitwirken.

SELECT title FROM song
JOIN song_artist ON song.songid = song_artist.songid
GROUP BY song.songid
HAVING count(artistid) >= 3;

-- 26.    Listen Sie alle Subgenres auf. Also alle Genres, die eine Supercategory haben. Die Liste soll folgendes 
--        Format haben: "Name des Genre", "Name des Supergenre".

SELECT genre.name AS "Name des Genre", super.name AS "Name des Supergenre" FROM genre
JOIN genre super ON genre.supergenreid = super.genreid;

-- 27.    Geben Sie alle Songs von Rappern an. (Alle Spalten der Tabelle Son)

-- Vorausgesetzt, sie zählen hip hop artists nicht zu den rappern

SELECT title, artist.name FROM song
JOIN song_artist ON song.songid = song_artist.songid
JOIN artist ON song_artist.artistid = artist.artistid
WHERE artist.genreid IN (
    SELECT genre.genreid FROM genre
    LEFT JOIN genre super ON genre.supergenreid = super.genreid
    WHERE super.name = 'rap' OR genre.name = 'rap' -- Falls doch müsste hier der filter auf hiphop erweitert werden
);

-- 28.    Zusatz für Profis: Listen Sie alle Songs (Songid, Songname) auf in denen sowohl 'Sido' als auch 'Apache 207' 
--        mitgewirkt haben.g

SELECT song.songid, song.title FROM song
JOIN song_artist ON song.songid = song_artist.songid
JOIN artist ON song_artist.artistid = artist.artistid
WHERE artist.name = 'Sido'
INTERSECT
SELECT song.songid, song.title FROM song
JOIN song_artist ON song.songid = song_artist.songid
JOIN artist ON song_artist.artistid = artist.artistid
WHERE artist.name = 'Apache 207';

