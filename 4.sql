/*
Listar o nome da companhia aérea bem como a data e a hora de saída de todos os voos 
que chegam para a cidade de 'NEW YORK' que partem às terças, quartas ou quintas-feiras, 
no mês do seu aniversário  (caso a consulta não retorne nenhuma linha, faça para o mês subsequente 
até encontrar um mês que retorne alguma linha). 
[resposta sugerida = 1 linha para o mês de março de 2023]
*/

-- SELECT 
--     airlines.AIRLINE_NAME,
--     afs.MONDAY,
--     afs.ARRIVAL,
--     afs.DEPARTURE,
--     f.ARRIVAL,
--     f.DEPARTURE,
--     airgeo.CITY
-- FROM 
--     ARRUDA.AIR_AIRLINES airlines 
--     JOIN ARRUDA.AIR_AIRPLANES airplanes ON airplanes.AIRLINE_ID = airlines.AIRLINE_ID
--     JOIN ARRUDA.AIR_FLIGHTS f ON f.AIRPLANE_ID = airplanes.AIRPLANE_ID
--     JOIN ARRUDA.AIR_AIRPORTS airports ON airports.AIRPORT_ID = f.TO_AIRPORT_ID --verificar essa condicao
--     JOIN ARRUDA.AIR_AIRPORTS_GEO airgeo ON airgeo.AIRPORT_ID = airports.AIRPORT_ID
--     JOIN ARRUDA.AIR_FLIGHTS_SCHEDULES afs ON afs.FLIGHTNO = f.FLIGHTNO
-- WHERE
    -- f.ARRIVAL BETWEEN TRUNC(TO_DATE('2023-03-01', 'YYYY-MM-DD')) AND LAST_DAY(TO_DATE('2023-03-01', 'YYYY-MM-DD'))
    -- AND (
    -- afs.TUESDAY = 1
    -- OR
    -- afs.WEDNESDAY = 1
    -- OR  
    -- afs.THURSDAY = 1
    -- ) AND 
    -- airgeo.CITY = 'NEW YORK'
    -- ;


SELECT 
    airlines.AIRLINE_NAME,
    afs.MONDAY,
    afs.ARRIVAL,
    afs.DEPARTURE,
    f.ARRIVAL,
    f.DEPARTURE,
    airgeo.CITY
FROM 
    ARRUDA.AIR_FLIGHTS_SCHEDULES afs 
    JOIN ARRUDA.AIR_AIRLINES airlines ON airlines.AIRLINE_ID = afs.AIRLINE_ID
    JOIN ARRUDA.AIR_FLIGHTS f ON f.FLIGHTNO = afs.FLIGHTNO
    JOIN ARRUDA.AIR_AIRPORTS airports ON airports.AIRPORT_ID = f.TO_AIRPORT_ID  
    JOIN ARRUDA.AIR_AIRPORTS_GEO airgeo ON airgeo.AIRPORT_ID = airports.AIRPORT_ID
    JOIN ARRUDA.AIR_FLIGHTS_SCHEDULES afs ON afs.FLIGHTNO = f.FLIGHTNO
WHERE
    f.ARRIVAL BETWEEN TRUNC(TO_DATE('2023-03-01', 'YYYY-MM-DD')) AND LAST_DAY(TO_DATE('2023-03-01', 'YYYY-MM-DD'))
    AND (
    afs.TUESDAY = 1
    OR
    afs.WEDNESDAY = 1
    OR  
    afs.THURSDAY = 1
    ) AND 
    airgeo.CITY = 'NEW YORK'
    ;


-- duvida: flights schedules o valor de departure e arrive eh sempre o mesmo