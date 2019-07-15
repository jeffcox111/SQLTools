ALTER DATABASE DataWarehouse
SET SINGLE_USER WITH
ROLLBACK immediate

ALTER DATABASE DataWarehouse
SET multi_user WITH
ROLLBACK immediate


RESTORE FILELISTONLY FROM DISK='c:\data\DataWarehouse_backup_2017_03_28_060010_9263139.bak'
RESTORE DATABASE DataWarehouse FROM DISK='c:\data\DataWarehouse_backup_2017_03_28_060010_9263139.bak'
WITH 
   MOVE 'DataWarehouse' TO 'F:\SQLData\DataWarehouse.mdf',
   MOVE 'DataWarehouse_log' TO 'F:\SQLLog\DataWarehouse.ldf',
   REPLACE
