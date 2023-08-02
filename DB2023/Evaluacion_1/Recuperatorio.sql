USE VIVERO_FENIX;

--Encuentra todos los clientes que han comprado todas las plantas disponibles en stock

SELECT
    C.COD_CLIENTE,
    C.APELLIDO,
    C.NOMBRE
FROM CLIENTES AS C
WHERE NOT EXISTS (
        SELECT P.COD_PLANTA
        FROM PLANTAS AS P
        WHERE
            P.STOCK > 0
            AND EXISTS (
                SELECT
                    DF.COD_DETALLE
                FROM
                    DETALLES_FACTURAS AS DF
                    INNER JOIN FACTURAS F ON DF.NRO_FACTURA = F.NRO_FACTURA
                WHERE
                    DF.COD_PLANTA = P.COD_PLANTA
                    AND F.COD_CLIENTE = C.COD_CLIENTE
            )
    );

--Encuentra todos los clientes que hayan realizado al menos dos facturas en el mismo día,
--pero cada factura debe tener una planta distinta.
--Mostrar el nombre del cliente y el numero de factura y planta de ambas facturas

SELECT
    C.NOMBRE,
    F1.NRO_FACTURA AS FACTURA_1,
    P1.COD_PLANTA AS PLANTA_1,
    F2.NRO_FACTURA AS FACTURA_2,
    P2.COD_PLANTA AS PLANTA_2
FROM CLIENTES AS C
    INNER JOIN FACTURAS AS F1 ON C.COD_CLIENTE = F1.COD_CLIENTE
    INNER JOIN DETALLES_FACTURAS AS DF1 ON F1.NRO_FACTURA = DF1.NRO_FACTURA
    INNER JOIN PLANTAS AS P1 ON DF1.COD_PLANTA = P1.COD_PLANTA
    INNER JOIN FACTURAS AS F2 ON C.COD_CLIENTE = F2.COD_CLIENTE
    INNER JOIN DETALLES_FACTURAS AS DF2 ON F2.NRO_FACTURA = DF2.NRO_FACTURA
    INNER JOIN PLANTAS AS P2 ON DF2.COD_PLANTA = P2.COD_PLANTA
WHERE
    F1.FECHA = F2.FECHA
    AND F1.NRO_FACTURA <> F2.NRO_FACTURA
    AND P1.COD_PLANTA <> P2.COD_PLANTA;

--Encuentra el nombre y apellido de los clientes que hayan comprado todas las plantas disponibles en stock,
--y además, muestra el precio máximo y mínimo de esas plantas.
--También, concatena los nombres de todas las plantas junto
--con la forma en la que fueron pagadas en una sola cadena separada por comas.

SELECT
    C.COD_CLIENTE,
    C.APELLIDO,
    C.NOMBRE,
    P1.COD_PLANTA
FROM CLIENTES AS C
    INNER JOIN PLANTAS AS P1 ON P1.COD_PLANTA
WHERE NOT EXISTS (
        SELECT P1.COD_PLANTA
        FROM PLANTAS AS P1
        WHERE
            P1.STOCK > 0
            AND EXISTS (
                SELECT
                    DF.COD_DETALLE
                FROM
                    DETALLES_FACTURAS AS DF
                    INNER JOIN FACTURAS F ON DF.NRO_FACTURA = F.NRO_FACTURA
                WHERE
                    DF.COD_PLANTA = P1.COD_PLANTA
                    AND F.COD_CLIENTE = C.COD_CLIENTE
            )
    )
    AND NOT EXISTS(
        SELECT *
        FROM PLANTAS as P2
        WHERE
            P1.PRECIO < P2.PRECIO
    )
    AND NOT EXISTS(
        SELECT *
        FROM PLANTAS as P2
        WHERE
            P1.PRECIO > P2.PRECIO
    );

--Aca hace falta un group concat pero no me acuerdo como hacerlo xd