/*
    Listar o número do voo, o nome do aeroporto de saída e o nome do aeroporto de destino, 
    o nome completo (primeiro e último nome) e o assento de cada passageiro, 
    para todos os voos que partem no dia do seu aniversário neste ano 
    (caso a consulta não retorne nenhuma linha, 
    faça para o dia subsequente até encontrar uma data que retorne alguma linha). 
*/

    SELECT
        f.FLIGHTNO AS FLIGHT_NUMBER,
        airport_to.NAME AS AIRPORT_TO,
        airport_from.NAME AS AIRPORT_FROM,
        p.FIRSTNAME || ' ' || p.LASTNAME AS FULLNAME,
        b.SEAT,
        f.DEPARTURE
    FROM 
        ARRUDA.AIR_FLIGHTS f 
        JOIN ARRUDA.AIR_AIRPORTS airport_to ON airport_to.AIRPORT_ID = f.TO_AIRPORT_ID
        JOIN ARRUDA.AIR_AIRPORTS airport_from ON airport_from.AIRPORT_ID = f.FROM_AIRPORT_ID
        JOIN ARRUDA.AIR_BOOKINGS b ON b.FLIGHT_ID = f.FLIGHT_ID
        JOIN ARRUDA.AIR_PASSENGERS p ON p.PASSENGER_ID = b.PASSENGER_ID
    WHERE 
        f.DEPARTURE BETWEEN TRUNC(TO_DATE('2023-03-25', 'YYYY-MM-DD')) AND (TRUNC(TO_DATE('2023-03-26', 'YYYY-MM-DD'))-(1/(24*60*60)));