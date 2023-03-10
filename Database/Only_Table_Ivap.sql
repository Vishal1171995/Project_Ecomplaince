USE [IVAP]
GO
/****** Object:  Table [dbo].[dbo.IVAP_HIS_LWF]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_CALENDAR_SETUP]    Script Date: 03-06-2019 19:01:21 ******/
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
	[ActivityCategory] [varchar](200) NULL,
 CONSTRAINT [PK_IVAP_CALENDAR_SETUP] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_CONFIG_SMTP]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_DATA_ACCESS_DTL]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_BANK]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_CALENDAR_SETUP]    Script Date: 03-06-2019 19:01:21 ******/
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
	[ActivityCategory] [varchar](200) NULL,
 CONSTRAINT [PK_IVAP_HIS_CALENDAR_SETUP] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_CAPA]    Script Date: 03-06-2019 19:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_CAPA](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CID] [int] NOT NULL,
	[ISSUE] [nvarchar](max) NOT NULL,
	[ISSUE_DESCRIPTION] [nvarchar](max) NOT NULL,
	[CUSTOMER_IMPACT] [nvarchar](max) NOT NULL,
	[SEQUENCE_OF_EVENT] [nvarchar](max) NOT NULL,
	[COMMUNICATION_PROCESS] [nvarchar](max) NOT NULL,
	[ROOT_CAUSE] [nvarchar](max) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_CAPA_CORRECTIVE]    Script Date: 03-06-2019 19:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_CAPA_CORRECTIVE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CID] [int] NOT NULL,
	[CAPA_ID] [int] NOT NULL,
	[CORRECTIVE_ACTION] [nvarchar](max) NOT NULL,
	[ACTION_TEXT] [nvarchar](max) NOT NULL,
	[ACTION_OWNER] [nvarchar](max) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_CAPA_PREVENTIVE]    Script Date: 03-06-2019 19:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_CAPA_PREVENTIVE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CID] [int] NOT NULL,
	[CAPA_ID] [int] NOT NULL,
	[PREVENTIVE_ACTION] [nvarchar](max) NOT NULL,
	[ACTION_TEXT] [nvarchar](max) NOT NULL,
	[ACTION_OWNER] [nvarchar](max) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_CLASS]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_COMPANY]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_COMPONENT]    Script Date: 03-06-2019 19:01:21 ******/
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
	[COMPONENT_NAME] [varchar](100) NULL,
	[COMPONENT_DATATYPE] [varchar](20) NULL,
	[COMPONENT_DISPLAY_NAME] [varchar](100) NULL,
	[COMPONENT_DESCRIPTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL,
	[MIN_LENGTH] [int] NULL,
	[MAX_LENGTH] [int] NULL,
	[MANDATORY] [int] NULL,
	[ACTION] [varchar](50) NULL,
	[EXTRA_INPUT_VALIDATION] [nvarchar](100) NULL,
	[EXTRA_RG_EXPRESSION] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_COMPONENT_ENTITY]    Script Date: 03-06-2019 19:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_COMPONENT_ENTITY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CompEntityID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[COMPONENT_FILE_TYPE] [varchar](200) NULL,
	[COMPONENT_TYPE] [varchar](200) NULL,
	[COMPONENT_SUB_TYPE] [varchar](200) NULL,
	[COMPONENT_NAME] [varchar](200) NULL,
	[COMPONENT_DATATYPE] [varchar](20) NULL,
	[COMPONENT_TABLE_NAME] [varchar](200) NULL,
	[COMPONENT_COLUMN_NAME] [varchar](200) NULL,
	[COMPONENT_DISPLAY_NAME] [varchar](200) NULL,
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
	[ACTION] [varchar](30) NULL,
	[EXTRA_INPUT_VALIDATION] [nvarchar](100) NULL,
	[EXTRA_RG_EXPRESSION] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_COSTCENTRE]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_CURRENCY]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_DEPARTMENT]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_DESIGNATION]    Script Date: 03-06-2019 19:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_DESIGNATION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[DESGID] [int] NOT NULL,
	[ENTITY_ID] [int] NULL,
	[PAY_DSG_CODE] [varchar](4000) NULL,
	[ERP_DSG_CODE] [varchar](4000) NULL,
	[DSG_NAME] [varchar](4000) NULL,
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
/****** Object:  Table [dbo].[IVAP_HIS_DIVISION]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_FILE_COMP_DETAIL]    Script Date: 03-06-2019 19:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_FILE_COMP_DETAIL](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FID] [int] NOT NULL,
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
	[PMS_CODE] [nvarchar](200) NULL,
	[ACTION] [nvarchar](100) NULL,
	[EXTRA_INPUT_VALIDATION] [nvarchar](100) NULL,
	[EXTRA_RG_EXPRESSION] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_FILETYPE]    Script Date: 03-06-2019 19:01:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_HIS_FILETYPE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FID] [int] NOT NULL,
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
	[CATEGORY] [nvarchar](100) NULL,
	[ACTION] [nvarchar](100) NULL,
	[Transpose] [bit] NULL,
	[Payroll_Input_File] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_HIS_FUNCTION]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_GRADE]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_LEAVING_REASON]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_LEVEL]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_LOCATION]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_LOCATION_GLOBAL]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_LWF]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_MINWAGE]    Script Date: 03-06-2019 19:01:21 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_MONTH_CLOSE]    Script Date: 03-06-2019 19:01:21 ******/
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
	[DEFAULT_MONTH] [bit] NULL,
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
/****** Object:  Table [dbo].[IVAP_HIS_PASSWORD]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_PLANT]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_PROCESS]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_PTAX]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_REGION]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_SECTION]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_STATE]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_SUB_FUNCTION]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_TYPE]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_USER]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_USERROLE]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[IVAP_HIS_WorkFlowSetting]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_1]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_1](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NOT NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_14]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_15]    Script Date: 03-06-2019 19:01:22 ******/
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
	[METRO] [nvarchar](max) NULL,
	[COMP_CODE] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DIVI_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[LOC_CODE] [int] NULL,
	[PROC_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](max) NULL,
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
	[HR_PAYDATE] [datetime] NULL,
	[LNAME] [nvarchar](50) NULL,
	[LWOP] [numeric](16, 2) NULL,
	[MNAME] [nvarchar](50) NULL,
	[MOBILENO] [nvarchar](50) NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[TITLE] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[COMPANYCAR] [nvarchar](10) NULL,
	[EPF] [numeric](16, 2) NULL,
	[EPS] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPF] [nvarchar](50) NULL,
	[INVAMT] [numeric](16, 2) NULL,
	[INVCOMP] [nvarchar](10) NULL,
	[ITFMPRVEMP] [numeric](16, 2) NULL,
	[LLPAN] [nvarchar](10) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[PFPRVEMP] [numeric](16, 2) NULL,
	[PRVEMPINC] [numeric](16, 2) NULL,
	[PTFMPRVEMP] [numeric](16, 2) NULL,
	[RENTAMT] [numeric](16, 2) NULL,
	[RENTFM] [datetime] NULL,
	[RENTTO] [datetime] NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_24]    Script Date: 03-06-2019 19:01:22 ******/
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
	[METRO] [nvarchar](max) NULL,
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
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_27]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_28]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_29]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_30]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_31]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_31](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[LOC_NAME] [int] NULL,
	[BANK_NAME] [nvarchar](max) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DISDT] [datetime] NULL,
	[DISREM] [nvarchar](500) NULL,
	[DISRT] [nvarchar](500) NULL,
	[DOB] [datetime] NULL,
	[DOJUST] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[EMPREM] [nvarchar](400) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[HR_PAYDATE] [datetime] NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[INPSDT] [datetime] NULL,
	[LNAME] [nvarchar](50) NULL,
	[LOPDAY] [nvarchar](31) NULL,
	[LOPMON] [nvarchar](12) NULL,
	[LOPREM] [nvarchar](500) NULL,
	[LOPYR] [nvarchar](3000) NULL,
	[MNAME] [nvarchar](50) NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[PTLOC] [nvarchar](200) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
	[DOR] [datetime] NULL,
	[LWD] [datetime] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_CHECKER] [int] NULL,
	[TRN_DATE] [datetime] NULL,
	[TRN_WEF] [datetime] NULL,
	[EMPBANKNAME] [nvarchar](max) NULL,
	[STATUS] [nvarchar](max) NULL,
	[PAY_TYPE] [nvarchar](max) NULL,
	[FATNAME] [nvarchar](max) NULL,
	[STATE_CODE] [int] NULL,
	[AADHAARNO] [nvarchar](max) NULL,
	[COST_CODE] [int] NULL,
	[ESINO] [nvarchar](max) NULL,
	[MOBILENO] [nvarchar](max) NULL,
	[DEPT_CODE] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_34]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_34](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NOT NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_37]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_37](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NOT NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COMP_CODE] [int] NULL,
	[COMP_NAME] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[LOC_NAME] [int] NULL,
	[TYPE_CODE] [nvarchar](50) NULL,
	[ADDDATA] [nvarchar](4000) NULL,
	[BANK_NAME] [int] NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[EMPBANKNAME] [nvarchar](200) NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[HR_PAYDATE] [datetime] NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
	[LTYPE] [nvarchar](50) NULL,
	[MSTATUS] [nvarchar](50) NULL,
	[OTHRS] [nvarchar](4000) NULL,
	[PERIOD] [nvarchar](2) NULL,
	[PFERNO] [nvarchar](4000) NULL,
	[PRVPFNO] [nvarchar](200) NULL,
	[TAXYEAR] [nvarchar](4) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_38]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_38](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NOT NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COMP_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DOB] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[FATNAME] [nvarchar](500) NULL,
	[STATUS] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_39]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_39](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NOT NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[LOC_NAME] [int] NULL,
	[BANK_NAME] [int] NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[HR_PAYDATE] [datetime] NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
	[COMP_NAME] [int] NULL,
	[LTYPE] [nvarchar](max) NULL,
	[STATE_CODE] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_41]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_41](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COMP_CODE] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[ADDDATA] [nvarchar](4000) NULL,
	[BANK_NAME] [int] NULL,
	[CATEGORY] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOC] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[EMPREM] [nvarchar](400) NULL,
	[ESINUMBER] [int] NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[FATNAME] [nvarchar](500) NULL,
	[GENDER] [nvarchar](50) NULL,
	[HOLIDAYS] [nvarchar](50) NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[EPS] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPF] [nvarchar](50) NULL,
	[FPFNO] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_42]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_42](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[DSG_CODE] [int] NULL,
	[LOC_NAME] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_44]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_44](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[EMPTYPE] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[ACTYPE] [nvarchar](15) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[ESICNO] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MARITALSTATUS] [nvarchar](20) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[PFNO] [nvarchar](30) NULL,
	[PROPCODE] [nvarchar](30) NULL,
	[REASON] [nvarchar](200) NULL,
	[UAN] [nvarchar](12) NULL,
	[WEF] [datetime] NULL,
	[WORKCITY] [nvarchar](30) NULL,
	[CITIZENSHIP] [nvarchar](max) NULL,
	[LWOPDAYS] [numeric](16, 2) NULL,
	[REMARKS] [nvarchar](max) NULL,
	[STATUS] [nvarchar](max) NULL,
	[EPSSTATUS] [nvarchar](max) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[PFSTATUS] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_5]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_69]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_69](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_7]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_HIS_70]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_70](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_71]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_71](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_72]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_72](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_73]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_73](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_74]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_74](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_75]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_75](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_76]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_76](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_HIS_77]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_HIS_77](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_1]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_1](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
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
/****** Object:  Table [dbo].[Ivap_HRD_MAST_14]    Script Date: 03-06-2019 19:01:22 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_MAST_15]    Script Date: 03-06-2019 19:01:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_15](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[METRO] [nvarchar](max) NULL,
	[COMP_CODE] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DIVI_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[LOC_CODE] [int] NULL,
	[PROC_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](max) NULL,
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
	[HR_PAYDATE] [datetime] NULL,
	[LNAME] [nvarchar](50) NULL,
	[LWOP] [numeric](16, 2) NULL,
	[MNAME] [nvarchar](50) NULL,
	[MOBILENO] [nvarchar](50) NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[TITLE] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[COMPANYCAR] [nvarchar](10) NULL,
	[EPF] [numeric](16, 2) NULL,
	[EPS] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPF] [nvarchar](50) NULL,
	[INVAMT] [numeric](16, 2) NULL,
	[INVCOMP] [nvarchar](10) NULL,
	[ITFMPRVEMP] [numeric](16, 2) NULL,
	[LLPAN] [nvarchar](10) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[PFPRVEMP] [numeric](16, 2) NULL,
	[PRVEMPINC] [numeric](16, 2) NULL,
	[PTFMPRVEMP] [numeric](16, 2) NULL,
	[RENTAMT] [numeric](16, 2) NULL,
	[RENTFM] [datetime] NULL,
	[RENTTO] [datetime] NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_24]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_24](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[Pay_Date] [date] NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [int] NULL,
	[METRO] [nvarchar](max) NULL,
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
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_27]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_MAST_28]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_MAST_29]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_MAST_30]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_MAST_31]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_31](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[LOC_NAME] [int] NULL,
	[BANK_NAME] [nvarchar](max) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DISDT] [datetime] NULL,
	[DISREM] [nvarchar](500) NULL,
	[DISRT] [nvarchar](500) NULL,
	[DOB] [datetime] NULL,
	[DOJUST] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[EMPREM] [nvarchar](400) NULL,
	[FNAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[HR_PAYDATE] [datetime] NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[INPSDT] [datetime] NULL,
	[LNAME] [nvarchar](50) NULL,
	[LOPDAY] [nvarchar](31) NULL,
	[LOPMON] [nvarchar](12) NULL,
	[LOPREM] [nvarchar](500) NULL,
	[LOPYR] [nvarchar](3000) NULL,
	[MNAME] [nvarchar](50) NULL,
	[NEFT_CODE] [nvarchar](20) NULL,
	[PTLOC] [nvarchar](200) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
	[DOR] [datetime] NULL,
	[LWD] [datetime] NULL,
	[TRN_DATE] [datetime] NULL,
	[TRN_WEF] [datetime] NULL,
	[EMPBANKNAME] [nvarchar](max) NULL,
	[STATUS] [nvarchar](max) NULL,
	[PAY_TYPE] [nvarchar](max) NULL,
	[FATNAME] [nvarchar](max) NULL,
	[STATE_CODE] [int] NULL,
	[AADHAARNO] [nvarchar](max) NULL,
	[COST_CODE] [int] NULL,
	[ESINO] [nvarchar](max) NULL,
	[MOBILENO] [nvarchar](max) NULL,
	[DEPT_CODE] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_34]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_34](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_37]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_37](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COMP_CODE] [int] NULL,
	[COMP_NAME] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[LOC_NAME] [int] NULL,
	[TYPE_CODE] [nvarchar](50) NULL,
	[ADDDATA] [nvarchar](4000) NULL,
	[BANK_NAME] [int] NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[EMPBANKNAME] [nvarchar](200) NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[HR_PAYDATE] [datetime] NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
	[LTYPE] [nvarchar](50) NULL,
	[MSTATUS] [nvarchar](50) NULL,
	[OTHRS] [nvarchar](4000) NULL,
	[PERIOD] [nvarchar](2) NULL,
	[PFERNO] [nvarchar](4000) NULL,
	[PRVPFNO] [nvarchar](200) NULL,
	[TAXYEAR] [nvarchar](4) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_38]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_38](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COMP_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DOB] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[FATNAME] [nvarchar](500) NULL,
	[STATUS] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_39]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_39](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[DSG_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[LOC_NAME] [int] NULL,
	[BANK_NAME] [int] NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[GENDER] [nvarchar](50) NULL,
	[HR_PAYDATE] [datetime] NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
	[PFNO] [nvarchar](50) NULL,
	[UAN] [nvarchar](50) NULL,
	[COMP_NAME] [int] NULL,
	[LTYPE] [nvarchar](max) NULL,
	[STATE_CODE] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_41]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_41](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[COMP_CODE] [int] NULL,
	[COST_CODE] [int] NULL,
	[DEPT_CODE] [int] NULL,
	[ADDDATA] [nvarchar](4000) NULL,
	[BANK_NAME] [int] NULL,
	[CATEGORY] [nvarchar](50) NULL,
	[DOB] [datetime] NULL,
	[DOC] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[EFFDATE] [datetime] NULL,
	[EMAILID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[EMP_NAME] [nvarchar](500) NULL,
	[EMPREM] [nvarchar](400) NULL,
	[ESINUMBER] [int] NULL,
	[F_H_NAME] [nvarchar](50) NULL,
	[FATNAME] [nvarchar](500) NULL,
	[GENDER] [nvarchar](50) NULL,
	[HOLIDAYS] [nvarchar](50) NULL,
	[IFSC_CODE] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[EPF] [numeric](16, 2) NULL,
	[EPS] [nvarchar](50) NULL,
	[ESINO] [nvarchar](50) NULL,
	[FPF] [nvarchar](50) NULL,
	[FPFNO] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_42]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_42](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[DSG_CODE] [int] NULL,
	[LOC_NAME] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[AADHAARNO] [nvarchar](50) NULL,
	[PANNO] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_44]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_44](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[EMPTYPE] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[ACTYPE] [nvarchar](15) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[ESICNO] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MARITALSTATUS] [nvarchar](20) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[PFNO] [nvarchar](30) NULL,
	[PROPCODE] [nvarchar](30) NULL,
	[REASON] [nvarchar](200) NULL,
	[UAN] [nvarchar](12) NULL,
	[WEF] [datetime] NULL,
	[WORKCITY] [nvarchar](30) NULL,
	[CITIZENSHIP] [nvarchar](max) NULL,
	[LWOPDAYS] [numeric](16, 2) NULL,
	[REMARKS] [nvarchar](max) NULL,
	[STATUS] [nvarchar](max) NULL,
	[EPSSTATUS] [nvarchar](max) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[PFSTATUS] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_5]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_MAST_69]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_69](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_7]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[Ivap_HRD_MAST_70]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_70](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_71]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_71](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_72]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_72](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_73]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_73](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_74]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_74](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_75]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_75](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_76]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_76](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_HRD_MAST_77]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_HRD_MAST_77](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_LOG_ERROR]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[IVAP_LOGIN_LOG]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_1]    Script Date: 03-06-2019 19:01:23 ******/
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
	[SAL_ADVANCE] [nvarchar](50) NULL,
	[YTD_LOAN] [varchar](max) NULL,
	[CONVEYANCE] [varchar](max) NULL,
	[DEPT_CODE] [nvarchar](max) NULL,
	[GRD_CODE] [nvarchar](max) NULL,
	[BANK_CODE] [varchar](max) NULL,
	[BANKACNO] [varchar](max) NULL,
	[DOJ] [nvarchar](max) NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [varchar](max) NULL,
	[LNAME] [varchar](max) NULL,
	[YTD_SAL_ADVANCE] [varchar](max) NULL,
	[YTD_CONVEYANCE] [nvarchar](max) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[paydate] [varchar](max) NULL,
	[ADJUST] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_44]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_44](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[BANKNAME] [varchar](max) NULL,
	[COSTCENTER] [varchar](max) NULL,
	[DEPARTMENT] [varchar](max) NULL,
	[DESIGNATION] [varchar](max) NULL,
	[EMPTYPE] [varchar](max) NULL,
	[GRADE] [varchar](max) NULL,
	[LOCATION] [varchar](max) NULL,
	[STATE] [varchar](max) NULL,
	[AADHAR] [varchar](max) NULL,
	[ACTYPE] [varchar](max) NULL,
	[BANKACCNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[DOR] [varchar](max) NULL,
	[EMAIL_ID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMP_NAME] [varchar](max) NULL,
	[ESICNO] [varchar](max) NULL,
	[FATHER_HUSBAND] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[IFSC] [varchar](max) NULL,
	[MARITALSTATUS] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[PAN] [varchar](max) NULL,
	[PFNO] [varchar](max) NULL,
	[PROPCODE] [varchar](max) NULL,
	[REASON] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[WEF] [varchar](max) NULL,
	[WORKCITY] [varchar](max) NULL,
	[ADJUST] [varchar](max) NULL,
	[CAHG] [varchar](max) NULL,
	[LON_SALADV] [varchar](max) NULL,
	[NOTDED] [varchar](max) NULL,
	[REFBON] [varchar](max) NULL,
	[UNICOST] [varchar](max) NULL,
	[ESI] [varchar](max) NULL,
	[GDED] [varchar](max) NULL,
	[LWF] [varchar](max) NULL,
	[PF] [varchar](max) NULL,
	[PTAX] [varchar](max) NULL,
	[TDS] [varchar](max) NULL,
	[NPAY] [varchar](max) NULL,
	[COLAAC] [varchar](max) NULL,
	[GRATUITY] [varchar](max) NULL,
	[INCENT] [varchar](max) NULL,
	[JONBON] [varchar](max) NULL,
	[LVNCAS] [varchar](max) NULL,
	[NOTBUY] [varchar](max) NULL,
	[NOTPAY] [varchar](max) NULL,
	[OTHERN] [varchar](max) NULL,
	[PAYHLD] [varchar](max) NULL,
	[PLI] [varchar](max) NULL,
	[REMPAY] [varchar](max) NULL,
	[RETBON] [varchar](max) NULL,
	[WZINCT] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[COLAAL] [varchar](max) NULL,
	[ESIEMPR] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[PAYDATE] [varchar](max) NULL,
	[PFEMPR] [varchar](max) NULL,
	[SPLALL] [varchar](max) NULL,
	[CITIZENSHIP] [nvarchar](max) NULL,
	[STATEBONUS] [nvarchar](max) NULL,
	[LWOPDAYS] [nvarchar](max) NULL,
	[REMARKS] [nvarchar](max) NULL,
	[STATUS] [nvarchar](max) NULL,
	[FIXEDMONTHLYCTC] [nvarchar](max) NULL,
	[GRATUITYCTC] [nvarchar](max) NULL,
	[LTA] [nvarchar](max) NULL,
	[TOTALCTC] [nvarchar](max) NULL,
	[PROPCASHRECOVERY] [nvarchar](max) NULL,
	[DEFERREDBONUS] [nvarchar](max) NULL,
	[MEALDEDUCTION] [nvarchar](max) NULL,
	[OTHERDEDUCTION] [nvarchar](max) NULL,
	[OVERTIME] [nvarchar](max) NULL,
	[SALARYADVANCE] [nvarchar](max) NULL,
	[SHIFTALLOWANCE] [nvarchar](max) NULL,
	[TRAVELDEDUCTION] [nvarchar](max) NULL,
	[EPSSTATUS] [nvarchar](max) NULL,
	[FINANCIALYEAR] [nvarchar](max) NULL,
	[PFSTATUS] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_72]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_72](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [varchar](max) NULL,
	[MEALDEDUCTION] [varchar](max) NULL,
	[NOTICERECOVERY] [varchar](max) NULL,
	[OTHERDEDUCTION] [varchar](max) NULL,
	[SALARYADVANCE] [varchar](max) NULL,
	[TRAVELDEDUCTION] [varchar](max) NULL,
	[UNIFORMDEDUCTION] [varchar](max) NULL,
	[DEFERREDBONUS] [varchar](max) NULL,
	[INCENTIVE] [varchar](max) NULL,
	[JOININGBONUS] [varchar](max) NULL,
	[LEAVEENCASH] [varchar](max) NULL,
	[NOTICEPAY] [varchar](max) NULL,
	[OTHEREARNING] [varchar](max) NULL,
	[OVERTIME] [varchar](max) NULL,
	[PLI] [varchar](max) NULL,
	[REFERRALBONUS] [varchar](max) NULL,
	[RETENTIONBONUS] [varchar](max) NULL,
	[SHIFTALLOWANCE] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[FIXEDMONTHLYCTC] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[LTA] [varchar](max) NULL,
	[PAYDATE] [varchar](max) NULL,
	[SPLALL] [varchar](max) NULL,
	[STATBONUS] [varchar](max) NULL,
	[TOTALCTC] [varchar](max) NULL,
	[BANKNAME] [varchar](max) NULL,
	[COSTCENTER] [varchar](max) NULL,
	[DEPARTMENT] [varchar](max) NULL,
	[DESIGNATION] [varchar](max) NULL,
	[GRADE] [varchar](max) NULL,
	[LOCATION] [varchar](max) NULL,
	[STATE] [varchar](max) NULL,
	[ESIEMPLOYER] [varchar](max) NULL,
	[GRATUITYCTC] [varchar](max) NULL,
	[PFEMPLOYER] [varchar](max) NULL,
	[AADHAR] [varchar](max) NULL,
	[BANKACCNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[EFFECTIVEDATE] [varchar](max) NULL,
	[EMAIL_ID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMP_NAME] [varchar](max) NULL,
	[FATHER_HUSBAND] [varchar](max) NULL,
	[FINANCIALYEAR] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[IFSC] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[PAN] [varchar](max) NULL,
	[STATUS] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[EPSSTATUS] [varchar](max) NULL,
	[INTERNATIONALWORKERS] [varchar](max) NULL,
	[PFSTATUS] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_73]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_73](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [varchar](max) NULL,
	[MEALDEDUCTION] [varchar](max) NULL,
	[NOTICERECOVERY] [varchar](max) NULL,
	[OTHERDEDUCTION] [varchar](max) NULL,
	[SALARYADVANCE] [varchar](max) NULL,
	[TRAVELDEDUCTION] [varchar](max) NULL,
	[UNIFORMDEDUCTION] [varchar](max) NULL,
	[DEFERREDBONUS] [varchar](max) NULL,
	[INCENTIVE] [varchar](max) NULL,
	[JOININGBONUS] [varchar](max) NULL,
	[LEAVEENCASH] [varchar](max) NULL,
	[NOTICEPAY] [varchar](max) NULL,
	[OTHEREARNING] [varchar](max) NULL,
	[OVERTIME] [varchar](max) NULL,
	[PLI] [varchar](max) NULL,
	[REFERRALBONUS] [varchar](max) NULL,
	[RETENTIONBONUS] [varchar](max) NULL,
	[SHIFTALLOWANCE] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[FIXEDMONTHLYCTC] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[LTA] [varchar](max) NULL,
	[PAYDATE] [varchar](max) NULL,
	[SPLALL] [varchar](max) NULL,
	[STATBONUS] [varchar](max) NULL,
	[TOTALCTC] [varchar](max) NULL,
	[BANKNAME] [varchar](max) NULL,
	[COSTCENTER] [varchar](max) NULL,
	[DEPARTMENT] [varchar](max) NULL,
	[DESIGNATION] [varchar](max) NULL,
	[GRADE] [varchar](max) NULL,
	[LOCATION] [varchar](max) NULL,
	[STATE] [varchar](max) NULL,
	[ESIEMPLOYER] [varchar](max) NULL,
	[GRATUITYCTC] [varchar](max) NULL,
	[PFEMPLOYER] [varchar](max) NULL,
	[AADHAR] [varchar](max) NULL,
	[BANKACCNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[EFFECTIVEDATE] [varchar](max) NULL,
	[EMAIL_ID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMP_NAME] [varchar](max) NULL,
	[FATHER_HUSBAND] [varchar](max) NULL,
	[FINANCIALYEAR] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[IFSC] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[PAN] [varchar](max) NULL,
	[STATUS] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[EPSSTATUS] [varchar](max) NULL,
	[INTERNATIONALWORKERS] [varchar](max) NULL,
	[PFSTATUS] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_74]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_74](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [varchar](max) NULL,
	[MEALDEDUCTION] [varchar](max) NULL,
	[NOTICERECOVERY] [varchar](max) NULL,
	[OTHERDEDUCTION] [varchar](max) NULL,
	[SALARYADVANCE] [varchar](max) NULL,
	[TRAVELDEDUCTION] [varchar](max) NULL,
	[UNIFORMDEDUCTION] [varchar](max) NULL,
	[DEFERREDBONUS] [varchar](max) NULL,
	[INCENTIVE] [varchar](max) NULL,
	[JOININGBONUS] [varchar](max) NULL,
	[LEAVEENCASH] [varchar](max) NULL,
	[NOTICEPAY] [varchar](max) NULL,
	[OTHEREARNING] [varchar](max) NULL,
	[OVERTIME] [varchar](max) NULL,
	[PLI] [varchar](max) NULL,
	[REFERRALBONUS] [varchar](max) NULL,
	[RETENTIONBONUS] [varchar](max) NULL,
	[SHIFTALLOWANCE] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[FIXEDMONTHLYCTC] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[LTA] [varchar](max) NULL,
	[PAYDATE] [varchar](max) NULL,
	[SPLALL] [varchar](max) NULL,
	[STATBONUS] [varchar](max) NULL,
	[TOTALCTC] [varchar](max) NULL,
	[BANKNAME] [varchar](max) NULL,
	[COSTCENTER] [varchar](max) NULL,
	[DEPARTMENT] [varchar](max) NULL,
	[DESIGNATION] [varchar](max) NULL,
	[GRADE] [varchar](max) NULL,
	[LOCATION] [varchar](max) NULL,
	[STATE] [varchar](max) NULL,
	[ESIEMPLOYER] [varchar](max) NULL,
	[GRATUITYCTC] [varchar](max) NULL,
	[PFEMPLOYER] [varchar](max) NULL,
	[AADHAR] [varchar](max) NULL,
	[BANKACCNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[EFFECTIVEDATE] [varchar](max) NULL,
	[EMAIL_ID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMP_NAME] [varchar](max) NULL,
	[FATHER_HUSBAND] [varchar](max) NULL,
	[FINANCIALYEAR] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[IFSC] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[PAN] [varchar](max) NULL,
	[STATUS] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[EPSSTATUS] [varchar](max) NULL,
	[INTERNATIONALWORKERS] [varchar](max) NULL,
	[PFSTATUS] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_75]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_75](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [varchar](max) NULL,
	[MEALDEDUCTION] [varchar](max) NULL,
	[NOTICERECOVERY] [varchar](max) NULL,
	[OTHERDEDUCTION] [varchar](max) NULL,
	[SALARYADVANCE] [varchar](max) NULL,
	[TRAVELDEDUCTION] [varchar](max) NULL,
	[UNIFORMDEDUCTION] [varchar](max) NULL,
	[DEFERREDBONUS] [varchar](max) NULL,
	[INCENTIVE] [varchar](max) NULL,
	[JOININGBONUS] [varchar](max) NULL,
	[LEAVEENCASH] [varchar](max) NULL,
	[NOTICEPAY] [varchar](max) NULL,
	[OTHEREARNING] [varchar](max) NULL,
	[OVERTIME] [varchar](max) NULL,
	[PLI] [varchar](max) NULL,
	[REFERRALBONUS] [varchar](max) NULL,
	[RETENTIONBONUS] [varchar](max) NULL,
	[SHIFTALLOWANCE] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[FIXEDMONTHLYCTC] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[LTA] [varchar](max) NULL,
	[PAYDATE] [varchar](max) NULL,
	[SPLALL] [varchar](max) NULL,
	[STATBONUS] [varchar](max) NULL,
	[TOTALCTC] [varchar](max) NULL,
	[BANKNAME] [varchar](max) NULL,
	[COSTCENTER] [varchar](max) NULL,
	[DEPARTMENT] [varchar](max) NULL,
	[DESIGNATION] [varchar](max) NULL,
	[GRADE] [varchar](max) NULL,
	[LOCATION] [varchar](max) NULL,
	[STATE] [varchar](max) NULL,
	[ESIEMPLOYER] [varchar](max) NULL,
	[GRATUITYCTC] [varchar](max) NULL,
	[PFEMPLOYER] [varchar](max) NULL,
	[AADHAR] [varchar](max) NULL,
	[BANKACCNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[EFFECTIVEDATE] [varchar](max) NULL,
	[EMAIL_ID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMP_NAME] [varchar](max) NULL,
	[FATHER_HUSBAND] [varchar](max) NULL,
	[FINANCIALYEAR] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[IFSC] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[PAN] [varchar](max) NULL,
	[STATUS] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[EPSSTATUS] [varchar](max) NULL,
	[INTERNATIONALWORKERS] [varchar](max) NULL,
	[PFSTATUS] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_76]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_76](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [varchar](max) NULL,
	[MEALDEDUCTION] [varchar](max) NULL,
	[NOTICERECOVERY] [varchar](max) NULL,
	[OTHERDEDUCTION] [varchar](max) NULL,
	[SALARYADVANCE] [varchar](max) NULL,
	[TRAVELDEDUCTION] [varchar](max) NULL,
	[UNIFORMDEDUCTION] [varchar](max) NULL,
	[DEFERREDBONUS] [varchar](max) NULL,
	[INCENTIVE] [varchar](max) NULL,
	[JOININGBONUS] [varchar](max) NULL,
	[LEAVEENCASH] [varchar](max) NULL,
	[NOTICEPAY] [varchar](max) NULL,
	[OTHEREARNING] [varchar](max) NULL,
	[OVERTIME] [varchar](max) NULL,
	[PLI] [varchar](max) NULL,
	[REFERRALBONUS] [varchar](max) NULL,
	[RETENTIONBONUS] [varchar](max) NULL,
	[SHIFTALLOWANCE] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[FIXEDMONTHLYCTC] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[LTA] [varchar](max) NULL,
	[PAYDATE] [varchar](max) NULL,
	[SPLALL] [varchar](max) NULL,
	[STATBONUS] [varchar](max) NULL,
	[TOTALCTC] [varchar](max) NULL,
	[BANKNAME] [varchar](max) NULL,
	[COSTCENTER] [varchar](max) NULL,
	[DEPARTMENT] [varchar](max) NULL,
	[DESIGNATION] [varchar](max) NULL,
	[GRADE] [varchar](max) NULL,
	[LOCATION] [varchar](max) NULL,
	[STATE] [varchar](max) NULL,
	[ESIEMPLOYER] [varchar](max) NULL,
	[GRATUITYCTC] [varchar](max) NULL,
	[PFEMPLOYER] [varchar](max) NULL,
	[AADHAR] [varchar](max) NULL,
	[BANKACCNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[EFFECTIVEDATE] [varchar](max) NULL,
	[EMAIL_ID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMP_NAME] [varchar](max) NULL,
	[FATHER_HUSBAND] [varchar](max) NULL,
	[FINANCIALYEAR] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[IFSC] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[PAN] [varchar](max) NULL,
	[STATUS] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[EPSSTATUS] [varchar](max) NULL,
	[INTERNATIONALWORKERS] [varchar](max) NULL,
	[PFSTATUS] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_MAST_TEMP_77]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_MAST_TEMP_77](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[TEMP_STATUS] [varchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [varchar](max) NULL,
	[MEALDEDUCTION] [varchar](max) NULL,
	[NOTICERECOVERY] [varchar](max) NULL,
	[OTHERDEDUCTION] [varchar](max) NULL,
	[SALARYADVANCE] [varchar](max) NULL,
	[TRAVELDEDUCTION] [varchar](max) NULL,
	[UNIFORMDEDUCTION] [varchar](max) NULL,
	[DEFERREDBONUS] [varchar](max) NULL,
	[INCENTIVE] [varchar](max) NULL,
	[JOININGBONUS] [varchar](max) NULL,
	[LEAVEENCASH] [varchar](max) NULL,
	[NOTICEPAY] [varchar](max) NULL,
	[OTHEREARNING] [varchar](max) NULL,
	[OVERTIME] [varchar](max) NULL,
	[PLI] [varchar](max) NULL,
	[REFERRALBONUS] [varchar](max) NULL,
	[RETENTIONBONUS] [varchar](max) NULL,
	[SHIFTALLOWANCE] [varchar](max) NULL,
	[BASIC] [varchar](max) NULL,
	[FIXEDMONTHLYCTC] [varchar](max) NULL,
	[HRA] [varchar](max) NULL,
	[LTA] [varchar](max) NULL,
	[PAYDATE] [varchar](max) NULL,
	[SPLALL] [varchar](max) NULL,
	[STATBONUS] [varchar](max) NULL,
	[TOTALCTC] [varchar](max) NULL,
	[BANKNAME] [varchar](max) NULL,
	[COSTCENTER] [varchar](max) NULL,
	[DEPARTMENT] [varchar](max) NULL,
	[DESIGNATION] [varchar](max) NULL,
	[GRADE] [varchar](max) NULL,
	[LOCATION] [varchar](max) NULL,
	[STATE] [varchar](max) NULL,
	[ESIEMPLOYER] [varchar](max) NULL,
	[GRATUITYCTC] [varchar](max) NULL,
	[PFEMPLOYER] [varchar](max) NULL,
	[AADHAR] [varchar](max) NULL,
	[BANKACCNO] [varchar](max) NULL,
	[DOB] [varchar](max) NULL,
	[DOJ] [varchar](max) NULL,
	[DOL] [varchar](max) NULL,
	[EFFECTIVEDATE] [varchar](max) NULL,
	[EMAIL_ID] [varchar](max) NULL,
	[EMP_CODE] [varchar](max) NULL,
	[EMP_NAME] [varchar](max) NULL,
	[FATHER_HUSBAND] [varchar](max) NULL,
	[FINANCIALYEAR] [varchar](max) NULL,
	[GENDER] [varchar](max) NULL,
	[IFSC] [varchar](max) NULL,
	[MOBILENO] [varchar](max) NULL,
	[PAN] [varchar](max) NULL,
	[STATUS] [varchar](max) NULL,
	[UAN] [varchar](max) NULL,
	[EPSSTATUS] [varchar](max) NULL,
	[INTERNATIONALWORKERS] [varchar](max) NULL,
	[PFSTATUS] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_META_MASTER]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[IVAP_META_MASTER_DEFAULT]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[IVAP_MONTH_CLOSE]    Script Date: 03-06-2019 19:01:23 ******/
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
	[DEFAULT_MONTH] [bit] NULL,
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
/****** Object:  Table [dbo].[IVAP_MST_BANK]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_BANK_GLOBAL]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_CALENDAR_TYPE]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_CAPA]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_CAPA](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[ISSUE] [nvarchar](max) NOT NULL,
	[ISSUE_DESCRIPTION] [nvarchar](max) NOT NULL,
	[CUSTOMER_IMPACT] [nvarchar](max) NOT NULL,
	[SEQUENCE_OF_EVENT] [nvarchar](max) NOT NULL,
	[COMMUNICATION_PROCESS] [nvarchar](max) NOT NULL,
	[ROOT_CAUSE] [nvarchar](max) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[CATEGORY] [nvarchar](100) NULL,
	[FINANCE_TYPE] [nvarchar](50) NULL,
	[FINANCE_AMOUNT] [nvarchar](100) NULL,
	[IMPACT_VALUE] [nvarchar](100) NULL,
	[STAGE] [nvarchar](100) NULL,
	[INCIDENT_DATE] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_CAPA_CONVERSATION]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_CAPA_CONVERSATION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CAPAID] [int] NOT NULL,
	[ITEM_ID] [int] NOT NULL,
	[ITEM_NAME] [nvarchar](100) NOT NULL,
	[REMARK] [nvarchar](max) NULL,
	[ATTACHMENT] [nvarchar](max) NULL,
	[STATUS] [nvarchar](20) NULL,
	[CLOSURE_DATE] [nvarchar](50) NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[SYSTEM_ATTACHMENT] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_CAPA_CORRECTIVE]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_CAPA_CORRECTIVE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CAPA_ID] [int] NOT NULL,
	[CORRECTIVE_ACTION] [nvarchar](max) NOT NULL,
	[ACTION_TEXT] [nvarchar](max) NOT NULL,
	[ACTION_OWNER] [nvarchar](max) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[STATUS] [nvarchar](50) NULL,
	[Owner_Email] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_CAPA_PREVENTIVE]    Script Date: 03-06-2019 19:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_CAPA_PREVENTIVE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CAPA_ID] [int] NOT NULL,
	[PREVENTIVE_ACTION] [nvarchar](max) NOT NULL,
	[ACTION_TEXT] [nvarchar](max) NOT NULL,
	[ACTION_OWNER] [nvarchar](max) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATE_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[STATUS] [nvarchar](50) NULL,
	[Owner_Email] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_CLASS]    Script Date: 03-06-2019 19:01:23 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_COMPANY]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_COMPONENT]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_COMPONENT](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[COMPONENT_FILE_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_SUB_TYPE] [varchar](20) NOT NULL,
	[COMPONENT_NAME] [varchar](100) NULL,
	[COMPONENT_DATATYPE] [varchar](20) NOT NULL,
	[COMPONENT_DISPLAY_NAME] [varchar](100) NULL,
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
	[COMPONENT_COLUMN_NAME] [varchar](50) NULL,
	[EXTRA_INPUT_VALIDATION] [nvarchar](100) NULL,
	[EXTRA_RG_EXPRESSION] [nvarchar](100) NULL,
	[File_Template] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_component_COMPONENT_Sub_TYPE]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_component_COMPONENT_Sub_TYPE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[COMPONENT_FILE_TYPE] [varchar](200) NULL,
	[COMPONENT_SUB_TYPE] [varchar](100) NULL,
	[COMPONENT_TYPE] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_component_COMPONENT_TYPE]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_component_COMPONENT_TYPE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[COMPONENT_FILE_TYPE] [varchar](200) NULL,
	[COMPONENT_TYPE] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_component_DataType]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_component_DataType](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[COMPONENT_DATATYPE] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_COMPONENT_ENTITY]    Script Date: 03-06-2019 19:01:24 ******/
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
	[COMPONENT_NAME] [varchar](100) NOT NULL,
	[COMPONENT_DATATYPE] [varchar](20) NOT NULL,
	[COMPONENT_TABLE_NAME] [varchar](50) NULL,
	[COMPONENT_COLUMN_NAME] [varchar](50) NULL,
	[COMPONENT_DISPLAY_NAME] [varchar](100) NULL,
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
	[PMS_CODE] [varchar](200) NULL,
	[EXTRA_INPUT_VALIDATION] [nvarchar](100) NULL,
	[EXTRA_RG_EXPRESSION] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_COSTCENTRE]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_COUNTRY]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_CURRENCY]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_DEFAULT_MENU]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_DEPARTMENT]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_DESIGNATION]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_DESIGNATION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[PAY_DSG_CODE] [varchar](4000) NULL,
	[ERP_DSG_CODE] [varchar](4000) NULL,
	[DSG_NAME] [varchar](4000) NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ISACTIVE] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_DIVISION]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_ENTITY]    Script Date: 03-06-2019 19:01:24 ******/
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
	[Services_Availed] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_EXTRA_VALIDATION_TYPE]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_EXTRA_VALIDATION_TYPE](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[VALIDATION_FIELD] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_FILE_CATEGORY]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_FILE_CATEGORY](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[CATEGORY] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_FILE_COMP_DETAIL]    Script Date: 03-06-2019 19:01:24 ******/
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
	[PMS_CODE] [nvarchar](200) NULL,
	[EXTRA_INPUT_VALIDATION] [nvarchar](100) NULL,
	[EXTRA_RG_EXPRESSION] [nvarchar](100) NULL,
	[Spl_Field_Type] [nvarchar](20) NULL,
	[Spl_Field_Value] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_Mst_FileExporer_Access_Role]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_Mst_FileExporer_Access_Role](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[EID] [int] NOT NULL,
	[UID] [int] NOT NULL,
	[FileID] [int] NOT NULL,
	[IsView] [bit] NULL,
	[IsCreate] [bit] NULL,
	[IsDelete] [bit] NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_Mst_FileExt]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_FILEEXTENSION]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_FILEEXTENSION](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_EXTENSION] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_Mst_FileMetaData]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_Mst_FileMetaData](
	[FileMetaID] [int] IDENTITY(1,1) NOT NULL,
	[EID] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[MetaData] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[FileTypeName] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_IVAP_Mst_FileMetaData] PRIMARY KEY CLUSTERED 
