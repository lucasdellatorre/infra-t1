/*
    Listar o nome da companhia aérea, o identificador da aeronave, o nome do tipo de aeronave 
    e o número de todos os voos operados por essa companhia aérea 
    (independentemente de a aeronave ser de sua propriedade) 
    que saem E chegam em aeroportos localizados no país 'BRAZIL'. 
*/

/*
    Adicionar chaver primárias e estrangeiras em todas as tabelas pra ver a diferença
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
    
ALTER TABLE AIR_AIRLINES
ADD PRIMARY KEY(airline_id);

ALTER TABLE AIR_AIRPLANES
ADD CONSTRAINT fk_airline_id
FOREIGN KEY (airline_id)
REFERENCES AIR_AIRLINES(airline_id);

ALTER TABLE AIR_FLIGHTS
ADD PRIMARY KEY(flight_id);

ALTER TABLE AIR_FLIGHTS
ADD CONSTRAINT fk_airplane_id
FOREIGN KEY (airplane_id)
REFERENCES AIR_AIRPLANES(airplane_id);

ALTER TABLE AIR_AIRPORTS
ADD PRIMARY KEY(airport_id);

ALTER TABLE AIR_AIRPORTS_GEO_CL
ADD PRIMARY KEY(airport_id);


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

SELECT PLAN_TABLE_OUTPUT 
FROM TABLE(DBMS_XPLAN.DISPLAY());

ALTER TABLE AIR_AIRPORTS
ADD PRIMARY KEY(AIRPORT_ID);

ALTER TABLE AIR_FLIGHTS
ADD CONSTRAINT fk_airport_id_from
FOREIGN KEY (from_airport_id)
REFERENCES AIR_AIRPORTS(airport_id);

ALTER TABLE AIR_FLIGHTS
ADD CONSTRAINT fk_airport_id_to
FOREIGN KEY (to_airport_id)
REFERENCES AIR_AIRPORTS(airport_id);

ALTER TABLE AIR_AIRPLANE_TYPES
ADD PRIMARY KEY(AIRPLANE_TYPE_ID);

ALTER TABLE AIR_AIRPLANES
ADD CONSTRAINT fk_airplane_type_id
FOREIGN KEY (AIRPLANE_TYPE_ID)
REFERENCES AIR_AIRPLANE_TYPES(AIRPLANE_TYPE_ID);

CREATE INDEX fk_airport_id_from ON AIR_FLIGHTS(from_airport_id);
CREATE INDEX fk_airport_id_to ON AIR_FLIGHTS(to_airport_id);
