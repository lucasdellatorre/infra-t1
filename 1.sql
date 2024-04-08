/*
    Listar o nome completo (primeiro nome + último nome), 
    a idade e a cidade de todos os passageiros do sexo feminino (sex='w') 
    com mais de 40 anos, residentes no país 'BRAZIL'.
*/

EXPLAIN PLAN FOR
SELECT
    ap.FIRSTNAME || ' ' || ap.LASTNAME  as FULLNAME,
    apd.BIRTHDATE,
    apd.CITY
FROM
    AIR_PASSENGERS ap
    JOIN AIR_PASSENGERS_DETAILS apd ON ap.PASSENGER_ID = apd.PASSENGER_ID
WHERE
    SEX = 'w'
    AND 
    birthdate <= ADD_MONTHS(SYSDATE,-41*12)
    AND
    COUNTRY = 'BRAZIL';
    
DROP INDEX sex_idx;
DROP INDEX country_idx;
DROP INDEX bday_idx;
DROP INDEX fk_passenger_id_idx;

DROP CLUSTER cl_passenger_details including tables CASCADE CONSTRAINTS;
DROP CLUSTER air_passengers_country including tables CASCADE CONSTRAINTS;

ALTER TABLE AIR_PASSENGERS_DETAILS
DROP PRIMARY KEY;

ALTER TABLE AIR_PASSENGERS_DETAILS
DROP constraint fk_passenger_details_id;

ALTER TABLE AIR_PASSENGERS
DROP PRIMARY KEY;

ALTER TABLE AIR_PASSENGERS
ADD PRIMARY KEY(PASSENGER_ID);

CREATE INDEX fk_passenger_id_idx ON AIR_PASSENGERS_DETAILS(passenger_id);
CREATE INDEX sex_idx ON AIR_PASSENGERS_DETAILS(sex);
CREATE INDEX country_idx ON AIR_PASSENGERS_DETAILS(country);
CREATE INDEX bday_idx ON AIR_PASSENGERS_DETAILS(birthdate);

CREATE CLUSTER air_passengers_country (
 country varchar(50)
)
INDEX
SIZE 160;

CREATE CLUSTER air_passengers_country (
 country varchar(50)
)
SIZE 8K
hashkeys 128;

CREATE INDEX idx_air_passengers_country ON CLUSTER air_passengers_country;

CREATE TABLE AIR_PASSENGERS_DETAILS_CL (
    PASSENGER_ID NUMERIC(12) NOT NULL,
    BIRTHDATE DATE NOT NULL,
    SEX CHAR(1) NOT NULL,
    STREET NOT NULL VARCHAR(100),
    CITY VARCHAR(100) NOT NULL,
    ZIP NUMBER(5) NOT NULL,
    COUNTRY NOT NULL VARCHAR(50),
    EMAILADDRESS VARCHAR(120),
    TELEPHONENO VARCHAR(30)
) CLUSTER air_passengers_country(country);

SELECT PLAN_TABLE_OUTPUT 
FROM TABLE(DBMS_XPLAN.DISPLAY());

SELECT
  'create table ' || table_name || ' as select * from ARRUDA.' || table_name || ';'
FROM
  all_tables
WHERE
    owner = 'ARRUDA'
    AND table_name LIKE 'AIR_%';

INSERT INTO AIR_PASSENGERS_DETAILS_CL select * from ARRUDA.AIR_PASSENGERS_DETAILS;

describe AIR_PASSENGERS_DETAILS;

SELECT * FROM AIR_PASSENGERS_DETAILS;

create table AIR_PASSENGERS_DETAILS as select * from ARRUDA.AIR_PASSENGERS_DETAILS;

drop table air_passengers_details;
