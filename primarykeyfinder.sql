select schema_name(tab.schema_id) as [schema_name]
    ,tab.[name] as table_name 
    ,pk.[name] as pk_name
    ,substring(column_names, 1, len(column_names)-1) as [columns]
	,ident_current(tab.[name]) as CurrentSeed
	,t.name as 'Type'
from sys.tables tab
    left outer join sys.indexes pk
        on tab.object_id = pk.object_id 
        and pk.is_primary_key = 1
   cross apply (select col.[name] + ', '
                    from sys.index_columns ic
                        inner join sys.columns col
                            on ic.object_id = col.object_id
                            and ic.column_id = col.column_id
                    where ic.object_id = tab.object_id
                        and ic.index_id = pk.index_id
                            order by col.column_id
                            for xml path ('') ) D (column_names)
	LEFT OUTER JOIN sys.index_columns ic ON ic.object_id = pk.object_id --AND ic.column_id = c.column_id
	left outer join sys.columns c on c.object_id = pk.object_id and c.column_id = ic.column_id
	left outer join sys.types t on t.user_type_id = c.user_type_id
order by schema_name(tab.schema_id),
    tab.[name]