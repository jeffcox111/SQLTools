--Server stats
CREATE TABLE #sp_who2 (SPID INT,Status VARCHAR(255),
      Login  VARCHAR(255),HostName  VARCHAR(255), 
      BlkBy  VARCHAR(255),DBName  VARCHAR(255), 
      Command VARCHAR(255),CPUTime BIGINT, 
      DiskIO INT,LastBatch VARCHAR(255), 
      ProgramName VARCHAR(255),SPID2 INT, 
      REQUESTID INT) 
INSERT INTO #sp_who2 EXEC sp_who2

SELECT COUNT(1) AS Connections
	   ,SUM(diskio) AS TotalDiskIO
	   ,SUM(cputime) as TotalCPUTime
	   ,(SELECT COUNT(1) FROM #sp_who2 WHERE BlkBy <> '  .') as Blocked
	   
FROM #sp_who2
DROP TABLE #sp_who2


--failed jobs
select j.name
    ,js.step_name
    ,jh.sql_severity
    ,jh.message
    ,jh.run_date
    ,jh.run_time
FROM msdb.dbo.sysjobs AS j
INNER JOIN msdb.dbo.sysjobsteps AS js ON js.job_id = j.job_id
INNER JOIN msdb.dbo.sysjobhistory AS jh ON jh.job_id = j.job_id 
WHERE jh.run_status = 0


--Orphaned users THAT MATCH SQL LOGINS
CREATE TABLE ##ORPHANUSER 
( 
DBNAME VARCHAR(100), 
USERNAME VARCHAR(100)
) 
 
EXEC SP_MSFOREACHDB' USE [?] 
INSERT INTO ##ORPHANUSER 
SELECT db_name(), UserName = name
FROM sysusers
WHERE issqluser = 1
	AND (sid IS NOT NULL
	AND sid <> 0x0)
	AND SUSER_SNAME(sid) IS NULL
	AND name in (select name from master.sys.server_principals where type = ''S'')
ORDER BY name' 
SELECT * FROM ##ORPHANUSER  
DROP TABLE ##ORPHANUSER;

--Orphaned users THAT DON'T MATCH UP WITH SQL LOGINS
CREATE TABLE ##ORPHANUSER_WithoutMatch
( 
DBNAME VARCHAR(100), 
USERNAME VARCHAR(100), 
CREATEDATE VARCHAR(100), 
USERTYPE VARCHAR(100) 
) 
 
EXEC SP_MSFOREACHDB' USE [?] 
INSERT INTO ##ORPHANUSER_WithoutMatch 
SELECT DB_NAME() DBNAME, NAME,CREATEDATE, 
(CASE  
WHEN ISNTGROUP = 0 AND ISNTUSER = 0 THEN ''SQL LOGIN'' 
WHEN ISNTGROUP = 1 THEN ''NT GROUP'' 
WHEN ISNTGROUP = 0 AND ISNTUSER = 1 THEN ''NT LOGIN'' 
END) [LOGIN TYPE] FROM sys.sysusers 
WHERE SID IS NOT NULL AND SID <> 0X0 AND ISLOGIN =1 AND 
SID NOT IN (SELECT SID FROM sys.syslogins)' 
SELECT * FROM ##ORPHANUSER_WithoutMatch 
DROP TABLE ##ORPHANUSER_WithoutMatch 
