-- zad.1
CREATE EXTENSION postgis;

CREATE TABLE obiekty (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    geom GEOMETRY
);

INSERT INTO obiekty (name, geom) VALUES
('obiekt1', ST_GeomFromText('COMPOUNDCURVE((0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1),(5 1, 6 1))')),
('obiekt2', ST_GeomFromText('MULTICURVE(
    CIRCULARSTRING(11 2, 12 1, 13 2, 12 3, 11 2),
    COMPOUNDCURVE(
        (10 6, 10 2), 
        CIRCULARSTRING(10 2, 12 0, 14 2),
        CIRCULARSTRING(14 2, 16 4, 14 6),
        (14 6, 10 6)))')),
('obiekt3', ST_GeomFromText('LINESTRING( 10 17, 7 15, 12 13, 10 17 )')),
('obiekt4', ST_GeomFromText('LINESTRING( 20.5 19.5, 22 19, 26 21, 25 22, 27 24, 25 25, 20 20 )')),
--('obiekt5', 'MULTIPOINT((30 30 59), (38 32 234))'),
('obiekt6', ST_GeomFromText('MULTILINESTRING(( 1 1, 3 2 ), ( 4 2, 4 2 ))'));



-- zad.2
WITH shortest_line AS (
    SELECT ST_ShortestLine( o3.geom, o4.geom ) AS geom
    FROM obiekty o3, obiekty o4
    WHERE o3.name = 'obiekt3' AND o4.name = 'obiekt4'
)

SELECT ST_Area( ST_Buffer( geom, 5 ) ) AS buffer_area
FROM shortest_line;



-- zad.3
UPDATE obiekty
SET geom = ST_AddPoint( geom, ST_StartPoint( geom ) )
WHERE name = 'obiekt4';

UPDATE obiekty
SET geom = ST_MakePolygon( geom )
WHERE name = 'obiekt4';

SELECT name, ST_GeometryType( geom )
FROM obiekty
WHERE name = 'obiekt4';



-- zad.4
INSERT INTO obiekty ( name, geom )
SELECT 'obiekt7', ST_Collect( o3.geom, o4.geom )
FROM obiekty o3, obiekty o4
WHERE o3.name = 'obiekt3' AND o4.name = 'obiekt4';



-- zad.5
WITH filtered_objects AS (
    SELECT o.id, o.name, o.geom
    FROM obiekty o
    WHERE NOT ST_HasArc(o.geom)
)

SELECT SUM( ST_Area( ST_Buffer( f.geom, 5 ) ) ) AS total_buffer_area
FROM filtered_objects f;
