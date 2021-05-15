-- Maximilian Schulke 20215853

CREATE SCHEMA maximilian_schulke;
SET SCHEMA 'maximilian_schulke';

-- Tables

CREATE TABLE Genre (
    GenreId SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    SuperGenreID INT,
    FOREIGN KEY (SuperGenreID) REFERENCES Genre(GenreId)
);

CREATE TABLE Artist (
    ArtistId SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Age INT,
    Nationality VARCHAR(255) NOT NULL,
    GenreId INT NOT NULL,
    Alive BOOLEAN NOT NULL,
    FOREIGN KEY (GenreId) REFERENCES Genre(GenreId)
);

CREATE TABLE Album (
    AlbumId SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ArtistId INT NOT NULL,
    PublishingYear INT NOT NULL,
    FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId)
);

CREATE TABLE Song (
    SongId SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AlbumId INT,
    Length TIME NOT NULL,
    Explicit BOOLEAN NOT NULL,
    FOREIGN KEY (AlbumId) REFERENCES Album(AlbumId)
);

CREATE TABLE Song_Artist (
    SongId INT NOT NULL,
    ArtistId INT NOT NULL,
    FOREIGN KEY (SongId) REFERENCES Song(SongId),
    FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId),
    PRIMARY KEY (SongId, ArtistId)
);

CREATE TABLE Playlist (
    PlaylistId SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE Playlist_Song (
    PlaylistId INT NOT NULL,
    SongId INT NOT NULL,
    FOREIGN KEY (PlaylistId) REFERENCES Playlist(PlaylistId),
    FOREIGN KEY (SongId) REFERENCES Song(SongId),
    PRIMARY KEY (SongId, PlaylistId)
);

-- Inserts

-- System Of A Down

INSERT INTO Genre VALUES (1, 'Rock', NULL), (2, 'Alternative Metal', 1);

INSERT INTO Artist VALUES (1, 'System Of A Down', NULL, 'USA', 2, TRUE);

INSERT INTO Album VALUES (1, 'Steal This Album!', 1, 2002);

INSERT INTO Song
VALUES (1, 'Innervision', 1, '00:02:33', FALSE),
       (2, 'Bubbles', 1, '00:01:56', FALSE),
       (3, 'A.D.D. (Americal Dream Denial)', 1, '00:03:17', TRUE);

INSERT INTO Song_Artist
VALUES (1, 1), (2, 1), (3, 1);

-- Slipknot

INSERT INTO Artist VALUES (2, 'Slipknot', NULL, 'USA', 2, TRUE);

INSERT INTO Album VALUES (2, 'Slipknot (10th Anniversary Edition)', 2, 2002);

INSERT INTO Song
VALUES (4, 'Tattered & Torn', 2, '00:02:53', TRUE),
       (5, 'No Life', 2, '00:02:47', TRUE);

INSERT INTO Song_Artist
VALUES (4, 2), (5, 2);

INSERT INTO Playlist
VALUES (1, 'Mix #1'),
       (2, 'My Metal'),
       (3, 'Best of Rock');

INSERT INTO Playlist_Song
VALUES (1, 4), (2, 4), (3, 5);

-- Peter Fox

INSERT INTO Genre VALUES (3, 'Hip Hop', NULL), (4, 'German Hip Hop', 3);

INSERT INTO Artist VALUES (3, 'Peter Fox', 49, 'Germany', 4, TRUE);

INSERT INTO Album VALUES (3, 'Stadtaffe', 3, 2008);

INSERT INTO Song
VALUES (6, 'Alles neu', 3, '00:04:20', FALSE),
       (7, 'Der letzte Tag', 3, '00:03:42', FALSE);

INSERT INTO Song_Artist
VALUES (6, 3), (7, 3);

INSERT INTO Playlist
VALUES (4, 'Deutschrap'),
       (5, 'Best of Rap'),
       (6, 'Mix #3');

INSERT INTO Playlist_Song
VALUES (4, 6), (5, 6), (6, 7);

-- Beispiel Queries

-- Alle Songs von Artists über 40

SELECT song.title, artist.name FROM song
JOIN song_artist ON song.songid = song_artist.songid
JOIN artist ON song_artist.artistid = artist.artistid
WHERE artist.age > 40;

-- Alle Artists inklusive ihrer Genre

SELECT artist.name, genre.name FROM artist
JOIN genre ON artist.genreid = genre.genreid;

-- Alle Playlists, die Menge an Songs die diese Playlist enthält und ihre Länge

SELECT playlist.name, count(playlist.name) contains_songs, SUM(song.length) as total_length FROM playlist
JOIN playlist_song ON playlist.playlistid = playlist_song.playlistid
JOIN song ON playlist_song.songid = song.songid
GROUP BY playlist.name;

