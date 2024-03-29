SELECT  SUM(p.rows) AS QuantidadeDeItens, SUM(a.total_pages) * 8 / 1024 AS TamanhoTotalMB, SUM(a.used_pages) * 8 / 1024 AS TamanhoUsadoMB, (SUM(a.total_pages) - SUM(a.used_pages)) * 8 / 1024 AS TamanhoNaoUsadoMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.NAME NOT LIKE 'dt%'
AND t.is_ms_shipped = 0
AND i.OBJECT_ID > 255