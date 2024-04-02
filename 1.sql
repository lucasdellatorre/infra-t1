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

CREATE INDEX sex_idx ON AIR_PASSENGERS_DETAILS(sex);
CREATE INDEX country_idx ON AIR_PASSENGERS_DETAILS(country);
CREATE INDEX bday_idx ON AIR_PASSENGERS_DETAILS(birthdate);

SELECT PLAN_TABLE_OUTPUT 
FROM TABLE(DBMS_XPLAN.DISPLAY());
