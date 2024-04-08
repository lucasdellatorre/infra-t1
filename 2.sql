/*
    Listar o nome da companhia aérea, o identificador da aeronave, o nome do tipo de aeronave 
    e o número de todos os voos operados por essa companhia aérea 
    (independentemente de a aeronave ser de sua propriedade) 
    que saem E chegam em aeroportos localizados no país 'BRAZIL'. 
*/

EXPLAIN PLAN FOR
SELECT 
    airlines.AIRLINE_NAME,
    airplanes.AIRPLANE_ID,
    airplanest.NAME as AIRPLANE_NAME_TYPE,
    airflights.FLIGHTNO as FLIGHT_NUMBER
FROM
    AIR_AIRLINES airlines    
    JOIN AIR_AIRPLANES airplanes ON airplanes.AIRLINE_ID = airlines.AIRLINE_ID
    JOIN AIR_AIRPLANE_TYPES airplanest ON airplanest.AIRPLANE_TYPE_ID = airplanes.AIRPLANE_TYPE_ID
    JOIN AIR_FLIGHTS airflights ON airflights.AIRPLANE_ID = airplanes.AIRPLANE_ID
    JOIN AIR_AIRPORTS airports ON ((airports.AIRPORT_ID = airflights.FROM_AIRPORT_ID) or (airports.AIRPORT_ID = airflights.TO_AIRPORT_ID))
    JOIN AIR_AIRPORTS_GEO_CL airportsgeo ON airportsgeo.AIRPORT_ID = airports.AIRPORT_ID
WHERE
    airportsgeo.COUNTRY = 'BRAZIL';

DESCRIBE air_airports_geo;

CREATE CLUSTER air_airports_geo_country (
 country varchar(50)
)
SIZE 8K
hashkeys 128;

CREATE TABLE AIR_AIRPORTS_GEO_CL (
    AIRPORT_ID NUMBER(5) NOT NULL ,
    NAME VARCHAR2(50) NOT NULL,
    CITY VARCHAR2(50), 
    COUNTRY VARCHAR2(50), 
    LATITUDE NUMBER(11,8) NOT NULL,
    LONGITUDE NUMBER(11,8) NOT NULL 
) CLUSTER air_airports_geo_country (country);

INSERT INTO AIR_AIRPORTS_GEO_CL select * from AIR_AIRPORTS_GEO;

