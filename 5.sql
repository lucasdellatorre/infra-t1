-- Exibir todos os tipos de aeronaves da airline com id = 1

DROP CLUSTER cl_airlines_airplanes including tables CASCADE CONSTRAINTS;
 
CREATE CLUSTER cl_airlines_airplanes (
    airline_id numeric(5)
)
INDEX;
 
CREATE INDEX idx_cl_airlines_airplanes ON CLUSTER cl_airlines_airplanes;

CREATE TABLE air_airlines_cl (
    airline_id NUMBER(5) NOT NULL,
    iata CHAR(2) NOT NULL,
    airline_name VARCHAR2(30),
    base_airport_id NUMBER(5) NOT NULL,
    CONSTRAINT airlines_pk PRIMARY KEY (airline_id)
) CLUSTER cl_airlines_airplanes(airline_id);

insert into air_airlines_cl select * from air_airlines;

CREATE TABLE air_airplanes_cl (
    airplane_id NUMBER(5) NOT NULL,
    airline_id NUMBER(5) NOT NULL,
    airplane_type_id NUMBER(3) NOT NULL,
    capacity NUMBER(3) NOT NULL
    
) CLUSTER cl_airlines_airplanes(airline_id);

insert into air_airplanes_cl select * from air_airplanes;

describe air_airlines;

EXPLAIN PLAN FOR
SELECT 
    al.AIRLINE_NAME,
    apt.NAME
FROM
    air_airlines_cl al
    JOIN air_airplanes_cl ap ON al.AIRLINE_ID = ap.AIRLINE_ID
    JOIN AIR_AIRPLANE_TYPES apt ON ap.AIRPLANE_TYPE_ID = apt.AIRPLANE_TYPE_ID
WHERE
    al.airline_id = 1
;
