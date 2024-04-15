/*
    Listar o número do voo, o nome do aeroporto de saída e o nome do aeroporto de destino, 
    o nome completo (primeiro e último nome) e o assento de cada passageiro, 
    para todos os voos que partem no dia do seu aniversário neste ano 
    (caso a consulta não retorne nenhuma linha, 
    faça para o dia subsequente até encontrar uma data que retorne alguma linha). 
*/

EXPLAIN PLAN FOR
SELECT 
    airlines.AIRLINE_NAME,
    afs.MONDAY,
    afs.ARRIVAL,
    afs.DEPARTURE,
    f.ARRIVAL,
    f.DEPARTURE,
    airgeo.CITY
FROM 
    AIR_FLIGHTS_SCHEDULES afs 
    JOIN AIR_AIRLINES airlines ON airlines.AIRLINE_ID = afs.AIRLINE_ID
    JOIN AIR_FLIGHTS f ON f.FLIGHTNO = afs.FLIGHTNO
    JOIN AIR_AIRPORTS airports ON airports.AIRPORT_ID = f.TO_AIRPORT_ID  
    JOIN AIR_AIRPORTS_GEO_CL2 airgeo ON airgeo.AIRPORT_ID = airports.AIRPORT_ID
    JOIN AIR_FLIGHTS_SCHEDULES afs ON afs.FLIGHTNO = f.FLIGHTNO
WHERE
    f.DEPARTURE BETWEEN TRUNC(TO_DATE('2023-03-01', 'YYYY-MM-DD')) AND LAST_DAY(TO_DATE('2023-03-01', 'YYYY-MM-DD'))
    AND (
    afs.TUESDAY = 1
    OR
    afs.WEDNESDAY = 1
    OR  
    afs.THURSDAY = 1
    ) 
    AND 
    airgeo.CITY = 'NEW YORK';

SELECT PLAN_TABLE_OUTPUT 
FROM TABLE(DBMS_XPLAN.DISPLAY());
    
create bitmap index idx_tuesday on AIR_FLIGHTS_SCHEDULES(TUESDAY);
create bitmap index idx_wednesday on AIR_FLIGHTS_SCHEDULES(WEDNESDAY);
create bitmap index idx_thursday on AIR_FLIGHTS_SCHEDULES(THURSDAY);
create index idx_city on AIR_AIRPORTS_GEO(CITY);

DROP CLUSTER air_airports_geo_country  including tables CASCADE CONSTRAINTS;

CREATE CLUSTER air_airports_geo_city_cl (
 CITY varchar2(50)
)
SIZE 8K
hashkeys 128;

CREATE TABLE AIR_AIRPORTS_GEO_CL2 (
    AIRPORT_ID NUMBER(5) NOT NULL,
    NAME VARCHAR2(50) NOT NULL,
    CITY VARCHAR2(50) not null,
    COUNTRY VARCHAR2(50) not null,
    LATITUDE NUMBER(11,8) NOT NULL,
    LONGITUDE NUMBER(11,8) NOT NULL
) cluster air_airports_geo_city_cl(city);

insert into AIR_AIRPORTS_GEO_CL2 select * from AIR_AIRPORTS_GEO;

DELETE FROM AIR_AIRPORTS_GEO WHERE CITY IS NULL;



describe AIR_AIRPORTS_GEO;

drop index idx_tuesday;
drop index idx_wednesday;
drop index idx_thursday;
drop index idx_city;

