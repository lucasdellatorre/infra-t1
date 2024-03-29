/*
    Listar o nome completo (primeiro nome + último nome), 
    a idade e a cidade de todos os passageiros do sexo feminino (sex='w') 
    com mais de 40 anos, residentes no país 'BRAZIL'.
*/

SELECT
    ap.FIRSTNAME || ' ' || ap.LASTNAME  as FULLNAME,
    apd.BIRTHDATE,
    apd.CITY
FROM
    ARRUDA.AIR_PASSENGERS ap
    JOIN ARRUDA.AIR_PASSENGERS_DETAILS apd ON apd.PASSENGER_ID = ap.PASSENGER_ID
WHERE
    SEX = 'w'
    AND 
    TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTHDATE)/12,0) > 40
    AND
    COUNTRY = 'BRAZIL';