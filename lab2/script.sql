-- zad.2
CREATE DATABASE lab2
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Polish_Poland.1250'
    LC_CTYPE = 'Polish_Poland.1250'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- zad.3
CREATE EXTENSION postgis;

-- zad.4
CREATE TABLE buildings (
    id SERIAL PRIMARY KEY,
    geometry GEOMETRY(POLYGON), 
    name VARCHAR(255)
);

CREATE TABLE roads (
    id SERIAL PRIMARY KEY,
    geometry GEOMETRY(LINESTRING),
    name VARCHAR(255)
);

CREATE TABLE poi (
    id SERIAL PRIMARY KEY,
    geometry GEOMETRY(POINT),
    name VARCHAR(255)
);

-- zad.5
INSERT INTO buildings( geometry, name ) 
VALUES
    ( ST_GeomFromText( 'POLYGON( ( 8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4 ) )' ), 'BuildingA' ),
    ( ST_GeomFromText( 'POLYGON( ( 4 7, 4 5, 6 5, 6 7, 4 7 ) )' ), 'BuildingB' ),
    ( ST_GeomFromText( 'POLYGON( ( 3 8, 3 6, 5 6, 5 8, 3 8 ) )' ), 'BuildingC' ),
    ( ST_GeomFromText( 'POLYGON( ( 9 9, 9 8, 10 8, 10 9, 9 9 ) )' ), 'BuildingD' ),
    ( ST_GeomFromText( 'POLYGON( ( 1 2, 1 1, 2 1, 2 2, 1 2 ) )' ), 'BuildingF' );

INSERT INTO roads( geometry, name ) 
VALUES
    ( ST_GeomFromText( 'LINESTRING( 0 4.5, 12 4.5 )' ), 'RoadX' ),
    ( ST_GeomFromText( 'LINESTRING( 7.5 10.5, 7.5 0 )' ), 'RoadY' );

INSERT INTO poi( geometry, name )
VALUES
	( ST_GeomFromText( 'POINT( 1 3.5 )' ), 'G' ),
	( ST_GeomFromText( 'POINT( 5.5 1.5 )' ), 'H' ),
	( ST_GeomFromText( 'POINT( 9.5 6 )' ), 'I' ),
	( ST_GeomFromText( 'POINT( 6.5 6 )' ), 'J' ),
	( ST_GeomFromText( 'POINT( 6 9.5 )' ), 'K' );

-- zad.6
-- a)
SELECT SUM( ST_Length( geometry ) ) AS total_length
FROM roads;

-- b)
SELECT 
    ST_AsText( geometry ) AS wkt,
    ST_Area( geometry ) AS area,
    ST_Perimeter( geometry ) AS perimeter
FROM buildings
WHERE name = 'BuildingA';


-- c)
SELECT name, ST_Area( geometry ) as area
FROM buildings
ORDER BY name, area;

-- d)
SELECT name, ST_Perimeter( geometry ) AS perimeter
FROM buildings
ORDER BY perimeter desc
LIMIT 2;

-- e)
WITH k_geometry AS (
	SELECT geometry
	FROM poi 
	WHERE name = 'K' 
), c_geometry AS (
	SELECT geometry
	FROM buildings
	WHERE name = 'BuildingC'
)

SELECT ST_Distance( c.geometry, k.geometry ) AS distance
FROM k_geometry AS k
CROSS JOIN c_geometry AS c;

-- f)
SELECT ST_Area(
    ST_Difference(
        ( SELECT geometry FROM buildings WHERE name = 'BuildingC' ),
        ST_Buffer(
            ( SELECT geometry FROM buildings WHERE name = 'BuildingB' ), 0.5
        )
    )
) AS area_exceeding_distance;

-- g)
WITH centr AS (
	SELECT MAX( ST_Y( ( dp ).geom ) ) AS max_y
	FROM ST_DumpPoints( ( SELECT geometry FROM roads WHERE name = 'RoadX' ) ) AS dp
)
SELECT name
FROM buildings, centr
WHERE ST_Y( ST_Centroid( geometry ) ) > centr.max_y;

-- h)
SELECT ST_Area( ST_SymDifference(
	( SELECT geometry FROM buildings WHERE name = 'BuildingC' ), 
	ST_GeomFromText( 'POLYGON( ( 4 7, 6 7, 6 8, 4 8, 4 7 ) )' ) ) ) AS non_overlapping_area;


