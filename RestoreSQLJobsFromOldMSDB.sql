begin tran

select [name] into #MissingJobs from msdb_old.dbo.sysjobs
where [name] not in (select [name] from msdb.dbo.sysjobs)

WHILE EXISTS (SELECT top 1 * from #missingjobs)
BEGIN

	DECLARE @JobName as varchar(300)

	SELECT top 1 @JobName = [name] from #MissingJobs

	PRINT 'Attempting to restore job: ' + @JobName

	DECLARE @JobID UNIQUEIDENTIFIER
	SELECT @JobID = job_id FROM msdb_old.dbo.sysjobs WHERE NAME=@JobName

	DECLARE @servername sysname
	SET @servername = @@SERVERNAME

	INSERT msdb.dbo.sysjobs
	SELECT * FROM msdb_old.dbo.sysjobs
	WHERE job_id=@JobID

	INSERT msdb.dbo.sysjobsteps
	SELECT * FROM msdb_old.dbo.sysjobsteps
	WHERE job_id=@JobID

	SET IDENTITY_INSERT msdb.dbo.sysjobhistory ON
	INSERT msdb.dbo.sysjobhistory
		(instance_id,job_id,step_id,step_name,sql_message_id,sql_severity,
		 [message],run_status,run_date,run_time,run_duration,operator_id_emailed,
		 operator_id_netsent,operator_id_paged,retries_attempted,[server])
	SELECT
		instance_id,job_id,step_id,step_name,sql_message_id,sql_severity,
		[message],run_status,run_date,run_time,run_duration,operator_id_emailed,
		operator_id_netsent,operator_id_paged,retries_attempted,[server]
	FROM msdb_old.dbo.sysjobhistory
	WHERE job_id=@JobID
	SET IDENTITY_INSERT msdb.dbo.sysjobhistory OFF

	SET IDENTITY_INSERT msdb.dbo.sysschedules ON
	INSERT msdb.dbo.sysschedules (schedule_id, schedule_uid,
			 originating_server_id, name, owner_sid, enabled,
			 freq_type,freq_interval, freq_subday_type,
			 freq_subday_interval, freq_relative_interval,
			 freq_recurrence_factor, active_start_date, 
			 active_end_date, active_start_time, active_end_time,
			 date_created, date_modified, version_number)
	SELECT schedule_id, schedule_uid, originating_server_id, name,
		   owner_sid, enabled, freq_type, freq_interval, freq_subday_type,
		   freq_subday_interval, freq_relative_interval,
		   freq_recurrence_factor, active_start_date, active_end_date,
		   active_start_time, active_end_time, date_created, date_modified,
		   version_number 
	FROM msdb_old.dbo.sysschedules a
	WHERE schedule_id = (select schedule_id from msdb_old.dbo.sysjobschedules b where job_id=@JobID )
	SET IDENTITY_INSERT msdb.dbo.sysschedules OFF


	INSERT msdb.dbo.sysjobschedules
	SELECT * FROM msdb_old.dbo.sysjobschedules
	WHERE job_id=@JobID


	EXEC msdb.dbo.sp_add_jobserver @job_id=@JobID, @server_name = @servername

	select * from msdb.dbo.sysjobs where name = @JobName

	DELETE FROM #MissingJobs where [name] = @JobName
END

drop table #MissingJobs

--rollback tran
commit tran
									  

