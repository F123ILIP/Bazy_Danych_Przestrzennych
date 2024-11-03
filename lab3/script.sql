CREATE EXTENSION postgis;

-- zad.1
SELECT b2019.*
FROM t2019_kar_buildings b2019
LEFT JOIN t2018_kar_buildings b2018
ON b2019.polygon_id = b2018.polygon_id AND b2019.height = b2018.height
WHERE b2018.polygon_id IS NULL;

-- zad.2
WITH buildings AS (
	SELECT left_table.*
	FROM t2019_kar_buildings AS left_table
	LEFT JOIN t2018_kar_buildings AS right_table 
	ON left_table.geom = right_table.geom AND left_table.height = right_table.height
	WHERE right_table.geom IS NULL
), buffer AS (
	SELECT ST_Buffer( ST_Union( geom ), 0.005 ) AS geom FROM buildings
), new_poi AS (
	SELECT left_table.*
	FROM t2019_kar_poi_table AS left_table
	LEFT JOIN t2018_kar_poi_table AS right_table
	ON left_table.geom = right_table.geom
	WHERE right_table.geom IS NULL
), count_poi AS (
	SELECT COUNT(*) AS count, right_table.type
	FROM new_poi AS right_table
	JOIN buffer AS left_table
	ON ST_DWithin(left_table.geom, right_table.geom, 0.005)
	GROUP BY right_table.type
)

SELECT * 
FROM count_poi
WHERE count != 0
ORDER BY count DESC;

-- zad.3
CREATE TABLE streets_reprojected AS
SELECT gid, ST_Transform( geom, 3068 ) AS geom
FROM t2019_kar_buildings;

-- zad.4
CREATE TABLE input_points (
    id SERIAL PRIMARY KEY,
    geom GEOMETRY( Point, 4326 )
);

INSERT INTO input_points( geom )
VALUES ( ST_SetSRID( ST_MakePoint( 8.36093, 49.03174 ), 4326 ) ),
       ( ST_SetSRID( ST_MakePoint( 8.39876, 49.00644 ), 4326 ) );

-- zad.5
ALTER TABLE input_points
ALTER COLUMN geom TYPE geometry( Point, 3068 )
USING ST_Transform( geom, 3068 );

-- zad.6
WITH line AS (
    SELECT ST_MakeLine( geom ORDER BY id ) AS geom
    FROM input_points
)
SELECT ksn.*
FROM t2019_kar_street_node ksn, line
WHERE ST_DWithin( ST_Transform( ksn.geom, 3068 ), line.geom, 200 );

-- zad.7
SELECT COUNT(*) AS sport_store_count
FROM t2019_kar_poi_table poi
JOIN t2019_kar_land_use_a park ON poi.type = 'Sporting Goods Store'
WHERE ST_DWithin( poi.geom, park.geom, 300 );

-- zad.8
SELECT DISTINCT ST_Intersection( kr.geom, kwl.geom ) AS geom
INTO t2019_kar_bridges
FROM t2019_kar_railways AS kr
CROSS JOIN t2019_kar_water_lines AS kwl
WHERE ST_Intersects( kr.geom, kwl.geom );



