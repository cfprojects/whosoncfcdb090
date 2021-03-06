CREATE TABLE [dbo].[ActiveUsers] (
	[ClientID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[UserID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Roles] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Created] [datetime] NOT NULL ,
	[LastUpdated] [datetime] NOT NULL ,
	[Referer] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[IP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HostName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HideClient] [bit] NOT NULL ,
	[Coords] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Country] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntryPage] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CurrentPage] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PageHits] [numeric](18, 0) NOT NULL ,
	[UserAgent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ServerName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PageHistory] (
	[ClientID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Page] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LoadTime] [datetime] NOT NULL 
) ON [PRIMARY]
GO