(
	[FileMetaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_Mst_Files]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_Mst_Files](
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[EID] [int] NOT NULL,
	[FileType] [nvarchar](100) NOT NULL,
	[FileOriginalName] [nvarchar](1000) NOT NULL,
	[FileSystemGeneratedName] [nvarchar](1000) NOT NULL,
	[PID] [int] NULL,
	[FileTypeName] [nvarchar](1000) NULL,
	[MetaValue] [nvarchar](1000) NULL,
	[FileExtention] [varchar](50) NULL,
	[FileSize] [decimal](18, 2) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[UserRights] [varchar](500) NULL,
 CONSTRAINT [PK_Ivap_Mst_Files] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_FILETYPE]    Script Date: 03-06-2019 19:01:24 ******/
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
	[CATEGORY] [nvarchar](100) NULL,
	[Transpose] [bit] NULL,
	[Payroll_Input_File] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_FUNCTION]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_GRADE]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_KEYWORD]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_LEAVING_REASON]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_LEVEL]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_LOCATION]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_LOCATION_GLOBAL]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_LWF]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_MAILSETUP]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_MENU]    Script Date: 03-06-2019 19:01:24 ******/
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
	[MENU_TYPE] [varchar](200) NULL,
	[DefaultMenuID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_MINWAGE]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_MOM]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_MOM](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NULL,
	[MEETING_HELD] [datetime] NULL,
	[ADDRESS] [nvarchar](max) NULL,
	[AGENDA] [nvarchar](max) NULL,
	[CREATED_ON] [datetime] NULL,
	[LASTUPDATE] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[ISACTIVE] [char](1) NULL,
	[MEETING_ATTENDEES] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ivap_mst_mom_item]    Script Date: 03-06-2019 19:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ivap_mst_mom_item](
	[Item_ID] [int] IDENTITY(1,1) NOT NULL,
	[MOM_ID] [int] NULL,
	[MoM_Minutes] [nvarchar](max) NULL,
	[OwnerShip] [nvarchar](200) NULL,
	[Expected_Closure_Date] [datetime] NULL,
	[Actual_Date] [datetime] NULL,
	[Curr_Status] [nvarchar](50) NULL,
	[Created_ON] [datetime] NULL,
	[Modified_On] [datetime] NULL,
	[Remarks] [nvarchar](200) NULL,
	[System_File_Name] [nvarchar](200) NULL,
	[Original_File_Name] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Item_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_PASSLINK]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_PLANT]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_PROCESS]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_PTAX]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_REGION]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_SECTION]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_SERVICE_GLOBAL]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_STATE]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_SUB_FUNCTION]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_TYPE]    Script Date: 03-06-2019 19:01:24 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_USER]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_MST_USER](
	[UID] [int] IDENTITY(1,1) NOT NULL,
	[ENTITY_ID] [int] NULL,
	[USERID] [varchar](200) NULL,
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
	[PROFILE_PIC] [nvarchar](max) NULL,
	[LAST_PASSWORD_TRY_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_MST_USERROLE]    Script Date: 03-06-2019 19:01:25 ******/
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
/****** Object:  Table [dbo].[IVAP_MST_WorkFlowSetting]    Script Date: 03-06-2019 19:01:25 ******/
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
/****** Object:  Table [dbo].[Ivap_PAY_HIS_1]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
	[ADJUST] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_14]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_15]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAY_PAYDATE] [datetime] NULL,
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_27]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_28]    Script Date: 03-06-2019 19:01:25 ******/
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
/****** Object:  Table [dbo].[Ivap_PAY_HIS_29]    Script Date: 03-06-2019 19:01:25 ******/
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
/****** Object:  Table [dbo].[Ivap_PAY_HIS_30]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_31]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_31](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[ADV] [numeric](16, 2) NULL,
	[AIF] [numeric](16, 2) NULL,
	[GDD] [numeric](16, 2) NULL,
	[GYM] [numeric](16, 2) NULL,
	[IAD] [numeric](16, 2) NULL,
	[IPD] [numeric](16, 2) NULL,
	[LOP] [numeric](16, 2) NULL,
	[MAD] [numeric](16, 2) NULL,
	[NPR] [numeric](16, 2) NULL,
	[OID] [numeric](16, 2) NULL,
	[PDD] [numeric](16, 2) NULL,
	[SDD] [numeric](16, 2) NULL,
	[STY] [numeric](16, 2) NULL,
	[TDD] [numeric](16, 2) NULL,
	[TEA] [numeric](16, 2) NULL,
	[TRN] [numeric](16, 2) NULL,
	[UWF] [numeric](16, 2) NULL,
	[UWF_ABY_TVM] [numeric](16, 2) NULL,
	[UWF_ARP_TVM] [numeric](16, 2) NULL,
	[UWF_ASB_KOC] [numeric](16, 2) NULL,
	[UWF_ATS_TVM] [numeric](16, 2) NULL,
	[UWF_BDD_TVM] [numeric](16, 2) NULL,
	[UWF_BLD_BLR] [numeric](16, 2) NULL,
	[UWF_BLD_CHN] [numeric](16, 2) NULL,
	[UWF_BLD_KOC] [numeric](16, 2) NULL,
	[UWF_BPI_TVM] [numeric](16, 2) NULL,
	[UWF_CBI_TVM] [numeric](16, 2) NULL,
	[UWF_CHS_TVM] [numeric](16, 2) NULL,
	[UWF_CIS_TVM] [numeric](16, 2) NULL,
	[UWF_ENS_TVM] [numeric](16, 2) NULL,
	[UWF_EVP_BLR] [numeric](16, 2) NULL,
	[UWF_EVP_KOC] [numeric](16, 2) NULL,
	[UWF_EVP_TVM] [numeric](16, 2) NULL,
	[UWF_HEP_CHN] [numeric](16, 2) NULL,
	[UWF_HMF_BLR] [numeric](16, 2) NULL,
	[UWF_ISE_TVM] [numeric](16, 2) NULL,
	[UWF_KLS_TVM] [numeric](16, 2) NULL,
	[UWF_KNS_TVM] [numeric](16, 2) NULL,
	[UWF_KRS_TVM] [numeric](16, 2) NULL,
	[UWF_KTS_TVM] [numeric](16, 2) NULL,
	[UWF_MHC_TVM] [numeric](16, 2) NULL,
	[UWF_MIT_CHN] [numeric](16, 2) NULL,
	[UWF_MTF_BLR] [numeric](16, 2) NULL,
	[UWF_NCP_CHN] [datetime] NULL,
	[UWF_NSH_TVM] [numeric](16, 2) NULL,
	[UWF_ORP_CN] [numeric](16, 2) NULL,
	[UWF_PRP_TVM] [numeric](16, 2) NULL,
	[UWF_RCC_TVM] [numeric](16, 2) NULL,
	[UWF_SCP_CHN] [numeric](16, 2) NULL,
	[UWF_SCP_KOC] [numeric](16, 2) NULL,
	[UWF_SHM_BLR] [numeric](16, 2) NULL,
	[UWF_SIL_CHN] [numeric](16, 2) NULL,
	[UWF_SIL_KOC] [numeric](16, 2) NULL,
	[UWF_SOS_KOC] [numeric](16, 2) NULL,
	[UWF_STB_KOC] [numeric](16, 2) NULL,
	[UWF_UFC_BLR] [numeric](16, 2) NULL,
	[UWF_UFC_CHN] [numeric](16, 2) NULL,
	[UWF_UFC_IND] [numeric](16, 2) NULL,
	[UWF_UFC_KOC] [numeric](16, 2) NULL,
	[UWF_UFC_TVM] [numeric](16, 2) NULL,
	[UWF_VGS_TVM] [numeric](16, 2) NULL,
	[UWF_WRD_BLR] [numeric](16, 2) NULL,
	[VPD] [numeric](16, 2) NULL,
	[VPS] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[ITAX] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PRF] [numeric](16, 2) NULL,
	[PTX] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[ALW_NSH] [numeric](16, 2) NULL,
	[ALW_ONC] [numeric](16, 2) NULL,
	[ALW_PRJ] [numeric](16, 2) NULL,
	[ALW_SKL] [numeric](16, 2) NULL,
	[ALW_WKD] [numeric](16, 2) NULL,
	[BNS_DEF] [numeric](16, 2) NULL,
	[BNS_JON] [numeric](16, 2) NULL,
	[BNS_LIN] [numeric](16, 2) NULL,
	[BNS_ONT] [numeric](16, 2) NULL,
	[BNS_PRJ] [numeric](16, 2) NULL,
	[BNS_PRS] [numeric](16, 2) NULL,
	[BNS_REF] [numeric](16, 2) NULL,
	[BNS_SPC] [numeric](16, 2) NULL,
	[COM_PAY] [numeric](16, 2) NULL,
	[DEP_ALW] [numeric](16, 2) NULL,
	[EXP] [numeric](16, 2) NULL,
	[INC_DEL] [numeric](16, 2) NULL,
	[INC_OTH] [numeric](16, 2) NULL,
	[INC_TRN] [numeric](16, 2) NULL,
	[LEC] [numeric](16, 2) NULL,
	[LPR] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[NPP] [numeric](16, 2) NULL,
	[RWD] [numeric](16, 2) NULL,
	[VPY] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_BONUS] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_EDUALN] [numeric](16, 2) NULL,
	[ARR_HRA] [numeric](16, 2) NULL,
	[ARR_MEALALL] [numeric](16, 2) NULL,
	[ARR_PF] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[ARR_VPAY] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[EDUALN] [numeric](16, 2) NULL,
	[GRACTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PFEMPR] [numeric](16, 2) NULL,
	[SODEXO] [numeric](16, 2) NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[VPAY] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[PAYDAYS] [numeric](16, 2) NULL,
	[GPAY] [numeric](16, 2) NULL,
	[GDED] [numeric](16, 2) NULL,
	[NPAY] [numeric](16, 2) NULL,
	[NCPDAY] [numeric](16, 2) NULL,
	[ESIC_WAGE] [numeric](16, 2) NULL,
	[ESIEMPR] [numeric](16, 2) NULL,
	[ESICTOT] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[SRCG] [numeric](16, 2) NULL,
	[ECESS] [numeric](16, 2) NULL,
	[LWFEMPR] [numeric](16, 2) NULL,
	[LWFTOT] [numeric](16, 2) NULL,
	[PFWAGE] [numeric](16, 2) NULL,
	[EPSWAGE] [numeric](16, 2) NULL,
	[EDLIWAGE] [numeric](16, 2) NULL,
	[VPF] [numeric](16, 2) NULL,
	[PFERCON] [numeric](16, 2) NULL,
	[EMPREPS] [numeric](16, 2) NULL,
	[EMPRFPS] [numeric](16, 2) NULL,
	[EMPREDLI] [numeric](16, 2) NULL,
	[EMPRADM] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[CARPERQ] [numeric](16, 2) NULL,
	[RFAPERQ] [numeric](16, 2) NULL,
	[OTHER_PERK] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_CHECKER] [int] NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[YTDCONV] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_37]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_37](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NOT NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[PBCQ] [numeric](16, 2) NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[TRVADV] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[NETPAY] [numeric](16, 2) NULL,
	[PF] [numeric](16, 2) NULL,
	[ESIEE] [numeric](16, 2) NULL,
	[ESIER] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[LWFER] [numeric](16, 2) NULL,
	[PFEDA] [numeric](16, 2) NULL,
	[PFEDL] [numeric](16, 2) NULL,
	[PFEPF] [numeric](16, 2) NULL,
	[PFEPS] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[VPF] [numeric](16, 2) NULL,
	[ANPL] [numeric](16, 2) NULL,
	[BCHARG] [numeric](16, 2) NULL,
	[BNS_JON] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[BONUSAWS] [numeric](16, 2) NULL,
	[BPAWD] [numeric](16, 2) NULL,
	[ERN_EXGRAT] [numeric](16, 2) NULL,
	[ERN_SURFEE] [numeric](16, 2) NULL,
	[GRATP] [numeric](16, 2) NULL,
	[GROSSUP] [numeric](16, 2) NULL,
	[INSOTH] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[MICP] [numeric](16, 2) NULL,
	[NOPAYLV] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[NTHELP] [numeric](16, 2) NULL,
	[OT] [numeric](16, 2) NULL,
	[PERDIEM] [numeric](16, 2) NULL,
	[REFFEE] [numeric](16, 2) NULL,
	[SAFP] [numeric](16, 2) NULL,
	[SALFHC] [numeric](16, 2) NULL,
	[SURALL] [numeric](16, 2) NULL,
	[TFEES] [numeric](16, 2) NULL,
	[TTHELP] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CAR_FUELALLOWANCE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[GRACTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[LTA_RIM] [numeric](16, 2) NULL,
	[MEDALL] [numeric](16, 2) NULL,
	[MEDRIM] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[OTHER_TRAVELALLOWANC] [numeric](16, 2) NULL,
	[OTHRIM] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[SUBALL] [numeric](16, 2) NULL,
	[SUPERANNUATION] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[TPTALL] [numeric](16, 2) NULL,
	[EMPLOYER_PF] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[YTD_BASIC] [numeric](16, 2) NULL,
	[YTD_HRA] [numeric](16, 2) NULL,
	[YTD_MEAL] [numeric](16, 2) NULL,
	[YTD_SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[YTD_TELEPHONE] [numeric](16, 2) NULL,
	[MEDTAX] [numeric](16, 2) NULL,
	[LTANTAX] [numeric](16, 2) NULL,
	[PDALLW] [numeric](16, 2) NULL,
	[ERN_INSDED] [numeric](16, 2) NULL,
	[PFADM] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_38]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_38](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NOT NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CANTEEN] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[PROVIDENT_FUND] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[COMPAY] [numeric](16, 2) NULL,
	[LEAVETRAVEL_ALLOWANC] [numeric](16, 2) NULL,
	[ARR_BONUS] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[AMOUNT] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_39]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_39](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NOT NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[GDED] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[PF] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[ITAX] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[VPF] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[HOLDAMT] [numeric](16, 2) NULL,
	[LEC] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[OTHERN] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_CCA] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_HRA] [numeric](16, 2) NULL,
	[ARR_MEALALL] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_SFTALL] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[ARR_TELE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[ERN_OTHALL] [numeric](16, 2) NULL,
	[GPAY] [numeric](16, 2) NULL,
	[GRACTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA_RIM] [numeric](16, 2) NULL,
	[MEDRIM] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[NPAY] [numeric](16, 2) NULL,
	[OTHRIM] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PFEMPR] [numeric](16, 2) NULL,
	[SFTALL] [numeric](16, 2) NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[BPRIM] [numeric](16, 2) NULL,
	[CCA] [numeric](16, 2) NULL,
	[DRV_RIM] [numeric](16, 2) NULL,
	[FODRIM] [numeric](16, 2) NULL,
	[TELEPHONE] [numeric](16, 2) NULL,
	[STABON] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[YTD_BASIC] [numeric](16, 2) NULL,
	[YTD_CONVEYANCE] [numeric](16, 2) NULL,
	[YTD_HRA] [numeric](16, 2) NULL,
	[YTD_SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[PAYDAYS] [numeric](16, 2) NULL,
	[ARR_DAYS] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_41]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_41](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[BUS] [numeric](16, 2) NULL,
	[OID] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[MEAL] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[ITAX] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[ESIC_WAGE] [numeric](16, 2) NULL,
	[BNS_DEF] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[COMPAY] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_BONUS] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_DAYS] [int] NULL,
	[ARR_HRA] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_PF] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PAYDAYS] [int] NULL,
	[CCA] [numeric](16, 2) NULL,
	[EMPLOYER_PF] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[AMOUNT] [numeric](16, 2) NULL,
	[COMPONENT] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_44]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_44](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[ADJUST] [numeric](16, 2) NULL,
	[CAHG] [numeric](16, 2) NULL,
	[LON_SALADV] [numeric](16, 2) NULL,
	[NOTDED] [numeric](16, 2) NULL,
	[REFBON] [numeric](16, 2) NULL,
	[UNICOST] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[GDED] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[NPAY] [numeric](16, 2) NULL,
	[COLAAC] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[INCENT] [numeric](16, 2) NULL,
	[JONBON] [numeric](16, 2) NULL,
	[LVNCAS] [numeric](16, 2) NULL,
	[NOTBUY] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[OTHERN] [numeric](16, 2) NULL,
	[PAYHLD] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REMPAY] [numeric](16, 2) NULL,
	[RETBON] [numeric](16, 2) NULL,
	[WZINCT] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[COLAAL] [numeric](16, 2) NULL,
	[ESIEMPR] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PFEMPR] [numeric](16, 2) NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[STATEBONUS] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PROPCASHRECOVERY] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_5]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_69]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_69](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_7]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_70]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_70](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_71]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_71](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_72]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_72](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_73]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_73](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_74]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_74](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_75]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_75](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_76]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_76](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_HIS_77]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_HIS_77](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[HRDID] [int] NULL,
	[UPDATED_ON] [datetime] NULL,
	[UPDATED_BY] [int] NULL,
	[ACTION] [varchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_1]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
	[ADJUST] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_14]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_15]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAY_PAYDATE] [datetime] NULL,
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_27]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_28]    Script Date: 03-06-2019 19:01:25 ******/
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
/****** Object:  Table [dbo].[Ivap_PAY_MAST_29]    Script Date: 03-06-2019 19:01:25 ******/
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
/****** Object:  Table [dbo].[Ivap_PAY_MAST_30]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_31]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_31](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[ADV] [numeric](16, 2) NULL,
	[AIF] [numeric](16, 2) NULL,
	[GDD] [numeric](16, 2) NULL,
	[GYM] [numeric](16, 2) NULL,
	[IAD] [numeric](16, 2) NULL,
	[IPD] [numeric](16, 2) NULL,
	[LOP] [numeric](16, 2) NULL,
	[MAD] [numeric](16, 2) NULL,
	[NPR] [numeric](16, 2) NULL,
	[OID] [numeric](16, 2) NULL,
	[PDD] [numeric](16, 2) NULL,
	[SDD] [numeric](16, 2) NULL,
	[STY] [numeric](16, 2) NULL,
	[TDD] [numeric](16, 2) NULL,
	[TEA] [numeric](16, 2) NULL,
	[TRN] [numeric](16, 2) NULL,
	[UWF] [numeric](16, 2) NULL,
	[UWF_ABY_TVM] [numeric](16, 2) NULL,
	[UWF_ARP_TVM] [numeric](16, 2) NULL,
	[UWF_ASB_KOC] [numeric](16, 2) NULL,
	[UWF_ATS_TVM] [numeric](16, 2) NULL,
	[UWF_BDD_TVM] [numeric](16, 2) NULL,
	[UWF_BLD_BLR] [numeric](16, 2) NULL,
	[UWF_BLD_CHN] [numeric](16, 2) NULL,
	[UWF_BLD_KOC] [numeric](16, 2) NULL,
	[UWF_BPI_TVM] [numeric](16, 2) NULL,
	[UWF_CBI_TVM] [numeric](16, 2) NULL,
	[UWF_CHS_TVM] [numeric](16, 2) NULL,
	[UWF_CIS_TVM] [numeric](16, 2) NULL,
	[UWF_ENS_TVM] [numeric](16, 2) NULL,
	[UWF_EVP_BLR] [numeric](16, 2) NULL,
	[UWF_EVP_KOC] [numeric](16, 2) NULL,
	[UWF_EVP_TVM] [numeric](16, 2) NULL,
	[UWF_HEP_CHN] [numeric](16, 2) NULL,
	[UWF_HMF_BLR] [numeric](16, 2) NULL,
	[UWF_ISE_TVM] [numeric](16, 2) NULL,
	[UWF_KLS_TVM] [numeric](16, 2) NULL,
	[UWF_KNS_TVM] [numeric](16, 2) NULL,
	[UWF_KRS_TVM] [numeric](16, 2) NULL,
	[UWF_KTS_TVM] [numeric](16, 2) NULL,
	[UWF_MHC_TVM] [numeric](16, 2) NULL,
	[UWF_MIT_CHN] [numeric](16, 2) NULL,
	[UWF_MTF_BLR] [numeric](16, 2) NULL,
	[UWF_NCP_CHN] [datetime] NULL,
	[UWF_NSH_TVM] [numeric](16, 2) NULL,
	[UWF_ORP_CN] [numeric](16, 2) NULL,
	[UWF_PRP_TVM] [numeric](16, 2) NULL,
	[UWF_RCC_TVM] [numeric](16, 2) NULL,
	[UWF_SCP_CHN] [numeric](16, 2) NULL,
	[UWF_SCP_KOC] [numeric](16, 2) NULL,
	[UWF_SHM_BLR] [numeric](16, 2) NULL,
	[UWF_SIL_CHN] [numeric](16, 2) NULL,
	[UWF_SIL_KOC] [numeric](16, 2) NULL,
	[UWF_SOS_KOC] [numeric](16, 2) NULL,
	[UWF_STB_KOC] [numeric](16, 2) NULL,
	[UWF_UFC_BLR] [numeric](16, 2) NULL,
	[UWF_UFC_CHN] [numeric](16, 2) NULL,
	[UWF_UFC_IND] [numeric](16, 2) NULL,
	[UWF_UFC_KOC] [numeric](16, 2) NULL,
	[UWF_UFC_TVM] [numeric](16, 2) NULL,
	[UWF_VGS_TVM] [numeric](16, 2) NULL,
	[UWF_WRD_BLR] [numeric](16, 2) NULL,
	[VPD] [numeric](16, 2) NULL,
	[VPS] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[ITAX] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PRF] [numeric](16, 2) NULL,
	[PTX] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[ALW_NSH] [numeric](16, 2) NULL,
	[ALW_ONC] [numeric](16, 2) NULL,
	[ALW_PRJ] [numeric](16, 2) NULL,
	[ALW_SKL] [numeric](16, 2) NULL,
	[ALW_WKD] [numeric](16, 2) NULL,
	[BNS_DEF] [numeric](16, 2) NULL,
	[BNS_JON] [numeric](16, 2) NULL,
	[BNS_LIN] [numeric](16, 2) NULL,
	[BNS_ONT] [numeric](16, 2) NULL,
	[BNS_PRJ] [numeric](16, 2) NULL,
	[BNS_PRS] [numeric](16, 2) NULL,
	[BNS_REF] [numeric](16, 2) NULL,
	[BNS_SPC] [numeric](16, 2) NULL,
	[COM_PAY] [numeric](16, 2) NULL,
	[DEP_ALW] [numeric](16, 2) NULL,
	[EXP] [numeric](16, 2) NULL,
	[INC_DEL] [numeric](16, 2) NULL,
	[INC_OTH] [numeric](16, 2) NULL,
	[INC_TRN] [numeric](16, 2) NULL,
	[LEC] [numeric](16, 2) NULL,
	[LPR] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[NPP] [numeric](16, 2) NULL,
	[RWD] [numeric](16, 2) NULL,
	[VPY] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_BONUS] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_EDUALN] [numeric](16, 2) NULL,
	[ARR_HRA] [numeric](16, 2) NULL,
	[ARR_MEALALL] [numeric](16, 2) NULL,
	[ARR_PF] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[ARR_VPAY] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[EDUALN] [numeric](16, 2) NULL,
	[GRACTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PFEMPR] [numeric](16, 2) NULL,
	[SODEXO] [numeric](16, 2) NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[VPAY] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[PAYDAYS] [numeric](16, 2) NULL,
	[GPAY] [numeric](16, 2) NULL,
	[GDED] [numeric](16, 2) NULL,
	[NPAY] [numeric](16, 2) NULL,
	[NCPDAY] [numeric](16, 2) NULL,
	[ESIC_WAGE] [numeric](16, 2) NULL,
	[ESIEMPR] [numeric](16, 2) NULL,
	[ESICTOT] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[SRCG] [numeric](16, 2) NULL,
	[ECESS] [numeric](16, 2) NULL,
	[LWFEMPR] [numeric](16, 2) NULL,
	[LWFTOT] [numeric](16, 2) NULL,
	[PFWAGE] [numeric](16, 2) NULL,
	[EPSWAGE] [numeric](16, 2) NULL,
	[EDLIWAGE] [numeric](16, 2) NULL,
	[VPF] [numeric](16, 2) NULL,
	[PFERCON] [numeric](16, 2) NULL,
	[EMPREPS] [numeric](16, 2) NULL,
	[EMPRFPS] [numeric](16, 2) NULL,
	[EMPREDLI] [numeric](16, 2) NULL,
	[EMPRADM] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[CARPERQ] [numeric](16, 2) NULL,
	[RFAPERQ] [numeric](16, 2) NULL,
	[OTHER_PERK] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[YTDCONV] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_37]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_37](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[PBCQ] [numeric](16, 2) NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[TRVADV] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[NETPAY] [numeric](16, 2) NULL,
	[PF] [numeric](16, 2) NULL,
	[ESIEE] [numeric](16, 2) NULL,
	[ESIER] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[LWFER] [numeric](16, 2) NULL,
	[PFEDA] [numeric](16, 2) NULL,
	[PFEDL] [numeric](16, 2) NULL,
	[PFEPF] [numeric](16, 2) NULL,
	[PFEPS] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[VPF] [numeric](16, 2) NULL,
	[ANPL] [numeric](16, 2) NULL,
	[BCHARG] [numeric](16, 2) NULL,
	[BNS_JON] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[BONUSAWS] [numeric](16, 2) NULL,
	[BPAWD] [numeric](16, 2) NULL,
	[ERN_EXGRAT] [numeric](16, 2) NULL,
	[ERN_SURFEE] [numeric](16, 2) NULL,
	[GRATP] [numeric](16, 2) NULL,
	[GROSSUP] [numeric](16, 2) NULL,
	[INSOTH] [numeric](16, 2) NULL,
	[JOINING_BONUS] [numeric](16, 2) NULL,
	[MICP] [numeric](16, 2) NULL,
	[NOPAYLV] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[NTHELP] [numeric](16, 2) NULL,
	[OT] [numeric](16, 2) NULL,
	[PERDIEM] [numeric](16, 2) NULL,
	[REFFEE] [numeric](16, 2) NULL,
	[SAFP] [numeric](16, 2) NULL,
	[SALFHC] [numeric](16, 2) NULL,
	[SURALL] [numeric](16, 2) NULL,
	[TFEES] [numeric](16, 2) NULL,
	[TTHELP] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CAR_FUELALLOWANCE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[GRACTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[LTA_RIM] [numeric](16, 2) NULL,
	[MEDALL] [numeric](16, 2) NULL,
	[MEDRIM] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[OTHER_TRAVELALLOWANC] [numeric](16, 2) NULL,
	[OTHRIM] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[SUBALL] [numeric](16, 2) NULL,
	[SUPERANNUATION] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[TPTALL] [numeric](16, 2) NULL,
	[EMPLOYER_PF] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[YTD_BASIC] [numeric](16, 2) NULL,
	[YTD_HRA] [numeric](16, 2) NULL,
	[YTD_MEAL] [numeric](16, 2) NULL,
	[YTD_SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[YTD_TELEPHONE] [numeric](16, 2) NULL,
	[MEDTAX] [numeric](16, 2) NULL,
	[LTANTAX] [numeric](16, 2) NULL,
	[PDALLW] [numeric](16, 2) NULL,
	[ERN_INSDED] [numeric](16, 2) NULL,
	[PFADM] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_38]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_38](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CANTEEN] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[PROVIDENT_FUND] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[COMPAY] [numeric](16, 2) NULL,
	[LEAVETRAVEL_ALLOWANC] [numeric](16, 2) NULL,
	[ARR_BONUS] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[AMOUNT] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_39]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_39](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[GDED] [numeric](16, 2) NULL,
	[OTHDED] [numeric](16, 2) NULL,
	[PF] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[ITAX] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[VPF] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[HOLDAMT] [numeric](16, 2) NULL,
	[LEC] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[OTHERN] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_CCA] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_HRA] [numeric](16, 2) NULL,
	[ARR_MEALALL] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_SFTALL] [numeric](16, 2) NULL,
	[ARR_SPALL] [numeric](16, 2) NULL,
	[ARR_TELE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[ERN_OTHALL] [numeric](16, 2) NULL,
	[GPAY] [numeric](16, 2) NULL,
	[GRACTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA_RIM] [numeric](16, 2) NULL,
	[MEDRIM] [numeric](16, 2) NULL,
	[MELRIM] [numeric](16, 2) NULL,
	[NPAY] [numeric](16, 2) NULL,
	[OTHRIM] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PFEMPR] [numeric](16, 2) NULL,
	[SFTALL] [numeric](16, 2) NULL,
	[SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[TELRIM] [numeric](16, 2) NULL,
	[BPRIM] [numeric](16, 2) NULL,
	[CCA] [numeric](16, 2) NULL,
	[DRV_RIM] [numeric](16, 2) NULL,
	[FODRIM] [numeric](16, 2) NULL,
	[TELEPHONE] [numeric](16, 2) NULL,
	[STABON] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[YTD_BASIC] [numeric](16, 2) NULL,
	[YTD_CONVEYANCE] [numeric](16, 2) NULL,
	[YTD_HRA] [numeric](16, 2) NULL,
	[YTD_SPL_ALLOWANCE] [numeric](16, 2) NULL,
	[PAYDAYS] [numeric](16, 2) NULL,
	[ARR_DAYS] [numeric](16, 2) NULL,
	[CTC_PF] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_41]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_41](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[BUS] [numeric](16, 2) NULL,
	[OID] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[MEAL] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[ITAX] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[ESIC_WAGE] [numeric](16, 2) NULL,
	[BNS_DEF] [numeric](16, 2) NULL,
	[BONUS] [numeric](16, 2) NULL,
	[COMPAY] [numeric](16, 2) NULL,
	[ARR_BASIC] [numeric](16, 2) NULL,
	[ARR_BONUS] [numeric](16, 2) NULL,
	[ARR_CONV] [numeric](16, 2) NULL,
	[ARR_DAYS] [int] NULL,
	[ARR_HRA] [numeric](16, 2) NULL,
	[ARR_OTHALL] [numeric](16, 2) NULL,
	[ARR_PF] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[CTC] [numeric](16, 2) NULL,
	[DA] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PAYDAYS] [int] NULL,
	[CCA] [numeric](16, 2) NULL,
	[EMPLOYER_PF] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[AMOUNT] [numeric](16, 2) NULL,
	[COMPONENT] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_44]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_44](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[ADJUST] [numeric](16, 2) NULL,
	[CAHG] [numeric](16, 2) NULL,
	[LON_SALADV] [numeric](16, 2) NULL,
	[NOTDED] [numeric](16, 2) NULL,
	[REFBON] [numeric](16, 2) NULL,
	[UNICOST] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[GDED] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[NPAY] [numeric](16, 2) NULL,
	[COLAAC] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[INCENT] [numeric](16, 2) NULL,
	[JONBON] [numeric](16, 2) NULL,
	[LVNCAS] [numeric](16, 2) NULL,
	[NOTBUY] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[OTHERN] [numeric](16, 2) NULL,
	[PAYHLD] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REMPAY] [numeric](16, 2) NULL,
	[RETBON] [numeric](16, 2) NULL,
	[WZINCT] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[COLAAL] [numeric](16, 2) NULL,
	[ESIEMPR] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PFEMPR] [numeric](16, 2) NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[STATEBONUS] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PROPCASHRECOVERY] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_5]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_69]    Script Date: 03-06-2019 19:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_69](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_7]    Script Date: 03-06-2019 19:01:25 ******/
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
	[PAYDATE] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_70]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_70](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_71]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_71](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_72]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_72](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_73]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_73](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_74]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_74](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_75]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_75](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_76]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_76](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_PAY_MAST_77]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_PAY_MAST_77](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[WF_STATUS] [varchar](2000) NULL,
	[FILE_ID] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PAY_EMP_CODE] [nvarchar](50) NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ivap_setup_template]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ivap_setup_template](
	[Tid] [int] IDENTITY(1,1) NOT NULL,
	[File_Category] [nvarchar](200) NULL,
	[File_Name] [nvarchar](200) NULL,
	[File_Description] [nvarchar](200) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[File_Type] [nvarchar](200) NULL,
	[PayRollInputFile] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Tid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_TEMP_HIS_1]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_TEMP_HIS_1](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[WF_STATUS] [varchar](200) NULL,
	[CURR_STATUS] [varchar](200) NULL,
	[CURR_USER] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_CHECKER] [int] NULL,
	[SAL_ADVANCE] [numeric](16, 2) NULL,
	[YTD_LOAN] [numeric](16, 2) NULL,
	[CONVEYANCE] [numeric](16, 2) NULL,
	[DEPT_CODE] [int] NULL,
	[GRD_CODE] [int] NULL,
	[BANK_CODE] [nvarchar](50) NULL,
	[BANKACNO] [nvarchar](50) NULL,
	[DOJ] [datetime] NULL,
	[EMP_CODE] [nvarchar](50) NULL,
	[FNAME] [nvarchar](50) NULL,
	[LNAME] [nvarchar](50) NULL,
	[YTD_SAL_ADVANCE] [numeric](16, 2) NULL,
	[YTD_CONVEYANCE] [numeric](16, 2) NULL,
	[ADJUST] [numeric](16, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_TEMP_HIS_44]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_TEMP_HIS_44](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[WF_STATUS] [varchar](200) NULL,
	[CURR_STATUS] [varchar](200) NULL,
	[CURR_USER] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_MAKER_DATE] [datetime] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_CHECKER_DATE] [datetime] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[CLIENT_ADMIN_DATE] [datetime] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_MAKER_DATE] [datetime] NULL,
	[MYND_CHECKER] [int] NULL,
	[MYND_CHECKER_DATE] [datetime] NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[EMPTYPE] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[AADHAR] [nvarchar](12) NULL,
	[ACTYPE] [nvarchar](15) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[DOR] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[ESICNO] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MARITALSTATUS] [nvarchar](20) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[PFNO] [nvarchar](30) NULL,
	[PROPCODE] [nvarchar](30) NULL,
	[REASON] [nvarchar](200) NULL,
	[UAN] [nvarchar](12) NULL,
	[WEF] [datetime] NULL,
	[WORKCITY] [nvarchar](30) NULL,
	[ADJUST] [numeric](16, 2) NULL,
	[CAHG] [numeric](16, 2) NULL,
	[LON_SALADV] [numeric](16, 2) NULL,
	[NOTDED] [numeric](16, 2) NULL,
	[REFBON] [numeric](16, 2) NULL,
	[UNICOST] [numeric](16, 2) NULL,
	[ESI] [numeric](16, 2) NULL,
	[GDED] [numeric](16, 2) NULL,
	[LWF] [numeric](16, 2) NULL,
	[PF] [numeric](16, 2) NULL,
	[PTAX] [numeric](16, 2) NULL,
	[TDS] [numeric](16, 2) NULL,
	[NPAY] [numeric](16, 2) NULL,
	[COLAAC] [numeric](16, 2) NULL,
	[GRATUITY] [numeric](16, 2) NULL,
	[INCENT] [numeric](16, 2) NULL,
	[JONBON] [numeric](16, 2) NULL,
	[LVNCAS] [numeric](16, 2) NULL,
	[NOTBUY] [numeric](16, 2) NULL,
	[NOTPAY] [numeric](16, 2) NULL,
	[OTHERN] [numeric](16, 2) NULL,
	[PAYHLD] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REMPAY] [numeric](16, 2) NULL,
	[RETBON] [numeric](16, 2) NULL,
	[WZINCT] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[COLAAL] [numeric](16, 2) NULL,
	[ESIEMPR] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[PFEMPR] [numeric](16, 2) NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[CITIZENSHIP] [varchar](30) NULL,
	[STATEBONUS] [numeric](16, 2) NULL,
	[LWOPDAYS] [numeric](16, 2) NULL,
	[REMARKS] [varchar](300) NULL,
	[STATUS] [varchar](15) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[PROPCASHRECOVERY] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[EPSSTATUS] [varchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[PFSTATUS] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_TEMP_HIS_72]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_TEMP_HIS_72](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[WF_STATUS] [varchar](200) NULL,
	[CURR_STATUS] [varchar](200) NULL,
	[CURR_USER] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_MAKER_DATE] [datetime] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_CHECKER_DATE] [datetime] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[CLIENT_ADMIN_DATE] [datetime] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_MAKER_DATE] [datetime] NULL,
	[MYND_CHECKER] [int] NULL,
	[MYND_CHECKER_DATE] [datetime] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_TEMP_HIS_73]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_TEMP_HIS_73](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[WF_STATUS] [varchar](200) NULL,
	[CURR_STATUS] [varchar](200) NULL,
	[CURR_USER] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_MAKER_DATE] [datetime] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_CHECKER_DATE] [datetime] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[CLIENT_ADMIN_DATE] [datetime] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_MAKER_DATE] [datetime] NULL,
	[MYND_CHECKER] [int] NULL,
	[MYND_CHECKER_DATE] [datetime] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_TEMP_HIS_74]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_TEMP_HIS_74](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[WF_STATUS] [varchar](200) NULL,
	[CURR_STATUS] [varchar](200) NULL,
	[CURR_USER] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_MAKER_DATE] [datetime] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_CHECKER_DATE] [datetime] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[CLIENT_ADMIN_DATE] [datetime] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_MAKER_DATE] [datetime] NULL,
	[MYND_CHECKER] [int] NULL,
	[MYND_CHECKER_DATE] [datetime] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_TEMP_HIS_75]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_TEMP_HIS_75](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[WF_STATUS] [varchar](200) NULL,
	[CURR_STATUS] [varchar](200) NULL,
	[CURR_USER] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_MAKER_DATE] [datetime] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_CHECKER_DATE] [datetime] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[CLIENT_ADMIN_DATE] [datetime] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_MAKER_DATE] [datetime] NULL,
	[MYND_CHECKER] [int] NULL,
	[MYND_CHECKER_DATE] [datetime] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_TEMP_HIS_76]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_TEMP_HIS_76](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[WF_STATUS] [varchar](200) NULL,
	[CURR_STATUS] [varchar](200) NULL,
	[CURR_USER] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_MAKER_DATE] [datetime] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_CHECKER_DATE] [datetime] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[CLIENT_ADMIN_DATE] [datetime] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_MAKER_DATE] [datetime] NULL,
	[MYND_CHECKER] [int] NULL,
	[MYND_CHECKER_DATE] [datetime] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_TEMP_HIS_77]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_TEMP_HIS_77](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FILE_ID] [int] NULL,
	[TEMP_BATCH_ID] [int] NULL,
	[TEMP_BATCH_NO] [varchar](100) NULL,
	[WF_STATUS] [varchar](200) NULL,
	[CURR_STATUS] [varchar](200) NULL,
	[CURR_USER] [int] NULL,
	[CREATED_ON] [datetime] NULL,
	[CREATED_BY] [int] NULL,
	[CLIENT_MAKER] [int] NULL,
	[CLIENT_MAKER_DATE] [datetime] NULL,
	[CLIENT_CHECKER] [int] NULL,
	[CLIENT_CHECKER_DATE] [datetime] NULL,
	[CLIENT_ADMIN] [int] NULL,
	[CLIENT_ADMIN_DATE] [datetime] NULL,
	[MYND_MAKER] [int] NULL,
	[MYND_MAKER_DATE] [datetime] NULL,
	[MYND_CHECKER] [int] NULL,
	[MYND_CHECKER_DATE] [datetime] NULL,
	[IS_VALID] [int] NULL,
	[LOANADVANCE] [numeric](16, 2) NULL,
	[MEALDEDUCTION] [numeric](16, 2) NULL,
	[NOTICERECOVERY] [numeric](16, 2) NULL,
	[OTHERDEDUCTION] [numeric](16, 2) NULL,
	[SALARYADVANCE] [numeric](16, 2) NULL,
	[TRAVELDEDUCTION] [numeric](16, 2) NULL,
	[UNIFORMDEDUCTION] [numeric](16, 2) NULL,
	[DEFERREDBONUS] [numeric](16, 2) NULL,
	[INCENTIVE] [numeric](16, 2) NULL,
	[JOININGBONUS] [numeric](16, 2) NULL,
	[LEAVEENCASH] [numeric](16, 2) NULL,
	[NOTICEPAY] [numeric](16, 2) NULL,
	[OTHEREARNING] [numeric](16, 2) NULL,
	[OVERTIME] [numeric](16, 2) NULL,
	[PLI] [numeric](16, 2) NULL,
	[REFERRALBONUS] [numeric](16, 2) NULL,
	[RETENTIONBONUS] [numeric](16, 2) NULL,
	[SHIFTALLOWANCE] [numeric](16, 2) NULL,
	[BASIC] [numeric](16, 2) NULL,
	[FIXEDMONTHLYCTC] [numeric](16, 2) NULL,
	[HRA] [numeric](16, 2) NULL,
	[LTA] [numeric](16, 2) NULL,
	[PAYDATE] [datetime] NULL,
	[SPLALL] [numeric](16, 2) NULL,
	[STATBONUS] [numeric](16, 2) NULL,
	[TOTALCTC] [numeric](16, 2) NULL,
	[BANKNAME] [int] NULL,
	[COSTCENTER] [int] NULL,
	[DEPARTMENT] [int] NULL,
	[DESIGNATION] [int] NULL,
	[GRADE] [int] NULL,
	[LOCATION] [int] NULL,
	[STATE] [int] NULL,
	[ESIEMPLOYER] [numeric](16, 2) NULL,
	[GRATUITYCTC] [numeric](16, 2) NULL,
	[PFEMPLOYER] [numeric](16, 2) NULL,
	[AADHAR] [nvarchar](12) NULL,
	[BANKACCNO] [int] NULL,
	[DOB] [datetime] NULL,
	[DOJ] [datetime] NULL,
	[DOL] [datetime] NULL,
	[EFFECTIVEDATE] [datetime] NULL,
	[EMAIL_ID] [nvarchar](50) NULL,
	[EMP_CODE] [nvarchar](15) NULL,
	[EMP_NAME] [nvarchar](30) NULL,
	[FATHER_HUSBAND] [nvarchar](30) NULL,
	[FINANCIALYEAR] [datetime] NULL,
	[GENDER] [nvarchar](15) NULL,
	[IFSC] [nvarchar](11) NULL,
	[MOBILENO] [int] NULL,
	[PAN] [nvarchar](10) NULL,
	[STATUS] [nvarchar](15) NULL,
	[UAN] [nvarchar](12) NULL,
	[EPSSTATUS] [nvarchar](30) NULL,
	[INTERNATIONALWORKERS] [nvarchar](3) NULL,
	[PFSTATUS] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ivap_Transpose_Setting]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ivap_Transpose_Setting](
	[Tid] [int] IDENTITY(1,1) NOT NULL,
	[Entity_ID] [int] NULL,
	[File_Id] [int] NULL,
	[Field_Type] [nvarchar](200) NULL,
	[Component_Name] [nvarchar](200) NULL,
	[Display_Name] [nvarchar](200) NULL,
	[Display_Order] [int] NULL,
	[Default_Value] [nvarchar](200) NULL,
	[Created_By] [int] NULL,
	[Created_On] [datetime] NULL,
	[Modified_By] [int] NULL,
	[Modified_On] [datetime] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Tid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_WF_Input]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_WF_Input](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FileID] [int] NOT NULL,
	[PayDate] [datetime] NULL,
	[UID] [int] NULL,
	[No_Of_Records] [int] NULL,
	[TIDs] [varchar](max) NULL,
	[InDate] [datetime] NOT NULL,
	[OutDate] [datetime] NULL,
	[Status] [varchar](500) NULL,
	[Remarks] [varchar](max) NULL,
 CONSTRAINT [PK_IVAP_WF_Input] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IVAP_WF_Output]    Script Date: 03-06-2019 19:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IVAP_WF_Output](
	[TID] [int] IDENTITY(1,1) NOT NULL,
	[FileID] [int] NOT NULL,
	[PayDate] [datetime] NULL,
	[UID] [int] NULL,
	[No_Of_Records] [int] NULL,
	[TIDs] [varchar](max) NULL,
	[InDate] [datetime] NOT NULL,
	[OutDate] [datetime] NULL,
	[Status] [varchar](500) NULL,
	[Remarks] [varchar](max) NULL,
 CONSTRAINT [PK_IVAP_WF_Output] PRIMARY KEY CLUSTERED 
(
	[TID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Temp_Country]    Script Date: 03-06-2019 19:01:26 ******/
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
/****** Object:  Table [dbo].[yourtable]    Script Date: 03-06-2019 19:01:26 ******/
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
ALTER TABLE [dbo].[IVAP_HIS_FILETYPE] ADD  DEFAULT ((0)) FOR [Transpose]
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
ALTER TABLE [dbo].[IVAP_HIS_MONTH_CLOSE] ADD  CONSTRAINT [DF_IVAP_HIS_MONTH_CLOSE_DEFAULT_MONTH]  DEFAULT ((0)) FOR [DEFAULT_MONTH]
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
ALTER TABLE [dbo].[Ivap_HRD_HIS_1] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_1] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
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
ALTER TABLE [dbo].[Ivap_HRD_HIS_31] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_31] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_34] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_34] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_37] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_37] ADD  DEFAULT (NULL) FOR [UPDATED_BY]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_37] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_38] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_38] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_39] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_39] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_41] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_41] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_42] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_42] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_44] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_44] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_5] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_69] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_69] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_7] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_7] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_70] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_70] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_71] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_71] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_72] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_72] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_73] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_73] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_74] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_74] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_75] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_75] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_76] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_76] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_77] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_HIS_77] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_1] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
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
ALTER TABLE [dbo].[Ivap_HRD_MAST_31] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_34] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_37] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_38] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_39] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_41] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_42] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_44] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_69] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_7] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_70] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_71] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_72] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_73] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_74] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_75] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_76] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_HRD_MAST_77] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_1] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_44] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_72] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_73] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_74] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_75] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_76] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_MAST_TEMP_77] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_META_MASTER] ADD  DEFAULT ((0)) FOR [DISPLAY_ORDER]
GO
ALTER TABLE [dbo].[IVAP_META_MASTER_DEFAULT] ADD  DEFAULT ((0)) FOR [DISPLAY_ORDER]
GO
ALTER TABLE [dbo].[IVAP_MONTH_CLOSE] ADD  CONSTRAINT [DF_IVAP_MONTH_CLOSE_DEFAULT_MONTH]  DEFAULT ((0)) FOR [DEFAULT_MONTH]
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
ALTER TABLE [dbo].[IVAP_MST_CAPA_CORRECTIVE] ADD  CONSTRAINT [DF_Status]  DEFAULT (N'OPEN') FOR [STATUS]
GO
ALTER TABLE [dbo].[IVAP_MST_CAPA_PREVENTIVE] ADD  CONSTRAINT [DF_Status_Preventive]  DEFAULT (N'OPEN') FOR [STATUS]
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
ALTER TABLE [dbo].[IVAP_MST_COMPONENT] ADD  DEFAULT (NULL) FOR [File_Template]
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
ALTER TABLE [dbo].[IVAP_Mst_FileExporer_Access_Role] ADD  CONSTRAINT [DF_IVAP_Mst_FileExporer_Access_Role_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[IVAP_Mst_FileExporer_Access_Role] ADD  CONSTRAINT [DF_IVAP_Mst_FileExporer_Access_Role_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[IVAP_Mst_FileMetaData] ADD  CONSTRAINT [DF_IVAP_Mst_FileMetaData_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Ivap_Mst_Files] ADD  CONSTRAINT [DF_Ivap_Mst_Files_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Ivap_Mst_Files] ADD  CONSTRAINT [DF_Ivap_Mst_Files_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[IVAP_MST_FILETYPE] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_MST_FILETYPE] ADD  CONSTRAINT [DF_IVAP_MST_FILETYPE_ISACTIVE]  DEFAULT ((1)) FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[IVAP_MST_FILETYPE] ADD  DEFAULT (NULL) FOR [Img_Icon]
GO
ALTER TABLE [dbo].[IVAP_MST_FILETYPE] ADD  DEFAULT ((0)) FOR [Transpose]
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
ALTER TABLE [dbo].[IVAP_MST_MOM] ADD  DEFAULT ('0') FOR [ISACTIVE]
GO
ALTER TABLE [dbo].[ivap_mst_mom_item] ADD  DEFAULT (NULL) FOR [Remarks]
GO
ALTER TABLE [dbo].[ivap_mst_mom_item] ADD  DEFAULT (NULL) FOR [System_File_Name]
GO
ALTER TABLE [dbo].[ivap_mst_mom_item] ADD  DEFAULT (NULL) FOR [Original_File_Name]
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
ALTER TABLE [dbo].[Ivap_PAY_HIS_31] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_31] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_37] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_37] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_38] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_38] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_39] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_39] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_41] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_41] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_44] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_44] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_5] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_69] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_69] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_7] ADD  DEFAULT (getdate()) FOR [Updated_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_7] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_70] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_70] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_71] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_71] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_72] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_72] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_73] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_73] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_74] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_74] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_75] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_75] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_76] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_76] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_77] ADD  DEFAULT (getdate()) FOR [UPDATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_HIS_77] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_1] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_14] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_15] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_27] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_28] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_29] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_30] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_31] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_37] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_38] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_39] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_41] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_44] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_5] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_69] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_7] ADD  DEFAULT (getdate()) FOR [Created_On]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_70] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_71] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_72] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_73] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_74] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_75] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_76] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_PAY_MAST_77] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[ivap_setup_template] ADD  DEFAULT (NULL) FOR [File_Category]
GO
ALTER TABLE [dbo].[ivap_setup_template] ADD  DEFAULT (NULL) FOR [ModifiedOn]
GO
ALTER TABLE [dbo].[ivap_setup_template] ADD  DEFAULT (NULL) FOR [File_Type]
GO
ALTER TABLE [dbo].[ivap_setup_template] ADD  DEFAULT (NULL) FOR [PayRollInputFile]
GO
ALTER TABLE [dbo].[Ivap_TEMP_HIS_1] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_TEMP_HIS_44] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_TEMP_HIS_72] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_TEMP_HIS_73] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_TEMP_HIS_74] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_TEMP_HIS_75] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_TEMP_HIS_76] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[Ivap_TEMP_HIS_77] ADD  DEFAULT (getdate()) FOR [CREATED_ON]
GO
ALTER TABLE [dbo].[IVAP_WF_Input] ADD  CONSTRAINT [DF_IVAP_WF_Input_InDate]  DEFAULT (getdate()) FOR [InDate]
GO
ALTER TABLE [dbo].[IVAP_WF_Output] ADD  CONSTRAINT [DF_IVAP_WF_Output_InDate]  DEFAULT (getdate()) FOR [InDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check if Rule is set on this component.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IVAP_MST_COMPONENT_ENTITY', @level2type=N'COLUMN',@level2name=N'TID'
GO
