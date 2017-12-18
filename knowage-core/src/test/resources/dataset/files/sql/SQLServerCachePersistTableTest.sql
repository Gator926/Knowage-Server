CREATE TABLE [dbo].[cachepersisttest](
	[colbigint] [bigint] NULL,
	[colbinary] [binary](50) NULL,
	[colbit] [bit] NULL,
	[colchar] [char](10) NULL,
	[coldate] [date] NULL,
	[coldatetime] [datetime] NULL,
	[coldatetime2] [datetime2](7) NULL,
	[coldecimal] [decimal](18, 0) NULL,
	[colfloat] [float] NULL,
	[colimage] [image] NULL,
	[colint] [int] NULL,
	[colmoney] [money] NULL,
	[colnchar] [nchar](10) NULL,
	[colntext] [ntext] NULL,
	[colnumeric] [numeric](18, 0) NULL,
	[colnvarchar] [nvarchar](50) NULL,
	[colreal] [real] NULL,
	[colsmalldatetime] [smalldatetime] NULL,
	[colsmallint] [smallint] NULL,
	[colsmallmoney] [smallmoney] NULL,
	[coltext] [text] NULL,
	[coltime] [time](7) NULL,
	[coltimestamp] [timestamp] NULL,
	[coltinyint] [tinyint] NULL,
	[coluniqueidentifier] [uniqueidentifier] NULL,
	[colvarbinary] [varbinary](50) NULL,
	[colvarchar] [varchar](50) NULL
);
INSERT [dbo].[cachepersisttest] ([colbigint], [colbinary], [colbit], [colchar], [coldate], [coldatetime], [coldatetime2], [coldecimal], [colfloat], [colimage], [colint], [colmoney], [colnchar], [colntext], [colnumeric], [colnvarchar], [colreal], [colsmalldatetime], [colsmallint], [colsmallmoney], [coltext], [coltime], [coltinyint], [coluniqueidentifier], [colvarbinary], [colvarchar]) VALUES (1, 0x0101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, 1, N'c         ', CAST(N'2016-03-24' AS Date), CAST(N'2016-03-24 17:10:19.370' AS DateTime), CAST(N'2016-03-24 17:10:19.3700000' AS DateTime2), CAST(1 AS Decimal(18, 0)), 1, 0x010101, 1, 1.0000, N'nchar     ', N'text', CAST(1 AS Numeric(18, 0)), N'nvarchar', 1, CAST(N'2016-03-24 17:10:00' AS SmallDateTime), 1, 1.0000, N'text', CAST(N'17:10:19.3700000' AS Time), 1, N'00010101-0000-0000-0000-000000000000', 0x010101, N'varchar');
