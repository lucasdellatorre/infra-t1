/*
    Listar o número do voo, o nome do aeroporto de saída e o nome do aeroporto de destino, 
    o nome completo (primeiro e último nome) e o assento de cada passageiro, 
    para todos os voos que partem no dia do seu aniversário neste ano 
    (caso a consulta não retorne nenhuma linha, 
    faça para o dia subsequente até encontrar uma data que retorne alguma linha). 
*/

EXPLAIN PLAN FOR
SELECT
    f.FLIGHTNO AS FLIGHT_NUMBER,
    airport_to.NAME AS AIRPORT_TO,
    airport_from.NAME AS AIRPORT_FROM,
    p.FIRSTNAME || ' ' || p.LASTNAME AS FULLNAME,
    b.SEAT,
    f.DEPARTURE
FROM 
    AIR_FLIGHTS f 
    JOIN AIR_AIRPORTS airport_to ON airport_to.AIRPORT_ID = f.TO_AIRPORT_ID
    JOIN AIR_AIRPORTS airport_from ON airport_from.AIRPORT_ID = f.FROM_AIRPORT_ID
    JOIN AIR_BOOKINGS b ON b.FLIGHT_ID = f.FLIGHT_ID
    JOIN AIR_PASSENGERS p ON p.PASSENGER_ID = b.PASSENGER_ID
WHERE 
    f.DEPARTURE >= DATE '2023-03-25' 
    AND 
    f.DEPARTURE < DATE '2023-03-26';
    
create index idx_departure on AIR_FLIGHTS(DEPARTURE);

DROP INDEX idx_from_airport_id;

ALTER TABLE AIR_BOOKINGS
ADD CONSTRAINT fk_bookings_flight_id
FOREIGN KEY(FLIGHT_ID)
REFERENCES AIR_FLIGHTS(FLIGHT_ID)

ALTER TABLE AIR_BOOKINGS
ADD CONSTRAINT fk_bookings_passenger_id
FOREIGN KEY(PASSENGER_ID)
REFERENCES AIR_PASSENGERS(PASSENGER_ID);

ALTER TABLE AIR_FLIGHTS
ADD CONSTRAINT fk_flights_from_airport_id
FOREIGN KEY(FROM_AIRPORT_ID)
REFERENCES AIR_AIRPORTS(AIRPORT_ID);

ALTER TABLE AIR_FLIGHTS
ADD CONSTRAINT fk_flights_to_airport_id
FOREIGN KEY(TO_AIRPORT_ID)
REFERENCES AIR_AIRPORTS(AIRPORT_ID);
    
ALTER TABLE AIR_FLIGHTS
ADD PRIMARY KEY(FLIGHT_ID);    

ALTER TABLE AIR_AIRPORTS
ADD PRIMARY KEY(AIRPORT_ID);

ALTER TABLE AIR_BOOKINGS
ADD PRIMARY KEY(BOOKING_ID);    

ALTER TABLE AIR_PASSENGERS
ADD PRIMARY KEY(PASSENGER_ID);    

--describe air_flights;
--
--CREATE CLUSTER air_flights_departure (
--    departure TIMESTAMP(6)
--)
--SIZE 8K
--hashkeys 128;
--
--DROP CLUSTER air_flights_departure including tables cascade constraints;
--
--CREATE TABLE AIR_FLIGHTS_CL (
--    FLIGHT_ID       NUMBER(10) NOT NULL,
--    FLIGHTNO        CHAR(8) NOT NULL,
--    AIRLINE_ID      NUMBER(5) NOT NULL,
--    FROM_AIRPORT_ID NUMBER(5) NOT NULL,
--    TO_AIRPORT_ID   NUMBER(5) NOT NULL,
--    AIRPLANE_ID     NUMBER(5) NOT NULL,
--    DEPARTURE       TIMESTAMP(6) NOT NULL,
--    ARRIVAL         TIMESTAMP(6) NOT NULL,
--    CONSTRAINT pk_air_flights_cl PRIMARY KEY (FLIGHT_ID)
--) cluster air_flights_departure(departure);
--
--insert into air_flights_cl select * from AIR_FLIGHTS;

EXPLAIN PLAN FOR
SELECT
    f.FLIGHTNO AS FLIGHT_NUMBER,
    airport_to.NAME AS AIRPORT_TO,
    airport_from.NAME AS AIRPORT_FROM,
    p.FIRSTNAME || ' ' || p.LASTNAME AS FULLNAME,
    b.SEAT,
    f.DEPARTURE
FROM 
    AIR_FLIGHTS f 
    JOIN AIR_AIRPORTS airport_to ON airport_to.AIRPORT_ID = f.TO_AIRPORT_ID
    JOIN AIR_AIRPORTS airport_from ON airport_from.AIRPORT_ID = f.FROM_AIRPORT_ID
    JOIN AIR_BOOKINGS b ON b.FLIGHT_ID = f.FLIGHT_ID
    JOIN AIR_PASSENGERS p ON p.PASSENGER_ID = b.PASSENGER_ID
WHERE 
    f.DEPARTURE BETWEEN TRUNC(TO_DATE('2023-03-25', 'YYYY-MM-DD')) AND (TRUNC(TO_DATE('2023-03-26', 'YYYY-MM-DD'))-(1/(24*60*60)));
