/*
    Listar o nome da companhia aérea, o identificador da aeronave, o nome do tipo de aeronave 
    e o número de todos os voos operados por essa companhia aérea 
    (independentemente de a aeronave ser de sua propriedade) 
    que saem E chegam em aeroportos localizados no país 'BRAZIL'. 
*/

SELECT 
    airlines.AIRLINE_NAME,
    airplanes.AIRPLANE_ID,
    airplanest.NAME as AIRPLANE_NAME_TYPE,
    airflights.FLIGHTNO as FLIGHT_NUMBER
FROM
    ARRUDA.AIR_AIRLINES airlines    
    JOIN ARRUDA.AIR_AIRPLANES airplanes ON airplanes.AIRLINE_ID = airlines.AIRLINE_ID
    JOIN ARRUDA.AIR_AIRPLANE_TYPES airplanest ON airplanest.AIRPLANE_TYPE_ID = airplanes.AIRPLANE_TYPE_ID
    JOIN ARRUDA.AIR_FLIGHTS airflights ON airflights.AIRPLANE_ID = airplanes.AIRPLANE_ID
    JOIN ARRUDA.AIR_AIRPORTS airports ON ((airports.AIRPORT_ID = airflights.FROM_AIRPORT_ID) or (airports.AIRPORT_ID = airflights.TO_AIRPORT_ID))
    JOIN ARRUDA.AIR_AIRPORTS_GEO airportsgeo ON airportsgeo.AIRPORT_ID = airports.AIRPORT_ID
WHERE
    airportsgeo.COUNTRY = 'BRAZIL';



