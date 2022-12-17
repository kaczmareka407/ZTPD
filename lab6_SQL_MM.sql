--LAB 6
--CW1

--A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;
 
 -- B
 select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1

-- C
DROP TABLE MYST_MAJOR_CITIES;


CREATE TABLE MYST_MAJOR_CITIES(
FIPS_CNTRY VARCHAR2(2),
CITY_NAME VARCHAR2(40),
STGEOM ST_POINT
);
select * from MYST_MAJOR_CITIES

-- D
select * from MAJOR_CITIES;

select FIPS_CNTRY, CITY_NAME, GEOM from MAJOR_CITIES;

INSERT INTO MYST_MAJOR_CITIES select FIPS_CNTRY, CITY_NAME, ST_POINT(GEOM) from MAJOR_CITIES;

-- CW2
-- A

INSERT INTO MYST_MAJOR_CITIES VALUES
('PL', 'SZCZYRK',
TREAT(ST_POINT.FROM_WKT('POINT(19.036107 49.718655)', 8307) AS ST_POINT));

-- B
SELECT *  FROM rivers r

select name,
treat(ST_POINT.FROM_SDO_GEOM(GEOM) AS ST_GEOMETRY).GET_WKT() WKT  
FROM rivers

-- C brak

select B.CITY_NAME, B.STGEOM.ST_AsGML() GML
from MYST_MAJOR_CITIES B
where B.CITY_NAME = 'Szczyrk';

-- CW 3
-- A
CREATE TABLE MYST_COUNTRY_BOUNDARIES(
FIPS_CNTRY VARCHAR2(2),
CNTRY_NAME VARCHAR2(40),
STGEOM ST_MULTIPOLYGON
)

--B

INSERT INTO  MYST_COUNTRY_BOUNDARIES select FIPS_CNTRY, CNTRY_NAME, ST_MULTIPOLYGON(GEOM) from COUNTRY_BOUNDARIES;

-- C

select A.STGEOM.ST_GeometryType(), count(A.CNTRY_NAME) from MYST_COUNTRY_BOUNDARIES A group by A.STGEOM.ST_GeometryType()

-- D

select B.STGEOM.ST_ISSIMPLE() from MYST_COUNTRY_BOUNDARIES B group by

-- CW 4

-- A
select B.CNTRY_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B,
 MYST_MAJOR_CITIES C
where C.STGEOM.ST_WITHIN(B.STGEOM) = 1
group by B.CNTRY_NAME;

-- B

select A.CNTRY_NAME A_NAME, B.CNTRY_NAME B_NAME
from MYST_COUNTRY_BOUNDARIES A,
 MYST_COUNTRY_BOUNDARIES B
where A.STGEOM.ST_TOUCHES(B.STGEOM) = 1
and B.CNTRY_NAME = 'Czech Republic';

-- C

select distinct B.CNTRY_NAME, R.name
from MYST_COUNTRY_BOUNDARIES B, RIVERS R
where B.CNTRY_NAME = 'Czech Republic'
and ST_LINESTRING(R.GEOM).ST_INTERSECTS(B.STGEOM) = 1

-- D

select TREAT(A.STGEOM.ST_UNION(B.STGEOM) as ST_POLYGON).ST_AREA() CZECHOSLOWACJA
from MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Czech Republic'
and B.CNTRY_NAME = 'Slovakia';

-- E

select B.STGEOM.GET_WKT(),TREAT(B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)) as ST_POLYGON).ST_GEOMETRYTYPE() WEGRY_BEZ
from MYST_COUNTRY_BOUNDARIES B, WATER_BODIES W
where B.CNTRY_NAME = 'Hungary'
and W.name = 'Balaton';

--CW 5

--A
select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
 'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

-- B
insert into USER_SDO_GEOM_METADATA
 select 'MYST_MAJOR_CITIES', 'STGEOM',
 T.DIMINFO, T.SRID
 from USER_SDO_GEOM_METADATA T
 where T.TABLE_NAME = 'MAJOR_CITIES';
 
 -- C
 
create index MYST_MAJOR_CITIES_IDX on
MYST_MAJOR_CITIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;

create index MYST_COUNTRY_BOUNDARIES_IDX on
MYST_COUNTRY_BOUNDARIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;

-- D

explain plan for
select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
 'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

select * from table(dbms_xplan.display)