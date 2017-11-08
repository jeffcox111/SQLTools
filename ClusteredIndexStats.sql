SELECT
    t.name as 'TableName'
	,c.Name as 'ColumnName'
	,i.name as 'ClusteredIndexName'
	,i.fill_factor as 'FillFactor'
	,round(ips.avg_fragmentation_in_percent , 2, 2) as 'Fragemenation'
	,ips.page_count as 'PageCount'
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.index_columns ic ON i.index_id = ic.index_id AND i.object_id = ic.object_id
JOIN sys.columns c ON ic.column_id = c.column_id AND ic.object_id = c.object_id
JOIN sys.types ty on ty.system_type_id = c.system_type_id
JOIN sys.dm_db_index_physical_stats(db_id(), null, null, null, null) ips on ips.object_id = i.object_id
WHERE i.index_id = 1  -- clustered index
	--and ty.system_type_id = 36 --guid 