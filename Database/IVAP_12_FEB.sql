--USE [master]
--GO
--/****** Object:  Database [IVAP]    Script Date: 12-02-2019 21:00:09 ******/
--CREATE DATABASE [IVAP]
-- CONTAINMENT = NONE
-- ON  PRIMARY 
--( NAME = N'IVAP', FILENAME = N'D:\DATABASE\IVAP.mdf' , SIZE = 103424KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
-- LOG ON 
--( NAME = N'IVAP_log', FILENAME = N'D:\DATABASE\IVAP_log.ldf' , SIZE = 353216KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO
--ALTER DATABASE [IVAP] SET COMPATIBILITY_LEVEL = 120
--GO
--IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
--begin
--EXEC [IVAP].[dbo].[sp_fulltext_database] @action = 'enable'
--end
--GO
--ALTER DATABASE [IVAP] SET ANSI_NULL_DEFAULT OFF 
--GO
--ALTER DATABASE [IVAP] SET ANSI_NULLS OFF 
--GO
--ALTER DATABASE [IVAP] SET ANSI_PADDING OFF 
--GO
--ALTER DATABASE [IVAP] SET ANSI_WARNINGS OFF 
--GO
--ALTER DATABASE [IVAP] SET ARITHABORT OFF 
--GO
--ALTER DATABASE [IVAP] SET AUTO_CLOSE OFF 
--GO
--ALTER DATABASE [IVAP] SET AUTO_SHRINK OFF 
--GO
--ALTER DATABASE [IVAP] SET AUTO_UPDATE_STATISTICS ON 
--GO
--ALTER DATABASE [IVAP] SET CURSOR_CLOSE_ON_COMMIT OFF 
--GO
--ALTER DATABASE [IVAP] SET CURSOR_DEFAULT  GLOBAL 
--GO
--ALTER DATABASE [IVAP] SET CONCAT_NULL_YIELDS_NULL OFF 
--GO
--ALTER DATABASE [IVAP] SET NUMERIC_ROUNDABORT OFF 
--GO
--ALTER DATABASE [IVAP] SET QUOTED_IDENTIFIER OFF 
--GO
--ALTER DATABASE [IVAP] SET RECURSIVE_TRIGGERS OFF 
--GO
--ALTER DATABASE [IVAP] SET  DISABLE_BROKER 
--GO
--ALTER DATABASE [IVAP] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
--GO
--ALTER DATABASE [IVAP] SET DATE_CORRELATION_OPTIMIZATION OFF 
--GO
--ALTER DATABASE [IVAP] SET TRUSTWORTHY OFF 
--GO
--ALTER DATABASE [IVAP] SET ALLOW_SNAPSHOT_ISOLATION OFF 
--GO
--ALTER DATABASE [IVAP] SET PARAMETERIZATION SIMPLE 
--GO
--ALTER DATABASE [IVAP] SET READ_COMMITTED_SNAPSHOT OFF 
--GO
--ALTER DATABASE [IVAP] SET HONOR_BROKER_PRIORITY OFF 
--GO
--ALTER DATABASE [IVAP] SET RECOVERY FULL 
--GO
--ALTER DATABASE [IVAP] SET  MULTI_USER 
--GO
--ALTER DATABASE [IVAP] SET PAGE_VERIFY CHECKSUM  
--GO
--ALTER DATABASE [IVAP] SET DB_CHAINING OFF 
--GO
--ALTER DATABASE [IVAP] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
--GO
--ALTER DATABASE [IVAP] SET TARGET_RECOVERY_TIME = 0 SECONDS 
--GO
--ALTER DATABASE [IVAP] SET DELAYED_DURABILITY = DISABLED 
--GO
--USE [IVAP]
--GO
--/****** Object:  User [IVAP]    Script Date: 12-02-2019 21:00:09 ******/
--CREATE USER [IVAP] FOR LOGIN [IVAP] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [IVAP]
--GO
--ALTER ROLE [db_securityadmin] ADD MEMBER [IVAP]
--GO
--ALTER ROLE [db_ddladmin] ADD MEMBER [IVAP]
--GO
--/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 12-02-2019 21:00:09 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

use ivap2

 CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END
GO
/****** Object:  Table [dbo].[dbo.IVAP_HIS_LWF]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dbo.IVAP_HIS_LWF](
	[HISID] [int] NOT NULL,
	[LWFID] [int] NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[LOCATION_ID] [int] NOT NULL,
	[PERIOD_FLAG] [nchar](20) NOT NULL,
	[DED_MONTH] [nchar](20) NOT NULL,
	[LWF_EMPLOYEE] [nchar](20) NOT NULL,
	[LWF_EMPLOYER] [nchar](20) NOT NULL,
	[CREATED_ON] [nchar](20) NOT NULL,
	[CREATED_BY] [nchar](20) NOT NULL,
	[UPDATED_ON] [nchar](20) NOT NULL,
	[UPDATED_BY] [nchar](20) NOT NULL,
	[ISACT] [int] NOT NULL,
	[ACTION] [nchar](10) NOT NULL,
 CONSTRAINT [PK_dbo.IVAP_HIS_LWF] PRIMARY KEY CLUSTERED 
(
	[HISID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_CALENDAR_SETUP]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_CALENDAR_SETUP](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[CALENDAR_TYPE] [int] NULL,
	[FILE_TYPE] [varchar](50) NULL,
	[CALENDAR_NAME] [varchar](200) NULL,
	[DESCRIPTION] [varchar](500) NULL,
	[PAY_DATE] [datetime] NULL,
	[DUE_DATE] [datetime] NULL,
	[REMAINDER_DAYS] [int] NULL,
	[EVENT] [varchar](200) NULL,
	[FREQUENCY] [varchar](100) NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [bit] NOT NULL,
 CONSTRAINT [PK_IVAP_CALENDAR_SETUP] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_CONFIG_SMTP]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_CONFIG_SMTP](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[PASSWORD] [varchar](200) NULL,
	[PORT] [varchar](200) NULL,
	[HOST] [varchar](200) NULL,
	[USERNAME] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_DATA_ACCESS_DTL]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_DATA_ACCESS_DTL](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NULL,
	[TABLE_NAME] [varchar](100) NULL,
	[TIDS] [varchar](max) NULL,
	[CREATED_BY] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[ISACTIVE] [char](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_BANK]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_BANK](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[BANKID] [int] NULL,
	[ENTITY_ID] [int] NOT NULL,
	[BANK_CODE] [varchar](30) NULL,
	[BANK_NAME] [varchar](200) NOT NULL,
	[BANK_ADDR] [varchar](500) NOT NULL,
	[BANK_CITY] [varchar](50) NOT NULL,
	[BANK_STATE] [int] NOT NULL,
	[BANK_PIN] [varchar](10) NOT NULL,
	[BANK_PHONE] [varchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](50) NULL,
	[GLOBAL_BANK_ID] [int] NULL,
 CONSTRAINT [PK_IVAP_HIS_BANK] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_CALENDAR_SETUP]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_CALENDAR_SETUP](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CALENDARID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[CALENDAR_TYPE] [int] NULL,
	[FILE_TYPE] [varchar](50) NULL,
	[CALENDAR_NAME] [varchar](200) NULL,
	[DESCRIPTION] [varchar](500) NULL,
	[PAY_DATE] [datetime] NULL,
	[DUE_DATE] [datetime] NULL,
	[REMAINDER_DAYS] [int] NULL,
	[EVENT] [varchar](200) NULL,
	[FREQUENCY] [varchar](100) NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [bit] NOT NULL,
	[ACTION] [varchar](50) NULL,
 CONSTRAINT [PK_IVAP_HIS_CALENDAR_SETUP] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_CLASS]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_CLASS](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_CLASS_CODE] [varchar](10) NOT NULL,
	[ERP_CLASS_CODE] [varchar](10) NOT NULL,
	[CLASS_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_COMPANY]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_COMPANY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[COMPID] [int] NOT NULL,
	[EID] [int] NULL,
	[COMP_CODE] [varchar](20) NULL,
	[COMP_NAME] [varchar](200) NULL,
	[COMP_ADDR1] [varchar](500) NULL,
	[COMP_ADDR2] [varchar](500) NULL,
	[COMP_CITY] [varchar](200) NULL,
	[COMP_STATE] [int] NULL,
	[COMP_PIN] [varchar](10) NULL,
	[COMP_CLASS] [int] NULL,
	[COMP_PANNO] [varchar](10) NULL,
	[COMP_TANNO] [varchar](20) NULL,
	[COMP_TDSCIRCLE] [varchar](50) NULL,
	[SIGN_FNAME] [varchar](200) NULL,
	[SIGN_LNAME] [varchar](200) NULL,
	[SIGN_FATHER_NAME] [varchar](200) NULL,
	[SIGN_ADDR1] [varchar](500) NULL,
	[SIGN_ADDR2] [varchar](500) NULL,
	[SIGN_CITY] [varchar](200) NULL,
	[SIGN_DSG] [varchar](50) NULL,
	[SIGN_STATE] [int] NULL,
	[SIGN_PIN] [varchar](10) NULL,
	[SIGN_PLACE] [varchar](50) NULL,
	[SIGN_DATE] [datetime] NULL,
	[RETIRE_AGE] [numeric](10, 2) NULL,
	[EMP_CODE_GEN] [varchar](1) NULL,
	[EMP_CODE_PREFIX] [varchar](10) NULL,
	[EMP_CODE_LEN] [int] NULL,
	[Comp_Logo] [varchar](200) NULL,
	[COMP_URL] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](50) NULL,
 CONSTRAINT [PK_IVAP_HIS_COMPANY] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_COMPONENT]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_COMPONENT](
	[HID] [int] IDENTITY(1,1) NOT NULL,
	[COMPONENT_ID] [int] NULL,
	[COMPONENT_FILE_TYPE] [varchar](20) NULL,
	[COMPONENT_TYPE] [varchar](20) NULL,
	[COMPONENT_SUB_TYPE] [varchar](20) NULL,
	[COMPONENT_NAME] [varchar](20) NULL,
	[COMPONENT_DATATYPE] [varchar](20) NULL,
	[COMPONENT_DISPLAY_NAME] [varchar](20) NULL,
	[COMPONENT_DESCRIPTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[MIN_LENGTH] [int] NULL,
	[MAX_LENGTH] [int] NULL,
	[MANDATORY] [int] NULL,
	[ACTION] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_COMPONENT_ENTITY]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_COMPONENT_ENTITY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CompEntityID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[COMPONENT_FILE_TYPE] [varchar](20) NULL,
	[COMPONENT_TYPE] [varchar](20) NULL,
	[COMPONENT_SUB_TYPE] [varchar](20) NULL,
	[COMPONENT_NAME] [varchar](20) NULL,
	[COMPONENT_DATATYPE] [varchar](20) NULL,
	[COMPONENT_TABLE_NAME] [varchar](20) NULL,
	[COMPONENT_COLUMN_NAME] [varchar](20) NULL,
	[COMPONENT_DISPLAY_NAME] [varchar](20) NULL,
	[COMPONENT_DESCRIPTION] [varchar](200) NULL,
	[MIN_LENGTH] [int] NULL,
	[MAX_LENGTH] [int] NULL,
	[MANDATORY] [int] NULL,
	[HAS_RULE] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[Globle_Component_ID] [int] NULL,
	[ACTION] [varchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_COSTCENTRE]    Script Date: 12-02-2019 21:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_COSTCENTRE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[COSTCENID] [int] NOT NULL,
	[ENTITY_ID] [int] NULL,
	[PAY_COST_CODE] [varchar](10) NULL,
	[ERP_COST_CODE] [varchar](10) NULL,
	[COST_NAME] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](50) NULL,
 CONSTRAINT [PK_IVAP_HIS_COSTCENTER] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_CURRENCY]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_CURRENCY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CID] [int] NOT NULL,
	[CURRENCY_CODE] [varchar](10) NOT NULL,
	[CURRENCY_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_DEPARTMENT]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_DEPARTMENT](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[DEPTID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_DEPT_CODE] [varchar](10) NOT NULL,
	[ERP_DEPT_CODE] [varchar](10) NOT NULL,
	[DEPT_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](50) NULL,
 CONSTRAINT [PK_IVAP_HIS_DEPARTMENT] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_DESIGNATION]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_DESIGNATION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[DESGID] [int] NOT NULL,
	[ENTITY_ID] [int] NULL,
	[PAY_DSG_CODE] [varchar](10) NULL,
	[ERP_DSG_CODE] [varchar](10) NULL,
	[DSG_NAME] [varchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](20) NULL,
 CONSTRAINT [PK_IVAP_HIS_DESIGNATION] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_DIVISION]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_DIVISION](
	[HISID] [int] IDENTITY(1,1) NOT NULL,
	[DIVIID] [int] NOT NULL,
	[ENTITY_ID] [int] NULL,
	[PAY_DIVI_CODE] [varchar](10) NULL,
	[ERP_DIVI_CODE] [varchar](10) NULL,
	[DIVI_NAME] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](20) NULL,
 CONSTRAINT [PK_IVAP_HIS_DIVISION] PRIMARY KEY CLUSTERED 
(
	[HISID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_FUNCTION]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_FUNCTION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FUNCTIONID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[PAY_FUNC_CODE] [varchar](10) NULL,
	[ERP_FUNC_CODE] [varchar](10) NULL,
	[FUNC_NAME] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_GRADE]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_GRADE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[GRAD_ID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[PAY_GRADE_CODE] [varchar](10) NULL,
	[ERP_GRADE_CODE] [varchar](10) NULL,
	[GARDE_NAME] [varchar](100) NULL,
	[GRADE_SCALE_FROM] [numeric](10, 2) NULL,
	[GRADE_SCALE_TO] [numeric](10, 2) NULL,
	[GRADE_MIDPOINT] [numeric](10, 2) NULL,
	[Prob_Period] [numeric](10, 2) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_LEAVING_REASON]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_LEAVING_REASON](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[LEAID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_LEAVING_CODE] [varchar](10) NOT NULL,
	[ERP_LEAVING_CODE] [varchar](10) NOT NULL,
	[VOL/NON_VOL] [varchar](200) NOT NULL,
	[REASON] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_LEVEL]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_LEVEL](
	[HISID] [int] IDENTITY(1,1) NOT NULL,
	[LEVELID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_LEVEL_CODE] [varchar](10) NOT NULL,
	[ERP_LEVEL_CODE] [varchar](10) NOT NULL,
	[LEVEL_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](20) NULL,
 CONSTRAINT [PK_IVAP_HIS_LEVEL] PRIMARY KEY CLUSTERED 
(
	[HISID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_LOCATION]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_LOCATION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[LOC_ID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_LOC_CODE] [varchar](10) NOT NULL,
	[ERP_LOC_CODE] [varchar](10) NOT NULL,
	[LOC_NAME] [varchar](200) NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[ISMETRO] [int] NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](20) NOT NULL,
	[PARENT_LOC_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_LOCATION_GLOBAL]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_LOCATION_GLOBAL](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[LID] [int] NOT NULL,
	[LOC_CODE] [varchar](10) NOT NULL,
	[LOC_NAME] [varchar](200) NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[ISMETRO] [int] NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_LWF]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_LWF](
	[HISID] [int] IDENTITY(1,1) NOT NULL,
	[LWFID] [int] NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[LOCATION_ID] [int] NULL,
	[PERIOD_FLAG] [varchar](10) NOT NULL,
	[DED_MONTH] [int] NOT NULL,
	[LWF_EMPLOYEE] [numeric](10, 2) NOT NULL,
	[LWF_EMPLOYER] [numeric](10, 2) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [bit] NULL,
	[ACTION] [varchar](20) NULL,
	[EFF_FROM_DT] [datetime] NULL,
	[EFF_TO_DT] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_MINWAGE]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_MINWAGE](
	[HISID] [int] IDENTITY(1,1) NOT NULL,
	[MINWAGEID] [int] NOT NULL,
	[STATE_ID] [int] NULL,
	[LOCATION_ID] [int] NULL,
	[CATEGORY] [varchar](100) NULL,
	[MIN_WAGE] [numeric](10, 2) NULL,
	[EFF_DT_FROM] [date] NULL,
	[EFF_DATE_TO] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](20) NULL,
 CONSTRAINT [PK_IVAP_HIS_MINWAGE] PRIMARY KEY CLUSTERED 
(
	[HISID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_MONTH_CLOSE]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_MONTH_CLOSE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[MONTH_CLOSE_ID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[MONTH] [int] NULL,
	[YEAR] [int] NULL,
	[OPEN_DATE] [datetime] NULL,
	[CLOSED_DATE] [datetime] NULL,
	[STATUS] [varchar](20) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACT] [bit] NOT NULL,
	[ACTION] [varchar](20) NOT NULL,
 CONSTRAINT [PK_IVAP_HIS_MONTH_CLOSE] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_PASSWORD]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_PASSWORD](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[PASSWORD] [varchar](500) NOT NULL,
	[CREATED_ON] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_PLANT]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_PLANT](
	[HISID] [int] IDENTITY(1,1) NOT NULL,
	[PLANTID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_PLANT_CODE] [varchar](10) NOT NULL,
	[ERP_PLANT_CODE] [varchar](10) NOT NULL,
	[PLANT_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](20) NULL,
 CONSTRAINT [PK_IVAP_HIS_PLANT] PRIMARY KEY CLUSTERED 
(
	[HISID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_PROCESS]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_PROCESS](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[PROC_ID] [int] NULL,
	[COMP_ID] [int] NOT NULL,
	[PAY_PROC_CODE] [varchar](10) NOT NULL,
	[ERP_PROC_CODE] [varchar](10) NOT NULL,
	[PROC_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_PTAX]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_PTAX](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[PTAXID] [int] NULL,
	[STATE_ID] [int] NULL,
	[PERIOD_FLAG] [varchar](10) NULL,
	[DED_MONTH] [int] NULL,
	[YTD_MONTH_FROM] [int] NULL,
	[YTD_MONTH_TO] [int] NULL,
	[PT_SAL_FROM] [numeric](10, 2) NULL,
	[PT_SAL_TO] [numeric](10, 2) NULL,
	[GENDER] [varchar](10) NULL,
	[PTAX] [numeric](10, 2) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](20) NULL,
	[EFF_FROM_DT] [datetime] NULL,
	[EFF_TO_DT] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_REGION]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_REGION](
	[HISID] [int] IDENTITY(1,1) NOT NULL,
	[RegionID] [int] NOT NULL,
	[ENTITY_ID] [int] NULL,
	[PAY_REGION_CODE] [varchar](10) NULL,
	[ERP_REGION_CODE] [varchar](10) NULL,
	[REGION_NAME] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](20) NULL,
 CONSTRAINT [PK_IVAP_HIS_REGION] PRIMARY KEY CLUSTERED 
(
	[HISID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_SECTION]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_SECTION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[SECTID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[PAY_SECTION_CODE] [varchar](10) NULL,
	[ERP_SECTION_CODE] [varchar](10) NULL,
	[SECTION_NAME] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_STATE]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_STATE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[SID] [int] NOT NULL,
	[STATE_CODE] [varchar](10) NOT NULL,
	[STATE_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](20) NOT NULL,
	[COUNTRY] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_SUB_FUNCTION]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_SUB_FUNCTION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[SID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_SUB_FUNC_CODE] [varchar](10) NOT NULL,
	[ERP_SUB_FUNC_CODE] [varchar](10) NOT NULL,
	[SUB_FUNC_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[PARENT_FUNC_ID] [int] NOT NULL,
	[ACTION] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_TYPE]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_TYPE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[TYID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_TYPE_CODE] [varchar](10) NOT NULL,
	[ERP_TYPE_CODE] [varchar](10) NOT NULL,
	[TYPE_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ACTION] [varchar](200) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_USER]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_USER](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[ENTITY_ID] [int] NULL,
	[USERID] [varchar](20) NULL,
	[USER_FIRSTNAME] [varchar](50) NULL,
	[USER_LASTNAME] [varchar](50) NULL,
	[USER_EMAIL] [varchar](100) NULL,
	[USER_ROLE] [int] NULL,
	[USER_MOBILENO] [varchar](20) NULL,
	[PASSWORD] [varchar](2000) NULL,
	[PASSWORD_LAST_UPDATED] [datetime] NULL,
	[ISAUTH] [int] NULL,
	[ISACT] [char](1) NULL,
	[CREATED_BY] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[PASSWORD_TRY] [int] NULL,
	[USERTYPE] [varchar](20) NULL,
	[PROFILE_PIC] [varchar](max) NULL,
	[LAST_PASSWORD_TRY_DATE] [datetime] NULL,
	[Action] [varchar](20) NULL,
 CONSTRAINT [PK_IVAP_HIS_USER] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_USERROLE]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_USERROLE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ROLE_ID] [int] NOT NULL,
	[ROLENAME] [varchar](20) NULL,
	[ROLETYPE] [varchar](20) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACT] [int] NULL,
	[ACTION] [varchar](50) NULL,
 CONSTRAINT [PK_IVAP_HIS_USERROLE] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_WorkFlowSetting]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_WorkFlowSetting](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WFSID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[FILE_ID] [int] NOT NULL,
	[USER_ROLE] [int] NOT NULL,
	[ORDERING] [int] NOT NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](50) NULL,
 CONSTRAINT [PK_IVAP_HIS_WorkFlowSetting] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_1]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_1](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOJ] [datetime] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_14]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_14](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[MADDR1] [nvarchar](50) NULL,
	[MCITY] [nvarchar](50) NULL,
	[MSTATE] [nvarchar](50) NULL,
	[COST_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[CHILD] [int] NULL,
	[DOB] [datetime] NULL,
	[DOL_COMP] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GROSSPKG] [numeric](16, 2) NULL,
	[HOLIDAYS] [numeric](16, 2) NULL,
	[STATUS] [nvarchar](10) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[EPS] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPFNO] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_15]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_15](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[COMP_CODE] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DIVI_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[LOC_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[BLOODGRP] [nvarchar](50) NULL,
	[CAR_CC_VALUE] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOJ_COMP] [datetime] NULL,
	[DOL] [datetime] NULL,
	[DOL_COMP] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
	[LWOP] [numeric](16, 2) NULL,
	[MNAME] [nvarchar](50) NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[PAYDATE] [datetime] NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[EPS] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPF] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_24]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_24](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[METRO] [nvarchar](50) NULL,
	[MPIN] [nvarchar](50) NULL,
	[COMP_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[CATEGORY] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOJ_COMP] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[HOLIDAYS] [numeric](16, 2) NULL,
	[LAST_PROM] [datetime] NULL,
	[LNOTICE] [datetime] NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[EPF] [numeric](16, 2) NULL,
	[ESI_CODE] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPFNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_27]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_27](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRADENAME] [int] NULL,
	[LOC_NAME] [int] NULL,
	[TYPE_CODE] [int] NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMPBANKNAME] [nvarchar](200) NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
	[MNAME] [nvarchar](50) NULL,
	[MOBILENO] [nvarchar](50) NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[SET_DATE] [datetime] NULL,
	[STATUS] [nvarchar](10) NULL,
	[STATUSCODE] [nvarchar](10) NULL,
	[TRNDATE] [datetime] NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_28]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_28](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[COMP_NAME] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[TYPE_CODE] [int] NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[LTYPE] [nvarchar](50) NULL,
	[MSTATUS] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[LOC_NAME] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_29]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_29](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_30]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_30](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[METRO] [nvarchar](50) NULL,
	[COMP_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[CATEGORY] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOC] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[HOLIDAYS] [numeric](16, 2) NULL,
	[MOBILENO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[ESI_CODE] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[GRAT_YN] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_5]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_5](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[COMP_CODE] [int] NULL,
	[DIVI_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[CATEGORY] [nvarchar](50) NULL,
	[DOC] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_7]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_7](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[METRO] [nvarchar](50) NULL,
	[PPIN] [nvarchar](50) NULL,
	[COST_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[CAR_CC_VALUE] [int] NULL,
	[CHILD] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ_COMP] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMPBANKNAME] [nvarchar](200) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[ESI_CODE] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_1]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_1](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOJ] [datetime] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_14]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_14](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[MADDR1] [nvarchar](50) NULL,
	[MCITY] [nvarchar](50) NULL,
	[MSTATE] [nvarchar](50) NULL,
	[COST_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[CHILD] [int] NULL,
	[DOB] [datetime] NULL,
	[DOL_COMP] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GROSSPKG] [numeric](16, 2) NULL,
	[HOLIDAYS] [numeric](16, 2) NULL,
	[STATUS] [nvarchar](10) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[EPS] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPFNO] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_15]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_15](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[COMP_CODE] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DIVI_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[LOC_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[BLOODGRP] [nvarchar](50) NULL,
	[CAR_CC_VALUE] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOJ_COMP] [datetime] NULL,
	[DOL] [datetime] NULL,
	[DOL_COMP] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
	[LWOP] [numeric](16, 2) NULL,
	[MNAME] [nvarchar](50) NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[PAYDATE] [datetime] NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[EPS] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPF] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_24]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_24](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[METRO] [nvarchar](50) NULL,
	[MPIN] [nvarchar](50) NULL,
	[COMP_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[CATEGORY] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOJ_COMP] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[HOLIDAYS] [numeric](16, 2) NULL,
	[LAST_PROM] [datetime] NULL,
	[LNOTICE] [datetime] NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[EPF] [numeric](16, 2) NULL,
	[ESI_CODE] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPFNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_27]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_27](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRADENAME] [int] NULL,
	[LOC_NAME] [int] NULL,
	[TYPE_CODE] [int] NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMPBANKNAME] [nvarchar](200) NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
	[MNAME] [nvarchar](50) NULL,
	[MOBILENO] [nvarchar](50) NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[SET_DATE] [datetime] NULL,
	[STATUS] [nvarchar](10) NULL,
	[STATUSCODE] [nvarchar](10) NULL,
	[TRNDATE] [datetime] NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_28]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_28](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[COMP_NAME] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[TYPE_CODE] [int] NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[LTYPE] [nvarchar](50) NULL,
	[MSTATUS] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[LOC_NAME] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_29]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_29](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_30]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_30](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[METRO] [nvarchar](50) NULL,
	[COMP_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[CATEGORY] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOC] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[HOLIDAYS] [numeric](16, 2) NULL,
	[MOBILENO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[ESI_CODE] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[GRAT_YN] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_5]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_5](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[COMP_CODE] [int] NULL,
	[DIVI_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[CATEGORY] [nvarchar](50) NULL,
	[DOC] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_7]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_7](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[METRO] [nvarchar](50) NULL,
	[PPIN] [nvarchar](50) NULL,
	[COST_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANK_NAME] [nvarchar](100) NULL,
	[CAR_CC_VALUE] [int] NULL,
	[CHILD] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ_COMP] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMPBANKNAME] [nvarchar](200) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[ESI_CODE] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_LOG_ERROR]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_LOG_ERROR](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NULL,
	[CONTROLLER_NAME] [varchar](200) NULL,
	[ACTION_NAME] [varchar](200) NULL,
	[ERROR] [varchar](500) NULL,
	[CREATED_DATE] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_LOGIN_LOG]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_LOGIN_LOG](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NULL,
	[LOGIN_TIME] [datetime] NULL,
	[LOGOUT_TIME] [datetime] NULL,
	[IP_ADDRESS] [varchar](200) NULL,
	[MAC_ADDRESS] [varchar](200) NULL,
	[SESSION_ID] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_1]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_1](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[SAL_ADVANCE] [varchar](max) NULL,
	[YTD_LOAN] [varchar](max) NULL,
	[CONVEYANCE] [varchar](max) NULL,
	[DEPT_CODE] [varchar](max) NULL,
	[GRD_CODE] [varchar](max) NULL,
	[BANK_CODE] [varchar](max) NULL,
	[BANKACNO] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[FNAME] [varchar](max) NULL,
	[LNAME] [varchar](max) NULL,
	[YTD_SAL_ADVANCE] [varchar](max) NULL,
	[YTD_CONVEYANCE] [varchar](max) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[paydate] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_14]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_14](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[MADDR1] [varchar](max) NULL,
	[MCITY] [varchar](max) NULL,
	[MSTATE] [varchar](max) NULL,
	[LOAN] [varchar](max) NULL,
	[CTC_PF] [varchar](max) NULL,
	[MEAL] [varchar](max) NULL,
	[OTHDED] [varchar](max) NULL,
	[PTAX] [varchar](max) NULL,
	[MEDICLAIM] [varchar](max) NULL,
	[EPF_WAGE] [varchar](max) NULL,
	[NOTPAY] [varchar](max) NULL,
	[ARR_OTHALL] [varchar](max) NULL,
	[ARR_SFTALL] [varchar](max) NULL,
	[ARR_SPALL] [varchar](max) NULL,
	[ARR_TELE] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[DA] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[PAYDAYS] [varchar](max) NULL,
	[EMPLOYER_ESIC] [varchar](max) NULL,
	[COST_CODE] [varchar](max) NULL,
	[DSG_CODE] [varchar](max) NULL,
	[BANK_NAME] [varchar](max) NULL,
	[BANKACNO] [varchar](max) NULL,
	[CHILD] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOL_COMP] [varchar](max) NULL,
	[EMAILID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[FNAME] [varchar](max) NULL,
	[GROSSPKG] [varchar](max) NULL,
	[HOLIDAYS] [varchar](max) NULL,
	[STATUS] [varchar](max) NULL,
	[AADHAARNO] [varchar](max) NULL,
	[EPF] [varchar](max) NULL,
	[EPS] [varchar](max) NULL,
	[ESINO] [varchar](max) NULL,
	[FPFNO] [varchar](max) NULL,
	[PANNO] [varchar](max) NULL,
	[PFNO] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_15]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_15](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[SAL_ADVANCE] [varchar](max) NULL,
	[CTC_PF] [varchar](max) NULL,
	[GRATUITY] [varchar](max) NULL,
	[OTHDED] [varchar](max) NULL,
	[BONUS] [varchar](max) NULL,
	[LVNCAS] [varchar](max) NULL,
	[CTC] [varchar](max) NULL,
	[HOLDAMT] [varchar](max) NULL,
	[JOINING_BONUS] [varchar](max) NULL,
	[NOTPAY] [varchar](max) NULL,
	[ARR_BASIC] [varchar](max) NULL,
	[ARR_CCA] [varchar](max) NULL,
	[ARR_CONV] [varchar](max) NULL,
	[ARR_DAYS] [varchar](max) NULL,
	[ARR_HRA] [varchar](max) NULL,
	[ARR_MEALALL] [varchar](max) NULL,
	[ARR_OTHALL] [varchar](max) NULL,
	[ARR_SFTALL] [varchar](max) NULL,
	[ARR_SPALL] [varchar](max) NULL,
	[ARR_TELE] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[CONVEYANCE] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[PAYDAYS] [varchar](max) NULL,
	[SFTALL] [varchar](max) NULL,
	[SPL_ALLOWANCE] [varchar](max) NULL,
	[BPRIM] [varchar](max) NULL,
	[CCA] [varchar](max) NULL,
	[DRV_RIM] [varchar](max) NULL,
	[FODRIM] [varchar](max) NULL,
	[LTA_RIM] [varchar](max) NULL,
	[MEDRIM] [varchar](max) NULL,
	[MELRIM] [varchar](max) NULL,
	[OTHRIM] [varchar](max) NULL,
	[TELEPHONE] [varchar](max) NULL,
	[TELRIM] [varchar](max) NULL,
	[STABON] [varchar](max) NULL,
	[COMP_CODE] [varchar](max) NULL,
	[COST_CODE] [varchar](max) NULL,
	[DEPT_CODE] [varchar](max) NULL,
	[DIVI_CODE] [varchar](max) NULL,
	[DSG_CODE] [varchar](max) NULL,
	[GRD_CODE] [varchar](max) NULL,
	[LOC_CODE] [varchar](max) NULL,
	[PAY_EMP_CODE] [varchar](max) NULL,
	[BANK_CODE] [varchar](max) NULL,
	[BANK_NAME] [varchar](max) NULL,
	[BANKACNO] [varchar](max) NULL,
	[BLOODGRP] [varchar](max) NULL,
	[CAR_CC_VALUE] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOJ_COMP] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[DOL_COMP] [varchar](max) NULL,
	[DOR] [varchar](max) NULL,
	[EFFDATE] [varchar](max) NULL,
	[EMAILID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[F_H_NAME] [varchar](max) NULL,
	[FNAME] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[LNAME] [varchar](max) NULL,
	[LWOP] [varchar](max) NULL,
	[MNAME] [varchar](max) NULL,
	[NEFT_CODE] [varchar](max) NULL,
	[PAYDATE] [varchar](max) NULL,
	[AADHAARNO] [varchar](max) NULL,
	[EPF] [varchar](max) NULL,
	[EPS] [varchar](max) NULL,
	[ESINO] [varchar](max) NULL,
	[FPF] [varchar](max) NULL,
	[PANNO] [varchar](max) NULL,
	[PFNO] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_24]    Script Date: 12-02-2019 21:00:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_24](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[METRO] [varchar](max) NULL,
	[MPIN] [varchar](max) NULL,
	[LOAN] [varchar](max) NULL,
	[BUS] [varchar](max) NULL,
	[CANTEEN] [varchar](max) NULL,
	[CTC_PF] [varchar](max) NULL,
	[EMPLOYEE_ESIC] [varchar](max) NULL,
	[EMPLOYEE_PF] [varchar](max) NULL,
	[ITAX] [varchar](max) NULL,
	[LWF] [varchar](max) NULL,
	[BONUS] [varchar](max) NULL,
	[ADMIN_WAGE] [varchar](max) NULL,
	[EPF_WAGE] [varchar](max) NULL,
	[ESIC_WAGE] [varchar](max) NULL,
	[CTC] [varchar](max) NULL,
	[JOINING_BONUS] [varchar](max) NULL,
	[NOTPAY] [varchar](max) NULL,
	[ARR_DAYS] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[CONVEYANCE] [varchar](max) NULL,
	[DA] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[CCA] [varchar](max) NULL,
	[DRIVER] [varchar](max) NULL,
	[EMPLOYER_ESIC] [varchar](max) NULL,
	[NPS] [varchar](max) NULL,
	[COMP_CODE] [varchar](max) NULL,
	[DEPT_CODE] [varchar](max) NULL,
	[GRD_CODE] [varchar](max) NULL,
	[BANK_CODE] [varchar](max) NULL,
	[CATEGORY] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOJ_COMP] [varchar](max) NULL,
	[DOR] [varchar](max) NULL,
	[EMAILID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[FNAME] [varchar](max) NULL,
	[HOLIDAYS] [varchar](max) NULL,
	[LAST_PROM] [varchar](max) NULL,
	[LNOTICE] [varchar](max) NULL,
	[NEFT_CODE] [varchar](max) NULL,
	[EPF] [varchar](max) NULL,
	[ESI_CODE] [varchar](max) NULL,
	[ESINO] [varchar](max) NULL,
	[FPFNO] [varchar](max) NULL,
	[PFNO] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_27]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_27](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[JOINING_BONUS] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[CONVEYANCE] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[COST_CODE] [varchar](max) NULL,
	[DEPT_CODE] [varchar](max) NULL,
	[DSG_CODE] [varchar](max) NULL,
	[GRADENAME] [varchar](max) NULL,
	[LOC_NAME] [varchar](max) NULL,
	[TYPE_CODE] [varchar](max) NULL,
	[BANK_NAME] [varchar](max) NULL,
	[BANKACNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[DOR] [varchar](max) NULL,
	[EFFDATE] [varchar](max) NULL,
	[EMAILID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMPBANKNAME] [varchar](max) NULL,
	[F_H_NAME] [varchar](max) NULL,
	[FNAME] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[LNAME] [varchar](max) NULL,
	[MNAME] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[NEFT_CODE] [varchar](max) NULL,
	[SET_DATE] [varchar](max) NULL,
	[STATUS] [varchar](max) NULL,
	[STATUSCODE] [varchar](max) NULL,
	[TRNDATE] [varchar](max) NULL,
	[AADHAARNO] [varchar](max) NULL,
	[ESINO] [varchar](max) NULL,
	[PANNO] [varchar](max) NULL,
	[PFNO] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[BONUS] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_28]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_28](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COMP_NAME] [varchar](max) NULL,
	[COST_CODE] [varchar](max) NULL,
	[DEPT_CODE] [varchar](max) NULL,
	[DSG_CODE] [varchar](max) NULL,
	[TYPE_CODE] [varchar](max) NULL,
	[BANK_NAME] [varchar](max) NULL,
	[BANKACNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[EMAILID] [varchar](max) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[IFSC_CODE] [varchar](max) NULL,
	[LTYPE] [varchar](max) NULL,
	[MSTATUS] [varchar](max) NULL,
	[EPF] [varchar](max) NULL,
	[PANNO] [varchar](max) NULL,
	[PFNO] [varchar](max) NULL,
	[GRATUITY] [varchar](max) NULL,
	[INDEPENDENT_SURVEYOR] [varchar](max) NULL,
	[PROVIDENT_FUND] [varchar](max) NULL,
	[CTC] [varchar](max) NULL,
	[LEAVETRAVEL_ALLOWANC] [varchar](max) NULL,
	[OTHER_TRAVELALLOWANC] [varchar](max) NULL,
	[TRANSPORT_ALLOWANCE] [varchar](max) NULL,
	[TRAVEL_OTHEXPS] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[CAR_FUELALLOWANCE] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[MEDICAL_ALLOWANCE] [varchar](max) NULL,
	[SPL_ALLOWANCE] [varchar](max) NULL,
	[SUBSISTENCE_ALLOWANC] [varchar](max) NULL,
	[SUPERANNUATION] [varchar](max) NULL,
	[MELRIM] [varchar](max) NULL,
	[OTHRIM] [varchar](max) NULL,
	[TELRIM] [varchar](max) NULL,
	[LOC_NAME] [nvarchar](50) NULL,
	[PAYDATE] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_29]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_29](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[PAYDATE] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[AMOUNT] [varchar](max) NULL,
	[FIELD_NAME] [varchar](max) NULL,
	[REMARKS] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_30]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_30](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[METRO] [varchar](max) NULL,
	[CANTEEN] [varchar](max) NULL,
	[GRATUITY] [varchar](max) NULL,
	[OTHDED] [varchar](max) NULL,
	[EMPLOYEE_ESIC] [varchar](max) NULL,
	[EMPLOYEE_PF] [varchar](max) NULL,
	[PTAX] [varchar](max) NULL,
	[BONUS] [varchar](max) NULL,
	[MEDICLAIM] [varchar](max) NULL,
	[EPF_WAGE] [varchar](max) NULL,
	[FPF_WAGE] [varchar](max) NULL,
	[CTC] [varchar](max) NULL,
	[HOLDAMT] [varchar](max) NULL,
	[NOTPAY] [varchar](max) NULL,
	[ARR_BASIC] [varchar](max) NULL,
	[ARR_CCA] [varchar](max) NULL,
	[ARR_OTHALL] [varchar](max) NULL,
	[ARR_SPALL] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[CONVEYANCE] [varchar](max) NULL,
	[DA] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[DRIVER] [varchar](max) NULL,
	[EMPLOYER_ESIC] [varchar](max) NULL,
	[EMPLOYER_PF] [varchar](max) NULL,
	[STABON] [varchar](max) NULL,
	[COMP_CODE] [varchar](max) NULL,
	[DSG_CODE] [varchar](max) NULL,
	[BANK_CODE] [varchar](max) NULL,
	[BANK_NAME] [varchar](max) NULL,
	[CATEGORY] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOC] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[EFFDATE] [varchar](max) NULL,
	[EMAILID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[FNAME] [varchar](max) NULL,
	[HOLIDAYS] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[EPF] [varchar](max) NULL,
	[ESI_CODE] [varchar](max) NULL,
	[ESINO] [varchar](max) NULL,
	[GRAT_YN] [varchar](max) NULL,
	[PFNO] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[AMOUNT] [varchar](max) NULL,
	[COMPONENT] [varchar](max) NULL,
	[paydate] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_5]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_5](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[BUS] [nvarchar](50) NULL,
	[CTC_PF] [nvarchar](10) NULL,
	[EMPLOYEE_ESIC] [nvarchar](50) NULL,
	[BONUS] [nvarchar](10) NULL,
	[ADMIN_WAGE] [nvarchar](50) NULL,
	[ARR_CONV] [nvarchar](10) NULL,
	[ARR_DAYS] [nvarchar](2) NULL,
	[ARR_TELE] [nvarchar](10) NULL,
	[BASIC] [nvarchar](50) NULL,
	[DA] [nvarchar](50) NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_7]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_7](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[PAY_DATE] [date] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[METRO] [varchar](max) NULL,
	[PPIN] [varchar](max) NULL,
	[LOAN] [varchar](max) NULL,
	[BUS] [varchar](max) NULL,
	[CANTEEN] [varchar](max) NULL,
	[CTC_PF] [varchar](max) NULL,
	[GRATUITY] [varchar](max) NULL,
	[MEAL] [varchar](max) NULL,
	[OTHDED] [varchar](max) NULL,
	[EMPLOYEE_PF] [varchar](max) NULL,
	[LWF] [varchar](max) NULL,
	[PTAX] [varchar](max) NULL,
	[BONUS] [varchar](max) NULL,
	[EPF_WAGE] [varchar](max) NULL,
	[PTAX_WAGE] [varchar](max) NULL,
	[CTC] [varchar](max) NULL,
	[HOLDAMT] [varchar](max) NULL,
	[JOINING_BONUS] [varchar](max) NULL,
	[NOTPAY] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[CONVEYANCE] [varchar](max) NULL,
	[DA] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[DRIVER] [varchar](max) NULL,
	[MELRIM] [varchar](max) NULL,
	[EMPLOYER_ESIC] [varchar](max) NULL,
	[EMPLOYER_PF] [varchar](max) NULL,
	[NPS] [varchar](max) NULL,
	[COST_CODE] [varchar](max) NULL,
	[PAY_EMP_CODE] [varchar](max) NULL,
	[BANK_CODE] [varchar](max) NULL,
	[BANK_NAME] [varchar](max) NULL,
	[CAR_CC_VALUE] [varchar](max) NULL,
	[CHILD] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ_COMP] [varchar](max) NULL,
	[DOR] [varchar](max) NULL,
	[EFFDATE] [varchar](max) NULL,
	[EMAILID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMPBANKNAME] [varchar](max) NULL,
	[FNAME] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[AADHAARNO] [varchar](max) NULL,
	[EPF] [varchar](max) NULL,
	[ESI_CODE] [varchar](max) NULL,
	[ESINO] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[COMPONENT] [varchar](max) NULL,
	[YTD_BASIC] [varchar](max) NULL,
	[YTD_CONVEYANCE] [varchar](max) NULL,
	[YTD_MEAL] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_META_MASTER]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_META_MASTER](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[SCREEN_NAME] [varchar](100) NOT NULL,
	[DISPLAY_NAME] [varchar](100) NOT NULL,
	[FIELD_NAME] [varchar](100) NOT NULL,
	[DISPLAY_ORDER] [int] NULL,
	[TABLE_NAME] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_META_MASTER_DEFAULT]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_META_MASTER_DEFAULT](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[SCREEN_NAME] [varchar](100) NOT NULL,
	[DISPLAY_NAME] [varchar](100) NOT NULL,
	[FIELD_NAME] [varchar](100) NOT NULL,
	[DISPLAY_ORDER] [int] NULL,
	[TABLE_NAME] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MONTH_CLOSE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MONTH_CLOSE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[MONTH] [int] NULL,
	[YEAR] [int] NULL,
	[OPEN_DATE] [datetime] NULL,
	[CLOSED_DATE] [datetime] NULL,
	[STATUS] [varchar](20) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACT] [bit] NOT NULL,
 CONSTRAINT [PK_IVAP_MONTH_CLOSE] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_BANK]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_BANK](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[BANK_CODE] [varchar](10) NULL,
	[BANK_NAME] [varchar](200) NOT NULL,
	[BANK_ADDR] [varchar](500) NOT NULL,
	[BANK_CITY] [varchar](50) NOT NULL,
	[BANK_STATE] [int] NOT NULL,
	[BANK_PIN] [varchar](10) NOT NULL,
	[BANK_PHONE] [varchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[ERP_BANK_CODE] [varchar](20) NULL,
	[PAY_BANK_CODE] [varchar](20) NULL,
	[IFSC] [varchar](20) NULL,
	[GLOBAL_BANK_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_BANK_GLOBAL]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_BANK_GLOBAL](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[BANK_NAME] [varchar](200) NOT NULL,
	[IFSC] [varchar](20) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_CALENDAR_TYPE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_CALENDAR_TYPE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [bit] NOT NULL,
 CONSTRAINT [PK_IVAP_MST_CALENDAR_TYPE] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_CLASS]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_CLASS](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_CLASS_CODE] [varchar](10) NOT NULL,
	[ERP_CLASS_CODE] [varchar](10) NOT NULL,
	[CLASS_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_COMPANY]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_COMPANY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NULL,
	[COMP_CODE] [varchar](20) NOT NULL,
	[COMP_NAME] [varchar](200) NOT NULL,
	[COMP_ADDR1] [varchar](500) NOT NULL,
	[COMP_ADDR2] [varchar](500) NULL,
	[COMP_CITY] [varchar](50) NOT NULL,
	[COMP_STATE] [int] NOT NULL,
	[COMP_PIN] [varchar](10) NOT NULL,
	[COMP_CLASS] [varchar](20) NULL,
	[COMP_PANNO] [varchar](10) NULL,
	[COMP_TANNO] [varchar](20) NULL,
	[COMP_TDSCIRCLE] [varchar](50) NULL,
	[SIGN_FNAME] [varchar](200) NULL,
	[SIGN_LNAME] [varchar](200) NULL,
	[SIGN_ADDR1] [varchar](500) NULL,
	[SIGN_ADDR2] [varchar](500) NULL,
	[SIGN_CITY] [varchar](200) NULL,
	[SIGN_DSG] [varchar](50) NULL,
	[SIGN_STATE] [int] NULL,
	[SIGN_PIN] [varchar](10) NULL,
	[SIGN_PLACE] [varchar](50) NULL,
	[SIGN_DATE] [datetime] NULL,
	[RETIRE_AGE] [numeric](10, 2) NULL,
	[EMP_CODE_GEN] [varchar](1) NULL,
	[EMP_CODE_PREFIX] [varchar](10) NULL,
	[EMP_CODE_LEN] [int] NULL,
	[Comp_Logo] [varchar](200) NULL,
	[COMP_URL] [varchar](200) NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[SIGN_FATHER_NAME] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_COMPONENT]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_COMPONENT](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[COMPONENT_FILE_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_SUB_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_NAME] [varchar](20) NOT NULL,
	[COMPONENT_DATATYPE] [varchar](20) NOT NULL,
	[COMPONENT_DISPLAY_NAME] [varchar](20) NOT NULL,
	[COMPONENT_DESCRIPTION] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[MIN_LENGTH] [int] NULL,
	[MAX_LENGTH] [int] NULL,
	[MANDATORY] [int] NULL,
	[COMPONENT_TABLE_NAME] [varchar](50) NULL,
	[COMPONENT_COLUMN_NAME] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_COMPONENT_ENTITY]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_COMPONENT_ENTITY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[COMPONENT_FILE_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_SUB_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_NAME] [varchar](20) NOT NULL,
	[COMPONENT_DATATYPE] [varchar](20) NOT NULL,
	[COMPONENT_TABLE_NAME] [varchar](20) NULL,
	[COMPONENT_COLUMN_NAME] [varchar](20) NULL,
	[COMPONENT_DISPLAY_NAME] [varchar](20) NOT NULL,
	[COMPONENT_DESCRIPTION] [varchar](200) NOT NULL,
	[MIN_LENGTH] [int] NOT NULL,
	[MAX_LENGTH] [int] NOT NULL,
	[MANDATORY] [int] NOT NULL,
	[HAS_RULE] [int] NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[Globle_Component_ID] [int] NULL,
	[GL_Code] [varchar](100) NULL,
	[PMS_CODE] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_COSTCENTRE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_COSTCENTRE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_COST_CODE] [varchar](10) NOT NULL,
	[ERP_COST_CODE] [varchar](10) NOT NULL,
	[COST_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_COUNTRY]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_COUNTRY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[COUNTRY_CODE] [varchar](10) NOT NULL,
	[COUNTRY_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_CURRENCY]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_CURRENCY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CURRENCY_CODE] [varchar](10) NOT NULL,
	[CURRENCY_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_DEFAULT_MENU]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_DEFAULT_MENU](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](200) NULL,
	[PMENU] [int] NULL,
	[ROLES] [varchar](1000) NULL,
	[DISPLAY_ORDER] [int] NULL,
	[ACTIONS_NAME] [varchar](200) NULL,
	[IMAGE] [varchar](200) NULL,
	[ISACT] [int] NULL,
	[CONTROLLER] [varchar](200) NULL,
	[MENU_TYPE] [varchar](200) NULL,
	[ROUTE] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_DEPARTMENT]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_DEPARTMENT](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_DEPT_CODE] [varchar](10) NOT NULL,
	[ERP_DEPT_CODE] [varchar](10) NOT NULL,
	[DEPT_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_DESIGNATION]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_DESIGNATION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_DSG_CODE] [varchar](10) NOT NULL,
	[ERP_DSG_CODE] [varchar](10) NOT NULL,
	[DSG_NAME] [varchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_DIVISION]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_DIVISION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_DIVI_CODE] [varchar](10) NOT NULL,
	[ERP_DIVI_CODE] [varchar](10) NOT NULL,
	[DIVI_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_ENTITY]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_ENTITY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_CODE] [varchar](20) NOT NULL,
	[ENTITY_NAME] [varchar](200) NOT NULL,
	[ENTITY_ADDR1] [varchar](500) NOT NULL,
	[ENTITY_ADDR2] [varchar](500) NULL,
	[ENTITY_CITY] [varchar](50) NOT NULL,
	[ENTITY_STATE] [int] NOT NULL,
	[ENTITY_PIN] [varchar](10) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[DOMAIN_NAME] [varchar](50) NOT NULL,
	[PAY_PERIOD] [varchar](20) NULL,
	[COUNTRY] [int] NOT NULL,
	[CURRENCY] [int] NOT NULL,
	[DATE_FORMAT] [varchar](20) NULL,
	[Payperiod_Weekly_Fr] [varchar](50) NULL,
	[Payperiod_Weekly_To] [varchar](50) NULL,
	[Payperiod_Monthly_Fr] [int] NULL,
	[Payperiod_Monthly_To] [int] NULL,
	[Payperiod_Fortnightly_Fr1] [int] NULL,
	[Payperiod_Fortnightly_To1] [int] NULL,
	[Payperiod_Fortnightly_Fr2] [int] NULL,
	[Payperiod_Fortnightly_To2] [int] NULL,
	[Services_Availed] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_FILE_COMP_DETAIL]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_FILE_COMP_DETAIL](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NOT NULL,
	[COMPONENT_ID] [int] NOT NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[Display_Order] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[COMPONENT_FILE_TYPE] [nvarchar](50) NULL,
	[COMPONENT_TYPE] [nvarchar](50) NULL,
	[COMPONENT_SUB_TYPE] [nvarchar](50) NULL,
	[COMPONENT_NAME] [nvarchar](50) NULL,
	[COMPONENT_DATATYPE] [nvarchar](50) NULL,
	[COMPONENT_TABLE_NAME] [nvarchar](50) NULL,
	[COMPONENT_COLUMN_NAME] [nvarchar](50) NULL,
	[COMPONENT_DISPLAY_NAME] [nvarchar](50) NULL,
	[COMPONENT_DESCRIPTION] [nvarchar](50) NULL,
	[MIN_LENGTH] [int] NULL,
	[MAX_LENGTH] [int] NULL,
	[MANDATORY] [int] NULL,
	[HAS_RULE] [int] NULL,
	[Globle_Component_ID] [int] NULL,
	[GL_Code] [nvarchar](100) NULL,
	[PMS_CODE] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_Mst_FileExt]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_Mst_FileExt](
	[FileExtID] [int] IDENTITY(1,1) NOT NULL,
	[FileExtension] [varchar](20) NOT NULL,
 CONSTRAINT [PK_IVAP_Mst_FileExt] PRIMARY KEY CLUSTERED 
(
	[FileExtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_FILEEXTENSION]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_FILEEXTENSION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_EXTENSION] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_FILETYPE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_FILETYPE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[FILE_TYPE] [varchar](20) NOT NULL,
	[FILE_NAME] [varchar](50) NOT NULL,
	[FILE_DESC] [varchar](100) NOT NULL,
	[DUE_DATE] [datetime] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[Img_Icon] [nvarchar](200) NULL,
	[FILE_CATEGORY] [varchar](50) NULL,
	[CATEGORY] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_FUNCTION]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_FUNCTION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_FUNC_CODE] [varchar](10) NOT NULL,
	[ERP_FUNC_CODE] [varchar](10) NOT NULL,
	[FUNC_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_GRADE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_GRADE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_GRADE_CODE] [varchar](10) NOT NULL,
	[ERP_GRADE_CODE] [varchar](10) NOT NULL,
	[GARDE_NAME] [varchar](100) NOT NULL,
	[GRADE_SCALE_FROM] [numeric](10, 2) NOT NULL,
	[GRADE_SCALE_TO] [numeric](10, 2) NOT NULL,
	[GRADE_MIDPOINT] [numeric](10, 2) NOT NULL,
	[Prob_Period] [numeric](10, 2) NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_KEYWORD]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_KEYWORD](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[KEYWORD] [varchar](30) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_LEAVING_REASON]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_LEAVING_REASON](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_LEAVING_CODE] [varchar](10) NOT NULL,
	[ERP_LEAVING_CODE] [varchar](10) NOT NULL,
	[VOL/NON_VOL] [varchar](200) NOT NULL,
	[REASON] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_LEVEL]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_LEVEL](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_LEVEL_CODE] [varchar](10) NOT NULL,
	[ERP_LEVEL_CODE] [varchar](10) NOT NULL,
	[LEVEL_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_LOCATION]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_LOCATION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_LOC_CODE] [varchar](10) NOT NULL,
	[ERP_LOC_CODE] [varchar](10) NOT NULL,
	[LOC_NAME] [varchar](200) NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[ISMETRO] [int] NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[PARENT_LOC_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_LOCATION_GLOBAL]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_LOCATION_GLOBAL](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[LOC_CODE] [varchar](10) NOT NULL,
	[LOC_NAME] [varchar](200) NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[ISMETRO] [int] NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_LWF]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_LWF](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[LOCATION_ID] [int] NULL,
	[PERIOD_FLAG] [varchar](10) NOT NULL,
	[DED_MONTH] [int] NOT NULL,
	[LWF_EMPLOYEE] [numeric](10, 2) NOT NULL,
	[LWF_EMPLOYER] [numeric](10, 2) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
	[ACTION] [varchar](20) NULL,
	[EFF_FROM_DT] [datetime] NULL,
	[EFF_TO_DT] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_MAILSETUP]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_MAILSETUP](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[PASSWORD] [varchar](100) NULL,
	[PORT] [int] NULL,
	[HOST] [varchar](100) NULL,
	[USERNAME] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_MENU]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_MENU](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[NAME] [varchar](200) NULL,
	[PMENU] [int] NULL,
	[PAGE_TYPE] [varchar](200) NULL,
	[ROUTE] [varchar](200) NULL,
	[ROLES] [varchar](1000) NULL,
	[DISPLAY_ORDER] [int] NULL,
	[ACTIONS_NAME] [varchar](200) NULL,
	[ISMOBILE] [int] NULL,
	[IMAGE] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACT] [int] NULL,
	[CONTROLLER] [varchar](200) NULL,
	[MENU_TYPE] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_MINWAGE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_MINWAGE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[LOCATION_ID] [int] NULL,
	[CATEGORY] [varchar](100) NOT NULL,
	[MIN_WAGE] [numeric](10, 2) NOT NULL,
	[EFF_DT_FROM] [date] NOT NULL,
	[EFF_DATE_TO] [date] NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NULL,
 CONSTRAINT [PK_IVAP_MST_MINWAGE] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_PASSLINK]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_PASSLINK](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NULL,
	[KEYTYPE] [varchar](50) NULL,
	[RANDOMKEY] [varchar](3000) NULL,
	[CREATEDON] [datetime] NULL,
	[ISUSED] [char](1) NULL,
	[USEDON] [datetime] NULL,
	[USEDBY] [int] NULL,
	[REMARKS] [varchar](2000) NULL,
 CONSTRAINT [PK_IVAP_MST_PASSLINK] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_PLANT]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_PLANT](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_PLANT_CODE] [varchar](10) NOT NULL,
	[ERP_PLANT_CODE] [varchar](10) NOT NULL,
	[PLANT_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_PROCESS]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_PROCESS](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_PROC_CODE] [varchar](10) NOT NULL,
	[ERP_PROC_CODE] [varchar](10) NOT NULL,
	[PROC_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_PTAX]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_PTAX](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[STATE_ID] [int] NOT NULL,
	[LOCATION_ID] [int] NULL,
	[PERIOD_FLAG] [varchar](10) NOT NULL,
	[DED_MONTH] [int] NOT NULL,
	[YTD_MONTH_FROM] [int] NOT NULL,
	[YTD_MONTH_TO] [int] NOT NULL,
	[PT_SAL_FROM] [numeric](10, 2) NOT NULL,
	[PT_SAL_TO] [numeric](10, 2) NOT NULL,
	[GENDER] [varchar](10) NOT NULL,
	[PTAX] [numeric](10, 2) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[EFF_FROM_DT] [datetime] NULL,
	[EFF_TO_DT] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_REGION]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_REGION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_REGION_CODE] [varchar](10) NOT NULL,
	[ERP_REGION_CODE] [varchar](10) NOT NULL,
	[REGION_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_SECTION]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_SECTION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_SECTION_CODE] [varchar](10) NOT NULL,
	[ERP_SECTION_CODE] [varchar](10) NOT NULL,
	[SECTION_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_SERVICE_GLOBAL]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_SERVICE_GLOBAL](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[SERVICE_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_STATE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_STATE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[STATE_CODE] [varchar](10) NOT NULL,
	[STATE_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[COUNTRY] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_SUB_FUNCTION]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_SUB_FUNCTION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_SUB_FUNC_CODE] [varchar](10) NOT NULL,
	[ERP_SUB_FUNC_CODE] [varchar](10) NOT NULL,
	[SUB_FUNC_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[PARENT_FUNC_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_TYPE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_TYPE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_TYPE_CODE] [varchar](10) NOT NULL,
	[ERP_TYPE_CODE] [varchar](10) NOT NULL,
	[TYPE_NAME] [varchar](200) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_USER]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_USER](
	[UID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NULL,
	[USERID] [varchar](20) NULL,
	[USER_FIRSTNAME] [varchar](50) NULL,
	[USER_LASTNAME] [varchar](50) NULL,
	[USER_EMAIL] [varchar](100) NULL,
	[USER_ROLE] [int] NULL,
	[USER_MOBILENO] [varchar](20) NULL,
	[PASSWORD] [varchar](2000) NULL,
	[PASSWORD_LAST_UPDATED] [datetime] NULL,
	[ISAUTH] [int] NULL,
	[ISACT] [char](1) NULL,
	[CREATED_BY] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[PASSWORD_TRY] [int] NULL,
	[USERTYPE] [varchar](20) NULL,
	[PROFILE_PIC] [varchar](max) NULL,
	[LAST_PASSWORD_TRY_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_USERROLE]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_USERROLE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ROLENAME] [varchar](20) NULL,
	[ROLETYPE] [varchar](20) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACT] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_WorkFlowSetting]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_WorkFlowSetting](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[FILE_ID] [int] NOT NULL,
	[USER_ROLE] [int] NOT NULL,
	[ORDERING] [int] NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_1]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_1](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[YTD_LOAN] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[YTD_SAL_ADVANCE] [numeric](16, 2) NULL,
	[YTD_CONVEYANCE] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_14]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_14](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[LOAN] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[MEAL] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[MEDICLAIM] [numeric](16, 2) NULL,
	[EPF_WAGE] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_SFTALL] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[ARR_TELE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDAYS] [int] NULL,
	[EMPLOYER_ESIC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_15]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_15](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[LVNCAS] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[HOLDAMT] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_CCA] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_DAYS] [int] NULL,
	[ARR_HRA] [numeric](16, 2) NULL,
	[ARR_MEALALL] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_SFTALL] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[ARR_TELE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PAYDAYS] [int] NULL,
	[SFTALL] [numeric](16, 2) NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[BPRIM] [numeric](16, 2) NULL,
	[CCA] [numeric](16, 2) NULL,
	[DRV_RIM] [numeric](16, 2) NULL,
	[FODRIM] [numeric](16, 2) NULL,
	[LTA_RIM] [numeric](16, 2) NULL,
	[MEDRIM] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[OTHRIM] [numeric](16, 2) NULL,
	[TELEPHONE] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[STABON] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_24]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_24](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[LOAN] [numeric](16, 2) NULL,
	[BUS] [numeric](16, 2) NULL,
	[CANTEEN] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[EMPLOYEE_ESIC] [numeric](16, 2) NULL,
	[EMPLOYEE_PF] [numeric](16, 2) NULL,
	[ITAX] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[ADMIN_WAGE] [numeric](16, 2) NULL,
	[EPF_WAGE] [numeric](16, 2) NULL,
	[ESIC_WAGE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[ARR_DAYS] [int] NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[CCA] [numeric](16, 2) NULL,
	[DRIVER] [numeric](16, 2) NULL,
	[EMPLOYER_ESIC] [numeric](16, 2) NULL,
	[NPS] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_27]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_27](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[BONUS] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_28]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_28](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[INDEPENDENT_SURVEYOR] [numeric](16, 2) NULL,
	[PROVIDENT_FUND] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[LEAVETRAVEL_ALLOWANC] [numeric](16, 2) NULL,
	[OTHER_TRAVELALLOWANC] [numeric](16, 2) NULL,
	[TRANSPORT_ALLOWANCE] [numeric](16, 2) NULL,
	[TRAVEL_OTHEXPS] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CAR_FUELALLOWANCE] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[MEDICAL_ALLOWANCE] [numeric](16, 2) NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[SUBSISTENCE_ALLOWANC] [numeric](16, 2) NULL,
	[SUPERANNUATION] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[OTHRIM] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[PAYDATE] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_29]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_29](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[PAYDATE] [datetime] NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[AMOUNT] [numeric](16, 2) NULL,
	[FIELD_NAME] [nvarchar](50) NULL,
	[REMARKS] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_30]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_30](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[CANTEEN] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[EMPLOYEE_ESIC] [numeric](16, 2) NULL,
	[EMPLOYEE_PF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[MEDICLAIM] [numeric](16, 2) NULL,
	[EPF_WAGE] [numeric](16, 2) NULL,
	[FPF_WAGE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[HOLDAMT] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_CCA] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[DRIVER] [numeric](16, 2) NULL,
	[EMPLOYER_ESIC] [numeric](16, 2) NULL,
	[EMPLOYER_PF] [numeric](16, 2) NULL,
	[STABON] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[AMOUNT] [numeric](16, 2) NULL,
	[COMPONENT] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_5]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_5](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[BUS] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[EMPLOYEE_ESIC] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[ADMIN_WAGE] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_DAYS] [int] NULL,
	[ARR_TELE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_7]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_7](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[HRDID] [int] NULL,
	[Updated_ON] [datetime] NULL,
	[updated_by] [int] NOT NULL,
	[Action] [varchar](200) NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[LOAN] [numeric](16, 2) NULL,
	[BUS] [numeric](16, 2) NULL,
	[CANTEEN] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[MEAL] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[EMPLOYEE_PF] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[EPF_WAGE] [numeric](16, 2) NULL,
	[PTAX_WAGE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[HOLDAMT] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[DRIVER] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[EMPLOYER_ESIC] [numeric](16, 2) NULL,
	[EMPLOYER_PF] [numeric](16, 2) NULL,
	[NPS] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[COMPONENT] [nvarchar](100) NULL,
	[YTD_BASIC] [numeric](16, 2) NULL,
	[YTD_CONVEYANCE] [numeric](16, 2) NULL,
	[YTD_MEAL] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_1]    Script Date: 12-02-2019 21:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_1](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[YTD_LOAN] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[YTD_SAL_ADVANCE] [numeric](16, 2) NULL,
	[YTD_CONVEYANCE] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_14]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_14](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[LOAN] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[MEAL] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[MEDICLAIM] [numeric](16, 2) NULL,
	[EPF_WAGE] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_SFTALL] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[ARR_TELE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDAYS] [int] NULL,
	[EMPLOYER_ESIC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_15]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_15](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[LVNCAS] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[HOLDAMT] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_CCA] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_DAYS] [int] NULL,
	[ARR_HRA] [numeric](16, 2) NULL,
	[ARR_MEALALL] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_SFTALL] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[ARR_TELE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PAYDAYS] [int] NULL,
	[SFTALL] [numeric](16, 2) NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[BPRIM] [numeric](16, 2) NULL,
	[CCA] [numeric](16, 2) NULL,
	[DRV_RIM] [numeric](16, 2) NULL,
	[FODRIM] [numeric](16, 2) NULL,
	[LTA_RIM] [numeric](16, 2) NULL,
	[MEDRIM] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[OTHRIM] [numeric](16, 2) NULL,
	[TELEPHONE] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[STABON] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_24]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_24](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[LOAN] [numeric](16, 2) NULL,
	[BUS] [numeric](16, 2) NULL,
	[CANTEEN] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[EMPLOYEE_ESIC] [numeric](16, 2) NULL,
	[EMPLOYEE_PF] [numeric](16, 2) NULL,
	[ITAX] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[ADMIN_WAGE] [numeric](16, 2) NULL,
	[EPF_WAGE] [numeric](16, 2) NULL,
	[ESIC_WAGE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[ARR_DAYS] [int] NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[CCA] [numeric](16, 2) NULL,
	[DRIVER] [numeric](16, 2) NULL,
	[EMPLOYER_ESIC] [numeric](16, 2) NULL,
	[NPS] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_27]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_27](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[BONUS] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_28]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_28](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[INDEPENDENT_SURVEYOR] [numeric](16, 2) NULL,
	[PROVIDENT_FUND] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[LEAVETRAVEL_ALLOWANC] [numeric](16, 2) NULL,
	[OTHER_TRAVELALLOWANC] [numeric](16, 2) NULL,
	[TRANSPORT_ALLOWANCE] [numeric](16, 2) NULL,
	[TRAVEL_OTHEXPS] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CAR_FUELALLOWANCE] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[MEDICAL_ALLOWANCE] [numeric](16, 2) NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[SUBSISTENCE_ALLOWANC] [numeric](16, 2) NULL,
	[SUPERANNUATION] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[OTHRIM] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[PAYDATE] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_29]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_29](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[PAYDATE] [datetime] NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[AMOUNT] [numeric](16, 2) NULL,
	[FIELD_NAME] [nvarchar](50) NULL,
	[REMARKS] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_30]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_30](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[CANTEEN] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[EMPLOYEE_ESIC] [numeric](16, 2) NULL,
	[EMPLOYEE_PF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[MEDICLAIM] [numeric](16, 2) NULL,
	[EPF_WAGE] [numeric](16, 2) NULL,
	[FPF_WAGE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[HOLDAMT] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_CCA] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[DRIVER] [numeric](16, 2) NULL,
	[EMPLOYER_ESIC] [numeric](16, 2) NULL,
	[EMPLOYER_PF] [numeric](16, 2) NULL,
	[STABON] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[AMOUNT] [numeric](16, 2) NULL,
	[COMPONENT] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_5]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_5](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[BUS] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[EMPLOYEE_ESIC] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[ADMIN_WAGE] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_DAYS] [int] NULL,
	[ARR_TELE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_7]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_7](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[LOAN] [numeric](16, 2) NULL,
	[BUS] [numeric](16, 2) NULL,
	[CANTEEN] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[MEAL] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[EMPLOYEE_PF] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[EPF_WAGE] [numeric](16, 2) NULL,
	[PTAX_WAGE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[HOLDAMT] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[DRIVER] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[EMPLOYER_ESIC] [numeric](16, 2) NULL,
	[EMPLOYER_PF] [numeric](16, 2) NULL,
	[NPS] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[COMPONENT] [nvarchar](100) NULL,
	[YTD_BASIC] [numeric](16, 2) NULL,
	[YTD_CONVEYANCE] [numeric](16, 2) NULL,
	[YTD_MEAL] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Temp_Country]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Temp_Country](
	[COUNTRY_NAME] [nvarchar](255) NULL,
	[COUNTRY_CODE] [nvarchar](255) NULL,
	[CREATED_BY] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[yourtable]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[yourtable](
	[Id] [int] NULL,
	[Name] [varchar](4) NULL,
	[Category] [varchar](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [IX_dbo.IVAP_HIS_LWF]    Script Date: 12-02-2019 21:00:12 ******/
CREATE NONCLUSTERED INDEX [IX_dbo.IVAP_HIS_LWF] ON [dbo].[dbo.IVAP_HIS_LWF]
(
	[HISID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IVAP_CALENDAR_SETUP] ADD  CONSTRAINT [DF_IVAP_CALENDAR_SETUP_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_CALENDAR_SETUP] ADD  CONSTRAINT [DF_IVAP_CALENDAR_SETUP_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_DATA_ACCESS_DTL] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_DATA_ACCESS_DTL] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_BANK] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_CALENDAR_SETUP] ADD  CONSTRAINT [DF_IVAP_HIS_CALENDAR_SETUP_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_CALENDAR_SETUP] ADD  CONSTRAINT [DF_IVAP_HIS_CALENDAR_SETUP_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPANY] ADD  CONSTRAINT [DF_IVAP_HIS_COMPANY_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPANY] ADD  CONSTRAINT [DF_IVAP_HIS_COMPANY_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT] ADD  DEFAULT ((0)) FOR [MIN_LENGTH]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT] ADD  DEFAULT ((0)) FOR [MAX_LENGTH]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT] ADD  DEFAULT ((0)) FOR [MANDATORY]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [MIN_LENGTH]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [MAX_LENGTH]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [MANDATORY]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [HAS_RULE]
GO
ALTER TABLE [dbo].[IVAP_HIS_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_COSTCENTRE] ADD  CONSTRAINT [DF_IVAP_HIS_COSTCENTER_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_COSTCENTRE] ADD  CONSTRAINT [DF_IVAP_HIS_COSTCENTER_ISACTIVE]  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_DEPARTMENT] ADD  CONSTRAINT [DF_IVAP_HIS_DEPARTMENT_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_DEPARTMENT] ADD  CONSTRAINT [DF_IVAP_HIS_DEPARTMENT_ISACTIVE]  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_DESIGNATION] ADD  CONSTRAINT [DF_IVAP_HIS_DESIGNATION_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_DESIGNATION] ADD  CONSTRAINT [DF_IVAP_HIS_DESIGNATION_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_DIVISION] ADD  CONSTRAINT [DF_IVAP_HIS_DIVISION_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_DIVISION] ADD  CONSTRAINT [DF_IVAP_HIS_DIVISION_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_FUNCTION] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_GRADE] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_LEVEL] ADD  CONSTRAINT [DF_IVAP_HIS_LEVEL_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_LEVEL] ADD  CONSTRAINT [DF_IVAP_HIS_LEVEL_ISACTIVE]  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_LWF] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_MINWAGE] ADD  CONSTRAINT [DF_IVAP_HIS_MINWAGE_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_MINWAGE] ADD  CONSTRAINT [DF_IVAP_HIS_MINWAGE_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_MONTH_CLOSE] ADD  CONSTRAINT [DF_IVAP_HIS_MONTH_CLOSE_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_MONTH_CLOSE] ADD  CONSTRAINT [DF_IVAP_HIS_MONTH_CLOSE_ISACT]  DEFAULT ((0)) FOR [ISACT]
GO
ALTER TABLE [dbo].[IVAP_HIS_PASSWORD] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_PLANT] ADD  CONSTRAINT [DF_IVAP_HIS_PLANT_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_PLANT] ADD  CONSTRAINT [DF_IVAP_HIS_PLANT_ISACTIVE]  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_REGION] ADD  CONSTRAINT [DF_IVAP_HIS_REGION_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_REGION] ADD  CONSTRAINT [DF_IVAP_HIS_REGION_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_HIS_USER] ADD  CONSTRAINT [DF_IVAP_HIS_USER_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_USER] ADD  CONSTRAINT [DF_IVAP_HIS_USER_UPDATED_ON]  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_USER] ADD  CONSTRAINT [DF_IVAP_HIS_USER_PASSWORD_TRY]  DEFAULT ((0)) FOR [PASSWORD_TRY]
GO
ALTER TABLE [dbo].[IVAP_HIS_USERROLE] ADD  CONSTRAINT [DF_IVAP_HIS_USERROLE_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_USERROLE] ADD  CONSTRAINT [DF_IVAP_HIS_USERROLE_UPDATED_ON]  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_WorkFlowSetting] ADD  CONSTRAINT [DF_IVAP_HIS_WorkFlowSetting_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_HIS_WorkFlowSetting] ADD  CONSTRAINT [DF_IVAP_HIS_WorkFlowSetting_ISACTIVE]  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_1] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_1] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_14] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_14] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_15] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_15] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_24] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_24] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_27] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_27] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_28] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_28] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_29] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_29] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_30] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_30] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_5] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_7] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_7] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_1] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_14] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_15] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_24] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_27] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_28] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_29] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_30] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_7] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_1] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_14] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_15] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_24] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_27] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_28] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_29] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_30] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_7] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_META_MASTER] ADD  DEFAULT ((0)) FOR [DISPLAY_ORDER]
GO
ALTER TABLE [dbo].[IVAP_META_MASTER_DEFAULT] ADD  DEFAULT ((0)) FOR [DISPLAY_ORDER]
GO
ALTER TABLE [dbo].[IVAP_MONTH_CLOSE] ADD  CONSTRAINT [DF_IVAP_MONTH_CLOSE_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MONTH_CLOSE] ADD  CONSTRAINT [DF_IVAP_MONTH_CLOSE_ISACT]  DEFAULT ((0)) FOR [ISACT]
GO
ALTER TABLE [dbo].[IVAP_MST_BANK] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_BANK] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_BANK_GLOBAL] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_BANK_GLOBAL] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_CALENDAR_TYPE] ADD  CONSTRAINT [DF_IVAP_MST_CALENDAR_TYPE_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_CALENDAR_TYPE] ADD  CONSTRAINT [DF_IVAP_MST_CALENDAR_TYPE_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_CLASS] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_CLASS] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPANY] ADD  CONSTRAINT [DF__IVAP_MST___CREAT__47A6A41B]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPANY] ADD  CONSTRAINT [DF__IVAP_MST___ISACT__489AC854]  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT] ADD  DEFAULT ((0)) FOR [MIN_LENGTH]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT] ADD  DEFAULT ((0)) FOR [MAX_LENGTH]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT] ADD  DEFAULT ((0)) FOR [MANDATORY]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [MIN_LENGTH]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [MAX_LENGTH]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [MANDATORY]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [HAS_RULE]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT_ENTITY] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_COMPONENT_ENTITY] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_COSTCENTRE] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_COSTCENTRE] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_COUNTRY] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_COUNTRY] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_CURRENCY] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_CURRENCY] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_DEPARTMENT] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_DEPARTMENT] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_DESIGNATION] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_DESIGNATION] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_DIVISION] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_DIVISION] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_ENTITY] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_ENTITY] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_ENTITY] ADD  DEFAULT ((0)) FOR [COUNTRY]
GO
ALTER TABLE [dbo].[IVAP_MST_ENTITY] ADD  DEFAULT ((0)) FOR [CURRENCY]
GO
ALTER TABLE [dbo].[IVAP_MST_ENTITY] ADD  DEFAULT ('DD-MMM-YYYY') FOR [DATE_FORMAT]
GO
ALTER TABLE [dbo].[IVAP_MST_FILE_COMP_DETAIL] ADD  CONSTRAINT [DF_IVAP_MST_FILE_COMP_DETAIL_CREATED_ON]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_FILE_COMP_DETAIL] ADD  CONSTRAINT [DF_IVAP_MST_FILE_COMP_DETAIL_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_FILETYPE] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_FILETYPE] ADD  CONSTRAINT [DF_IVAP_MST_FILETYPE_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_FILETYPE] ADD  DEFAULT (NULL) FOR [Img_Icon]
GO
ALTER TABLE [dbo].[IVAP_MST_FUNCTION] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_FUNCTION] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_GRADE] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_GRADE] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_KEYWORD] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_KEYWORD] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_LEAVING_REASON] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_LEAVING_REASON] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_LEVEL] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_LEVEL] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_LOCATION] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_LOCATION] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_LOCATION_GLOBAL] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_LOCATION_GLOBAL] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_LWF] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_MENU] ADD  DEFAULT ((0)) FOR [ISMOBILE]
GO
ALTER TABLE [dbo].[IVAP_MST_MENU] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_MENU] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_MINWAGE] ADD  CONSTRAINT [DF__IVAP_MST___CREAT__73852659]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_MINWAGE] ADD  CONSTRAINT [DF_IVAP_MST_MINWAGE_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_PASSLINK] ADD  CONSTRAINT [DF_IVAP_MST_PASSLINK_CREATEDON]  DEFAULT (getdate()) FOR [CREATEDON]
GO
ALTER TABLE [dbo].[IVAP_MST_PASSLINK] ADD  CONSTRAINT [DF_IVAP_MST_PASSLINK_ISUSED]  DEFAULT ((0)) FOR [ISUSED]
GO
ALTER TABLE [dbo].[IVAP_MST_PLANT] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_PLANT] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_PROCESS] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_PROCESS] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_PTAX] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_REGION] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_REGION] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_SECTION] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_SECTION] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_SERVICE_GLOBAL] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_SERVICE_GLOBAL] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_STATE] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_STATE] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_SUB_FUNCTION] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_SUB_FUNCTION] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_TYPE] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_TYPE] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_USER] ADD  CONSTRAINT [DF__IVAP_MST___CREAT__48CFD27E]  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_USER] ADD  CONSTRAINT [DF__IVAP_MST___UPDAT__49C3F6B7]  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_USER] ADD  CONSTRAINT [DF__IVAP_MST___PASSW__4AB81AF0]  DEFAULT ((0)) FOR [PASSWORD_TRY]
GO
ALTER TABLE [dbo].[IVAP_MST_USERROLE] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_USERROLE] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_WorkFlowSetting] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_WorkFlowSetting] ADD  DEFAULT ((0)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_1] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_1] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_14] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_14] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_15] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_15] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_24] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_24] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_27] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_27] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_28] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_28] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_29] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_29] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_30] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_30] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_5] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_7] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_7] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_1] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_14] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_15] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_24] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_27] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_28] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_29] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_30] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_7] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
/****** Object:  StoredProcedure [dbo].[ActivateUser]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[ActivateUser]
(
@P_Uid int,
@P_Password Varchar(100),
@P_Randomkey Varchar(100)
)
As
declare @Ret int=0,@Flag int=0
Begin
  Select @Flag=Count(*) From IVAP_Mst_Passlink Where Randomkey=@P_Randomkey And UId=@P_Uid
  If @Flag>0
  begin
    update IVAP_MST_USER set ISAUTH=1,ISACT=1,password=@P_Password,PASSWORD_LAST_UPDATED=getdate(),PASSWORD_TRY=0 Where UId=@P_Uid
    Update IVAP_MST_PASSLINK SET Isused=1,Usedon=getdate(),UsedBy=@P_Uid,Remarks='First Time Varification'
    Where Randomkey=@P_Randomkey And UId=@P_Uid;
    Insert Into IVAP_HIS_PASSWORD(UId,Password,CREATED_ON) Values(@P_Uid,@P_Password,getdate());
    Select @Ret=Isauth From IVAP_MST_USER Where UId=@P_Uid;
  End
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateBANK]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddUpdateBANK]    
(    
 @BANKID INT,    
 @ENTITYID INT,    
 --@BANK_CODE VARCHAR(10),    
 @BANK_NAME VARCHAR(200),    
@BANK_ADDR VARCHAR(500),    
@BANK_CITY VARCHAR(50),    
@BANK_STATE INT ,    
@BANK_PIN VARCHAR(20),    
@BANK_PHONE VARCHAR(100),    
 @CREATED_BY INT,    
 @ISACT INT,    
 @ERP_BANK_CODE VARCHAR(20),    
 @PAY_BANK_CODE VARCHAR(20),    
 @IFSC VARCHAR(20),   
 @GLOBAL_BANK_ID int   
)    
AS    
BEGIN    
 DECLARE @result INT =0    
 --IF Exists(SELECT * FROM IVAP_MST_BANK WHERE BANK_NAME = @BANK_NAME AND TID <> @BANKID )    
 --BEGIN    
 -- SET @result = -1    
 -- SELECT @result as result    
 -- RETURN;    
 --END    
 IF Exists(SELECT * FROM IVAP_MST_BANK WHERE ENTITY_ID=@ENTITYID and  PAY_BANK_CODE = @PAY_BANK_CODE AND TID <> @BANKID )    
 BEGIN    
  SET @result = -2    
  SELECT @result as result    
  RETURN;    
 END    
 IF Exists(SELECT * FROM IVAP_MST_BANK WHERE ENTITY_ID=@ENTITYID and  ERP_BANK_CODE = @ERP_BANK_CODE AND TID <> @BANKID )    
 BEGIN    
  SET @result = -3    
  SELECT @result as result    
  RETURN;    
 END    
 IF(@BANKID =0)    
 BEGIN    
  INSERT INTO IVAP_MST_BANK(ENTITY_ID,BANK_NAME,BANK_ADDR,BANK_CITY,BANK_STATE,BANK_PIN,BANK_PHONE,ERP_BANK_CODE,PAY_BANK_CODE,IFSC,CREATED_ON,CREATED_BY,ISACTIVE,GLOBAL_BANK_ID)    
  VALUES(@ENTITYID,@BANK_NAME,@BANK_ADDR,@BANK_CITY,@BANK_STATE,@BANK_PIN,@BANK_PHONE,@ERP_BANK_CODE,@PAY_BANK_CODE,@IFSC,GETDATE(),@CREATED_BY,@ISACT,@GLOBAL_BANK_ID)    
  SET @result = SCOPE_IDENTITY();   
  EXEC DATA_ACCESSCONTROL_INSERT @CREATED_BY,'IVAP_MST_BANK',@result 
  EXEC Bank_History @result,@CREATED_BY,'Create'    
 END    
 ELSE    
 BEGIN    
  UPDATE IVAP_MST_BANK SET    
  ENTITY_ID=@ENTITYID,BANK_NAME=@BANK_NAME,BANK_ADDR=@BANK_ADDR,BANK_CITY=@BANK_CITY,BANK_STATE=@BANK_STATE,BANK_PIN=@BANK_PIN,BANK_PHONE=@BANK_PHONE,    
  ERP_BANK_CODE=@ERP_BANK_CODE,PAY_BANK_CODE=@PAY_BANK_CODE,IFSC=@IFSC,GLOBAL_BANK_ID=@GLOBAL_BANK_ID,    
  UPDATED_BY=@CREATED_BY,    
  UPDATE_ON=GETDATE(),    
  ISACTIVE=@ISACT    
   WHERE TID = @BANKID    
   SET @result =0    
   EXEC Bank_History @BANKID,@CREATED_BY,'Update'    
 END    
 SELECT @result AS result    
END 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateCalendar_Setup]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateCalendar_Setup]
(
	@TID INT,
	@ENTITY_ID INT,
	@CALENDAR_TYPE INT,
	@FILE_TYPE VARCHAR(50),
	@DESCRIPTION VARCHAR(500),
	@PAY_DATE DATETIME,
	@DUE_DATE DATETIME,
	@REMAINDER_DAYS INT,
	@EVENT VARCHAR(200),
	@FREQUENCY VARCHAR(100),
	@ISACTIVE INT,
	@UID INT
)
AS
BEGIN
	DECLARE @Result INT =0
	--IF EXISTS(SELECT * FROM IVAP_CALENDAR_SETUP where ENTITY_ID=@ENTITY_ID AND CALENDAR_NAME=@CALENDAR_NAME AND TID<>@TID)    
	--BEGIN    
	--	SELECT -1    
	--	RETURN    
	--END
	IF(@TID =0)
	BEGIN
		INSERT INTO IVAP_CALENDAR_SETUP(ENTITY_ID,FILE_TYPE,CALENDAR_TYPE,DESCRIPTION,PAY_DATE,DUE_DATE,REMAINDER_DAYS,EVENT,FREQUENCY,CREATED_ON,CREATED_BY,ISACTIVE)
			VALUES(@ENTITY_ID,@FILE_TYPE,@CALENDAR_TYPE,@DESCRIPTION,@PAY_DATE,@DUE_DATE,@REMAINDER_DAYS,@EVENT,@FREQUENCY,GETDATE(),@UID,@ISACTIVE)
		SET @Result = SCOPE_IDENTITY()
		Exec Calendar_Setup_His @Result,@UID,'Create'
	END
	ELSE
	BEGIN
		UPDATE IVAP_CALENDAR_SETUP SET
			ENTITY_ID =@ENTITY_ID,FILE_TYPE=@FILE_TYPE, CALENDAR_TYPE=@CALENDAR_TYPE,DESCRIPTION=@DESCRIPTION,PAY_DATE=@PAY_DATE,DUE_DATE=@DUE_DATE,REMAINDER_DAYS=@REMAINDER_DAYS,EVENT=@EVENT,
			FREQUENCY=@FREQUENCY,ISACTIVE= @ISACTIVE,UPDATED_ON = GETDATE(),UPDATED_BY =@UID
		WHERE TID = @TID
		Exec Calendar_Setup_His @TID,@UID,'Update'
		SET @Result = 0
	END
	SELECT @Result AS result
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateChangeLabel]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC [dbo].[AddUpdateChangeLabel]
(
	@TID INT,
	@DISPLAY_NAME VARCHAR(100),
	@DISPLAY_ORDER int
)
AS
BEGIN
	DECLARE @result INT =0
	 
		UPDATE IVAP_META_MASTER SET
		DISPLAY_NAME=@DISPLAY_NAME,
		DISPLAY_ORDER=@DISPLAY_ORDER
			WHERE TID = @TID
			SET @result =0 
	SELECT @result AS result
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateClass]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
        
CREATE proc [dbo].[AddUpdateClass]        
(        
@CID int=0,                  
@ENTITY_ID INT,                  
@PAY_CLASS_CODE VARCHAR(10),              
@ERP_CLASS_CODE VARCHAR(10),                   
@CLASS_NAME VARCHAR(200),                    
@UID INT ,             
@ISACTIVE INT           
)        
AS        
BEGIN        
DECLARE @result int=0                  
if exists(select * from IVAP_MST_CLASS where UPPER(CLASS_NAME)=UPPER(@CLASS_NAME) AND ENTITY_ID=@ENTITY_ID AND TID <> @CID)                  
begin            
set @result=-1                  
select @result as result                  
Return;                  
end   
if exists(select * from IVAP_MST_CLASS where  ENTITY_ID=@ENTITY_ID AND ERP_CLASS_CODE=@ERP_CLASS_CODE AND TID <> @CID)                  
begin            
set @result=-2                  
select @result as result                  
Return;                  
end   
  if exists(select * from IVAP_MST_CLASS where ENTITY_ID=@ENTITY_ID AND PAY_CLASS_CODE=@PAY_CLASS_CODE  AND TID <> @CID)                  
begin            
set @result=-3                  
select @result as result                  
Return;                  
end         
if(@CID=0)                  
begin                  
Insert into IVAP_MST_CLASS(ENTITY_ID,PAY_CLASS_CODE,ERP_CLASS_CODE,CLASS_NAME,CREATED_ON,CREATED_BY,ISACTIVE)          
VALUES(@ENTITY_ID,@PAY_CLASS_CODE,@ERP_CLASS_CODE,@CLASS_NAME,GETDATE(),@UID,@ISACTIVE)          
SET @Result = SCOPE_IDENTITY()   
EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_CLASS',@Result    
EXEC CLASS_HISTORY @Result,@UID,'CREATE';             
End                  
else                  
begin              
UPDATE IVAP_MST_CLASS SET ENTITY_ID=@ENTITY_ID,PAY_CLASS_CODE=@PAY_CLASS_CODE,ERP_CLASS_CODE=@ERP_CLASS_CODE,CLASS_NAME=@CLASS_NAME,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE          
WHERE TID=@CID          
SET @Result =0          
EXEC CLASS_HISTORY @CID,@UID,'UPDATE';                
end                  
SELECT @Result AS result            
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateCompany]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
--select * from IVAP_MST_COMPANY    
--select * from IVAP_MST_DESIGNATION    
    
CREATE PROC [dbo].[AddUpdateCompany]    
(    
 @COMPID INT,    
 @EID INT,    
 @COMP_CODE VARCHAR(20),    
 @COMP_NAME VARCHAR(200),    
 @COMP_ADDR1 VARCHAR(500),    
 @COMP_ADDR2 VARCHAR(500)='',    
 @COMP_CITY VARCHAR(200),    
 @COMP_STATE INT,    
 @COMP_PIN VARCHAR(20),    
 @COMP_CLASS INT,    
 @COMP_PANNO VARCHAR(20),    
 @COMP_TANNO VARCHAR(50),    
 @COMP_TDSCIRCLE VARCHAR(50),    
 @SIGN_FNAME VARCHAR(200)='',    
 @SIGN_LNAME VARCHAR(100)='',    
 @SIGN_FATHER_NAME VARCHAR(200)='',    
 @SIGN_ADDR1 VARCHAR(500)='',    
 @SIGN_ADDR2 VARCHAR(500)='',    
 @SIGN_CITY VARCHAR(200)='',    
 @SIGN_DSG VARCHAR(50)='',    
 @SIGN_STATE INT,    
 @SIGN_PIN VARCHAR(12)='',    
 @SIGN_PLACE VARCHAR(100)='',    
 @SIGN_DATE DATE=null,    
 @RETIRE_AGE INT,    
 @EMP_CODE_GEN INT,    
 @EMP_CODE_PREFIX VARCHAR(10),    
 @EMP_CODE_LEN INT,    
 @Comp_Logo VARCHAR(500)='',    
 @COMP_URL VARCHAR(200)='',    
 @CREATED_BY INT,    
 @ISACT INT    
)    
AS    
BEGIN    
 DECLARE @result INT =0    
 IF Exists(SELECT * FROM IVAP_MST_COMPANY WHERE COMP_NAME = @COMP_NAME AND TID <> @COMPID AND ENTITY_ID=@EID)    
 BEGIN    
  SET @result = -1    
  SELECT @result as result    
  RETURN;    
 END    
 IF Exists(SELECT * FROM IVAP_MST_COMPANY WHERE COMP_CODE = @COMP_CODE AND TID <> @COMPID AND ENTITY_ID=@EID)    
 BEGIN    
  SET @result = -2    
  SELECT @result as result    
  RETURN;    
 END    
 IF(@COMPID =0)    
 BEGIN    
  INSERT INTO IVAP_MST_COMPANY(    
   ENTITY_ID,    
   COMP_CODE,    
   COMP_NAME,    
   COMP_ADDR1,    
   COMP_ADDR2,    
   COMP_CITY,    
   COMP_STATE,    
   COMP_PIN,    
   COMP_CLASS,    
   COMP_PANNO,    
   COMP_TANNO,    
   COMP_TDSCIRCLE,    
   SIGN_FNAME,    
   SIGN_LNAME,    
   SIGN_FATHER_NAME,    
   SIGN_ADDR1,    
   SIGN_ADDR2,    
   SIGN_CITY,    
   SIGN_DSG,    
   SIGN_STATE,    
   SIGN_PIN,    
   SIGN_PLACE,    
   SIGN_DATE,    
   RETIRE_AGE,    
   EMP_CODE_GEN,    
   EMP_CODE_PREFIX,    
   EMP_CODE_LEN,    
   Comp_Logo,    
   COMP_URL,    
   CREATED_BY,    
   ISACTIVE    
  )    
  VALUES(    
   @EID,    
   @COMP_CODE,    
   @COMP_NAME,    
   @COMP_ADDR1,    
   @COMP_ADDR2,    
   @COMP_CITY,    
   @COMP_STATE,    
   @COMP_PIN,    
   @COMP_CLASS,    
   @COMP_PANNO,    
   @COMP_TANNO,    
   @COMP_TDSCIRCLE,    
   @SIGN_FNAME,    
   @SIGN_LNAME,    
   @SIGN_FATHER_NAME,    
   @SIGN_ADDR1,    
   @SIGN_ADDR2,    
   @SIGN_CITY,    
   @SIGN_DSG,    
   @SIGN_STATE,    
   @SIGN_PIN,    
   @SIGN_PLACE,    
   @SIGN_DATE,    
   @RETIRE_AGE,    
   @EMP_CODE_GEN,    
   @EMP_CODE_PREFIX,    
   @EMP_CODE_LEN,    
   @Comp_Logo,    
   @COMP_URL,    
   @CREATED_BY,    
   @ISACT    
  )    
  SET @result = SCOPE_IDENTITY();    
  EXEC DATA_ACCESSCONTROL_INSERT @CREATED_BY,'IVAP_MST_COMPANY',@result  
  EXEC Company_History @result,@CREATED_BY,'Create'    
 END    
 ELSE    
 BEGIN    
  UPDATE IVAP_MST_COMPANY SET    
   ENTITY_ID=@EID,    
   COMP_CODE=@COMP_CODE,    
   COMP_NAME=@COMP_NAME,    
   COMP_ADDR1=@COMP_ADDR1,    
   COMP_ADDR2=@COMP_ADDR2,    
   COMP_CITY=@COMP_CITY,    
   COMP_STATE=@COMP_STATE,    
   COMP_PIN=@COMP_PIN,    
   COMP_CLASS=@COMP_CLASS,    
   COMP_PANNO=@COMP_PANNO,    
   COMP_TANNO=@COMP_TANNO,    
   COMP_TDSCIRCLE=@COMP_TDSCIRCLE,    
   SIGN_FNAME=@SIGN_FNAME,    
   SIGN_LNAME=@SIGN_LNAME,    
   SIGN_FATHER_NAME=@SIGN_FATHER_NAME,    
   SIGN_ADDR1=@SIGN_ADDR1,    
   SIGN_ADDR2=@SIGN_ADDR2,    
   SIGN_CITY=@SIGN_CITY,    
   SIGN_DSG=@SIGN_DSG,    
   SIGN_STATE=@SIGN_STATE,    
   SIGN_PIN=@SIGN_PIN,    
   SIGN_PLACE=@SIGN_PLACE,    
   SIGN_DATE=@SIGN_DATE,    
   RETIRE_AGE=@RETIRE_AGE,    
   EMP_CODE_GEN=@EMP_CODE_GEN,    
   EMP_CODE_PREFIX=@EMP_CODE_PREFIX,    
   EMP_CODE_LEN=@EMP_CODE_LEN,    
   Comp_Logo=@Comp_Logo,    
   COMP_URL=@COMP_URL,    
   UPDATED_BY=@CREATED_BY,    
   UPDATED_ON=GETDATE(),    
   ISACTIVE=@ISACT    
   WHERE TID = @COMPID    
   SET @result =0    
   EXEC Company_History @COMPID,@CREATED_BY,'Update'    
 END    
 SELECT @result AS result    
END 



GO
/****** Object:  StoredProcedure [dbo].[AddUpdateComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddUpdateComponent]
(
	@ComponentID INT,
	@COMPONENT_FILE_TYPE VARCHAR(20),
	@COMPONENT_TYPE VARCHAR(20),
	@COMPONENT_SUB_TYPE VARCHAR(20),
@COMPONENT_NAME VARCHAR(20),
@COMPONENT_DATATYPE VARCHAR(20),
@COMPONENT_DISPLAY_NAME VARCHAR(20) ,
@COMPONENT_DESCRIPTION VARCHAR(20),
@MIN_LENGTH int,
@MAX_LENGTH int,
@MANDATORY int,
	@CREATED_BY INT,
	@ISACT INT
)
AS
BEGIN
	DECLARE @result INT =0
	--IF Exists(SELECT * FROM IVAP_MST_COMPONENT WHERE COMPONENT_NAME = @COMPONENT_NAME and COMPONENT_TYPE!='MASTER' AND TID = @ComponentID )
	--BEGIN
	--	SET @result = -1
	--	SELECT @result as result
	--	RETURN;
	--END

	IF Exists(SELECT * FROM IVAP_MST_COMPONENT WHERE COMPONENT_NAME = @COMPONENT_NAME and COMPONENT_TYPE!='MASTER' AND TID = @ComponentID )
	BEGIN
		SET @result = -1
		SELECT @result as result
		RETURN;
	END
	 
	IF(@ComponentID =0)
	BEGIN
		INSERT INTO IVAP_MST_COMPONENT(COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,CREATED_ON,CREATED_BY,ISACTIVE)
		VALUES(@COMPONENT_FILE_TYPE,@COMPONENT_TYPE,@COMPONENT_SUB_TYPE,@COMPONENT_NAME,@COMPONENT_DATATYPE,@COMPONENT_DISPLAY_NAME,@COMPONENT_DESCRIPTION,@MIN_LENGTH,@MAX_LENGTH,@MANDATORY,GETDATE(),@CREATED_BY,@ISACT)
		SET @result = SCOPE_IDENTITY();
		EXEC Component_History @result,@CREATED_BY,'Create'
	END
	ELSE
	BEGIN
		UPDATE IVAP_MST_COMPONENT SET
		COMPONENT_FILE_TYPE=@COMPONENT_FILE_TYPE,COMPONENT_TYPE=@COMPONENT_TYPE,COMPONENT_SUB_TYPE=@COMPONENT_SUB_TYPE,COMPONENT_NAME=@COMPONENT_NAME,COMPONENT_DATATYPE=@COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME
		,COMPONENT_DESCRIPTION=@COMPONENT_DESCRIPTION,MIN_LENGTH=@MIN_LENGTH,
		MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,
		UPDATED_BY=@CREATED_BY,
		UPDATE_ON=GETDATE(),
		ISACTIVE=@ISACT
			WHERE TID = @ComponentID
			SET @result =0
			EXEC Component_History @ComponentID,@CREATED_BY,'Update'
	END
	SELECT @result AS result
END

 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateComponent2612]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddUpdateComponent2612]
(
	@ComponentID INT,
	@COMPONENT_FILE_TYPE VARCHAR(20),
	@COMPONENT_TYPE VARCHAR(20),
	@COMPONENT_SUB_TYPE VARCHAR(20),
@COMPONENT_NAME VARCHAR(20),
@COMPONENT_DATATYPE VARCHAR(20),
@COMPONENT_DISPLAY_NAME VARCHAR(20) ,
@COMPONENT_DESCRIPTION VARCHAR(20),
@Component_TableName VARCHAR(50)='' ,
@Component_FieldName VARCHAR(50)='',
@MIN_LENGTH int =0,
@MAX_LENGTH int =0,
@MANDATORY int,
	@CREATED_BY INT,
	@ISACT INT
)
AS
BEGIN
	DECLARE @result INT =0
	IF Exists(SELECT KEYWORD FROM IVAP_MST_KEYWORD WHERE KEYWORD = @COMPONENT_NAME )
	BEGIN
		SET @result = -3
		SELECT @result as result
		RETURN;
	END
	IF Exists(SELECT * FROM IVAP_MST_COMPONENT WHERE COMPONENT_NAME = @COMPONENT_NAME  and  TID <> @ComponentID )
	BEGIN
		SET @result = -1
		SELECT @result as result
		RETURN;
	END
	IF(LEN(@Component_TableName)>5)BEGIN
	IF Exists(SELECT * FROM IVAP_MST_COMPONENT WHERE COMPONENT_TABLE_NAME=@Component_TableName and COMPONENT_COLUMN_NAME=@Component_FieldName and TID <> @ComponentID )
	BEGIN
		SET @result = -2
		SELECT @result as result
		RETURN;
	END
	END

	 
	IF(@ComponentID =0)
	BEGIN
		INSERT INTO IVAP_MST_COMPONENT(COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,
		COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,MIN_LENGTH,MAX_LENGTH,MANDATORY,CREATED_ON,CREATED_BY,ISACTIVE)
		VALUES(@COMPONENT_FILE_TYPE,@COMPONENT_TYPE,@COMPONENT_SUB_TYPE,@COMPONENT_NAME,@COMPONENT_DATATYPE,@COMPONENT_DISPLAY_NAME,@COMPONENT_DESCRIPTION,
		@Component_TableName,@Component_FieldName,@MIN_LENGTH,@MAX_LENGTH,@MANDATORY,GETDATE(),@CREATED_BY,@ISACT)
		SET @result = SCOPE_IDENTITY();
		EXEC Component_History @result,@CREATED_BY,'Create'
	END
	ELSE
	BEGIN
		UPDATE IVAP_MST_COMPONENT SET
		COMPONENT_FILE_TYPE=@COMPONENT_FILE_TYPE,COMPONENT_TYPE=@COMPONENT_TYPE,COMPONENT_SUB_TYPE=@COMPONENT_SUB_TYPE,COMPONENT_NAME=@COMPONENT_NAME,COMPONENT_DATATYPE=@COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,
		COMPONENT_TABLE_NAME=@Component_TableName,COMPONENT_COLUMN_NAME=@Component_FieldName
		,COMPONENT_DESCRIPTION=@COMPONENT_DESCRIPTION,MIN_LENGTH=@MIN_LENGTH,
		MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,
		UPDATED_BY=@CREATED_BY,
		UPDATE_ON=GETDATE(),
		ISACTIVE=@ISACT
			WHERE TID = @ComponentID
			SET @result =0
			EXEC Component_History @ComponentID,@CREATED_BY,'Update'
	END
	SELECT @result AS result
END


GO
/****** Object:  StoredProcedure [dbo].[AddUpdateCostCentre]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from IVAP_MST_COSTCENTRE  
CREATE PROC [dbo].[AddUpdateCostCentre]  
(  
 @CostCenterID INT,  
 @ENTITYID INT,  
 @PAY_COST_CODE VARCHAR(20),  
 @ERP_COST_CODE VARCHAR(20),  
 @COST_NAME VARCHAR(200),  
 @CREATED_BY INT,  
 @ISACT INT  
)  
AS  
BEGIN  
 DECLARE @result INT =0  
 IF Exists(SELECT * FROM IVAP_MST_COSTCENTRE WHERE COST_NAME = @COST_NAME AND TID <> @CostCenterID AND ENTITY_ID=@ENTITYID)  
 BEGIN  
  SET @result = -1  
  SELECT @result as result  
  RETURN;  
 END  
 IF Exists(SELECT * FROM IVAP_MST_COSTCENTRE WHERE ENTITY_ID=@ENTITYID and  PAY_COST_CODE = @PAY_COST_CODE AND TID <> @CostCenterID )  
 BEGIN  
  SET @result = -2  
  SELECT @result as result  
  RETURN;  
 END  
 IF Exists(SELECT * FROM IVAP_MST_COSTCENTRE WHERE ENTITY_ID=@ENTITYID and  ERP_COST_CODE = @ERP_COST_CODE AND TID <> @CostCenterID )  
 BEGIN  
  SET @result = -3  
  SELECT @result as result  
  RETURN;  
 END  
 IF(@CostCenterID =0)  
 BEGIN  
  INSERT INTO IVAP_MST_COSTCENTRE(ENTITY_ID,PAY_COST_CODE,ERP_COST_CODE,COST_NAME,CREATED_BY,CREATED_ON,ISACTIVE)  
  VALUES(@ENTITYID,@PAY_COST_CODE,@ERP_COST_CODE,@COST_NAME,@CREATED_BY,GETDATE(),@ISACT)  
  SET @result = SCOPE_IDENTITY();  
  EXEC DATA_ACCESSCONTROL_INSERT @CREATED_BY,'IVAP_MST_COSTCENTRE',@result
  EXEC CostCentre_History @result,@CREATED_BY,'Create'  
 END  
 ELSE  
 BEGIN  
  UPDATE IVAP_MST_COSTCENTRE SET  
  ENTITY_ID=@ENTITYID,  
  PAY_COST_CODE=@PAY_COST_CODE,  
  ERP_COST_CODE=@ERP_COST_CODE,  
  COST_NAME=@COST_NAME,  
  UPDATED_BY=@CREATED_BY,  
  UPDATED_ON=GETDATE(),  
  ISACTIVE=@ISACT  
   WHERE TID = @CostCenterID  
   SET @result =0  
   EXEC CostCentre_History @CostCenterID,@CREATED_BY,'Update'  
 END  
 SELECT @result AS result  
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateCurrency]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CURRENCY_HISTORY  
CREATE proc [dbo].[AddUpdateCurrency]  
(  
@CID int=0,   
@CURRENCY_CODE VARCHAR(10),   
@CURRENCY_NAME VARCHAR(200),  
@UID INT ,             
@ISACTIVE INT   
)  
as  
begin  
DECLARE @result int=0                  
if exists(select * from IVAP_MST_CURRENCY where CURRENCY_CODE=@CURRENCY_CODE AND UPPER(CURRENCY_NAME)=UPPER(@CURRENCY_NAME)  AND TID <> @CID)                  
begin            
set @result=-1                  
select @result as result                  
Return;                  
end    
if(@CID=0)                  
begin                  
Insert into IVAP_MST_CURRENCY(CURRENCY_CODE,CURRENCY_NAME,CREATED_ON,CREATED_BY,ISACTIVE)          
VALUES(@CURRENCY_CODE,@CURRENCY_NAME,GETDATE(),@UID,@ISACTIVE)          
SET @Result = SCOPE_IDENTITY()       
EXEC CURRENCY_HISTORY @Result,@UID,'CREATE';             
End                  
else                  
begin              
UPDATE IVAP_MST_CURRENCY SET CURRENCY_CODE=@CURRENCY_CODE,CURRENCY_NAME=@CURRENCY_NAME,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE          
WHERE TID=@CID          
SET @Result =0          
EXEC CURRENCY_HISTORY @CID,@UID,'UPDATE';                
end                  
SELECT @Result AS result    
end
GO
/****** Object:  StoredProcedure [dbo].[ADDUPDATEDATAACCESS]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[ADDUPDATEDATAACCESS]
(
@DAID INT,
@UID INT,
@TABLE_NAME varchar(100)='',
@TIDS varchar(MAX),
@CREATED_BY int,
@ISACTIVE VARCHAR(10)='1'
)
AS
BEGIN     
DECLARE @result int=0                  
if exists(select * from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME=@TABLE_NAME )                  
begin            
set @DAID=1                                   
end       
if(@DAID=0)                  
begin                  
Insert into IVAP_DATA_ACCESS_DTL(UID,TABLE_NAME,TIDS,CREATED_ON,CREATED_BY,ISACTIVE)          
VALUES(@UID,@TABLE_NAME,@TIDS,GETDATE(),@CREATED_BY,@ISACTIVE)          
SET @Result = SCOPE_IDENTITY()                 
End                  
else                  
begin              
UPDATE IVAP_DATA_ACCESS_DTL SET TIDS=@TIDS,CREATED_ON=GETDATE(),CREATED_BY=@CREATED_BY,ISACTIVE=@ISACTIVE          
WHERE UID=@UID AND TABLE_NAME=@TABLE_NAME        
SET @Result =0                        
end                  
SELECT @Result AS result            
END

GO
/****** Object:  StoredProcedure [dbo].[AddUpdateDepartment]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateDepartment]  
(  
 @DEPTID INT,  
 @ENTITYID INT,  
 @PAY_DEPT_CODE VARCHAR(20),  
 @ERP_DEPT_CODE VARCHAR(20),  
 @DEPT_NAME VARCHAR(200),  
 @CREATED_BY INT,  
 @ISACT INT  
)  
AS  
BEGIN  
 DECLARE @result INT =0  
 IF Exists(SELECT * FROM IVAP_MST_DEPARTMENT WHERE DEPT_NAME = @DEPT_NAME AND ENTITY_ID=@ENTITYID AND TID <> @DEPTID )  
 BEGIN  
  SET @result = -1  
  SELECT @result as result  
  RETURN;  
 END  
 IF Exists(SELECT * FROM IVAP_MST_DEPARTMENT WHERE ENTITY_ID=@ENTITYID and  PAY_DEPT_CODE = @PAY_DEPT_CODE AND TID <> @DEPTID )  
 BEGIN  
  SET @result = -2  
  SELECT @result as result  
  RETURN;  
 END  
 IF Exists(SELECT * FROM IVAP_MST_DEPARTMENT WHERE ENTITY_ID=@ENTITYID and  ERP_DEPT_CODE = @ERP_DEPT_CODE AND TID <> @DEPTID )  
 BEGIN  
  SET @result = -3  
  SELECT @result as result  
  RETURN;  
 END  
 IF(@DEPTID =0)  
 BEGIN  
  INSERT INTO IVAP_MST_DEPARTMENT(ENTITY_ID,PAY_DEPT_CODE,ERP_DEPT_CODE,DEPT_NAME,CREATED_BY,CREATED_ON,ISACTIVE)  
  VALUES(@ENTITYID,@PAY_DEPT_CODE,@ERP_DEPT_CODE,@DEPT_NAME,@CREATED_BY,GETDATE(),@ISACT)  
  SET @result = SCOPE_IDENTITY();  
  EXEC DATA_ACCESSCONTROL_INSERT  @CREATED_BY,'IVAP_MST_DEPARTMENT',@result    
  EXEC Department_History @result,@CREATED_BY,'Create'  
 END  
 ELSE  
 BEGIN  
  UPDATE IVAP_MST_DEPARTMENT SET  
  ENTITY_ID=@ENTITYID,  
  PAY_DEPT_CODE=@PAY_DEPT_CODE,  
  ERP_DEPT_CODE=@ERP_DEPT_CODE,  
  DEPT_NAME=@DEPT_NAME,  
  UPDATED_BY=@CREATED_BY,  
  UPDATED_ON=GETDATE(),  
  ISACTIVE=@ISACT  
   WHERE TID = @DEPTID  
   SET @result =0  
   EXEC Department_History @DEPTID,@CREATED_BY,'Update'  
 END  
 SELECT @result AS result  
END  
  

   
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateDesignation]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from IVAP_MST_DESIGNATION    
    
CREATE PROC [dbo].[AddUpdateDesignation]    
(    
 @DesigID INT,    
 @ENTITY_ID INT,    
 @PAY_DSG_CODE VARCHAR(20),    
 @ERP_DSG_CODE VARCHAR(20),    
 @DSG_NAME VARCHAR(200),    
 @UID INT,    
 @ISACTIVE INT    
)    
AS    
BEGIN    
 DECLARE @Result INT =0;    
 if exists (select * from IVAP_MST_DESIGNATION where ENTITY_ID=@ENTITY_ID AND PAY_DSG_CODE=@PAY_DSG_CODE AND TID<>@DesigID)    
 BEGIN    
  select -1    
  return    
 END    
 if exists (select * from IVAP_MST_DESIGNATION where ENTITY_ID=@ENTITY_ID AND ERP_DSG_CODE=@ERP_DSG_CODE AND TID<>@DesigID)    
 BEGIN    
  select -2    
  return    
 END     
 IF Exists(SELECT * FROM IVAP_MST_DESIGNATION WHERE ENTITY_ID=@ENTITY_ID AND UPPER(DSG_NAME) = UPPER(@DSG_NAME) AND TID <> @DesigID)    
 BEGIN    
  SET @result = -3    
  SELECT @result as result    
  RETURN;    
 END    
 IF(@DesigID =0)    
 BEGIN    
  INSERT INTO IVAP_MST_DESIGNATION(ENTITY_ID,PAY_DSG_CODE,ERP_DSG_CODE,DSG_NAME,CREATED_BY,ISACTIVE)    
  VALUES(@ENTITY_ID,@PAY_DSG_CODE,@ERP_DSG_CODE,@DSG_NAME,@UID,@ISACTIVE)    
  SET @Result = SCOPE_IDENTITY();    
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_DESIGNATION',@Result
  EXEC Designation_History @Result,@UID,'Create'    
 END    
 ELSE    
 BEGIN    
  UPDATE IVAP_MST_DESIGNATION SET     
  ENTITY_ID=@ENTITY_ID,PAY_DSG_CODE=@PAY_DSG_CODE,ERP_DSG_CODE=@ERP_DSG_CODE,DSG_NAME=@DSG_NAME    
  ,UPDATED_BY=@UID,UPDATED_ON=GETDATE(),ISACTIVE=@ISACTIVE    
  WHERE TID =@DesigID    
  EXEC Designation_History @DesigID,@UID,'Update'    
  SET @Result=0    
 END    
 SELECT @Result AS result;     
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateDivision]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
--select * from IVAP_MST_DIVISION      
CREATE PROC [dbo].[AddUpdateDivision]      
(      
 @DiviID INT,      
 @ENTITY_ID INT,      
 @PAY_DIVI_CODE VARCHAR(20),      
 @ERP_DIVI_CODE VARCHAR(20),      
 @DIVI_NAME VARCHAR(200),      
 @IsAct INT,      
 @UID INT      
)      
AS      
BEGIN      
 DECLARE @Result INT =0;      
 if exists (select * from IVAP_MST_DIVISION where ENTITY_ID=@ENTITY_ID AND PAY_DIVI_CODE=@PAY_DIVI_CODE AND TID<>@DiviID)      
 BEGIN      
  select -1      
  return      
 END      
 if exists (select * from IVAP_MST_DIVISION where ENTITY_ID=@ENTITY_ID AND ERP_DIVI_CODE=@ERP_DIVI_CODE AND TID<>@DiviID)      
 BEGIN      
  select -2      
  return      
 END      
 IF Exists(SELECT DIVI_NAME FROM IVAP_MST_DIVISION WHERE ENTITY_ID=@ENTITY_ID AND UPPER(DIVI_NAME) = UPPER(@DIVI_NAME) AND TID <> @DiviID)      
 BEGIN      
  SET @result = -3      
  SELECT @result as result      
  RETURN;      
 END      
 IF(@DiviID =0)      
 BEGIN      
  INSERT INTO IVAP_MST_DIVISION(ENTITY_ID,PAY_DIVI_CODE,ERP_DIVI_CODE,DIVI_NAME,CREATED_BY,ISACTIVE)      
   VALUES(@ENTITY_ID,@PAY_DIVI_CODE,@ERP_DIVI_CODE,@DIVI_NAME,@UID,@IsAct)      
  SET @Result = SCOPE_IDENTITY()  
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_DIVISION',@Result    
  Exec DIVISION_HISTORY @Result,@UID,'Create'      
      
 END      
 ELSE      
 BEGIN      
  UPDATE IVAP_MST_DIVISION       
  SET ENTITY_ID=@ENTITY_ID,PAY_DIVI_CODE=@PAY_DIVI_CODE,ERP_DIVI_CODE=@ERP_DIVI_CODE,DIVI_NAME=@DIVI_NAME,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@IsAct     
  WHERE TID =@DiviID      
  Exec DIVISION_HISTORY @DiviID,@UID,'Update'      
  SET @Result=0      
 END      
 SELECT @Result AS result      
END 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateEntityComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddUpdateEntityComponent]
(
@EntityCompID INT,
@Globle_Component_ID int=0,
@ENTITY_ID INT,
@COMPONENT_DATATYPE VARCHAR(20)='',
@COMPONENT_DISPLAY_NAME VARCHAR(20)='' ,
@MIN_LENGTH int=0,
@MAX_LENGTH int=0,
@MANDATORY int,
	@CREATED_BY INT,
	@ISACT INT
)
AS
BEGIN
	DECLARE @result INT =0
	IF Exists(SELECT * FROM IVAP_MST_COMPONENT_ENTITY WHERE Globle_Component_ID = @Globle_Component_ID and ENTITY_ID=@ENTITY_ID AND TID <> @EntityCompID )
	BEGIN
		SET @result = -1
		SELECT @result as result
		RETURN;
	END
	 
	IF(@EntityCompID =0)
	BEGIN
	INSERT INTO IVAP_MST_COMPONENT_ENTITY(Globle_Component_ID,ENTITY_ID,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH
,MAX_LENGTH,MANDATORY,CREATED_ON,CREATED_BY,ISACTIVE)
	select TID,@ENTITY_ID,COMPONENT_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH,MAX_LENGTH,MANDATORY,CREATED_ON,@CREATED_BY,ISACTIVE from
	 IVAP_MST_COMPONENT where tid in(@Globle_Component_ID)
		SET @result = SCOPE_IDENTITY();
		EXEC CREATE_ComponentEntity_History @result,@CREATED_BY,'Create'
	END
	ELSE
	BEGIN
		UPDATE IVAP_MST_COMPONENT_ENTITY SET
		COMPONENT_DATATYPE=@COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,MIN_LENGTH=@MIN_LENGTH,
		MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,
		UPDATED_BY=@CREATED_BY,
		UPDATE_ON=GETDATE(),
		ISACTIVE=@ISACT
			WHERE TID = @EntityCompID
			SET @result =0
			EXEC CREATE_ComponentEntity_History @EntityCompID,@CREATED_BY,'Update'
	END
	SELECT @result AS result
END

GO
/****** Object:  StoredProcedure [dbo].[AddUpdateEntityComponent1217]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateEntityComponent1217]
(
@EntityCompID INT,
@Globle_Component_ID int=0,
@ENTITY_ID INT,
@COMPONENT_DISPLAY_NAME VARCHAR(20)='' ,
@MANDATORY int,
@CREATED_BY INT,
@ISACT INT,
@GL_CODE VARCHAR(200)='',
@PMS_CODE VARCHAR(200)=''
)
AS
BEGIN
	DECLARE @result INT =0
	IF Exists(SELECT * FROM IVAP_MST_COMPONENT_ENTITY WHERE Globle_Component_ID = @Globle_Component_ID and ENTITY_ID=@ENTITY_ID AND TID <> @EntityCompID )
	BEGIN
		SET @result = -1
		SELECT @result as result
		RETURN;
	END
	 
	IF(@EntityCompID =0)
	BEGIN
	INSERT INTO IVAP_MST_COMPONENT_ENTITY(Globle_Component_ID,ENTITY_ID,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH

,MAX_LENGTH,MANDATORY,CREATED_ON,CREATED_BY,ISACTIVE,GL_Code,PMS_COde)
	select TID,@ENTITY_ID,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH,MAX_LENGTH,MANDATORY,CREATED_ON,@CREATED_BY,
	ISACTIVE,@GL_CODE,@PMS_CODE from
	 IVAP_MST_COMPONENT where tid in(@Globle_Component_ID)
		SET @result = SCOPE_IDENTITY();
		EXEC CREATE_ComponentEntity_History @result,@CREATED_BY,'Create'
	END
	ELSE
	BEGIN
		UPDATE IVAP_MST_COMPONENT_ENTITY SET
		COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME
		,MANDATORY=@MANDATORY,
		UPDATED_BY=@CREATED_BY,
		UPDATE_ON=GETDATE(),
		GL_Code=@GL_CODE,
		PMS_CODE=@PMS_CODE,
		ISACTIVE=@ISACT
			WHERE TID = @EntityCompID
			SET @result =0
			EXEC CREATE_ComponentEntity_History @EntityCompID,@CREATED_BY,'Update'
	END
	SELECT @result AS result
END


GO
/****** Object:  StoredProcedure [dbo].[AddUpdateFileCompDetail]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_FILE_COMP_DETAIL
--select * from IVAP_MST_COMPONENT_ENTITY
CREATE PROCEDURE [dbo].[AddUpdateFileCompDetail]
(
	@TID INT=0,
	@FILE_ID INT,
	@COMPONENT_ID INT,
	@UID INT
)
AS
BEGIN
	DECLARE @result INT =0
	DECLARE @Display_Order INT =0
	IF Exists(SELECT * FROM IVAP_MST_FILE_COMP_DETAIL WHERE COMPONENT_ID = @COMPONENT_ID AND FILE_ID =@FILE_ID AND TID <> @TID )
	BEGIN
		SET @result = -1
		SELECT @result as result
		RETURN;
	END
	IF(@TID =0)
	BEGIN
		SET @Display_Order = (SELECT ISNULL(MAX(Display_Order),0) FROM IVAP_MST_FILE_COMP_DETAIL WHERE FILE_ID =@FILE_ID)
		SET @Display_Order =@Display_Order +1;
		INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order)
			VALUES(@FILE_ID,@COMPONENT_ID,@UID,@Display_Order)
		SET @result = SCOPE_IDENTITY();
	END
	ELSE
	BEGIN
		UPDATE IVAP_MST_FILE_COMP_DETAIL SET FILE_ID =@FILE_ID,COMPONENT_ID=@COMPONENT_ID,UPDATED_ON = GETDATE(),UPDATED_BY = @UID
		WHERE TID = @TID
		SET @result = 0
	END
	SELECT @result AS result
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateFileCompDetail_12_FEB]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[AddUpdateFileCompDetail_12_FEB]  
(  
 @TID INT=0,  
 @FILE_ID INT,  
 @COMPONENT_ID INT,  
 @UID INT  
)  
AS  
BEGIN  
 DECLARE @result INT =0  
 DECLARE @Display_Order INT =0  
 IF Exists(SELECT * FROM IVAP_MST_FILE_COMP_DETAIL WHERE COMPONENT_ID = @COMPONENT_ID AND FILE_ID =@FILE_ID AND TID <> @TID )  
 BEGIN  
  SET @result = -1  
  SELECT @result as result  
  RETURN;  
 END  
 IF(@TID =0)  
 BEGIN  
  SET @Display_Order = (SELECT ISNULL(MAX(Display_Order),0) FROM IVAP_MST_FILE_COMP_DETAIL WHERE FILE_ID =@FILE_ID)  
  SET @Display_Order =@Display_Order +1;  
  INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE)  
  select @FILE_ID,@COMPONENT_ID,@UID,@Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE from IVAP_MST_COMPONENT_ENTITY where IVAP_MST_COMPONENT_ENTITY.TID=@COMPONENT_ID
  SET @result = SCOPE_IDENTITY();  
 END  
 ELSE  
 BEGIN  
  UPDATE IVAP_MST_FILE_COMP_DETAIL SET FILE_ID =@FILE_ID,COMPONENT_ID=@COMPONENT_ID,UPDATED_ON = GETDATE(),UPDATED_BY = @UID  
  WHERE TID = @TID  
  SET @result = 0  
 END  
 SELECT @result AS result  
END  
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateFileType]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from IVAP_MST_FILETYPE where TID =11  
--select * from IVAP_MST_FILE_COMP_DETAIL where FILE_ID=11  
  
CREATE PROC [dbo].[AddUpdateFileType]  
(  
 @FileID INT=0,  
 @ENTITY_ID INT,  
 @FILE_TYPE VARCHAR(50),  
 @FILE_NAME VARCHAR(200),  
 @FILE_DESC VARCHAR(500)=null,  
 --@DUE_DATE DATE,  
 @ISACTIVE INT,  
 @UID INT,  
 @CATEGORY nvarchar(100)
)  
AS  
BEGIN  
 DECLARE @Result INT=0  
 DECLARE @ComponentID INT =0  
 IF Exists(SELECT * FROM IVAP_MST_FILETYPE WHERE ENTITY_ID=@ENTITY_ID AND FILE_TYPE=@FILE_TYPE AND UPPER(FILE_NAME) = UPPER(@FILE_NAME) AND TID <> @FileID)  
 BEGIN  
  SET @Result = -1  
  SELECT @Result as result  
  RETURN;  
 END  
 IF(@FileID =0)  
 BEGIN  
  INSERT INTO IVAP_MST_FILETYPE(ENTITY_ID,FILE_TYPE,FILE_NAME,FILE_DESC,CREATED_BY,ISACTIVE,CATEGORY)  
   VALUES(@ENTITY_ID,@FILE_TYPE,@FILE_NAME,@FILE_DESC,@UID,@ISACTIVE,@CATEGORY)  
  SET @Result = SCOPE_IDENTITY()  
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_FILETYPE',@Result   
  SET @ComponentID = (select TID from IVAP_MST_COMPONENT_ENTITY where ENTITY_ID=@ENTITY_ID AND COMPONENT_NAME='EMP_CODE')  
  
  INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order)  
   VALUES(@Result,@ComponentID,@UID,1)  
 END  
 ELSE  
 BEGIN  
  UPDATE IVAP_MST_FILETYPE   
  SET ENTITY_ID=@ENTITY_ID,FILE_TYPE=@FILE_TYPE,FILE_NAME=@FILE_NAME,FILE_DESC=@FILE_DESC,UPDATED_ON = GETDATE(),UPDATED_BY = @UID,CATEGORY=@CATEGORY  
  WHERE TID = @FileID  
  SET @Result = 0  
 END  
 SELECT @Result AS result  
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateFunction]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE proc [dbo].[AddUpdateFunction]    
(    
 @TID int ,    
 @ENTITYID int,    
 @PAY_FUNC_CODE varchar(10),    
 @ERP_FUNC_CODE varchar(10) ,    
 @FUNC_NAME varchar(200) ,    
 @CREATED_BY int ,    
 @ISACTIVE char(1)    
)    
AS    
BEGIN    
DECLARE @result int=0     
 IF EXISTS(select * from IVAP_MST_FUNCTION WHERE ENTITY_ID=@ENTITYID AND ERP_FUNC_CODE=@ERP_FUNC_CODE AND TID<>@TID )    
 BEGIN    
  select -1;    
  return;    
 END    
 IF EXISTS(select * from IVAP_MST_FUNCTION WHERE ENTITY_ID=@ENTITYID  AND PAY_FUNC_CODE=@PAY_FUNC_CODE AND TID<>@TID)    
 BEGIN    
  select -2;    
  return;    
 END    
 IF EXISTS(select * from IVAP_MST_FUNCTION WHERE ENTITY_ID=@ENTITYID  AND FUNC_NAME=@FUNC_NAME AND TID<>@TID)    
 BEGIN    
  select -3;    
  return;    
 END    
 IF(@TID=0)    
 BEGIN    
 insert into IVAP_MST_FUNCTION(    
 ENTITY_ID,    
 PAY_FUNC_CODE,    
 ERP_FUNC_CODE,    
 FUNC_NAME,    
 CREATED_BY,    
 ISACTIVE    
 )    
 values    
 (    
  @ENTITYID,    
  @PAY_FUNC_CODE,    
  @ERP_FUNC_CODE,    
  @FUNC_NAME,    
  @CREATED_BY,    
  @ISACTIVE     
 )    
SET @result= SCOPE_IDENTITY();   
EXEC DATA_ACCESSCONTROL_INSERT @CREATED_BY,'IVAP_MST_FUNCTION',@result 
 EXEC CREATE_FUNCTION_History @Result,@CREATED_BY,'CREATE';    
 select @result;  
 END   
 ELSE   
 BEGIN   
 update IVAP_MST_FUNCTION Set    
 PAY_FUNC_CODE=@PAY_FUNC_CODE,    
 ERP_FUNC_CODE=@ERP_FUNC_CODE,    
 FUNC_NAME=@FUNC_NAME,    
 UPDATED_BY=@CREATED_BY,    
    ENTITY_ID=    @ENTITYID,    
 ISACTIVE=@ISACTIVE,    
 UPDATE_ON=getdate()    
 where TID=@TID;    
 SET @Result =0     
 EXEC CREATE_FUNCTION_History @TID,@CREATED_BY,'UPDATE';     
 SELECT @Result  AS Result  
 END   
END    
    
GO
/****** Object:  StoredProcedure [dbo].[ADDUPDATEGLOBALLOCATION]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
        
--sp_helptext addupdategloballocation

    
CREATE PROC [dbo].[ADDUPDATEGLOBALLOCATION]  
(  
@LID INT=0,  
@LOC_CODE VARCHAR(10),  
@LOC_NAME VARCHAR(200),  
@STATE_ID INT,  
@ISMETRO INT,  
@UID INT ,             
@ISACTIVE INT   
)  
AS  
BEGIN  
DECLARE @result int=0                  
if exists(select * from IVAP_MST_LOCATION_GLOBAL where UPPER(LOC_NAME)=UPPER(@LOC_NAME) AND STATE_ID=@STATE_ID AND TID <> @LID)                  
begin                  
set @result=-1                  
select @result as result                  
Return;                  
end
if exists(select * from IVAP_MST_LOCATION_GLOBAL where LOC_CODE=@LOC_CODE AND STATE_ID=@STATE_ID AND TID <> @LID)                  
begin                  
set @result=-2                  
select @result as result                  
Return;                  
end      
if(@LID=0)                  
begin   
INSERT INTO IVAP_MST_LOCATION_GLOBAL(LOC_CODE,LOC_NAME,STATE_ID,ISMETRO,CREATED_ON,CREATED_BY,ISACTIVE)  
VALUES(@LOC_CODE,@LOC_NAME,@STATE_ID,@ISMETRO,GETDATE(),@UID,@ISACTIVE)  
SET @Result = SCOPE_IDENTITY()                
  EXEC GLOBALLOCATION_HISTORY @Result,@UID,'CREATE';                
End                  
else                  
begin                  
update IVAP_MST_LOCATION_GLOBAL set LOC_CODE=@LOC_CODE,LOC_NAME=@LOC_NAME,STATE_ID=@STATE_ID,ISMETRO=@ISMETRO,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE                  
where TID=@LID                  
SET @Result =0          
EXEC GLOBALLOCATION_HISTORY @LID,@UID,'UPDATE';                  
end                  
SELECT @Result AS result     
END
          
  
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateGrade]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AddUpdateGrade]    
(    
 @TID int=0,    
 @ENTITY_ID int ,    
 @PAY_GRADE_CODE varchar(10) ,    
 @ERP_GRADE_CODE varchar(10) ,    
 @GARDE_NAME varchar(100),    
 @GRADE_SCALE_FROM numeric(10, 2),    
 @GRADE_SCALE_TO numeric(10, 2),    
 @GRADE_MIDPOINT numeric(10, 2),    
 @Prob_Period numeric(10, 2) ,    
 @CREATED_BY int ,    
 @ISACTIVE char(1)     
)    
AS    
BEGIN    
DECLARE @result int=0     
 IF EXISTS(select * from IVAP_MST_GRADE WHERE ENTITY_ID=@ENTITY_ID  AND ERP_GRADE_CODE=@ERP_GRADE_CODE AND TID<>@TID)    
 BEGIN    
  select -1;    
  return;    
 END    
 IF EXISTS(select * from IVAP_MST_GRADE WHERE ENTITY_ID=@ENTITY_ID  AND PAY_GRADE_CODE=@PAY_GRADE_CODE AND TID<>@TID)    
 BEGIN    
  select -2;    
  return;    
 END    
 IF EXISTS(select * from IVAP_MST_GRADE WHERE ENTITY_ID=@ENTITY_ID  AND GARDE_NAME=@GARDE_NAME AND TID<>@TID)    
 BEGIN    
  select -3;    
  return;    
 END    
 IF (@TID=0)    
 BEGIN    
  INSERT INTO IVAP_MST_GRADE(ENTITY_ID,PAY_GRADE_CODE,ERP_GRADE_CODE,GARDE_NAME,GRADE_SCALE_FROM,GRADE_SCALE_TO,GRADE_MIDPOINT,    
  Prob_Period,CREATED_BY,ISACTIVE,CREATED_ON)    
  values(    
  @ENTITY_ID,@PAY_GRADE_CODE,@ERP_GRADE_CODE,@GARDE_NAME,@GRADE_SCALE_FROM,@GRADE_SCALE_TO,@GRADE_MIDPOINT,    
  @Prob_Period,@CREATED_BY,@ISACTIVE,getdate())    
  set @result= SCOPE_IDENTITY()  
  EXEC DATA_ACCESSCONTROL_INSERT @CREATED_BY,'IVAP_MST_GRADE',@result  
  EXEC CREATE_GRAD_History @Result,@CREATED_BY,'CREATE';   
  select @result;    
 END    
 else  
 begin  
 update IVAP_MST_GRADE Set     
 ENTITY_ID=@ENTITY_ID,    
 PAY_GRADE_CODE=@PAY_GRADE_CODE,    
 ERP_GRADE_CODE=@ERP_GRADE_CODE,    
 GARDE_NAME=@GARDE_NAME,    
 GRADE_SCALE_FROM=@GRADE_SCALE_FROM,    
 GRADE_SCALE_TO=@GRADE_SCALE_TO,    
 GRADE_MIDPOINT=@GRADE_MIDPOINT,    
 Prob_Period=@Prob_Period,    
 CREATED_BY=@CREATED_BY,    
 ISACTIVE=@ISACTIVE    
 where TID=@TID;    
 set @result= 0  ;  
 EXEC CREATE_GRAD_History @TID,@CREATED_BY,'UPDATE';     
 select @result as Result  
 end  
END    
  
    
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateLeavingReason]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
CREATE proc [dbo].[AddUpdateLeavingReason]          
(          
@LEAVID int=0,                    
@ENTITY_ID INT,                    
@PAY_LEAVING_CODE VARCHAR(10),                
@ERP_LEAVING_CODE VARCHAR(10),                     
@VOL VARCHAR(200),   
@REASON VARCHAR(200),                    
@UID INT ,               
@ISACTIVE INT             
)          
AS          
BEGIN          
DECLARE @result int=0                    
if exists(select * from IVAP_MST_LEAVING_REASON where PAY_LEAVING_CODE=@PAY_LEAVING_CODE AND ENTITY_ID=@ENTITY_ID AND TID <> @LEAVID)                    
begin              
set @result=-1                    
select @result as result                    
Return;                    
end     
if exists(select * from IVAP_MST_LEAVING_REASON where  ENTITY_ID=@ENTITY_ID AND ERP_LEAVING_CODE=@ERP_LEAVING_CODE AND TID <> @LEAVID)                    
begin              
set @result=-2                    
select @result as result                    
Return;                    
end           
if(@LEAVID=0)                    
begin                    
Insert into IVAP_MST_LEAVING_REASON(ENTITY_ID,PAY_LEAVING_CODE,ERP_LEAVING_CODE,[VOL/NON_VOL],REASON,CREATED_ON,CREATED_BY,ISACTIVE)            
VALUES(@ENTITY_ID,@PAY_LEAVING_CODE,@ERP_LEAVING_CODE,@VOL,@REASON,GETDATE(),@UID,@ISACTIVE)            
SET @Result = SCOPE_IDENTITY()        
EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_LEAVING_REASON',@Result 
EXEC LEAVINGREASON_HISTORY @Result,@UID,'CREATE';               
End                    
else                    
begin                
UPDATE IVAP_MST_LEAVING_REASON SET ENTITY_ID=@ENTITY_ID,PAY_LEAVING_CODE=@PAY_LEAVING_CODE,ERP_LEAVING_CODE=@ERP_LEAVING_CODE,[VOL/NON_VOL]=@VOL,REASON=@REASON,[UPDATED_ON]=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE            
WHERE TID=@LEAVID            
SET @Result =0            
EXEC LEAVINGREASON_HISTORY @LEAVID,@UID,'UPDATE';                  
end                    
SELECT @Result AS result              
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateLevel]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
--select * from ivap_mst_Level    
CREATE PROC [dbo].[AddUpdateLevel]    
(    
 @LevelID INT,    
 @ENTITY_ID INT,    
 @PAY_LEVEL_CODE VARCHAR(10),    
 @ERP_LEVEL_CODE VARCHAR(10),    
 @LEVEL_NAME VARCHAR(200),    
 @IsAct INT,    
 @UID INT    
)    
AS    
BEGIN    
 DECLARE @Result INT =0;    
 if exists (select * from IVAP_MST_LEVEL where ENTITY_ID=@ENTITY_ID AND PAY_LEVEL_CODE=@PAY_LEVEL_CODE AND TID<>@LevelID)    
 BEGIN    
  select -1    
  return    
 END    
 if exists (select * from IVAP_MST_LEVEL where ENTITY_ID=@ENTITY_ID AND ERP_LEVEL_CODE=@ERP_LEVEL_CODE AND TID<>@LevelID)    
 BEGIN    
  select -2    
  return    
 END    
 IF Exists(SELECT * FROM IVAP_MST_LEVEL WHERE ENTITY_ID=@ENTITY_ID AND UPPER(LEVEL_NAME) = UPPER(@LEVEL_NAME) AND TID <> @LevelID)    
 BEGIN    
  SET @result = -3    
  SELECT @result as result    
  RETURN;    
 END    
 IF(@LevelID =0)    
 BEGIN    
  INSERT INTO IVAP_MST_LEVEL(ENTITY_ID,PAY_LEVEL_CODE,ERP_LEVEL_CODE,LEVEL_NAME,CREATED_BY,ISACTIVE)    
   VALUES(@ENTITY_ID,@PAY_LEVEL_CODE,@ERP_LEVEL_CODE,@LEVEL_NAME,@UID,@IsAct)    
  SET @Result = SCOPE_IDENTITY()    
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_LEVEL',@Result
  Exec LEVEL_HISTORY @Result,@UID,'Create'    
    
 END    
 ELSE    
 BEGIN    
  UPDATE IVAP_MST_LEVEL    
  SET ENTITY_ID=@ENTITY_ID,PAY_LEVEL_CODE=@PAY_LEVEL_CODE,ERP_LEVEL_CODE=@ERP_LEVEL_CODE,LEVEL_NAME=@LEVEL_NAME,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@IsAct    
  WHERE TID =@LevelID    
  Exec LEVEL_HISTORY @LevelID,@UID,'Update'    
  SET @Result=0    
 END    
 SELECT @Result AS result    
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateLocation]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddUpdateLocation]                  
(                  
@LOCID int=0,                  
@ENTITY_ID INT,                  
@ERP_LOC_CODE VARCHAR(10),              
@PAY_LOC_CODE VARCHAR(10),                   
@LOC_NAME VARCHAR(200),                  
@STATE_ID INT,                  
@ISMETRO INT,             
@UID INT ,             
@ISACTIVE INT,  
@PARENT_LOC_ID INT              
                 
)                  
AS                   
BEGIN                  
DECLARE @result int=0                  
if exists(select * from IVAP_MST_LOCATION where UPPER(LOC_NAME)=UPPER(@LOC_NAME) AND ENTITY_ID=@ENTITY_ID  AND TID <> @LOCID)                  
begin                  
set @result=-1                  
select @result as result                  
Return;                  
end       
if exists(select * from IVAP_MST_LOCATION where ENTITY_ID=@ENTITY_ID  AND ERP_LOC_CODE=@ERP_LOC_CODE   AND TID <> @LOCID)                  
begin                  
set @result=-2                  
select @result as result                  
Return;                  
end      
if exists(select * from IVAP_MST_LOCATION where ENTITY_ID=@ENTITY_ID  AND PAY_LOC_CODE=@PAY_LOC_CODE  AND TID <> @LOCID)                  
begin                  
set @result=-3                  
select @result as result                  
Return;                  
end                 
if(@LOCID=0)                  
begin                  
Insert into IVAP_MST_LOCATION                  
(                      
ENTITY_ID,                  
ERP_LOC_CODE,              
PAY_LOC_CODE,                  
LOC_NAME,                  
STATE_ID,                  
ISMETRO,              
CREATED_ON,              
CREATED_BY,              
ISACTIVE,  
PARENT_LOC_ID                  
)                  
values(                  
                 
@ENTITY_ID,                  
@ERP_LOC_CODE,              
@PAY_LOC_CODE,                  
@LOC_NAME,                  
@STATE_ID,                  
@ISMETRO,              
GETDATE(),              
@UID,              
@ISACTIVE,  
@PARENT_LOC_ID                  
)                  
SET @Result = SCOPE_IDENTITY()            
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_LOCATION',@Result
  EXEC LOCATION_HISTORY @Result,@UID,'CREATE';                
End                  
else                  
begin                  
update IVAP_MST_LOCATION set ENTITY_ID=@ENTITY_ID,ERP_LOC_CODE=@ERP_LOC_CODE,PAY_LOC_CODE=@PAY_LOC_CODE,LOC_NAME=@LOC_NAME,STATE_ID=@STATE_ID,ISMETRO=@ISMETRO,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE,PARENT_LOC_ID=@PARENT_LOC_ID             
     
where TID=@LOCID                  
SET @Result =0          
EXEC LOCATION_HISTORY @LOCID,@UID,'UPDATE';                  
end                  
SELECT @Result AS result                  
end 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateLwf]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AddUpdateLwf]  
(  
  
@LWFID INT=0,  
@StateId INT,  
@LocationId INT =NULL,  
@Periodflag VARCHAR(10),  
@DedMonth INT,  
@LwfEmployee NUMERIC,  
@LwfEmployer NUMERIC,  
@EFF_FROM_DT DATETIME,  
@EFF_TO_DT DATETIME,  
@UID INT,  
@IsAct INT  
  
)  
AS  
BEGIN  
     DECLARE @result int = 0  
 -- IF Exists(Select * from IVAP_MST_LWF WHERE LOCATION_ID = @LocationId AND TID <> @LWFID)  
 -- BEGIN  
 -- SET @result = -1  
 -- SELECT @result as result  
 -- RETURN;  
 --END  
 IF(@LWFID =0)  
 BEGIN  
  INSERT INTO IVAP_MST_LWF(STATE_ID,LOCATION_ID,PERIOD_FLAG,DED_MONTH,LWF_EMPLOYEE,LWF_EMPLOYER,CREATED_BY,CREATED_ON,ISACTIVE,EFF_FROM_DT,EFF_TO_DT)  
  VALUES(@StateId,@LocationId,@Periodflag,@DedMonth,@LwfEmployee,@LwfEmployer,@UID,GETDATE(),@IsAct,@EFF_FROM_DT,@EFF_TO_DT)  
  SET @Result = SCOPE_IDENTITY();  
  EXEC LWF_History @result,@UID,'Create'  
 END  
 ELSE  
 BEGIN  
    UPDATE IVAP_MST_LWF SET  
  STATE_ID=@StateId,LOCATION_ID=@LocationId,PERIOD_FLAG=@Periodflag,DED_MONTH=@DedMonth,LWF_EMPLOYEE=@LwfEmployee,LWF_EMPLOYER=@LwfEmployer,UPDATED_BY=@UID,  
  EFF_FROM_DT=@EFF_FROM_DT,EFF_TO_DT=@EFF_TO_DT,UPDATE_ON=GETDATE(),ISACTIVE =@IsAct
     WHERE TID = @LWFID  
   EXEC LWF_History @LWFID,@UID,'Update'  
   SET @result =0  
 END  
 SELECT @result AS result  
END 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateMinWage]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_MINWAGE
--sp_help IVAP_MST_MINWAGE
--select * from ivap_his_MINWAGE
--SELECT MIN_WAGE FROM IVAP_MST_MINWAGE WHERE UPPER(MIN_WAGE) = UPPER(200) AND TID <> 0 AND ISACTIVE =1
CREATE PROC [dbo].[AddUpdateMinWage]
(
	@MinWageID INT,
	@STATE_ID INT,
	@CATEGORY VARCHAR(200),
	@MIN_WAGE INT,
	@EFF_DT_FROM DATE,
	@EFF_DATE_TO DATE,
	@ISACTIVE INT,
	@UID INT
)
AS
BEGIN
	DECLARE @Result INT =0;
	IF Exists(SELECT MIN_WAGE FROM IVAP_MST_MINWAGE WHERE UPPER(MIN_WAGE) = UPPER(@MIN_WAGE) AND TID <> @MinWageID AND ISACTIVE =1)
	BEGIN
		SET @result = -1
		SELECT @result as result
		RETURN;
	END
	IF(@MinWageID = 0)
	BEGIN
		INSERT INTO IVAP_MST_MINWAGE(STATE_ID,CATEGORY,MIN_WAGE,EFF_DT_FROM,EFF_DATE_TO,CREATED_BY,ISACTIVE)
			VALUES(@STATE_ID,@CATEGORY,@MIN_WAGE,@EFF_DT_FROM,@EFF_DATE_TO,@UID,@ISACTIVE)
		SET @Result=SCOPE_IDENTITY()
		EXEC MINWAGE_HISTORY @Result,@UID,'Create'
	END
	ELSE
	BEGIN
		UPDATE IVAP_MST_MINWAGE SET
		STATE_ID =@STATE_ID,CATEGORY=@CATEGORY,MIN_WAGE=@MIN_WAGE,EFF_DT_FROM=@EFF_DT_FROM,EFF_DATE_TO=@EFF_DATE_TO,
		UPDATED_BY=@UID,UPDATED_ON=GETDATE(),ISACTIVE=@ISACTIVE
		WHERE TID = @MinWageID
		EXEC MINWAGE_HISTORY @MinWageID,@UID,'Update'
		SET @Result=0
	END
	SELECT @Result As result
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdatePLant]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
--SELECT * FROM IVAP_MST_PLANT    
CREATE PROC [dbo].[AddUpdatePLant]    
(    
 @PlantID INT,    
 @ENTITY_ID INT,    
 @PAY_PLANT_CODE VARCHAR(10),    
 @ERP_PLANT_CODE VARCHAR(10),    
 @PLANT_NAME VARCHAR(200),    
 @IsAct INT,    
 @UID INT    
)    
AS    
BEGIN    
 DECLARE @Result INT =0;    
 if exists (select * from IVAP_MST_PLANT where ENTITY_ID=@ENTITY_ID AND PAY_PLANT_CODE=@PAY_PLANT_CODE AND TID<>@PlantID)    
 BEGIN    
  select -1    
  return    
 END    
 if exists (select * from IVAP_MST_PLANT where ENTITY_ID=@ENTITY_ID AND ERP_PLANT_CODE=@ERP_PLANT_CODE AND TID<>@PlantID)    
 BEGIN    
  select -2    
  return    
 END    
 IF Exists(SELECT * FROM IVAP_MST_PLANT WHERE ENTITY_ID=@ENTITY_ID AND UPPER(PLANT_NAME) = UPPER(@PLANT_NAME) AND TID <> @PlantID)    
 BEGIN    
  SET @result = -3    
  SELECT @result as result    
  RETURN;    
 END    
 IF(@PlantID =0)    
 BEGIN    
  INSERT INTO IVAP_MST_PLANT(ENTITY_ID,PAY_PLANT_CODE,ERP_PLANT_CODE,PLANT_NAME,CREATED_BY,ISACTIVE)    
   VALUES(@ENTITY_ID,@PAY_PLANT_CODE,@ERP_PLANT_CODE,@PLANT_NAME,@UID,@IsAct)    
  SET @Result = SCOPE_IDENTITY()  
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_PLANT',@Result  
  Exec PLANT_HISTORY @Result,@UID,'Create'    
    
 END    
 ELSE    
 BEGIN    
  UPDATE IVAP_MST_PLANT    
  SET ENTITY_ID=@ENTITY_ID,PAY_PLANT_CODE=@PAY_PLANT_CODE,ERP_PLANT_CODE=@ERP_PLANT_CODE,PLANT_NAME=@PLANT_NAME,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@IsAct    
  WHERE TID =@PlantID    
  Exec PLANT_HISTORY @PlantID,@UID,'Update'    
  SET @Result=0    
 END    
 SELECT @Result AS result    
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateProcess]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


     
        
CREATE proc [dbo].[AddUpdateProcess]          
(          
 @TID INT,          
 @ENTITY_ID iNT,          
 @Pay_Proc_Code varchar(10),          
 @Erp_Proc_Code varchar(10),          
 @Proc_Name varchar(200),          
 @IsAct int,          
 @Created_By int          
)          
AS          
BEGIN          
DECLARE @result int=0         
 if exists (select * from IVAP_MST_PROCESS where ENTITY_ID=@ENTITY_ID AND PAY_PROC_CODE=@Pay_Proc_Code AND TID<>@TID)          
 BEGIN          
  set @result=-1                      
select @result as result            
  return          
 END          
 if exists (select * from IVAP_MST_PROCESS where ENTITY_ID=@ENTITY_ID AND ERP_PROC_CODE=@Erp_Proc_Code AND TID<>@TID)          
 BEGIN          
  set @result=-2                      
select @result as result          
  return          
 END          
 if exists (select * from IVAP_MST_PROCESS where ENTITY_ID=@ENTITY_ID AND PROC_NAME=@Proc_Name AND TID<>@TID)          
 BEGIN          
 set @result=-3                     
select @result as result           
  return          
 END          
 if(@TID=0)       
 BEGIN        
  INSERT INTO IVAP_MST_PROCESS(ENTITY_ID,PAY_PROC_CODE,ERP_PROC_CODE,PROC_NAME,CREATED_BY,ISACTIVE)          
  values(@ENTITY_ID,@Pay_Proc_Code,@Erp_Proc_Code,@Proc_Name,@Created_By,@IsAct)            
  SET @RESULT= SCOPE_IDENTITY()      
  EXEC DATA_ACCESSCONTROL_INSERT  @Created_By,'IVAP_MST_PROCESS',@Result         
  EXEC PROCESS_HISTORY @Result,@Created_By,'CREATE';        
END 
ELSE 
 BEGIN          
  UPDATE IVAP_MST_PROCESS Set PAY_PROC_CODE=@Pay_Proc_Code,ERP_PROC_CODE=@Erp_Proc_Code,PROC_NAME=@Proc_Name,UPDATE_ON=getdate(),          
  Isactive=@IsAct,CREATED_BY=@Created_By where ENTITY_ID=@ENTITY_ID AND TID=@TID;          
  SET @Result =0          
  EXEC PROCESS_HISTORY @TID,@Created_By,'UPDATE';          
 END         
  SELECT @Result AS result           
END

GO
/****** Object:  StoredProcedure [dbo].[AddUpdatePTAX]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdatePTAX]
(
	@PTAXID INT,
	@STATE_ID INT,
	@PERIOD_FLAG VARCHAR(10),
	@DED_MONTH int,
@YTD_MONTH_FROM int,
@YTD_MONTH_TO int,
@PT_SAL_FROM numeric,
@PT_SAL_TO numeric ,
@GENDER VARCHAR(20),
@PTAX numeric,
@EFF_FROM_DT DATE,
@EFF_TO_DT DATE,
	@CREATED_BY INT
)
AS
BEGIN
	DECLARE @result INT =0
	--IF Exists(SELECT * FROM IVAP_MST_PTAX WHERE BANK_CODE = @BANK_CODE AND TID <> @BANKID )
	--BEGIN
	--	SET @result = -1
	--	SELECT @result as result
	--	RETURN;
	--END
	IF(@PTAXID =0)
	BEGIN
		INSERT INTO IVAP_MST_PTAX(STATE_ID,PERIOD_FLAG,DED_MONTH,YTD_MONTH_FROM,YTD_MONTH_TO,PT_SAL_FROM,PT_SAL_TO
             ,GENDER,PTAX,EFF_FROM_DT,EFF_TO_DT,CREATED_ON,CREATED_BY)
		VALUES(@STATE_ID,@PERIOD_FLAG,@DED_MONTH,@YTD_MONTH_FROM,@YTD_MONTH_TO,@PT_SAL_FROM,@PT_SAL_TO,@GENDER,@PTAX,
		@EFF_FROM_DT,@EFF_TO_DT,
		GETDATE(),@CREATED_BY)
		SET @result = SCOPE_IDENTITY();
	  EXEC CREATE_PTAX_History @result,@CREATED_BY,'Create'
	END
	ELSE
	BEGIN
		UPDATE IVAP_MST_PTAX SET
		STATE_ID=@STATE_ID,PERIOD_FLAG=@PERIOD_FLAG,DED_MONTH=@DED_MONTH,YTD_MONTH_FROM=@YTD_MONTH_FROM,YTD_MONTH_TO=@YTD_MONTH_TO,PT_SAL_FROM=@PT_SAL_FROM,PT_SAL_TO=@PT_SAL_TO,GENDER=@GENDER,
		EFF_FROM_DT=@EFF_FROM_DT,
		EFF_TO_DT=@EFF_TO_DT,
		UPDATED_BY=@CREATED_BY,
		UPDATE_ON=GETDATE(),
		PTAX=@PTAX
			WHERE TID = @PTAXID
			SET @result =0
			EXEC CREATE_PTAX_History @PTAXID,@CREATED_BY,'Update'
	END
	SELECT @result AS result
END 

GO
/****** Object:  StoredProcedure [dbo].[AddUpdateRegion]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--select * from IVAP_MST_REGION    
CREATE PROC [dbo].[AddUpdateRegion]    
(    
 @RegionID INT,    
 @ENTITY_ID INT,    
 @PAY_REGION_CODE VARCHAR(20),    
 @ERP_REGION_CODE VARCHAR(20),    
 @REGION_NAME VARCHAR(200),    
 @ISACTIVE INT,    
 @UID INT    
)    
AS    
BEGIN    
 DECLARE @Result INT =0;    
 if exists (select * from IVAP_MST_REGION where ENTITY_ID=@ENTITY_ID AND PAY_REGION_CODE=@PAY_REGION_CODE AND TID<>@RegionID)    
 BEGIN    
  select -1    
  return    
 END    
 if exists (select * from IVAP_MST_REGION where ENTITY_ID=@ENTITY_ID AND ERP_REGION_CODE=@ERP_REGION_CODE AND TID<>@RegionID)    
 BEGIN    
  select -2    
  return    
 END    
 IF Exists(SELECT REGION_NAME FROM IVAP_MST_REGION WHERE ENTITY_ID=@ENTITY_ID AND UPPER(REGION_NAME) = UPPER(@REGION_NAME) AND TID <> @RegionID)    
 BEGIN    
  SET @result = -3    
  SELECT @result as result    
  RETURN;    
 END    
 IF(@RegionID =0)    
 BEGIN    
  INSERT INTO IVAP_MST_REGION(ENTITY_ID,PAY_REGION_CODE,ERP_REGION_CODE,REGION_NAME,CREATED_BY,ISACTIVE)    
   VALUES(@ENTITY_ID,@PAY_REGION_CODE,@ERP_REGION_CODE,@REGION_NAME,@UID,@ISACTIVE)    
  SET @Result = SCOPE_IDENTITY()   
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_REGION',@Result 
  Exec REGION_HISTORY @Result,@UID,'Create'    
    
 END    
 ELSE    
 BEGIN    
  UPDATE IVAP_MST_REGION     
  SET ENTITY_ID=@ENTITY_ID,PAY_REGION_CODE=@PAY_REGION_CODE,ERP_REGION_CODE=@ERP_REGION_CODE,REGION_NAME=@REGION_NAME,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE    
  WHERE TID =@RegionID    
  Exec REGION_HISTORY @RegionID,@UID,'Update'    
  SET @Result=0    
 END    
 SELECT @Result AS result    
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateRole]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_USERROLE  
--select * from IVAP_HIS_USERROLE  
  
CREATE PROC [dbo].[AddUpdateRole]  
(  
 @RoleID INT,  
 --@EntityID INT,  
 @RoleName VARCHAR(200),  
 @RoleType VARCHAR(100),  
 @IsAct INT,  
 @UID INT  
)  
AS  
BEGIN  
 DECLARE @Result INT =0;  
   
 IF Exists(SELECT ROLENAME FROM IVAP_MST_USERROLE WHERE UPPER(ROLENAME) = UPPER(@RoleName) AND TID <> @RoleID)  
 BEGIN  
  SET @result = -1  
  SELECT @result as result  
  RETURN;  
 END  
 IF(@RoleID =0)  
 BEGIN  
  INSERT INTO IVAP_MST_USERROLE(ROLENAME,ROLETYPE,CREATED_BY,ISACT)  
  VALUES(@RoleName,@RoleType,@UID,@IsAct)  
  SET @Result = SCOPE_IDENTITY()  
  EXEC UserRole_History @Result,@UID,'Create';  
    
 END  
 ELSE  
 BEGIN  
  UPDATE IVAP_MST_USERROLE SET ROLENAME=@RoleName,ROLETYPE=@RoleType,UPDATED_ON=GETDATE(),UPDATED_BY=@UID,ISACT=@IsAct  
  WHERE TID=@RoleID  
  SET @Result =0  
  EXEC UserRole_History @RoleID,@UID,'Update'  
 END  
 SELECT @Result AS result  
END 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateSection]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
CREATE PROC [dbo].[AddUpdateSection]  
(  
 @SECTID INT,  
 @ENTITYID INT,  
 @PAY_SECTION_CODE VARCHAR(20),  
 @ERP_SECTION_CODE VARCHAR(20),  
 @SECTION_NAME VARCHAR(200),  
 @CREATED_BY INT,  
 @ISACT INT  
)  
AS  
BEGIN  
 DECLARE @result INT =0  
 IF Exists(SELECT * FROM IVAP_MST_SECTION WHERE ENTITY_ID=@ENTITYID AND SECTION_NAME = @SECTION_NAME AND TID <> @SECTID )  
 BEGIN  
  SET @result = -1  
  SELECT @result as result  
  RETURN;  
 END  
 IF Exists(SELECT * FROM IVAP_MST_SECTION WHERE ENTITY_ID=@ENTITYID and  PAY_SECTION_CODE = @PAY_SECTION_CODE AND TID <> @SECTID )  
 BEGIN  
  SET @result = -2  
  SELECT @result as result  
  RETURN;  
 END  
 IF Exists(SELECT * FROM IVAP_MST_SECTION WHERE ENTITY_ID=@ENTITYID and  ERP_SECTION_CODE = @ERP_SECTION_CODE AND TID <> @SECTID )  
 BEGIN  
  SET @result = -3  
  SELECT @result as result  
  RETURN;  
 END  
 IF(@SECTID =0)  
 BEGIN  
  INSERT INTO IVAP_MST_SECTION(ENTITY_ID,PAY_SECTION_CODE,ERP_SECTION_CODE,SECTION_NAME,CREATED_BY,CREATED_ON,ISACTIVE)  
  VALUES(@ENTITYID,@PAY_SECTION_CODE,@ERP_SECTION_CODE,@SECTION_NAME,@CREATED_BY,GETDATE(),@ISACT)  
  SET @result = SCOPE_IDENTITY();  
  EXEC DATA_ACCESSCONTROL_INSERT @CREATED_BY,'IVAP_MST_SECTION',@result
  EXEC Section_History @result,@CREATED_BY,'Create'  
 END  
 ELSE  
 BEGIN  
  UPDATE IVAP_MST_SECTION SET  
  ENTITY_ID=@ENTITYID,  
  PAY_SECTION_CODE=@PAY_SECTION_CODE,  
  ERP_SECTION_CODE=@ERP_SECTION_CODE,  
  SECTION_NAME=@SECTION_NAME,  
  UPDATED_BY=@CREATED_BY,  
  UPDATED_ON=GETDATE(),  
  ISACTIVE=@ISACT  
   WHERE TID = @SECTID  
   SET @result =0  
   EXEC Section_History @SECTID,@CREATED_BY,'Update'  
 END  
 SELECT @result AS result  
END  
  
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateState]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELPTEXT ADDUPDATESTATE  
    
--SP_HELPTEXT ADDUPDATESTATE    
      
        
--sp_help IVAP_MST_STATE      
      
CREATE proc [dbo].[AddUpdateState]      
(      
@SID int=0,  
                      
@STATE_CODE VARCHAR(10),            
@STATE_NAME VARCHAR(200),                            
@UID INT ,           
@ISACTIVE INT,  
@COUNTRY   VARCHAR(50)        
)      
AS      
BEGIN      
DECLARE @result int=0                
if exists(select * from IVAP_MST_STATE where UPPER(STATE_NAME)=UPPER(@STATE_NAME) AND STATE_CODE=@STATE_CODE  AND TID <> @SID)                
begin          
set @result=-1                
select @result as result                
Return;                
end         
if(@SID=0)                
begin                
Insert into IVAP_MST_STATE(STATE_CODE,STATE_NAME,CREATED_ON,CREATED_BY,ISACTIVE,COUNTRY)        
VALUES(@STATE_CODE,@STATE_NAME,GETDATE(),@UID,@ISACTIVE,@COUNTRY)        
SET @Result = SCOPE_IDENTITY()      
EXEC STATE_HISTORY  @Result,@UID,'CREATE';             
End                
else                
begin            
UPDATE IVAP_MST_STATE SET STATE_CODE=@STATE_CODE,STATE_NAME=@STATE_NAME,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE ,COUNTRY=@COUNTRY       
WHERE TID=@SID        
SET @Result =0     
EXEC STATE_HISTORY  @SID,@UID,'UPDATE';                 
end                
SELECT @Result AS result          
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateSubFunction]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
 --CURRENCY_HISTORY    
CREATE proc [dbo].[AddUpdateSubFunction]    
(    
 @SID int=0,     
 @ENTITY_ID int,    
 @PAY_SUB_FUNC_CODE VARCHAR(10),     
 @ERP_SUB_FUNC_CODE VARCHAR(10),     
 @SUB_FUNC_NAME VARCHAR(200),    
 @UID INT ,               
 @ISACTIVE INT,    
 @PARENT_FUNC_ID INT      
)    
as    
begin    
 DECLARE @result int=0       
 if exists (select * from IVAP_MST_SUB_FUNCTION where ENTITY_ID=@ENTITY_ID AND PAY_SUB_FUNC_CODE=@PAY_SUB_FUNC_CODE AND TID<>@SID)    
 BEGIN    
  select -1    
  return    
 END    
 if exists (select * from IVAP_MST_SUB_FUNCTION where ENTITY_ID=@ENTITY_ID AND ERP_SUB_FUNC_CODE=@ERP_SUB_FUNC_CODE AND TID<>@SID)    
 BEGIN    
  select -2    
  return    
 END    
 IF Exists(SELECT * FROM IVAP_MST_SUB_FUNCTION WHERE ENTITY_ID=@ENTITY_ID AND UPPER(SUB_FUNC_NAME) = UPPER(@SUB_FUNC_NAME) AND TID <> @SID)    
 BEGIN    
  SET @result = -3    
  SELECT @result as result    
  RETURN;    
 END    
 if(@SID=0)                    
 begin                    
  Insert into IVAP_MST_SUB_FUNCTION(ENTITY_ID,PAY_SUB_FUNC_CODE,ERP_SUB_FUNC_CODE,SUB_FUNC_NAME,CREATED_ON,CREATED_BY,ISACTIVE,PARENT_FUNC_ID)            
  VALUES(@ENTITY_ID,@PAY_SUB_FUNC_CODE,@ERP_SUB_FUNC_CODE,@SUB_FUNC_NAME,GETDATE(),@UID,@ISACTIVE,@PARENT_FUNC_ID)            
  SET @Result = SCOPE_IDENTITY()   
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_SUB_FUNCTION',@Result      
  EXEC SUBFUNCTION_HISTORY @Result,@UID,'CREATE';               
 End                    
 else                    
 begin                
  UPDATE IVAP_MST_SUB_FUNCTION SET PAY_SUB_FUNC_CODE=@PAY_SUB_FUNC_CODE,ERP_SUB_FUNC_CODE=@ERP_SUB_FUNC_CODE,SUB_FUNC_NAME=@SUB_FUNC_NAME,PARENT_FUNC_ID=@PARENT_FUNC_ID,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE            
  WHERE TID=@SID            
  SET @Result =0            
  EXEC SUBFUNCTION_HISTORY @SID,@UID,'UPDATE';                  
  end                    
  SELECT @Result AS result      
 end    
    
--select * from sp_help IVAP_MST_SUB_FUNCTION    
--TID ENTITY_ID PAY_SUB_FUNC_CODE ERP_SUB_FUNC_CODE SUB_FUNC_NAME CREATED_ON CREATED_BY UPDATE_ON UPDATED_BY ISACTIVE PARENT_FUNC_ID
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateType]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


     
CREATE PROC [dbo].[AddUpdateType]           
(            
@TYID int=0,            
@COMP_ID INT,            
@PAY_TYPE_CODE VARCHAR(10),        
@ERP_TYPE_CODE VARCHAR(10),             
@TYPE_NAME VARCHAR(200),              
@UID INT ,       
@ISACTIVE INT             
)      
AS    
BEGIN    
DECLARE @result int=0            
if exists(select * from IVAP_MST_TYPE where TYPE_NAME=@TYPE_NAME  AND ENTITY_ID=@COMP_ID AND TID <> @TYID)            
begin      
set @result=-1            
select @result as result            
Return;            
end 
IF Exists(select * from IVAP_MST_TYPE where PAY_TYPE_CODE=@PAY_TYPE_CODE AND ENTITY_ID=@COMP_ID AND TID <> @TYID)    
 BEGIN    
  SET @result = -2    
  SELECT @result as result    
  RETURN;    
 END    
 IF Exists(select * from IVAP_MST_TYPE where ERP_TYPE_CODE=@ERP_TYPE_CODE AND ENTITY_ID=@COMP_ID AND TID <> @TYID)    
 BEGIN    
  SET @result = -3    
  SELECT @result as result    
  RETURN;    
 END               
if(@TYID=0)            
begin            
Insert into IVAP_MST_TYPE(ENTITY_ID,PAY_TYPE_CODE,ERP_TYPE_CODE,TYPE_NAME,CREATED_ON,CREATED_BY,ISACTIVE)    
VALUES(@COMP_ID,@PAY_TYPE_CODE,@ERP_TYPE_CODE,@TYPE_NAME,GETDATE(),@UID,@ISACTIVE)    
SET @Result = SCOPE_IDENTITY()        
EXEC TYPE_HISTORY @Result,@UID,'CREATE';            
End            
else            
begin        
UPDATE IVAP_MST_TYPE SET ENTITY_ID=@COMP_ID,PAY_TYPE_CODE=@PAY_TYPE_CODE,ERP_TYPE_CODE=@ERP_TYPE_CODE,TYPE_NAME=@TYPE_NAME,UPDATE_ON=GETDATE(),UPDATED_BY=@UID,ISACTIVE=@ISACTIVE    
WHERE TID=@TYID    
SET @Result =0            
EXEC TYPE_HISTORY @TYID,@UID,'UPDATE';   
end            
SELECT @Result AS result      
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateTypes]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


        
CREATE proc [dbo].[AddUpdateTypes]        
(        
 @TID INT,        
 @Type_Name varchar(200),        
 @Pay_Type_Code varchar(10),        
 @Erp_Type_Code varchar(10),        
 @EID int,        
 @IsAct int,        
 @Created_By int        
)        
AS        
BEGIN        
DECLARE @result int=0        
 if exists (select * from IVAP_MST_TYPE where Pay_Type_Code=@Pay_Type_Code AND ENTITY_ID=@EID AND TID<>@TID)        
 BEGIN        
    set @result=-1                     
select @result as result       
  return        
 END        
 if exists (select * from IVAP_MST_TYPE where Erp_Type_Code=@Erp_Type_Code AND ENTITY_ID=@EID AND TID<>@TID)        
 BEGIN        
    set @result=-2                      
select @result as result        
  return        
 END        
 if exists (select * from IVAP_MST_TYPE where Type_Name=@Type_Name AND ENTITY_ID=@EID AND TID<>@TID)        
 BEGIN        
  set @result=-3                      
select @result as result      
  return        
 END        
 if(@TID=0)   
 BEGIN      
 INSERT INTO IVAP_MST_TYPE(ENTITY_ID,PAY_TYPE_CODE,ERP_TYPE_CODE,TYPE_NAME,CREATED_BY,ISACTIVE)        
 values(@EID,@PAY_TYPE_CODE,@ERP_TYPE_CODE,@TYPE_NAME,@Created_By,@IsAct)        
SET @Result = SCOPE_IDENTITY()    
EXEC DATA_ACCESSCONTROL_INSERT @Created_By,'IVAP_MST_TYPE',@Result          
EXEC TYPE_HISTORY @Result,@Created_By,'CREATE';           
 END 
 ELSE        
 BEGIN        
  UPDATE IVAP_MST_TYPE Set ENTITY_ID=@EID,PAY_TYPE_CODE=@PAY_TYPE_CODE,ERP_TYPE_CODE=@ERP_TYPE_CODE,TYPE_NAME=@TYPE_NAME,        
  Isactive=@IsAct,CREATED_BY=@Created_By where ENTITY_ID=@EID AND TID=@TID        
  SET @Result =0          
  EXEC TYPE_HISTORY @TID,@Created_By,'UPDATE';         
 END      
 
 SELECT @Result AS result         
END 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateUser]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM IVAP_MST_USER

CREATE PROC [dbo].[AddUpdateUser]
(
	@UID INT,
	@ENITYTID INT,
	@USERID VARCHAR(200),
	@USER_FIRSTNAME VARCHAR(200),
	@USER_LASTNAME VARCHAR(200)='',
	@USER_EMAIL VARCHAR(200),
	@USER_ROLE INT,
	@USER_MOBILENO VARCHAR(12),
	@PassToken VARCHAR(2000),
	@CreatedBy INT 
)
AS
BEGIN
	DECLARE @result INT =0
	IF Exists(SELECT USERID FROM IVAP_MST_USER WHERE USERID = @USERID AND UID <> @UID AND ENTITY_ID=@ENITYTID)
	BEGIN
		SET @result = -1
		SELECT @result as result
		RETURN;
	END
	IF(@UID=0)
	BEGIN
		INSERT INTO IVAP_MST_USER(ENTITY_ID,USERID,USER_FIRSTNAME,USER_LASTNAME,USER_EMAIL,USER_ROLE,USER_MOBILENO,ISAUTH,ISACT,CREATED_BY)
		VALUES(@ENITYTID,@USERID,@USER_FIRSTNAME,@USER_LASTNAME,@USER_EMAIL,@USER_ROLE,@USER_MOBILENO,0,1,@CreatedBy)
		SET @result = SCOPE_IDENTITY()
		insert into IVAP_MST_Passlink (UID,KeyType,RandomKey) values (@result,'New User',@PassToken);
		EXEC User_History @result,@CreatedBy,'Create';
	END
	ELSE
	BEGIN
		UPDATE IVAP_MST_USER 
		SET ENTITY_ID=@ENITYTID,USERID=@USERID,USER_FIRSTNAME=@USER_FIRSTNAME,USER_LASTNAME=@USER_LASTNAME,USER_EMAIL=@USER_EMAIL,USER_ROLE=@USER_ROLE,
			USER_MOBILENO=@USER_MOBILENO,UPDATED_BY=@CreatedBy,UPDATED_ON=GETDATE()
		WHERE UID = @UID
		EXEC User_History @UID,@CreatedBy,'Update';
		SET @result = 0
	END
	SELECT @result AS Result
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateUserProfile]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[AddUpdateUserProfile]
(
@p_UID int,
@p_USER_FIRSTNAME nvarchar(200),
@p_USER_LASTNAME nvarchar(200),
@p_USER_EMAIL nvarchar(200),
@p_USER_MOBILENO nvarchar(20),
@p_USER_PROFILEPIC varchar(max),
@p_CreatedBy int
)
AS
declare @Result int=0
BEGIN
Update ivap_mst_user Set  USER_FIRSTNAME=@p_USER_FIRSTNAME,USER_LASTNAME=@p_USER_LASTNAME,
USER_EMAIL=@p_USER_EMAIL,USER_MOBILENO=@p_USER_MOBILENO,
PROFILE_PIC=@p_USER_PROFILEPIC,
UPDATED_BY=@p_createdby where uid=@p_uid
Exec User_History @p_UID,@p_CreatedBy,'Update'
select @Result
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateWorkFlowSetting]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddUpdateWorkFlowSetting]
(
	@ENTITY_ID INT,
	@FILE_ID int,
	@USER_ROLE int,
 @ORDERING int,
@CREATED_BY INT,
@ISChek int=0
)
AS
BEGIN
	DECLARE @result INT =0;
	DECLARE @Cout INT =0
	set @Cout=(select count(*) from IVAP_MST_WorkFlowSetting where ENTITY_ID=@ENTITY_ID and FILE_ID=@FILE_ID and USER_ROLE=@USER_ROLE)
	IF(@Cout =0 and @ISChek=1)
	BEGIN
		INSERT INTO IVAP_MST_WorkFlowSetting(ENTITY_ID,FILE_ID,USER_ROLE,ORDERING,CREATED_ON,CREATED_BY)
		VALUES(@ENTITY_ID,@FILE_ID,@USER_ROLE,@ORDERING,GETDATE(),@CREATED_BY)
		SET @result = SCOPE_IDENTITY();
	  EXEC Workflowsetting_History @result,@CREATED_BY,'Create'
	END
	if(@Cout >0 and @ISChek=1)
	BEGIN
		UPDATE IVAP_MST_WorkFlowSetting SET
		ENTITY_ID=@ENTITY_ID,FILE_ID=@FILE_ID,USER_ROLE=@USER_ROLE,ORDERING=@ORDERING,
		UPDATED_BY=@CREATED_BY,
		UPDATED_ON=GETDATE()
			WHERE  ENTITY_ID=@ENTITY_ID and FILE_ID=@FILE_ID and USER_ROLE=@USER_ROLE
			SET @result =0
			EXEC Workflowsetting_History @result ,@CREATED_BY,'Update'
	END
	
	if(@Cout >0 and @ISChek=0)
	BEGIN
	delete from IVAP_MST_WorkFlowSetting where ENTITY_ID=@ENTITY_ID and FILE_ID=@FILE_ID and USER_ROLE=@USER_ROLE
		SET @result =2
			EXEC Workflowsetting_History @result,@CREATED_BY,'Delete'
	end
	SELECT @result AS result
END 
GO
/****** Object:  StoredProcedure [dbo].[ApprovalTempTableData]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ApprovalTempTableData](@TempTableName varchar(100),@TempTID int)
as
begin
DECLARE @result INT =0;
DECLARE @SqlQuery NVARCHAR(500)  ;
   DECLARE @ParmDefinition nvarchar(Max); 
set @SqlQuery= 'update ' +@TempTableName+ ' set TEMP_STATUS=''Awaiting Approval'' where TID='+convert(varchar(10),@TempTID) 
 SET @ParmDefinition = N'@TempTableName varchar(100),@TempTID int'; 
  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition,@TempTableName,@TempTID
  SET @result=1;
  SELECT @result;
end
GO
/****** Object:  StoredProcedure [dbo].[ApprovedTempTableData]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ApprovedTempTableData](@TempTableName varchar(100),@FileID int,  @Status varchar(100)='Awatting Cleint Approval')
as
begin
DECLARE @result INT =0;
DECLARE @SqlQuery NVARCHAR(500)  ;
   DECLARE @ParmDefinition nvarchar(Max); 
set @SqlQuery= 'update ' +@TempTableName+ ' set TEMP_STATUS='''+@Status+''' where FILE_ID='+convert(varchar(10),@FileID) 
 --PRINT @SqlQuery
 SET @ParmDefinition = N'@TempTableName varchar(100),@FileID int'; 
  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition,@TempTableName,@FileID
  SET @result=1;
  SELECT @result;
 --SELECT @SqlQuery
end
GO
/****** Object:  StoredProcedure [dbo].[AuthenticateUser]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AuthenticateUser]
(
    @Userid NVARCHAR(100)='MS001'
)
AS
begin
  DECLARE  @PasstryMinutes float
  DECLARE   @InvalidPassTryCount int
  SELECT  @PasstryMinutes=datediff(minute,getdate(),LAST_PASSWORD_TRY_DATE) ,
  @InvalidPassTryCount=isnull(PASSWORD_TRY,0) FROM IVap_MST_USER WHERE Userid=@Userid AND Isact=1;

  IF(@InvalidPassTryCount > 5 AND @PasstryMinutes > 30)
    UPDATE IVap_MST_USER SET Password_try = 0,LAST_PASSWORD_TRY_DATE = getdate() WHERE Userid =@Userid AND Isact=1; 
  
  select U.UID,U.USERID,password,U.USER_FIRSTNAME,U.USER_LASTNAME,U.USER_EMAIL,ENTITY_ID,
  Isauth,U.PROFILE_PIC AS PROFILEPIC,U.USER_MOBILENO,'' As LastLogin,
  R.Rolename
AS
  Rolename, U.User_Role,isnull(Password_Try,0)
AS
  Passwordtry, Datediff(Day,getdate(),u.Password_Last_Updated)
AS
  PassChangeDayCount FROM IVap_MST_USER U
  inner join IVap_MST_USERROLE R on R.TID=U.USER_ROLE
  WHERE U.Userid=@Userid AND U.Isact=1;
  UPDATE IVap_MST_USER
  SET PASSWORD_TRY     =isnull(PASSWORD_TRY,0)+1,LAST_PASSWORD_TRY_DATE=getdate()
  WHERE upper( Userid)= upper(@Userid);
END

--select * from Ivap_LOG_USER ENTITY_ID

--select * from IVap_MST_USER
GO
/****** Object:  StoredProcedure [dbo].[AuthenticateUser_EID]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AuthenticateUser_EID]
(
    @Userid NVARCHAR(100)='MS001',
	@DomainName VARCHAR(20)
)
AS
begin
  DECLARE   @PasstryMinutes float
  DECLARE   @InvalidPassTryCount int
  DECLARE   @EID INT
  SET @EID=(select top 1 TID from Ivap_Mst_Entity WHERE Domain_Name= @DomainName AND ISACTIVE=1)
  SELECT  @PasstryMinutes=datediff(minute,getdate(),LAST_PASSWORD_TRY_DATE) ,
  @InvalidPassTryCount=isnull(PASSWORD_TRY,0) FROM IVap_MST_USER WHERE Userid=@Userid AND Isact=1 AND ENTITY_ID=@EID;

  IF(@InvalidPassTryCount > 5 AND @PasstryMinutes > 30)
    UPDATE IVap_MST_USER SET Password_try = 0,LAST_PASSWORD_TRY_DATE = getdate() WHERE Userid =@Userid AND Isact=1 AND ENTITY_ID=@EID; 
  
  select U.UID,U.USERID,password,U.USER_FIRSTNAME,U.USER_LASTNAME,U.USER_EMAIL,ENTITY_ID,
  Isauth,U.PROFILE_PIC AS PROFILEPIC,U.USER_MOBILENO,'' As LastLogin,
  R.Rolename AS Rolename, U.User_Role,isnull(Password_Try,0) AS Passwordtry, Datediff(Day,getdate(),u.Password_Last_Updated) AS PassChangeDayCount FROM IVap_MST_USER U
  inner join IVap_MST_USERROLE R on R.TID=U.USER_ROLE
  WHERE U.Userid=@Userid AND U.Isact=1 AND ENTITY_ID=@EID;
  UPDATE IVap_MST_USER
  SET PASSWORD_TRY     =isnull(PASSWORD_TRY,0)+1,LAST_PASSWORD_TRY_DATE=getdate()
  WHERE upper( Userid)= upper(@Userid) AND ENTITY_ID=@EID;
END

--select * from Ivap_LOG_USER ENTITY_ID

--select * from IVap_MST_USER

--select * from IVAP_MST_ENTITY
GO
/****** Object:  StoredProcedure [dbo].[BANK_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BANK_History]  
(  
 @BANKID INT,  
 @CREATED_BY INT,  
 @Action VARCHAR(50)  
)  
AS  
BEGIN  
 INSERT INTO IVAP_HIS_BANK(  
 BANKID,  
ENTITY_ID,  
BANK_CODE,  
BANK_NAME,  
BANK_ADDR,  
BANK_CITY,  
BANK_STATE,  
BANK_PIN,  
BANK_PHONE,  
CREATED_ON,  
CREATED_BY,  
ISACTIVE,
GLOBAL_BANK_ID,  
ACTION  
)  
 SELECT  
  TID,  
 ENTITY_ID,  
BANK_CODE,  
BANK_NAME,  
BANK_ADDR,  
BANK_CITY,  
BANK_STATE,  
BANK_PIN,  
BANK_PHONE,  
  GETDATE(),  
  @CREATED_BY,  
  ISACTIVE,
  GLOBAL_BANK_ID,  
  @Action   
  FROM IVAP_MST_BANK  
  WHERE TID =@BANKID  
END  
GO
/****** Object:  StoredProcedure [dbo].[Calendar_Setup_His]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Calendar_Setup_His]
(
	@TID INT,
	@Updated_BY INT,
	@Action VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_Calendar_setup(CALENDARID,ENTITY_ID,CALENDAR_TYPE,FILE_TYPE,DESCRIPTION,PAY_DATE,DUE_DATE,REMAINDER_DAYS,EVENT,FREQUENCY,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,ACTION)
		SELECT TID,ENTITY_ID,CALENDAR_TYPE,FILE_TYPE,DESCRIPTION,PAY_DATE,DUE_DATE,REMAINDER_DAYS,EVENT,FREQUENCY,CREATED_ON,CREATED_BY,GETDATE(),@Updated_BY,ISACTIVE,@Action
		 FROM ivap_Calendar_setup WHERE TID =@TID
END
GO
/****** Object:  StoredProcedure [dbo].[ChangeMenuStatus]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ChangeMenuStatus]
(
	@TID INT,
	@IsAct INT
)
AS
BEGIN
	UPDATE IVAP_MST_MENU SET ISACT =@IsAct WHERE TID=@TID
	SELECT 0 AS result
END
GO
/****** Object:  StoredProcedure [dbo].[ChangePassword]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ChangePassword]
(
  @P_UID int ,
  @P_PASSWORD varchar(250)
)
as
declare @HISPASS_COUNT int=0,@RESULT int=0
begin
 --SELECT @HISPASS_COUNT= COUNT(*) from (select top 3 * from ivap_HIS_PASSWORD where UID=@P_UID and UPPER(password)=UPPER(@P_PASSWORD) order by TID desc)
 --SET @HISPASS_COUNT = (SELECT COUNT(*) FROM (select top 3 * from ivap_HIS_PASSWORD where UID=@P_UID and UPPER(password)=UPPER(@P_PASSWORD) order by TID desc))
 SET @HISPASS_COUNT=  (SELECT TOP 3 COUNT(*)  from ivap_HIS_PASSWORD where UID=@P_UID and UPPER( password)=UPPER(@P_PASSWORD))
  if(@HISPASS_COUNT > 0)
  begin
    set @RESULT=0
	select @RESULT as result
    return;
  end
  update ivap_MST_USER set password=@P_PASSWORD,PASSWORD_LAST_UPDATED=GETDATE() WHERE UID=@P_UID
  insert into IVAP_HIS_PASSWORD(UID,password,CREATED_ON) values(@P_UID,@P_PASSWORD,getdate())
  set @RESULT=1
  select @RESULT as result
END
GO
/****** Object:  StoredProcedure [dbo].[CheckMataMasterCount]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CheckMataMasterCount](@ENTITYID INT =0,@SCREENNAME VARCHAR(50)='',@DISPLAY_NAME VARCHAR(50)='',@DISPLAY_ORDER int =0,@TID int =0)
	   as
	   begin
	   DECLARE @result INT =0
	  
			IF Exists(SELECT * FROM IVAP_META_MASTER WHERE DISPLAY_NAME = @DISPLAY_NAME AND SCREEN_NAME = @SCREENNAME and ENTITY_ID= @ENTITYID and TID<>@TID )
		BEGIN
			SET @result = 3
			SELECT @result as result
			RETURN;
		END
		--IF Exists(SELECT * FROM IVAP_META_MASTER WHERE DISPLAY_ORDER = @DISPLAY_ORDER AND SCREEN_NAME = @SCREENNAME and ENTITY_ID= @ENTITYID and TID<>@TID )
		--BEGIN
		--	SET @result = 2
		--	SELECT @result as result
		--	RETURN;
		--END
		  SET @result = 0
			SELECT @result as result
	   end


GO
/****** Object:  StoredProcedure [dbo].[CheckPublistStatus]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE Procedure [dbo].[CheckPublistStatus]  
(  
 @EntityID int=1  
)  
as  
begin  
DECLARE @Ivap_HR_Table_Name varchar(50);   
DECLARE @Ivap_SAL_Table_Name varchar(50);   
DECLARE @Ivap_Temp_Table_Name varchar(50);  
set @Ivap_HR_Table_Name= 'Ivap_HRD_MAST_'+cast(@EntityID as varchar(10));  
set @Ivap_SAL_Table_Name= 'Ivap_PAY_MAST_'+cast(@EntityID as varchar(10));  
set @Ivap_Temp_Table_Name= 'Ivap_MAST_TEMP_'+cast(@EntityID as varchar(10));  
  
select Name from sys.objects where type='U' and name=@Ivap_HR_Table_Name   
select Name from sys.objects where type='U' and name =@Ivap_SAL_Table_Name;  
select Name from sys.objects where type='U' and name =@Ivap_Temp_Table_Name;  

  
end
GO
/****** Object:  StoredProcedure [dbo].[CLASS_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELPTEXT CLASS_HISTORY

  
  
CREATE PROC [dbo].[CLASS_HISTORY]  
(  
@CID INT,   
@UpdatedBy INT,    
@Action VARCHAR(100)              
)  
AS  
BEGIN  
INSERT INTO IVAP_HIS_CLASS(CID,ENTITY_ID,PAY_CLASS_CODE,ERP_CLASS_CODE,CLASS_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION)  
SELECT TID,ENTITY_ID,PAY_CLASS_CODE,ERP_CLASS_CODE,CLASS_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_CLASS  
END

GO
/****** Object:  StoredProcedure [dbo].[Company_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[Company_History]  
(  
 @COMPID INT,  
 @Updated_BY INT,  
 @Action VARCHAR(50)  
)  
AS  
BEGIN  
 INSERT INTO IVAP_HIS_COMPANY(  
  COMPID,  
  EID,  
  COMP_CODE,  
  COMP_NAME,  
  COMP_ADDR1,  
  COMP_ADDR2,  
  COMP_CITY,  
  COMP_STATE,  
  COMP_PIN,  
  COMP_CLASS,  
  COMP_PANNO,  
  COMP_TANNO,  
  COMP_TDSCIRCLE,  
  SIGN_FNAME,  
  SIGN_LNAME,  
  SIGN_FATHER_NAME,  
  SIGN_ADDR1,  
  SIGN_ADDR2,  
  SIGN_CITY,  
  SIGN_DSG,  
  SIGN_STATE,  
  SIGN_PIN,  
  SIGN_PLACE,  
  SIGN_DATE,  
  RETIRE_AGE,  
  EMP_CODE_GEN,  
  EMP_CODE_PREFIX,  
  EMP_CODE_LEN,  
  Comp_Logo,  
  COMP_URL,  
  CREATED_ON,  
  CREATED_BY,  
  UPDATED_ON,  
  UPDATED_BY,  
  ISACTIVE,  
  ACTION  
 )  
 SELECT  
  TID,  
  ENTITY_ID,  
  COMP_CODE,  
  COMP_NAME,  
  COMP_ADDR1,  
  COMP_ADDR2,  
  COMP_CITY,  
  COMP_STATE,  
  COMP_PIN,  
  COMP_CLASS,  
  COMP_PANNO,  
  COMP_TANNO,  
  COMP_TDSCIRCLE,  
  SIGN_FNAME,  
  SIGN_LNAME,  
  SIGN_FATHER_NAME,  
  SIGN_ADDR1,  
  SIGN_ADDR2,  
  SIGN_CITY,  
  SIGN_DSG,  
  SIGN_STATE,  
  SIGN_PIN,  
  SIGN_PLACE,  
  SIGN_DATE,  
  RETIRE_AGE,  
  EMP_CODE_GEN,  
  EMP_CODE_PREFIX,  
  EMP_CODE_LEN,  
  Comp_Logo,  
  COMP_URL,  
  CREATED_ON,  
  CREATED_BY,  
  GETDATE(),  
  @Updated_BY,  
  ISACTIVE,  
  @Action   
  FROM IVAP_MST_COMPANY   
  WHERE TID =@COMPID  
END
GO
/****** Object:  StoredProcedure [dbo].[Component_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Component_History]
(
	@ComponentID INT,
	@CREATED_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_COMPONENT(
		COMPONENT_ID,
		COMPONENT_FILE_TYPE,
		COMPONENT_TYPE,
		COMPONENT_SUB_TYPE,
		COMPONENT_NAME,
		COMPONENT_DATATYPE,
		COMPONENT_DISPLAY_NAME,
		COMPONENT_DESCRIPTION,
		MIN_LENGTH,
		MAX_LENGTH,
		MANDATORY,
		CREATED_ON,
		CREATED_BY,
		UPDATE_ON,
		UPDATED_BY,
		ISACTIVE,
		ACTION)
	SELECT
		TID,
		COMPONENT_FILE_TYPE,
		COMPONENT_TYPE,
		COMPONENT_SUB_TYPE,
		COMPONENT_NAME,
		COMPONENT_DATATYPE,
		COMPONENT_DISPLAY_NAME,
		COMPONENT_DESCRIPTION,
		MIN_LENGTH,
		MAX_LENGTH,
		MANDATORY,
		CREATED_ON,
		@CREATED_BY,
		GETDATE(),
		UPDATED_BY,
		ISACTIVE,
		@Action 
		FROM IVAP_MST_COMPONENT
		WHERE TID =@ComponentID
END

GO
/****** Object:  StoredProcedure [dbo].[COPYRIGHTTOANOTHERUSER]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[COPYRIGHTTOANOTHERUSER]
(
@UID INT,
@COPYUSER INT
)
AS
BEGIN
INSERT INTO IVAP_DATA_ACCESS_DTL(UID,TABLE_NAME,TIDS,CREATED_BY,CREATED_ON,ISACTIVE) SELECT @UID,TABLE_NAME,TIDS,CREATED_BY,CREATED_ON,ISACTIVE  FROM IVAP_DATA_ACCESS_DTL WHERE UID=@COPYUSER
END
GO
/****** Object:  StoredProcedure [dbo].[CostCentre_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CostCentre_History]
(
	@COSTCENID INT,
	@Updated_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_COSTCENTRE(
		COSTCENID,
		ENTITY_ID,
		PAY_COST_CODE,
		ERP_COST_CODE,
		COST_NAME,
		CREATED_ON,
		CREATED_BY,
		UPDATED_ON,
		UPDATED_BY,
		ISACTIVE,
		ACTION)
	SELECT
		TID,
		ENTITY_ID,
		PAY_COST_CODE,
		ERP_COST_CODE,
		COST_NAME,
		CREATED_ON,
		CREATED_BY,
		GETDATE(),
		@Updated_BY,
		ISACTIVE,
		@Action 
		FROM IVAP_MST_COSTCENTRE 
		WHERE TID =@COSTCENID
END
GO
/****** Object:  StoredProcedure [dbo].[CREATE_ComponentEntity_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[CREATE_ComponentEntity_History]
(
	@CompEntityID INT,
	@CREATED_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
IF Exists(SELECT * FROM IVAP_HIS_COMPONENT_ENTITY WHERE  CompEntityID = @CompEntityID)
BEGIN

INSERT INTO IVAP_HIS_COMPONENT_ENTITY(CompEntityID,Globle_Component_ID,ENTITY_ID,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH
,MAX_LENGTH,MANDATORY,ISACTIVE,UPDATE_ON,CREATED_BY,ACTION)
	select TID,Globle_Component_ID,ENTITY_ID,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH
,MAX_LENGTH,MANDATORY,ISACTIVE,GETDATE(),@CREATED_BY,@Action  from
	 IVAP_MST_COMPONENT_ENTITY where tid =@CompEntityID
END
ELSE
		BEGIN
		INSERT INTO IVAP_HIS_COMPONENT_ENTITY(CompEntityID,Globle_Component_ID,ENTITY_ID,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,
		COMPONENT_DISPLAY_NAME,MIN_LENGTH,MAX_LENGTH,MANDATORY,ISACTIVE,CREATED_ON,CREATED_BY,ACTION)
	select TID,Globle_Component_ID,ENTITY_ID,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH
,MAX_LENGTH,MANDATORY,ISACTIVE,GETDATE(),@CREATED_BY,@Action  from
	 IVAP_MST_COMPONENT_ENTITY where tid =@CompEntityID
		END
END
GO
/****** Object:  StoredProcedure [dbo].[CREATE_FUNCTION_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CREATE_FUNCTION_History]
(
	@FunctionID INT,
	@CREATED_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
IF Exists(SELECT * FROM IVAP_MST_FUNCTION WHERE  TID = @FunctionID)
BEGIN
	INSERT INTO IVAP_HIS_FUNCTION(FUNCTIONID,ENTITY_ID,PAY_FUNC_CODE,ERP_FUNC_CODE,FUNC_NAME,ISACTIVE,UPDATE_ON
	,CREATED_BY,ACTION)
	SELECT TID,ENTITY_ID,PAY_FUNC_CODE,ERP_FUNC_CODE,FUNC_NAME,ISACTIVE,GETDATE(),@CREATED_BY,@Action 
		FROM IVAP_MST_FUNCTION WHERE TID =@FunctionID
END
ELSE
		BEGIN
		INSERT INTO IVAP_HIS_FUNCTION(FUNCTIONID,ENTITY_ID,PAY_FUNC_CODE,ERP_FUNC_CODE,FUNC_NAME,ISACTIVE,CREATED_ON,CREATED_BY,ACTION)
	     SELECT TID,ENTITY_ID,PAY_FUNC_CODE,ERP_FUNC_CODE,FUNC_NAME,ISACTIVE,GETDATE(),@CREATED_BY,@Action 
		FROM IVAP_MST_FUNCTION WHERE TID =@FunctionID
		END
END

GO
/****** Object:  StoredProcedure [dbo].[CREATE_GRAD_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[CREATE_GRAD_History]
(
	@Grad_ID INT,
	@CREATED_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
IF Exists(SELECT * FROM IVAP_MST_GRADE WHERE  TID = @Grad_ID)
BEGIN
	INSERT INTO IVAP_HIS_GRADE(GRAD_ID,ENTITY_ID,PAY_GRADE_CODE,ERP_GRADE_CODE,GARDE_NAME,GRADE_SCALE_FROM,GRADE_SCALE_TO,GRADE_MIDPOINT,Prob_Period,ISACTIVE,UPDATE_ON,CREATED_BY,ACTION)
	  SELECT TID,ENTITY_ID,PAY_GRADE_CODE,ERP_GRADE_CODE,GARDE_NAME,GRADE_SCALE_FROM,GRADE_SCALE_TO,GRADE_MIDPOINT,Prob_Period,ISACTIVE,GETDATE(),@CREATED_BY,@Action 
		FROM IVAP_MST_GRADE WHERE TID =@Grad_ID
END
ELSE
		BEGIN
		INSERT INTO IVAP_HIS_GRADE(GRAD_ID,ENTITY_ID,PAY_GRADE_CODE,ERP_GRADE_CODE,GARDE_NAME,GRADE_SCALE_FROM,GRADE_SCALE_TO,GRADE_MIDPOINT,Prob_Period,ISACTIVE,CREATED_ON,CREATED_BY,ACTION)
	     SELECT TID,ENTITY_ID,PAY_GRADE_CODE,ERP_GRADE_CODE,GARDE_NAME,GRADE_SCALE_FROM,GRADE_SCALE_TO,GRADE_MIDPOINT,Prob_Period,ISACTIVE,GETDATE(),@CREATED_BY,@Action 
		FROM IVAP_MST_GRADE WHERE TID =@Grad_ID
		END
END

GO
/****** Object:  StoredProcedure [dbo].[CREATE_PTAX_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[CREATE_PTAX_History]
(
	@PTAXID INT,
	@CREATED_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
IF Exists(SELECT * FROM IVAP_MST_PTAX WHERE  TID = @PTAXID)
BEGIN
	INSERT INTO IVAP_HIS_PTAX(PTAXID,STATE_ID,PERIOD_FLAG,DED_MONTH,YTD_MONTH_FROM,EFF_FROM_DT,EFF_TO_DT,
YTD_MONTH_TO,PT_SAL_FROM,PT_SAL_TO,GENDER,PTAX,UPDATE_ON,CREATED_BY,ACTION
)
	SELECT TID,STATE_ID,PERIOD_FLAG,DED_MONTH,YTD_MONTH_FROM,EFF_FROM_DT,EFF_TO_DT,
YTD_MONTH_TO,PT_SAL_FROM,PT_SAL_TO,GENDER,PTAX,GETDATE(),@CREATED_BY,@Action 
		FROM IVAP_MST_PTAX
		WHERE TID =@PTAXID
END
ELSE
		BEGIN
		INSERT INTO IVAP_HIS_PTAX(PTAXID,STATE_ID,PERIOD_FLAG,DED_MONTH,YTD_MONTH_FROM,EFF_FROM_DT,EFF_TO_DT,
YTD_MONTH_TO,PT_SAL_FROM,PT_SAL_TO,GENDER,PTAX,CREATED_ON,CREATED_BY,ACTION
)
	SELECT TID,STATE_ID,PERIOD_FLAG,DED_MONTH,YTD_MONTH_FROM,EFF_FROM_DT,EFF_TO_DT,
YTD_MONTH_TO,PT_SAL_FROM,PT_SAL_TO,GENDER,PTAX,GETDATE(),@CREATED_BY,@Action 
		FROM IVAP_MST_PTAX
		WHERE TID =@PTAXID
		END
END
GO
/****** Object:  StoredProcedure [dbo].[CreateEntity]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[CreateEntity]
(
	@ENTITY_NAME	varchar(200),
	@ENTITY_ADDR1	varchar(500),
	@ENTITY_ADDR2	varchar(500)='',
	@ENTITY_CITY	varchar(50),
	@ENTITY_STATE	int,
	@ENTITY_PIN	varchar(10),
	@CREATED_BY	int,
	@DOMAIN_NAME	varchar(50),
	@CURRENCY INT,
	@DATE_FORMAT VARCHAR(30),
	@COUNTRY INT,
	@PAY_PERIOD VARCHAR(30)
)

AS
BEGIN
	Declare @EID INT;
	Declare @ECode VARCHAR(10);
	Declare @LeadingZero VARCHAR(10);
	if  exists(select * from IVAP_MST_ENTITY where DOMAIN_NAME=@DOMAIN_NAME )
	BEGIN
		select -1;
		return;
	END
	if not exists(select * from IVAP_MST_ENTITY where ENTITY_NAME=@ENTITY_NAME )
	BEGIN
		insert into IVAP_MST_ENTITY(ENTITY_NAME,ENTITY_ADDR1,ENTITY_ADDR2,ENTITY_CITY,ENTITY_STATE,ENTITY_PIN,CREATED_BY,DOMAIN_NAME,COUNTRY,CURRENCY,DATE_FORMAT,PAY_PERIOD,ENTITY_CODE,ISActive)
		values(@ENTITY_NAME,@ENTITY_ADDR1,@ENTITY_ADDR2,@ENTITY_CITY,@ENTITY_STATE,@ENTITY_PIN,@CREATED_BY,@DOMAIN_NAME,@COUNTRY,@CURRENCY,@DATE_FORMAT,@PAY_PERIOD,'',1);
		set @EID=SCOPE_IDENTITY();
		if(len(@EID)=1)
			SET @LeadingZero='0000';
		else if(len(@EID)=2)
			SET @LeadingZero='000';
		else if(len(@EID)=3)
			SET @LeadingZero='00';
		else if(len(@EID)=4)
			SET @LeadingZero='0';
		else
			SET @LeadingZero='';

			SET @ECode=(select upper(SUBSTRING(@ENTITY_NAME, 1, 1))+@LeadingZero+CAST(@EID As VARCHAR))
			update IVAP_MST_ENTITY Set ENTITY_CODE=@ECode where TID=@EID;
			select @EID;
	END
	ELSE
	select 0

END

--select * from IVAP_MST_ENTITY
GO
/****** Object:  StoredProcedure [dbo].[CreateEntity_1]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[CreateEntity_1]
(
	@ENTITY_NAME	varchar(200),
	@ENTITY_ADDR1	varchar(500),
	@ENTITY_ADDR2	varchar(500)='',
	@ENTITY_CITY	varchar(50),
	@ENTITY_STATE	int,
	@ENTITY_PIN	varchar(10),
	@CREATED_BY	int,
	@DOMAIN_NAME	varchar(50),
	@CURRENCY INT,
	@DATE_FORMAT VARCHAR(30),
	@COUNTRY INT,
	@PAY_PERIOD VARCHAR(30),
	@Payperiod_Weekly_Fr VARCHAR(30)='',
	@Payperiod_Weekly_To VARCHAR(30)='',
	@Payperiod_Monthly_Fr int,
	@Payperiod_Monthly_To int,
	@Payperiod_Fortnightly_Fr1 int,
	@Payperiod_Fortnightly_To1 int,
	@Payperiod_Fortnightly_Fr2 int,
	@Payperiod_Fortnightly_To2 int,
	@Services_Availed int
)

AS
BEGIN
	Declare @EID INT;
	Declare @ECode VARCHAR(10);
	Declare @LeadingZero VARCHAR(10);
	if  exists(select * from IVAP_MST_ENTITY where DOMAIN_NAME=@DOMAIN_NAME )
	BEGIN
		select -1;
		return;
	END
	if not exists(select * from IVAP_MST_ENTITY where ENTITY_NAME=@ENTITY_NAME )
	BEGIN
		insert into IVAP_MST_ENTITY(ENTITY_NAME,ENTITY_ADDR1,ENTITY_ADDR2,ENTITY_CITY,ENTITY_STATE,ENTITY_PIN,CREATED_BY,DOMAIN_NAME,COUNTRY,CURRENCY,
		DATE_FORMAT,PAY_PERIOD,ENTITY_CODE,ISActive,Payperiod_Weekly_Fr,Payperiod_Weekly_To,Payperiod_Monthly_Fr,Payperiod_Monthly_To,Payperiod_Fortnightly_Fr1,
		Payperiod_Fortnightly_To1,Payperiod_Fortnightly_Fr2,Payperiod_Fortnightly_To2,Services_Availed)
		values(@ENTITY_NAME,@ENTITY_ADDR1,@ENTITY_ADDR2,@ENTITY_CITY,@ENTITY_STATE,@ENTITY_PIN,@CREATED_BY,@DOMAIN_NAME,@COUNTRY,@CURRENCY,
		@DATE_FORMAT,@PAY_PERIOD,'',1,@Payperiod_Weekly_Fr,@Payperiod_Weekly_To,@Payperiod_Monthly_Fr,@Payperiod_Monthly_To,@Payperiod_Fortnightly_Fr1,
		@Payperiod_Fortnightly_To1,@Payperiod_Fortnightly_Fr2,@Payperiod_Fortnightly_To2,@Services_Availed);
		set @EID=SCOPE_IDENTITY();
		if(len(@EID)=1)
			SET @LeadingZero='0000';
		else if(len(@EID)=2)
			SET @LeadingZero='000';
		else if(len(@EID)=3)
			SET @LeadingZero='00';
		else if(len(@EID)=4)
			SET @LeadingZero='0';
		else
			SET @LeadingZero='';

			SET @ECode=(select upper(SUBSTRING(@ENTITY_NAME, 1, 1))+@LeadingZero+CAST(@EID As VARCHAR))
			update IVAP_MST_ENTITY Set ENTITY_CODE=@ECode where TID=@EID;
			select @EID;
	END
	ELSE
	select 0

END

--select * from IVAP_MST_ENTITY
GO
/****** Object:  StoredProcedure [dbo].[CURRENCY_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CURRENCY_HISTORY]
(
@CID INT,     
@UpdatedBy INT,      
@Action VARCHAR(100) 
)
AS
BEGIN

INSERT INTO IVAP_HIS_CURRENCY(CID,CURRENCY_CODE,CURRENCY_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION)    
SELECT TID,CURRENCY_CODE,CURRENCY_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_CURRENCY
END
GO
/****** Object:  StoredProcedure [dbo].[DATA_ACCESSCONTROL_INSERT]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
  
CREATE PROC [dbo].[DATA_ACCESSCONTROL_INSERT]  
(  
 @UID INT,  
 @TABLE_NAME NVARCHAR(50),  
 @TID NVARCHAR(MAX)  
  
)  
 AS  
 BEGIN  
    DECLARE @TIDS_VAL nvarchar(max);  
  
   SELECT @TIDS_VAL=TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID=@UID AND TABLE_NAME=@TABLE_NAME  
 IF(@TIDS_VAL is not NULL)  
  BEGIN  
  UPDATE IVAP_DATA_ACCESS_DTL SET TIDS=@TIDS_VAL+@TID+',' WHERE UID=@UID AND TABLE_NAME=@TABLE_NAME  
  END  
  
 ELSE  
  BEGIN  
  INSERT INTO IVAP_DATA_ACCESS_DTL(UID,TABLE_NAME,TIDS,CREATED_ON,CREATED_BY,ISACTIVE) VALUES(@UID,@TABLE_NAME,@TID +',',GETDATE(),@UID,'1')  
  END  
  
END  
  
  
GO
/****** Object:  StoredProcedure [dbo].[DeleteCalendarSetup]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteCalendarSetup]
(
	@TID INT,
	@ENTITY_ID INT,
	@UID INT
)
AS
BEGIN
	INSERT INTO IVAP_HIS_Calendar_setup(CALENDARID,ENTITY_ID,CALENDAR_NAME,DESCRIPTION,DUE_DATE,REMAINDER_DAYS,EVENT,FREQUENCY,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,ACTION)
		SELECT TID,ENTITY_ID,CALENDAR_NAME,DESCRIPTION,DUE_DATE,REMAINDER_DAYS,EVENT,FREQUENCY,CREATED_ON,CREATED_BY,GETDATE(),@UID,ISACTIVE,'Delete'
		 FROM ivap_Calendar_setup WHERE TID =@TID

	DELETE FROM IVAP_CALENDAR_SETUP WHERE TID = @TID AND ENTITY_ID =@ENTITY_ID
	SELECT 0 AS result
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteEntityComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[DeleteEntityComponent](@EntityCompID int =0,@EntityID int =0)
as
begin
if exists(select COMPONENT_ID from IVAP_MST_FILE_COMP_DETAIL fil LEFT join  IVAP_MST_FILETYPE TY ON fil.FILE_ID=TY.TID where COMPONENT_ID=@EntityCompID AND ENTITY_ID=@EntityID)
begin
select -1
return
end
DELETE FROM IVAP_MST_COMPONENT_ENTITY WHERE TID=@EntityCompID and ENTITY_ID=@EntityID
SELECT 2
end


GO
/****** Object:  StoredProcedure [dbo].[DeleteFileCompDtl]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_FILE_COMP_DETAIL
CREATE PROC [dbo].[DeleteFileCompDtl]
(
	@FileCompDtlIDs VARCHAR(MAX),
	@EID INT
)
AS
BEGIN
	DELETE FROM IVAP_MST_FILE_COMP_DETAIL WHERE TID  IN (SELECT * FROM [dbo].SplitString(@FileCompDtlIDs,','))
	Select 1 as result
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFileType]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_FILE_COMP_DETAIL
--select * from IVAP_MST_FILETYPE
CREATE PROCEDURE [dbo].[DeleteFileType](@FileID INT,@EID INT)
AS
BEGIN
	DELETE FROM IVAP_MST_FILETYPE WHERE TID =@FileID AND ENTITY_ID =@EID
	DELETE FROM IVAP_MST_FILE_COMP_DETAIL WHERE FILE_ID =@FileID
	SELECT @FileID as result;
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteGlobalComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DeleteGlobalComponent](@GlobalCompID int =0)
as
begin
if exists(select Globle_Component_ID from IVAP_MST_COMPONENT_ENTITY where Globle_Component_ID=@GlobalCompID)
begin
select -1
return
end
DELETE FROM IVAP_MST_COMPONENT WHERE TID=@GlobalCompID 
SELECT 2
end
GO
/****** Object:  StoredProcedure [dbo].[DeleteTempTableData]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[DeleteTempTableData](@File_ID int ,@Effe_Date varchar(100)='',@Pay_Date varchar(100)='' ,@TableName varchar(100))
as
begin
DECLARE @SqlQuery NVARCHAR(500)  ;
   DECLARE @ParmDefinition nvarchar(Max); 
   declare @Result int ;
   set  @Result=0
--select * from Ivap_MAST_TEMP_15 where FILE_ID=@File_ID and TEMP_BATCH_ID=@Batch_TempID
if(@Effe_Date!='' and @Pay_Date!='')
begin
set @SqlQuery= 'delete from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and EFFDATE='''+convert(varchar(15),@Effe_Date)+''' and PAY_DATE='''+convert(varchar(15),@Pay_Date)+''''
set  @Result=1
end
else if(@Effe_Date!='')
begin
set @SqlQuery= 'delete from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and EFFDATE='''+convert(varchar(15),@Effe_Date)+''''
set  @Result=1
end
else if(@Pay_Date!='')
begin
set @SqlQuery= 'delete from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and PAY_DATE='''+convert(varchar(15),@Pay_Date)+''''
set  @Result=1
end
else 
begin
set @SqlQuery= 'delete from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) 
set  @Result=1
end
select @Result
--print  @SqlQuery 
 SET @ParmDefinition = N'@File_ID int,@Effe_Date varchar(100),@Pay_Date varchar(100),@TableName varchar(100)'; 
  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@Effe_Date,@Pay_Date,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[Department_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Department_History]
(
	@DEPTID INT,
	@Updated_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_DEPARTMENT(
		DEPTID,
		ENTITY_ID,
		PAY_DEPT_CODE,
		ERP_DEPT_CODE,
		DEPT_NAME,
		CREATED_ON,
		CREATED_BY,
		UPDATED_ON,
		UPDATED_BY,
		ISACTIVE,
		ACTION)
	SELECT
		TID,
		ENTITY_ID,
		PAY_DEPT_CODE,
		ERP_DEPT_CODE,
		DEPT_NAME,
		CREATED_ON,
		CREATED_BY,
		GETDATE(),
		@Updated_BY,
		ISACTIVE,
		@Action 
		FROM IVAP_MST_DEPARTMENT 
		WHERE TID =@DEPTID
END
GO
/****** Object:  StoredProcedure [dbo].[Designation_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Designation_History]
(
	@DesigID INT,
	@Updated_BY INT,
	@Action VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_DESIGNATION(DESGID,ENTITY_ID,PAY_DSG_CODE,ERP_DSG_CODE,DSG_NAME,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,ACTION)
		SELECT TID,ENTITY_ID,PAY_DSG_CODE,ERP_DSG_CODE,DSG_NAME,CREATED_ON,CREATED_BY,GETDATE(),@Updated_BY,ISACTIVE,@Action
		FROM IVAP_MST_DESIGNATION WHERE TID =@DesigID
END

--select * from IVAP_HIS_DESIGNATION
GO
/****** Object:  StoredProcedure [dbo].[DIVISION_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ivap_mst_Division
CREATE PROC [dbo].[DIVISION_HISTORY]
(
	@DIVIID INT,
	@Updated_By INT,
	@Action VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_DIVISION(DIVIID,ENTITY_ID,PAY_DIVI_CODE,ERP_DIVI_CODE,DIVI_NAME,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,ACTION)
		SELECT TID,ENTITY_ID,PAY_DIVI_CODE,ERP_DIVI_CODE,DIVI_NAME,CREATED_ON,CREATED_BY,GETDATE(),@Updated_By,ISACTIVE,@Action 
		FROM IVAP_MST_DIVISION WHERE TID = @DIVIID

END
GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_SETUP_SAMPLE]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[GET_FILE_SETUP_SAMPLE] 
(    
 @EID INT,    
 @FILE_ID INT  
)    
AS    
BEGIN  

 select COMPONENT_DISPLAY_NAME from IVAP_MST_COMPONENT_ENTITY E  
 INNER JOIN IVAP_MST_FILE_COMP_DETAIL Dtl ON E.TID = dtl.COMPONENT_ID  
 where ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID ORDER BY dtl.Display_Order  
 
END
GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_SETUP_UPLOAD]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_FILE_SETUP_UPLOAD]    
(    
	 @EID INT,    
	 @FILE_ID INT  
)    
AS    
BEGIN    
		 select E.COMPONENT_FILE_TYPE,E.COMPONENT_TYPE,E.COMPONENT_SUB_TYPE,E.COMPONENT_NAME,E.COMPONENT_DATATYPE,E.COMPONENT_DISPLAY_NAME,E.MANDATORY,E.ISACTIVE ,GCo.COMPONENT_TABLE_NAME,GCo.COMPONENT_COLUMN_NAME,GCo.MIN_LENGTH,	GCo.MAX_LENGTH
		 from IVAP_MST_COMPONENT_ENTITY E  INNER JOIN IVAP_MST_FILE_COMP_DETAIL Dtl ON E.TID = dtl.COMPONENT_ID inner join IVAP_MST_COMPONENT GCo on e.Globle_Component_ID=GCo.TID 
		 where Dtl.ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID ORDER BY dtl.Display_Order  
		 --AND TID IN (SELECT COMPONENT_ID FROM IVAP_MST_FILE_COMP_DETAIL WHERE FIle_ID =@FILE_ID)    
END
GO
/****** Object:  StoredProcedure [dbo].[GetBank]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetBank]    
(    
 @BankID INT=0,    
 @ENTITYName varchar(200)='',    
 @ENTITYID INT =0,    
 @StateName varchar(200)='',    
 @ISACT VARCHAR(1)='0',  
 @UID INT=0    
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
    
 SET @SQLString =N' select BK.TID,BK.BANK_CODE,BK.GLOBAL_BANK_ID,GB.BANK_NAME,BK.BANK_ADDR,BK.BANK_CITY,BK.BANK_STATE,BK.BANK_PIN,BK.BANK_PHONE,BK.ENTITY_ID    
 ,ST.STATE_NAME,CASE WHEN BK.ISACTIVE=1 THEN ''Active'' else ''In Active'' end STATUS ,BK.ISACTIVE,ENTITY.ENTITY_NAME ,    
 BK.IFSC,BK.ERP_BANK_CODE,BK.PAY_BANK_CODE    
 from IVAP_MST_BANK BK 
 inner join IVAP_MST_BANK_GLOBAL GB ON BK.GLOBAL_BANK_ID=GB.TID
 LEFT JOIN IVAP_MST_ENTITY ENTITY ON BK.ENTITY_ID =ENTITY.TID LEFT JOIN IVAP_MST_STATE ST ON BK.BANK_STATE=ST.TID    
 WHERE 1 =1'    
 IF(@BankID > 0)    
 BEGIN    
  SET @SQLString+=' AND BK.TID=' + '@BankID'    
 END    
 IF(ISNULL(@ENTITYName,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND ENTITY.ENTITY_NAME=' + '@ENTITYName'    
 END    
 IF(@ENTITYID > 0)    
 BEGIN    
  SET @SQLString+=' AND BK.ENTITY_ID=' + '@ENTITYID'    
 END    
    
 IF(ISNULL(@StateName,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND ST.STATE_NAME=' + '@StateName'    
 END    
 IF(ISNULL(@ISACT,'0') <> '0')    
 BEGIN    
  SET @SQLString+=' AND BK.ISACTIVE=' + '@ISACT'    
 END    
  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND BK.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_BANK''),'',''))'  
 END    
 print @SQLString    
 set @SQLString = @SQLString+' order by TID desc'     
 SET @ParmDefinition = N'@BankID int,@ENTITYName varchar(200),@ENTITYID INT,@StateName varchar(200),@ISACT VARCHAR(1) ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @BankID,@ENTITYName,@ENTITYID,@StateName,@ISACT    
END




GO
/****** Object:  StoredProcedure [dbo].[GetBankHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC [dbo].[GetBankHis]
(
	@BANKID INT
)
AS
BEGIN
 select BKH.TID,BKH.BANK_CODE,BKH.BANK_NAME,BKH.BANK_ADDR,BKH.BANK_CITY,BKH.BANK_PIN,BKH.BANK_PHONE
	,ST.STATE_NAME,CASE WHEN BKH.ISACTIVE=1 THEN 'Active' else 'In Active' end STATUS ,ENTITY.ENTITY_NAME ,BKH.ACTION,BKH.CREATED_BY,BKH.UPDATED_BY,BKH.CREATED_ON
	from IVAP_HIS_BANK BKH LEFT JOIN IVAP_MST_ENTITY ENTITY ON BKH.ENTITY_ID =ENTITY.TID LEFT JOIN IVAP_MST_STATE ST ON BKH.BANK_STATE=ST.TID
	WHERE BKH.BANKID =@BANKID
END
GO
/****** Object:  StoredProcedure [dbo].[GETBATCHNO]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE PROC [dbo].[GETBATCHNO]   
 (  
	 @EID INT=0,  
	 @FILEID NVARCHAR(20)=0  
 )  
 AS  
 BEGIN  
	  DECLARE @SQLQuery AS NVARCHAR(500)  
	  DECLARE @ParameterDefinition AS NVARCHAR(100)  
	  DECLARE @Ivap_Temp_Table_Name VARCHAR(50);  
	  SET @Ivap_Temp_Table_Name='Ivap_MAST_TEMP_'+cast(@EID as varchar(10)); 
	  SET @SQLQuery = 'SELECT MAX(TEMP_BATCH_ID) AS BATCHID FROM ' + @Ivap_Temp_Table_Name + ' WHERE FILE_ID = @FILEID'   
	  SET @ParameterDefinition =  '@FILEID NVARCHAR(20)'  
	  EXECUTE sp_executesql @SQLQuery, @ParameterDefinition, @FILEID 
 END
GO
/****** Object:  StoredProcedure [dbo].[GetCalendar_Setup]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_CALENDAR_TYPE

CREATE PROC [dbo].[GetCalendar_Setup]
(
	@TID INT=0,
	@ENTITY_ID INT=0,
	@CALENDAR_NAME VARCHAR(200)='',
	@IsAct VARCHAR(1)='1'
)
AS
BEGIN
	SET NOCOUNT ON    
	DECLARE @SQLString nvarchar(Max);     
	DECLARE @ParmDefinition nvarchar(Max);
	IF(@IsAct = '0')    
		SET @IsAct ='' 
	SET @SQLString =N'SELECT CS.TID, CS.ENtITY_ID,CS.CALENDAR_TYPE,CS.DESCRIPTION,FORMAT(CS.DUE_DATE,''dd/MM/yyyy'') DUE_DATE,FORMAT(CS.PAY_DATE,''dd/MM/yyyy'') PAY_DATE,CS.REMAINDER_DAYS,CS.EVENT,CS.FREQUENCY,
						CASE WHEN CS.ISACTIVE =1 THEN ''Active'' ELSE ''IN Active'' END STATUS,FORMAT(CS.CREATED_ON,''dd/MM/yyyy'') CREATED_ON,E.ENTITY_NAME,
						E.ENTITY_CODE,CS.ISACTIVE,CT.NAME CALENDAR_TYPE_TEXT,CS.FILE_TYPE
					FROM IVAP_CALENDAR_SETUP CS
					INNER JOIN IVAP_MST_ENTITY E ON CS.ENTITY_ID=E.TID
					INNER JOIN IVAP_MST_CALENDAR_TYPE CT ON CT.TID = CS.CALENDAR_TYPE
					WHERE E.ISACTIVE=1'
	IF(@TID > 0)    
	BEGIN    
		SET @SQLString+=' AND CS.TID=' + '@TID'    
	END
	IF(@ENTITY_ID > 0)    
	BEGIN    
		SET @SQLString+=' AND CS.ENTITY_ID=' + '@ENTITY_ID'
	END
	IF(ISNULL(@CALENDAR_NAME,'') <> '')    
	BEGIN    
		SET @SQLString+=' AND CS.CALENDAR_NAME=' + '@CALENDAR_NAME'    
	END    
	IF(len(@IsAct) > 0)    
	BEGIN    
	SET @SQLString+=' AND CS.ISACTIVE=' + '@IsAct'    
	END
	SET @SQLString = @SQLString+' order by CS.TID desc'     
	SET @ParmDefinition = N'@TID int,@ENTITY_ID INT, @IsAct VARCHAR(1),@CALENDAR_NAME varchar(200) ';     
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @TID,@ENTITY_ID,@IsAct,@CALENDAR_NAME 
END
GO
/****** Object:  StoredProcedure [dbo].[GetCalendar_Setup_His]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCalendar_Setup_His]
(
	@TID INT
)
AS
BEGIN
	SELECT CS.ENtITY_ID,CS.CALENDAR_TYPE,CS.DESCRIPTION,FORMAT(CS.DUE_DATE,'dd/MM/yyyy') DUE_DATE,FORMAT(CS.PAY_DATE,'dd/MM/yyyy') PAY_DATE,CS.REMAINDER_DAYS,CS.EVENT,CS.FREQUENCY,
	CASE WHEN CS.ISACTIVE =1 THEN 'Active' ELSE 'IN Active' END STATUS,FORMAT(CS.CREATED_ON,'dd/MM/yyyy') CREATED_ON,
	E.ENTITY_NAME,E.ENTITY_CODE,CS.ISACTIVE,ACTION,CT.NAME CALENDAR_TYPE_TEXT,CS.FILE_TYPE
	FROM IVAP_HIS_Calendar_SETUP CS
	INNER JOIN IVAP_MST_ENTITY E ON CS.ENTITY_ID=E.TID
	INNER JOIN IVAP_MST_CALENDAR_TYPE CT ON CT.TID = CS.CALENDAR_TYPE
	WHERE E.ISACTIVE=1 AND CALENDARID=@TID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCalendarDtl]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCalendarDtl]
(
	@EID INT,
	@CaledarType INT
)
AS
BEGIN
	select DESCRIPTION,format(DUE_DATE,'yyyy/MM/dd') DUE_DATE from IVAP_CALENDAR_SETUP where Calendar_TYPE =@CaledarType AND ENTITY_ID=@EID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCalendarType]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCalendarType]
AS
BEGIN
	SELECT TID,NAME FROM IVAP_MST_CALENDAR_TYPE
END
GO
/****** Object:  StoredProcedure [dbo].[GetClass]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetClass]                  
(                  
 @ClassID INT=0,                  
 @ClassCode VARCHAR(20)='',     
 @EntityID INT=0,               
 @ClassName VARCHAR(200)='',                  
 @ISAct VARCHAR(1)='0',
 @UID INT=0                  
)                  
AS                  
BEGIN                  
 SET NOCOUNT ON                  
 DECLARE @SQLString nvarchar(Max);                   
 DECLARE @ParmDefinition nvarchar(Max);                  
 IF(@IsAct = '0')                  
  SET @IsAct =''                  
  SET @SQLString =N'SELECT C.TID,C.ENTITY_ID,E.ENTITY_NAME,C.PAY_CLASS_CODE,C.ERP_CLASS_CODE,C.CLASS_NAME,C.ISACTIVE,CASE WHEN C.ISACTIVE=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS FROM IVAP_MST_CLASS C      
  INNER JOIN IVAP_MST_ENTITY E ON C.ENTITY_ID = E.TID                      
   WHERE 1=1'                  
 IF(@ClassID > 0)                  
 BEGIN                  
  SET @SQLString+=' AND C.TID=' + '@ClassID'                  
 END                  
 IF(@EntityID > 0)                  
 BEGIN                  
  SET @SQLString+=' AND C.ENTITY_ID=' + '@EntityID'                  
 END                  
 IF(ISNULL(@ClassName,'') <> '')                  
 BEGIN                  
  SET @SQLString+=' AND CLASS_NAME=' + '@ClassName'                  
 END 
  IF(@UID <> 0)                  
 BEGIN                  
  SET @SQLString=@SQLString+' AND C.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_CLASS''),'',''))'
 END                  
 set @SQLString = @SQLString+' order by TID desc'                   
 SET @ParmDefinition = N'@ClassID int,@ClassCode VARCHAR(20), @IsAct VARCHAR(1),@ClassName varchar(200),@EntityID INT';                   
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @ClassID,@ClassCode,@IsAct,@ClassName,@EntityID                  
END   
    
--  sp_helptext getlocation  
GO
/****** Object:  StoredProcedure [dbo].[GetClassHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetClassHis]          
(          
@CID INT,
@EntityID INT          
)          
AS           
BEGIN          
SELECT C.ENTITY_ID,E.ENTITY_NAME,C.PAY_CLASS_CODE,C.ERP_CLASS_CODE,C.CLASS_NAME,C.CREATED_ON,C.CREATED_BY,C.UPDATE_ON,C.UPDATED_BY,C.ACTION,C.ISACTIVE,CASE WHEN C.ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS FROM IVAP_HIS_CLASS C  
INNER JOIN IVAP_MST_ENTITY E ON C.ENTITY_ID = E.TID           
WHERE C.CID=@CID AND C.ENTITY_ID=@EntityID         
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompany]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--SELECT * FROM IVAP_MST_COMPANY    
CREATE PROC [dbo].[GetCompany]    
(    
 @COMPID INT=0,    
 @EID INT=1,    
 @StateID INT=0,    
 @COMP_CODE VARCHAR(20)='',    
 @COMP_NAME VARCHAR(200)='',    
 @ISACT VARCHAR(1)='0',  
 @UID INT=47    
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
 IF(@ISACT = '0')    
  SET @ISACT =''    
 SET @SQLString =N'SELECT C.TID,C.ENTITY_ID,C.COMP_CODE,C.COMP_NAME,COMP_ADDR1,COMP_ADDR2,COMP_CITY,COMP_STATE,COMP_PIN,COMP_CLASS,COMP_PANNO,COMP_TANNO,COMP_TDSCIRCLE,SIGN_FNAME,    
 SIGN_LNAME,SIGN_FATHER_NAME,SIGN_ADDR1,SIGN_ADDR2,SIGN_CITY,SIGN_DSG,SIGN_STATE,SIGN_PIN,SIGN_PLACE,format(SIGN_DATE,''dd/MM/yyyy'') SIGN_DATE,RETIRE_AGE,EMP_CODE_GEN,EMP_CODE_PREFIX,EMP_CODE_LEN,    
 COMP_LOGO,COMP_URL,C.ISACTIVE,E.ENTITY_CODE,E.ENTITY_NAME,CompS.STATE_NAME AS COMPStateText,Sign_S.STATE_NAME SignStateText,C.ISACTIVE,    
 CASE WHEN C.EMP_CODE_GEN = 1 THEN ''YES'' ELSE ''NO'' END EMP_CODE_GEN_Text,    
 CASE WHEN C.ISACTIVE = 1 THEN ''Active'' ELSE ''In Active'' END STATUS,Class.CLASS_NAME    
 FROM IVAP_MST_COMPANY C    
 INNER JOIN IVAP_MST_ENTITY E ON C.ENTITY_ID = E.TID    
 INNER JOIN IVAP_MST_CLASS Class ON C.COMP_CLASS =Class.TID    
 LEFT OUTER JOIN IVAP_MST_STATE CompS ON C.COMP_STATE = CompS.TID    
 LEFT OUTER JOIN IVAP_MST_STATE Sign_S ON C.COMP_STATE = Sign_S.TID    
 WHERE E.ISACTIVE =1 AND Class.ISACTIVE =1'    
 IF(@COMPID > 0)    
 BEGIN    
  SET @SQLString+=' AND C.TID=' + '@COMPID'    
 END    
 IF(@EID > 0)    
 BEGIN    
  SET @SQLString+=' AND C.ENTITY_ID=' + '@EID'    
 END    
 IF(@StateID > 0)    
 BEGIN    
  SET @SQLString+=' AND C.COMP_STATE=' + '@StateID'    
 END    
 IF(ISNULL(@COMP_CODE,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND C.COMP_CODE=' + '@COMP_CODE'    
 END    
 IF(ISNULL(@COMP_NAME,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND C.COMP_NAME=' + '@COMP_NAME'    
 END    
 IF(len(@ISACT) > 0)    
 BEGIN    
  SET @SQLString+=' AND C.ISACTIVE=' + '@ISACT'    
 END     
 IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND C.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_COMPANY''),'',''))'  
 END   
  
 print @SQLString    
 set @SQLString = @SQLString+' order by TID desc'     
 SET @ParmDefinition = N'@COMPID int,@EID INT,@StateID INT, @COMP_CODE VARCHAR(20),@COMP_NAME varchar(200),@ISACT VARCHAR(1) ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @COMPID,@EID,@StateID,@COMP_CODE,@COMP_NAME,@ISACT    
END 
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCompanyHis]
(
	@CompID INT=1
)
AS
BEGIN
	SELECT C.TID,C.EID,C.COMP_CODE,C.COMP_NAME,COMP_ADDR1,COMP_ADDR2,COMP_CITY,COMP_STATE,COMP_PIN,COMP_CLASS,COMP_PANNO,COMP_TANNO,COMP_TDSCIRCLE,SIGN_FNAME,
	SIGN_LNAME,SIGN_FATHER_NAME,SIGN_ADDR1,SIGN_ADDR2,SIGN_CITY,SIGN_DSG,SIGN_STATE,SIGN_PIN,SIGN_PLACE,format(SIGN_DATE,'dd/MM/yyyy') SIGN_DATE,RETIRE_AGE,EMP_CODE_GEN,EMP_CODE_PREFIX,EMP_CODE_LEN,
	COMP_LOGO,COMP_URL,C.ISACTIVE,E.ENTITY_CODE,E.ENTITY_NAME,CompS.STATE_NAME AS COMPStateText,Sign_S.STATE_NAME SignStateText,
	CASE WHEN C.ISACTIVE = 1 THEN 'Active' ELSE 'In Active' END STATUS,format(C.CREATED_ON,'dd/MM/yyyy') CREATE_ON,format(UPDATED_ON,'dd/MM/yyyy') UPDATED_ON,ACTION
	FROM IVAP_HIS_COMPANY C
	INNER JOIN IVAP_MST_ENTITY E ON C.EID = E.TID
	LEFT OUTER JOIN IVAP_MST_STATE CompS ON C.COMP_STATE = CompS.TID
	LEFT OUTER JOIN IVAP_MST_STATE Sign_S ON C.COMP_STATE = Sign_S.TID
	WHERE E.ISACTIVE =1
END

--select * from IVAP_HIS_COMPANY
GO
/****** Object:  StoredProcedure [dbo].[GetComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetComponent]
(
	@ComponentID INT=0,
	@CompFileType varchar(200)='',
	@ISAct varchar(1)=''
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max);

	SET @SQLString =N'select TID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,
	COMPONENT_DESCRIPTION,ISACTIVE,MIN_LENGTH,MAX_LENGTH,MANDATORY ,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,
	CASE when MANDATORY=1 then ''required''else ''not required'' end MANDATORY_STATUS,CASE WHEN ISACTIVE=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS
	 from IVAP_MST_COMPONENT
	WHERE 1 =1'
	IF(@ComponentID > 0)
	BEGIN
		SET @SQLString+=' AND TID=' + '@ComponentID'
	END

	IF(ISNULL(@CompFileType,'') <> '')
	BEGIN
		SET @SQLString+=' AND COMPONENT_FILE_TYPE=' + '@CompFileType'
	END
	 
	set @SQLString = @SQLString+' order by TID desc' 
	SET @ParmDefinition = N'@ComponentID int,@CompFileType varchar(200) '; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @ComponentID,@CompFileType
END

GO
/****** Object:  StoredProcedure [dbo].[GetComponentEntity]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetComponentEntity]
(
	@EntityCompID INT=0,
	@EntityID INT =0,
	@ISAct varchar(1)='',
	@COMPONENT_FILE_TYPE varchar(50)=''
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max);

	SET @SQLString =N'select COE.TID,COE.COMPONENT_FILE_TYPE,Globle_Component_ID,COMPONENT_TYPE,COMPONENT_COLUMN_NAME,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,
	COMPONENT_DESCRIPTION,COE.ISACTIVE,MIN_LENGTH,case MAX_LENGTH when 0 then 100 when null then 100 else MAX_LENGTH END AS MAX_LENGTH,MANDATORY ,ENTITY.ENTITY_NAME,ISNULL(PMS_CODE,'''') as PMS_CODE,ISNULL(GL_CODE,'''') aS GL_CODE
	,CASE when MANDATORY=1 then ''required''else ''not required'' end MANDATORY_STATUS,CASE WHEN COE.ISACTIVE=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS
	 from IVAP_MST_COMPONENT_ENTITY COE INNER JOIN IVAP_MST_ENTITY ENTITY ON COE.ENTITY_ID=ENTITY.TID
	WHERE 1 =1'
	IF(@EntityCompID > 0)
	BEGIN
		SET @SQLString+=' AND COE.TID=' + '@EntityCompID'
	END
	IF( ISNULL(@COMPONENT_FILE_TYPE,'') != '')
	BEGIN
		SET @SQLString+=' AND COE.COMPONENT_FILE_TYPE=' + '@COMPONENT_FILE_TYPE'
	END

	IF(@EntityID>0)
	BEGIN
		SET @SQLString+=' AND COE.ENTITY_ID=' + '@EntityID'
	END
	 
	set @SQLString = @SQLString+' order by COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME' 

	PRINT @SQLString
	SET @ParmDefinition = N'@EntityCompID int,@EntityID INT ,@ISAct varchar(1),@COMPONENT_FILE_TYPE varchar(50)'; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @EntityCompID,@EntityID,@ISAct,@COMPONENT_FILE_TYPE
END
GO
/****** Object:  StoredProcedure [dbo].[GetComponentEntity1]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetComponentEntity1]
(
	@EntityCompID INT=0,
	@EntityID INT =0,
	@ISAct varchar(1)='',
	@COMPONENT_FILE_TYPE varchar(50)=''
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max);

	SET @SQLString =N'select  max(COE.TID)TID,max(COE.COMPONENT_FILE_TYPE)COMPONENT_FILE_TYPE,max(Globle_Component_ID)Globle_Component_ID,max(COMPONENT_TYPE)COMPONENT_TYPE,max(COMPONENT_COLUMN_NAME)COMPONENT_COLUMN_NAME,max(COMPONENT_SUB_TYPE)COMPONENT_SUB_TYPE,max(COMPONENT_NAME)COMPONENT_NAME,max(COMPONENT_DATATYPE)COMPONENT_DATATYPE,max(COMPONENT_DISPLAY_NAME)COMPONENT_DISPLAY_NAME,
	max(COMPONENT_DESCRIPTION)COMPONENT_DESCRIPTION,max(COE.ISACTIVE)ISACTIVE,max(MIN_LENGTH)MIN_LENGTH,case max(MAX_LENGTH) when 0 then 100 when null then 100 else max(MAX_LENGTH) END AS MAX_LENGTH,max(MANDATORY)MANDATORY ,max(ENTITY.ENTITY_NAME)ENTITY_NAME,ISNULL(max(PMS_CODE),'') as PMS_CODE,ISNULL(max(GL_CODE),'') aS GL_CODE
	,CASE when max(MANDATORY)=1 then ''required''else ''not required'' end MANDATORY_STATUS,CASE WHEN max(COE.ISACTIVE)=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS
	 from IVAP_MST_COMPONENT_ENTITY COE INNER JOIN IVAP_MST_ENTITY ENTITY ON COE.ENTITY_ID=ENTITY.TID
	WHERE 1 =1 '
	IF(@EntityCompID > 0)
	BEGIN
		SET @SQLString+=' AND COE.TID=' + '@EntityCompID'
	END
	IF( ISNULL(@COMPONENT_FILE_TYPE,'') != '')
	BEGIN
		SET @SQLString+=' AND COE.COMPONENT_FILE_TYPE=' + '@COMPONENT_FILE_TYPE'
	END

	IF(@EntityID>0)
	BEGIN
		SET @SQLString+=' AND COE.ENTITY_ID=' + '@EntityID'
	END
	set @SQLString = @SQLString+' group by COMPONENT_NAME' 
	set @SQLString = @SQLString+' order by COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME' 
	--PRINT @SQLString
	SET @ParmDefinition = N'@EntityCompID int,@EntityID INT ,@ISAct varchar(1),@COMPONENT_FILE_TYPE varchar(50)'; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @EntityCompID,@EntityID,@ISAct,@COMPONENT_FILE_TYPE
END
GO
/****** Object:  StoredProcedure [dbo].[GetComponentEntity17]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetComponentEntity17]
(
	@EntityCompID INT=0,
	@EntityID INT =0,
	@ISAct varchar(1)='',
	@COMPONENT_FILE_TYPE varchar(50)=''
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max);
	DECLARE @SQLMString nvarchar(max)

	SET @SQLString =N'select ROW_NUMBER() OVER (PARTITION BY COMPONENT_NAME ORDER BY COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME) ROWNUM, COE.TID,COE.COMPONENT_FILE_TYPE,Globle_Component_ID,COMPONENT_TYPE,COMPONENT_COLUMN_NAME,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,
	COMPONENT_DESCRIPTION,COE.ISACTIVE,MIN_LENGTH,case MAX_LENGTH when 0 then 100 when null then 100 else MAX_LENGTH END AS MAX_LENGTH,MANDATORY ,ENTITY.ENTITY_NAME,ISNULL(PMS_CODE,'''') as PMS_CODE,ISNULL(GL_CODE,'''') aS GL_CODE
	,CASE when MANDATORY=1 then ''required''else ''not required'' end MANDATORY_STATUS,CASE WHEN COE.ISACTIVE=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS
	 from IVAP_MST_COMPONENT_ENTITY COE INNER JOIN IVAP_MST_ENTITY ENTITY ON COE.ENTITY_ID=ENTITY.TID
	WHERE 1 =1 '
	IF(@EntityCompID > 0)
	BEGIN
		SET @SQLString+=' AND COE.TID=' + '@EntityCompID'
	END
	IF( ISNULL(@COMPONENT_FILE_TYPE,'') != '')
	BEGIN
		SET @SQLString+=' AND COE.COMPONENT_FILE_TYPE=' + '@COMPONENT_FILE_TYPE'
	END

	IF(@EntityID>0)
	BEGIN
		SET @SQLString+=' AND COE.ENTITY_ID=' + '@EntityID'
	END

	set @SQLMString=N'WITH Data AS
				(' + @SQLString+')
	SELECT *
	FROM Data where ROWNUM=1 order by COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME'
	--set @SQLString = @SQLString+' order by COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME' 
	

	PRINT @SQLMString
	SET @ParmDefinition = N'@EntityCompID int,@EntityID INT ,@ISAct varchar(1),@COMPONENT_FILE_TYPE varchar(50)'; 
	EXECUTE sp_executesql @SQLMString, @ParmDefinition, @EntityCompID,@EntityID,@ISAct,@COMPONENT_FILE_TYPE
END
GO
/****** Object:  StoredProcedure [dbo].[GetComponentEntityHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[GetComponentEntityHis]
(
	@CompEntityID INT
)
AS
BEGIN
select COEH.TID,COEH.COMPONENT_FILE_TYPE,COEH.COMPONENT_TYPE,COEH.COMPONENT_COLUMN_NAME,COEH.COMPONENT_SUB_TYPE,COEH.COMPONENT_NAME,COEH.COMPONENT_DATATYPE,COEH.COMPONENT_DISPLAY_NAME,
	COEH.COMPONENT_DESCRIPTION,COEH.MIN_LENGTH,COEH.MAX_LENGTH ,ENTITY.ENTITY_NAME
	,CASE when COEH.MANDATORY=1 then 'required'else 'not required' end MANDATORY_STATUS,CASE WHEN COEH.ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS,
	FORMAT(COEH.CREATED_ON,'dd/MM/yyyy') CREATED_ON,U.USER_FIRSTNAME CREATED_BY,CASE WHEN COEH.ACTION='Update' THEN U.USER_FIRSTNAME END UPDATED_BY,FORMAT(COEH.UPDATE_ON,'dd/MM/yyyy')UPDATE_ON,COEH.ACTION
	 from IVAP_HIS_COMPONENT_ENTITY COEH INNER JOIN IVAP_MST_ENTITY ENTITY ON COEH.ENTITY_ID=ENTITY.TID INNER JOIN IVAP_MST_USER U ON COEH.CREATED_BY=U.UID
	WHERE COEH.CompEntityID=@CompEntityID
END
GO
/****** Object:  StoredProcedure [dbo].[GetComponentFileType]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetComponentFileType](@Component_File_Type varchar(50)='',@Component_Type varchar(50)='',@COMPONENT_DATATYPE VARCHAR(20)='')
as
begin
if(isnull(@COMPONENT_DATATYPE,'D') ='D')
begin
select distinct COMPONENT_DATATYPE from IVAP_MST_component ORDER BY COMPONENT_DATATYPE
end
if(isnull(@Component_File_Type,'') ='' and isnull(@Component_Type,'') ='')
begin
select distinct COMPONENT_FILE_TYPE from IVAP_MST_component
end
if(isnull(@Component_File_Type,'') !=''  AND  isnull(@Component_Type,'') ='')
begin
select distinct COMPONENT_TYPE from IVAP_MST_component where COMPONENT_FILE_TYPE=@Component_File_Type
end
if(isnull(@Component_File_Type,'') !='' AND isnull(@Component_Type,'') !='')
begin
select distinct COMPONENT_SUB_TYPE from IVAP_MST_component where COMPONENT_FILE_TYPE=@Component_File_Type and COMPONENT_TYPE=@Component_Type
end
end

GO
/****** Object:  StoredProcedure [dbo].[GetComponentHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetComponentHis]      
(      
@COMPONENT_ID INT      
)      
AS       
BEGIN      
SELECT CH.HID,CH.COMPONENT_ID,CH.COMPONENT_FILE_TYPE,CH.COMPONENT_TYPE,CH.COMPONENT_SUB_TYPE,CH.COMPONENT_NAME,CH.COMPONENT_DATATYPE,CH.COMPONENT_DISPLAY_NAME,
	CH.COMPONENT_DESCRIPTION,CH.MIN_LENGTH,CH.MAX_LENGTH,CASE when CH.MANDATORY=1 then 'required'else 'not required' end MANDATORY_STATUS,
	CASE WHEN CH.ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS,CASE WHEN ISNULL(CH.CREATED_ON,'') <>'' THEN U.USER_FIRSTNAME ELSE '' END CREATEDBY
,CASE WHEN ISNULL(CH.UPDATE_ON,'') <>'' THEN U.USER_FIRSTNAME ELSE '' END UPDATEDBY,FORMAT(CH.UPDATE_ON,'dd/MM/yyyy')UPDATED_ON,FORMAT(CH.CREATED_ON,'dd/MM/yyyy')CREATED_ON
 FROM IVAP_HIS_COMPONENT CH INNER JOIN IVAP_MST_USER U ON CH.CREATED_BY=U.UID     
WHERE COMPONENT_ID=@COMPONENT_ID      
END
GO
/****** Object:  StoredProcedure [dbo].[GetCostCenterHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCostCenterHis]
(
	@COSTCENID INT
)
AS
BEGIN
 select COH.TID,COH.COSTCENID,COH.PAY_COST_CODE,COH.ERP_COST_CODE,COH.COST_NAME,CASE WHEN COH.ISACTIVE=1 THEN 'Active' else 'In Active' end STATUS ,ENTITY.ENTITY_NAME 
	from IVAP_HIS_COSTCENTRE COH LEFT JOIN IVAP_MST_ENTITY ENTITY ON COH.ENTITY_ID =ENTITY.TID
	WHERE COH.COSTCENID =@COSTCENID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCostCentre]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROC [dbo].[GetCostCentre]  
(  
 @CostCenterID INT=0,  
 @ENTITYID INT=0,  
 @ISACT VARCHAR(1)='',
 @UID INT=0  
)  
AS  
BEGIN  
 SET NOCOUNT ON  
 DECLARE @SQLString nvarchar(Max);   
 DECLARE @ParmDefinition nvarchar(Max);  
 IF(@ISACT = '0')  
  SET @ISACT =''  
 SET @SQLString =N' select CO.TID,CO.PAY_COST_CODE,CO.ERP_COST_CODE,CO.COST_NAME,CO.ENTITY_ID,CASE WHEN CO.ISACTIVE=1 THEN ''Active'' else ''In Active'' end STATUS ,CO.ISACTIVE,ENTITY.ENTITY_NAME   
 from IVAP_MST_COSTCENTRE CO INNER JOIN IVAP_MST_ENTITY ENTITY ON CO.ENTITY_ID =ENTITY.TID  
 WHERE 1 =1'  
 IF(@CostCenterID > 0)  
 BEGIN  
  SET @SQLString+=' AND CO.TID=' + '@CostCenterID'  
 END  
 IF(@ENTITYID > 0)  
 BEGIN  
  SET @SQLString+=' AND CO.ENTITY_ID=' + '@ENTITYID'  
 END  
  
 IF(len(@ISACT) > 0)  
 BEGIN  
  SET @SQLString+=' AND CO.ISACTIVE=' + '@ISACT'  
 END  
  IF(@UID <> 0)  
 BEGIN  
  SET @SQLString=@SQLString+' AND CO.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_COSTCENTRE''),'',''))'
 END 
 set @SQLString = @SQLString+' order by TID desc'   
 SET @ParmDefinition = N'@CostCenterID int,@ENTITYID INT,@ISACT VARCHAR(1) ';   
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @CostCenterID,@ENTITYID,@ISACT  
END  
GO
/****** Object:  StoredProcedure [dbo].[GetCountry]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetCountry]
AS
BEGIN
	select TID,COUNTRY_CODE,COUNTRY_NAME,COUNTRY_NAME+'('+COUNTRY_CODE+')' As CountryCode 
	 from IVAP_MST_COUNTRY order by Country_Name
END
GO
/****** Object:  StoredProcedure [dbo].[GetCurrency]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[GetCurrency]              
(                
 @CurrencyID INT=0,                
 @CurrencyCode VARCHAR(10)='',                
 @CurrencyName VARCHAR(200)='',                
 @ISAct VARCHAR(1)='0'                
)                
AS                
BEGIN                
 SET NOCOUNT ON                
 DECLARE @SQLString nvarchar(Max);                 
 DECLARE @ParmDefinition nvarchar(Max);                
 IF(@IsAct = '0')                
  SET @IsAct =''                
  SET @SQLString =N'SELECT C.TID,C.CURRENCY_CODE,C.CURRENCY_NAME,C.CURRENCY_NAME+''(''+C.CURRENCY_CODE+'')'' AS CurrencyCode,C.ISACTIVE,CASE WHEN C.ISACTIVE=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS FROM IVAP_MST_CURRENCY C                      
   WHERE 1=1'                
 IF(@CurrencyID > 0)                
 BEGIN                
  SET @SQLString+=' AND C.TID=' + '@CurrencyID'                
 END                
 IF(ISNULL(@CurrencyCode,'') <> '')                
 BEGIN                
  SET @SQLString+=' AND CURRENCY_CODE=' + '@CurrencyCode'                
 END                
 IF(ISNULL(@CurrencyName,'') <> '')                
 BEGIN                
  SET @SQLString+=' AND CURRENCY_NAME=' + '@CurrencyName'                
 END                
 set @SQLString = @SQLString+' order by TID desc'                 
 SET @ParmDefinition = N'@CurrencyID int,@CurrencyCode VARCHAR(10),@CurrencyName VARCHAR(200), @IsAct VARCHAR(1) ';                 
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @CurrencyID,@CurrencyCode,@CurrencyName,@IsAct                
END 
GO
/****** Object:  StoredProcedure [dbo].[GetCurrencyHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetCurrencyHis]          
(          
@CID INT          
)          
AS           
BEGIN          
SELECT CID,CURRENCY_CODE,CURRENCY_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,CASE WHEN ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS,ACTION FROM IVAP_HIS_CURRENCY          
WHERE CID=@CID          
END  
GO
/****** Object:  StoredProcedure [dbo].[GetCurrencyNew]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetCurrencyNew]
AS
BEGIN
	SELECT C.TID,C.CURRENCY_CODE,C.CURRENCY_NAME,C.CURRENCY_NAME +'('+C.CURRENCY_CODE+')' AS CurrencyCode
	FROM IVAP_MST_CURRENCY C                      
END
GO
/****** Object:  StoredProcedure [dbo].[GETDATAACCESSCONTROL]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
       
        
CREATE PROC [dbo].[GETDATAACCESSCONTROL]     
(          
 @ACTION_NAME VARCHAR(100)='',          
 @EID INT=0,          
 @UID INT=0          
)          
AS          
BEGIN          
 IF @ACTION_NAME='ViewCompany'          
 BEGIN          
  SELECT 'IVAP_MST_COMPANY' as TableName,TID,COMP_NAME as Name,COMP_CODE AS  PAY_CODE,        
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_COMPANY C          
  LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_COMPANY'),',')) Sp          
  ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
          
 ELSE IF @ACTION_NAME='ProcessList'           
 BEGIN          
   SELECT 'IVAP_MST_PROCESS' as TableName,TID,PROC_NAME as Name,PAY_PROC_CODE AS PAY_CODE,ERP_PROC_CODE AS ERP_CODE,          
   case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
    FROM IVAP_MST_PROCESS C          
    LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_PROCESS'),',')) Sp          
    ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewLocation'           
 BEGIN          
   SELECT 'IVAP_MST_LOCATION' as TableName,TID,LOC_NAME as Name,PAY_LOC_CODE AS PAY_CODE,ERP_LOC_CODE AS ERP_CODE,          
   case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
   FROM  IVAP_MST_LOCATION C         
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_LOCATION'),',')) Sp          
   ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
    END          
          
 ELSE IF @ACTION_NAME='Gradelist'           
 BEGIN          
 SELECT 'IVAP_MST_GRADE' as TableName,TID,GARDE_NAME as Name,PAY_GRADE_CODE AS PAY_CODE,ERP_GRADE_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_GRADE C          
  LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_GRADE'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewDepartment'           
  BEGIN          
 SELECT 'IVAP_MST_DEPARTMENT' as TableName,TID,DEPT_NAME as Name,PAY_DEPT_CODE AS PAY_CODE,ERP_DEPT_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_DEPARTMENT C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_DEPARTMENT'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
 ELSE IF @ACTION_NAME='ViewDesignation'           
  BEGIN          
 SELECT 'IVAP_MST_DESIGNATION' as TableName,TID,DSG_NAME as Name,PAY_DSG_CODE AS PAY_CODE,ERP_DSG_CODE AS ERP_CODE,            
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_DESIGNATION C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_DESIGNATION'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewCostCentre'           
  BEGIN          
 SELECT 'IVAP_MST_COSTCENTRE' as TableName,TID,COST_NAME as Name,PAY_COST_CODE AS PAY_CODE,ERP_COST_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_COSTCENTRE C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_COSTCENTRE'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
          
 ELSE IF @ACTION_NAME='TypeList'           
  BEGIN          
 SELECT 'IVAP_MST_TYPE' as TableName,TID,TYPE_NAME as Name,PAY_TYPE_CODE AS PAY_CODE,ERP_TYPE_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_TYPE C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_TYPE'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 --ELSE IF @ACTION_NAME='ViewPTAX'           
 --SELECT * FROM IVAP_MST_PTAX WHERE Entit =@EID          
          
 ELSE IF @ACTION_NAME='ViewRegion'           
  BEGIN          
 SELECT 'IVAP_MST_REGION' as TableName,TID,REGION_NAME as Name,PAY_REGION_CODE AS PAY_CODE,ERP_REGION_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_REGION C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_REGION'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='Division'           
  BEGIN          
 SELECT 'IVAP_MST_DIVISION' as TableName,TID,DIVI_NAME as Name,PAY_DIVI_CODE AS PAY_CODE,ERP_DIVI_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_DIVISION C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_DIVISION'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewFunction'           
  BEGIN          
 SELECT 'IVAP_MST_FUNCTION' as TableName,TID,FUNC_NAME as Name,PAY_FUNC_CODE AS PAY_CODE,ERP_FUNC_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_FUNCTION C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_FUNCTION'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewBank'           
  BEGIN          
 SELECT 'IVAP_MST_BANK' as TableName,C.TID,GB.BANK_NAME as Name,PAY_BANK_CODE AS PAY_CODE,ERP_BANK_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_BANK C     
  inner join IVAP_MST_BANK_GLOBAL GB ON C.GLOBAL_BANK_ID=GB.TID         
  LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_BANK'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewClass'           
  BEGIN          
 SELECT 'IVAP_MST_CLASS' as TableName,TID,CLASS_NAME as Name,PAY_CLASS_CODE AS PAY_CODE,ERP_CLASS_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_CLASS C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_CLASS'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
 ELSE IF @ACTION_NAME='ViewPlant'           
  BEGIN          
 SELECT 'IVAP_MST_PLANT' as TableName,TID,PLANT_NAME as Name,PAY_PLANT_CODE AS PAY_CODE,ERP_PLANT_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_PLANT C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_PLANT'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewSubFunction'           
  BEGIN          
 SELECT 'IVAP_MST_SUB_FUNCTION' as TableName,TID,SUB_FUNC_NAME as Name,PAY_SUB_FUNC_CODE AS PAY_CODE,ERP_SUB_FUNC_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_SUB_FUNCTION C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_SUB_FUNCTION'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewLevel'           
  BEGIN          
 SELECT 'IVAP_MST_LEVEL' as TableName,TID,LEVEL_NAME as Name,PAY_LEVEL_CODE AS PAY_CODE,ERP_LEVEL_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_LEVEL C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_LEVEL'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewSection'           
  BEGIN          
 SELECT 'IVAP_MST_SECTION' as TableName,TID,SECTION_NAME as Name, PAY_SECTION_CODE AS PAY_CODE,ERP_SECTION_CODE AS ERP_CODE,         
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_SECTION  C          
  LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_SECTION'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
 END          
          
 ELSE IF @ACTION_NAME='ViewLeavingReason'           
  BEGIN          
 SELECT 'IVAP_MST_LEAVING_REASON' as TableName,TID,REASON as Name,PAY_LEAVING_CODE AS PAY_CODE,ERP_LEAVING_CODE AS ERP_CODE,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_LEAVING_REASON C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_LEAVING_REASON'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
  END          
      
 ELSE IF @ACTION_NAME='FileSetupList'           
  BEGIN          
 SELECT 'IVAP_MST_FILETYPE' as TableName,TID,FILE_NAME as Name,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_FILETYPE C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_FILETYPE'),',')) Sp          
 ON C.TID = Sp.Item WHERE C.ENTITY_ID=@EID          
  END        
          
END 
GO
/****** Object:  StoredProcedure [dbo].[GETDATAACCESSUSER]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GETDATAACCESSUSER]
(
@UID INT
)
AS
BEGIN
SELECT * FROM IVAP_DATA_ACCESS_DTL WHERE UID=@UID
END
GO
/****** Object:  StoredProcedure [dbo].[GetDefaultMenu]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetDefaultMenu]
AS
BEGIN
	select TID,
NAME,
PMENU,
ROLES,
DISPLAY_ORDER,
ACTIONS_NAME,
IMAGE,
CONTROLLER,
Route,
MENU_TYPE from Ivap_Mst_Default_Menu;
END
GO
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetDepartment]  
(  
 @DEPTID INT=0,  
 @ENTITYID INT=0,  
 @ISACT VARCHAR(1)='',
 @UID INT=0 
)  
AS  
BEGIN  
 SET NOCOUNT ON  
 DECLARE @SQLString nvarchar(Max);   
 DECLARE @ParmDefinition nvarchar(Max);  
 IF(@ISACT = '0')  
  SET @ISACT =''  
 SET @SQLString =N' select DEP.TID,DEP.PAY_DEPT_CODE,DEP.ERP_DEPT_CODE,DEP.DEPT_NAME,DEP.ENTITY_ID,CASE WHEN DEP.ISACTIVE=1 THEN ''Active'' else ''In Active'' end STATUS   
 ,DEP.ISACTIVE,ENTITY.ENTITY_NAME from IVAP_MST_DEPARTMENT DEP INNER JOIN IVAP_MST_ENTITY ENTITY ON DEP.ENTITY_ID =ENTITY.TID  
 WHERE DEP.ENTITY_ID='+Cast(@ENTITYID As varchar)  
 IF(@DEPTID > 0)  
 BEGIN  
  SET @SQLString+=' AND DEP.TID=' + '@DEPTID'  
 END  
 IF(@ENTITYID > 0)  
 BEGIN  
  SET @SQLString+=' AND DEP.ENTITY_ID=' + '@ENTITYID'  
 END  
  
 IF(len(@ISACT) > 0)  
 BEGIN  
  SET @SQLString+=' AND DEP.ISACTIVE=' + '@ISACT'  
 END  
  IF(@UID <> 0)  
 BEGIN  
  SET @SQLString=@SQLString+' AND DEP.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_DEPARTMENT''),'',''))'
 END  

 set @SQLString = @SQLString+' order by TID desc'   
 SET @ParmDefinition = N'@DEPTID int,@ENTITYID INT,@ISACT VARCHAR(1) ';   
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @DEPTID,@ENTITYID,@ISACT  
END  
  
   
  
  
GO
/****** Object:  StoredProcedure [dbo].[GetDepartmentHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROC [dbo].[GetDepartmentHis]
(
	@DEPTID INT
)
AS
BEGIN
select DEPTH.TID,DEPTH.DEPTID,DEPTH.PAY_DEPT_CODE,DEPTH.ERP_DEPT_CODE,DEPTH.DEPT_NAME,CASE WHEN DEPTH.ISACTIVE=1 THEN 'Active' else 'In Active' end STATUS ,ENTITY.ENTITY_NAME 
	from IVAP_HIS_DEPARTMENT DEPTH LEFT JOIN IVAP_MST_ENTITY ENTITY ON DEPTH.ENTITY_ID =ENTITY.TID
	WHERE DEPTH.DEPTID =@DEPTID
END
GO
/****** Object:  StoredProcedure [dbo].[GetDesignation]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetDesignation]  
(  
 @DSGID INT=0,  
 @ENTITY_ID INT=0,  
 @DSG_CODE VARCHAR(20)='',  
 @DSG_NAME VARCHAR(200)='',  
 @IsAct VARCHAR(1)='',
 @UID INT=0  
)  
AS  
BEGIN  
 SET NOCOUNT ON  
 DECLARE @SQLString nvarchar(Max);   
 DECLARE @ParmDefinition nvarchar(Max);  
 IF(@IsAct = '0')  
  SET @IsAct =''  
 SET @SQLString =N'SELECT D.TID,D.ENTITY_ID,D.PAY_DSG_CODE,ERP_DSG_CODE,D.DSG_NAME,D.ISACTIVE,  
     CASE WHEN D.ISACTIVE =1 THEN ''Active'' ELSE ''In Active'' END STATUS,E.ENTITY_CODE,E.ENTITY_NAME  
      FROM IVAP_MST_DESIGNATION D  
      INNER JOIN IVAP_MST_ENTITY E ON D.ENTITY_ID = E.TID WHERE 1=1'  
 IF(@DSGID > 0)  
 BEGIN  
  SET @SQLString+=' AND D.TID=' + '@DSGID'  
 END  
 IF(@ENTITY_ID > 0)  
 BEGIN  
  SET @SQLString+=' AND D.ENTITY_ID=' + '@ENTITY_ID'  
 END  
 IF(ISNULL(@DSG_NAME,'') <> '')  
 BEGIN  
  SET @SQLString+=' AND D.DSG_NAME=' + '@DSG_NAME'  
 END  
 IF(len(@IsAct) > 0)  
 BEGIN  
  SET @SQLString+=' AND ISACTIVE=' + '@IsAct'  
 END  
  IF(@UID <> 0)  
 BEGIN  
  SET @SQLString=@SQLString+' AND D.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_DESIGNATION''),'',''))'
 END 
 set @SQLString = @SQLString+' order by TID desc'   
 SET @ParmDefinition = N'@DSGID int,@ENTITY_ID INT, @IsAct VARCHAR(1),@DSG_CODE varchar(20),@DSG_NAME VARCHAR(200) ';   
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @DSGID,@ENTITY_ID,@IsAct,@DSG_CODE,@DSG_NAME  
END
GO
/****** Object:  StoredProcedure [dbo].[GetDesignationHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_ENTITY
--select * from IVAP_MST_DESIGNATION
--update IVAP_MST_DESIGNATION set ENTITY_ID=1
CREATE PROC [dbo].[GetDesignationHis]
(
	@DSGID INT
)
AS
BEGIN
	SELECT D.TID,D.ENTITY_ID,D.PAY_DSG_CODE,D.ERP_DSG_CODE,D.DSG_NAME,D.ISACTIVE,
		CASE WHEN D.ISACTIVE =1 THEN 'Active' ELSE 'In Active' END STATUS,E.ENTITY_NAME,D.CREATED_ON,D.UPDATED_ON,D.ACTION
			FROM IVAP_HIS_DESIGNATION D
			INNER JOIN IVAP_MST_ENTITY E ON D.ENTITY_ID = E.TID
		WHERE D.DESGID =@DSGID
END
GO
/****** Object:  StoredProcedure [dbo].[GetDivision]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
--SELECT * FROM IVAP_MST_Division    
CREATE PROC [dbo].[GetDivision]    
(    
 @DiviID INT=0,    
 @ENTITY_ID INT=0,    
 @DIVI_CODE VARCHAR(20)='',    
 @DIVI_NAME VARCHAR(200)='',    
 @IsAct VARCHAR(1)='1',  
 @UID INT=0    
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
 IF(@IsAct = '0')    
  SET @IsAct =''    
  SET @SQLString =N'SELECT D.TID, D.ENTITY_ID,D.PAY_DIVI_CODE,D.ERP_DIVI_CODE,D.DIVI_NAME,    
      CASE WHEN D.ISACTIVE =1 THEN ''Active'' ELSE ''IN Active'' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,D.ISACTIVE    
      FROM IVAP_MST_DIVISION D    
      INNER JOIN IVAP_MST_ENTITY E ON D.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1'    
 IF(@DiviID > 0)    
 BEGIN    
  SET @SQLString+=' AND D.TID=' + '@DiviID'    
 END    
 IF(@ENTITY_ID > 0)    
 BEGIN    
  SET @SQLString+=' AND D.ENTITY_ID=' + '@ENTITY_ID'    
 END    
 --IF(ISNULL(@DIVI_CODE,'') <> '')    
 --BEGIN    
 -- SET @SQLString+=' AND D.DIVI_CODE=' + '@DIVI_CODE'    
 --END    
 IF(ISNULL(@DIVI_NAME,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND D.DIVI_NAME=' + '@DIVI_NAME'    
 END    
 IF(len(@IsAct) > 0)    
 BEGIN    
  SET @SQLString+=' AND D.ISACTIVE=' + '@IsAct'    
 END   
  IF(@UID <> 0)      
 BEGIN      
  SET @SQLString=@SQLString+' AND D.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_DIVISION''),'',''))'  
 END    
 set @SQLString = @SQLString+' order by D.TID desc'     
 SET @ParmDefinition = N'@DiviID int,@ENTITY_ID INT, @IsAct VARCHAR(1),@DIVI_CODE varchar(20),@DIVI_NAME varchar(200) ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @DiviID,@ENTITY_ID,@IsAct,@DIVI_CODE,@DIVI_NAME    
END
GO
/****** Object:  StoredProcedure [dbo].[GetDivisionHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetDivisionHis]  
(  
 @DiviID INT  
)  
AS  
BEGIN  
 SELECT D.ENTITY_ID,D.PAY_DIVI_CODE,D.ERP_DIVI_CODE,D.DIVI_NAME,  
  CASE WHEN D.ISACTIVE =1 THEN 'Active' ELSE 'Is Active' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,ACTION  
  FROM IVAP_HIS_DIVISION D  
  INNER JOIN IVAP_MST_ENTITY E ON D.ENTITY_ID=E.TID  
  WHERE E.ISACTIVE=1 AND DIVIID =@DiviID  
END  
  
--select * from IVAP_HIS_DIVISION
GO
/****** Object:  StoredProcedure [dbo].[GetDSGName]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM IVAP_MST_DESIGNATION
--select * from IVAP_MST_COMPANY
CREATE PROC [dbo].[GetDSGName]
(
	@COMP_ID INT=3,
	@DSG_NAME VARCHAR(200)=''
)
AS
BEGIN
	with DesigList As
(
       select TID,DSG_NAME,1 AS LBL,CAST(DSG_NAME AS VARCHAR(255)) As ComPath from IVAP_MST_DESIGNATION AS RootDesg
       where PARENT_DSG IS NULL OR PARENT_DSG =0
       union all
       select Desg.TID,Desg.DSG_NAME,LBL+1,ComPath=
       CAST(CAST(DSGLST.ComPath as varchar(255))+CAST(' -> ' AS VARCHAR(255))+CAST(Desg.DSG_NAME as varchar(255)) AS VARCHAR(255)) from IVAP_MST_DESIGNATION AS Desg
       inner join DesigList AS DSGLST ON  Desg.PARENT_DSG=DSGLST.TID
       where Desg.PARENT_DSG IS not NULL AND Desg.PARENT_DSG >0 AND COMP_ID = @COMP_ID

)
select TID AS id,ComPath AS value from DesigList WHERE ComPath like '%'+@DSG_NAME+'%'

END
GO
/****** Object:  StoredProcedure [dbo].[GetEffDatecheck]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetEffDatecheck](@File_ID int)
as
begin
select CE.COMPONENT_NAME from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY CE on FD.COMPONENT_ID=CE.TID where FD.FILE_ID=@File_ID and CE.COMPONENT_NAME like 'eff%' or COMPONENT_NAME = 'PAY_DATE' or COMPONENT_NAME = 'PAYDATE' order by CE.COMPONENT_NAME
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDatecheck1]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetEffDatecheck1](@File_ID int)
as
begin
;WITH Data AS(
select distinct CE.COMPONENT_NAME,FD.FILE_ID from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY CE on FD.COMPONENT_ID=CE.TID where FD.FILE_ID=@File_ID and CE.COMPONENT_NAME like 'eff%' or COMPONENT_NAME = 'PAY_DATE'  or COMPONENT_NAME = 'PAYDATE' 
)
select * from Data where FILE_ID=@File_ID order by COMPONENT_NAME
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetEffDateTempTableData](@File_ID int ,@UID INT,@EID INT)
as
begin
	Declare @TableName VARCHAR(2000)='Ivap_MAST_TEMP_'+cast(@EID As VARCHAR);
	
	DECLARE @SqlQuery NVARCHAR(500)  ;
	DECLARE @ParmDefinition nvarchar(Max); 
	if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where FD.COMPONENT_DISPLAY_NAME ='PAYDATE' AND FD.FILE_ID=@File_ID)
	BEGIN
		set @SqlQuery= 'select PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+' AND  FILE_ID='+convert(varchar(10),@File_ID)+' group by PAYDATE'
	END
	ELSE
		set @SqlQuery= 'select ''ALL'' As PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+ ' AND FILE_ID='+convert(varchar(10),@File_ID);
	SET @ParmDefinition = N'@File_ID int ,@TableName varchar(100)'; 
	--print @SqlQuery 
	EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData0]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[GetEffDateTempTableData0](@File_ID int ,@UID INT,@EID INT)
as
begin
	Declare @TableName VARCHAR(2000)='Ivap_MAST_TEMP_'+cast(@EID As VARCHAR);
	
	DECLARE @SqlQuery NVARCHAR(500)  ;
	DECLARE @ParmDefinition nvarchar(Max); 
	if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where COMPONENT_NAME ='PAYDATE' AND FD.FILE_ID=@File_ID)
	BEGIN
		set @SqlQuery= 'select convert(varchar(10),PAYDATE,101) AS PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+' AND  FILE_ID='+convert(varchar(10),@File_ID)+' group by convert(varchar(10),PAYDATE,101)'
	END
	ELSE
		set @SqlQuery= 'select ''ALL'' As PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+ ' AND FILE_ID='+convert(varchar(10),@File_ID);
	SET @ParmDefinition = N'@File_ID int ,@TableName varchar(100)'; 
	EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData1]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetEffDateTempTableData1](@File_ID int ,@TableName varchar(100),@ColumnGroup varchar(100))
as
begin
DECLARE @SqlQuery NVARCHAR(500)  ;
   DECLARE @ParmDefinition nvarchar(Max); 
--select * from Ivap_MAST_TEMP_15 where FILE_ID=@File_ID and TEMP_BATCH_ID=@Batch_TempID
--set @SqlQuery= 'select * from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and TEMP_BATCH_ID='+convert(varchar(10),@Batch_TempID)
set @SqlQuery= 'select ' +@ColumnGroup+',count(*) TOTAL from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID)+' group by '+@ColumnGroup
 SET @ParmDefinition = N'@File_ID int ,@TableName varchar(100),@ColumnGroup varchar(100)'; 
  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@TableName,@ColumnGroup
end
GO
/****** Object:  StoredProcedure [dbo].[GetEntity]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetEntity]
(
	@EntityID INT=0,
	@IsAct VARCHAR(1)='0'
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max);
	IF(@IsAct = '0')
		SET @IsAct =''
	SET @SQLString =N'SELECT E.TID,E.ENTITY_CODE,E.ENTITY_NAME,E.ENTITY_CITY,S.STATE_NAME,E.ENTITY_ADDR1,E.ENTITY_ADDR2,ENTITY_STATE,
E.ENTITY_PIN,CASE WHEN E.ISACTIVE=1 THEN ''Active'' ELSE ''In Active'' END STATUS,DOMAIN_NAME,E.PAY_PERIOD,E.COUNTRY,C.COUNTRY_NAME,CR.CURRENCY_NAME,E.CREATED_BY,
E.CURRENCY,E.DATE_FORMAT,E.ISACTIVE[ISACT],CONVERT(VARCHAR(11),E.CREATED_ON)[CREATED_ON],Payperiod_Weekly_Fr,Payperiod_Weekly_To,Payperiod_Monthly_Fr,
Payperiod_Monthly_To,Payperiod_Fortnightly_Fr1,Payperiod_Fortnightly_To1,Payperiod_Fortnightly_Fr2,Payperiod_Fortnightly_To2,Services_Availed,G.SERVICE_NAME
FROM IVAP_MST_ENTITY E 
INNER JOIN IVAP_MST_STATE S ON S.TID=E.ENTITY_STATE 
INNER JOIN IVAP_MST_COUNTRY C ON E.COUNTRY=C.TID 
INNER JOIN IVAP_MST_CURRENCY CR ON E.CURRENCY=CR.TID
INNER JOIN IVAP_MST_SERVICE_GLOBAL G ON E.Services_Availed=G.TID
WHERE 1=1'
	IF(@EntityID > 0)
	BEGIN
		SET @SQLString+=' AND E.TID=' + '@EntityID'
	END
	IF(len(@IsAct) > 0)
	BEGIN
		SET @SQLString+=' AND E.ISACTIVE=' + '@IsAct'
	END
	set @SQLString = @SQLString+' order by E.TID desc' 
	SET @ParmDefinition = N'@EntityID int,@IsAct VARCHAR(1) '; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @EntityID,@IsAct
	print @SQLString
	--SELECT * FROM IVAP_MST_ENTITY
END
GO
/****** Object:  StoredProcedure [dbo].[GetEntityComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetEntityComponent]
(
	@Search_Text varchar(100)='',
	@EID INT=100,
	@Entity_Component_ID varchar(200)='',
	@FileID INT=0
)
AS
BEGIN
	DECLARE @isTable varchar(300)=''
	SET @isTable = (select Name from sys.objects where type='U' and name='Ivap_HRD_MAST_'+cast(@EID as varchar(10)))
	IF(ISNULL(@Search_Text,'') = '')
	BEGIN
		select TID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DISPLAY_NAME from IVAP_MST_COMPONENT_ENTITY 
		where ISACTIVE=1 AND ENTITY_ID=@EID
		and TID NOT IN (select * from dbo.SplitString(@Entity_Component_ID,','))
		and TID not in (select COMPONENT_ID from IVAP_MST_FILE_COMP_DETAIL where FILE_ID =@FileID) AND ISNULL(@isTable,'') <> ''
		order by COMPONENT_NAME
	END
	ELSE
	BEGIN
		select TID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DISPLAY_NAME from IVAP_MST_COMPONENT_ENTITY 
		where ISACTIVE=1 AND ENTITY_ID=@EID AND 
		(COMPONENT_TYPE like '%'+@Search_Text +'%' OR COMPONENT_SUB_TYPE like '%'+@Search_Text +'%'
		OR  COMPONENT_NAME like '%'+@Search_Text +'%' OR  COMPONENT_DISPLAY_NAME like '%'+@Search_Text +'%'
		OR  COMPONENT_DESCRIPTION like '%'+@Search_Text +'%'
		)
		and TID NOT IN (select * from dbo.SplitString(@Entity_Component_ID,','))
		and TID not in (select COMPONENT_ID from IVAP_MST_FILE_COMP_DETAIL where FILE_ID =@FileID) AND ISNULL(@isTable,'') <> ''
		order by COMPONENT_NAME
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetEntityDtl]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetEntityDtl]
(
@EntityID INT=0
)
AS
BEGIN
IF (@EntityID = 0)
BEGIN
select * from IVAP_MST_ENTITY
END
	else
BEGIN
	select * from IVAP_MST_ENTITY where tid=@EntityID
END
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileCompDtl]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROC [dbo].[GetFileCompDtl]  
(    
 @FILE_ID INT=11,    
 @EID INT =1   
)    
AS    
BEGIN    
 SELECT FD.TID,FD.FILE_ID,FD.Display_Order,F.FILE_NAME,E.COMPONENT_NAME,E.COMPONENT_DISPLAY_NAME FROM IVAP_MST_FILE_COMP_DETAIL FD    
 INNER JOIN IVAP_MST_FILETYPE F ON FD.FILE_ID = F.TID    
 INNER JOIN IVAP_MST_COMPONENT_ENTITY E ON FD.COMPONENT_ID = E.TID AND E.ENTITY_ID=@EID  
 WHERE FD.FILE_ID =@FILE_ID AND F.ENTITY_ID =@EID ORDER BY Display_Order    
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetFileComponent]
(
@TID int
)

as
Begin

select * from IVAP_MST_FILE_COMP_DETAIL where TID=@TID

End
GO
/****** Object:  StoredProcedure [dbo].[GetFileExt]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[GetFileExt]
AS
BEGIN
  SELECT FileExtID,FileExtension FROM IVAP_Mst_FileExt;
END;

--select * from IVAP_Mst_FileExt

GO
/****** Object:  StoredProcedure [dbo].[GetFileType]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileType]    
(    
 @FileID INT=0,    
 @ENTITY_ID INT=0,    
 @FILE_TYPE VARCHAR(50)='',    
 @FILE_NAME VARCHAR(200)='',    
 @IsAct VARCHAR(1)='1',  
 @UID INT=0  ,  
 @WFS_STRING VARCHAR(10)=''  
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
 IF(@IsAct = '0')    
  SET @IsAct =''    
 SET @SQLString =N'SELECT F.TID,F.ENTITY_ID,F.FILE_TYPE,F.CATEGORY,F.FILE_NAME,F.FILE_DESC,format(F.DUE_DATE,''dd/MM/yyyy'') DUE_DATE,F.CREATED_ON,    
     CASE WHEN F.ISACTIVE =1 THEN ''Active'' ELSE ''Is Active'' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,F.ISACTIVE ,F.FILE_NAME+'' (''+F.FILE_TYPE+'')'' WFS_FILENAME   
     FROM IVAP_MST_FILETYPE F    
     INNER JOIN IVAP_MST_ENTITY E ON F.ENTITY_ID = E.TID    
     WHERE E.ISACTIVE =1'    
 IF(@FileID > 0)    
 BEGIN    
  SET @SQLString+=' AND F.TID=' + '@FileID'    
 END    
 IF(@ENTITY_ID > 0)    
 BEGIN    
  SET @SQLString+=' AND F.ENTITY_ID=' + '@ENTITY_ID'    
 END    
 IF(ISNULL(@FILE_TYPE,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND F.FILE_TYPE=' + '@FILE_TYPE'    
 END    
 IF(ISNULL(@FILE_NAME,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND F.FILE_NAME=' + '@FILE_NAME'    
 END    
 IF(len(@IsAct) > 0)    
 BEGIN    
  SET @SQLString+=' AND F.ISACTIVE=' + '@IsAct'    
 END    
 IF(ISNULL(@WFS_STRING,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND FILE_TYPE=''Payroll Input File'' OR FILE_TYPE= ''PMS Input File'''  
 END    
  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND F.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_FILETYPE''),'',''))'  
 END   
 IF(ISNULL(@WFS_STRING,'') <> '')    
 BEGIN    
  set @SQLString = @SQLString+' order by F.FILE_TYPE' 
 END else
 begin 
 set @SQLString = @SQLString+' order by F.TID desc'  
 end   
 --print @SQLString;  
 SET @ParmDefinition = N'@FileID int,@ENTITY_ID INT, @IsAct VARCHAR(1),@FILE_TYPE varchar(50),@FILE_NAME varchar(200) ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @FileID,@ENTITY_ID,@IsAct,@FILE_TYPE,@FILE_NAME    
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileTypeDB]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetFileTypeDB](
	@ENTITY_ID int =15
)
as
Begin
	declare @SqlQuery varchar(max)='';

	set	@SqlQuery=' select count(mt.TID) as COUNTS, ft.Tid,File_Name from IVAP_MST_FILETYPE ft 
	inner join ivap_mast_temp_'+Cast(@ENTITY_ID as varchar)+' as mt on ft.tid=mt.file_id where ft.entity_id='+Cast(@ENTITY_ID as varchar)+' 
	and ft.file_Type in(''Payroll Input File'') and left(paydate,10) in(select Convert(varchar,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),103))  group by ft.Tid,ft.File_Name '
	print(@SqlQuery)
	exec (@SqlQuery)
End
GO
/****** Object:  StoredProcedure [dbo].[GetFileTypeForWfSetting]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileTypeForWfSetting]    
(    
 @ENTITY_ID INT=1,    
 @FILE_TYPE VARCHAR(50)='Payroll Input File',    
 @UID INT=0 
)    
AS    
BEGIN    
 SET NOCOUNT ON    
	SELECT F.TID,F.FILE_TYPE,isnull(F.CATEGORY,'N/A') As CATEGORY,F.FILE_NAME,F.FILE_DESC,case  when  WF.FILE_ID is not null then 'Active' else 'In-Active' end 
     FROM IVAP_MST_FILETYPE F  
	 left join   (select  Distinct Entity_ID,FILE_ID from IVAP_MST_WorkFlowSetting where ENTITY_ID=@ENTITY_ID) WF ON WF.FILE_ID=F.TID
     WHERE F.ISACTIVE =1  and F.ENTITY_ID=@ENTITY_ID and F.FILE_TYPE=@FILE_TYPE  
	 
END
GO
/****** Object:  StoredProcedure [dbo].[GetFunction]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE proc [dbo].[GetFunction]    
(    
 @ENTITYID INT=0,  
 @TID INT=0,    
 @IsAct CHAR(1)='0',
 @UID INT=0    
)    
AS    
BEGIN    
 DECLARE @QRY VARCHAR(MAX)=''    
 SET @QRY='select Func.TID,Func.FUNC_NAME,Func.ENTITY_ID,Func.PAY_FUNC_CODE,Func.ERP_FUNC_CODE,ENTITY.ENTITY_NAME,CASE WHEN Func.ISACTIVE=1 THEN ''Active'' else ''In Active'' end STATUS,Func.ISACTIVE from IVAP_MST_FUNCTION Func    
 INNER JOIN IVAP_MST_ENTITY ENTITY ON ENTITY.TID=Func.ENTITY_ID where 1=1';    
 IF(@TID>0)    
  SET @QRY=@QRY+' AND Func.TID='+CAST(@TID AS VARCHAR)    
 IF(@ENTITYID>0)    
  SET @QRY=@QRY+' AND Func.ENTITY_ID='+CAST(@ENTITYID AS VARCHAR)    
 IF(@IsAct<>'0')    
  SET @QRY=@QRY+' AND Func.IsActive=''1''';  
  IF(@UID<>0)    
  SET @QRY=@QRY+' AND Func.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_FUNCTION''),'',''))'
 EXEC(@QRY)    
END   
GO
/****** Object:  StoredProcedure [dbo].[GetFunctionHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[GetFunctionHis]
(
	@FunctionID INT
)
AS
BEGIN
select Func.FUNCTIONID,Func.FUNC_NAME,Func.PAY_FUNC_CODE,Func.ERP_FUNC_CODE,ENTITY.ENTITY_NAME,CASE WHEN Func.ISACTIVE=1 THEN 'Active' else 'In Active' end STATUS,
FORMAT(Func.CREATED_ON,'dd/MM/yyyy') CREATED_ON,U.USER_FIRSTNAME CREATED_BY,CASE WHEN Func.ACTION='Update' THEN U.USER_FIRSTNAME END UPDATED_BY,FORMAT(Func.UPDATE_ON,'dd/MM/yyyy')UPDATE_ON,Func.ACTION
	from IVAP_HIS_FUNCTION Func INNER JOIN IVAP_MST_ENTITY ENTITY ON ENTITY.TID=Func.ENTITY_ID INNER JOIN IVAP_MST_USER U ON Func.CREATED_BY=U.UID
	WHERE Func.FUNCTIONID = @FunctionID 
END
GO
/****** Object:  StoredProcedure [dbo].[GetGComponentTableName]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetGComponentTableName](@TableName varchar(50)='')
as
begin
if(isnull(@TableName,'')='')
begin
select distinct TABLE_NAME,SCREEN_NAME from IVAP_META_MASTER_DEFAULT order by SCREEN_NAME
end
if(isnull(@TableName,'')!='')
begin
select distinct FIELD_NAME,DISPLAY_NAME from IVAP_META_MASTER_DEFAULT where TABLE_NAME=@TableName order by DISPLAY_NAME 
end
end
GO
/****** Object:  StoredProcedure [dbo].[GETGLOBALBANK]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GETGLOBALBANK]
(
@BANK_ID int=0
)  
   AS  
   BEGIN  
   IF(@BANK_ID>0)  
   BEGIN  
   select  *  from IVAP_MST_BANK_GLOBAL WHERE TID=@BANK_ID   
   END  
   ELSE   
   BEGIN  
   select  TID,BANK_NAME,IFSC  from IVAP_MST_BANK_GLOBAL where ISACTIVE=1  
  END  
 END

GO
/****** Object:  StoredProcedure [dbo].[GetGlobalLocation]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetGlobalLocation]                          
(                        
 @LocID INT=0,                                               
 @StateID INT=0,                          
 @LocName VARCHAR(200)=''                          
)                          
AS                          
BEGIN                          
 SET NOCOUNT ON                          
 DECLARE @SQLString nvarchar(Max);                           
 DECLARE @ParmDefinition nvarchar(Max);                          
 SET @SQLString =N'SELECT L.TID,L.LOC_CODE,L.LOC_NAME,L.ISMETRO,CASE WHEN L.ISMETRO=1 THEN ''YES'' ELSE ''NO'' END METRO,L.STATE_ID,L.ISACTIVE,CASE WHEN L.ISACTIVE=1 THEN ''Active'' ELSE ''In Active'' END STATUS,S.STATE_CODE,S.STATE_NAME FROM IVAP_MST_LOCATION_GLOBAL L                                           
 INNER JOIN IVAP_MST_STATE S ON L.STATE_ID = S.TID                          
 WHERE 1=1'                          
IF(@LocID > 0)                          
 BEGIN                          
  SET @SQLString+=' AND L.TID=' + '@LocID'                          
 END                                               
 IF(@StateID > 0)                          
 BEGIN                          
  SET @SQLString+=' AND L.STATE_ID=' + '@StateID'                          
 END                          
 IF(ISNULL(@LocName,'') <> '')                          
 BEGIN                          
  SET @SQLString+=' AND L.LOC_NAME=' + '@LocName'                          
 END                          
 set @SQLString = @SQLString+' order by TID desc'                           
 print @SQLString                  
 SET @ParmDefinition = N'@LocID int,@StateID INT,@LocName VARCHAR(200) ';                           
 EXECUTE sp_executesql @SQLString, @ParmDefinition,@LocID, @StateID,@LocName                                           
END 
GO
/****** Object:  StoredProcedure [dbo].[GetGlobalLocationHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetGlobalLocationHis]        
(        
@LID INT        
)        
AS         
BEGIN        
SELECT GL.TID,GL.LID,GL.LOC_CODE,S.STATE_NAME,GL.LOC_NAME,GL.STATE_ID,GL.ISMETRO,GL.CREATED_ON,GL.UPDATE_ON,GL.ACTION,GL.ISACTIVE,CASE WHEN GL.ISACTIVE =1 THEN 'Active' ELSE 'In Active' END STATUS
 FROM IVAP_HIS_LOCATION_GLOBAL  GL
INNER JOIN IVAP_MST_STATE S ON GL.STATE_ID = S.TID       
WHERE LID=@LID        
END 
GO
/****** Object:  StoredProcedure [dbo].[GetGlobleComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetGlobleComponent]
(
	@COMPONENT_FILE_TYPE varchar(50),
	@Search_Text varchar(100),
	@EID INT,
	@Globle_Component_ID varchar(200)=''
)
AS
BEGIN
	select TID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DISPLAY_NAME from IVAP_MST_COMPONENT with (nolock)
	where ISACTIVE=1 AND (COMPONENT_TYPE like '%'+@Search_Text +'%' OR COMPONENT_SUB_TYPE like '%'+@Search_Text +'%'
	OR  COMPONENT_NAME like '%'+@Search_Text +'%' OR COMPONENT_DESCRIPTION LIKE '%'+@Search_Text+'%')  AND COMPONENT_FILE_TYPE=@COMPONENT_FILE_TYPE
	and TID NOT IN (select * from dbo.SplitString(@Globle_Component_ID,','))
	and TID not in (select Globle_Component_ID from IVAP_MST_COMPONENT_ENTITY with (nolock) where ENTITY_ID=@EID)

	order by COMPONENT_NAME
	 
END

GO
/****** Object:  StoredProcedure [dbo].[GetGrade]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROC [dbo].[GetGrade]  
(  
 @GradeID INT=0,  
 @EntityID INT=0,  
 @Grade_Code VARCHAR(20)='',  
 @Grade_Name VARCHAR(200)='',  
 @IsAct VARCHAR(1)='',
 @UID INT=0  
)  
AS  
BEGIN  
 SET NOCOUNT ON  
 DECLARE @SQLString nvarchar(Max);   
 DECLARE @ParmDefinition nvarchar(Max);  
 IF(@IsAct = '0')  
  SET @IsAct =''  
 SET @SQLString =N' SELECT G.TID,G.ENTITY_ID,G.GARDE_NAME,G.GRADE_MIDPOINT,G.PROB_PERIOD,   
     ENTITY.ENTITY_NAME,G.ISACTIVE,CASE WHEN G.ISACTIVE=1 THEN ''Active'' ELSE ''In Active'' END STATUS,convert(varchar(10),G.created_on,103)[CREATED_ON],  
     G.ERP_GRADE_CODE,G.PAY_GRADE_CODE,G.GRADE_SCALE_FROM,G.GRADE_SCALE_TO  
     FROM IVAP_MST_GRADE G  
     INNER JOIN IVAP_MST_ENTITY ENTITY ON G.ENTITY_ID =ENTITY.TID  
     WHERE ENTITY.ISACTIVE=1'  
 IF(@GradeID > 0)  
 BEGIN  
  SET @SQLString+=' AND G.TID=' + '@GradeID'  
 END  
 IF(@EntityID > 0)  
 BEGIN  
  SET @SQLString+=' AND G.ENTITY_ID=' + '@EntityID'  
 END  
 --IF(ISNULL(@Grade_Code,'') <> '')  
 --BEGIN  
 -- SET @SQLString+=' AND G.GRADE_CODE=' + '@Grade_Code'  
 --END  
 IF(ISNULL(@Grade_Name,'') <> '')  
 BEGIN  
  SET @SQLString+=' AND G.GARDE_NAME=' + '@Grade_Name'  
 END  
  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND G.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_GRADE''),'',''))'
 END  

 set @SQLString = @SQLString+' order by TID desc'   
 SET @ParmDefinition = N'@GradeID int,@EntityID INT, @IsAct VARCHAR(1),@Grade_Code varchar(20),@Grade_Name VARCHAR(200) ';  
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @GradeID,@EntityID,@IsAct,@Grade_Code,@Grade_Name  
END  
  
  
GO
/****** Object:  StoredProcedure [dbo].[GetGradHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[GetGradHis]
(
	@Grad_ID INT
)
AS
BEGIN
select G.Grad_ID,G.GARDE_NAME,G.GRADE_MIDPOINT,G.PROB_PERIOD,ENTITY.ENTITY_NAME,CASE WHEN G.ISACTIVE=1 THEN 'Active' ELSE 'In Active' END STATUS   
    , G.ERP_GRADE_CODE,G.PAY_GRADE_CODE,G.GRADE_SCALE_FROM,G.GRADE_SCALE_TO ,
FORMAT(G.CREATED_ON,'dd/MM/yyyy') CREATED_ON,U.USER_FIRSTNAME CREATED_BY,CASE WHEN G.ACTION='Update' THEN U.USER_FIRSTNAME END UPDATED_BY,FORMAT(G.UPDATE_ON,'dd/MM/yyyy')UPDATE_ON,G.ACTION
	from IVAP_HIS_GRADE G INNER JOIN IVAP_MST_ENTITY ENTITY ON ENTITY.TID=G.ENTITY_ID INNER JOIN IVAP_MST_USER U ON G.CREATED_BY=U.UID
	WHERE G.Grad_ID = @Grad_ID 
END
GO
/****** Object:  StoredProcedure [dbo].[GetGridGlobalLocation]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetGridGlobalLocation]
(
	@FromNumber NVARCHAR(10)=1,
	@ToNumber NVARCHAR(10)=10,
	@SQLSortString nvarchar(1000)=null,
	@SQLFilterString nvarchar(1000)=null
)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @SQLString nvarchar(Max); 
	DECLARE @SQLQueryCount nvarchar(MAX);
    DECLARE @ParmDefinition nvarchar(Max); 
	
SET @SQLString =N' L.TID,L.LOC_CODE,L.LOC_NAME,L.ISMETRO,CASE WHEN L.ISMETRO=1 THEN ''YES'' ELSE ''NO'' END METRO,L.STATE_ID,S.STATE_NAME,S.STATE_CODE,L.ISACTIVE,CASE WHEN L.ISACTIVE=1 THEN ''Active'' ELSE ''In Active'' END STATUS FROM
 IVAP_MST_LOCATION_GLOBAL L                                             
 INNER JOIN IVAP_MST_STATE S ON L.STATE_ID = S.TID                            
 WHERE 1=1' 
	SET @SQLQueryCount =N'select Count(*) [TotalCount] 
					FROM IVAP_MST_LOCATION_GLOBAL L
					INNER JOIN IVAP_MST_STATE S ON L.STATE_ID = S.TID 
					WHERE 1=1'
  
 	IF @SQLSortString IS NOT NULL and @SQLSortString != ''
	BEGIN
		SET @SQLString= N'SELECT ROW_NUMBER() OVER (ORDER BY '+@SQLSortString+') AS ''RowNumber'', ' +  @SQLString
		
	END
	ELSE
	BEGIN
		SET @SQLString= N'SELECT ROW_NUMBER() OVER (ORDER BY S.STATE_NAME) AS ''RowNumber'', ' + @SQLString
		
	END
	IF @SQLFilterString IS NOT NULL  and @SQLFilterString != ''
	BEGIN
		SET @SQLString= @SQLString + ' AND ' + @SQLFilterString
		SET @SQLQueryCount = @SQLQueryCount + ' AND ' + @SQLFilterString
	END
	SET @SQLString=N' WITH Data AS
				(' + @SQLString+')
	SELECT *
	FROM Data'
	IF @FromNumber IS NOT NULL
	BEGIN
		SET @SQLString=@SQLString+N' WHERE RowNumber BETWEEN '+@FromNumber+' AND '+@ToNumber --BETWEEN is inclusive
	END
                   
    --  print @SQLString                          
 EXECUTE sp_executesql @SQLString
 EXECUTE sp_executesql @SQLQueryCount

END

GO
/****** Object:  StoredProcedure [dbo].[GetGridUsers]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetGridUsers]
(
	@UID INT=0,
	@ENTITY_ID INT=0,
	@USERID VARCHAR(200)='',
	@USER_ROLE INT=0,
	@FromNumber NVARCHAR(10)=1,
	@ToNumber NVARCHAR(10)=12099,
	@SQLSortString nvarchar(1000)=null,
	@SQLFilterString nvarchar(1000)=null
)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @SQLString nvarchar(Max); 
	DECLARE @SQLQueryCount nvarchar(MAX);
    DECLARE @ParmDefinition nvarchar(Max); 
	IF(@USERID=null)
			SET @USERID=''
	SET @SQLString = N' U.UID,U.ENTITY_ID,E.ENTITY_NAME,E.ENTITY_CODE,U.USERID,U.USER_FIRSTNAME,U.USER_LASTNAME,U.USER_EMAIL,
						U.USER_ROLE,R.ROLENAME,USER_MOBILENO,U.PASSWORD,U.ISAUTH,U.ISACT,CASE WHEN U.ISACT =1 THEN ''Active'' ELSE ''In Active'' END STATUS
					FROM IVAP_MST_USER U
					INNER JOIN IVAP_MST_ENTITY E ON U.ENTITY_ID = E.TID
					INNER JOIN IVAP_MST_USERROLE R ON U.USER_ROLE = R.TID
					WHERE 1=1'
	SET @SQLQueryCount =
		N' select Count(*) [TotalCount] 
					FROM IVAP_MST_USER U
					INNER JOIN IVAP_MST_ENTITY E ON U.ENTITY_ID = E.TID
					INNER JOIN IVAP_MST_USERROLE R ON U.USER_ROLE = R.TID
					WHERE 1=1'
	IF(@UID > 0)
	BEGIN
		SET @SQLString+=' AND U.UID=' + '@UID'
		SET @SQLQueryCount+=' AND U.UID=' + '@UID'
	END
	IF(@ENTITY_ID >0)
	BEGIN
		SET @SQLString+=' AND U.ENTITY_ID=' + '@ENTITY_ID'
		SET @SQLQueryCount+=' AND U.ENTITY_ID=' + '@ENTITY_ID'
	END
	IF(@USERID <> '')
	BEGIN
		SET @SQLString+=' AND U.USERID=' + '@USERID'
		SET @SQLQueryCount+=' AND U.USERID=' + '@USERID'
	END
	IF(@USER_ROLE >0)
	BEGIN
		SET @SQLString+=' AND U.USER_ROLE=' + '@USER_ROLE'
		SET @SQLQueryCount+=' AND U.USER_ROLE=' + '@USER_ROLE'
	END
	IF @SQLSortString IS NOT NULL and @SQLSortString != ''
	BEGIN
		SET @SQLString= N'SELECT ROW_NUMBER() OVER (ORDER BY '+@SQLSortString+') AS ''RowNumber'', ' +  @SQLString
		
	END
	ELSE
	BEGIN
		SET @SQLString= N'SELECT ROW_NUMBER() OVER (ORDER BY E.ENTITY_NAME) AS ''RowNumber'', ' + @SQLString
		
	END
	IF @SQLFilterString IS NOT NULL  and @SQLFilterString != ''
	BEGIN
		SET @SQLString= @SQLString + ' AND ' + @SQLFilterString
		SET @SQLQueryCount = @SQLQueryCount + ' AND ' + @SQLFilterString
	END
	SET @SQLString=N' WITH Data AS
				(' + @SQLString+')
	SELECT *
	FROM Data '
	IF @FromNumber IS NOT NULL
	BEGIN
		SET @SQLString=@SQLString+N' WHERE RowNumber BETWEEN '+@FromNumber+' AND '+@ToNumber --BETWEEN is inclusive
	END

	SET @ParmDefinition = N'@UID INT,@ENTITY_ID INT,@USERID VARCHAR(200),@USER_ROLE INT';
	--print @SQLString
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @UID,@ENTITY_ID,@USERID,@USER_ROLE
	EXECUTE sp_executesql @SQLQueryCount, @ParmDefinition, @UID,@ENTITY_ID,@USERID,@USER_ROLE
END

--select * from ivap_mst_user

GO
/****** Object:  StoredProcedure [dbo].[GetLeavingReason]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetLeavingReason]                    
(                    
 @LEAVID INT=0,  
 @EntityID INT=0,                                    
 @ISAct VARCHAR(1)='0',
 @UID INT=0                    
)                    
AS                    
BEGIN                    
 SET NOCOUNT ON                    
 DECLARE @SQLString nvarchar(Max);                     
 DECLARE @ParmDefinition nvarchar(Max);                    
 IF(@IsAct = '0')                    
  SET @IsAct =''                    
  SET @SQLString =N'SELECT L.TID,L.ENTITY_ID,E.ENTITY_NAME,L.PAY_LEAVING_CODE,L.ERP_LEAVING_CODE,L.[VOL/NON_VOL] AS VOLU,L.REASON,L.ISACTIVE,CASE WHEN L.ISACTIVE=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS FROM IVAP_MST_LEAVING_REASON L        
  INNER JOIN IVAP_MST_ENTITY E ON L.ENTITY_ID = E.TID                        
   WHERE 1=1'                    
 IF(@LEAVID > 0)                    
 BEGIN                    
  SET @SQLString+=' AND L.TID=' + '@LEAVID'                    
 END     
 IF(@EntityID > 0)                    
 BEGIN                    
  SET @SQLString+=' AND L.ENTITY_ID=' + '@EntityID'                    
 END                   
    IF(@UID <> 0)                    
 BEGIN                    
  SET @SQLString=@SQLString+' AND L.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_LEAVING_REASON''),'',''))'
 END                 
 set @SQLString = @SQLString+' order by TID desc'                     
 SET @ParmDefinition = N'@LEAVID int, @IsAct VARCHAR(1),@EntityID INT';                     
 EXECUTE sp_executesql @SQLString, @ParmDefinition,@LEAVID,@IsAct,@EntityID                    
END 
GO
/****** Object:  StoredProcedure [dbo].[GetLeavingReasonHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetLeavingReasonHis]            
(            
@LEAVID INT,
@EntityID INT            
)            
AS             
BEGIN            
SELECT LR.LEAID,LR.ENTITY_ID,E.ENTITY_NAME,LR.PAY_LEAVING_CODE,LR.ERP_LEAVING_CODE,LR.[VOL/NON_VOL] AS VOLU,LR.REASON,LR.CREATED_ON,LR.CREATED_BY,LR.UPDATED_ON,LR.UPDATED_BY,LR.ISACTIVE,CASE WHEN LR.ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS,LR.ACTION FROM IVAP_HIS_LEAVING_REASON LR  
INNER JOIN IVAP_MST_ENTITY E ON Lr.ENTITY_ID = E.TID      
WHERE LR.LEAID=@LEAVID AND LR.ENTITY_ID=@EntityID          
END
GO
/****** Object:  StoredProcedure [dbo].[GetLevel]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
--SELECT * FROM IVAP_MST_Division    
CREATE PROC [dbo].[GetLevel]    
(    
 @LevelID INT=0,    
 @ENTITY_ID INT=0,    
 @LEVEL_CODE VARCHAR(20)='',    
 @LEVEL_NAME VARCHAR(200)='',    
 @IsAct VARCHAR(1)='1',  
 @UID INT=0    
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
 IF(@IsAct = '0')    
  SET @IsAct =''    
  SET @SQLString =N'SELECT L.TID, L.ENTITY_ID,L.PAY_LEVEL_CODE,L.ERP_LEVEL_CODE,L.LEVEL_NAME,    
      CASE WHEN L.ISACTIVE =1 THEN ''Active'' ELSE ''In Active'' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,L.ISACTIVE    
      FROM IVAP_MST_LEVEL L    
      INNER JOIN IVAP_MST_ENTITY E ON L.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1'    
 IF(@LevelID > 0)    
 BEGIN    
  SET @SQLString+=' AND L.TID=' + '@LevelID'    
 END    
 IF(@ENTITY_ID > 0)    
 BEGIN    
  SET @SQLString+=' AND L.ENTITY_ID=' + '@ENTITY_ID'    
 END    
 --IF(ISNULL(@LEVEL_CODE,'') <> '')    
 --BEGIN    
 -- SET @SQLString+=' AND D.LEVEL_CODE=' + '@LEVEL_CODE'    
 --END    
 IF(ISNULL(@LEVEL_NAME,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND L.LEVEL_NAME=' + '@LEVEL_NAME'    
 END    
 IF(len(@IsAct) > 0)    
 BEGIN    
  SET @SQLString+=' AND L.ISACTIVE=' + '@IsAct'    
 END    
  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND L.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_LEVEL''),'',''))'  
 END    
 set @SQLString = @SQLString+' order by L.TID desc'     
 SET @ParmDefinition = N'@LevelID int,@ENTITY_ID INT, @IsAct VARCHAR(1),@LEVEL_CODE varchar(20),@LEVEL_NAME varchar(200) ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @LevelID,@ENTITY_ID,@IsAct,@LEVEL_CODE,@LEVEL_NAME    
END
GO
/****** Object:  StoredProcedure [dbo].[GetLevelHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetLevelHis]
(
	@LevelID INT
)
AS
BEGIN
	SELECT L.ENTITY_ID,L.PAY_LEVEL_CODE,L.ERP_LEVEL_CODE,L.LEVEL_NAME,
		CASE WHEN L.ISACTIVE =1 THEN 'Active' ELSE 'Is Active' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,ACTION
		FROM IVAP_HIS_LEVEL L
		INNER JOIN IVAP_MST_ENTITY E ON L.ENTITY_ID=E.TID
		WHERE E.ISACTIVE=1 AND LEVELID =@LevelID
END
GO
/****** Object:  StoredProcedure [dbo].[GetLocation]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_LOCATION  
CREATE PROC [dbo].[GetLocation]                                
(                              
 @LocID INT=0,                            
 @ParentID INT=0,                                
 @StateID INT=0,  
 @EntityID INT=0,                                 
 @LocName VARCHAR(200)='',
 @UID INT=0                                
)                                
AS                                
BEGIN                                
 SET NOCOUNT ON                                
 DECLARE @SQLString nvarchar(Max);                                 
 DECLARE @ParmDefinition nvarchar(Max);                                
 SET @SQLString =N'SELECT L.TID,L.PARENT_LOC_ID,GL.LOC_NAME AS GLOBALNAME,GL.TID AS GLOBALLOCTID,
 L.ENTITY_ID,E.ENTITY_NAME,L.ISMETRO,CASE WHEN L.ISMETRO=1 THEN ''YES'' ELSE ''NO'' END METRO,L.ERP_LOC_CODE,L.PAY_LOC_CODE,L.LOC_NAME,L.STATE_ID,L.ISACTIVE,  
  CASE WHEN L.ISACTIVE=1 THEN ''Active'' ELSE ''In Active'' END STATUS,S.STATE_CODE,S.STATE_NAME FROM IVAP_MST_LOCATION L        
  INNER JOIN IVAP_MST_ENTITY E ON L.ENTITY_ID = E.TID                                                
  INNER JOIN IVAP_MST_STATE S ON L.STATE_ID = S.TID      
  INNER JOIN IVAP_MST_LOCATION_GLOBAL GL ON L.PARENT_LOC_ID = GL.TID                           
  WHERE 1=1'                                
 IF(@LocID > 0)                                
 BEGIN                                
  SET @SQLString+=' AND L.TID=' + '@LocID'                                
 END        
 IF(@ParentID > 0)                                
 BEGIN                                
  SET @SQLString+=' AND L.PARENT_LOC_ID=' + '@ParentID'                                
 END   
 BEGIN                                
  SET @SQLString+=' AND L.ENTITY_ID=' + '@EntityID'                                
 END                        
 IF(@StateID > 0)                                
 BEGIN                                
  SET @SQLString+=' AND L.STATE_ID=' + '@StateID'                                
 END                                
 IF(ISNULL(@LocName,'') <> '')                                
 BEGIN                                
  SET @SQLString+=' AND L.LOC_NAME=' + '@LocName'                                
 END  
  IF(@UID <> 0)                                
 BEGIN                                
  SET @SQLString=@SQLString+' AND L.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_LOCATION''),'',''))'
 END                               
 set @SQLString = @SQLString+' order by TID desc'                                 
 print @SQLString                        
 SET @ParmDefinition = N'@LocID int,@ParentID int,@StateID INT,@LocName VARCHAR(200),@EntityID INT';                                 
 EXECUTE sp_executesql @SQLString, @ParmDefinition,@LocID,@ParentID, @StateID,@LocName,@EntityID                          
                               
END   
  
GO
/****** Object:  StoredProcedure [dbo].[GetLocationHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[GetLocationHis]    
(        
@LOCID INT,
@EntityId INT        
)        
AS         
BEGIN        
SELECT LH.ENTITY_ID,LH.STATE_ID,GL.LOC_NAME AS GLOBALNAME,S.STATE_NAME ,LH.PAY_LOC_CODE,E.ENTITY_NAME,LH.ERP_LOC_CODE,LH.LOC_NAME,LH.ISMETRO,CASE WHEN GL.ISMETRO =1 THEN 'Yes' ELSE 'No' END METRO,LH.CREATED_ON,LH.CREATED_BY,LH.UPDATE_ON,LH.UPDATED_BY,LH.ISACTIVE,CASE WHEN GL.ISACTIVE =1 THEN 'Active' ELSE 'In Active' END STATUS,LH.ACTION FROM IVAP_HIS_LOCATION LH    
 INNER JOIN IVAP_MST_ENTITY E ON LH.ENTITY_ID = E.TID                                                
     INNER JOIN IVAP_MST_STATE S ON LH.STATE_ID = S.TID      
  INNER JOIN IVAP_MST_LOCATION_GLOBAL GL ON LH.PARENT_LOC_ID = GL.TID       
WHERE LH.LOC_ID=@LOCID and LH.ENTITY_ID=@EntityId       
END 
GO
/****** Object:  StoredProcedure [dbo].[GetLocationName]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetLocationName]  
(  
 @STATEID INT,  
 @LOCNAME VARCHAR(200)=''  
)  
AS  
BEGIN   
select TID AS id,LOC_NAME AS value from IVAP_MST_LOCATION_GLOBAL WHERE STATE_ID=@STATEID AND LOC_NAME like '%'+@LOCNAME+'%'  
END
GO
/****** Object:  StoredProcedure [dbo].[GETLOCNAMEGLOBAL]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GETLOCNAMEGLOBAL]
(
@TID INT=0
)
AS
BEGIN
SELECT TID,LOC_CODE,LOC_NAME,STATE_ID,ISMETRO,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE FROM IVAP_MST_LOCATION_GLOBAL
END
GO
/****** Object:  StoredProcedure [dbo].[GetLwf]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_LWF
CREATE PROC [dbo].[GetLwf]
(
	@LwfID INT=0,
	@StateID INT=0
)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @SQLString nvarchar(Max); 
    DECLARE @ParmDefinition nvarchar(Max); 
	SET @SQLString = N'SELECT L.TID,L.STATE_ID,L.Location_ID,L.PERIOD_FLAG,L.DED_MONTH,S.STATE_NAME,L.LWF_EMPLOYEE,L.LWF_EMPLOYER,
					format(L.EFF_FROM_DT,''dd/MM/yyyy'') EFF_FROM_DT,format(L.EFF_TO_DT,''dd/MM/yyyy'')  EFF_TO_DT,
					L.ISACTIVE,L.ACTION,CASE WHEN L.ISACTIVE =1 THEN ''Active'' ELSE ''In Active'' END STATUS
					FROM IVAP_MST_LWF L
					INNER JOIN IVAP_MST_STATE S ON L.STATE_ID = S.TID
					WHERE 1=1'
	IF(@LwfID > 0)
	BEGIN
		SET @SQLString+=' AND L.TID=' + '@LwfID'
	END
	IF(@StateID > 0)
	BEGIN
	   SET @SQLString+=' AND L.STATEID=' + '@StateID'
	   END

	--SET @SQLString+= @SQLString+'  Order by  TID desc'
	print @SQLString
	SET @ParmDefinition = N'@LwfID INT,@StateID INT';
	EXECUTE sp_executesql @SQLString, @ParmDefinition,@LwfID,@StateID
END
GO
/****** Object:  StoredProcedure [dbo].[GetLwfHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetLwfHis]
(
	@HISID INT
)
AS
BEGIN
 select HISID,LWFID,STATE_ID,LOCATION_ID,PERIOD_FLAG,DED_MONTH,LWF_EMPLOYEE,LWF_EMPLOYER,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,EFF_FROM_DT,EFF_TO_DT,ACTION FROM dbo.IVAP_HIS_LWF 
	WHERE LWFID =@HISID
END
GO
/****** Object:  StoredProcedure [dbo].[GetMailSetup]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetMailSetup]
As
 Begin
 select * from ivap_mst_mailsetup
End
GO
/****** Object:  StoredProcedure [dbo].[GetMasterMetaData]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetMasterMetaData]  
(  
 @EID INT=15,  
 @SCREEN_NAME VARCHAR(50)='IVAP_MST_PLANT',  
 @Menu_Name VARCHAR(50)='ViewPlant'  
)  
AS  
BEGIN  
 select TID,DISPLAY_NAME,FIELD_NAME from  IVAP_META_MASTER where ENTITY_ID=@EID AND Table_NAME=@SCREEN_NAME  order by DISPLAY_ORDER
 select Name FROM  IVAP_MST_MENU WHERE ENTITY_ID=@EID AND ROUTE=@Menu_Name AND Menu_Type='MENU';  
END  
GO
/****** Object:  StoredProcedure [dbo].[GetMataMaster]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC [dbo].[GetMataMaster](@ENTITYID INT =0,@SCREENNAME VARCHAR(50)='')
	   as
	   begin
	   select  METAM.ENTITY_ID,METAM.TID, METAM.SCREEN_NAME,METAM.DISPLAY_NAME,METAM.DISPLAY_ORDER  from IVAP_META_MASTER METAM INNER JOIN IVAP_MST_ENTITY EN ON METAM.ENTITY_ID=EN.TID
	    WHERE METAM.ENTITY_ID=@ENTITYID AND METAM.SCREEN_NAME=@SCREENNAME
	   end
GO
/****** Object:  StoredProcedure [dbo].[GetMenu]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ivap_mst_Menu where PMenu=0 and ENTITY_ID =1

--update ivap_mst_Menu set DISPLAY_ORDER = 3 where TID =1 

--select * from IVAP_MST_MENU where Name like 'Configuration'
CREATE PROC [dbo].[GetMenu]
(
	@TID INT=0,
	@MenuName VARCHAR(100)='',
	@EID INT=1
)
AS
BEGIN
	IF(ISNULL(@MenuName,'') = '')
	BEGIN
		IF(@TID =0)
			SELECT M1.TID,M.TID PTID,M1.ENTITY_ID,M.NAME PName,M1.NAME,M1.PMENU,M1.ROUTE,M1.ROLES,M1.ACTIONS_NAME,M1.ISACT,M1.DISPLAY_ORDER,
			CASE WHEN M1.ISACT =1 THEN 'Active' ELSE 'In Active' END STATUS
			FROM IVAP_MST_MENU M
			INNER JOIN IVAP_MST_MENU M1 ON M.TID = M1.PMENU
			WHERE M1.ENTITY_ID =@EID AND M1.NAME IS NOT NULL ORDER BY M1.ENTITY_ID,M1.PMENU,M1.DISPLAY_ORDER 
		ELSE
		BEGIN
			SELECT TID,ENTITY_ID,NAME,PMENU,ROUTE,ROLES,ACTIONS_NAME,ISACT,DISPLAY_ORDER FROM IVAP_MST_MENU WHERE ENTITY_ID=@EID AND TID = @TID
		END
	END
	ELSE
	BEGIN
		SELECT TID,ENTITY_ID,NAME,PMENU,ROUTE,ROLES,ACTIONS_NAME,ISACT,DISPLAY_ORDER FROM IVAP_MST_MENU WHERE ENTITY_ID=@EID AND NAME = @MenuName
	END
END

--select * from ivap_mst_Menu
GO
/****** Object:  StoredProcedure [dbo].[GETMENUACCESSCONTROL]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GETMENUACCESSCONTROL]
(
@ENTITY_ID INT
)
AS
BEGIN
select * from IVAP_MST_MENU where ENTITY_ID=@ENTITY_ID and ROUTE not in('ViewState','MasterMetaSetup','ViewPTAX','EntityComponentsList','FileSetupList','DataAccessControl','ViewLwf','ViewCurrency','ViewMinWage','Master','')
END

GO
/****** Object:  StoredProcedure [dbo].[GetMinWage]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_LOCATION
CREATE PROCEDURE [dbo].[GetMinWage]
(
	@MinWageID INT=0,
	@STATE_ID INT=0,
	--@LOCATION_ID INT=0,
	@IsAct VARCHAR(1)=''
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max);
	IF(@IsAct = '0')
		SET @IsAct =''
	SET @SQLString =N'SELECT M.TID,M.STATE_ID,M.CATEGORY,M.MIN_WAGE,format(M.EFF_DT_FROM,''dd/MM/yyyy'') EFF_DT_FROM,
					format(M.EFF_DATE_TO,''dd/MM/yyyy'') EFF_DATE_TO,M.ISACTIVE,
					CASE WHEN M.ISACTIVE = 1 THEN ''Active'' ELSE ''In Active'' END Status,S.STATE_NAME
					FROM IVAP_MST_MINWAGE M
					INNER JOIN IVAP_MST_STATE S ON M.STATE_ID = S.TID
					WHERE 1=1'
	IF(@MinWageID > 0)
	BEGIN
		SET @SQLString+=' AND M.TID=' + '@MinWageID'
	END
	IF(@STATE_ID > 0)
	BEGIN
		SET @SQLString+=' AND M.STATE_ID=' + '@STATE_ID'
	END
	--IF(@LOCATION_ID > 0)
	--BEGIN
	--	SET @SQLString+=' AND M.LOCATION_ID=' + '@LOCATION_ID'
	--END
	IF(len(@IsAct) > 0)
	BEGIN
		SET @SQLString+=' AND M.ISACTIVE=' + '@IsAct'
	END
	set @SQLString = @SQLString+' order by M.TID desc' 
	--print @SQLString
	SET @ParmDefinition = N'@MinWageID int,@STATE_ID INT, @IsAct VARCHAR(1) '; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @MinWageID,@STATE_ID,@IsAct
END
GO
/****** Object:  StoredProcedure [dbo].[GetMinWageHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetMinWageHis]
(
	@MinWageID INT=0
)
AS
BEGIN
	SELECT M.HISID,M.STATE_ID,M.CATEGORY,M.MIN_WAGE,M.EFF_DT_FROM,M.EFF_DATE_TO,M.ISACTIVE,
					CASE WHEN M.ISACTIVE = 1 THEN 'Active' ELSE 'In Active' END Status,S.STATE_NAME,ACTION
					FROM IVAP_HIS_MINWAGE M
					INNER JOIN IVAP_MST_STATE S ON M.STATE_ID = S.TID
					WHERE 1=1 AND MINWAGEID =@MinWageID
END

--select * from IVAP_HIS_MINWAGE
GO
/****** Object:  StoredProcedure [dbo].[GetMonthClose]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetMonthClose]
(
	@EID INT=15,
	@TID INT =0
)
AS
BEGIN
	SET NOCOUNT ON    
	DECLARE @currentM INT =0,@currentYear INT =0,@CurrentRow INT=0
	SET @currentM = (SELECT MONTH(GETDATE()))
	SET @currentYear = (SELECT YEAR(GETDATE()))

	IF EXISTS(SELECT * FROM IVAP_MONTH_CLOSE WHERE [MONTH] =@currentM AND [YEAR] =@currentYear AND ENTITY_ID=@EID)
	BEGIN
		SET @CurrentRow =1
	END
	IF(@TID =0)
	BEGIN
	SELECT MC.TID, MC.ENTITY_ID,DATENAME(MONTH, DATEADD(MONTH, MC.MONTH, -1 )) MONTH,MC.YEAR,
	CASE WHEN MC.STATUS ='OPEN' THEN FORMAT(MC.OPEN_DATE,'dd/MM/yyyy') ELSE FORMAT(MC.CLOSED_DATE,'dd/MM/yyyy') END CURRENT_STATUS_DATE,
	 FORMAT(MC.OPEN_DATE,'dd/MM/yyyy') OPEN_DATE, FORMAT(MC.CLOSED_DATE,'dd/MM/yyyy') CLOSED_DATE,MC.STATUS,   
      CASE WHEN MC.ISACT =1 THEN 'Active' ELSE 'IN Active' END ISACTIVE,E.ENTITY_NAME,E.ENTITY_CODE,MC.ISACT    
      FROM IVAP_MONTH_CLOSE MC    
      INNER JOIN IVAP_MST_ENTITY E ON MC.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1 AND MC.ENTITY_ID =@EID
		
	  UNION ALL SELECT 0 as TID,@EID AS ENTITY_ID,DATENAME(MONTH, DATEADD(MONTH, @currentM, -1 )) AS MONTH, @currentYear AS  YEAR,
	  FORMAT(GETDATE(),'dd/MM/yyyy') AS CURRENT_STATUS_DATE,FORMAT(GETDATE(),'dd/MM/yyyy') AS OPEN_DATE, null CLOSED_DATE,
	  'OPEN' STATUS, 'Active' AS ISACTIVE,ENTITY_NAME,ENTITY_CODE,1 AS ISACT  FROM IVAP_MST_ENTITY WHERE TID = @EID AND @CurrentRow =0
	END
	ELSE
	BEGIN
		SELECT MC.TID, MC.ENTITY_ID,DATENAME(MONTH, DATEADD(MONTH, MC.MONTH, -1 )) MONTH,MC.YEAR,
		CASE WHEN MC.STATUS ='OPEN' THEN FORMAT(MC.OPEN_DATE,'dd/MM/yyyy') ELSE FORMAT(MC.CLOSED_DATE,'dd/MM/yyyy') END CURRENT_STATUS_DATE,
		ISNULL(FORMAT(MC.OPEN_DATE,'dd/MM/yyyy'),'') OPEN_DATE,ISNULL(FORMAT(MC.CLOSED_DATE,'dd/MM/yyyy'),'') CLOSED_DATE,MC.STATUS,   
      CASE WHEN MC.ISACT =1 THEN 'Active' ELSE 'IN Active' END ISACTIVE,E.ENTITY_NAME,E.ENTITY_CODE,MC.ISACT    
      FROM IVAP_MONTH_CLOSE MC    
      INNER JOIN IVAP_MST_ENTITY E ON MC.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1 AND MC.ENTITY_ID =@EID AND MC.TID =@TID 
	END
END

 
GO
/****** Object:  StoredProcedure [dbo].[GetMonthClose_1]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM IVAP_MONTH_CLOSE    
CREATE PROC [dbo].[GetMonthClose_1]   
(    
 @TID INT=0,    
 @ENTITY_ID INT=0,    
 @IsAct VARCHAR(1)='1'
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
 IF(@IsAct = '0')    
  SET @IsAct =''    
  SET @SQLString =N'SELECT MC.TID, MC.ENTITY_ID,MC.MONTH,MC.YEAR,MC.OPEN_DATE,MC.CLOSED_DATE,MC.STATUS,   
      CASE WHEN MC.ISACT =1 THEN ''Active'' ELSE ''IN Active'' END ISACTIVE,E.ENTITY_NAME,E.ENTITY_CODE,MC.ISACT    
      FROM IVAP_MONTH_CLOSE MC    
      INNER JOIN IVAP_MST_ENTITY E ON MC.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1'    
 IF(@TID > 0)    
 BEGIN    
  SET @SQLString+=' AND MC.TID=' + '@TID'    
 END    
 IF(@ENTITY_ID > 0)    
 BEGIN    
  SET @SQLString+=' AND MC.ENTITY_ID=' + '@ENTITY_ID'    
 END    
 IF(len(@IsAct) > 0)    
 BEGIN    
  SET @SQLString+=' AND MC.ISACT=' + '@IsAct'    
 END    
 set @SQLString = @SQLString+' order by MC.TID desc'     
 SET @ParmDefinition = N'@TID int,@ENTITY_ID INT, @IsAct VARCHAR(1) ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @TID,@ENTITY_ID,@IsAct    
END
GO
/****** Object:  StoredProcedure [dbo].[GetMonthCloseHistory]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetMonthCloseHistory]
(
	@TID INT
)
AS
BEGIN
	SELECT MC.TID, MC.ENTITY_ID,DATENAME(MONTH, DATEADD(MONTH, MC.MONTH, -1 )) MONTH,MC.YEAR,FORMAT(MC.OPEN_DATE,'dd/MM/yyyy') OPEN_DATE,FORMAT(MC.CLOSED_DATE,'dd/MM/yyyy') CLOSED_DATE,MC.STATUS,   
      CASE WHEN MC.ISACT =1 THEN 'Active' ELSE 'IN Active' END ISACTIVE,E.ENTITY_NAME,E.ENTITY_CODE,MC.ISACT,ACTION
      FROM IVAP_HIS_MONTH_CLOSE MC    
      INNER JOIN IVAP_MST_ENTITY E ON MC.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1 AND MC.MONTH_CLOSE_ID =@TID
END

GO
/****** Object:  StoredProcedure [dbo].[GetPayComponentName]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPayComponentName]  
(  
 @FILETYPEID INT=0,  
 @ENTITYID INT=0
)  
AS  
BEGIN  
 IF(@FILETYPEID > 0)  
 BEGIN  
  select distinct COMPONENT_NAME from IVAP_MST_COMPONENT_ENTITY where tid in (select COMPONENT_ID  from IVAP_MST_FILE_COMP_DETAIL where file_id = @FILETYPEID) 
  and component_file_type = 'PAYMAST' and ENTITY_ID=@ENTITYID
 END  
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollCompDB]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetPayrollCompDB]  
(  
 @COMPONENT_NAME varchar(max),  
 @ENTITYID INT=0
)  
AS  

BEGIN  
declare @sqlqry nvarchar(max)='';
 IF(@ENTITYID > 0) 
  
 BEGIN
   
  set @sqlqry='select '+@COMPONENT_NAME+' from Ivap_MAST_TEMP_15'
  print(@sqlqry)
    exec (@sqlqry) 
END
END

GO
/****** Object:  StoredProcedure [dbo].[GetPayrollCompDB_0]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPayrollCompDB_0] 
(  
 @COMPONENT_NAME varchar(max), 
 @COMPONENT_LIST varchar(max), 
 @ENTITYID INT=0
)  
AS  

BEGIN  
declare @sqlqry nvarchar(max)='';
 IF(@ENTITYID > 0) 
  
 BEGIN
   
  set @sqlqry='select '+@COMPONENT_NAME+' from Ivap_MAST_TEMP_15 where CONVERT(varchar(10), CONVERT(date, paydate, 103), 120)=convert(varchar(10),DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, getdate()) + 1, 0)),126)
  union all select '+@COMPONENT_NAME+' from Ivap_MAST_TEMP_15 where CONVERT(varchar(10), CONVERT(date, paydate, 103), 120)=convert(varchar(10),DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, getdate()), 0)),126)
  union all select '+@COMPONENT_NAME+' from Ivap_MAST_TEMP_15 where CONVERT(varchar(10), CONVERT(date, paydate, 103), 120)=convert(varchar(10),DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, getdate()) -1, 0)),126)
  union all select '+@COMPONENT_NAME+' from Ivap_MAST_TEMP_15 where CONVERT(varchar(10), CONVERT(date, paydate, 103), 120)=convert(varchar(10),DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, getdate()) -2, 0)),126)'
 -- union all select '+@COMPONENT_NAME+' from Ivap_MAST_TEMP_15 where CONVERT(varchar(10), CONVERT(date, paydate, 103), 120)=convert(varchar(10),DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, getdate()) -11, 0)),126)
 -- print(@sqlqry)
    exec (@sqlqry) 
END
END
GO
/****** Object:  StoredProcedure [dbo].[GetPlant]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--SELECT * FROM IVAP_MST_Division    
CREATE PROC [dbo].[GetPlant]    
(    
 @PlantID INT=0,    
 @ENTITY_ID INT=0,    
 @PLANT_CODE VARCHAR(20)='',    
 @PLANT_NAME VARCHAR(200)='',    
 @IsAct VARCHAR(1)='1',  
 @UID INT=0    
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
 IF(@IsAct = '0')    
  SET @IsAct =''    
  SET @SQLString =N'SELECT P.TID, P.ENTITY_ID,P.PAY_PLANT_CODE,P.ERP_PLANT_CODE,P.PLANT_NAME,    
      CASE WHEN P.ISACTIVE =1 THEN ''Active'' ELSE ''In Active'' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,P.ISACTIVE    
      FROM IVAP_MST_PLANT P    
      INNER JOIN IVAP_MST_ENTITY E ON P.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1'    
 IF(@PlantID > 0)    
 BEGIN    
  SET @SQLString+=' AND P.TID=' + '@PlantID'    
 END    
 IF(@ENTITY_ID > 0)    
 BEGIN    
  SET @SQLString+=' AND P.ENTITY_ID=' + '@ENTITY_ID'    
 END    
 --IF(ISNULL(@PLANT_CODE,'') <> '')    
 --BEGIN    
 -- SET @SQLString+=' AND D.PLANT_CODE=' + '@PLANT_CODE'    
 --END    
 IF(ISNULL(@PLANT_NAME,'') <> '')    
 BEGIN    
  SET @SQLString+=' AND P.PLANT_NAME=' + '@PLANT_NAME'    
 END    
 IF(len(@IsAct) > 0)    
 BEGIN    
  SET @SQLString+=' AND P.ISACTIVE=' + '@IsAct'    
 END    
  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND P.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_PLANT''),'',''))'  
 END    
 set @SQLString = @SQLString+' order by P.TID desc'     
 SET @ParmDefinition = N'@PlantID int,@ENTITY_ID INT, @IsAct VARCHAR(1),@PLANT_CODE varchar(20),@PLANT_NAME varchar(200) ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @PlantID,@ENTITY_ID,@IsAct,@PLANT_CODE,@PLANT_NAME    
END
  
GO
/****** Object:  StoredProcedure [dbo].[GetPlantHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetPlantHis]
(
	@PlantID INT
)
AS
BEGIN
	SELECT P.ENTITY_ID,P.PAY_PLANT_CODE,P.ERP_PLANT_CODE,P.PLANT_NAME,
		CASE WHEN P.ISACTIVE =1 THEN 'Active' ELSE 'Is Active' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,ACTION
		FROM IVAP_HIS_PLANT P
		INNER JOIN IVAP_MST_ENTITY E ON P.ENTITY_ID=E.TID
		WHERE E.ISACTIVE=1 AND PLANTID =@PlantID
END
GO
/****** Object:  StoredProcedure [dbo].[GetProcess]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[GetProcess]  
(  
 @ENTITY_ID INT=0,  
 @IsAct Char(1)=0,  
 @TID INT=0,
 @UID INT=0
)  
AS  
BEGIN  
 DECLARE @Qry VARCHAR(MAX)='';  
 Set @Qry='select P.TID,P.ENTITY_ID, P.PAY_PROC_CODE, P.ERP_PROC_CODE, P.PROC_NAME, P.ISACTIVE,E.ENTITY_NAME,  
 CASE WHEN P.ISACTIVE=1 THEN ''Active'' ELSE ''In Active'' END STATUS,convert(varchar(10),P.created_on,103)[CREATED_ON]  
 from IVap_MST_Process P inner join Ivap_MST_entity E ON E.TID=P.ENTITY_ID  WHERE 1=1';  
 Set @Qry=@QRY+' AND P.ENTITY_ID='+ CAST(@ENTITY_ID As VARCHAR)  
 IF(@TID>0)  
 Set @Qry=@QRY+' AND P.TID='+ CAST(@TID As VARCHAR)  
 IF(@UID <> 0)
 BEGIN
	SET @Qry=@QRY+' AND P.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_PROCESS''),'',''))'
 END
 IF(@IsAct=1)  
 Set @Qry=@QRY+' AND P.ISACTIVE=1'
 --PRINT @Qry;
 EXEC(@Qry);  
END



--select * from IVAP_DATA_ACCESS_DTL where UID=47 and TABLE_NAME='IVAP_MST_PROCESS' and TIDS in(select P.TID,P.ENTITY_ID, P.PAY_PROC_CODE, P.ERP_PROC_CODE, P.PROC_NAME, P.ISACTIVE,E.ENTITY_NAME,  
-- convert(varchar(10),P.created_on,103)[CREATED_ON]  
-- from IVap_MST_Process P inner join Ivap_MST_entity E ON E.TID=P.ENTITY_ID  WHERE 1=1)
GO
/****** Object:  StoredProcedure [dbo].[GetProcessHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetProcessHis]              
(              
@PID INT,  
@EntityID INT              
)              
AS               
BEGIN              
SELECT P.PROC_ID,P.COMP_ID,E.ENTITY_NAME,P.PAY_PROC_CODE,P.ERP_PROC_CODE,P.PROC_NAME,P.CREATED_ON,P.CREATED_BY,P.UPDATE_ON,P.UPDATED_BY,P.ACTION FROM IVAP_HIS_PROCESS P   
INNER JOIN IVAP_MST_ENTITY E ON P.COMP_ID = E.TID        
WHERE P.PROC_ID=@PID AND P.COMP_ID=@EntityID            
END
GO
/****** Object:  StoredProcedure [dbo].[GetPTAX]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetPTAX]
(
	@PTaxID INT=0,
	@StateName varchar(200)=''
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max);

	SET @SQLString =N'select PT.TID,PT.STATE_ID,PT.PERIOD_FLAG,PT.DED_MONTH,DateName( month , DateAdd( month , PT.DED_MONTH , -1 ) ) DED_MONTHNAME,PT.YTD_MONTH_FROM,DateName( month , DateAdd( month , PT.YTD_MONTH_FROM , -1 ) ) YTD_MONTH_FROMNAME
	,PT.YTD_MONTH_TO,DateName( month , DateAdd( month , PT.YTD_MONTH_TO , -1 ) ) YTD_MONTH_TOName,PT.PT_SAL_FROM,PT.PT_SAL_TO,PT.GENDER,format(PT.EFF_FROM_DT,''dd/MM/yyyy'') EFF_FROM_DT,format(PT.EFF_TO_DT,''dd/MM/yyyy'') EFF_TO_DT,
	PT.PTAX,ST.STATE_NAME
	from IVAP_MST_PTAX PT  LEFT JOIN IVAP_MST_STATE ST ON PT.STATE_ID=ST.TID
	WHERE 1 =1'
	IF(@PTaxID > 0)
	BEGIN
		SET @SQLString+=' AND PT.TID=' + '@PTaxID'
	END

	IF(ISNULL(@StateName,'') <> '')
	BEGIN
		SET @SQLString+=' AND ST.STATE_NAME=' + '@StateName'
	END
	 
	set @SQLString = @SQLString+' order by TID desc' 
	SET @ParmDefinition = N'@PTaxID int,@StateName varchar(200) '; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @PTaxID,@StateName
END

GO
/****** Object:  StoredProcedure [dbo].[GetPTAXHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetPTAXHis]
(
	@PTAXID INT
)
AS
BEGIN
select PTH.PTAXID,PTH.PERIOD_FLAG,PTH.DED_MONTH,DateName( month , DateAdd( month , PTH.DED_MONTH , -1 ) ) DED_MONTHNAME,PTH.YTD_MONTH_FROM,DateName( month , DateAdd( month , PTH.YTD_MONTH_FROM , -1 ) ) YTD_MONTH_FROMNAME,PTH.YTD_MONTH_TO,DateName( month ,
 DateAdd( month , PTH.YTD_MONTH_TO , -1 ) ) YTD_MONTH_TOName,PTH.PT_SAL_FROM,PTH.PT_SAL_TO,PTH.GENDER,format(PTH.EFF_FROM_DT,'dd/MM/yyyy') EFF_FROM_DT,format(PTH.EFF_TO_DT,'dd/MM/yyyy') EFF_TO_DT,
	PTH.PTAX,ST.STATE_NAME,FORMAT(PTH.CREATED_ON,'dd/MM/yyyy') CREATED_ON,U.USER_FIRSTNAME CREATED_BY,CASE WHEN PTH.ACTION='Update' THEN U.USER_FIRSTNAME END UPDATED_BY,FORMAT(PTH.UPDATE_ON,'dd/MM/yyyy')UPDATE_ON,PTH.ACTION
	from IVAP_HIS_PTAX PTH  LEFT JOIN IVAP_MST_STATE ST ON PTH.STATE_ID=ST.TID INNER JOIN IVAP_MST_USER U ON PTH.CREATED_BY=U.UID
	WHERE PTH.PTAXID =@PTAXID 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPublishData]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetPublishData]
(
	@EntityID int=1
)
as
begin
DECLARE @Ivap_HR_Table_Name varchar(50); 
DECLARE @Ivap_SAL_Table_Name varchar(50); 
set @Ivap_HR_Table_Name= 'Ivap_HRD_MAST_'+cast(@EntityID as varchar(10));
set @Ivap_SAL_Table_Name= 'Ivap_PAY_MAST_'+cast(@EntityID as varchar(10));

select Name from sys.objects where type='U' and name=@Ivap_HR_Table_Name 
select Name from sys.objects where type='U' and name =@Ivap_SAL_Table_Name;

end

GO
/****** Object:  StoredProcedure [dbo].[GetRegion]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM IVAP_MST_REGION      
CREATE PROC [dbo].[GetRegion]      
(      
 @RegionID INT=0,      
 @ENTITY_ID INT=0,      
 @REGION_CODE VARCHAR(20)='',      
 @REGION_NAME VARCHAR(200)='',      
 @IsAct VARCHAR(1)='1',  
 @UID INT=0      
)      
AS      
BEGIN      
 SET NOCOUNT ON      
 DECLARE @SQLString nvarchar(Max);       
 DECLARE @ParmDefinition nvarchar(Max);      
 IF(@IsAct = '0')      
  SET @IsAct =''      
  SET @SQLString =N'SELECT R.TID, R.ENTITY_ID,R.PAY_REGION_CODE,R.ERP_REGION_CODE,R.REGION_NAME,      
      CASE WHEN R.ISACTIVE =1 THEN ''Active'' ELSE ''In Active'' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,R.ISACTIVE      
      FROM IVAP_MST_REGION R      
      INNER JOIN IVAP_MST_ENTITY E ON R.ENTITY_ID=E.TID      
      WHERE E.ISACTIVE=1'      
 IF(@RegionID > 0)      
 BEGIN      
  SET @SQLString+=' AND R.TID=' + '@RegionID'      
 END      
 IF(@ENTITY_ID > 0)      
 BEGIN      
  SET @SQLString+=' AND R.ENTITY_ID=' + '@ENTITY_ID'      
 END      
 --IF(ISNULL(@REGION_CODE,'') <> '')      
 --BEGIN      
 -- SET @SQLString+=' AND R.REGION_CODE=' + '@REGION_CODE'      
 --END      
 IF(ISNULL(@REGION_NAME,'') <> '')      
 BEGIN      
  SET @SQLString+=' AND R.REGION_NAME=' + '@REGION_NAME'      
 END      
 IF(len(@IsAct) > 0)      
 BEGIN      
  SET @SQLString+=' AND R.ISACTIVE=' + '@IsAct'      
 END      
 IF(@UID <> 0)      
 BEGIN      
  SET @SQLString=@SQLString+' AND R.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_REGION''),'',''))'  
 END   
  
 set @SQLString = @SQLString+' order by R.TID desc'       
 SET @ParmDefinition = N'@RegionID int,@ENTITY_ID INT, @IsAct VARCHAR(1),@REGION_CODE varchar(20),@REGION_NAME varchar(200) ';       
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @RegionID,@ENTITY_ID,@IsAct,@REGION_CODE,@REGION_NAME      
END
GO
/****** Object:  StoredProcedure [dbo].[GetRegionHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetRegionHis]  
(  
 @RegionID INT  
)  
AS  
BEGIN  
 SELECT R.ENTITY_ID,R.PAY_REGION_CODE,R.ERP_REGION_CODE,R.REGION_NAME,  
  CASE WHEN R.ISACTIVE =1 THEN 'Active' ELSE 'Is Active' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,ACTION  
  FROM IVAP_HIS_REGION R  
  INNER JOIN IVAP_MST_ENTITY E ON R.ENTITY_ID=E.TID  
  WHERE E.ISACTIVE=1 AND RegionID =@RegionID  
END  
  
--select * from IVAP_HIS_REGION
GO
/****** Object:  StoredProcedure [dbo].[GetRoles]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_USERROLE
--select * from IVAP_MST_ENTITY
CREATE PROC [dbo].[GetRoles]
(
	@RoleID INT=0,
	--@EntityID INT=0,
	@ROLENAME VARCHAR(200)=null,
	@IsAct VARCHAR(1)=''
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max);
	IF(@IsAct = '0')
		SET @IsAct =''
	SET @SQLString =N'SELECT U.TID,ROLENAME,ROLETYPE,ISACT,CASE WHEN ISACT=1 THEN ''Active'' ELSE ''In Active'' END STATUS FROM IVAP_MST_USERROLE U
					WHERE 1=1'
	IF(@RoleID > 0)
	BEGIN
		SET @SQLString+=' AND U.TID=' + '@RoleID'
	END
	--IF(@EntityID > 0)
	--BEGIN
	--	SET @SQLString+=' AND ENTITY_ID=' + '@EntityID'
	--END
	IF(@ROLENAME <> '')
	BEGIN
		SET @SQLString+=' AND ROLENAME=' + '@ROLENAME'
	END
	IF(len(@IsAct) > 0)
	BEGIN
		SET @SQLString+=' AND IsAct=' + '@IsAct'
	END
	set @SQLString = @SQLString+' order by TID desc' 
	SET @ParmDefinition = N'@RoleID int,@IsAct VARCHAR(1),@ROLENAME varchar(200) '; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @RoleID,@IsAct,@ROLENAME
END
GO
/****** Object:  StoredProcedure [dbo].[GetSection]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROC [dbo].[GetSection]                
(                
 @SectionID INT=0,                              
 @SectionName VARCHAR(200)='',     
 @ENTITYID INT =0,             
 @ISAct VARCHAR(1)='0',
 @UID INT=0                
)                
AS                
BEGIN                
 SET NOCOUNT ON                
 DECLARE @SQLString nvarchar(Max);                 
 DECLARE @ParmDefinition nvarchar(Max);                
 IF(@IsAct = '0')                
  SET @IsAct =''                
  SET @SQLString =N'SELECT S.TID,S.ENTITY_ID,E.ENTITY_NAME,S.PAY_SECTION_CODE,S.ERP_SECTION_CODE,S.SECTION_NAME,S.ISACTIVE,CASE WHEN S.ISACTIVE=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS FROM IVAP_MST_SECTION S   
  INNER JOIN IVAP_MST_ENTITY E ON S.ENTITY_ID = E.TID                    
   WHERE 1=1'                
 IF(@SectionID > 0)                
 BEGIN                
  SET @SQLString+=' AND S.TID=' + '@SectionID'                
 END                
  IF(@ENTITYID > 0)                
 BEGIN                
  SET @SQLString+=' AND S.ENTITY_ID=' + '@ENTITYID'                
 END        
 IF(ISNULL(@SectionName,'') <> '')                
 BEGIN                
  SET @SQLString+=' AND SECTION_NAME=' + '@SectionName'                
 END     
   IF(@UID <> 0)                
 BEGIN                
  SET @SQLString=@SQLString+' AND S.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_SECTION''),'',''))'
 END            
 set @SQLString = @SQLString+' order by TID desc'                 
 SET @ParmDefinition = N'@SectionID int,@SectionName varchar(200),@ENTITYID INT, @IsAct VARCHAR(1) ';     
 PRINT  @SQLString             
 EXECUTE sp_executesql @SQLString, @ParmDefinition,@SectionID,@SectionName ,@ENTITYID,@IsAct               
END   
  
    
GO
/****** Object:  StoredProcedure [dbo].[GetSectionHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetSectionHis]      
(      
@SECTID INT      
)      
AS       
BEGIN      
SELECT SH.TID,E.ENTITY_NAME,SH.PAY_SECTION_CODE,SH.ERP_SECTION_CODE,SH.SECTION_NAME,CASE WHEN ISNULL(SH.CREATED_ON,'') <>'' THEN U.USER_FIRSTNAME ELSE '' END CREATEDBY
,CASE WHEN ISNULL(SH.UPDATED_ON,'') <>'' THEN U.USER_FIRSTNAME ELSE '' END UPDATEDBY,FORMAT(SH.UPDATED_ON,'dd/MM/yyyy')UPDATED_ON,FORMAT(SH.CREATED_ON,'dd/MM/yyyy')CREATED_ON
,CASE WHEN SH.ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS
 FROM IVAP_HIS_SECTION SH INNER JOIN IVAP_MST_ENTITY E ON SH.ENTITY_ID = E.TID INNER JOIN IVAP_MST_USER U ON SH.CREATED_BY=U.UID     
WHERE SECTID=@SECTID      
END
GO
/****** Object:  StoredProcedure [dbo].[GetServiceAvailed]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetServiceAvailed]              
(                
 @SID INT=0,                
 @ISAct VARCHAR(1)='0'                
)                
AS                
BEGIN     
SET NOCOUNT ON
 DECLARE @SQLString nvarchar(Max);                 
 IF(@IsAct = '0')                
  SET @IsAct =''                
  SET @SQLString =N'SELECT TID,SERVICE_NAME[ServicesName],ISACTIVE FROM IVAP_MST_SERVICE_GLOBAL                      
   WHERE 1=1'                
 IF(@SID > 0)                
 BEGIN                
  SET @SQLString+=' AND TID=' + '@SID'                
 END                                
 EXECUTE sp_executesql @SQLString                
END 
GO
/****** Object:  StoredProcedure [dbo].[GetState]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELPTEXT GETSTATE
  
--SP_HELPTEXT ADDUPDATESTATE  
  
--SP_HELPTEXT GETSTATE  
  
    
    
 --sp_helptext getstate    
 --select * from ivap_mst_State      
      
CREATE PROC [dbo].[GetState]      
(      
 @StateID INT=0,      
 @StateName VARCHAR(200)=''      
)      
AS      
BEGIN      
 SET NOCOUNT ON      
 DECLARE @SQLString nvarchar(Max);       
 DECLARE @ParmDefinition nvarchar(Max);      
 SET @SQLString =N'SELECT TID,STATE_CODE,STATE_NAME,ISACTIVE,COUNTRY,CASE WHEN ISACTIVE=1 THEN ''ACTIVE'' ELSE ''INACTIVE'' END STATUS FROM IVAP_MST_STATE      
      WHERE 1=1'      
 IF(@StateID > 0)      
 BEGIN      
  SET @SQLString+=' AND TID=' + '@StateID'      
 END      
 IF(ISNULL(@StateName,'') <> '')      
 BEGIN      
  SET @SQLString+=' AND STATE_NAME=' + '@StateName'      
 END      
 set @SQLString = @SQLString+' order by TID desc'       
 SET @ParmDefinition = N'@StateID int,@StateName VARCHAR(200) ';       
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @StateID,@StateName      
END 
GO
/****** Object:  StoredProcedure [dbo].[GETSTATEHIS]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GETSTATEHIS]      
(      
@SID INT      
)      
AS      
BEGIN      
SELECT STATE_CODE,STATE_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,CASE WHEN ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS,ACTION,COUNTRY FROM IVAP_HIS_STATE      
WHERE SID=@SID      
END
GO
/****** Object:  StoredProcedure [dbo].[GetStateList]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetStateList]
AS
BEGIN
select TID,State_Code,State_Name,STATE_NAME+'('+ STATE_CODE+')' As StateNameAndCode from IVAP_MST_STATE

END
GO
/****** Object:  StoredProcedure [dbo].[GetSubFunction]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from IVAP_MST_SUB_FUNCTION  
--select * from ivap_mst_function  
  
CREATE proc [dbo].[GetSubFunction]    
(    
 @TID INT=0,    
 @ENTITYID INT=15,    
 @IsAct CHAR(1)='0',
 @UID INT=0    
)    
AS    
BEGIN    
 DECLARE @QRY VARCHAR(MAX)=''    
 SET @QRY='select SbFunc.TID,SbFunc.ENTITY_ID,SbFunc.PAY_SUB_FUNC_CODE,SbFunc.ERP_SUB_FUNC_CODE,SUB_FUNC_NAME,ENTITY.ENTITY_NAME,CASE WHEN SbFunc.ISACTIVE=1 THEN ''Active'' else ''In Active'' end STATUS,  
 SbFunc.ISACTIVE,SbFunc.PARENT_FUNC_ID ,Func.FUNC_NAME from IVAP_MST_SUB_FUNCTION SbFunc    
 INNER JOIN IVAP_MST_ENTITY ENTITY ON ENTITY.TID=SbFunc.ENTITY_ID  
 INNER JOIN IVAP_MST_FUNCTION Func ON Func.TID=SbFunc.PARENT_FUNC_ID  
  where 1=1';    
 IF(@TID>0)    
  SET @QRY=@QRY+' AND SbFunc.TID='+CAST(@TID AS VARCHAR)    
 IF(@ENTITYID>0)    
  SET @QRY=@QRY+' AND SbFunc.ENTITY_ID='+CAST(@ENTITYID AS VARCHAR)    
 IF(@IsAct<>'0')    
  SET @QRY=@QRY+' AND SbFunc.IsActive=''1'''; 
   IF(@UID<>0)    
  SET @QRY=@QRY+' AND SbFunc.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_SUB_FUNCTION''),'',''))'
  print (@QRY)    
 EXEC(@QRY)    
END 
GO
/****** Object:  StoredProcedure [dbo].[GetSubFunctionHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetSubFunctionHis]        
(        
@SID INT        
)        
AS         
BEGIN        
SELECT SID,ENTITY_ID,PAY_SUB_FUNC_CODE,ERP_SUB_FUNC_CODE,SUB_FUNC_NAME,PARENT_FUNC_ID,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION FROM IVAP_HIS_SUB_FUNCTION       
WHERE SID=@SID        
END
GO
/****** Object:  StoredProcedure [dbo].[GetTempTableData]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetTempTableData](@File_ID int ,@Batch_TempID int ,@TableName varchar(100))
as
begin
DECLARE @SqlQuery NVARCHAR(500)  ;
   DECLARE @ParmDefinition nvarchar(Max); 
--select * from Ivap_MAST_TEMP_15 where FILE_ID=@File_ID and TEMP_BATCH_ID=@Batch_TempID
set @SqlQuery= 'select * from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and TEMP_BATCH_ID='+convert(varchar(10),@Batch_TempID)
 SET @ParmDefinition = N'@File_ID int,@Batch_TempID int ,@TableName varchar(100)'; 
  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@Batch_TempID,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[GetTempTableData24]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetTempTableData24](@File_ID int ,@Effe_Date varchar(100)='',@Pay_Date varchar(100)='' ,@TableName varchar(100))
as
begin
DECLARE @SqlQuery NVARCHAR(500)  ;
   DECLARE @ParmDefinition nvarchar(Max); 
--select * from Ivap_MAST_TEMP_15 where FILE_ID=@File_ID and TEMP_BATCH_ID=@Batch_TempID
if(@Effe_Date!='' and @Pay_Date!='')
begin
set @SqlQuery= 'select * from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and EFFDATE='''+convert(varchar(15),@Effe_Date)+''' and PAY_DATE='''+convert(varchar(15),@Pay_Date)+''''
end
else if(@Effe_Date!='')
begin
set @SqlQuery= 'select * from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and EFFDATE='''+convert(varchar(15),@Effe_Date)+''''
end
else if(@Pay_Date!='')
begin
set @SqlQuery= 'select * from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and PAY_DATE='''+convert(varchar(15),@Pay_Date)+''''
end
else 
begin
set @SqlQuery= 'select * from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) 
end
--print  @SqlQuery 
 SET @ParmDefinition = N'@File_ID int,@Effe_Date varchar(100),@Pay_Date varchar(100),@TableName varchar(100)'; 
  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@Effe_Date,@Pay_Date,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[GetType]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[GetType]  
(    
 @IsAct VARCHAR(1)='1',    
 @TID INT=0,
 @EID INT=0,
 @UID INT=0    
)    
AS    
BEGIN    
 DECLARE @Qry VARCHAR(MAX)='';    
 Set @Qry='select T.TID,T.ENTITY_ID,E.ENTITY_NAME, T.PAY_TYPE_CODE, T.ERP_TYPE_CODE,T.TYPE_NAME,T.ISACTIVE,    
 CASE WHEN T.ISACTIVE=1 THEN ''Active'' ELSE ''In Active'' END STATUS,convert(varchar(10),T.created_on,103)[CREATED_ON]    
 from IVAP_MST_TYPE T  
 INNER JOIN IVAP_MST_ENTITY E ON T.ENTITY_ID = E.TID   
  WHERE 1=1';    
 IF(@TID>0)    
 Set @Qry=@QRY+' AND T.TID='+ CAST(@TID As VARCHAR)    
 IF(@IsAct=1)    
 Set @Qry=@QRY+' AND T.ISACTIVE=1'  
 IF(@EID>0)    
 Set @Qry=@QRY+' AND T.ENTITY_ID='+ CAST(@EID As VARCHAR)
 IF(@UID<>0)    
 Set @Qry=@QRY+' AND T.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_TYPE''),'',''))'
 EXEC(@Qry);    
END
 
GO
/****** Object:  StoredProcedure [dbo].[GetTypeHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetTypeHis]              
(              
@TYID INT,  
@EntityID INT              
)              
AS               
BEGIN              
SELECT T.TYID,T.ENTITY_ID,E.ENTITY_NAME,T.PAY_TYPE_CODE,T.ERP_TYPE_CODE,T.TYPE_NAME,T.CREATED_ON,T.CREATED_BY,T.UPDATE_ON,T.UPDATED_BY,T.ISACTIVE,CASE WHEN T.ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS,T.ACTION FROM IVAP_HIS_TYPE T
INNER JOIN IVAP_MST_ENTITY E ON T.ENTITY_ID = E.TID        
WHERE T.TYID=@TYID AND T.ENTITY_ID=@EntityID            
END
GO
/****** Object:  StoredProcedure [dbo].[GetUser]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ivap_mst_user
 CREATE PROC [dbo].[GetUser]
(
	@UID INT=0,
	@ENTITY_ID INT=0,
	@USERID VARCHAR(200)='',
	@USER_ROLE INT=0
)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @SQLString nvarchar(Max); 
    DECLARE @ParmDefinition nvarchar(Max); 
	IF(@USERID=null)
			SET @USERID=''
	SET @SQLString = 'SELECT U.UID,U.ENTITY_ID,E.ENTITY_NAME,E.ENTITY_CODE,U.USERID,U.USER_FIRSTNAME,U.USER_LASTNAME,U.USER_EMAIL,U.PROFILE_PIC[PROFILEPIC],
						U.USER_ROLE,R.ROLENAME,USER_MOBILENO,U.PASSWORD,U.ISAUTH,U.ISACT,CASE WHEN U.ISACT =1 THEN ''Active'' ELSE ''In Active'' END STATUS, 
						(U.USER_FIRSTNAME +'' '' + U.USER_LASTNAME) AS USERNAME
					FROM IVAP_MST_USER U
					INNER JOIN IVAP_MST_ENTITY E ON U.ENTITY_ID = E.TID
					INNER JOIN IVAP_MST_USERROLE R ON U.USER_ROLE = R.TID
					WHERE 1=1'
	IF(@UID > 0)
	BEGIN
		SET @SQLString+=' AND U.UID=' + '@UID'
	END
	IF(@ENTITY_ID >0)
	BEGIN
		SET @SQLString+=' AND U.ENTITY_ID=' + '@ENTITY_ID'
	END
	IF(@USERID <> '')
	BEGIN
		SET @SQLString+=' AND U.USERID=' + '@USERID'
	END
	IF(@USER_ROLE >0)
	BEGIN
		SET @SQLString+=' AND U.USER_ROLE=' + '@USER_ROLE'
	END
	SET @SQLString+= ' Order by  UID DESC'
	SET @ParmDefinition = N'@UID INT,@ENTITY_ID INT,@USERID VARCHAR(200),@USER_ROLE INT';
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @UID,@ENTITY_ID,@USERID,@USER_ROLE
END
GO
/****** Object:  StoredProcedure [dbo].[GETUSERCOPYRIGHT]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GETUSERCOPYRIGHT]
(
 @UID INT=0,  
 @ENTITY_ID INT=0,  
 @USERID VARCHAR(200)='' 
)
AS
BEGIN 
SET NOCOUNT ON  
    DECLARE @SQLString nvarchar(Max);   
    DECLARE @ParmDefinition nvarchar(Max);   
 IF(@USERID=null)  
   SET @USERID=''  
 SET @SQLString = 'SELECT U.UID,U.ENTITY_ID,E.ENTITY_NAME,E.ENTITY_CODE,U.USERID,U.USER_FIRSTNAME,U.USER_LASTNAME,U.USER_EMAIL,U.PROFILE_PIC[PROFILEPIC],  
      U.USER_ROLE,R.ROLENAME,USER_MOBILENO,U.PASSWORD,U.ISAUTH,U.ISACT,CASE WHEN U.ISACT =1 THEN ''Active'' ELSE ''In Active'' END STATUS,   
      (U.USER_FIRSTNAME +'' '' + U.USER_LASTNAME) AS USERNAME  
     FROM IVAP_MST_USER U  
     INNER JOIN IVAP_MST_ENTITY E ON U.ENTITY_ID = E.TID  
     INNER JOIN IVAP_MST_USERROLE R ON U.USER_ROLE = R.TID  
     WHERE 1=1'  
 IF(@UID > 0)  
 BEGIN  
  SET @SQLString+=' AND U.UID<>' + '@UID'  
 END  
 IF(@ENTITY_ID >0)  
 BEGIN  
  SET @SQLString+=' AND U.ENTITY_ID=' + '@ENTITY_ID'  
 END  
 IF(@USERID <> '')  
 BEGIN  
  SET @SQLString+=' AND U.USERID=' + '@USERID'  
 END 
 SET @SQLString+= ' Order by  UID DESC'  
 SET @ParmDefinition = N'@UID INT,@ENTITY_ID INT,@USERID VARCHAR(200)';  
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @UID,@ENTITY_ID,@USERID  
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserFromPassKey]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[GetUserFromPassKey]
(
 @p_Randomkey Varchar(max)
)
AS
Begin
Select U.UId ,U.Userid,P.Keytype,P.Isused,p.createdon From
IVAP_MST_USER U inner join IVAP_MST_PASSLINK P on P.UID=U.UID
Where upper(P.Randomkey)=upper(@p_Randomkey) AND ISUSED=0
End
GO
/****** Object:  StoredProcedure [dbo].[GetUserHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetUserHis]
(
	@UID INT =47
)
AS
BEGIN
	SELECT U.UID,U.ENTITY_ID,E.ENTITY_NAME,E.ENTITY_CODE,U.USERID,U.USER_FIRSTNAME,U.USER_LASTNAME,U.USER_FIRSTNAME,U.USER_LASTNAME,U.USER_EMAIL,
						U.USER_ROLE,U.USER_MOBILENO,R.ROLENAME,U.PASSWORD,U.ISAUTH,U.ISACT,CASE WHEN U.ISACT =1 THEN 'Active' ELSE 'In Active' END STATUS,
						format(UPDATE_ON,'dd/MM/yyyy') UPDATE_ON,format(U.CREATED_ON,'dd/MM/yyyy') CREATED_ON,ACTION
					FROM IVAP_HIS_USER U
					INNER JOIN IVAP_MST_ENTITY E ON U.ENTITY_ID = E.TID
					INNER JOIN IVAP_MST_USERROLE R ON U.USER_ROLE = R.TID
					WHERE UID =@UID
END

--select * from IVAP_HIS_USER

GO
/****** Object:  StoredProcedure [dbo].[GetUserMenu]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetUserMenu]
(
	@Roles VARCHAR(200)='Central Admin'
)
AS
BEGIN
	SET NOCOUNT ON
		SELECT TID,Name,Pmenu,Route,Roles,DISPLAY_ORDER,ACTIONS_NAME,Controller,IsAct,Image,MENU_TYPE FROM 
		IVAP_MST_MENU WHERE IsAct=1 and ROLES Like '%{'+@Roles+':%' order by Pmenu, DISPLAY_ORDER	
END 
GO
/****** Object:  StoredProcedure [dbo].[GetUserMenu_EID]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetUserMenu_EID]  
(  
 @Roles VARCHAR(200)='CLIENT ADMIN',  
 @Entity_ID INT=27  
)  
AS  
BEGIN  
 SET NOCOUNT ON  
 SELECT TID,Name,Pmenu,Route,Roles,DISPLAY_ORDER,ACTIONS_NAME,Controller,IsAct,Image,MENU_TYPE FROM   
 IVAP_MST_MENU WHERE IsAct=1 and ROLES Like '%{'+@Roles+':%'  AND ENTITY_ID=@Entity_ID order by Pmenu, DISPLAY_ORDER   
END 
GO
/****** Object:  StoredProcedure [dbo].[GETUSERMENUACCESS]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
CREATE PROC [dbo].[GETUSERMENUACCESS]    
(    
@EID INT  =1  
)    
AS    
BEGIN    
SELECT * FROM IVAP_MST_MENU WHERE ENTITY_ID=@EID AND ROUTE NOT IN('ViewRoles','ViewState','ViewMenu','MasterMetaSetup','ViewCurrency','ViewPTAX','ViewLWF','EntityList','ViewUser','ViewMinWage','ViewGlobalComponent','EntityComponentsList','DataAccessControl','','ViewGlobalLocation','FileSetupList','UploadFile','DataAccessControl',' ','CalendarSetup','MonthClose','CalendarSetup','MonthClose','WorkFlowSetting','MyRequest','PayRollProcessing','DummyDashBoard')    
    
END  
GO
/****** Object:  StoredProcedure [dbo].[GetUserRoleHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetUserRoleHis]
(
	@ROLEID INT
)
AS
BEGIN
	--select * from IVAP_HIS_USERROLE

	SELECT R.ROLENAME,R.ROLETYPE,R.CREATED_ON,format(R.UPDATED_ON,'dd/MM/yyyy') UPDATED_ON,U.USER_FIRSTNAME UPDATED_BY,
	CASE WHEN R.IsAct =1 THEN 'Active' ELSE 'InActive' END Status,Action
	 FROM IVAP_HIS_USERROLE R
	 INNER JOIN IVAP_MST_USER U ON R.UPDATED_BY = U.UID
	 --INNER JOIN IVAP_MST_ENTITY E ON R.ENTITY_ID = E.TID
	  WHERE ROLE_ID =@ROLEID
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserRoleWise]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetUserRoleWise]
(
	@RoleID INT ,
	@EntityID int,
	@File_ID int,
	@StringFile_ID varchar(10)
)
AS
BEGIN

select u.USER_FIRSTNAME,u.USERID,u.USER_EMAIL,u.USER_MOBILENO,e.ENTITY_NAME from ivap_mst_user U inner join IVAP_MST_ENTITY E on u.ENTITY_ID=e.TID
where u.USER_ROLE=@RoleID and U.ISACT=1 AND UID in (select UID from IVAP_DATA_ACCESS_DTL where TIDS like @StringFile_ID) AND E.TID=@EntityID
END
GO
/****** Object:  StoredProcedure [dbo].[GetWorkFlowSetting]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetWorkFlowSetting]
(
	@WFSID INT,
	@FILE_ID INT ,
	@ENTITY_ID INT ,
	@USER_ROLE INT
)
AS
BEGIN
 DECLARE @SQLString nvarchar(Max);   
 DECLARE @ParmDefinition nvarchar(Max);  
 SET @SQLString=N'
 select WFS.TID,WFS.ORDERING,WFS.FILE_ID,WFS.ENTITY_ID,WFS.ISACTIVE,1 as ISChecked,WFS.USER_ROLE,FT.FILE_TYPE,UR.ROLENAME,UR.TID AS ROLEID,(select count(*) from ivap_mst_user where user_role= UR.TID and ISACT=1) USERCOUNT,CASE WHEN WFS.ISACTIVE=1 THEN ''Active'' else ''In Active'' end STATUS ,ENTITY.ENTITY_NAME 
	from IVAP_MST_WorkFlowSetting WFS INNER JOIN IVAP_MST_ENTITY ENTITY ON WFS.ENTITY_ID =ENTITY.TID INNER join IVAP_MST_FILETYPE FT on WFS.FILE_ID =FT.TID
	inner join IVAP_MST_USERROLE  UR on WFS.USER_ROLE=UR.TID 
	WHERE 1=1 '

	IF(@WFSID > 0)  
 BEGIN  
  SET @SQLString+=' WFS.TID =@WFSID' 
 END  
 IF(@FILE_ID > 0)  
 BEGIN  
  SET @SQLString+=' AND WFS.FILE_ID=' + '@FILE_ID'  
 END  
  IF(@ENTITY_ID > 0)  
 BEGIN  
  SET @SQLString+=' AND WFS.ENTITY_ID=' + '@ENTITY_ID'  
 END 
  IF(@USER_ROLE > 0)  
 BEGIN  
  SET @SQLString+=' AND WFS.USER_ROLE=' + '@USER_ROLE'  
 END 
   set @SQLString = @SQLString+' order by WFS.ORDERING'   
 SET @ParmDefinition = N'@WFSID int,@FILE_ID INT,@ENTITY_ID INT,@USER_ROLE INT ';   
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @WFSID,@FILE_ID,@ENTITY_ID,@USER_ROLE 
END
GO
/****** Object:  StoredProcedure [dbo].[GetWorkFlowSetting31]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetWorkFlowSetting31]
(
	@FILE_ID INT ,
	@ENTITY_ID INT ,
	@StringFile_ID varchar(10)
)
AS
BEGIN

select WFS.TID,WFS.ORDERING,WFS.FILE_ID,WFS.ENTITY_ID,WFS.ISACTIVE,1 as ISChecked,WFS.USER_ROLE,FT.FILE_TYPE,UR.ROLENAME,UR.TID AS ROLEID,CASE WHEN WFS.ISACTIVE=1 THEN 'Active' else 'In Active' end STATUS ,ENTITY.ENTITY_NAME 
	from IVAP_MST_WorkFlowSetting WFS INNER JOIN IVAP_MST_ENTITY ENTITY ON WFS.ENTITY_ID =ENTITY.TID INNER join IVAP_MST_FILETYPE FT on WFS.FILE_ID =FT.TID
	inner join IVAP_MST_USERROLE  UR on WFS.USER_ROLE=UR.TID 
	WHERE  WFS.FILE_ID= @FILE_ID AND WFS.ENTITY_ID=@ENTITY_ID order by WFS.ORDERING

 select count(UR.TID) USERCOUNT,UR.TID ROLEID from ivap_mst_user US INNER JOIN IVAP_MST_USERROLE UR ON US.user_role= UR.TID
 inner join IVAP_MST_ENTITY E on US.ENTITY_ID=e.TID 
 where  US.ISACT=1 AND  UID in (select UID from IVAP_DATA_ACCESS_DTL where TIDS like @StringFile_ID)  AND E.TID=@ENTITY_ID GROUP BY UR.TID

END
GO
/****** Object:  StoredProcedure [dbo].[GetWorkFlowSettingHis]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetWorkFlowSettingHis]
(
	@WFSID INT
)
AS
BEGIN
 select WFS.TID,WFS.WFSID,WFS.ORDERING,FT.FILE_TYPE,UR.ROLENAME,US.USER_FIRSTNAME CREATED_BY,CASE WHEN WFS.ISACTIVE=1 THEN 'Active' else 'In Active' end STATUS ,ENTITY.ENTITY_NAME 
	from IVAP_HIS_WorkFlowSetting WFS LEFT JOIN IVAP_MST_ENTITY ENTITY ON WFS.ENTITY_ID =ENTITY.TID left join IVAP_MST_FILETYPE FT on WFS.FILE_ID =FT.TID
	inner join IVAP_MST_USERROLE  UR on WFS.USER_ROLE=UR.TID 
	inner join IVAP_MST_USER  US on WFS.CREATED_BY=UR.TID 
	WHERE WFS.WFSID =@WFSID
END
GO
/****** Object:  StoredProcedure [dbo].[GLOBALLOCATION_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GLOBALLOCATION_HISTORY]
(
@LID INT,    
@UpdatedBy INT,      
@Action VARCHAR(100) 
)
AS
BEGIN
INSERT INTO IVAP_HIS_LOCATION_GLOBAL(LID,LOC_CODE,LOC_NAME,STATE_ID,ISMETRO,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION)
SELECT TID,LOC_CODE,LOC_NAME,STATE_ID,ISMETRO,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_LOCATION_GLOBAL
END
GO
/****** Object:  StoredProcedure [dbo].[InsertDefaultMasterMeta]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[InsertDefaultMasterMeta]
(
	@Entity_ID INT=1
)
AS
BEGIN
	INSERT INTO IVAP_META_MASTER(ENTITY_ID,SCREEN_NAME,DISPLAY_NAME,FIELD_NAME,TABLE_NAME,DISPLAY_ORDER)
	select @Entity_ID,SCREEN_NAME,DISPLAY_NAME,FIELD_NAME,TABLE_NAME,DISPLAY_ORDER from IVAP_META_MASTER_DEFAULT
	select 1
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertDefaultMenu]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[InsertDefaultMenu]
(
@Entity_ID INT,
@NAME varchar(20),
@PMENU INT,
@ROLES varchar(200),
@DISPLAY_ORDER int,
@ACTIONS_NAME varchar(200),
@IMAGE varchar(200),
@CONTROLLER varchar(100),
@MENU_TYPE varchar(100),
@Route Varchar(50)
)
AS
begin
	insert into Ivap_Mst_Menu(Entity_ID,Name,Pmenu,Roles,Display_Order,Actions_Name,Image,CONTROLLER,MENU_TYPE,ISACT,Route)
	values(@Entity_ID, @Name,@Pmenu,@Roles,@Display_Order,@ACTIONS_NAME,@Image,@CONTROLLER,@MENU_TYPE,1,@Route)
	select SCOPE_IDENTITY()
end
GO
/****** Object:  StoredProcedure [dbo].[LEAVINGREASON_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[LEAVINGREASON_HISTORY]    
(    
@LEAVID INT,     
@UpdatedBy INT,      
@Action VARCHAR(100)                
)    
AS    
BEGIN    
INSERT INTO IVAP_HIS_LEAVING_REASON(LEAID,ENTITY_ID,PAY_LEAVING_CODE,ERP_LEAVING_CODE,[VOL/NON_VOL],REASON,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,ACTION)    
SELECT TID,ENTITY_ID,PAY_LEAVING_CODE,ERP_LEAVING_CODE,[VOL/NON_VOL],REASON,CREATED_ON,CREATED_BY,UPDATED_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_LEAVING_REASON    
END  
GO
/****** Object:  StoredProcedure [dbo].[LEVEL_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ivap_mst_Division
--select * from ivap_his_Plant
CREATE PROC [dbo].[LEVEL_HISTORY]
(
	@LevelID INT,
	@Updated_By INT,
	@Action VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_LEVEL(LEVELID,ENTITY_ID,PAY_LEVEL_CODE,ERP_LEVEL_CODE,LEVEL_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION)
		SELECT TID,ENTITY_ID,PAY_LEVEL_CODE,ERP_LEVEL_CODE,LEVEL_NAME,CREATED_ON,CREATED_BY,GETDATE(),@Updated_By,ISACTIVE,@Action 
		FROM IVAP_MST_LEVEL WHERE TID = @LevelID

END
GO
/****** Object:  StoredProcedure [dbo].[LOCATION_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[LOCATION_HISTORY]    
(    
@LOCID INT,    
@UpdatedBy INT,      
@Action VARCHAR(100)     
)    
AS    
BEGIN    
INSERT INTO IVAP_HIS_LOCATION(LOC_ID,ENTITY_ID,PAY_LOC_CODE,ERP_LOC_CODE,LOC_NAME,STATE_ID,ISMETRO,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION,PARENT_LOC_ID)    
SELECT TID,ENTITY_ID,PAY_LOC_CODE,ERP_LOC_CODE,LOC_NAME,STATE_ID,ISMETRO,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action,PARENT_LOC_ID FROM IVAP_MST_LOCATION              
END  
GO
/****** Object:  StoredProcedure [dbo].[LogError]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[LogError]
(
  @p_UID int,
  @p_ControllerName VARCHAR(100),
  @p_ActionName VARCHAR(100),
  @p_Error VARCHAR(max)
  --Result Out  number
)
AS
BEGIN
  INSERT INTO IVAP_LOG_ERROR(UID,CONTROLLER_NAME,ACTION_NAME,ERROR,CREATED_DATE)
		VALUES(@p_UID,@p_ControllerName,@p_ActionName,@p_Error,getdate())
	select SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[LogUserLogin]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
procedure [dbo].[LogUserLogin]
(
    @Uid  int,
    @Ipaddress varchar(20),
    @MACKADDRESS varchar(50),
    @SessionID VARCHAR(2000)
)
AS
begin
                Insert into IVAP_LOGIN_LOG(UID,IP_ADDRESS,MAC_ADDRESS,session_ID,LOGIN_TIME) 
				VALUES(@Uid,@Ipaddress,@MACKADDRESS,@SessionID,getdate());
                Update IVAP_MST_USER Set PASSWORD_TRY=0 Where UID=@Uid;
                select 1
END
GO
/****** Object:  StoredProcedure [dbo].[LWF_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[LWF_History]
(
	@LWFID INT,
	@UPDATED_BY INT,
	@Action VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_LWF(
	LWFID,
STATE_ID,
LOCATION_ID,
PERIOD_FLAG,
DED_MONTH,
LWF_EMPLOYEE,
LWF_EMPLOYER,
CREATED_ON,
CREATED_BY,
UPDATE_ON,
UPDATED_BY,
ISACTIVE,
EFF_FROM_DT,
EFF_TO_DT,
ACTION
)
	SELECT
		TID,
		STATE_ID,
LOCATION_ID,
PERIOD_FLAG,
DED_MONTH,
LWF_EMPLOYEE,
LWF_EMPLOYER,
CREATED_ON,
CREATED_BY,
GETDATE(),
@UPDATED_BY,
ISACTIVE,
EFF_FROM_DT,
EFF_TO_DT,
@Action
		
		FROM IVAP_MST_LWF
		WHERE TID=@LWFID
END
GO
/****** Object:  StoredProcedure [dbo].[MASTERLABEL]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[MASTERLABEL](@ENTITYID INT =0)
   AS
   BEGIN
   select distinct SCREEN_NAME  from IVAP_META_MASTER METAM INNER JOIN IVAP_MST_ENTITY EN ON METAM.ENTITY_ID=EN.TID WHERE METAM.ENTITY_ID=@ENTITYID
 END
GO
/****** Object:  StoredProcedure [dbo].[MINWAGE_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_MINWAGE
CREATE PROC [dbo].[MINWAGE_HISTORY]
(
	@MinWageID INT,
	@Updated_BY INT,
	@Action VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_MINWAGE(MINWAGEID,STATE_ID,CATEGORY,MIN_WAGE,EFF_DT_FROM,EFF_DATE_TO,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,ACTION)
		SELECT TID,STATE_ID,CATEGORY,MIN_WAGE,EFF_DT_FROM,EFF_DATE_TO,CREATED_ON,CREATED_BY,GETDATE(),@Updated_BY,ISACTIVE,@Action
		FROM IVAP_MST_MINWAGE WHERE TID = @MinWageID
END
GO
/****** Object:  StoredProcedure [dbo].[MonthClose_HIS]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[MonthClose_HIS]
(
	@TID INT,
	@UPDATED_BY INT,
	@ACTION VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_MONTH_CLOSE(MONTH_CLOSE_ID,ENTITY_ID,MONTH,YEAR,OPEN_DATE,CLOSED_DATE,STATUS,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACT,ACTION)
		SELECT TID,ENTITY_ID,MONTH,YEAR,OPEN_DATE,CLOSED_DATE,STATUS,CREATED_ON,CREATED_BY,GETDATE(),@UPDATED_BY,ISACT,@ACTION
		FROM IVAP_MONTH_CLOSE WHERE TID = @TID
END
GO
/****** Object:  StoredProcedure [dbo].[MY_REQUEST_FILE]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[MY_REQUEST_FILE]
(
@TABLE_NAME VARCHAR(100)='IVAP_MAST_TEMP_15'
)
AS

BEGIN

	--select FILE_ID,Count(FILE_ID) as COUNTROW from @TABLE_NAME where STATUS='Awaiting Approval' group by FILE_ID

				  DECLARE @SqlQuery NVARCHAR(500)  ;  
				  DECLARE @ParmDefinition nvarchar(Max); 
				  SET @SqlQuery= 'select Filet.FILE_NAME,tem.FILE_ID,Count(tem.FILE_ID) as COUNTROW from ' +@TABLE_NAME+ ' tem inner join IVAP_MST_FILETYPE Filet  on tem.FILE_ID= Filet.TID  where STATUS=''Awaiting Approval'' group by tem.FILE_ID,Filet.FILE_NAME' 
				  SET @ParmDefinition = N'@TABLE_NAME varchar(100)';   
				  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition,@TABLE_NAME  

END
GO
/****** Object:  StoredProcedure [dbo].[MY_REQUEST_FILE_0]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[MY_REQUEST_FILE_0]
(
       @TABLE_NAME VARCHAR(100)='IVAP_MAST_TEMP_15',
       @UID INT=1,
	   @Status varchar(100)='Awatting Approval'
)
AS

BEGIN

       --select FILE_ID,Count(FILE_ID) as COUNTROW from @TABLE_NAME where STATUS='Awaiting Approval' group by FILE_ID

                             DECLARE @SqlQuery NVARCHAR(500)  ;  
                             DECLARE @ParmDefinition nvarchar(Max); 
                             SET @SqlQuery= 'select Filet.FILE_NAME,tem.FILE_ID,Count(tem.FILE_ID) as COUNTROW from ' +@TABLE_NAME+ ' tem inner join IVAP_MST_FILETYPE Filet  on tem.FILE_ID= Filet.TID  where tem.Temp_STATUS='''+@Status+''''
                             SET @SqlQuery=@SqlQuery+' AND  Filet.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_FILETYPE''),'',''))'
                             SET @SqlQuery=@SqlQuery+'group by tem.FILE_ID,Filet.FILE_NAME' 
                             SET @ParmDefinition = N'@TABLE_NAME varchar(100)';   
                             
                             print @SqlQuery
                             EXECUTE sp_executesql @SqlQuery ,@ParmDefinition,@TABLE_NAME  

END

GO
/****** Object:  StoredProcedure [dbo].[PAYROLLPROCESS]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[PAYROLLPROCESS]
(
@TABLE_NAME VARCHAR(100)='IVAP_MAST_TEMP_15'
)
AS

BEGIN

	--select FILE_ID,Count(FILE_ID) as COUNTROW from @TABLE_NAME where STATUS='Awaiting Approval' group by FILE_ID

				  DECLARE @SqlQuery NVARCHAR(500)  ;  
				  DECLARE @ParmDefinition nvarchar(Max); 
				  SET @SqlQuery= 'select Filet.FILE_NAME,tem.FILE_ID,Count(tem.FILE_ID) as COUNTROW from ' +@TABLE_NAME+ '  tem inner join IVAP_MST_FILETYPE Filet  on tem.FILE_ID= Filet.TID  where tem.STATUS=''Approved'' group by tem.FILE_ID,Filet.FILE_NAME' 
				  SET @ParmDefinition = N'@TABLE_NAME varchar(100)';   
				  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition,@TABLE_NAME  

END
GO
/****** Object:  StoredProcedure [dbo].[PAYROLLPROCESS_1]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PAYROLLPROCESS_1]
(
@TABLE_NAME VARCHAR(100)='IVAP_MAST_TEMP_15',
@UID INT=1
)
AS

BEGIN

	--select FILE_ID,Count(FILE_ID) as COUNTROW from @TABLE_NAME where STATUS='Awaiting Approval' group by FILE_ID

				  DECLARE @SqlQuery NVARCHAR(500)  ;  
				  DECLARE @ParmDefinition nvarchar(Max); 
				  SET @SqlQuery= 'select Filet.FILE_NAME,tem.FILE_ID,Count(tem.FILE_ID) as COUNTROW from ' +@TABLE_NAME+ '  tem inner join IVAP_MST_FILETYPE Filet  on tem.FILE_ID= Filet.TID  where tem.Temp_STATUS=''Approved''' 
				  SET @SqlQuery=@SqlQuery+' AND  Filet.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_FILETYPE''),'',''))'
                  SET @SqlQuery=@SqlQuery+'group by tem.FILE_ID,Filet.FILE_NAME' 
				  SET @ParmDefinition = N'@TABLE_NAME varchar(100)';   
				  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition,@TABLE_NAME  

END
GO
/****** Object:  StoredProcedure [dbo].[PLANT_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ivap_mst_Division
--select * from ivap_his_Plant
CREATE PROC [dbo].[PLANT_HISTORY]
(
	@PlantID INT,
	@Updated_By INT,
	@Action VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_PLANT(PLANTID,ENTITY_ID,PAY_PLANT_CODE,ERP_PLANT_CODE,PLANT_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION)
		SELECT TID,ENTITY_ID,PAY_PLANT_CODE,ERP_PLANT_CODE,PLANT_NAME,CREATED_ON,CREATED_BY,GETDATE(),@Updated_By,ISACTIVE,@Action 
		FROM IVAP_MST_PLANT WHERE TID = @PlantID

END
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROCESS_HISTORY]    
(    
@CID INT,     
@UpdatedBy INT,      
@Action VARCHAR(100)                
)    
AS    
BEGIN    
INSERT INTO IVAP_HIS_PROCESS(PROC_ID,COMP_ID,PAY_PROC_CODE,ERP_PROC_CODE,PROC_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ACTION)    
SELECT TID,ENTITY_ID,PAY_PROC_CODE,ERP_PROC_CODE,PROC_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,@Action FROM IVAP_MST_PROCESS   
END 
GO
/****** Object:  StoredProcedure [dbo].[PublishHRDComponent]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[PublishHRDComponent]
(
	@Qry_Text varchar(Max)=' Create table Ivap_HRD_MAST_1(TID int IDENTITY(1, 1) PRIMARY KEY,Pay_Date Date,Created_On datetime default(getdate()),Created_By int, COMP_CODE int,COST_CODE int,DEPT_CODE int,DIVI_CODE int,DSG_CODE int,GRD_CODE int,LOC_CODE int,LREASON int,PROC_CODE int,REGN_CODE int,SECT_CODE int,STATE_CODE int,TYPE_CODE int,BANK_CODE nvarchar(50),ESISALARY numeric(16,2),FPFSALARY numeric(16,2),PFSALARY numeric(16,2));; Create table Ivap_HRD_HIS_1(TID int IDENTITY(1, 1) PRIMARY KEY,HRDID INT,Updated_ON datetime default(getdate()),updated_by int not null,Action varchar(200) ,Pay_Date Date,Created_On datetime default(getdate()),Created_By int, COMP_CODE int,COST_CODE int,DEPT_CODE int,DIVI_CODE int,DSG_CODE int,GRD_CODE int,LOC_CODE int,LREASON int,PROC_CODE int,REGN_CODE int,SECT_CODE int,STATE_CODE int,TYPE_CODE int,BANK_CODE nvarchar(50),ESISALARY numeric(16,2),FPFSALARY numeric(16,2),PFSALARY numeric(16,2));',
	@Table_Name VARCHAR(100)='Ivap_HRD_MAST_1'

)
AS
BEGIN
EXEC(@Qry_Text)
 --Create table Ivap_HRD_MAST_1(TID int IDENTITY(1, 1) PRIMARY KEY,Pay_Date Date,Created_On datetime default(getdate()),Created_By int, COMP_CODE int,COST_CODE int,DEPT_CODE int,DIVI_CODE int,DSG_CODE int,GRD_CODE int,LOC_CODE int,LREASON int,PROC_CODE int,REGN_CODE int,SECT_CODE int,STATE_CODE int,TYPE_CODE int,BANK_CODE nvarchar(50),ESISALARY numeric(16,2),FPFSALARY numeric(16,2),PFSALARY numeric(16,2));; Create table Ivap_HRD_HIS_1(TID int IDENTITY(1, 1) PRIMARY KEY,HRDID INT,Updated_ON datetime default(getdate()),updated_by int not null,Action varchar(200) ,Pay_Date Date,Created_On datetime default(getdate()),Created_By int, COMP_CODE int,COST_CODE int,DEPT_CODE int,DIVI_CODE int,DSG_CODE int,GRD_CODE int,LOC_CODE int,LREASON int,PROC_CODE int,REGN_CODE int,SECT_CODE int,STATE_CODE int,TYPE_CODE int,BANK_CODE nvarchar(50),ESISALARY numeric(16,2),FPFSALARY numeric(16,2),PFSALARY numeric(16,2));
--BEGIN TRAN 
--BEGIN TRY 
--if NOT exists(select Name from Sys.objects where Type='u' and name =@Table_Name) 
--	BEGIN  
--		--DECLARE @HRD_Table_Statement VARCHAR(Max)=''
--		--Create table Ivap_HRD_MAST_1(TID int IDENTITY(1, 1) PRIMARY KEY,Pay_Date Date,Created_On datetime default(getdate()),Created_By int, COMP_CODE int,COST_CODE int,DEPT_CODE int,DIVI_CODE int,DSG_CODE int,GRD_CODE int,LOC_CODE int,LREASON int,PROC_CODE int,REGN_CODE int,SECT_CODE int,STATE_CODE int,TYPE_CODE int,BANK_CODE nvarchar(50),ESISALARY numeric(16,2),FPFSALARY numeric(16,2),PFSALARY numeric(16,2));; Create table Ivap_HRD_HIS_1(TID int IDENTITY(1, 1) PRIMARY KEY,HRDID INT,Updated_ON datetime default(getdate()),updated_by int not null,Action varchar(200) ,Pay_Date Date,Created_On datetime default(getdate()),Created_By int, COMP_CODE int,COST_CODE int,DEPT_CODE int,DIVI_CODE int,DSG_CODE int,GRD_CODE int,LOC_CODE int,LREASON int,PROC_CODE int,REGN_CODE int,SECT_CODE int,STATE_CODE int,TYPE_CODE int,BANK_CODE nvarchar(50),ESISALARY numeric(16,2),FPFSALARY numeric(16,2),PFSALARY numeric(16,2));
--		EXEC (@Qry_Text)
--		--COMMIT; 
--		select 1 
--	END
--	ELSE 
--		SELECT -1;
--	END TRY
--	BEGIN CATCH
--		 ROLLBACK;
--	END CATCH

END

--SELECT * FROM sys.sysprocesses WHERE open_tran = 1
GO
/****** Object:  StoredProcedure [dbo].[Regeneratepassword]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[Regeneratepassword]
(
@P_Uid int,
@P_Password Varchar(max)
)
As
declare @Flag int,@Result int
Begin
  SET @Flag=  (SELECT TOP 3 COUNT(*)  from ivap_HIS_PASSWORD where UID=@P_UID and UPPER(password)=UPPER(@P_PASSWORD))
  If @Flag >0 
  begin
    set @Result=0
	select @Result as result
    return;
  end
    update IVAP_MST_USER set password=@P_PASSWORD,PASSWORD_LAST_UPDATED=GETDATE(),PASSWORD_TRY=0  Where UId=@P_Uid
    Insert Into IVAP_HIS_PASSWORD(UId,Password,Created_on) Values(@P_Uid,@P_Password,GETDATE())
    Update IVAP_MST_PASSLINK Set Isused=1,Usedon=getdate(),Usedby=@P_Uid,Remarks='Password Rest' Where UId=@P_Uid
    set @Result=1
	select @Result as result
END
GO
/****** Object:  StoredProcedure [dbo].[REGION_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM IVAP_HIS_REGION
CREATE PROC [dbo].[REGION_HISTORY]
(
	@RegionID INT,
	@Updated_BY INT,
	@Action VARCHAR(20)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_REGION(RegionID,ENTITY_ID,PAY_REGION_CODE,ERP_REGION_CODE,REGION_NAME,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,ACTION)
		SELECT TID,ENTITY_ID,PAY_REGION_CODE,ERP_REGION_CODE,REGION_NAME,CREATED_ON,CREATED_BY,GETDATE(),@Updated_BY,ISACTIVE,@Action FROM IVAP_MST_REGION WHERE TID =@RegionID

END
GO
/****** Object:  StoredProcedure [dbo].[ResetPassLink]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ResetPassLink]
(
@P_UID int,
@P_RANDOMKEY varchar(50)
)
As
Begin
insert into IVAP_MST_PASSLINK (UID,KEYTYPE,RANDOMKEY,ISUSED,REMARKS)
values(@P_UID,'Forget Password',@P_RANDOMKEY,0,'Forget password')
select 1
END
GO
/****** Object:  StoredProcedure [dbo].[Section_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Section_History]
(
	@SECTID INT,
	@Updated_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_SECTION(
		SECTID,
		ENTITY_ID,
		PAY_SECTION_CODE,
		ERP_SECTION_CODE,
		SECTION_NAME,
		CREATED_ON,
		CREATED_BY,
		UPDATED_ON,
		UPDATED_BY,
		ISACTIVE,
		ACTION)
	SELECT
		TID,
		ENTITY_ID,
		PAY_SECTION_CODE,
		ERP_SECTION_CODE,
		SECTION_NAME,
		CREATED_ON,
		@Updated_BY,
		GETDATE(),
		UPDATED_BY,
		ISACTIVE,
		@Action 
		FROM IVAP_MST_SECTION
		WHERE TID =@SECTID
END
GO
/****** Object:  StoredProcedure [dbo].[SetDisplayOrder_down]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetDisplayOrder_down]
(
	@TID INT,
	@Name VARCHAR(200),
	@PID INT,
	@EID INT
)
AS
BEGIN
	set nocount on   
	declare @flowpos int  
	declare @Dorder int=0;
	declare @CurrDorder int=0;
	IF(@TID =0)
	BEGIN
		SET @TID = (SELECT TID FROM IVAP_MST_MENU WHERE PMENU =0 AND Name =@Name AND ENTITY_ID=@EID)
		SET @PID =0
	END
	set @Dorder=(select DISPLAY_ORDER from IVAP_MST_MENU where  TID=@TID  AND ENTITY_ID=@EID)
	Set @CurrDorder=@Dorder;
	set @Dorder=@Dorder+1;
	--select @Dorder,@CurrDorder
	declare @lastRecord int;
	Set @lastRecord=(select top 1 TID from IVAP_MST_MENU where  PMENU=@PID AND ENTITY_ID=@EID and DISPLAY_ORDER>@CurrDorder order by DISPLAY_ORDER )
	UPDATE IVAP_MST_MENU set DISPLAY_ORDER =@Dorder where  TID=@TID AND ENTITY_ID=@EID;
	UPDATE IVAP_MST_MENU set DISPLAY_ORDER =DISPLAY_ORDER-1 where  tid=@lastRecord AND ENTITY_ID=@EID;
	SELECT 0 AS result
END
GO
/****** Object:  StoredProcedure [dbo].[SetDisplayOrder_FileCompDtl]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetDisplayOrder_FileCompDtl]
(
	@TID INT,
	@DISPLAY_ORDER INT,
	@EID INT
)
AS
BEGIN
	UPDATE IVAP_MST_FILE_COMP_DETAIL SET Display_Order = @DISPLAY_ORDER
	WHERE TID =@TID
	SELECT 0 AS result
END
GO
/****** Object:  StoredProcedure [dbo].[SetDisplayOrder_UP]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetDisplayOrder_UP]
(
	@TID INT,
	@Name VARCHAR(200),
	@PID INT,
	@EID INT
)
AS
BEGIN
	set nocount on   
	declare @flowpos int  
	declare @Dorder int=0;
	declare @CurrDorder int=0;
	IF(@TID =0)
	BEGIN
		SET @TID = (SELECT TID FROM IVAP_MST_MENU WHERE PMENU =0 AND Name =@Name AND ENTITY_ID=@EID)
		SET @PID =0
	END
	set @Dorder=(select DISPLAY_ORDER from IVAP_MST_MENU where  TID=@TID  AND ENTITY_ID=@EID)
	Set @CurrDorder=@Dorder;
	if(@Dorder>1)
	set @Dorder=@Dorder-1;
	--select @Dorder,@CurrDorder
	declare @lastRecord int;
	Set @lastRecord=(select top 1 TID from IVAP_MST_MENU where  PMENU=@PID AND ENTITY_ID=@EID and DISPLAY_ORDER<@CurrDorder order by DISPLAY_ORDER desc )
	UPDATE IVAP_MST_MENU set DISPLAY_ORDER =@Dorder where  TID=@TID AND ENTITY_ID=@EID;
	UPDATE IVAP_MST_MENU set DISPLAY_ORDER =DISPLAY_ORDER+1 where  tid=@lastRecord AND ENTITY_ID=@EID;
	SELECT 0 AS result
END
GO
/****** Object:  StoredProcedure [dbo].[SetOrderFileCompDtl_Down]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetOrderFileCompDtl_Down]
(
	@TID INT,
	@FILE_ID INT,
	@EID INT =0
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @flowpos INT  
	DECLARE @Dorder INT=0;
	DECLARE @CurrDorder INT=0;

	SET @Dorder=(select ISNULL(DISPLAY_ORDER,0) from IVAP_MST_FILE_COMP_DETAIL where  TID=@TID)
	SET @CurrDorder=@Dorder;
	SET @Dorder=@Dorder+1;
	DECLARE @lastRecord INT;
	SET @lastRecord=(SELECT TOP 1 TID from IVAP_MST_FILE_COMP_DETAIL where  FILE_ID=@FILE_ID and DISPLAY_ORDER>@CurrDorder ORDER BY DISPLAY_ORDER )
	UPDATE IVAP_MST_FILE_COMP_DETAIL set DISPLAY_ORDER =@Dorder where  TID=@TID;
	UPDATE IVAP_MST_FILE_COMP_DETAIL set DISPLAY_ORDER =DISPLAY_ORDER-1 where  tid=@lastRecord;
	SELECT 0 AS result
END
GO
/****** Object:  StoredProcedure [dbo].[SetOrderFileCompDtl_UP]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_MST_FILE_COMP_DETAIL
CREATE PROC [dbo].[SetOrderFileCompDtl_UP]
(
	@TID INT,
	@FILE_ID INT,
	@EID INT =0
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @flowpos INT  
	DECLARE @Dorder INT=0;
	DECLARE @CurrDorder INT=0;

	SET @Dorder=(select ISNULL(DISPLAY_ORDER,0) from IVAP_MST_FILE_COMP_DETAIL where  TID=@TID)
	SET @CurrDorder=@Dorder;
	IF(@Dorder>1)
		SET @Dorder=@Dorder-1;
	DECLARE @lastRecord INT;
	SET @lastRecord=(SELECT TOP 1 TID from IVAP_MST_FILE_COMP_DETAIL where  FILE_ID=@FILE_ID and DISPLAY_ORDER<@CurrDorder ORDER BY DISPLAY_ORDER DESC )
	UPDATE IVAP_MST_FILE_COMP_DETAIL set DISPLAY_ORDER =@Dorder where  TID=@TID;
	UPDATE IVAP_MST_FILE_COMP_DETAIL set DISPLAY_ORDER =DISPLAY_ORDER+1 where  tid=@lastRecord;
	SELECT 0 AS result
END
GO
/****** Object:  StoredProcedure [dbo].[SetStatus_ForMonthClose]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetStatus_ForMonthClose]
(
	@TID INT,
	@EID INT,
	@Status VARCHAR(20),
	@UID INT
)
AS
BEGIN
	DECLARE @OPEN_DATE DATETIME =null,@CLOSED_DATE DATETIME =null;
	DECLARE @result INT =0
	IF(@Status = 'OPEN')
		SET @OPEN_DATE = GETDATE()
	ELSE
		 SET @CLOSED_DATE = GETDATE()
	IF(@TID =0)
	BEGIN
		INSERT INTO IVAP_MONTH_CLOSE(ENTITY_ID,MONTH,YEAR,OPEN_DATE,CLOSED_DATE,STATUS,CREATED_BY,ISACT)
			VALUES(@EID,MONTH(GETDATE()),YEAR(GETDATE()),@OPEN_DATE,@CLOSED_DATE,@Status,@UID,1)
		SET @result =SCOPE_IDENTITY()  
		Exec MonthClose_HIS @result,@UID,'Create'    
	END
	ELSE
	BEGIN
		IF(@Status ='OPEN')
		BEGIN
			UPDATE IVAP_MONTH_CLOSE
			SET MONTH = MONTH(GETDATE()),YEAR =YEAR(GETDATE()),OPEN_DATE=@OPEN_DATE,CLOSED_DATE=@CLOSED_DATE,STATUS=@Status,
			UPDATED_BY =@UID,UPDATED_ON =GETDATE() WHERE TID =@TID
		END
		ELSE
		BEGIN
			UPDATE IVAP_MONTH_CLOSE
			SET MONTH = MONTH(GETDATE()),YEAR =YEAR(GETDATE()),CLOSED_DATE=@CLOSED_DATE,STATUS=@Status,
			UPDATED_BY =@UID,UPDATED_ON =GETDATE() WHERE TID =@TID
		END
		Exec MonthClose_HIS @TID,@UID,'Update' 
		SET @result =0  
	END
	SELECT 0 as result
END
GO
/****** Object:  StoredProcedure [dbo].[STATE_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELPTEXT STATE_HISTORY
  
--SP_HELPTEXT ADDUPDATESTATE  
    
    -- ALTER TABLE IVAP_HIS_STATE ADD COUNTRY VARCHAR(50) NOT NULL

	CREATE PROC [dbo].[STATE_HISTORY]  
(  
@SID INT,   
@UpdatedBy INT,    
@Action VARCHAR(100)                        
)   
AS  
BEGIN  
INSERT INTO IVAP_HIS_STATE(SID,STATE_CODE,STATE_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION,COUNTRY)  
SELECT TID,STATE_CODE,STATE_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action,COUNTRY FROM IVAP_MST_STATE  
END
GO
/****** Object:  StoredProcedure [dbo].[SUBFUNCTION_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SUBFUNCTION_HISTORY]  
(  
@SID INT,       
@UpdatedBy INT,        
@Action VARCHAR(100)   
)  
AS  
BEGIN  
  
INSERT INTO IVAP_HIS_SUB_FUNCTION(SID,ENTITY_ID,PAY_SUB_FUNC_CODE,ERP_SUB_FUNC_CODE,SUB_FUNC_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,PARENT_FUNC_ID,ACTION)      
SELECT TID,ENTITY_ID,PAY_SUB_FUNC_CODE,ERP_SUB_FUNC_CODE,SUB_FUNC_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,PARENT_FUNC_ID,@Action FROM IVAP_MST_SUB_FUNCTION  
END
GO
/****** Object:  StoredProcedure [dbo].[TYPE_HISTORY]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROC [dbo].[TYPE_HISTORY]    
(    
@CID INT,     
@UpdatedBy INT,      
@Action VARCHAR(100)                
)    
AS    
BEGIN    
INSERT INTO IVAP_HIS_TYPE(TYID,ENTITY_ID,PAY_TYPE_CODE,ERP_TYPE_CODE,TYPE_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION)    
SELECT TID,ENTITY_ID,PAY_TYPE_CODE,ERP_TYPE_CODE,TYPE_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_TYPE    
END 
GO
/****** Object:  StoredProcedure [dbo].[update_Entity_menu]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[update_Entity_menu](@entity_id int, @Def_menu_name varchar(100), @def_menu_parent varchar(100))
as
begin

declare @cnt int 
select @cnt = count(*) from IVAP_MST_MENU where ENTITY_ID = @entity_id and name = @Def_menu_name 
if @cnt >0
begin
select 'Menu Already Exist'
return;
end

declare @pmenu int
declare @def_menu_tid int
select @pmenu = pmenu, @def_menu_tid = tid  from IVAP_MST_DEFAULT_MENU where name = @Def_menu_name 

if @pmenu = 0
begin
select @pmenu = 0
end
else
begin
select @pmenu  = tid from IVAP_MST_MENU where name = @def_menu_parent and ENTITY_ID = @entity_id 
end

insert into ivap_mst_menu(entity_id, name, pmenu, route, roles, display_order, ACTIONS_NAME, image, CREATED_ON, UPDATED_ON , ISACT, controller, menu_type)
select @entity_id, name, @pmenu, route, roles, display_order, actions_name, image, getdate(), getdate(), isact, controller, MENU_TYPE  from IVAP_MST_DEFAULT_MENU where tid = @def_menu_tid 
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateEntity]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[UpdateEntity]
(
@EntityID int,
@EntityName VARCHAR(100),
@EntityState int,
@EntityCity VARCHAR(50),
@EntityPIN VARCHAR(20),
@EntityAdd1 VARCHAR(max)='',
@EntityAdd2 VARCHAR(max)='',
@DomainName VARCHAR(50),
@Payperiod VARCHAR(100),
@DateFormat VARCHAR(100),
@EntityCountry int,
@EntityCurrency int,
@Payperiod_Weekly_Fr VARCHAR(30)='',
@Payperiod_Weekly_To VARCHAR(30)='',
@Payperiod_Monthly_Fr int,
@Payperiod_Monthly_To int,
@Payperiod_Fortnightly_Fr1 int,
@Payperiod_Fortnightly_To1 int,
@Payperiod_Fortnightly_Fr2 int,
@Payperiod_Fortnightly_To2 int,
@Services_Availed int,
@IsAct int,
@UID int
)
AS 
BEGIN
DECLARE @result INT =0
	--IF Exists(SELECT * FROM IVAP_MST_ENTITY WHERE ENTITY_NAME=@EntityName AND TID <> @EntityID)
	--BEGIN
	--	SET @result = -1
	--	SELECT @result as result
	--	RETURN;
	--END

	if (@EntityID<>0)
begin
update IVAP_MST_ENTITY set ENTITY_NAME=@EntityName,ENTITY_ADDR1=@EntityAdd1,
ENTITY_ADDR2=@EntityAdd2,ENTITY_CITY=@EntityCity,ENTITY_STATE=@EntityState,ENTITY_PIN=@EntityPIN,DOMAIN_NAME=@DomainName,
ISACTIVE=@IsAct,DATE_FORMAT=@DateFormat,COUNTRY=@EntityCountry,CURRENCY=@EntityCurrency,PAY_PERIOD=@Payperiod,
Payperiod_Weekly_Fr=@Payperiod_Weekly_Fr,Payperiod_Weekly_To=@Payperiod_Weekly_To,Payperiod_Monthly_Fr=@Payperiod_Monthly_Fr,
Payperiod_Monthly_To=@Payperiod_Monthly_To,Payperiod_Fortnightly_Fr1=@Payperiod_Fortnightly_Fr1,Payperiod_Fortnightly_To1=@Payperiod_Fortnightly_To1,
Payperiod_Fortnightly_Fr2=@Payperiod_Fortnightly_Fr2,Payperiod_Fortnightly_To2=@Payperiod_Fortnightly_To2,Services_Availed=@Services_Availed,
UPDATED_BY=@UID,UPDATE_ON=GETDATE() where TID=@EntityID
SET @Result =0
end
SELECT @Result AS result
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateFile_Component]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[UpdateFile_Component] 
(
 @TID INT,  
 @UID INT,
 @COMPONENT_FILE_TYPE NVARCHAR(50),
 @COMPONENT_TYPE NVARCHAR(50),
 @COMPONENT_SUB_TYPE NVARCHAR(50),
 @COMPONENT_NAME NVARCHAR(50),
 @COMPONENT_DATATYPE NVARCHAR(50),
 @COMPONENT_TABLE_NAME NVARCHAR(50),
 @COMPONENT_COLUMN_NAME NVARCHAR(50),
 @COMPONENT_DISPLAY_NAME NVARCHAR(50),
 @COMPONENT_DESCRIPTION NVARCHAR(50),
 @MIN_LENGTH INT,
 @MAX_LENGTH INT,
 @MANDATORY NVARCHAR(50),
 @HAS_RULE NVARCHAR(50),
 @GL_Code INT,
 @PMS_CODE NVARCHAR(50)
)
AS
BEGIN

UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_FILE_TYPE=@COMPONENT_FILE_TYPE,COMPONENT_TYPE=@COMPONENT_TYPE,COMPONENT_SUB_TYPE=@COMPONENT_SUB_TYPE,COMPONENT_NAME=@COMPONENT_NAME,COMPONENT_TABLE_NAME=@COMPONENT_TABLE_NAME,
COMPONENT_DATATYPE=@COMPONENT_DATATYPE,COMPONENT_COLUMN_NAME=@COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION=@COMPONENT_DESCRIPTION,
MIN_LENGTH=@MIN_LENGTH,MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,HAS_RULE=@HAS_RULE,GL_Code=@GL_Code,PMS_CODE=@PMS_CODE WHERE TID=@TID

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateMenu]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateMenu]
(
	@TID INT,
	@EID INT,
	@MenuName VARCHAR(200),
	@Roles VARCHAR(500),
	@CreatedBy INT
)
AS
BEGIN
	--SELECT * FROM IVAP_MST_MENU
	DECLARE @Result INT =0;
	IF Exists(SELECT * FROM IVAP_MST_MENU WHERE UPPER(NAME) = UPPER(@MenuName) AND TID <> @TID AND ENTITY_ID =@EID)
	BEGIN
		SET @Result = -1
		SELECT @Result as result
		RETURN;
	END
	UPDATE IVAP_MST_MENU
	SET NAME = @MenuName,ROLES =@Roles WHERE TID = @TID AND ENTITY_ID=@EID
	SET @Result =0
	SELECT @Result AS result
END
GO
/****** Object:  StoredProcedure [dbo].[UPLOADTEMPTABLE]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UPLOADTEMPTABLE]  
(  
 @EID INT=0  
)  
AS  
   BEGIN  
   DECLARE @Ivap_Temp_Table_Name VARCHAR(50)  
   SET @Ivap_Temp_Table_Name='Ivap_MAST_TEMP_'+cast(@EID as varchar(10));    
   SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME =@Ivap_Temp_Table_Name;  
  
 END
GO
/****** Object:  StoredProcedure [dbo].[UPLOADTEMPTABLE_NEW]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UPLOADTEMPTABLE_NEW] 
(  
 @TEMP_TABLE varchar(50)='' , 
 @Column_Name varchar(100)=''
)  
AS  
   BEGIN  
   DECLARE @SqlQuery NVARCHAR(500)  ;
   DECLARE @ParmDefinition nvarchar(Max);  
   SET @SqlQuery= 'SELECT TABLE_NAME,COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TEMP_TABLE'  
   if(isnull(@Column_Name,'')!='')  
   begin
   SET @SqlQuery=@SqlQuery+' and COLUMN_NAME='+ '@Column_Name';
   end
   --PRINT @SqlQuery;
    SET @ParmDefinition = N'@TEMP_TABLE varchar(50),@Column_Name varchar(100) '; 
  EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @TEMP_TABLE,@Column_Name
 END 
GO
/****** Object:  StoredProcedure [dbo].[User_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[User_History]
(
	@UID INT,
	@UpdatedBy INT,
	@Action VARCHAR(100)
)
AS
BEGIN
	--select * from ivap_his_user
	INSERT INTO IVAP_HIS_USER(UID,ENTITY_ID,USERID,USER_FIRSTNAME,USER_LASTNAME,USER_EMAIL,USER_ROLE,USER_MOBILENO,ISAUTH,ISACT,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON,PROFILE_PIC,ACTION)
	SELECT UID,ENTITY_ID,USERID,USER_FIRSTNAME,USER_LASTNAME,USER_EMAIL,USER_ROLE,USER_MOBILENO,ISAUTH,ISACT,@UpdatedBy,CREATED_ON,UPDATED_BY,UPDATED_ON,PROFILE_PIC,@Action FROM IVAP_MST_USER
	WHERE UID =@UID
END
GO
/****** Object:  StoredProcedure [dbo].[UserRole_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from IVAP_HIS_USERROLE
CREATE PROC [dbo].[UserRole_History]
(
	@RoleID INT,
	@UpdatedBy INT,
	@Action VARCHAR(100)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_USERROLE(ROLE_ID,ROLENAME,ROLETYPE,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACT,ACTION)
		SELECT TID,ROLENAME,ROLETYPE,CREATED_ON,CREATED_BY,UPDATED_ON,@UpdatedBy,ISACT,@Action FROM IVAP_MST_USERROLE
		WHERE TID =@RoleID
END
GO
/****** Object:  StoredProcedure [dbo].[UserSignUp]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
procedure [dbo].[UserSignUp]
(
	@USERID varchar(100),
	@USER_FIRSTNAME varchar(100),
	@USER_LASTNAME varchar(100),
	@USER_EMAIL varchar(100),
	@EID int,
	@USER_ROLE int,
	@USER_MOBILENO varchar(100),
	@Password varchar(500),
	@Createdby int=1
)
AS
BEGIN
	DECLARE @UID INT;
    Insert Into IVAP_MST_USER
	(Userid,User_Firstname,User_Lastname,User_Email,ENTITY_ID,Password,USER_ROLE,USER_MOBILENO,ISAUTH,ISACT,CREATED_BY,PASSWORD_LAST_UPDATED)
    Values(@USERID,@USER_FIRSTNAME,@USER_LASTNAME,@USER_EMAIL,@EID,@Password,@USER_ROLE,@USER_MOBILENO,1,1,@Createdby,getdate())
	Set @UID=SCOPE_IDENTITY();
	
    Insert Into IVAP_HIS_PASSWORD(UID,Password) Values (@UID,@Password);
	select 1
 End
GO
/****** Object:  StoredProcedure [dbo].[Workflowsetting_History]    Script Date: 12-02-2019 21:00:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Workflowsetting_History]
(
	@WFSID INT,
	@Updated_BY INT,
	@Action VARCHAR(50)
)
AS
BEGIN
	INSERT INTO IVAP_HIS_WorkFlowSetting(
		WFSID,
ENTITY_ID,
FILE_ID,
USER_ROLE,
ORDERING,
CREATED_ON,
CREATED_BY,
UPDATED_ON,
UPDATED_BY,
ISACTIVE,
ACTION)
	SELECT
		TID,
		ENTITY_ID,
    FILE_ID,
     USER_ROLE,
      ORDERING,
		CREATED_ON,
		CREATED_BY,
		GETDATE(),
		@Updated_BY,
		ISACTIVE,
		@Action 
		FROM IVAP_MST_WorkFlowSetting 
		WHERE TID =@WFSID
END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check if Rule is set on this component.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IVAP_MST_COMPONENT_ENTITY', @level2type=N'COLUMN',@level2name=N'TID'
GO
USE [master]
GO
ALTER DATABASE [IVAP] SET  READ_WRITE 
GO
