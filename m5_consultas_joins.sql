USE Ventas_Tech_DB;

-- CONSULTA 1: Vista base del proyecto (INNER JOIN) --
-- Propósito: incluir en una sola tabla las ventas con la información descriptiva del cliente y producto, para contar con todo el detalle de la venta unificado. -- 

SELECT 
v.fecha_venta, v.id_venta, 
v.id_cliente, cl.nombre, cl.ciudad,
v.id_producto, p.nombre_producto, p.id_categoria,
ca.nombre_categoria,
v.cantidad, 
v.precio_unitario,
v.cantidad*v.precio_unitario AS total_venta
FROM ventas AS v
JOIN clientes AS cl ON v.id_cliente = cl.id_cliente 
JOIN productos AS p ON v.id_producto = p.id_producto
JOIN categorias AS ca ON p.id_categoria = ca.id_categoria;

-- Hallazgo: Se realizaron 10 ventas en el periodo y todas ellas tienen identificado el cliente, producto y categoría. --



-- CONSULTA 2: Clientes sin ventas (LEFT JOIN) --
-- Propósito: aislar en una tabla los clientes que aún no registran ventas, para realizar campañas de contacto a los mismos. -- 

SELECT 
cl. id_cliente, cl.nombre, cl.email, cl.ciudad, cl.fecha_registro
FROM clientes AS cl 
LEFT JOIN ventas AS v ON cl.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: no existen clientes registrados sin realizar compras. No apareció ningún registro. Esto implica eficiencia en CRM. --



-- CONSULTA 3: Productos sin ventas (LEFT JOIN) -- 
-- Propósito: identificar productos del catálogo que aún no se hayan vendido, para evaluar publicidad apuntando a esos productos críticos. -- 

SELECT 
p.id_producto, p.nombre_producto, p.id_categoria, p.precio
FROM productos AS p 
LEFT JOIN ventas AS v ON p.id_producto = v.id_producto
LEFT JOIN categorias AS ca ON p.id_categoria = ca.id_categoria
WHERE v.id_venta IS NULL; 

-- Hallazgo: no existen productos en el catálogo que aún no se hayan vendido. No apareció ningún registro. No hay productos críticos. --



-- Consulta 4: Consolidado por canal (UNION ALL) -- 
-- Propósito: totalizar la venta de la primera y segunda quincena del mes de Marzo y compararlas. -- 

SELECT
canal, SUM(total_venta) AS total_canal
FROM (
    SELECT
        'Primer quincena' AS canal,
        cantidad * precio_unitario AS total_venta
FROM ventas
WHERE fecha_venta >= '2024-03-01' AND fecha_venta < '2024-03-15'
UNION ALL
SELECT
'Segunda quincena' AS canal,
cantidad * precio_unitario AS total_venta
FROM ventas
WHERE fecha_venta >= '2024-03-15' AND fecha_venta < '2024-03-31'
) AS ventas_por_quincena
GROUP BY canal;

-- Hallazgo: la primer quincena totalizó una venta de $ 5.544, mientras que durante la segunda quincena se vendieron $ 900. --