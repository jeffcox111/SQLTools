USE [JiraExt]
GO

/****** Object:  Table [dbo].[WorkLogs]    Script Date: 9/4/2018 4:25:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WorkLogs](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ImportedTimeStamp] [datetime2](7) NOT NULL CONSTRAINT [DF_WorkLog_ImportedTimeStamp]  DEFAULT (getdate()),
	[TimeStamp] [datetime2](7) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Project] [varchar](20) NULL,
	[Comment] [varchar](1000) NULL,
	[Seconds] [int] NOT NULL,
 CONSTRAINT [PK_LogEntries] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


