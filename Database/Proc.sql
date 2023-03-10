USE [IVAP]
GO
/****** Object:  StoredProcedure [dbo].[ActivateUser]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE Procedure [dbo].[ActivateUser]
(
@P_Uid int,
@P_Password Varchar(1000),
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
	 Select Isauth From IVAP_MST_USER Where UId=@P_Uid;
    --Select @Ret=Isauth From IVAP_MST_USER Where UId=@P_Uid;
  End
END
GO
/****** Object:  StoredProcedure [dbo].[ADDCAPA]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ADDCAPA]  
(  
@TID int=0,
 @UID INT,    
 @ISSUE NVARCHAR(MAX),    
 @ISSUE_DESCRIPTION NVARCHAR(MAX),    
 @CUSTOMER_IMPACT NVARCHAR(MAX),    
 @SEQUENCE_OF_EVENT NVARCHAR(MAX),    
 @COMMUNICATION_PROCESS NVARCHAR(MAX),    
 @ROOT_CAUSE NVARCHAR(MAX)  
)  
  
AS  
BEGIN  
 DECLARE @Result int=0  
 if(@TID=0)
 begin   
  INSERT INTO IVAP_MST_CAPA(ISSUE,ISSUE_DESCRIPTION,CUSTOMER_IMPACT,SEQUENCE_OF_EVENT,COMMUNICATION_PROCESS,ROOT_CAUSE,CREATED_ON,CREATED_BY)    
  VALUES(@ISSUE,@ISSUE_DESCRIPTION,@CUSTOMER_IMPACT,@SEQUENCE_OF_EVENT,@COMMUNICATION_PROCESS,@ROOT_CAUSE,GETDATE(),@UID)    
  SET @Result = SCOPE_IDENTITY()  
  end  
 else
  begin
  UPDATE IVAP_MST_CAPA SET ISSUE=@ISSUE,ISSUE_DESCRIPTION=@ISSUE_DESCRIPTION,CUSTOMER_IMPACT=@CUSTOMER_IMPACT,SEQUENCE_OF_EVENT=@SEQUENCE_OF_EVENT,
  COMMUNICATION_PROCESS=@COMMUNICATION_PROCESS,ROOT_CAUSE=@ROOT_CAUSE,UPDATE_ON=GETDATE(),UPDATED_BY=@UID WHERE TID=@TID
 end

  SELECT @Result AS result     
END
GO
/****** Object:  StoredProcedure [dbo].[ADDCORRECTIVE]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ADDCORRECTIVE]
(
 @CAPA_ID INT,
 @CORRECTIVE_ACTION NVARCHAR(MAX)='', 
 @CORRECTIVEACTION_TEXT NVARCHAR(MAX),  
 @CORRECTIVEACTION_OWNER NVARCHAR(MAX),
 @UID int
)
AS
BEGIN
 DECLARE @Result int=0   

   INSERT INTO IVAP_MST_CAPA_CORRECTIVE(CAPA_ID,CORRECTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY)  
   VALUES(@CAPA_ID,@CORRECTIVE_ACTION,@CORRECTIVEACTION_TEXT,@CORRECTIVEACTION_OWNER,getdate(),@UID)  
   SET @Result = SCOPE_IDENTITY()  
  SELECT @Result AS result  

END

GO
/****** Object:  StoredProcedure [dbo].[ADDCORRECTIVEPREVENTIVE]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ADDCORRECTIVEPREVENTIVE]
(
 @CAPA_ID INT,
 @CORRECTIVE_ACTION NVARCHAR(MAX)='',  
 @PREVENTIVE_ACTION NVARCHAR(MAX)='',  
 @CORRECTIVEACTION_TEXT NVARCHAR(MAX),  
 @CORRECTIVEACTION_OWNER NVARCHAR(MAX),  
 @PREVENTIVEACTION_TEXT NVARCHAR(MAX),  
 @PREVENTIVEACTION_OWNER NVARCHAR(MAX),
 @UID int
)
AS
BEGIN

 IF(@CORRECTIVE_ACTION='')  
  BEGIN  
   INSERT INTO IVAP_MST_CAPA_PREVENTIVE(CAPA_ID,PREVENTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY)  
   VALUES(@CAPA_ID,@PREVENTIVE_ACTION,@PREVENTIVEACTION_TEXT,@PREVENTIVEACTION_OWNER,getdate(),@UID)  
  
  END  
  ELSE  
  BEGIN  
   INSERT INTO IVAP_MST_CAPA_CORRECTIVE(CAPA_ID,CORRECTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY)  
   VALUES(@CAPA_ID,@CORRECTIVE_ACTION,@CORRECTIVEACTION_TEXT,@CORRECTIVEACTION_OWNER,getdate(),@UID)  
  END  

END

GO
/****** Object:  StoredProcedure [dbo].[AddFile]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddFile]
(
	@FileID INT,
	@EID INT,
	@FileOriginalName NVARCHAR(500),
	@FileSystemGeneratedName NVARCHAR(MAX),
	@FileTypeName VARCHAR(200),
	@MetaValue NVARCHAR(MAX),
	@FileExtention NVARCHAR(100),
	@FileSize decimal(15, 3),--(--VARCHAR(20),
	@CreatedBy INT
)
AS
BEGIN
	--IF(@FileID =0)
	--BEGIN
	--	SET @FileID = (SELECT FileID FROM Ecom_Mst_Files WHERE CustomerID =@CustomerID AND PID=0)
	--END
	INSERT INTO IVAP_Mst_Files(EID,FileType,FileOriginalName,FileSystemGeneratedName,PID,FileTypeName,MetaValue,FileExtention,FileSize,CreatedBy)
		VALUES(@EID,'File',@FileOriginalName,@FileSystemGeneratedName,@FileID,@FileTypeName,@MetaValue,@FileExtention,@FileSize,@CreatedBy)
	SELECT SCOPE_IDENTITY()
END
GO
/****** Object:  StoredProcedure [dbo].[AddMOM]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddMOM]      
(
@ENTITY_ID int
,@MEETING_HELD datetime
,@MEETING_ATTENDEES NVARCHAR(200)
,@ADDRESS nvarchar(max)
,@AGENDA nvarchar(max)
,@CREATED_BY int
,@ISACTIVE char(1)
)      
AS      
BEGIN      
 DECLARE @result INT =0      
 IF Exists(SELECT * FROM IVAP_MST_MOM WHERE AGENDA = @AGENDA and ENTITY_ID=@ENTITY_ID)      
 BEGIN      
  SET @result = -1      
  SELECT @result as result      
  RETURN;      
 END    
	Begin  
		  INSERT INTO IVAP_MST_MOM(ENTITY_ID,MEETING_HELD,MEETING_ATTENDEES,ADDRESS,AGENDA,CREATED_ON,CREATED_BY,ISACTIVE)      
		  VALUES(@ENTITY_ID,@MEETING_HELD,@MEETING_ATTENDEES,@ADDRESS,@AGENDA,getdate(),@CREATED_BY,@ISACTIVE)      
		  SET @result = SCOPE_IDENTITY();     
		  EXEC DATA_ACCESSCONTROL_INSERT @CREATED_BY,'IVAP_MST_MOM',@result   
		  --EXEC Bank_History @result,@CREATED_BY,'Create'      
		 SELECT @result AS result      
	end 
 
END 

GO
/****** Object:  StoredProcedure [dbo].[AddMomItem]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[AddMomItem]
(
@MOM_ID  int,
@ITEM_ID int,
@MOM_Minutes nvarchar(max),
@OwnerShip nvarchar(400),
@Expected_Closure_Date nvarchar(max),
@Actual_Date nvarchar(max),
@Curr_Status nvarchar(200)
)
as
	Begin
			if (@ITEM_ID=0)
				Begin
					insert into ivap_mst_mom_item(MOM_ID,MoM_Minutes,OwnerShip,Expected_Closure_Date,Actual_Date,Curr_Status,Created_on)
						                   values(@MOM_ID,@MOM_Minutes,@OwnerShip,CONVERT(DATETIME,@Expected_Closure_Date , 103),CONVERT(DATETIME,@Actual_Date , 103),@Curr_Status,getdate())	
					SELECT SCOPE_IDENTITY();
				 End
			 else
				 Begin
				      Update ivap_mst_mom_item set MOM_ID=@MOM_ID,MoM_Minutes=@MOM_Minutes,OwnerShip=@OwnerShip,Expected_Closure_Date=CONVERT(DATETIME,@Expected_Closure_Date , 103),
					  Actual_Date=CONVERT(DATETIME,@Actual_Date , 103),Curr_Status=@Curr_Status
					   where Item_ID=@ITEM_ID
					   select 0
				 End

	End
GO
/****** Object:  StoredProcedure [dbo].[AddMomItem0]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[AddMomItem0]
(
@MOM_ID  int,
@ITEM_ID int=0,
@MOM_Minutes nvarchar(max),
@OwnerShip nvarchar(400),
@Expected_Closure_Date nvarchar(max),
@Actual_Date nvarchar(max)=null,
@Curr_Status nvarchar(200),
@closed_Remarks nvarchar(200)=null
)
as
	Begin
	if (@Actual_Date= '')
		Begin
		set @Actual_Date=null
		End
			if (@ITEM_ID=0)
				Begin
					insert into ivap_mst_mom_item(MOM_ID,MoM_Minutes,OwnerShip,Expected_Closure_Date,Actual_Date,Curr_Status,Created_on,Remarks)
						                   values(@MOM_ID,@MOM_Minutes,@OwnerShip,CONVERT(DATETIME,@Expected_Closure_Date , 103),CONVERT(DATETIME,@Actual_Date , 103),@Curr_Status,getdate(),@closed_Remarks)	
					SELECT SCOPE_IDENTITY();
				 End
			 else
				 Begin
				      Update ivap_mst_mom_item set MOM_ID=@MOM_ID,MoM_Minutes=@MOM_Minutes,OwnerShip=@OwnerShip,Expected_Closure_Date=CONVERT(DATETIME,@Expected_Closure_Date , 103),
					  Actual_Date=CONVERT(DATETIME,@Actual_Date , 103),Curr_Status=@Curr_Status,remarks=@closed_Remarks
					   where Item_ID=@ITEM_ID
					   select 0
				 End

	End

GO
/****** Object:  StoredProcedure [dbo].[AddMomItem1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[AddMomItem1]
(
@MOM_ID  int,
@ITEM_ID int=0,
@MOM_Minutes nvarchar(max),
@OwnerShip nvarchar(400),
@Expected_Closure_Date nvarchar(max),
@Actual_Date nvarchar(max)=null,
@Curr_Status nvarchar(200),
@closed_Remarks nvarchar(200)=null,
@System_File_Name nvarchar(200)=null,
@Original_File_Name nvarchar(200)=null
)
as
	Begin
	if (@Actual_Date= '')
		Begin
		set @Actual_Date=null
		End
			if (@ITEM_ID=0)
				Begin
					insert into ivap_mst_mom_item(MOM_ID,MoM_Minutes,OwnerShip,Expected_Closure_Date,Actual_Date,Curr_Status,Created_on,Remarks,System_File_Name,Original_File_Name)
						                   values(@MOM_ID,@MOM_Minutes,@OwnerShip,CONVERT(DATETIME,@Expected_Closure_Date , 103),CONVERT(DATETIME,@Actual_Date , 103),@Curr_Status,getdate(),@closed_Remarks,@System_File_Name,@Original_File_Name)	
					SELECT SCOPE_IDENTITY();
				 End
			 else
				 Begin
				      Update ivap_mst_mom_item set MOM_ID=@MOM_ID,MoM_Minutes=@MOM_Minutes,OwnerShip=@OwnerShip,Expected_Closure_Date=CONVERT(DATETIME,@Expected_Closure_Date , 103),
					  Actual_Date=CONVERT(DATETIME,@Actual_Date , 103),Curr_Status=@Curr_Status,remarks=@closed_Remarks,System_File_Name=@System_File_Name,Original_File_Name=@Original_File_Name
					   where Item_ID=@ITEM_ID
					   select 0
				 End

	End

GO
/****** Object:  StoredProcedure [dbo].[ADDPREVENTIVE]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE PROC [dbo].[ADDPREVENTIVE]  
(  
 @CAPA_ID INT,  
 @PREVENTIVE_ACTION NVARCHAR(MAX)='', 
 @PREVENTIVEACTION_TEXT NVARCHAR(MAX),    
 @PREVENTIVEACTION_OWNER NVARCHAR(MAX),  
 @UID int  
)  
AS  
BEGIN  
   DECLARE @Result int=0   
  
   INSERT INTO IVAP_MST_CAPA_PREVENTIVE(CAPA_ID,PREVENTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY)    
   VALUES(@CAPA_ID,@PREVENTIVE_ACTION,@PREVENTIVEACTION_TEXT,@PREVENTIVEACTION_OWNER,getdate(),@UID)    
    
    SET @Result = SCOPE_IDENTITY()  
  SELECT @Result AS result  
  
END  
  
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateBANK]    Script Date: 03-06-2019 19:23:41 ******/
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
@BANK_ADDR VARCHAR(500)='',      
@BANK_CITY VARCHAR(50),      
@BANK_STATE INT ,      
@BANK_PIN VARCHAR(20)='',      
@BANK_PHONE VARCHAR(100)='',      
 @CREATED_BY INT,      
 @ISACT INT,      
 @ERP_BANK_CODE VARCHAR(20),      
 @PAY_BANK_CODE VARCHAR(20),      
 @IFSC VARCHAR(20)='',     
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
/****** Object:  StoredProcedure [dbo].[AddUpdateCalendar_Setup]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateCalendar_Setup_New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateCalendar_Setup_New]  
(  
 @TID INT,  
 @ENTITY_ID INT,  
 @PAY_DATE DATETIME, 
 @CALENDAR_TYPE INT, 
 @DESCRIPTION VARCHAR(500),
 @DUE_DATE DATETIME, 
 @EVENT VARCHAR(200),
 @ISACTIVE INT,  
 @UID INT  
)  
AS  
BEGIN  
 DECLARE @Result INT =0  
 --IF EXISTS(SELECT * FROM IVAP_CALENDAR_SETUP where ENTITY_ID=@ENTITY_ID AND CALENDAR_NAME=@CALENDAR_NAME AND TID<>@TID)      
 --BEGIN      
 -- SELECT -1      
 -- RETURN      
 --END  
 IF(@TID =0)  
 BEGIN  
  INSERT INTO IVAP_CALENDAR_SETUP(ENTITY_ID,CALENDAR_TYPE,DESCRIPTION,PAY_DATE,DUE_DATE,EVENT,CREATED_ON,CREATED_BY,ISACTIVE)  
   VALUES(@ENTITY_ID,@CALENDAR_TYPE,@DESCRIPTION,@PAY_DATE,@DUE_DATE,@EVENT,GETDATE(),@UID,@ISACTIVE)  
  SET @Result = SCOPE_IDENTITY()  
  Exec Calendar_Setup_His @Result,@UID,'Create'  
 END  
 ELSE  
 BEGIN  
  UPDATE IVAP_CALENDAR_SETUP SET  
   ENTITY_ID =@ENTITY_ID, CALENDAR_TYPE=@CALENDAR_TYPE,DESCRIPTION=@DESCRIPTION,PAY_DATE=@PAY_DATE,DUE_DATE=@DUE_DATE,EVENT=@EVENT,  
   ISACTIVE= @ISACTIVE,UPDATED_ON = GETDATE(),UPDATED_BY =@UID  
  WHERE TID = @TID  
  Exec Calendar_Setup_His @TID,@UID,'Update'  
  SET @Result = 0  
 END  
 SELECT @Result AS result  
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateCalendar_Setup_New_1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateCalendar_Setup_New_1]
(  
 @TID INT,   
 @ENTITY_ID INT,  
 @PAY_DATE DATETIME, 
 @CALENDAR_TYPE INT, 
 @DESCRIPTION VARCHAR(500),
 @DUE_DATE DATETIME, 
 @EVENT VARCHAR(200),
 @File_Type VARCHAR(50),
 @ISACTIVE INT,  
 @UID INT,
 @ActivityCategory VARCHAR(200)=''
)  
AS  
BEGIN  
 DECLARE @Result INT =0  
 --IF EXISTS(SELECT * FROM IVAP_CALENDAR_SETUP where ENTITY_ID=@ENTITY_ID AND CALENDAR_NAME=@CALENDAR_NAME AND TID<>@TID)      
 --BEGIN      
 -- SELECT -1      
 -- RETURN      
 --END  
 IF(@TID =0)  
 BEGIN  
  INSERT INTO IVAP_CALENDAR_SETUP(ENTITY_ID,CALENDAR_TYPE,FILE_TYPE,DESCRIPTION,PAY_DATE,DUE_DATE,EVENT,CREATED_ON,CREATED_BY,ISACTIVE,ActivityCategory)  
   VALUES(@ENTITY_ID,@CALENDAR_TYPE,@File_Type,@DESCRIPTION,@PAY_DATE,@DUE_DATE,@EVENT,GETDATE(),@UID,@ISACTIVE,@ActivityCategory)  
  SET @Result = SCOPE_IDENTITY()  
  Exec Calendar_Setup_His @Result,@UID,'Create'  
 END  
 ELSE  
 BEGIN  
  UPDATE IVAP_CALENDAR_SETUP SET  
   ENTITY_ID =@ENTITY_ID, CALENDAR_TYPE=@CALENDAR_TYPE,FILE_TYPE=@File_Type,DESCRIPTION=@DESCRIPTION,PAY_DATE=@PAY_DATE,DUE_DATE=@DUE_DATE,EVENT=@EVENT,  
   ISACTIVE= @ISACTIVE,UPDATED_ON = GETDATE(),UPDATED_BY =@UID,ActivityCategory = @ActivityCategory
  WHERE TID = @TID  
  Exec Calendar_Setup_His @TID,@UID,'Update'  
  SET @Result = 0  
 END  
 SELECT @Result AS result  
END

GO
/****** Object:  StoredProcedure [dbo].[ADDUPDATECAPA]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROC [dbo].[ADDUPDATECAPA]            
(            
 @TID int=0,       
 @ENTITY_ID INT,         
 @UID INT,              
 @ISSUE NVARCHAR(MAX),              
 @ISSUE_DESCRIPTION NVARCHAR(MAX),              
 @CUSTOMER_IMPACT NVARCHAR(MAX),              
 @SEQUENCE_OF_EVENT NVARCHAR(MAX),              
 @COMMUNICATION_PROCESS NVARCHAR(MAX),              
 @ROOT_CAUSE NVARCHAR(MAX),  
 @CATEGORY NVARCHAR(100),  
 @FINANCE_TYPE NVARCHAR(50),  
 @FINANCE_AMOUNT NVARCHAR(100)='0',  
 @IMPACT_VALUE NVARCHAR(100)='',  
 @STAGE NVARCHAR(100),  
 @INCIDENT_DATE NVARCHAR(100)=''  
            
)            
            
AS            
BEGIN            
 DECLARE @Result int=0            
 if(@TID=0)          
 begin             
  INSERT INTO IVAP_MST_CAPA(ENTITY_ID,ISSUE,ISSUE_DESCRIPTION,CUSTOMER_IMPACT,SEQUENCE_OF_EVENT,COMMUNICATION_PROCESS,ROOT_CAUSE,CREATED_ON,CREATED_BY,CATEGORY,FINANCE_TYPE,FINANCE_AMOUNT,IMPACT_VALUE,STAGE,INCIDENT_DATE)              
  VALUES(@ENTITY_ID,@ISSUE,@ISSUE_DESCRIPTION,@CUSTOMER_IMPACT,@SEQUENCE_OF_EVENT,@COMMUNICATION_PROCESS,@ROOT_CAUSE,GETDATE(),@UID,@CATEGORY,@FINANCE_TYPE,@FINANCE_AMOUNT,@IMPACT_VALUE,@STAGE,@INCIDENT_DATE)              
  SET @Result = SCOPE_IDENTITY()          
  EXEC Capa_History  @Result,@UID,'CREATE'         
  end            
 else          
  begin          
  UPDATE IVAP_MST_CAPA SET ISSUE=@ISSUE,ISSUE_DESCRIPTION=@ISSUE_DESCRIPTION,CUSTOMER_IMPACT=@CUSTOMER_IMPACT,SEQUENCE_OF_EVENT=@SEQUENCE_OF_EVENT,  
  CATEGORY=@CATEGORY,FINANCE_TYPE=@FINANCE_TYPE,FINANCE_AMOUNT=@FINANCE_AMOUNT,IMPACT_VALUE=@IMPACT_VALUE,STAGE=@STAGE,INCIDENT_DATE=@INCIDENT_DATE,          
  COMMUNICATION_PROCESS=@COMMUNICATION_PROCESS,ROOT_CAUSE=@ROOT_CAUSE,UPDATE_ON=GETDATE(),UPDATED_BY=@UID WHERE TID=@TID AND  ENTITY_ID=@ENTITY_ID       
  EXEC Capa_History  @TID,@UID,'UPDATE'          
 end          
          
  SELECT @Result AS result               
END 
GO
/****** Object:  StoredProcedure [dbo].[ADDUPDATECAPA_CONVERSASTION]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE proc [dbo].[ADDUPDATECAPA_CONVERSASTION]  
(  
@TID INT=0,  
@CAPAID INT=0,  
@ITEM_ID INT=0,  
@ITEM_NAME NVARCHAR(200)='',  
@REMARK NVARCHAR(MAX)='',  
@ATTACHMENT NVARCHAR(MAX)='',  
@SYSTEM_ATTACHMENT nvarchar(max)='',  
@STATUS NVARCHAR(40)='',  
@CLOSURE_DATE nvarchar(50)='',  
@UID INT=0  
)  
AS  
BEGIN  
DECLARE @Result int=0    
DECLARE @statusCapa nvarchar(20)         
  if(@TID=0)      
  begin      
   INSERT INTO IVAP_MST_CAPA_CONVERSATION(CAPAID,ITEM_ID,ITEM_NAME,REMARK,ATTACHMENT,STATUS,CLOSURE_DATE,CREATED_ON,CREATED_BY,SYSTEM_ATTACHMENT)          
   VALUES(@CAPAID,@ITEM_ID,@ITEM_NAME,@REMARK,@ATTACHMENT,@STATUS,@CLOSURE_DATE,getdate(),@UID,@SYSTEM_ATTACHMENT)          
   SET @Result = SCOPE_IDENTITY()       
     
   end      
   else      
   begin  
  update IVAP_MST_CAPA_CONVERSATION set REMARK=@REMARK,STATUS=@STATUS,SYSTEM_ATTACHMENT=@SYSTEM_ATTACHMENT,    
  ATTACHMENT=@ATTACHMENT,CLOSURE_DATE=@CLOSURE_DATE,UPDATE_ON=getdate(),UPDATED_BY=@UID where TID=@TID  
  end   
    
  if(@ITEM_NAME='Corrective')  
  begin  
       select top 1 @statusCapa=(STATUS) from IVAP_MST_CAPA_CONVERSATION where ITEM_ID=@ITEM_ID and ITEM_NAME='Corrective' order by TID desc  
  
  if(@statusCapa='Closed')  
  begin  
  Update  IVAP_MST_CAPA_CORRECTIVE set STATUS='CLOSED' where TID=@ITEM_ID  
  end  
  else  
  begin  
  Update  IVAP_MST_CAPA_CORRECTIVE set STATUS='OPEN' where TID=@ITEM_ID  
  end  
    
  end  
  
     if(@ITEM_NAME='Preventive')  
   begin  
      select top 1 @statusCapa=(STATUS) from IVAP_MST_CAPA_CONVERSATION where ITEM_ID=@ITEM_ID and ITEM_NAME='Preventive' order by TID desc  
  
  if(@statusCapa='Closed')  
  begin  
  Update  IVAP_MST_CAPA_PREVENTIVE set STATUS='CLOSED' where TID=@ITEM_ID  
  end  
  else  
  begin  
  Update  IVAP_MST_CAPA_PREVENTIVE set STATUS='OPEN' where TID=@ITEM_ID  
  end  
    
  end  
    
          
 SELECT @Result AS result          
        
  
END
GO
/****** Object:  StoredProcedure [dbo].[ADDUPDATECAPA_NEW]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ADDUPDATECAPA_NEW]
(  
 @TID INT,  
 @UID INT,  
 @ISSUE NVARCHAR(MAX),  
 @ISSUE_DESCRIPTION NVARCHAR(MAX),  
 @CUSTOMER_IMPACT NVARCHAR(MAX),  
 @SEQUENCE_OF_EVENT NVARCHAR(MAX),  
 @COMMUNICATION_PROCESS NVARCHAR(MAX),  
 @ROOT_CAUSE NVARCHAR(MAX),  
 @CORRECTIVE_ACTION NVARCHAR(MAX)='',  
 @PREVENTIVE_ACTION NVARCHAR(MAX)='',  
 @ACTION_TEXT NVARCHAR(MAX),  
 @ACTION_OWNER NVARCHAR(MAX),  
 @PREVENTIVE_TID INT,  
 @CORRECTIVE_TID INT  
)  
AS  
BEGIN  
DECLARE @Result int=0     
  
 if(@TID=0)                      
  begin    
  INSERT INTO IVAP_MST_CAPA(ISSUE,ISSUE_DESCRIPTION,CUSTOMER_IMPACT,SEQUENCE_OF_EVENT,COMMUNICATION_PROCESS,ROOT_CAUSE,CREATED_ON,CREATED_BY)  
  VALUES(@ISSUE,@ISSUE_DESCRIPTION,@CUSTOMER_IMPACT,@SEQUENCE_OF_EVENT,@COMMUNICATION_PROCESS,@ROOT_CAUSE,GETDATE(),@UID)  
  
  SET @Result = SCOPE_IDENTITY()   
  
  IF(@CORRECTIVE_ACTION='')  
  BEGIN  
   INSERT INTO IVAP_MST_CAPA_PREVENTIVE(CAPA_ID,PREVENTIVE_ACTION,ACTION_TEXT,ACTION_OWNER)  
   VALUES(@Result,@PREVENTIVE_ACTION,@ACTION_TEXT,@ACTION_OWNER)  
  
  END  
  ELSE  
  BEGIN  
   INSERT INTO IVAP_MST_CAPA_CORRECTIVE(CAPA_ID,CORRECTIVE_ACTION,ACTION_TEXT,ACTION_OWNER)  
   VALUES(@Result,@CORRECTIVE_ACTION,@ACTION_TEXT,@ACTION_OWNER)  
  END  
  
END  
ELSE  
BEGIN  
 UPDATE IVAP_MST_CAPA SET ISSUE=@ISSUE,ISSUE_DESCRIPTION=@ISSUE_DESCRIPTION,CUSTOMER_IMPACT=@CUSTOMER_IMPACT,SEQUENCE_OF_EVENT=@SEQUENCE_OF_EVENT,  
 COMMUNICATION_PROCESS=@COMMUNICATION_PROCESS,ROOT_CAUSE=@ROOT_CAUSE,UPDATE_ON=GETDATE(),UPDATED_BY=@UID WHERE TID=@TID  
 IF(@CORRECTIVE_ACTION='')  
 BEGIN  
 UPDATE IVAP_MST_CAPA_PREVENTIVE SET PREVENTIVE_ACTION=@PREVENTIVE_ACTION,ACTION_TEXT=@ACTION_TEXT,ACTION_OWNER=@ACTION_OWNER WHERE TID=@PREVENTIVE_TID  
 END  
 ELSE  
 BEGIN  
 UPDATE IVAP_MST_CAPA_CORRECTIVE SET CORRECTIVE_ACTION=@CORRECTIVE_ACTION,ACTION_TEXT=@ACTION_TEXT,ACTION_OWNER=@ACTION_OWNER WHERE TID=@CORRECTIVE_TID  
  
 END  
  
END  
SELECT @Result AS result      
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateChangeLabel]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateClass]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateCompany]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateCompany]      
(      
 @COMPID INT,      
 @EID INT,      
 @COMP_CODE VARCHAR(20),      
 @COMP_NAME VARCHAR(200),      
 @COMP_ADDR1 VARCHAR(500),      
 @COMP_ADDR2 VARCHAR(500)='',      
 @COMP_CITY VARCHAR(50),      
 @COMP_STATE INT,      
 @COMP_PIN VARCHAR(10),      
 @COMP_CLASS INT,      
 @COMP_PANNO VARCHAR(10),      
 @COMP_TANNO VARCHAR(20),      
 @COMP_TDSCIRCLE VARCHAR(50),      
 @SIGN_FNAME VARCHAR(200)='',      
 @SIGN_LNAME VARCHAR(200)='',      
 @SIGN_FATHER_NAME VARCHAR(50)='',      
 @SIGN_ADDR1 VARCHAR(500)='',      
 @SIGN_ADDR2 VARCHAR(500)='',      
 @SIGN_CITY VARCHAR(200)='',      
 @SIGN_DSG VARCHAR(50)='',      
 @SIGN_STATE INT,      
 @SIGN_PIN VARCHAR(10)='',      
 @SIGN_PLACE VARCHAR(50)='',      
 @SIGN_DATE DATE=null,      
 @RETIRE_AGE INT,      
 @EMP_CODE_GEN INT,      
 @EMP_CODE_PREFIX VARCHAR(10),      
 @EMP_CODE_LEN INT,      
 @Comp_Logo VARCHAR(200)='',      
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
/****** Object:  StoredProcedure [dbo].[AddUpdateComponent]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateComponent2612]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateComponent2612New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     
CREATE PROC [dbo].[AddUpdateComponent2612New]  
(  
 @ComponentID INT,  
 @COMPONENT_FILE_TYPE VARCHAR(20),  
 @COMPONENT_TYPE VARCHAR(20),  
 @COMPONENT_SUB_TYPE VARCHAR(20),  
@COMPONENT_NAME VARCHAR(100),  
@COMPONENT_DATATYPE VARCHAR(20),  
@COMPONENT_DISPLAY_NAME VARCHAR(100) ,  
@COMPONENT_DESCRIPTION VARCHAR(200),  
@Component_TableName VARCHAR(50)='' ,  
@Component_FieldName VARCHAR(50)='',  
@MIN_LENGTH int =0,  
@MAX_LENGTH int =0,  
@MANDATORY int,  
 @CREATED_BY INT,  
 @ISACT INT,  
 @EXTRA_INPUT_VALIDATION varchar(200)='',  
 @EXTRA_RG_EXPRESSION varchar(200)=''  
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
 IF Exists(SELECT * FROM IVAP_MST_COMPONENT WHERE COMPONENT_NAME = @COMPONENT_NAME and TID <> @ComponentID )  
 BEGIN  
  SET @result = -1  
  SELECT @result as result  
  RETURN;  
 END  
 IF Exists(SELECT * FROM IVAP_MST_COMPONENT WHERE UPPER(COMPONENT_DISPLAY_NAME) = UPPER(@COMPONENT_DISPLAY_NAME) and TID <> @ComponentID )  
 BEGIN  
  SET @result = -4  
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
  COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,MIN_LENGTH,MAX_LENGTH,MANDATORY,CREATED_ON,CREATED_BY,ISACTIVE,EXTRA_INPUT_VALIDATION,EXTRA_RG_EXPRESSION)  
  VALUES(@COMPONENT_FILE_TYPE,@COMPONENT_TYPE,@COMPONENT_SUB_TYPE,@COMPONENT_NAME,@COMPONENT_DATATYPE,@COMPONENT_DISPLAY_NAME,@COMPONENT_DESCRIPTION,  
  @Component_TableName,@Component_FieldName,@MIN_LENGTH,@MAX_LENGTH,@MANDATORY,GETDATE(),@CREATED_BY,@ISACT,@EXTRA_INPUT_VALIDATION,@EXTRA_RG_EXPRESSION)  
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
  ISACTIVE=@ISACT,EXTRA_INPUT_VALIDATION=@EXTRA_INPUT_VALIDATION,EXTRA_RG_EXPRESSION=@EXTRA_RG_EXPRESSION  
   WHERE TID = @ComponentID  
   SET @result =0  
   EXEC Component_History @ComponentID,@CREATED_BY,'Update'  
 END  
 SELECT @result AS result  
END  
  
            
    
GO
/****** Object:  StoredProcedure [dbo].[ADDUPDATECORRECTIVE]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROC [dbo].[ADDUPDATECORRECTIVE]      
(      
 @CAPA_UPDATE int=0,    
 @CAPA_ID INT,      
 @CORRECTIVE_ACTION NVARCHAR(MAX)='',       
 @CORRECTIVEACTION_TEXT NVARCHAR(MAX),        
 @CORRECTIVEACTION_OWNER NVARCHAR(MAX),
 @Owner_Email nvarchar(max),      
 @UID int      
)      
AS      
BEGIN      
 DECLARE @Result int=0         
  if(@CAPA_UPDATE=0)    
  begin    
   INSERT INTO IVAP_MST_CAPA_CORRECTIVE(CAPA_ID,CORRECTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY,Owner_Email)        
   VALUES(@CAPA_ID,@CORRECTIVE_ACTION,@CORRECTIVEACTION_TEXT,@CORRECTIVEACTION_OWNER,getdate(),@UID,@Owner_Email)        
   SET @Result = SCOPE_IDENTITY()     
   EXEC CORRECTIVE_HISTORY @Result,@UID,'CREATE'  
   end    
   else    
   begin    
       
  update IVAP_MST_CAPA_CORRECTIVE set CORRECTIVE_ACTION=@CORRECTIVE_ACTION,ACTION_TEXT=@CORRECTIVEACTION_TEXT,Owner_Email=@Owner_Email,  
  ACTION_OWNER=@CORRECTIVEACTION_OWNER,UPDATE_ON=getdate(),UPDATED_BY=@UID where TID=@CAPA_UPDATE  
    
   EXEC CORRECTIVE_HISTORY @CAPA_UPDATE,@UID,'UPDATE'  
    --INSERT INTO IVAP_MST_CAPA_CORRECTIVE(CAPA_ID,CORRECTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY)        
    --VALUES(@CAPA_ID,@CORRECTIVE_ACTION,@CORRECTIVEACTION_TEXT,@CORRECTIVEACTION_OWNER,getdate(),@UID)        
   end       
  SELECT @Result AS result        
      
END 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateCostCentre]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--select * from IVAP_MST_COSTCENTRE    
CREATE PROC [dbo].[AddUpdateCostCentre]    
(    
 @CostCenterID INT,    
 @ENTITYID INT,    
 @PAY_COST_CODE VARCHAR(10),    
 @ERP_COST_CODE VARCHAR(10),    
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
/****** Object:  StoredProcedure [dbo].[AddUpdateCurrency]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[ADDUPDATEDATAACCESS]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateDepartment]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateDepartment]    
(    
 @DEPTID INT,    
 @ENTITYID INT,    
 @PAY_DEPT_CODE VARCHAR(10),    
 @ERP_DEPT_CODE VARCHAR(10),    
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
/****** Object:  StoredProcedure [dbo].[AddUpdateDesignation]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateDesignation]      
(      
 @DesigID INT,      
 @ENTITY_ID INT,      
 @PAY_DSG_CODE VARCHAR(10),      
 @ERP_DSG_CODE VARCHAR(10),      
 @DSG_NAME VARCHAR(2000),      
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
/****** Object:  StoredProcedure [dbo].[AddUpdateDivision]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   
--select * from IVAP_MST_DIVISION        
CREATE PROC [dbo].[AddUpdateDivision]        
(        
 @DiviID INT,        
 @ENTITY_ID INT,        
 @PAY_DIVI_CODE VARCHAR(10),        
 @ERP_DIVI_CODE VARCHAR(10),        
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
/****** Object:  StoredProcedure [dbo].[AddUpdateEntityComponent]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateEntityComponent1202]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddUpdateEntityComponent1202]
(
@EntityCompID INT,
@Globle_Component_ID int=0,
@ENTITY_ID INT,
@COMPONENT_DISPLAY_NAME VARCHAR(20)='' ,
@COMPONENT_FILE_TYPE VARCHAR(20),
@COMPONENT_TYPE VARCHAR(20),
@COMPONENT_SUB_TYPE VARCHAR(20),
@COMPONENT_NAME VARCHAR(20),
@COMPONENT_DATATYPE VARCHAR(20),
@COMPONENT_DESCRIPTION VARCHAR(20),
@Component_TableName VARCHAR(50)='' ,
@Component_FieldName VARCHAR(50)='',
@MIN_LENGTH int =0,
@MAX_LENGTH int =0,
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
		COMPONENT_FILE_TYPE=@COMPONENT_FILE_TYPE,COMPONENT_TYPE=@COMPONENT_TYPE,COMPONENT_SUB_TYPE=@COMPONENT_SUB_TYPE,COMPONENT_NAME=@COMPONENT_NAME,COMPONENT_DATATYPE=@COMPONENT_DATATYPE,
		COMPONENT_TABLE_NAME=@Component_TableName,COMPONENT_COLUMN_NAME=@Component_FieldName
		,COMPONENT_DESCRIPTION=@COMPONENT_DESCRIPTION,MIN_LENGTH=@MIN_LENGTH,
		MAX_LENGTH=@MAX_LENGTH ,
		COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,
		MANDATORY=@MANDATORY,
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
/****** Object:  StoredProcedure [dbo].[AddUpdateEntityComponent1217]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateEntityComponentNEW]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateEntityComponentNEW]
(
@EntityCompID INT,
@Globle_Component_ID int=0,
@ENTITY_ID INT,
@COMPONENT_DISPLAY_NAME VARCHAR(100)='' ,
@COMPONENT_DATATYPE VARCHAR(20)='',
@Component_TableName VARCHAR(50)='' ,
@Component_FieldName VARCHAR(50)='',
@MIN_LENGTH int =0,
@MAX_LENGTH int =0,
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
	IF Exists(SELECT * FROM IVAP_MST_COMPONENT_ENTITY WHERE UPPER(COMPONENT_DISPLAY_NAME) = UPPER(@COMPONENT_DISPLAY_NAME) and ENTITY_ID=@ENTITY_ID and TID <> @EntityCompID )
	BEGIN
		SET @result = -4
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
		COMPONENT_DATATYPE=@COMPONENT_DATATYPE,
		COMPONENT_TABLE_NAME=@Component_TableName,COMPONENT_COLUMN_NAME=@Component_FieldName
		,MIN_LENGTH=@MIN_LENGTH,
		MAX_LENGTH=@MAX_LENGTH ,
		COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,
		MANDATORY=@MANDATORY,
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
/****** Object:  StoredProcedure [dbo].[AddUpdateEntityComponentNEW20]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddUpdateEntityComponentNEW20]  
(  
@EntityCompID INT,  
@Globle_Component_ID int=0,  
@ENTITY_ID INT,  
@COMPONENT_DISPLAY_NAME VARCHAR(100)='' ,  
@COMPONENT_DATATYPE VARCHAR(20)='',  
@Component_TableName VARCHAR(50)='' ,  
@Component_FieldName VARCHAR(50)='',  
@MIN_LENGTH int =0,  
@MAX_LENGTH int =0,  
@MANDATORY int,  
@CREATED_BY INT,  
@ISACT INT,  
@GL_CODE VARCHAR(100)='',  
@PMS_CODE VARCHAR(200)='',  
@EXTRA_INPUT_VALIDATION varchar(200)='',  
@EXTRA_RG_EXPRESSION varchar(200)=''  
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
 IF Exists(SELECT * FROM IVAP_MST_COMPONENT_ENTITY WHERE UPPER(COMPONENT_DISPLAY_NAME) = UPPER(@COMPONENT_DISPLAY_NAME) and ENTITY_ID=@ENTITY_ID and TID <> @EntityCompID )  
 BEGIN  
  SET @result = -4  
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
  COMPONENT_DATATYPE=@COMPONENT_DATATYPE,  
  COMPONENT_TABLE_NAME=@Component_TableName,COMPONENT_COLUMN_NAME=@Component_FieldName  
  ,MIN_LENGTH=@MIN_LENGTH,  
  MAX_LENGTH=@MAX_LENGTH ,  
  COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,  
  MANDATORY=@MANDATORY,  
  UPDATED_BY=@CREATED_BY,  
  UPDATE_ON=GETDATE(),  
  GL_Code=@GL_CODE,  
  PMS_CODE=@PMS_CODE,  
  ISACTIVE=@ISACT,  
  EXTRA_INPUT_VALIDATION=@EXTRA_INPUT_VALIDATION,  
  EXTRA_RG_EXPRESSION=@EXTRA_RG_EXPRESSION  
   WHERE TID = @EntityCompID  
   SET @result =0  
   EXEC CREATE_ComponentEntity_History @EntityCompID,@CREATED_BY,'Update'  
 END  
 SELECT @result AS result  
END  
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateFileCompDetail]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateFileCompDetail_12_FEB]    Script Date: 03-06-2019 19:23:41 ******/
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
  EXEC FILE_COMPONENT_HISTORY @result,@UID,'CREATE'   
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
/****** Object:  StoredProcedure [dbo].[AddUpdateFileType]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  
  
  
  
  CREATE PROC [dbo].[AddUpdateFileType]        
(          
 @FileID INT=0,          
 @ENTITY_ID INT,          
 @FILE_TYPE VARCHAR(20),          
 @FILE_NAME VARCHAR(50),          
 @FILE_DESC VARCHAR(500)=null,          
 --@DUE_DATE DATE,          
 @ISACTIVE INT,          
 @UID INT,          
 @CATEGORY nvarchar(200),      
 @Transpose BIT=0    
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
  INSERT INTO IVAP_MST_FILETYPE(ENTITY_ID,FILE_TYPE,FILE_NAME,FILE_DESC,CREATED_BY,ISACTIVE,CATEGORY,Transpose)          
   VALUES(@ENTITY_ID,@FILE_TYPE,@FILE_NAME,@FILE_DESC,@UID,@ISACTIVE,@CATEGORY,@Transpose)          
  SET @Result = SCOPE_IDENTITY()        
  EXEC FILETYPE_HISTORY  @Result,@UID,'CREATE'       
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_FILETYPE',@Result           
  SET @ComponentID = (select TID from IVAP_MST_COMPONENT_ENTITY where ENTITY_ID=@ENTITY_ID AND COMPONENT_NAME='EMP_CODE')          
          
  --INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order)          
  -- VALUES(@Result,@ComponentID,@UID,1)          
  DECLARE @COMP_RESULT INT=0      
      
  INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,    
  COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,    COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE)        
   select @Result,@ComponentID,@UID,1,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,    
   COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,1   
   ,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE from IVAP_MST_COMPONENT_ENTITY where IVAP_MST_COMPONENT_ENTITY.TID=@ComponentID      
  SET @COMP_RESULT=SCOPE_IDENTITY()       
  EXEC FILE_COMPONENT_HISTORY @COMP_RESULT,@UID,'CREATE'       
      
  SET @ComponentID = (select TID from IVAP_MST_COMPONENT_ENTITY where ENTITY_ID=@ENTITY_ID AND COMPONENT_NAME='PAYDATE')      
      
  INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,    
  COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,    
  COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE)        
   select @Result,@ComponentID,@UID,1,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME ,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,1    
, HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE from IVAP_MST_COMPONENT_ENTITY where IVAP_MST_COMPONENT_ENTITY.TID=@ComponentID      
  SET @COMP_RESULT=SCOPE_IDENTITY()       
  EXEC FILE_COMPONENT_HISTORY @COMP_RESULT,@UID,'CREATE'       
 END          
 ELSE          
 BEGIN          
  UPDATE IVAP_MST_FILETYPE           
  SET ENTITY_ID=@ENTITY_ID,FILE_TYPE=@FILE_TYPE,FILE_NAME=@FILE_NAME,FILE_DESC=@FILE_DESC,UPDATED_ON = GETDATE(),UPDATED_BY = @UID,
  CATEGORY=@CATEGORY,Transpose=@Transpose         
  WHERE TID = @FileID       
  EXEC FILETYPE_HISTORY  @FileID,@UID,'UPDATE'          
  SET @Result = 0          
 END          
 SELECT @Result AS result          
END      
  
  
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateFileType_1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
    
  CREATE PROC [dbo].[AddUpdateFileType_1]            
(            
 @FileID INT=0,            
 @ENTITY_ID INT,            
 @FILE_TYPE VARCHAR(20),            
 @FILE_NAME VARCHAR(50),            
 @FILE_DESC VARCHAR(500)=null,            
 --@DUE_DATE DATE,            
 @ISACTIVE INT,            
 @UID INT,            
 @CATEGORY nvarchar(200),        
 @Transpose BIT=0,  
 @PayRollInputFile int=0       
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
  INSERT INTO IVAP_MST_FILETYPE(ENTITY_ID,FILE_TYPE,FILE_NAME,FILE_DESC,CREATED_BY,ISACTIVE,CATEGORY,Transpose,Payroll_Input_File)            
   VALUES(@ENTITY_ID,@FILE_TYPE,@FILE_NAME,@FILE_DESC,@UID,@ISACTIVE,@CATEGORY,@Transpose,@PayRollInputFile)            
  SET @Result = SCOPE_IDENTITY()          
  EXEC FILETYPE_HISTORY  @Result,@UID,'CREATE'         
  EXEC DATA_ACCESSCONTROL_INSERT @UID,'IVAP_MST_FILETYPE',@Result             
  SET @ComponentID = (select TID from IVAP_MST_COMPONENT_ENTITY where ENTITY_ID=@ENTITY_ID AND COMPONENT_NAME='EMP_CODE')            
            
  --INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order)            
  -- VALUES(@Result,@ComponentID,@UID,1)            
  DECLARE @COMP_RESULT INT=0        
        
  INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,      
  COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,    COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE)          
   select @Result,@ComponentID,@UID,1,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,      
   COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,1     
   ,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE from IVAP_MST_COMPONENT_ENTITY where IVAP_MST_COMPONENT_ENTITY.TID=@ComponentID        
  SET @COMP_RESULT=SCOPE_IDENTITY()         
  EXEC FILE_COMPONENT_HISTORY @COMP_RESULT,@UID,'CREATE'         
        
  SET @ComponentID = (select TID from IVAP_MST_COMPONENT_ENTITY where ENTITY_ID=@ENTITY_ID AND COMPONENT_NAME='PAYDATE')        
        
  INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,      
  COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,      
  COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE)          
   select @Result,@ComponentID,@UID,1,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME ,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,1      
, HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE from IVAP_MST_COMPONENT_ENTITY where IVAP_MST_COMPONENT_ENTITY.TID=@ComponentID        
  SET @COMP_RESULT=SCOPE_IDENTITY()         
  EXEC FILE_COMPONENT_HISTORY @COMP_RESULT,@UID,'CREATE'         
 END            
 ELSE            
 BEGIN            
  UPDATE IVAP_MST_FILETYPE             
  SET ENTITY_ID=@ENTITY_ID,FILE_TYPE=@FILE_TYPE,FILE_NAME=@FILE_NAME,FILE_DESC=@FILE_DESC,UPDATED_ON = GETDATE(),UPDATED_BY = @UID,  
  CATEGORY=@CATEGORY,Transpose=@Transpose,Payroll_Input_File=@PayRollInputFile           
  WHERE TID = @FileID         
  EXEC FILETYPE_HISTORY  @FileID,@UID,'UPDATE'            
  SET @Result = 0            
 END            
 SELECT @Result AS result            
END        
    
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateFunction]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[ADDUPDATEGLOBALLOCATION]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateGrade]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateLeavingReason]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateLevel]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateLocation]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateLwf]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateMetaData]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateMetaData]
(
	@FileMetaID int =0,
	@EID int,
	@Description varchar(max)='',
	@MetaData varchar(max)='',
	@FileTypeName varchar(max),
	@CreatedBy int  =1
)
AS
BEGIN
	DECLARE @result INT =0
	DECLARE @ActivityName VARCHAR(200)=''
	if(@FileMetaID =0)
		begin
				INSERT INTO Ivap_Mst_FileMetaData(EID,[Description],MetaData,FileTypeName,CreatedBy,CreatedOn)
				VALUES(@EID,@Description,@MetaData,@FileTypeName,@CreatedBy,getdate())
				SET @result = SCOPE_IDENTITY()
				SELECT @result AS result
				--execute Activity_History @activityid ,@uid,'Create'	
		end
	else 
		begin
			update Ivap_Mst_FileMetaData set EID=@EID,[Description]=@Description,MetaData=@MetaData,FileTypeName=@FileTypeName --,CreatedBy,CreatedOn
					where FileMetaID =@FileMetaID
				--	execute Activity_History @activityid ,@uid,'Update'	
			SET @result =0
			SELECT @result as result
			
		end	
END
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateMinWage]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateMinWage]  
(  
 @MinWageID INT,  
 @STATE_ID INT,  
 @CATEGORY VARCHAR(100),  
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
/****** Object:  StoredProcedure [dbo].[AddUpdateMOM]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddUpdateMOM]      
(
 @TID int
,@ENTITY_ID int
,@MEETING_HELD datetime
,@MEETING_ATTENDEES NVARCHAR(200)
,@ADDRESS nvarchar(max)
,@AGENDA nvarchar(max)
,@DISCUSS_POINTS nvarchar(max)
,@RESPONSIBILITY_HOLDER nvarchar(max)
,@STATUS nvarchar(200)
,@CREATED_BY int
,@CURR_USER int
,@CURR_STATUS nvarchar(max)
,@ISACTIVE char(1)
)      
AS      
BEGIN      
 DECLARE @result INT =0      
 IF Exists(SELECT * FROM IVAP_MST_MOM WHERE AGENDA = @AGENDA and ENTITY_ID=@ENTITY_ID AND TID <> @TID )      
 BEGIN      
  SET @result = -1      
  SELECT @result as result      
  RETURN;      
 END      
       
 IF(@TID =0)      
 BEGIN      
  INSERT INTO IVAP_MST_MOM(ENTITY_ID,MEETING_HELD,MEETING_ATTENDEES,ADDRESS,AGENDA,DISCUSS_POINTS,RESPONSIBILITY_HOLDER,STATUS,CREATED_ON,CREATED_BY,CURR_USER,CURR_STATUS,ISACTIVE)      
  VALUES(@ENTITY_ID,@MEETING_HELD,@MEETING_ATTENDEES,@ADDRESS,@AGENDA,@DISCUSS_POINTS,@RESPONSIBILITY_HOLDER,@STATUS,getdate(),@CREATED_BY,@CURR_USER,@CURR_STATUS,@ISACTIVE)      
  SET @result = SCOPE_IDENTITY();     
  EXEC DATA_ACCESSCONTROL_INSERT @CREATED_BY,'IVAP_MST_MOM',@result   
  --EXEC Bank_History @result,@CREATED_BY,'Create'      
 END      
 ELSE      
 BEGIN      
  UPDATE IVAP_MST_MOM SET      
  ENTITY_ID=@ENTITY_ID,MEETING_HELD=@MEETING_HELD,MEETING_ATTENDEES=@MEETING_ATTENDEES,ADDRESS=@ADDRESS,
  AGENDA=@AGENDA,DISCUSS_POINTS=@DISCUSS_POINTS,RESPONSIBILITY_HOLDER=@RESPONSIBILITY_HOLDER,STATUS=@STATUS,
  LASTUPDATE=GETDATE(),CURR_USER=@CURR_USER,CURR_STATUS=@CURR_STATUS,ISACTIVE=@ISACTIVE
   WHERE TID = @TID      
   SET @result =0      
   --EXEC Bank_History @BANKID,@CREATED_BY,'Update'      
 END      
 SELECT @result AS result      
END 
GO
/****** Object:  StoredProcedure [dbo].[AddUpdatePLant]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[ADDUPDATEPREVENTIVE]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[ADDUPDATEPREVENTIVE]        
(        
 @CAPA_UPDATE int=0,     
 @CAPA_ID INT,        
 @PREVENTIVE_ACTION NVARCHAR(MAX)='',       
 @PREVENTIVEACTION_TEXT NVARCHAR(MAX),          
 @PREVENTIVEACTION_OWNER NVARCHAR(MAX), 
 @Owner_Email nvarchar(max),        
 @UID int        
)        
AS        
BEGIN        
   DECLARE @Result int=0         
     if(@CAPA_UPDATE=0)    
  begin    
   INSERT INTO IVAP_MST_CAPA_PREVENTIVE(CAPA_ID,PREVENTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY,Owner_Email)          
   VALUES(@CAPA_ID,@PREVENTIVE_ACTION,@PREVENTIVEACTION_TEXT,@PREVENTIVEACTION_OWNER,getdate(),@UID,@Owner_Email)          
          
    SET @Result = SCOPE_IDENTITY()     
 EXEC PREVENTIVE_HISTORY @Result,@UID,'CREATE'  
 end    
 else    
 begin    
    update IVAP_MST_CAPA_PREVENTIVE set PREVENTIVE_ACTION=@PREVENTIVE_ACTION,ACTION_TEXT=@PREVENTIVEACTION_TEXT,Owner_Email=@Owner_Email,  
 ACTION_OWNER=@PREVENTIVEACTION_OWNER,UPDATE_ON=getdate(),UPDATED_BY=@UID where TID=@CAPA_UPDATE  
  
 EXEC PREVENTIVE_HISTORY @CAPA_UPDATE,@UID,'UPDATE'  
 --INSERT INTO IVAP_MST_CAPA_PREVENTIVE(CAPA_ID,PREVENTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY)          
 --  VALUES(@CAPA_ID,@PREVENTIVE_ACTION,@PREVENTIVEACTION_TEXT,@PREVENTIVEACTION_OWNER,getdate(),@UID)          
          
 end       
  SELECT @Result AS result        
        
END 


GO
/****** Object:  StoredProcedure [dbo].[AddUpdateProcess]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdatePTAX]    Script Date: 03-06-2019 19:23:41 ******/
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
@GENDER VARCHAR(10),  
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
 -- SET @result = -1  
 -- SELECT @result as result  
 -- RETURN;  
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
/****** Object:  StoredProcedure [dbo].[AddUpdateRegion]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
--select * from IVAP_MST_REGION      
CREATE PROC [dbo].[AddUpdateRegion]      
(      
 @RegionID INT,      
 @ENTITY_ID INT,      
 @PAY_REGION_CODE VARCHAR(10),      
 @ERP_REGION_CODE VARCHAR(10),      
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
/****** Object:  StoredProcedure [dbo].[AddUpdateRole]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateSection]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROC [dbo].[AddUpdateSection]    
(    
 @SECTID INT,    
 @ENTITYID INT,    
 @PAY_SECTION_CODE VARCHAR(10),    
 @ERP_SECTION_CODE VARCHAR(10),    
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
/****** Object:  StoredProcedure [dbo].[AddUpdateSpecialComponent]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
CREATE proc [dbo].[AddUpdateSpecialComponent]  
(  
 @TID int,  
 @FileID int,  
 @Special_Field_Type nvarchar(50),  
 @Display_Name nvarchar(50),  
 @Default_Value nvarchar(50)='',  
 @LookUp_Field_Value nvarchar(50)='',  
 @UID int  
)  
as  
begin  
 DECLARE @result INT =0      
 DECLARE @ExistResult INT =0     
    
  if exists(select * from IVAP_MST_FILE_COMP_DETAIL where FILE_ID=@FileID AND UPPER(COMPONENT_DISPLAY_NAME)=UPPER(@Display_Name) and TID <> @TID)                        
 BEGIN        
  SET @result = -1        
  SELECT @result as result        
  RETURN;        
 END        
   
 if(@TID=0)  
  begin    
  DECLARE @display_order INT =0    
   select @display_order=max(Display_Order) from IVAP_MST_FILE_COMP_DETAIL where FILE_ID=@FileID  
  if(@Special_Field_Type='DEFAULT VALUED')  
  begin  
   insert into IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,ISACTIVE,Display_Order,COMPONENT_DISPLAY_NAME,Spl_Field_Type,Spl_Field_Value)  
   values(@FileID,00,@UID,1,@display_order+1,@Display_Name,@Special_Field_Type,@Default_Value)  
   SET @result = SCOPE_IDENTITY()  
  end  
   if(@Special_Field_Type='LOOKUP VALUED')  
   begin  
    INSERT INTO IVAP_MST_FILE_COMP_DETAIL(FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE,Spl_Field_Type)        
    select @FileID,@LookUp_Field_Value,@UID,@display_order+1,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,@Display_Name,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE,@Special_Field_Type from IVAP_MST_COMPONENT_ENTITY where IVAP_MST_COMPONENT_ENTITY.TID=@LookUp_Field_Value    
    SET @result = SCOPE_IDENTITY()     
  end  
 end  
 else  
 begin  
   if(@Special_Field_Type='DEFAULT VALUED')  
  begin  
   update IVAP_MST_FILE_COMP_DETAIL set FILE_ID=@FileID,CREATED_BY=@UID,  
   ISACTIVE=1,COMPONENT_DISPLAY_NAME=@Display_Name,Spl_Field_Type=@Special_Field_Type,  
   Spl_Field_Value=@Default_Value where TID=@TID  
    
  end  
   if(@Special_Field_Type='LOOKUP VALUED')  
   begin  
    update IVAP_MST_FILE_COMP_DETAIL set FILE_ID=@FileID,COMPONENT_ID=@LookUp_Field_Value,CREATED_BY=@UID,  
    COMPONENT_DISPLAY_NAME=@Display_Name,Spl_Field_Type=@Special_Field_Type,  
   Spl_Field_Value=@Default_Value where TID=@TID  
  end  
 end  
  
  SELECT @result as result   
end






GO
/****** Object:  StoredProcedure [dbo].[AddUpdateState]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateSubFunction]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateTranspose]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
  CREATE proc [dbo].[AddUpdateTranspose]    
  (    
 @TID int,                        
 @ENTITY_ID INT,                        
 @File_Id int,                    
 @Field_Type VARCHAR(100),                         
 @Component_Name VARCHAR(200)='',                          
 @Display_Name VARCHAR(200) ,                   
 @Display_Order INT,    
 @Default_Value varchar(20),    
 @UID int,    
 @IsActive bit     
  )    
  as    
  begin    
  DECLARE @result int=0      
  if(@TID=0)    
  begin    
  insert into Ivap_Transpose_Setting (Entity_ID,File_Id,Field_Type,Component_Name,Display_Name,Display_Order,Default_Value,Created_By,Created_On,IsActive)    
  values(@ENTITY_ID,@File_Id,@Field_Type,@Component_Name,@Display_Name,@Display_Order,@Default_Value,@UID,getdate(),@IsActive)    
  SET @result = SCOPE_IDENTITY()                      
      
  end    
  else    
  begin    
  Update Ivap_Transpose_Setting set Field_Type=@Field_Type,Display_Name=@Display_Name,Display_Order=@Display_Order,Default_Value=@Default_Value,Modified_By=@UID,    
  Modified_On=getdate(),IsActive=@IsActive,Component_Name=@Component_Name where Tid=@TID    
  SET @result =0;    
  end    
   select @result as result     
  end
GO
/****** Object:  StoredProcedure [dbo].[AddUpdateType]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateTypes]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AddUpdateUser]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROC [dbo].[AddUpdateUser]  
(  
 @UID INT,  
 @ENITYTID INT,  
 @USERID VARCHAR(200),  
 @USER_FIRSTNAME VARCHAR(50),  
 @USER_LASTNAME VARCHAR(50)='',  
 @USER_EMAIL VARCHAR(100),  
 @USER_ROLE INT,  
 @USER_MOBILENO VARCHAR(20),  
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
/****** Object:  StoredProcedure [dbo].[AddUpdateUser_1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROC [dbo].[AddUpdateUser_1]    
(    
 @UID INT,    
 @ENITYTID INT,    
 @USERID VARCHAR(200),    
 @USER_FIRSTNAME VARCHAR(50),    
 @USER_LASTNAME VARCHAR(50)='',    
 @USER_EMAIL VARCHAR(100),    
 @USER_ROLE INT,    
 @USER_MOBILENO VARCHAR(20),    
 @PassToken VARCHAR(2000),    
 @CreatedBy INT,
 @ISACTIVE int     
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
  VALUES(@ENITYTID,@USERID,@USER_FIRSTNAME,@USER_LASTNAME,@USER_EMAIL,@USER_ROLE,@USER_MOBILENO,0,@ISACTIVE,@CreatedBy)    
  SET @result = SCOPE_IDENTITY()    
  insert into IVAP_MST_Passlink (UID,KeyType,RandomKey) values (@result,'New User',@PassToken);    
  EXEC User_History @result,@CreatedBy,'Create';    
 END    
 ELSE    
 BEGIN    
  UPDATE IVAP_MST_USER     
  SET ENTITY_ID=@ENITYTID,USERID=@USERID,USER_FIRSTNAME=@USER_FIRSTNAME,USER_LASTNAME=@USER_LASTNAME,USER_EMAIL=@USER_EMAIL,USER_ROLE=@USER_ROLE,    
   USER_MOBILENO=@USER_MOBILENO,UPDATED_BY=@CreatedBy,UPDATED_ON=GETDATE(),ISACT=@ISACTIVE    
  WHERE UID = @UID    
  EXEC User_History @UID,@CreatedBy,'Update';    
  SET @result = 0    
 END    
 SELECT @result AS Result    
END  

GO
/****** Object:  StoredProcedure [dbo].[AddUpdateUserProfile]    Script Date: 03-06-2019 19:23:41 ******/
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
@p_USER_PROFILEPIC varchar(max)=null,  
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
/****** Object:  StoredProcedure [dbo].[AddUpdateWorkFlowSetting]    Script Date: 03-06-2019 19:23:41 ******/
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
		INSERT INTO IVAP_MST_WorkFlowSetting(ENTITY_ID,FILE_ID,USER_ROLE,ORDERING,CREATED_ON,CREATED_BY,ISACTIVE)
		VALUES(@ENTITY_ID,@FILE_ID,@USER_ROLE,@ORDERING,GETDATE(),@CREATED_BY,1)
		SET @result = SCOPE_IDENTITY();
	  EXEC Workflowsetting_History @result,@CREATED_BY,'Create'
	END
	if(@Cout >0 and @ISChek=1)
	BEGIN
		UPDATE IVAP_MST_WorkFlowSetting SET
		ENTITY_ID=@ENTITY_ID,FILE_ID=@FILE_ID,USER_ROLE=@USER_ROLE,ORDERING=@ORDERING,
		UPDATED_BY=@CREATED_BY,
		UPDATED_ON=GETDATE(),
		ISACTIVE=1
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
/****** Object:  StoredProcedure [dbo].[ApprovalTempTableData]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[ApprovedTempTableData]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AuthenticateUser]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[AuthenticateUser_EID]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AuthenticateUser_EID]  
(  
    @Userid NVARCHAR(100)='ALCLADMN',  
 @DomainName VARCHAR(20)='Alcott'  
)  
AS  
begin  
  DECLARE   @PasstryMinutes float  
  DECLARE   @InvalidPassTryCount int  
  DECLARE   @EID INT  
  SET @EID=(select top 1 TID from Ivap_Mst_Entity WHERE Domain_Name= @DomainName AND ISACTIVE=1)  
  SELECT  @PasstryMinutes=datediff(minute,LAST_PASSWORD_TRY_DATE,getdate()) ,  
  @InvalidPassTryCount=isnull(PASSWORD_TRY,0) FROM IVap_MST_USER WHERE Userid=@Userid AND Isact=1 AND ENTITY_ID=@EID;  
  
  IF(@InvalidPassTryCount > 5 AND @PasstryMinutes > 30)  
    UPDATE IVap_MST_USER SET Password_try = 0,LAST_PASSWORD_TRY_DATE = getdate() WHERE Userid =@Userid AND Isact=1 AND ENTITY_ID=@EID;   
    
  select U.UID,U.USERID,password,U.USER_FIRSTNAME,U.USER_LASTNAME,U.USER_EMAIL,ENTITY_ID,  
  Isauth,U.PROFILE_PIC AS PROFILEPIC,U.USER_MOBILENO,'' As LastLogin,  
  R.Rolename AS Rolename, U.User_Role,isnull(Password_Try,0) AS Passwordtry,  
   Datediff(Day,u.Password_Last_Updated,getdate()) AS PassChangeDayCount FROM IVap_MST_USER U  
  inner join IVap_MST_USERROLE R on R.TID=U.USER_ROLE  
  WHERE U.Userid=@Userid AND U.Isact=1 AND ENTITY_ID=@EID;  
  
  UPDATE IVap_MST_USER  
  SET PASSWORD_TRY     =isnull(PASSWORD_TRY,0)+1,LAST_PASSWORD_TRY_DATE=getdate()  
  WHERE upper( Userid)= upper(@Userid) AND ENTITY_ID=@EID;  
  
  select DEFAULT_MONTH,YEAR,MONTH from IVAP_MONTH_CLOSE where ENTITY_ID=@EID AND Default_Month=1;  
END 
GO
/****** Object:  StoredProcedure [dbo].[BANK_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[Calendar_Setup_His]    Script Date: 03-06-2019 19:23:41 ******/
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
	INSERT INTO IVAP_HIS_Calendar_setup(CALENDARID,ENTITY_ID,CALENDAR_TYPE,FILE_TYPE,DESCRIPTION,PAY_DATE,DUE_DATE,REMAINDER_DAYS,EVENT,FREQUENCY,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,ACTION,ActivityCategory)
		SELECT TID,ENTITY_ID,CALENDAR_TYPE,FILE_TYPE,DESCRIPTION,PAY_DATE,DUE_DATE,REMAINDER_DAYS,EVENT,FREQUENCY,CREATED_ON,CREATED_BY,GETDATE(),@Updated_BY,ISACTIVE,@Action,ActivityCategory
		 FROM ivap_Calendar_setup WHERE TID =@TID
END
GO
/****** Object:  StoredProcedure [dbo].[Capa_History]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Capa_History]
(
@CID INT,       
@UpdatedBy INT,        
@Action VARCHAR(100) 
)
as
begin
insert  into IVAP_HIS_CAPA(CID,ISSUE,ISSUE_DESCRIPTION,CUSTOMER_IMPACT,SEQUENCE_OF_EVENT,COMMUNICATION_PROCESS,ROOT_CAUSE,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ACTION)
SELECT TID,ISSUE,ISSUE_DESCRIPTION,CUSTOMER_IMPACT,SEQUENCE_OF_EVENT,COMMUNICATION_PROCESS,ROOT_CAUSE,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,@Action   FROM IVAP_MST_CAPA WHERE TID=@CID

end
GO
/****** Object:  StoredProcedure [dbo].[ChangeMenuStatus]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[ChangePassword]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CheckHRDEMP]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CheckHRDEMP]
(
@EID int,
@EMP_Code nvarchar(max)
)
As
    declare @sqlQuery varchar(Max)=''
	Begin
			set @sqlQuery=' if exists(select * from Ivap_HRD_HIS_'+ Cast(@EID as Varchar)+' where EMP_CODE='''+@EMP_Code+''') begin 	select 1 end else select 0 '
			EXECUTE(@sqlQuery);
	End  
GO
/****** Object:  StoredProcedure [dbo].[CheckHRDEMP_1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CheckHRDEMP_1]
(
@EID int,
@EMP_Code nvarchar(max)
)
As
    declare @sqlQuery varchar(Max)=''
	Begin
			set @sqlQuery=' if exists(select * from Ivap_TEMP_HIS_'+ Cast(@EID as Varchar)+' where EMP_CODE='''+@EMP_Code+''') begin 	select 1 end else select 0 '
			EXECUTE(@sqlQuery);
	End  
GO
/****** Object:  StoredProcedure [dbo].[CheckHRDEMP_2]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[CheckHRDEMP_2]
(
@EID int,
@EMP_Code nvarchar(max),
@File_ID int
)
As
    declare @sqlQuery varchar(Max)=''
	Begin
			set @sqlQuery=' if exists(select * from Ivap_TEMP_HIS_'+ Cast(@EID as Varchar)+' where EMP_CODE='''+@EMP_Code+''' and File_ID='+Cast(@File_ID as Varchar)+') begin 	select 1 end else select 0 '
			EXECUTE(@sqlQuery);
	End 
GO
/****** Object:  StoredProcedure [dbo].[CheckHRMasterUser]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CheckHRMasterUser]
(
@EID int,
@EMP_Code nvarchar(max)
)
As
    declare @sqlQuery varchar(Max)=''
	Begin
			set @sqlQuery=' if exists(select * from Ivap_HRD_MAST_'+ Cast(@EID as Varchar)+' with(nolock) where EMP_CODE='''+@EMP_Code+''') begin 	select 1 end else select 0 '
			EXECUTE(@sqlQuery);
	End 


GO
/****** Object:  StoredProcedure [dbo].[CheckMataMasterCount]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CheckPAYEMP]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[CheckPAYEMP]
(
@EID int,
@EMP_Code nvarchar(max)
)
As	
	declare @sqlQuery varchar(Max)='';
	Begin
		Set @sqlQuery='if exists(select * from Ivap_pay_HIS_'+ Cast(@EID as Varchar)+' where PAY_EMP_CODE='''+@EMP_Code+''' and CONVERT(varchar,PAYDATE,103) in (select Convert(varchar,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),103))) begin 	select 1 end else select 0 '
		EXECUTE(@sqlQuery);
	End
GO
/****** Object:  StoredProcedure [dbo].[CheckPayMasterForMonth]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[CheckPayMasterForMonth]
(
@EID int,
@EMP_Code nvarchar(max),
@PayDate nvarchar(max)
)
As
    declare @sqlQuery varchar(Max)=''
	Begin
		set @sqlQuery=' if exists(select * from Ivap_PAY_MAST_'+ Cast(@EID as Varchar)+' with(nolock) where PAY_EMP_CODE='''+@EMP_Code+''' and cast(PayDate as date)=cast(''' + @PayDate + ''' as date) ) begin 	select 1 end else select 0 '
		print @sqlQuery
			EXECUTE(@sqlQuery);
	End 

GO
/****** Object:  StoredProcedure [dbo].[CheckPublistStatus]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CLASS_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CLASS_HISTORY]    
(    
@CID INT,     
@UpdatedBy INT,      
@Action VARCHAR(100)                
)    
AS    
BEGIN    
INSERT INTO IVAP_HIS_CLASS(CID,ENTITY_ID,PAY_CLASS_CODE,ERP_CLASS_CODE,CLASS_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION)    
SELECT TID,ENTITY_ID,PAY_CLASS_CODE,ERP_CLASS_CODE,CLASS_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_CLASS where TID=@CID   
END  
GO
/****** Object:  StoredProcedure [dbo].[Company_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[Component_History]    Script Date: 03-06-2019 19:23:41 ******/
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
		ACTION,
		EXTRA_INPUT_VALIDATION,
		EXTRA_RG_EXPRESSION
		)
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
		@Action,
		EXTRA_INPUT_VALIDATION,
		EXTRA_RG_EXPRESSION
		FROM IVAP_MST_COMPONENT
		WHERE TID =@ComponentID
END

GO
/****** Object:  StoredProcedure [dbo].[COPYRIGHTTOANOTHERUSER]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CORRECTIVE_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CORRECTIVE_HISTORY]
(
@CID INT,       
@UpdatedBy INT,        
@Action VARCHAR(100) 
)
as
begin
INSERT INTO IVAP_HIS_CAPA_CORRECTIVE(CID,CAPA_ID,CORRECTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ACTION)
SELECT TID,CAPA_ID,CORRECTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,@Action FROM IVAP_MST_CAPA_CORRECTIVE WHERE TID=@CID
END
GO
/****** Object:  StoredProcedure [dbo].[CostCentre_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CREATE_ComponentEntity_History]    Script Date: 03-06-2019 19:23:41 ******/
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
,MAX_LENGTH,MANDATORY,ISACTIVE,UPDATE_ON,CREATED_BY,ACTION,EXTRA_INPUT_VALIDATION,EXTRA_RG_EXPRESSION)
	select TID,Globle_Component_ID,ENTITY_ID,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH
,MAX_LENGTH,MANDATORY,ISACTIVE,GETDATE(),@CREATED_BY,@Action,EXTRA_INPUT_VALIDATION,EXTRA_RG_EXPRESSION  from
	 IVAP_MST_COMPONENT_ENTITY where tid =@CompEntityID
END
ELSE
		BEGIN
		INSERT INTO IVAP_HIS_COMPONENT_ENTITY(CompEntityID,Globle_Component_ID,ENTITY_ID,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,
		COMPONENT_DISPLAY_NAME,MIN_LENGTH,MAX_LENGTH,MANDATORY,ISACTIVE,CREATED_ON,CREATED_BY,ACTION,EXTRA_INPUT_VALIDATION,EXTRA_RG_EXPRESSION)
	select TID,Globle_Component_ID,ENTITY_ID,COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,MIN_LENGTH
,MAX_LENGTH,MANDATORY,ISACTIVE,GETDATE(),@CREATED_BY,@Action,EXTRA_INPUT_VALIDATION,EXTRA_RG_EXPRESSION  from
	 IVAP_MST_COMPONENT_ENTITY where tid =@CompEntityID
		END
END

GO
/****** Object:  StoredProcedure [dbo].[CREATE_FUNCTION_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CREATE_GRAD_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CREATE_PTAX_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CreateEntity]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[CreateEntity_1]    Script Date: 03-06-2019 19:23:41 ******/
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
	@Services_Availed varchar(200)
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
GO
/****** Object:  StoredProcedure [dbo].[CreateNewFolder]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CreateNewFolder]
(
	@EID INT,
	@FileID INT,
	@ParrentID INT,
	@OriginalName NVARCHAR(500),
	@SystemGenPath NVARCHAR(MAX),
	@UID INT
)
AS
BEGIN
	IF(@FileID =0)
		SET @ParrentID = 0 --ISNULL((SELECT FileID FROM Ecom_Mst_Files WHERE CustomerID =@CustomerID AND PID =0 AND FileType ='Folder'),0)
	ELSE
		SET @ParrentID = @FileID
	INSERT INTO IVAP_Mst_Files(EID,FileType,FileOriginalName,FileSystemGeneratedName,PID,CreatedBy)
		VALUES(@EID,'Folder',@OriginalName,@SystemGenPath,@ParrentID,@UID)
	SET @FileID = SCOPE_IDENTITY()
	SELECT @FileID
	--SELECT FileID,CustomerID,FileType,FileOriginalName,FileSystemGeneratedName,PID FROM Ecom_Mst_Files WHERE FileID =@FileID
END
GO
/****** Object:  StoredProcedure [dbo].[CURRENCY_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
SELECT TID,CURRENCY_CODE,CURRENCY_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_CURRENCY  where TID=@CID
END
GO
/****** Object:  StoredProcedure [dbo].[DATA_ACCESSCONTROL_INSERT]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteCalendarSetup]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteCorrective]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE proc [dbo].[DeleteCorrective]  
(  
 @TID int=0  
)  
as  
begin  
DECLARE @Result int=1  
 Delete from IVAP_MST_CAPA_CORRECTIVE where TID=@TID  
 SELECT @Result AS result    
    
end
GO
/****** Object:  StoredProcedure [dbo].[DeleteEntityComponent]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[DeleteEntityComponent](@EntityCompID int =0,@EntityID int =0)
as
begin
if exists(select COMPONENT_ID from IVAP_MST_FILE_COMP_DETAIL fil LEFT join  IVAP_MST_FILETYPE TY ON fil.FILE_ID=TY.TID where COMPONENT_ID=@EntityCompID AND fil.ENTITY_ID=@EntityID)
begin
select -1
return
end
DELETE FROM IVAP_MST_COMPONENT_ENTITY WHERE TID=@EntityCompID and ENTITY_ID=@EntityID
SELECT 2
end


GO
/****** Object:  StoredProcedure [dbo].[DeleteFileCompDtl]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteFileType]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFileType](@FileID INT,@EID INT)  
AS  
BEGIN  
EXEC FILETYPE_HISTORY  @FileID,28,'DELETE'  
 DELETE FROM IVAP_MST_FILETYPE WHERE TID =@FileID AND ENTITY_ID =@EID
    EXEC FILE_COMPONENT_HISTORY @FileID,28,'DELETE'
 DELETE FROM IVAP_MST_FILE_COMP_DETAIL WHERE FILE_ID =@FileID  
 
 SELECT @FileID as result;  
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFolder]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteFolder]
(
	@FileID INT,
	@UID INT
)
AS
BEGIN
	IF(EXISTS(SELECT * FROM IVAP_Mst_Files WHERE FileID =@FileID AND CreatedBy =@UID))
	BEGIN
		UPDATE IVAP_Mst_Files SET IsActive =0 WHERE FileID =@FileID
		UPDATE IVAP_Mst_Files SET IsActive =0 WHERE PID =@FileID
		SELECT @FileID
	END
	ELSE
		SELECT -1
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteGlobalComponent]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[DeleteMomItem]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[DeleteMomItem]
(
@ITEM_ID int
)
As
	Begin
			delete from ivap_mst_mom_item where item_id=@ITEM_ID 
			select 1
	End
GO
/****** Object:  StoredProcedure [dbo].[DeletePreventive]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DeletePreventive]  
(  
 @TID int=0  
)  
as  
begin  
DECLARE @Result int=1   
 Delete from IVAP_MST_CAPA_PREVENTIVE where TID=@TID  
 SELECT @Result AS result     
end
GO
/****** Object:  StoredProcedure [dbo].[DeleteTempTableData]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[DeleteTempTableData](@File_ID int ,@Effe_Date varchar(100)='',@Pay_Date varchar(100)='' ,@TableName varchar(100),@UserID int =0)
as
begin
DECLARE @SqlQuery NVARCHAR(500)  ;
   DECLARE @ParmDefinition nvarchar(Max); 
   declare @Result int ;
   set  @Result=0
--select * from Ivap_MAST_TEMP_15 where FILE_ID=@File_ID and TEMP_BATCH_ID=@Batch_TempID
if(@Effe_Date!='' and @Pay_Date!='')
begin
set @SqlQuery= 'delete from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and EFFDATE='''+convert(varchar(15),@Effe_Date)+''' and PAYDATE='''+convert(varchar(15),@Pay_Date)+'''
                  and CREATED_BY='+convert(varchar(10),@UserID) +''
end
else if(@Effe_Date!='')
begin
set @SqlQuery= 'delete from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and EFFDATE='''+convert(varchar(15),@Effe_Date)+'''
                and CREATED_BY='+convert(varchar(10),@UserID) +''
end
else if(@Pay_Date!='')
begin
set @SqlQuery= 'delete from ' +@TableName+ ' where FILE_ID='+convert(varchar(10),@File_ID) +' and PAYDATE='''+convert(varchar(15),@Pay_Date)+'''
                  and CREATED_BY='+convert(varchar(10),@UserID) +''
end
else 
begin
set @SqlQuery= 'delete from ' +@TableName+ ' where and CREATED_BY='+convert(varchar(10),@UserID) +' AND  FILE_ID='+convert(varchar(10),@File_ID) 
end
--select @Result
--print  @SqlQuery 
 SET @ParmDefinition = N'@File_ID int,@Effe_Date varchar(100),@Pay_Date varchar(100),@TableName varchar(100)'; 
 EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@Effe_Date,@Pay_Date,@TableName
set  @Result=@@ROWCOUNT
select @Result
end
GO
/****** Object:  StoredProcedure [dbo].[Department_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[Designation_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[DIVISION_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[DOWNLOAD_FILE_COMPONENT]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DOWNLOAD_FILE_COMPONENT]   
(  
@FILEID INT  
)  
AS  
  
BEGIN  
  
SELECT ISNULL(COMPONENT_DISPLAY_NAME,'') AS COMPONENT_DISPLAY_NAME,ISNULL(COMPONENT_COLUMN_NAME,'') AS COMPONENT_COLUMN_NAME,ISNULL(EXTRA_INPUT_VALIDATION,'') AS EXTRA_INPUT_VALIDATION,  
ISNULL(EXTRA_RG_EXPRESSION,'') AS EXTRA_RG_EXPRESSION,ISNULL(GL_Code,'') AS GL_Code,ISNULL(PMS_CODE,'') AS PMS_CODE,  
ISNULL(MIN_LENGTH,'') AS MIN_LENGTH,ISNULL(MAX_LENGTH,'') AS MAX_LENGTH,CASE WHEN MANDATORY=1 THEN 'YES' ELSE 'NO' END AS MANDATORY,  
CASE WHEN ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END AS ISACTIVE  FROM IVAP_MST_FILE_COMP_DETAIL WHERE FILE_ID=@FILEID  
END
GO
/****** Object:  StoredProcedure [dbo].[ExecuteQuery]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[ExecuteQuery]
(
@qry varchar(Max)
)
as
	Begin
			Execute(@qry);
	End		
GO
/****** Object:  StoredProcedure [dbo].[FILE_COMPONENT_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[FILE_COMPONENT_HISTORY]    
 (    
  @CID INT,         
  @UpdatedBy INT,          
  @Action VARCHAR(100)     
 )    
 as    
 begin    
    INSERT INTO IVAP_HIS_FILE_COMP_DETAIL(FID,FILE_ID,COMPONENT_ID,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE,ACTION,EXTRA_INPUT_VALIDATION,EXTRA_RG_EXPRESSION)    
    
 SELECT TID,FILE_ID,COMPONENT_ID,CREATED_ON,CREATED_BY,getdate(),@UpdatedBy,ISACTIVE,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE,@Action,EXTRA_INPUT_VALIDATION,EXTRA_RG_EXPRESSION FROM IVAP_MST_FILE_COMP_DETAIL Where TID=@CID   
 end
GO
/****** Object:  StoredProcedure [dbo].[FILETYPE_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[FILETYPE_HISTORY]    
(    
 @CID INT,         
 @UpdatedBy INT,          
 @Action VARCHAR(100)     
)    
AS    
BEGIN    
 INSERT INTO IVAP_HIS_FILETYPE(FID,ENTITY_ID,FILE_TYPE,FILE_NAME,FILE_DESC,DUE_DATE,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,Img_Icon,FILE_CATEGORY,CATEGORY,ACTION,Transpose,Payroll_Input_File)    
  SELECT TID,ENTITY_ID,FILE_TYPE,FILE_NAME,FILE_DESC,DUE_DATE,CREATED_ON,CREATED_BY,Getdate(),@UpdatedBy,ISACTIVE,Img_Icon,FILE_CATEGORY,CATEGORY,@Action,Transpose,Payroll_Input_File FROM IVAP_MST_FILETYPE  where TID=@CID  
END
GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_CATEGORY]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_FILE_CATEGORY](@TID int)
AS
BEGIN
SELECT * FROM IVAP_MST_FILE_CATEGORY order by CATEGORY
END
GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_SETUP_Input_Report]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_FILE_SETUP_Input_Report]    
(    
	 @EID INT,    
	 @FILE_ID INT  
)    
AS    
BEGIN    
		 select E.COMPONENT_FILE_TYPE,f.FILE_NAME,dtl.EXTRA_INPUT_VALIDATION,dtl.EXTRA_RG_EXPRESSION,
		 E.COMPONENT_TYPE,E.COMPONENT_SUB_TYPE,E.COMPONENT_NAME,E.COMPONENT_DATATYPE,Dtl.COMPONENT_DISPLAY_NAME ,Dtl.MANDATORY,E.ISACTIVE ,GCo.COMPONENT_TABLE_NAME,GCo.COMPONENT_COLUMN_NAME,Dtl.MIN_LENGTH,	Dtl.MAX_LENGTH,F.Transpose,
		 Dtl.Spl_Field_Type,Dtl.Spl_Field_Value
		 from IVAP_MST_FILE_COMP_DETAIL Dtl left join IVAP_MST_COMPONENT_ENTITY E   ON dtl.COMPONENT_ID =E.TID
		 INNER join IVAP_MST_COMPONENT GCo on e.Globle_Component_ID=GCo.TID 
		 INNER join IVAP_MST_FILETYPE F ON Dtl.FILE_ID=F.TID
		 where Dtl.ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID ORDER BY dtl.Display_Order  
		 --AND TID IN (SELECT COMPONENT_ID FROM IVAP_MST_FILE_COMP_DETAIL WHERE FIle_ID =@FILE_ID)    
END


GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_SETUP_SAMPLE]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_FILE_SETUP_SAMPLE] 
(    
 @EID INT=15,    
 @FILE_ID INT =97 
)    
AS    
BEGIN  

 select Dtl.COMPONENT_DISPLAY_NAME,Dtl.TID from IVAP_MST_COMPONENT_ENTITY E  
 INNER JOIN IVAP_MST_FILE_COMP_DETAIL Dtl ON E.TID = dtl.COMPONENT_ID  
 where E.ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID ORDER BY dtl.Display_Order  
 
END
GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_SETUP_SAMPLE_23_FEB]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GET_FILE_SETUP_SAMPLE_23_FEB]    
(        
 @EID INT=15,        
 @FILE_ID INT =97     
)        
AS        
BEGIN      
    
 select Dtl.COMPONENT_DISPLAY_NAME,Dtl.TID,E.TID,E.MAX_LENGTH,E.MIN_LENGTH,E.COMPONENT_DATATYPE,  
 CASE WHEN E.MANDATORY=1 THEN 'YES' ELSE 'NO' END AS MANDATORY,IME.DATE_FORMAT  from IVAP_MST_COMPONENT_ENTITY E      
 INNER JOIN IVAP_MST_FILE_COMP_DETAIL Dtl ON E.TID = dtl.COMPONENT_ID 
  inner join IVAP_MST_ENTITY IME on  @EID=IME.TID      
 where E.ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID ORDER BY dtl.Display_Order      
     
END
GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_SETUP_SAMPLE_28_FEB]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_FILE_SETUP_SAMPLE_28_FEB]    
(        
 @EID INT=15,        
 @FILE_ID INT =97     
)        
AS        
BEGIN      
    
 select IME.DATE_FORMAT,Dtl.COMPONENT_DISPLAY_NAME,Dtl.TID,E.TID,E.MAX_LENGTH,E.MIN_LENGTH,E.COMPONENT_DATATYPE,  
 CASE WHEN E.MANDATORY=1 THEN 'YES' ELSE 'NO' END AS MANDATORY  from IVAP_MST_COMPONENT_ENTITY E      
 INNER JOIN IVAP_MST_FILE_COMP_DETAIL Dtl ON E.TID = dtl.COMPONENT_ID 
 inner join IVAP_MST_ENTITY IME on  @EID=IME.TID    
 where E.ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID ORDER BY dtl.Display_Order      
     
END
GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_SETUP_UPLOAD]    Script Date: 03-06-2019 19:23:41 ******/
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
		 select E.COMPONENT_FILE_TYPE,f.FILE_NAME,dtl.EXTRA_INPUT_VALIDATION,dtl.EXTRA_RG_EXPRESSION,
		 E.COMPONENT_TYPE,E.COMPONENT_SUB_TYPE,E.COMPONENT_NAME,E.COMPONENT_DATATYPE,Dtl.COMPONENT_DISPLAY_NAME,Dtl.MANDATORY,E.ISACTIVE ,GCo.COMPONENT_TABLE_NAME,GCo.COMPONENT_COLUMN_NAME,Dtl.MIN_LENGTH,	Dtl.MAX_LENGTH,F.Transpose
		 from IVAP_MST_COMPONENT_ENTITY E  INNER JOIN IVAP_MST_FILE_COMP_DETAIL Dtl ON E.TID = dtl.COMPONENT_ID 
		 inner join IVAP_MST_COMPONENT GCo on e.Globle_Component_ID=GCo.TID 
		 inner join IVAP_MST_FILETYPE F ON Dtl.FILE_ID=F.TID
		 where Dtl.ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID ORDER BY dtl.Display_Order  
		 --AND TID IN (SELECT COMPONENT_ID FROM IVAP_MST_FILE_COMP_DETAIL WHERE FIle_ID =@FILE_ID)    
END
GO
/****** Object:  StoredProcedure [dbo].[GET_FILE_SETUP_UPLOAD_Transpose]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GET_FILE_SETUP_UPLOAD_Transpose]      
(      
  @EID INT,      
  @FILE_ID INT    
)      
AS      
BEGIN      
   select E.COMPONENT_FILE_TYPE,f.FILE_NAME,dtl.EXTRA_INPUT_VALIDATION,dtl.EXTRA_RG_EXPRESSION,  
   E.COMPONENT_TYPE,E.COMPONENT_SUB_TYPE,E.COMPONENT_NAME,E.COMPONENT_DATATYPE,Dtl.COMPONENT_DISPLAY_NAME,Dtl.MANDATORY,E.ISACTIVE ,GCo.COMPONENT_TABLE_NAME,GCo.COMPONENT_COLUMN_NAME,Dtl.MIN_LENGTH, Dtl.MAX_LENGTH,F.Transpose  
   from IVAP_MST_COMPONENT_ENTITY E  INNER JOIN IVAP_MST_FILE_COMP_DETAIL Dtl ON E.TID = dtl.COMPONENT_ID   
   inner join IVAP_MST_COMPONENT GCo on e.Globle_Component_ID=GCo.TID   
   inner join IVAP_MST_FILETYPE F ON Dtl.FILE_ID=F.TID  
   where Dtl.ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID  and E.COMPONENT_NAME not in(select Component_Name from Ivap_Transpose_Setting where File_Id=@FILE_ID and Entity_ID=@EID and Field_Type='COMPONENT') ORDER BY dtl.Display_Order    
   
END 
GO
/****** Object:  StoredProcedure [dbo].[GET_FILETYPE_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[GET_FILETYPE_HISTORY]
  (
  @FID int
  )
  as
  Begin

  select A.FILE_NAME,B.FILE_NAME as PayRollFileName,A.FILE_TYPE,A.FILE_DESC,A.CATEGORY,A.ACTION,convert(varchar, A.UPDATED_ON, 103) as UPDATED_ON,A.Transpose,A.ISACTIVE,case when A.ISACTIVE=1 then 'Active' else 'InActive' end as STATUS
   from IVAP_HIS_FILETYPE A left join IVAP_HIS_FILETYPE B on B.TID=A.Payroll_Input_File where A.FID=@FID
   
  end
GO
/****** Object:  StoredProcedure [dbo].[GET_Validation]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GET_Validation]
(@TID int)
as
begin

select * from IVAP_MST_EXTRA_VALIDATION_TYPE
end
GO
/****** Object:  StoredProcedure [dbo].[GET_ValidationNew]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GET_ValidationNew]
(@TID int,@Validation_Field varchar(100)='')
as
begin
if(isnull(@Validation_Field,'')='')
begin
select * from IVAP_MST_EXTRA_VALIDATION_TYPE
end
if(isnull(@Validation_Field,'')!='')
begin
select * from IVAP_MST_EXTRA_VALIDATION_TYPE where VALIDATION_FIELD=@Validation_Field
end
end
GO
/****** Object:  StoredProcedure [dbo].[GetAcessRoleForFileExplorer]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAcessRoleForFileExplorer]
(
	@EID INT=27,
	@FileID INT=1
)
AS
BEGIN
	SELECT U.UID,U.USERID,UR.ROLENAME,@FileID FileID,0 IsView,0 IsALL
	 FROM IVAP_MST_USER U
	 INNER JOIN IVAP_MST_USERROLE UR ON U.USER_ROLE = UR.TID
	WHERE ENTITY_ID =@EID AND UPPER(UR.ROLENAME) <> 'CLIENT ADMIN'
	SELECT FileID,ISNULL(UserRights,'') UserRights FROM Ivap_Mst_Files WHERE FileID =@FileID AND EID=@EID
END 



--select * from IVAP_Mst_FileExporer_Access_Role
--select * from Ivap_Mst_Files
--INSERT INTO IVAP_Mst_FileExporer_Access_Role(EID,UID,FileID,[View],[Add],[Delete],CreatedBy)
	--VALUES(27,52,1,1,1,1,1)
GO
/****** Object:  StoredProcedure [dbo].[GetAllChildFile]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllChildFile]
(
	@EID INT=27,
	@FileID INT =0
)
AS
BEGIN
	IF(@FileID !=0)
	BEGIN
		--;with HierarchyCTE (FileID,CustomerID,FileType,FileOriginalName,FileSystemGeneratedName,PID) as

		--   (select FileID,CustomerID,FileType,FileOriginalName,FileSystemGeneratedName,PID

		--   from dbo.Ecom_Mst_Files

		--   where FileID = @FileID AND IsActive =1

		--   union all

		--   select E.FileID,E.CustomerID,E.FileType,E.FileOriginalName,E.FileSystemGeneratedName,E.PID 

		--   from dbo.Ecom_Mst_Files E

		--   inner join hierarchycte

		--	  on E.PID = hierarchycte.FileID WHERE E.IsActive =1)

		--select *

		--from hierarchycte WHERE FileID <> @FileID

		select FileID id,EID,FileType,FileOriginalName,FileSystemGeneratedName,PID,FileExtention,

		CASE WHEN EXISTS (SELECT * FROM IVAP_Mst_Files WHERE PID = F.FileID AND IsActive=1) THEN 1 ELSE 0 END hasChildren,ISNULL(UserRights,'') UserRights

		 from IVAP_Mst_Files F WHERE PID =@FileID AND EID=@EID AND IsActive=1 ORDER BY F.CreatedOn
	END
	ELSE
	BEGIN
		--SELECT FileID,CustomerID,FileType,FileOriginalName,FileSystemGeneratedName,PID FROM Ecom_Mst_Files

		--	WHERE CustomerID =@CustomerID AND IsActive=1 AND FileID <> @FileID
		SELECT FileID id,EID,FileType,FileOriginalName,FileSystemGeneratedName,PID,FileExtention,
		CASE WHEN EXISTS (SELECT * FROM IVAP_Mst_Files WHERE PID = F.FileID AND IsActive=1) THEN 1 ELSE 0 END hasChildren,ISNULL(UserRights,'') UserRights
		 FROM IVAP_Mst_Files F
			WHERE EID =@EID AND IsActive=1 AND PID=0 ORDER BY F.CreatedOn
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllFiles]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetAllFiles]
(
@Entity_ID int
)
	as
		Begin
				select * from IVAP_MST_FILETYPE where ENTITY_ID=@Entity_ID
        End
GO
/****** Object:  StoredProcedure [dbo].[GetBank]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetBank]    
(    
 @BankID INT=0,    
 @ENTITYName varchar(200)='',    
 @ENTITYID INT =27,    
 @StateName varchar(200)='',    
 @ISACT VARCHAR(1)='0',  
 @UID INT=52    
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
    
 SET @SQLString =N' select BK.TID,BK.BANK_CODE,BK.GLOBAL_BANK_ID,BK.BANK_NAME,BK.BANK_ADDR,BK.BANK_CITY,BK.BANK_STATE,BK.BANK_PIN,BK.BANK_PHONE,BK.ENTITY_ID    
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
/****** Object:  StoredProcedure [dbo].[GetBankHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GETBATCHNO]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCalendar_Setup]    Script Date: 03-06-2019 19:23:41 ******/
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
						E.ENTITY_CODE,CS.ISACTIVE,CT.NAME CALENDAR_TYPE_TEXT,CS.FILE_TYPE,ISNULL(CS.ActivityCategory,'''') ActivityCategory
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
/****** Object:  StoredProcedure [dbo].[GetCalendar_Setup_His]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCalendarDtl]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCalendarDtl_1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCalendarDtl_1]
(
	@EID INT=31,
	@CaledarType INT=1
)
AS
BEGIN
	DECLARE @TableName VARCHAR(50) ='ivap_TEMP_HIS_' + CAST(@EID AS VARCHAR)
	DECLARE @Query VARCHAR(5000)=''

	SET @Query = 'select DESCRIPTION,format(DUE_DATE,''yyyy/MM/dd'') DUE_DATE,
					CASE WHEN [EVENT] = ''CLIENT MAKER'' THEN ''Upload'' WHEN [EVENT] = ''CLIENT CHECKER'' THEN ''Approved''
						WHEN [EVENT] = ''MYND MAKER'' THEN ''Validation'' WHEN [EVENT] = ''MYND CHECKER'' THEN ''Payroll run'' END Activity,
					format(PAY_DATE,''dd/MM/yyyy'') PAY_DATE,FILE_TYPE,
					CASE WHEN [EVENT] = ''CLIENT MAKER'' THEN ''Payroll Input'' ELSE ''Payroll Output'' END Category,
					CASE WHEN [EVENT] = ''CLIENT MAKER'' THEN
					(SELECT top 1 CLIENT_MAKER_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) 
					WHEN [EVENT] = ''CLIENT CHECKER'' THEN
					(SELECT top 1 CLIENT_CHECKER_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC)
					WHEN [EVENT] = ''CLIENT ADMIN'' THEN
					(SELECT top  1 CLIENT_ADMIN_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC)
					WHEN [EVENT] = ''MYND MAKER'' THEN
					(SELECT top  1 MYND_MAKER_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC)
					WHEN [EVENT] = ''MYND CHECKER'' THEN
					(SELECT top  1 MYND_CHECKER_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC)
					END Last_Updated_Date,
					
					CASE WHEN [EVENT] = ''CLIENT MAKER'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 CLIENT_MAKER from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.CLIENT_MAKER)
					WHEN [EVENT] = ''CLIENT CHECKER'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 CLIENT_CHECKER from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.CLIENT_CHECKER)
					WHEN [EVENT] = ''CLIENT ADMIN'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 CLIENT_ADMIN from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.CLIENT_ADMIN)
					WHEN [EVENT] = ''MYND MAKER'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 MYND_MAKER from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.MYND_MAKER)
					WHEN [EVENT] = ''MYND CHECKER'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 MYND_CHECKER from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.MYND_CHECKER)
					END Last_Action_By

					from IVAP_CALENDAR_SETUP ct where Calendar_TYPE ='+CAST(@CaledarType AS VARCHAR)+' AND ENTITY_ID='+CAST(@EID AS VARCHAR)+''
		EXEC(@Query)
		PRINT(@Query)
END



--select * from IVAP_CALENDAR_SETUP 

--select PayDate, * from ivap_TEMP_HIS_31

--select * from IVAP_MST_FILETYPE  where TID =119

GO
/****** Object:  StoredProcedure [dbo].[GetCalendarDtl_1_New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCalendarDtl_1_New]
(
	@EID INT=31,
	@CaledarType INT=1,
	@Event VARCHAR(50)='',
	@FileType VARCHAR(50)='',
	@DueDate VARCHAR(50)='',
	@PayDate VARCHAR(50)=''
)
AS
BEGIN
	DECLARE @TableName VARCHAR(50) ='ivap_TEMP_HIS_' + CAST(@EID AS VARCHAR)
	DECLARE @Query VARCHAR(5000)=''
	
	SET @Query = 'select DESCRIPTION,format(DUE_DATE,''yyyy/MM/dd'') DUE_DATE,
					CASE WHEN [EVENT] = ''CLIENT MAKER'' THEN ''Upload'' WHEN [EVENT] = ''CLIENT CHECKER'' THEN ''Approved''
						WHEN [EVENT] = ''MYND MAKER'' THEN ''Validation'' WHEN [EVENT] = ''MYND CHECKER'' THEN ''Payroll run'' END Activity,
					format(PAY_DATE,''dd/MM/yyyy'') PAY_DATE,FILE_TYPE,format(DUE_DATE,''dd/MM/yyyy'') DUE_DATE_Show,
					CASE WHEN [EVENT] = ''CLIENT MAKER'' THEN ''Payroll Input'' ELSE ''Payroll Output'' END Category,
					CASE WHEN [EVENT] = ''CLIENT MAKER'' THEN
					(SELECT top 1 CLIENT_MAKER_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) 
					WHEN [EVENT] = ''CLIENT CHECKER'' THEN
					(SELECT top 1 CLIENT_CHECKER_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC)
					WHEN [EVENT] = ''CLIENT ADMIN'' THEN
					(SELECT top  1 CLIENT_ADMIN_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC)
					WHEN [EVENT] = ''MYND MAKER'' THEN
					(SELECT top  1 MYND_MAKER_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC)
					WHEN [EVENT] = ''MYND CHECKER'' THEN
					(SELECT top  1 MYND_CHECKER_DATE PayDate from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC)
					END Last_Updated_Date,
					
					CASE WHEN [EVENT] = ''CLIENT MAKER'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 CLIENT_MAKER from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.CLIENT_MAKER)
					WHEN [EVENT] = ''CLIENT CHECKER'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 CLIENT_CHECKER from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.CLIENT_CHECKER)
					WHEN [EVENT] = ''CLIENT ADMIN'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 CLIENT_ADMIN from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.CLIENT_ADMIN)
					WHEN [EVENT] = ''MYND MAKER'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 MYND_MAKER from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.MYND_MAKER)
					WHEN [EVENT] = ''MYND CHECKER'' THEN
					(SELECT USERID FROM IVAP_MST_USER U INNER JOIN (SELECT top  1 MYND_CHECKER from '+@TableName+' WHERE CAST(PayDATE as Date) = CAST(ct.PAY_DATE AS DATE) ORDER BY  PayDATE DESC) Temp
					ON U.UID = Temp.MYND_CHECKER)
					END Last_Action_By

					from IVAP_CALENDAR_SETUP ct where Calendar_TYPE ='+CAST(@CaledarType AS VARCHAR)+' AND ENTITY_ID='+CAST(@EID AS VARCHAR)+''
		IF(@Event <> '')
		BEGIN
			SET @Query = @Query + ' AND ct.EVENT = '''+@Event+''''
		END
		IF(@FileType <> '')
		BEGIN
			SET @Query = @Query + ' AND ct.File_Type = '''+@FileType+''''
		END
		IF(@DueDate <> '')
		BEGIN
			SET @Query = @Query + ' AND convert(varchar,ct.DUE_DATE,103) = '''+@DueDate+''''
		END
		IF(@PayDate <> '')
		BEGIN
			SET @Query = @Query + ' AND convert(varchar,ct.PAY_DATE,103) = '''+@PayDate+''''
		END
		EXEC(@Query)
		PRINT(@Query)
END
 


--select * from IVAP_CALENDAR_SETUP 

--select PayDate, * from ivap_TEMP_HIS_31

--select * from IVAP_MST_FILETYPE  where TID =119

GO
/****** Object:  StoredProcedure [dbo].[GetCalendarSetupForCalendarView]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCalendarSetupForCalendarView]
(
	@EID INT=31,
	@CaledarType INT=0,
	@Event VARCHAR(50)='',
	@FileType VARCHAR(50)='',
	@DueDate VARCHAR(50)='',
	@PayDate DATE=''
)
AS
BEGIN
	DECLARE @Query VARCHAR(5000)=''

	SET @Query = 'select DESCRIPTION,format(DUE_DATE,''yyyy/MM/dd'') DUE_DATE,
					format(PAY_DATE,''dd/MM/yyyy'') PAY_DATE,CT.Name CaledarType,Event,ISNULL(File_Type,''N/A'') FileType
					from IVAP_CALENDAR_SETUP CS 
					INNER JOIN IVAP_MST_CALENDAR_TYPE CT ON CS.CALENDAR_TYPE =CT.TID
					where ENTITY_ID='+CAST(@EID AS VARCHAR)+''

		IF(@CaledarType <> '0')
		BEGIN
			SET @Query = @Query + ' AND CS.CALENDAR_TYPE = '''+CAST(@CaledarType AS VARCHAR)+''''
		END
		IF(@Event <> '')
		BEGIN
			SET @Query = @Query + ' AND CS.EVENT = '''+@Event+''''
		END
		IF(@FileType <> '')
		BEGIN
			SET @Query = @Query + ' AND CS.File_Type = '''+@FileType+''''
		END
		IF(@DueDate <> '')
		BEGIN
			SET @Query = @Query + ' AND convert(varchar,CS.DUE_DATE,103) = '''+@DueDate+''''
		END
		IF(@PayDate <> '')
		BEGIN
			SET @Query = @Query + ' AND convert(varchar,CS.@PayDate,103) = '''+@DueDate+''''
		END
		EXEC(@Query)
		PRINT(@Query)
END
 

 --select * from IVAP_MST_CALENDAR_TYPE
--select * from IVAP_CALENDAR_SETUP 

--select PayDate, * from ivap_TEMP_HIS_31

--select * from IVAP_MST_FILETYPE  where TID =119

GO
/****** Object:  StoredProcedure [dbo].[GetCalendarType]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCapa]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
    
CREATE PROC [dbo].[GetCapa]                         
(    
 @EID INT,                              
 @CapaID INT=0                                            
)                            
AS                            
BEGIN                            
                         
                               
   if( @CapaID>0)        
 begin         
      select * from IVAP_MST_CAPA where TID=@CapaID and ENTITY_ID=@EID order by TID desc      
        
     select * from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID=@CapaID        
        
     select * from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID=@CapaID        
 end        
  else        
  begin        
        
     --select * from IVAP_MST_CAPA  where ENTITY_ID=@EID  order by TID desc      
     SELECT   
    CAPA.TID,CAPA.ISSUE,CAPA.ISSUE_DESCRIPTION,CAPA.CUSTOMER_IMPACT,CAPA.COMMUNICATION_PROCESS,CAPA.SEQUENCE_OF_EVENT,CAPA.ROOT_CAUSE,
	CAPA.CREATED_BY,CAPA.CATEGORY,CAPA.FINANCE_TYPE,CAPA.FINANCE_AMOUNT,CAPA.IMPACT_VALUE,CAPA.STAGE,CAPA.INCIDENT_DATE, 
     isnull(CO.cnt,0) AS 'CORRECTIVE_COUNT',   
     isnull(PR.cnt,0) AS 'PREVENTIVE_COUNT'  
   FROM IVAP_MST_CAPA CAPA  
   LEFT OUTER JOIN   
   (  
    select CAPA_ID, count(*) AS cnt from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)  group by CAPA_ID   
   ) AS  CO ON CO.CAPA_ID= CAPA.TID  
   LEFT OUTER JOIN   
   (  
     select CAPA_ID, count(*) AS cnt from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)    group by CAPA_ID   
   ) AS PR ON PR.CAPA_ID= CAPA.TID  
   WHERE CAPA.ENTITY_ID=@EID order by CAPA.TID desc   
        
     select * from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)     
        
     select * from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)      
 end        
        
END   
  
GO
/****** Object:  StoredProcedure [dbo].[GetCapa_NEW]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


        
CREATE PROC [dbo].[GetCapa_NEW] --31,44                           
(        
 @EID INT,                                  
 @CapaID INT=0                                                
)                                
AS                                
BEGIN                                
                             
                                   
   if( @CapaID>0)            
 begin             
      select * from IVAP_MST_CAPA where TID=@CapaID and ENTITY_ID=@EID order by TID desc          
            
     select * from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID=@CapaID            
            
     select * from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID=@CapaID     
    
  select C.TID,C.CAPAID,C.ITEM_ID,C.ITEM_NAME,C.REMARK,C.ATTACHMENT,C.STATUS,C.CLOSURE_DATE,C.SYSTEM_ATTACHMENT,U.UID,CONCAT(U.USER_FIRSTNAME, ' ', U.USER_LASTNAME) AS NAME  from IVAP_MST_CAPA_CONVERSATION C inner join IVAP_MST_USER U on C.CREATED_BY=U.UID  
  Where ITEM_ID in( select TID from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID=@CapaID) and ITEM_NAME='Corrective'         
  
   select C.TID,C.CAPAID,C.ITEM_ID,C.ITEM_NAME,C.REMARK,C.ATTACHMENT,C.STATUS,C.CLOSURE_DATE,C.SYSTEM_ATTACHMENT,U.UID,CONCAT(U.USER_FIRSTNAME, ' ', U.USER_LASTNAME) AS NAME  from IVAP_MST_CAPA_CONVERSATION C inner join IVAP_MST_USER U on C.CREATED_BY=U.UID 
    Where ITEM_ID in( select TID from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID=@CapaID) and ITEM_NAME='Preventive'         
 end            
  else            
  begin            
            
     --select * from IVAP_MST_CAPA  where ENTITY_ID=@EID  order by TID desc          
     SELECT       
    CAPA.TID,CAPA.ISSUE,CAPA.ISSUE_DESCRIPTION,CAPA.CUSTOMER_IMPACT,CAPA.COMMUNICATION_PROCESS,CAPA.SEQUENCE_OF_EVENT,CAPA.ROOT_CAUSE,    
 CAPA.CREATED_BY,CAPA.CATEGORY,CAPA.FINANCE_TYPE,CAPA.FINANCE_AMOUNT,CAPA.IMPACT_VALUE,CAPA.STAGE,CAPA.INCIDENT_DATE,     
     isnull(CO.cnt,0) AS 'CORRECTIVE_COUNT',       
     isnull(PR.cnt,0) AS 'PREVENTIVE_COUNT'      
   FROM IVAP_MST_CAPA CAPA      
   LEFT OUTER JOIN       
   (      
    select CAPA_ID, count(*) AS cnt from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)  group by CAPA_ID       
   ) AS  CO ON CO.CAPA_ID= CAPA.TID      
   LEFT OUTER JOIN       
   (      
     select CAPA_ID, count(*) AS cnt from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)    group by CAPA_ID       
   ) AS PR ON PR.CAPA_ID= CAPA.TID      
   WHERE CAPA.ENTITY_ID=@EID order by CAPA.TID desc       
            
     select * from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)         
            
     select * from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)   
    
   select C.TID,C.CAPAID,C.ITEM_ID,C.ITEM_NAME,C.REMARK,C.ATTACHMENT,C.STATUS,C.CLOSURE_DATE,C.SYSTEM_ATTACHMENT,U.UID,CONCAT(U.USER_FIRSTNAME, ' ', U.USER_LASTNAME) AS NAME  from IVAP_MST_CAPA_CONVERSATION C inner join IVAP_MST_USER U on C.CREATED_BY=U.UID  Where
    ITEM_ID in( select TID from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)) and ITEM_NAME='Corrective'         
  
   select C.TID,C.CAPAID,C.ITEM_ID,C.ITEM_NAME,C.REMARK,C.ATTACHMENT,C.STATUS,C.CLOSURE_DATE,C.SYSTEM_ATTACHMENT,U.UID,CONCAT(U.USER_FIRSTNAME, ' ', U.USER_LASTNAME) AS NAME  from IVAP_MST_CAPA_CONVERSATION C inner join IVAP_MST_USER U on C.CREATED_BY=U.UID  Where
    ITEM_ID in( select TID from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID) ) and ITEM_NAME='Preventive'                
 end            
            
END 
GO
/****** Object:  StoredProcedure [dbo].[GetCapaCalendar]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
  
    
    
CREATE PROC [dbo].[GetCapaCalendar]  --15,'04/05/2019'                          
(    
 @EID INT,                              
 @CapaDate nvarchar(50)=''                                           
)                            
AS                            
BEGIN                            
                         
                               
   if( @CapaDate='')        
 begin         
      select * from IVAP_MST_CAPA where  ENTITY_ID=@EID order by TID desc      
        
     select * from IVAP_MST_CAPA_CORRECTIVE where  CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)       
        
     select * from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID)              
 end        
  else        
  begin        
        
     select * from IVAP_MST_CAPA  where ENTITY_ID=@EID and convert(varchar,CREATED_ON,103)= @CapaDate order by TID desc      
        
     select * from IVAP_MST_CAPA_CORRECTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID and convert(varchar,CREATED_ON,103)= @CapaDate)     
        
     select * from IVAP_MST_CAPA_PREVENTIVE where CAPA_ID in(select TID  from IVAP_MST_CAPA  where ENTITY_ID=@EID and convert(varchar,CREATED_ON,103)= @CapaDate)      
 end        
        
END 
GO
/****** Object:  StoredProcedure [dbo].[GetCapaCalendarData]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetCapaCalendarData]  
(    
@EID int    
)    
as    
begin    
    
    
select TID,ISSUE,ISSUE_DESCRIPTION,CUSTOMER_IMPACT,SEQUENCE_OF_EVENT,ROOT_CAUSE,COMMUNICATION_PROCESS,format(CREATED_ON,'yyyy/MM/dd') AS CREATED_ON from IVAP_MST_CAPA where ENTITY_ID=@EID    
    
    
end 
GO
/****** Object:  StoredProcedure [dbo].[GetCapaCorrective]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetCapaCorrective]
as
begin


select * from IVAP_MST_CAPA_CORRECTIVE

end
GO
/****** Object:  StoredProcedure [dbo].[GetCapaHis]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetCapaHis]  
(  
@CapaID int=0  
)  
as  
begin  
select TID,CID,ISSUE,ISSUE_DESCRIPTION,CUSTOMER_IMPACT,SEQUENCE_OF_EVENT,COMMUNICATION_PROCESS,ROOT_CAUSE,CONVERT(VARCHAR,CREATED_ON,107) AS CREATED_ON,
CREATED_BY,CONVERT(VARCHAR,UPDATE_ON,107) AS UPDATE_ON,ACTION from IVAP_HIS_CAPA where CID=@CapaID  
end
GO
/****** Object:  StoredProcedure [dbo].[GetCapaPreventive]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetCapaPreventive]
as
begin


select * from IVAP_MST_CAPA_PREVENTIVE

end
GO
/****** Object:  StoredProcedure [dbo].[GetClass]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetClassHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetClientAdmin]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[GetClientAdmin]
(
@Entity_ID int
)
	as
		Begin
				select  top 1 UID from IVAP_MST_user where ENTITY_ID=@Entity_ID 
        End
GO
/****** Object:  StoredProcedure [dbo].[GetClosingMonth]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[GetClosingMonth]
(
@Entity_Code int
)
As
	declare @qry nvarchar(max)='';
	Begin
		 set	@qry = @qry +'Select  distinct Upper(Right(Replace(convert(varchar,paydate,106),'' '',''-''),8)) Closing from Ivap_TEMP_HIS_'+ cast(@Entity_Code as varchar) +' order by Upper(Right(Replace(convert(varchar,paydate,106),'' '',''-''),8)) desc '
		 exec sp_executesql @qry
	End
GO
/****** Object:  StoredProcedure [dbo].[GetCompany]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--SELECT * FROM IVAP_MST_COMPANY      
CREATE PROC [dbo].[GetCompany]      
(      
 @COMPID INT=0,      
 @EID INT=38,      
 @StateID INT=0,      
 @COMP_CODE VARCHAR(20)='',      
 @COMP_NAME VARCHAR(200)='',      
 @ISACT VARCHAR(1)='0',    
 @UID INT=0      
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
/****** Object:  StoredProcedure [dbo].[GetCompanyHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetComponent]    Script Date: 03-06-2019 19:23:41 ******/
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
	COMPONENT_DESCRIPTION,ISACTIVE,MIN_LENGTH,MAX_LENGTH,MANDATORY ,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,EXTRA_INPUT_VALIDATION,ISNULL(EXTRA_RG_EXPRESSION,'''')EXTRA_RG_EXPRESSION,
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
/****** Object:  StoredProcedure [dbo].[GetComponentEntity]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetComponentEntity1]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetComponentEntity17]    Script Date: 03-06-2019 19:23:41 ******/
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

	SET @SQLString =N'select ROW_NUMBER() OVER (PARTITION BY COMPONENT_NAME ORDER BY COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME) ROWNUM, COE.TID,COE.COMPONENT_FILE_TYPE,Globle_Component_ID,COMPONENT_TYPE,
	CASE when COMPONENT_COLUMN_NAME=''0'' then ''''else COMPONENT_COLUMN_NAME end COMPONENT_COLUMN_NAME,COMPONENT_SUB_TYPE,
	COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_DISPLAY_NAME,COMPONENT_TABLE_NAME,COE.EXTRA_INPUT_VALIDATION,ISNULL(COE.EXTRA_RG_EXPRESSION,'''')EXTRA_RG_EXPRESSION,
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
/****** Object:  StoredProcedure [dbo].[GetComponentEntityHis]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetComponentEntityHis]
(
	@CompEntityID INT
)
AS
BEGIN
select COEH.TID,COEH.COMPONENT_FILE_TYPE,COEH.COMPONENT_TYPE,COEH.COMPONENT_COLUMN_NAME,COEH.COMPONENT_SUB_TYPE,COEH.COMPONENT_NAME,COEH.COMPONENT_DATATYPE,COEH.COMPONENT_DISPLAY_NAME,
	COEH.COMPONENT_DESCRIPTION,COEH.MIN_LENGTH,COEH.MAX_LENGTH ,ENTITY.ENTITY_NAME,COEH.EXTRA_INPUT_VALIDATION,COEH.EXTRA_RG_EXPRESSION
	,CASE when COEH.MANDATORY=1 then 'required'else 'not required' end MANDATORY_STATUS,CASE WHEN COEH.ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS,
	FORMAT(COEH.CREATED_ON,'dd/MM/yyyy') CREATED_ON,U.USER_FIRSTNAME CREATED_BY,CASE WHEN COEH.ACTION='Update' THEN U.USER_FIRSTNAME END UPDATED_BY,FORMAT(COEH.UPDATE_ON,'dd/MM/yyyy')UPDATE_ON,COEH.ACTION
	 from IVAP_HIS_COMPONENT_ENTITY COEH INNER JOIN IVAP_MST_ENTITY ENTITY ON COEH.ENTITY_ID=ENTITY.TID INNER JOIN IVAP_MST_USER U ON COEH.CREATED_BY=U.UID
	WHERE COEH.CompEntityID=@CompEntityID
END
GO
/****** Object:  StoredProcedure [dbo].[GetComponentFileType]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[GetComponentFileType](@Component_File_Type varchar(50)='',@Component_Type varchar(50)='',@COMPONENT_DATATYPE VARCHAR(20)='')
as
begin
if(isnull(@COMPONENT_DATATYPE,'D') ='D')
begin
select distinct COMPONENT_DATATYPE from IVAP_MST_component_DataType ORDER BY COMPONENT_DATATYPE
end
if(isnull(@Component_File_Type,'') ='' and isnull(@Component_Type,'') ='')
begin
select distinct COMPONENT_FILE_TYPE from IVAP_MST_component_COMPONENT_TYPE
end
if(isnull(@Component_File_Type,'') !=''  AND  isnull(@Component_Type,'') ='')
begin
select distinct COMPONENT_TYPE from IVAP_MST_component_COMPONENT_TYPE where COMPONENT_FILE_TYPE=@Component_File_Type
end
if(isnull(@Component_File_Type,'') !='' AND isnull(@Component_Type,'') !='')
begin
	select distinct COMPONENT_SUB_TYPE from IVAP_MST_component_COMPONENT_Sub_TYPE where COMPONENT_FILE_TYPE=@Component_File_Type and COMPONENT_TYPE=@Component_Type
end
end

GO
/****** Object:  StoredProcedure [dbo].[GetComponentFileTypeupload]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetComponentFileTypeupload](@Component_File_Type varchar(50)='',@Component_Type varchar(50)='',@COMPONENT_SUB_TYPE VARCHAR(100)='',@COMPONENT_DATATYPE VARCHAR(50)='',@UTableName VARCHAR(200)='')
as
begin
if(isnull(@COMPONENT_DATATYPE,'') !='')
begin
select distinct COMPONENT_DATATYPE from IVAP_MST_component_DataType where UPPER(COMPONENT_DATATYPE)=UPPER(@COMPONENT_DATATYPE)
end
if(isnull(@UTableName,'')!='')
begin
select distinct TABLE_NAME,SCREEN_NAME from IVAP_META_MASTER_DEFAULT where UPPER(SCREEN_NAME)=UPPER(@UTableName)
end
if(isnull(@Component_File_Type,'') !=''  AND  isnull(@Component_Type,'')! ='' AND isnull(@COMPONENT_SUB_TYPE,'') ='')
begin
select distinct COMPONENT_TYPE from IVAP_MST_component_COMPONENT_TYPE where UPPER(COMPONENT_FILE_TYPE)=UPPER(@Component_File_Type) and UPPER(COMPONENT_TYPE)=UPPER(@Component_Type)
end
if(isnull(@Component_File_Type,'') !='' AND isnull(@Component_Type,'') !='' AND isnull(@COMPONENT_SUB_TYPE,'') !='')
begin
	select distinct COMPONENT_SUB_TYPE from IVAP_MST_component_COMPONENT_Sub_TYPE where UPPER(COMPONENT_FILE_TYPE)=UPPER(@Component_File_Type) and UPPER(COMPONENT_TYPE)=UPPER(@Component_Type) and UPPER(COMPONENT_SUB_TYPE)=UPPER(@COMPONENT_SUB_TYPE)
end
end
GO
/****** Object:  StoredProcedure [dbo].[GetComponentForFile]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetComponentForFile]
(
@Template_ID int=0,
@Entity_ID int=0
)
as
	Begin
			select ce.TID  from IVAP_MST_COMPONENT gc WITH(NOLOCK) inner join IVAP_MST_COMPONENT_ENTITY ce WITH(NOLOCK) on ce.Globle_Component_ID=gc.TID AND CE.ENTITY_ID=@Entity_ID where ','+File_Template like '%,'+Cast(@Template_ID as nvarchar) +',%'
	End
GO
/****** Object:  StoredProcedure [dbo].[GetComponentHis]    Script Date: 03-06-2019 19:23:41 ******/
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
,CASE WHEN ISNULL(CH.UPDATE_ON,'') <>'' THEN U.USER_FIRSTNAME ELSE '' END UPDATEDBY,FORMAT(CH.UPDATE_ON,'dd/MM/yyyy')UPDATED_ON,FORMAT(CH.CREATED_ON,'dd/MM/yyyy')CREATED_ON,
CH.EXTRA_INPUT_VALIDATION,CH.EXTRA_RG_EXPRESSION
 FROM IVAP_HIS_COMPONENT CH INNER JOIN IVAP_MST_USER U ON CH.CREATED_BY=U.UID     
WHERE COMPONENT_ID=@COMPONENT_ID      
END
GO
/****** Object:  StoredProcedure [dbo].[GetCostCenterHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCostCentre]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCountry]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilationDB]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetCTCReconcilationDB]  
(      
 @ENTITYID int =31,    
 @PAYDATE varchar(20)='2019-02-28',  
 @P_PAYDATE varchar(20)='2019-01-31'    
)      
as      
declare @sqlqry_Input varchar(max)    
declare @sqlqry_Output varchar(max)    
Begin      
set @sqlqry_Input='select ''Opening Balance''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID     
where f.CATEGORY=''CTC Master'' and convert(date,his.paydate)=convert(date,'''+ @P_PAYDATE +''') and f.file_type=''PMS Output File''    
union all    
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID     
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''    
union all    
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID     
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''    
union all    
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID     
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''    
union all    
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID     
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''    
union all
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from     
Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID     
where f.CATEGORY=''Package Change'' and  f.file_type=''Payroll Input File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')
union all
select ''Closing Balance''[Category],0 [Value],0 as CTC'    
   exec (@sqlqry_Input)      
--print @sqlqry_Output    
End   
GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilationDB_copy1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetCTCReconcilationDB_copy1]
(  
 @ENTITYID int =31,
 @PAYDATE varchar(20)='2019-02-28'
)  
as  
declare @sqlqry_Input varchar(max)
declare @sqlqry_Output varchar(max)
Begin  
set @sqlqry_Input='SELECT ''Opening Balance''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
SELECT ''Closing Balance''[Category],
(


(SELECT count(*) FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+')
+
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')  and f.file_type=''Payroll Input File'')
-
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''Resignation'',''Transfer Out'') and  f.file_type=''Payroll Input File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')))[Value],0 as CTC
union all
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from 
Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Package Change'' and  f.file_type=''Payroll Input File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')'

set @sqlqry_Output='SELECT ''Opening Balance''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
SELECT ''Closing Balance''[Category],
(


(SELECT count(*) FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+')
+
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')  and f.file_type=''PMS Output File'')
-
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''Resignation'',''Transfer Out'') and  f.file_type=''PMS Output File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')))[Value],0 as CTC
union all
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from 
Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Package Change'' and  f.file_type=''PMS Output File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')'

--exec (@sqlqry_Input)
--exec (@sqlqry_Output)
print @sqlqry_Input
End
GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilationDB_New1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetCTCReconcilationDB_New1]  
(    
 @ENTITYID int =31,  
 @PAYDATE varchar(20)='2019-02-28',
 @P_PAYDATE varchar(20)='2019-01-31'  
)    
as    
declare @sqlqry_Input varchar(max)  
declare @sqlqry_Output varchar(max)  
Begin    
set @sqlqry_Input='select ''Opening Balance''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''CTC Master'' and convert(date,his.paydate)=convert(date,'''+ @P_PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
SELECT ''Closing Balance''[Category],  
(  
  
  
(SELECT count(*) FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+')  
+  
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his   
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')  and f.file_type=''Payroll Input File'')  
-  
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his   
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY in(''Resignation'',''Transfer Out'') and  f.file_type=''Payroll Input File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')))[Value],0 as CTC  
union all  
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from   
Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Package Change'' and  f.file_type=''Payroll Input File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')'  
  
set @sqlqry_Output='SELECT ''Opening Balance''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his  
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
SELECT ''Closing Balance''[Category],  
(  
  
  
(SELECT count(*) FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+')  
+  
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his   
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')  and f.file_type=''PMS Output File'')  
-  
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his   
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY in(''Resignation'',''Transfer Out'') and  f.file_type=''PMS Output File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')))[Value],0 as CTC  
union all  
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from   
Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Package Change'' and  f.file_type=''PMS Output File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')'  
  
exec (@sqlqry_Input)  
exec (@sqlqry_Output)  
--print @sqlqry_Output  
End 
GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilationDB_Test]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetCTCReconcilationDB_Test]  
(    
 @ENTITYID int =31,  
 @PAYDATE varchar(20)='2019-02-28'  
)    
as    
declare @sqlqry_Input varchar(max)  
declare @sqlqry_Output varchar(max)  
Begin    
set @sqlqry_Input='SELECT ''Opening Balance''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his  
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''  
union all  
SELECT ''Closing Balance''[Category],  
(  
  
  
(SELECT count(*) FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+')  
+  
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his   
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')  and f.file_type=''Payroll Input File'')  
-  
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his   
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY in(''Resignation'',''Transfer Out'') and  f.file_type=''Payroll Input File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')))[Value],0 as CTC  
union all  
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from   
Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Package Change'' and  f.file_type=''Payroll Input File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')'  
  
set @sqlqry_Output='SELECT ''Opening Balance''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his  
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''  
union all  
SELECT ''Closing Balance''[Category],  
(  
  
  
(SELECT count(*) FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+')  
+  
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his   
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')  and f.file_type=''PMS Output File'')  
-  
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his   
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY in(''Resignation'',''Transfer Out'') and  f.file_type=''PMS Output File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')))[Value],0 as CTC  
union all  
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from   
Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID   
where f.CATEGORY=''Package Change'' and  f.file_type=''PMS Output File'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')'  
  
exec (@sqlqry_Input)  
exec (@sqlqry_Output)  
--print @sqlqry_Output  
End 
GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconciliationDB]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCTCReconciliationDB]  
(  
 @COMPONENT_NAME varchar(max),  
 @ENTITYID INT=0
)  
AS  

BEGIN  
declare @sqlqry nvarchar(max)='';
 IF(@ENTITYID > 0) 
  
 BEGIN
   
  set @sqlqry='select '+@COMPONENT_NAME+' from Ivap_MAST_TEMP_'+@ENTITYID+''
  print(@sqlqry)
    exec (@sqlqry) 
END
END
GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilliation]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetCTCReconcilliation]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
       DECLARE @LastMonthCTC DECIMAL(18,2)
       DECLARE @CurrentMonthCTC DECIMAL(18,2)

       SET @LastMonthCTC=(

       select isnull(Sum(CTC),0)  from Ivap_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File')

       SET @CurrentMonthCTC=(
       select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
       select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
       ))
       



       select isnull(Sum(CTC),0) AS INPUTCTC,isnull(Sum(CTC),0) AS OUTPUTCTC,'Opening Balance' As Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
	   union all
       select isnull(Sum(CTC),0) As INPUTCTC,case  when @CurrentMonthCTC >0 then @LastMonthCTC-@CurrentMonthCTC else 0 end AS OUTPUTCTC,'New Joiner' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='New Joiner'
       and F.file_type='Payroll Input File'
	    union all

		select isnull(Sum(CTC),0) As INPUTCTC,0 AS OUTPUTCTC,'Transfer In' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' +@PayDate + '' and F.CATEGORY='Transfer InP' and F.file_type='Payroll Input File'

	    union all

		       select isnull(Sum(CTC),0) As INPUTCTC,case  when @CurrentMonthCTC >0 THEN(
              select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       )
       ) else 0 end AS OUTPUTCTC,'Transfer Out' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Transfer Out' and F.file_type='Payroll Input File'
	    union all

       select isnull(Sum(CTC),0) As INPUTCTC,0 AS OUTPUTCTC,'Separated Employee' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Resignation' and F.file_type='Payroll Input File'
	    union all
       select isnull(Sum(CTC),0) As INPUTCTC,case  when @CurrentMonthCTC >0 then (
              select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE  in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       ))-(
              select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE  in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       )) else 0 end AS OUTPUTCTC,'CTC Change' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Package Change' and F.file_type='Payroll Input File'
	   union all
	   select 0 As INPUTCTC,0 AS OUTPUTCTC,'Closing Balance' [Type] 

       --Package Change

END



GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilliation_0001]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[GetCTCReconcilliation_0001]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-02-28',
       @PreviousPayDate varchar(30)='2019-01-31' 
)
AS

BEGIN
       select isnull(Sum(CTC),0) AS CTC,'Opening Balance' As Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
	   union all
       select isnull(Sum(CTC),0) As CTC,'New Joiner' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='New Joiner'
       and F.file_type='Payroll Input File'
	    union all
		select isnull(Sum(CTC),0) As CTC,'Transfer In' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' +@PayDate + '' and F.CATEGORY='Transfer InP' and F.file_type='Payroll Input File'
	    union all
		       select isnull(Sum(CTC),0) As CTC,'Transfer Out' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Transfer Out' and F.file_type='Payroll Input File'
	    union all

       select isnull(Sum(CTC),0) As CTC,'Separated Employee' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Resignation' and F.file_type='Payroll Input File'
	    union all
       select isnull(Sum(CTC),0) As CTC,'Package Change' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Package Change' and F.file_type='Payroll Input File'
	   union all
	   select 0 As CTC,'Closing Balance' [Type] 

       --Package Change
END



GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilliation_001]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetCTCReconcilliation_001]
(
       @EID INT=37,
       @PayDate varchar(30)='2019-04-30',
       @PreviousPayDate varchar(30)='2019-03-31' 
)
AS

BEGIN
       DECLARE @LastMonthCTC DECIMAL(18,2)
       DECLARE @CurrentMonthCTC DECIMAL(18,2)

       SET @LastMonthCTC=(

       select isnull(Sum(CTC),0)  from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File')

       SET @CurrentMonthCTC=(
       select isnull(Sum(CTC),0)  from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
       select Distinct  EMP_CODE from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
       ))
       



       select isnull(Sum(CTC),0) AS INPUTCTC,isnull(Sum(CTC),0) AS OUTPUTCTC,'Opening Balance' As Type from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
	   union all
       select isnull(Sum(CTC),0) As INPUTCTC,
	   (
	   select isnull(Sum(CTC),0) AS OUTPUTCTC from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File' AND EMP_CODE IN
	   (SELECT EMP_CODE FROM Ivap_TEMP_HIS_37 WHERE PayDate='' + @PayDate + '')
	   and 	EMP_CODE not IN (SELECT EMP_CODE FROM Ivap_TEMP_HIS_37 WHERE PayDate='' + @PreviousPayDate + '')),
	   
	   'New Joiner' AS Type from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='New Joiner'
       and F.file_type='Payroll Input File'
	   union all

	   select isnull(Sum(CTC),0) As INPUTCTC,0 AS OUTPUTCTC,'Transfer In' AS Type from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' +@PayDate + '' and F.CATEGORY='Transfer InP' and F.file_type='Payroll Input File'

	    union all
		select isnull(Sum(CTC),0) As INPUTCTC,
		(select isnull(Sum(CTC),0) AS OUTPUTCTC from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File' AND EMP_CODE not IN
	   (SELECT EMP_CODE FROM Ivap_TEMP_HIS_37 WHERE PayDate='' + @PayDate + '')) OUTPUTCTC,
	   'Transfer Out' AS Type from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Transfer Out' and F.file_type='Payroll Input File'
	    union all

       select isnull(Sum(CTC),0) As INPUTCTC,0 AS OUTPUTCTC,'Separated Employee' AS Type from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Resignation' and F.file_type='Payroll Input File'
	    union all
       select isnull(Sum(CTC),0) As INPUTCTC,
	   (
	   select isnull(Sum(CTC),0) AS OUTPUTCTC from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File' AND EMP_CODE IN
	   (SELECT EMP_CODE FROM Ivap_TEMP_HIS_37 WHERE PayDate='' + @PayDate + '')),
	  
	  'CTC Change' AS Type from Ivap_TEMP_HIS_37 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Package Change' and F.file_type='Payroll Input File'
	   union all
	   select 0 As INPUTCTC,0 AS OUTPUTCTC,'Closing Balance' [Type] 

       --Package Change

END



GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilliation_1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetCTCReconcilliation_1]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
       DECLARE @LastMonthCTC DECIMAL(18,2)
       DECLARE @CurrentMonthCTC DECIMAL(18,2)

       SET @LastMonthCTC=(

       select isnull(Sum(CTC),0)  from Ivap_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File')

       SET @CurrentMonthCTC=(
       select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
       select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
       ))
       



       select isnull(Sum(CTC),0) AS INPUTCTC,isnull(Sum(CTC),0) AS OUTPUTCTC,'Opening Balance' As Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
	   union all
       select isnull(Sum(CTC),0) As INPUTCTC,case  when @CurrentMonthCTC >0 then @LastMonthCTC-@CurrentMonthCTC else 0 end AS OUTPUTCTC,'New Joiner' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='New Joiner'
       and F.file_type='Payroll Input File'
	    union all

		select isnull(Sum(CTC),0) As INPUTCTC,0 AS OUTPUTCTC,'Transfer In' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' +@PayDate + '' and F.CATEGORY='Transfer InP' and F.file_type='Payroll Input File'

	    union all

		       select isnull(Sum(CTC),0) As INPUTCTC,case  when @CurrentMonthCTC >0 THEN(
              select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       )
       ) else 0 end AS OUTPUTCTC,'Transfer Out' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Transfer Out' and F.file_type='Payroll Input File'
	    union all

       select isnull(Sum(CTC),0) As INPUTCTC,0 AS OUTPUTCTC,'Separated Employee' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Resignation' and F.file_type='Payroll Input File'
	    union all
       select isnull(Sum(CTC),0) As INPUTCTC,case  when @CurrentMonthCTC >0 then (
              select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE  in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       ))-(
              select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE  in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       )) else 0 end AS OUTPUTCTC,'CTC Change' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Package Change' and F.file_type='Payroll Input File'
	   union all
	   select 0 As INPUTCTC,0 AS OUTPUTCTC,'Closing Balance' [Type] 

       --Package Change

END



GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilliation_headCount]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetCTCReconcilliation_headCount]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
       
       
	   DECLARE @LastMonthCTC DECIMAL(18,2)
       DECLARE @CurrentMonthCTC DECIMAL(18,2)

       SET @LastMonthCTC=(

       select Count(*)  from Ivap_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File')

       SET @CurrentMonthCTC=(
       select Count(*)  from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
       select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
       ))


       select Count(*) AS INPUTCTC,Count(*) AS OUTPUTCTC,'Opening Balance' As Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
	   union all

       select Count(*) As INPUTCTC,@LastMonthCTC-@CurrentMonthCTC AS OUTPUTCTC,'New Joiner' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='New Joiner'
       and F.file_type='Payroll Input File'
	    union all

		select Count(*) As INPUTCTC,0 AS OUTPUTCTC,'Transfer In' AS Type from IVAP_TEMP_HIS_31 Temp
		inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
		where PayDate='' +@PayDate + '' and F.CATEGORY='Transfer InP' and F.file_type='Payroll Input File'
	    union all
		       select isnull(Sum(CTC),0) As INPUTCTC,(
              select isnull(Sum(CTC),0)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       )
       ) AS OUTPUTCTC,'Transfer Out' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Transfer Out' and F.file_type='Payroll Input File'
	    union all

       select Count(*) As INPUTCTC,0 AS OUTPUTCTC,'Separated Employee' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Resignation' and F.file_type='Payroll Input File'
	    union all
       select Count(*) As INPUTCTC,(
              select Count(*)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE  in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       ))-(
              select Count(*)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE  in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       )) AS OUTPUTCTC,'Package Change' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Package Change' and F.file_type='Payroll Input File'

	   union all
	   select 0 As INPUTCTC,0 AS OUTPUTCTC,'Closing Balance' [Type] 
       --Package Change

END



GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilliation_headCount_copy]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetCTCReconcilliation_headCount_copy]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
       
       
	   DECLARE @LastMonthCTC DECIMAL(18,2)
       DECLARE @CurrentMonthCTC DECIMAL(18,2)

       SET @LastMonthCTC=(

       select Count(*)  from Ivap_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File')

       SET @CurrentMonthCTC=(
       select Count(*)  from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
       select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
       ))


       select Count(*) AS INPUTCTC,Count(*) AS OUTPUTCTC,'Opening Balance' As Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
       and F.file_type='PMS Output File'
	   union all

       select Count(*) As INPUTCTC,case  when @CurrentMonthCTC >0 then @LastMonthCTC-@CurrentMonthCTC  else 0 end AS OUTPUTCTC,'New Joiner' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='New Joiner'
       and F.file_type='Payroll Input File'
	    union all

		select Count(*) As INPUTCTC,0 AS OUTPUTCTC,'Transfer In' AS Type from IVAP_TEMP_HIS_31 Temp
		inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
		where PayDate='' +@PayDate + '' and F.CATEGORY='Transfer InP' and F.file_type='Payroll Input File'
	    union all
		       select Count(*) As INPUTCTC,case  when @CurrentMonthCTC >0 then (
              select Count(*)  from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PreviousPayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File' and Temp.EMP_CODE not in (
              select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate='' + @PayDate + '' and F.CATEGORY='CTC Master'
              and F.file_type='PMS Output File'
       )
       ) else 0 end AS OUTPUTCTC,'Transfer Out' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Transfer Out' and F.file_type='Payroll Input File'
	    union all

       select Count(*) As INPUTCTC,0 AS OUTPUTCTC,'Separated Employee' AS Type from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate='' + @PayDate + '' and F.CATEGORY='Resignation' and F.file_type='Payroll Input File'

	   union all
	   select 0 As INPUTCTC,0 AS OUTPUTCTC,'Closing Balance' [Type] 
       --Package Change

END



GO
/****** Object:  StoredProcedure [dbo].[GetCTCReconcilliation_New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetCTCReconcilliation_New]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
       declare @SqlQuery varchar(max)='';
       DECLARE @LastMonthCTC DECIMAL(18,2)
       DECLARE @CurrentMonthCTC DECIMAL(18,2)

       SET @LastMonthCTC='(
       select isnull(Sum(CTC),0)  from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PreviousPayDate + ''' and F.CATEGORY=''CTC Master''
       and F.file_type=''PMS Output File'')'

       SET @CurrentMonthCTC='(
       select isnull(Sum(CTC),0)  from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC Master''
       and F.file_type=''PMS Output File'' and Temp.EMP_CODE not in (
       select Distinct  EMP_CODE from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PreviousPayDate + ''' and F.CATEGORY=''CTC Master''
       and F.file_type=''PMS Output File''
       ))'


    set  @SqlQuery='select isnull(Sum(CTC),0) AS INPUTCTC,isnull(Sum(CTC),0) AS OUTPUTCTC,''Opening Balance'' As Type 
	     from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PreviousPayDate + ''' and F.CATEGORY=''CTC Master''
       and F.file_type=''PMS Output File''
	   
	    union all

		select isnull(Sum(CTC),0) As INPUTCTC,0 AS OUTPUTCTC,''Transfer In'' AS Type from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' +@PayDate + ''' and F.CATEGORY=''Transfer InP'' and F.file_type=''Payroll Input File''

	    union all

		       select isnull(Sum(CTC),0) As INPUTCTC,case  when ' + @CurrentMonthCTC + '  >0 THEN(
              select isnull(Sum(CTC),0)  from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate=''' + @PreviousPayDate + ''' and F.CATEGORY=''CTC Master''
              and F.file_type=''PMS Output File'' and Temp.EMP_CODE not in (
              select Distinct  EMP_CODE from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC Master''
              and F.file_type=''PMS Output File''
       )
       ) else 0 end AS OUTPUTCTC,''Transfer Out'' AS Type from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Transfer Out'' and F.file_type=''Payroll Input File''
	    union all

       select isnull(Sum(CTC),0) As INPUTCTC,0 AS OUTPUTCTC,''Separated Employee'' AS Type from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Resignation'' and F.file_type=''Payroll Input File''
	    union all
       select isnull(Sum(CTC),0) As INPUTCTC,case  when ' + @CurrentMonthCTC + '  >0 then (
              select isnull(Sum(CTC),0)  from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC Master''
              and F.file_type=''PMS Output File'' and Temp.EMP_CODE  in (
              select Distinct  EMP_CODE from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate=''' + @PreviousPayDate + ''' and F.CATEGORY=''CTC Master''
              and F.file_type=''PMS Output File''
       ))-(
              select isnull(Sum(CTC),0)  from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate=''' + @PreviousPayDate + ''' and F.CATEGORY=''CTC Master''
              and F.file_type=''PMS Output File'' and Temp.EMP_CODE  in (
              select Distinct  EMP_CODE from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
              inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
              where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC Master''
              and F.file_type=''PMS Output File''
       )) else 0 end AS OUTPUTCTC,''CTC Change'' AS Type from ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Package Change'' and F.file_type=''Payroll Input File''
	   union all
	   select 0 As INPUTCTC,0 AS OUTPUTCTC,''Closing Balance'' [Type]'

       --Package Change

	   print (@SqlQuery)
END



GO
/****** Object:  StoredProcedure [dbo].[GetCurrency]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCurrencyEntity]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[GetCurrencyEntity]
as
begin

SELECT C.TID,C.CURRENCY_CODE,C.CURRENCY_NAME,C.CURRENCY_NAME+'('+C.CURRENCY_CODE+')' AS CurrencyCode FROM IVAP_MST_CURRENCY C                        
   WHERE  ISACTIVE=1

end
GO
/****** Object:  StoredProcedure [dbo].[GetCurrencyHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCurrencyNew]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GETDATAACCESSCONTROL]    Script Date: 03-06-2019 19:23:41 ******/
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
  ELSE IF @ACTION_NAME='ViewState'           
  BEGIN          
 SELECT 'IVAP_MST_STATE' as TableName,TID,STATE_NAME as Name,          
  case when C.TID = Sp.Item THEN 'Y' ELSE 'N' END Checked          
  FROM IVAP_MST_State C          
   LEFT OUTER JOIN (SELECT * FROM [dbo].SplitString((select TIDS from IVAP_DATA_ACCESS_DTL where UID=@UID AND TABLE_NAME ='IVAP_MST_FILETYPE'),',')) Sp          
 ON C.TID = Sp.Item        
  END        
         
          
END 
GO
/****** Object:  StoredProcedure [dbo].[GETDATAACCESSUSER]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDataFromQry]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDataFromQry] 
(  
 @COMPONENT_NAME varchar(max),
 @FILETYPEID INT=0,  
 @ENTITYID INT=0,
 @DEFPAYDATE varchar(30),
 @DURATION INT=12
 )  
AS  
declare @sqlqry varchar(max) 

 BEGIN
    exec (@COMPONENT_NAME)
	if (@DURATION=3)
	BEGIN
	set @sqlqry='SELECT distinct CONVERT(CHAR(4), PAYDATE, 100) + CONVERT(CHAR(4), PAYDATE, 120) AS PAYDATE  FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+'
	where PAYDATE in (''' + @DEFPAYDATE + ''',DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-1, -1),
	DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-2, -1)) 
	order by PAYDATE desc'
	END
	ELSE IF (@DURATION=6)
	BEGIN
	set @sqlqry='SELECT distinct CONVERT(CHAR(4), PAYDATE, 100) + CONVERT(CHAR(4), PAYDATE, 120) AS PAYDATE  FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+'
                where PAYDATE in (''' + @DEFPAYDATE + ''',DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-1, -1)
               ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-2, -1)	,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-3, -1)
               ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-4, -1)	,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-5, -1)) 
               order by PAYDATE desc'
	END
	ELSE IF (@DURATION=9)
	BEGIN
	set @sqlqry='SELECT distinct CONVERT(CHAR(4), PAYDATE, 100) + CONVERT(CHAR(4), PAYDATE, 120) AS PAYDATE  FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+'
                where PAYDATE in (''' + @DEFPAYDATE + ''',DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-1, -1)
               ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-2, -1)	,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-3, -1)
               ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-4, -1)	,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-5, -1)
			   ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-6, -1), DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-7, -1)
			   ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-8, -1)) 
               order by PAYDATE desc'
	END
	ELSE
	BEGIN
	set @sqlqry='SELECT distinct CONVERT(CHAR(4), PAYDATE, 100) + CONVERT(CHAR(4), PAYDATE, 120) AS PAYDATE  FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+'
                where PAYDATE in (''' + @DEFPAYDATE + ''',DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-1, -1)
               ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-2, -1)	,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-3, -1)
               ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-4, -1)	,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-5, -1)
			   ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-6, -1), DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-7, -1)
			   ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-8, -1),DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-9, -1)
			   ,DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-10, -1),DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-11, -1)) 
                order by PAYDATE desc'
	END
	exec(@sqlqry)
	select distinct COMPONENT_NAME from IVAP_MST_COMPONENT_ENTITY where  tid in (select COMPONENT_ID  from 
	IVAP_MST_FILE_COMP_DETAIL where file_id = @FILETYPEID and COMPONENT_DATATYPE='AMOUNT') and ENTITY_ID=@ENTITYID
END
GO
/****** Object:  StoredProcedure [dbo].[GetDataFromQry_Output]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDataFromQry_Output]
(  
 @COMPONENT_NAME varchar(max)='',
 @ENTITYID INT=31,
 @DEFPAYDATE varchar(30)=''
 )  
AS  
declare @sqlqry varchar(max) 

 BEGIN
    exec (@COMPONENT_NAME)
	BEGIN
	set @sqlqry='SELECT distinct CONVERT(CHAR(4), PAYDATE, 100) + CONVERT(CHAR(4), PAYDATE, 120) AS PAYDATE  FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+'
	where PAYDATE in (''' + @DEFPAYDATE + ''',DATEADD(MONTH, DATEDIFF(MONTH, -1, ''' + @DEFPAYDATE + ''')-1, -1))
	order by PAYDATE desc'
	END
	exec (@sqlqry)
	select distinct COMPONENT_NAME from IVAP_MST_COMPONENT_ENTITY where  tid in (select COMPONENT_ID  from 
	IVAP_MST_FILE_COMP_DETAIL where file_id = 129 and COMPONENT_DATATYPE='AMOUNT') and ENTITY_ID=@ENTITYID
END
GO
/****** Object:  StoredProcedure [dbo].[GetDefaultFileDetail]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[GetDefaultFileDetail]
as
	Begin
			select * from ivap_setup_template


	End
GO
/****** Object:  StoredProcedure [dbo].[GetDefaultMenu]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDepartment]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDepartmentHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDesignation]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDesignationHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDivision]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDivisionHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetDSGName]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetEffDatecheck]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetEffDatecheck1]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData_OutPut]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetEffDateTempTableData_OutPut](@File_IDs nvarchar(max) ,@UID INT,@EID INT)
as
begin
	Declare @TableName VARCHAR(2000)='Ivap_TEMP_HIS_'+cast(@EID As VARCHAR);
	
	DECLARE @SqlQuery NVARCHAR(500)  ;
	DECLARE @ParmDefinition nvarchar(Max); 
	if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where COM.COMPONENT_NAME ='PAYDATE' AND FD.FILE_ID in(select * from SplitString(@File_IDs,',')))
	BEGIN
		set @SqlQuery= 'select Upper(Replace(convert(varchar,paydate,106),'' '',''-'')) AS PAYDATE,File_Name,temp.File_ID,count(*) TOTAL from ' +@TableName+ ' temp inner join IVAP_MST_FILETYPE ft on temp.File_id=ft.tid  where temp.CREATED_BY='+cast(@UID as varchar)+' AND  FILE_ID in (select * from SplitString('''+@File_IDs+''','','')) group by Upper(Replace(convert(varchar,paydate,106),'' '',''-'')),File_Name,temp.File_ID'
	END
	ELSE
		set @SqlQuery= 'select ''ALL'' As PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+ ' AND FILE_ID in (select * from SplitString('''+@File_IDs+''','',''))'
	SET @ParmDefinition = N'@File_IDs nvarchar(Max) ,@TableName varchar(100)'; 
	print @SqlQuery
	EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_IDs,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData_OutPut0]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetEffDateTempTableData_OutPut0]
(
@File_IDs nvarchar(max) ,
@UID INT,
@EID INT,
@PayDate nvarchar(10)
)
as
begin
	Declare @TableName VARCHAR(2000)='Ivap_TEMP_HIS_'+cast(@EID As VARCHAR);
	
	DECLARE @SqlQuery NVARCHAR(500)  ;
	DECLARE @ParmDefinition nvarchar(Max); 
	if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where COM.COMPONENT_NAME ='PAYDATE' AND FD.FILE_ID in(select * from SplitString(@File_IDs,',')))
	BEGIN
		set @SqlQuery= 'select Upper(Replace(convert(varchar,paydate,106),'' '',''-'')) AS PAYDATE,File_Name,temp.File_ID,count(*) TOTAL from ' +@TableName+ ' temp inner join IVAP_MST_FILETYPE ft on temp.File_id=ft.tid  where convert(varchar,temp.Paydate,103)='''+@PayDate +'''  and temp.CREATED_BY='+cast(@UID as varchar)+' AND  FILE_ID in (select * from SplitString('''+@File_IDs+''','','')) group by Upper(Replace(convert(varchar,paydate,106),'' '',''-'')),File_Name,temp.File_ID'
	END
	ELSE
		set @SqlQuery= 'select ''ALL'' As PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+ ' AND FILE_ID in (select * from SplitString('''+@File_IDs+''','',''))'
	SET @ParmDefinition = N'@File_IDs nvarchar(Max) ,@TableName varchar(100)'; 
	print @SqlQuery
	EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_IDs,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData0]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetEffDateTempTableData0](@File_ID int ,@UID INT,@EID INT)
as
begin
	Declare @TableName VARCHAR(2000)='Ivap_MAST_TEMP_'+cast(@EID As VARCHAR);
	
	DECLARE @SqlQuery NVARCHAR(500)  ;
	DECLARE @ParmDefinition nvarchar(Max); 
	if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where COM.COMPONENT_NAME ='PAYDATE' AND FD.FILE_ID=@File_ID)
	BEGIN
		set @SqlQuery= 'select convert(varchar(11),PAYDATE,101) AS PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+' AND  FILE_ID='+convert(varchar(10),@File_ID)+' group by convert(varchar(11),PAYDATE,101)'
	END
	ELSE
		set @SqlQuery= 'select ''ALL'' As PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+ ' AND FILE_ID='+convert(varchar(10),@File_ID);
	SET @ParmDefinition = N'@File_ID int ,@TableName varchar(100)'; 
	EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData00]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetEffDateTempTableData00](@File_ID int ,@UID INT,@EID INT)
as
begin
	Declare @TableName VARCHAR(2000)='Ivap_MAST_TEMP_'+cast(@EID As VARCHAR);
	
	DECLARE @SqlQuery NVARCHAR(500)  ;
	DECLARE @ParmDefinition nvarchar(Max); 
	if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where COM.COMPONENT_NAME ='PAYDATE' AND FD.FILE_ID=@File_ID)
	BEGIN
	set @SqlQuery='select (select top 1 * from SplitString(PAYDATE , '' '')) as PAYDATE from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+' AND  FILE_ID='+convert(varchar(10),@File_ID)+''
		--set @SqlQuery= 'select convert(varchar(10),PAYDATE,101) AS PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+' AND  FILE_ID='+convert(varchar(10),@File_ID)+' group by convert(varchar(10),PAYDATE,101)'
		SET @SqlQuery=N'WITH Data AS
				(' + @SqlQuery+')
	select PAYDATE,count(*) TOTAL from Data group by PAYDATE'
	END
	ELSE
		set @SqlQuery= 'select ''ALL'' As PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+ ' AND FILE_ID='+convert(varchar(10),@File_ID);

		--print @SqlQuery;
	SET @ParmDefinition = N'@File_ID int ,@TableName varchar(100)'; 
	EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@TableName
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData0New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetEffDateTempTableData0New](@File_ID int ,@UID INT,@EID INT)  
as  
begin  
 Declare @TableName VARCHAR(2000)='Ivap_MAST_TEMP_'+cast(@EID As VARCHAR);  
   
 DECLARE @SqlQuery NVARCHAR(500)  ;  
 DECLARE @ParmDefinition nvarchar(Max);   
 if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where COM.COMPONENT_NAME ='PAYDATE' AND FD.FILE_ID=@File_ID)  
 BEGIN  
  set @SqlQuery= 'select PAYDATE ,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+' AND  FILE_ID='+convert(varchar(10),@File_ID)+' group by PAYDATE'  
 END  
 ELSE  
  set @SqlQuery= 'select ''ALL'' As PAYDATE,count(*) TOTAL from ' +@TableName+ ' where CREATED_BY='+cast(@UID as varchar)+ ' AND FILE_ID='+convert(varchar(10),@File_ID);  
 SET @ParmDefinition = N'@File_ID int ,@TableName varchar(100)';   
 EXECUTE sp_executesql @SqlQuery ,@ParmDefinition, @File_ID,@TableName  
end
GO
/****** Object:  StoredProcedure [dbo].[GetEffDateTempTableData1]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetEntity]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetEntity]
(
	@EntityID INT=37,
	@IsAct VARCHAR(1)='1'
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
Payperiod_Monthly_To,Payperiod_Fortnightly_Fr1,Payperiod_Fortnightly_To1,Payperiod_Fortnightly_Fr2,Payperiod_Fortnightly_To2,Services_Availed
FROM IVAP_MST_ENTITY E 
INNER JOIN IVAP_MST_STATE S ON S.TID=E.ENTITY_STATE 
INNER JOIN IVAP_MST_COUNTRY C ON E.COUNTRY=C.TID 
INNER JOIN IVAP_MST_CURRENCY CR ON E.CURRENCY=CR.TID
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
/****** Object:  StoredProcedure [dbo].[GetEntity_001]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetEntity_001]
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
	SET @SQLString =N'
SELECT E.TID,E.ENTITY_CODE,E.ENTITY_NAME,E.ENTITY_CITY,S.STATE_NAME,E.ENTITY_ADDR1,E.ENTITY_ADDR2,ENTITY_STATE,l.LOC_NAME AS LOCATION_CITY,
E.ENTITY_PIN,CASE WHEN E.ISACTIVE=1 THEN ''Active'' ELSE ''In Active'' END STATUS,DOMAIN_NAME,E.PAY_PERIOD,E.COUNTRY,C.COUNTRY_NAME,CR.CURRENCY_NAME,E.CREATED_BY,
E.CURRENCY,E.DATE_FORMAT,E.ISACTIVE[ISACT],CONVERT(VARCHAR(11),E.CREATED_ON)[CREATED_ON],Payperiod_Weekly_Fr,Payperiod_Weekly_To,Payperiod_Monthly_Fr,
Payperiod_Monthly_To,Payperiod_Fortnightly_Fr1,Payperiod_Fortnightly_To1,Payperiod_Fortnightly_Fr2,Payperiod_Fortnightly_To2,Services_Availed
FROM IVAP_MST_ENTITY E 
left JOIN IVAP_MST_STATE S ON S.TID=E.ENTITY_STATE 
left JOIN IVAP_MST_COUNTRY C ON E.COUNTRY=C.TID 
left JOIN IVAP_MST_LOCATION_GLOBAL L ON convert(varchar,E.ENTITY_CITY)=convert(varchar,L.TID) 
left JOIN IVAP_MST_CURRENCY CR ON E.CURRENCY=CR.TID
--INNER JOIN IVAP_MST_SERVICE_GLOBAL G ON E.Services_Availed=G.TID
WHERE 1=1'
	IF(@EntityID > 0)
	BEGIN
		SET @SQLString+=' AND E.TID=' + '@EntityID'
	END
	--IF(len(@IsAct) > 0)
	--BEGIN
	--	SET @SQLString+=' AND E.ISACTIVE=' + '@IsAct'
	--END
	set @SQLString = @SQLString+' order by E.TID desc' 
	SET @ParmDefinition = N'@EntityID int,@IsAct VARCHAR(1) '; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @EntityID,@IsAct
	--print @SQLString
	--SELECT * FROM IVAP_MST_ENTITY
END

GO
/****** Object:  StoredProcedure [dbo].[GetEntityComponent]    Script Date: 03-06-2019 19:23:41 ******/
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
		select TID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DISPLAY_NAME from IVAP_MST_COMPONENT_ENTITY with (nolock)
		where ISACTIVE=1 AND ENTITY_ID=@EID
		and TID NOT IN (select * from dbo.SplitString(@Entity_Component_ID,','))
		and TID not in (select COMPONENT_ID from IVAP_MST_FILE_COMP_DETAIL where FILE_ID =@FileID) AND ISNULL(@isTable,'') <> ''
		order by COMPONENT_NAME
	END
	ELSE
	BEGIN
		select TID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DISPLAY_NAME from IVAP_MST_COMPONENT_ENTITY with (nolock)
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
/****** Object:  StoredProcedure [dbo].[GetEntityDtl]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetExceptionDashBoard]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetExceptionDashBoard]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
declare @SqlQuery varchar(max)='';  
	 set @SqlQuery='select ''Live employee However Salary Not processed'' AS Type,Count(*) TotalCount  from  Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC Master''
       and F.file_type=''PMS Output File'' and Temp.EMP_CODE not in (
       select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File''
       )

	   union all
	   select ''Zero Attendance'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and PAYDAYS=0

	   union all
	   select ''Missing Bank Account'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and len(Temp.BANKACNO)=0

	   union all
	   select ''Missing DOB'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and len(Temp.DOB)=0

	   union all
	   select ''Missing UAN'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and len(Temp.UAN)=0

	   union all

	   select ''Missing PAN'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and len(Temp.PANNO)=0

	   UNION ALL
	   select ''Age less than 18 Years'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and datediff(YEAR,DOB,getdate())<18

	   UNION ALL
	   select ''Age greater than 60 Years'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and datediff(YEAR,DOB,getdate())>60'
	   exec (@SqlQuery) 
	   --print @SqlQuery
END



GO
/****** Object:  StoredProcedure [dbo].[GetExceptionDashBoard_New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetExceptionDashBoard_New]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
declare @SqlQuery varchar(max)='';  
	 set @SqlQuery='select ''Live employee However Salary Not processed'' AS Type,Count(*) TotalCount  from  Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC Master''
       and F.file_type=''PMS Output File'' and Temp.EMP_CODE not in (
       select Distinct  EMP_CODE from IVAP_TEMP_HIS_31 Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File''
       )

	   union all
	   select ''Zero Attendance'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and PAYDAYS=0

	   union all
	   select ''Missing Bank Account'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and len(Temp.BANKACNO)=0

	   union all
	   select ''Missing DOB'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and len(Temp.DOB)=0

	   union all
	   select ''Missing UAN'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and len(Temp.UAN)=0

	   union all

	   select ''Missing PAN'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and len(Temp.PANNO)=0

	   UNION ALL
	   select ''Age less than 18 Years'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and datediff(YEAR,DOB,getdate())<18

	   UNION ALL
	   select ''Age greater than 60 Years'' AS Type ,Count(*) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''Pay Register''
       and F.file_type=''PMS Output File'' and datediff(YEAR,DOB,getdate())>60'
	   exec (@SqlQuery) 
	   --print @SqlQuery
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileCompDtl]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetFileCompDtl]   --136,15       
(            
 @FILE_ID INT=11,            
 @EID INT =1           
)            
AS            
BEGIN            
 SELECT FD.TID,FD.FILE_ID,FD.Display_Order,FD.Spl_Field_Type,F.FILE_NAME,F.FILE_TYPE,E.COMPONENT_NAME,FD.COMPONENT_DISPLAY_NAME as File_COMPONENT_DISPLAY_NAME,E.COMPONENT_DISPLAY_NAME FROM IVAP_MST_FILE_COMP_DETAIL FD            
 left JOIN IVAP_MST_FILETYPE F ON FD.FILE_ID = F.TID            
 left JOIN IVAP_MST_COMPONENT_ENTITY E ON FD.COMPONENT_ID = E.TID AND E.ENTITY_ID=@EID          
 WHERE FD.FILE_ID =@FILE_ID AND F.ENTITY_ID =@EID ORDER BY Display_Order            
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileCompDtl_New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetFileCompDtl_New]   --136,15       
(            
 @FILE_ID INT=11,            
 @EID INT =1           
)            
AS            
BEGIN            
 SELECT FD.TID,FD.FILE_ID,FD.Display_Order,FD.Spl_Field_Type,F.FILE_NAME,F.FILE_TYPE,E.COMPONENT_NAME,FD.COMPONENT_DISPLAY_NAME as File_COMPONENT_DISPLAY_NAME,E.COMPONENT_DISPLAY_NAME FROM IVAP_MST_FILE_COMP_DETAIL FD            
 Left JOIN IVAP_MST_FILETYPE F ON FD.FILE_ID = F.TID            
 Left JOIN IVAP_MST_COMPONENT_ENTITY E ON FD.COMPONENT_ID = E.TID AND E.ENTITY_ID=@EID          
 WHERE FD.FILE_ID =@FILE_ID AND F.ENTITY_ID =@EID ORDER BY Display_Order            
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileComponent]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[GetFileComponent]       
 (      
   @TID int      
 )      
      
 as      
 Begin      
      
   select FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,isnull(COMPONENT_FILE_TYPE,'') as COMPONENT_FILE_TYPE,
   isnull(COMPONENT_TYPE,'')as COMPONENT_TYPE,isnull(COMPONENT_SUB_TYPE,'') as COMPONENT_SUB_TYPE,isnull(COMPONENT_NAME,'') as COMPONENT_NAME    
  ,isnull(COMPONENT_DATATYPE,'') as COMPONENT_DATATYPE,isnull(COMPONENT_TABLE_NAME,'') as COMPONENT_TABLE_NAME,ISNULL(EXTRA_INPUT_VALIDATION,'') AS EXTRA_INPUT_VALIDATION,
  ISNULL(EXTRA_RG_EXPRESSION,'') AS EXTRA_RG_EXPRESSION,      
  isnull(COMPONENT_COLUMN_NAME,'') as COMPONENT_COLUMN_NAME,isnull(COMPONENT_DISPLAY_NAME,'') as COMPONENT_DISPLAY_NAME,isnull(COMPONENT_DESCRIPTION,'') as COMPONENT_DESCRIPTION,ISACTIVE,
  case when  ISACTIVE=1 then 'ACTIVE' else 'INACTIVE' end STATUS,FILE_ID,     
  isnull(MIN_LENGTH,'') as MIN_LENGTH,isnull(MAX_LENGTH,'') as MAX_LENGTH,isnull(MANDATORY,'') as MANDATORY,isnull(HAS_RULE,'') as HAS_RULE,Globle_Component_ID,isnull(GL_Code,'') as GL_Code,
  isnull(PMS_CODE,'') as PMS_CODE from IVAP_MST_FILE_COMP_DETAIL where TID=@TID      
      
 End 
GO
/****** Object:  StoredProcedure [dbo].[GetFileComponent0214]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetFileComponent0214] 
(
@FileDetID int =0 ,     
 @ENTITY_ID INT=0,
 @EntityCompID int ,
 @CheckDetl varchar(10)=''
)
as
Begin
DECLARE @SQLString nvarchar(Max);  
DECLARE @ParmDefinition nvarchar(Max);   
if(@CheckDetl='')
begin
set @SQLString =N'select CD.TID,FILE_ID,COMPONENT_ID,CD.CREATED_BY,CD.Display_Order,CD.ENTITY_ID,isnull(CD.COMPONENT_FILE_TYPE,'''') as COMPONENT_FILE_TYPE,isnull(CD.COMPONENT_TYPE,'''')as COMPONENT_TYPE,isnull(CD.COMPONENT_SUB_TYPE,'''') 
as COMPONENT_SUB_TYPE,isnull(CD.COMPONENT_NAME,'''') as COMPONENT_NAME
,isnull(CD.COMPONENT_DATATYPE,'''') as COMPONENT_DATATYPE,isnull(CD.COMPONENT_TABLE_NAME,'''') as COMPONENT_TABLE_NAME,
isnull(CD.COMPONENT_COLUMN_NAME,'''') as COMPONENT_COLUMN_NAME,isnull(CD.COMPONENT_DISPLAY_NAME,'''') as COMPONENT_DISPLAY_NAME,isnull(CD.COMPONENT_DESCRIPTION,'''') as COMPONENT_DESCRIPTION,CD.ISACTIVE,
isnull(CD.MIN_LENGTH,'''') as MIN_LENGTH,isnull(CD.MAX_LENGTH,'''') as MAX_LENGTH,isnull(CD.MANDATORY,'''') as MANDATORY,isnull(CD.HAS_RULE,'''') as HAS_RULE,CD.Globle_Component_ID,isnull(CD.GL_Code,'''') as GL_Code,isnull(CD.PMS_CODE,'''') as PMS_CODE,
FT.CATEGORY,FT.FILE_TYPE,FT.FILE_NAME
 from IVAP_MST_FILE_COMP_DETAIL CD 
inner join IVAP_MST_FILETYPE FT on CD.FILE_ID=FT.TID
where 1=1' 
IF(@FileDetID > 0)    
 BEGIN    
  SET @SQLString+=' AND CD.TID=' + '@FileDetID'    
 END 
 IF(@ENTITY_ID > 0)    
 BEGIN    
  SET @SQLString+=' AND CD.ENTITY_ID=' + '@ENTITY_ID'    
 END 
  IF(@EntityCompID > 0)    
 BEGIN    
  SET @SQLString+=' AND CD.COMPONENT_ID=' + '@EntityCompID'    
 END 
 --Print @SQLString
SET @ParmDefinition = N'@FileDetID int,@ENTITY_ID INT, @EntityCompID int';     
EXECUTE sp_executesql @SQLString, @ParmDefinition, @FileDetID,@ENTITY_ID,@EntityCompID
end
if(@CheckDetl='CheckDTL')
begin
select  Count(CD.TID) TotalRecord
 from IVAP_MST_FILE_COMP_DETAIL CD 
inner join IVAP_MST_FILETYPE FT on CD.FILE_ID=FT.TID
where  CD.ENTITY_ID=@ENTITY_ID and CD.COMPONENT_ID=@EntityCompID
end
End
GO
/****** Object:  StoredProcedure [dbo].[GetFileComponentHis]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE proc [dbo].[GetFileComponentHis]   
  (  
   @TID int  
  )  
 as  
 begin  
	Select FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,
	COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,
	HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE,ACTION,ISACTIVE, FORMAT(UPDATED_ON, 'dd/MMM/yyyy', 'en-us') as UPDATED_ON,CASE WHEN ISACTIVE=1 THEN 'ACTIVE' ELSE 'INACTIVE' END STATUS from IVAP_HIS_FILE_COMP_DETAIL where FID=@TID  
 end
GO
/****** Object:  StoredProcedure [dbo].[GetFileExplorer]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ivap_mst_user
CREATE PROC [dbo].[GetFileExplorer]
(
	@EID INT=27,
	@ParrentID INT=0,
	@FileID INT =0,
	@UID INT =42
)
AS
BEGIN
	declare @URole int 
	DECLARE @SqlQuery NVARCHAR(MAX) =''
	--declare @CustomerFilter int ,@CompanyFilter int,@ContractorFilter int 
	--select @Urole= [Role],@CompanyFilter = Company ,@Customerfilter =Customer,@ContractorFilter = Contractor from Ecom_Mst_User where UID =@UID
	IF(@FileID = -1)
	BEGIN
		SET @SqlQuery ='SELECT distinct 0 FileID, E.ENTITY_ID EID,E.USERID EntityName,
						CASE WHEN EXISTS (SELECT * FROM IVAP_Mst_Files F WHERE EID = E.ENTITY_ID AND F.FileType=''Folder'' AND F.IsActive=1) THEN 1 ELSE 0 END hasChildren,
						'''' UserRights
						FROM IVAP_MST_USER E
						WHERE 1=1 AND E.UID = '+CAST(@UID AS VARCHAR)+''
	END
	ELSE
	BEGIN
		IF(@FileID =0)
		BEGIN
			SET @SqlQuery = 'SELECT distinct FileID,EID,FileOriginalName,PID,CASE WHEN EXISTS (SELECT * FROM IVAP_Mst_Files WHERE PID = F.FileID AND IsActive=1) 
							THEN 1 ELSE 0 END hasChildren,ISNULL(UserRights,'''') UserRights FROM IVAP_Mst_Files F
							INNER JOIN IVAP_Mst_ENTITY E ON F.EID = E.TID
							WHERE EID = '+CAST(@EID AS VARCHAR)+' AND PID =0 AND F.FileType=''Folder'' AND F.IsActive=1'
		END
		ELSE
		BEGIN
			SET @SqlQuery = 'SELECT distinct FileID,EID,FileOriginalName,PID,CASE WHEN EXISTS (SELECT * FROM IVAP_Mst_Files WHERE PID = F.FileID AND IsActive=1) 
							THEN 1 ELSE 0 END hasChildren,ISNULL(UserRights,'''') UserRights FROM IVAP_Mst_Files F
							INNER JOIN IVAP_Mst_ENTITY E ON F.EID = E.TID
							WHERE EID = '+CAST(@EID AS VARCHAR)+' AND PID ='+CAST(@FileID AS VARCHAR)+' AND F.FileType=''Folder'' AND F.IsActive=1'
		END
	END
	PRINT @SqlQuery
	EXEC(@SqlQuery)
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileExplorerByFileID]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetFileExplorerByFileID]
(
	@FileID INT
)
AS
BEGIN
	SELECT FileID,UserRights FROM Ivap_Mst_Files WHERE FileID =@FileID
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileExt]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetFileInfo]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetFileInfo]--- 70
(
	@FileID INT =3
)
AS
BEGIN
	SELECT F.FileID,F.EID,F.FileType,FileOriginalName,FileTypeName,MetaValue , F.PID FROM IVAP_Mst_Files F
		INNER JOIN IVAP_MST_ENTITY E ON E.TID = F.EID
	 WHERE FileID =@FileID
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileMetaData]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetFileMetaData]
(
	@EID INT =32,
	@FileMetaID INT =1
)
AS
BEGIN
	IF(@FileMetaID =0)
		SELECT FileMetaID, EID,Description,MetaData,FileTypeName FROM IVAP_Mst_FileMetaData WHERE EID = @EID
	ELSE
		SELECT FileMetaID, EID,Description,MetaData,FileTypeName FROM IVAP_Mst_FileMetaData WHERE EID = @EID AND FileMetaID =@FileMetaID
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileType]    Script Date: 03-06-2019 19:23:41 ******/
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
 SET @SQLString =N'SELECT F.TID,F.ENTITY_ID,F.FILE_TYPE,F.CATEGORY,F.FILE_NAME,F.FILE_DESC,F.Payroll_Input_File,format(F.DUE_DATE,''dd/MM/yyyy'') DUE_DATE,F.CREATED_ON,      
     CASE WHEN F.ISACTIVE =1 THEN ''Active'' ELSE ''Is Active'' END STATUS,E.ENTITY_NAME,E.ENTITY_CODE,F.ISACTIVE ,F.FILE_NAME+'' (''+F.FILE_TYPE+'')'' WFS_FILENAME,  
  F.FILE_NAME+''(''+F.CATEGORY+'')'' As InputUploadFileName,ISNULL(F.Transpose,'''') Transpose  
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
/****** Object:  StoredProcedure [dbo].[GetFileTypeDB]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetFileTypeDB] 
(  
 @ENTITY_ID int =15  
)  
as  
Begin  
 declare @SqlQuery varchar(max)='';  
  
 set @SqlQuery='select ft.Tid as TID,count(mt.TID) as COUNTS,upper(File_Name) as File_Name,upper(CATEGORY) as CATEGORY,''20'' AS APPROVED,''50'' AS ''PENDING'' 
from IVAP_MST_FILETYPE ft inner join ivap_mast_temp_'+Cast(@ENTITY_ID as varchar)+' as mt on ft.tid=mt.file_id where 
ft.entity_id='+Cast(@ENTITY_ID as varchar)+' and ft.file_Type in(''Payroll Input File'') group by ft.Tid,ft.File_Name,CATEGORY '  
 print(@SqlQuery)  
 --and left(paydate,10) 
 --group by ft.Tid,
 exec (@SqlQuery)  
End

GO
/****** Object:  StoredProcedure [dbo].[GetFileTypeDB_NEW]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetFileTypeDB_NEW] 
(  
 @ENTITY_ID int=31,
 @UID int=92,
 @ROLENAME varchar(100)='mynd_MAKER',
 @PAYDATE varchar(40)='2018-12-31'
)  
as  
Begin  
 declare @SqlQuery varchar(max)='';  
 declare @SqlQueryOutput varchar(max)='';
 set @SqlQuery='with cte as(
select ft.TID AS FILETYPEID, dbo.CapitalizeFirstLetter(File_Name) as File_Name,upper(ft.CATEGORY) as CATEGORY,
(SELECT ISNULL(COUNT('+ @ROLENAME +'),0)  FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
convert(date,paydate)=convert(date,''' + @PAYDATE + ''')   AND file_id=ft.tid) AS TOTAL,

 ((SELECT ISNULL(COUNT('+ @ROLENAME +'),0)  FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
 convert(date,paydate)=convert(date,''' + @PAYDATE + ''')   AND file_id=ft.tid)-
 (SELECT ISNULL(COUNT(CURR_USER),0) FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
  CURR_USER='+Cast(@UID as varchar)+'  and convert(date,paydate)=convert(date,''' + @PAYDATE + ''')   AND file_id=ft.tid)) AS APPROVED ,

  (SELECT ISNULL(COUNT(CURR_USER),0) FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
  CURR_USER='+Cast(@UID as varchar)+'  and convert(date,paydate)=convert(date,''' + @PAYDATE + ''')   AND file_id=ft.tid) AS PENDING

 
from IVAP_MST_FILETYPE ft inner join Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' as mt on ft.tid=mt.file_id where 
ft.entity_id='+Cast(@ENTITY_ID as varchar)+'  
and convert(date,paydate)=convert(date,''' + @PAYDATE + ''')  and file_type=''Payroll Input File'' 
group by ft.Tid,ft.File_Name,CATEGORY) select * from cte where TOTAL<>0' 

set @SqlQueryOutput='with cte as( select ft.TID AS FILETYPEID, dbo.CapitalizeFirstLetter(File_Name) as File_Name,upper(ft.CATEGORY) as CATEGORY,
(SELECT ISNULL(COUNT('+ @ROLENAME +'),0)  FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
convert(date,paydate)=convert(date,''' + @PAYDATE + ''')   AND file_id=ft.tid) AS TOTAL,

 ((SELECT ISNULL(COUNT('+ @ROLENAME +'),0)  FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
 convert(date,paydate)=convert(date,''' + @PAYDATE + ''')   AND file_id=ft.tid)-
 (SELECT ISNULL(COUNT(CURR_USER),0) FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
  CURR_USER='+Cast(@UID as varchar)+'  and convert(date,paydate)=convert(date,''' + @PAYDATE + ''')   AND file_id=ft.tid)) AS APPROVED ,

  (SELECT ISNULL(COUNT(CURR_USER),0) FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
  CURR_USER='+Cast(@UID as varchar)+'  and convert(date,paydate)=convert(date,''' + @PAYDATE + ''')   AND file_id=ft.tid) AS PENDING

from IVAP_MST_FILETYPE ft inner join Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' as mt on ft.tid=mt.file_id where 
ft.entity_id='+Cast(@ENTITY_ID as varchar)+'  
and convert(date,paydate)=convert(date,''' + @PAYDATE + ''')  and file_type=''PMS Output File'' 
group by ft.Tid,ft.File_Name,CATEGORY) select * from cte where TOTAL<>0'  
--print(@SqlQuery)  
--print(@SqlQueryOutput) 
exec (@SqlQuery)  
exec (@SqlQueryOutput)  
End
GO
/****** Object:  StoredProcedure [dbo].[GetFileTypeDB_Old]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetFileTypeDB_Old]
(  
 @ENTITY_ID int =15  
)  
as  
Begin  
 declare @SqlQuery varchar(max)='';  
  
 set @SqlQuery=' select count(mt.TID) as COUNTS, ft.Tid,File_Name from IVAP_MST_FILETYPE ft   
 inner join ivap_mast_temp_'+Cast(@ENTITY_ID as varchar)+' as mt on ft.tid=mt.file_id where ft.entity_id='+Cast(@ENTITY_ID as varchar)+'   
 and ft.file_Type in(''Payroll Input File'') and left(PAY_DATE,10) in(select Convert(varchar,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),103))  group by ft.Tid,ft.File_Name '  
 print(@SqlQuery)  
 exec (@SqlQuery)  
End
GO
/****** Object:  StoredProcedure [dbo].[GetFileTypeDB_Output]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetFileTypeDB_Output]
(  
 @ENTITY_ID int,
 @UID int,
 @ROLENAME varchar(100),
 @PAYDATE varchar(40)
)  
as  
Begin  
 declare @SqlQuery varchar(max)='';  
 set @SqlQuery='select ft.TID AS FILETYPEID, dbo.CapitalizeFirstLetter(File_Name) as File_Name,upper(ft.CATEGORY) as CATEGORY,
COUNT('+ @ROLENAME +') AS APPROVED,
(SELECT ISNULL(COUNT(CURR_USER),0) FROM Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' WHERE 
 CURR_USER='+Cast(@UID as varchar)+' and convert(date,paydate)=convert(date,''' + @PAYDATE + ''')  AND file_id=ft.tid) AS PENDING
from IVAP_MST_FILETYPE ft inner join Ivap_TEMP_HIS_'+Cast(@ENTITY_ID as varchar)+' as mt on ft.tid=mt.file_id where 
ft.entity_id='+Cast(@ENTITY_ID as varchar)+'  AND '+ @ROLENAME +'='+Cast(@UID as varchar)+' 
and convert(date,mt.paydate)=convert(date,''' + @PAYDATE + ''') and ft.file_type=''Payroll Output File''  group by ft.Tid,ft.File_Name,CATEGORY'  
--print(@SqlQuery)  
exec (@SqlQuery)  
End
GO
/****** Object:  StoredProcedure [dbo].[GetFileTypeForWfSetting]    Script Date: 03-06-2019 19:23:41 ******/
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
	SELECT F.TID,F.FILE_TYPE,isnull(F.CATEGORY,'N/A') As CATEGORY,F.FILE_NAME,F.FILE_DESC,case  when  WF.FILE_ID is not null then 'Active' else 'In-Active' end WFAction
     FROM IVAP_MST_FILETYPE F  
	 left join   (select  Distinct Entity_ID,FILE_ID from IVAP_MST_WorkFlowSetting where ENTITY_ID=@ENTITY_ID) WF ON WF.FILE_ID=F.TID
     WHERE F.ISACTIVE =1  and F.ENTITY_ID=@ENTITY_ID and F.FILE_TYPE=@FILE_TYPE  AND F.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = Cast(@UID AS VARCHAR) AND TABLE_NAME ='IVAP_MST_FILETYPE'),''))
	 
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileTypeForWfSetting13]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[GetFileTypeForWfSetting13]    
(    
 @ENTITY_ID INT=1,    
 @FILE_TYPE VARCHAR(50)='Payroll Input File',    
 @UID INT=0 
)    
AS    
BEGIN    
DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);   
 SET NOCOUNT ON    
	SET @SQLString =N'SELECT F.TID,F.FILE_TYPE,isnull(F.CATEGORY,''N/A'') As CATEGORY,F.FILE_NAME,F.FILE_DESC,case  when  WF.FILE_ID is not null then ''Active'' else ''In-Active'' end WFAction
     FROM IVAP_MST_FILETYPE F  
	 left join   (select  Distinct Entity_ID,FILE_ID from IVAP_MST_WorkFlowSetting where ENTITY_ID=@ENTITY_ID) WF ON WF.FILE_ID=F.TID
     WHERE F.ISACTIVE =1  and F.ENTITY_ID=@ENTITY_ID and F.FILE_TYPE=@FILE_TYPE'
	 
	  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND F.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_FILETYPE''),'',''))'  
 END  
  SET @ParmDefinition = N'@ENTITY_ID INT,@FILE_TYPE VARCHAR(50), @UID INT ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @ENTITY_ID,@FILE_TYPE,@UID  
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileTypeForWfSetting131]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFileTypeForWfSetting131]   
(    
 @ENTITY_ID INT=1,    
 @FILE_TYPE VARCHAR(50)='',    
 @UID INT=0 
)    
AS    
BEGIN    
DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);   
 SET NOCOUNT ON    
	SET @SQLString =N'SELECT F.TID,F.FILE_TYPE,isnull(F.CATEGORY,''N/A'') As CATEGORY,F.FILE_NAME,F.FILE_DESC,case  when  WF.FILE_ID is not null then ''Active'' else ''In-Active'' end WFAction
     FROM IVAP_MST_FILETYPE F  
	 left join   (select  Distinct Entity_ID,FILE_ID from IVAP_MST_WorkFlowSetting where ENTITY_ID=@ENTITY_ID) WF ON WF.FILE_ID=F.TID
     WHERE F.ISACTIVE =1  and F.ENTITY_ID=@ENTITY_ID'
	 
	  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND F.TID IN(SELECT * from dbo.SplitString((SELECT TIDS FROM IVAP_DATA_ACCESS_DTL WHERE UID = '+Cast(@UID AS VARCHAR)+' AND TABLE_NAME =''IVAP_MST_FILETYPE''),'',''))'  
 END  
 --print @SQLString
  SET @ParmDefinition = N'@ENTITY_ID INT,@FILE_TYPE VARCHAR(50), @UID INT ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @ENTITY_ID,@FILE_TYPE,@UID  
END
GO
/****** Object:  StoredProcedure [dbo].[GetFunction]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetFunctionHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetGComponentTableName]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetGComponentTableName](@TableName varchar(50)='',@FieldName varchar(200))
as
begin
if(isnull(@TableName,'')='')
begin
select distinct TABLE_NAME,SCREEN_NAME from IVAP_META_MASTER_DEFAULT order by SCREEN_NAME
end
if(isnull(@TableName,'')!='')
begin
select distinct FIELD_NAME,DISPLAY_NAME from IVAP_META_MASTER_DEFAULT where UPPER(TABLE_NAME)=UPPER(@TableName) and FIELD_NAME!='ISACTIVE' order by DISPLAY_NAME 
end

if(isnull(@TableName,'')!='' and isnull(@FieldName,'')!='')
begin
select distinct FIELD_NAME,DISPLAY_NAME from IVAP_META_MASTER_DEFAULT where UPPER(TABLE_NAME)=UPPER(@TableName) and UPPER(DISPLAY_NAME)=UPPER(@FieldName) and FIELD_NAME!='ISACTIVE'
end
end
GO
/****** Object:  StoredProcedure [dbo].[GETGLOBALBANK]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetGlobalLocation]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetGlobalLocationHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetGlobleComponent]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetGrade]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetGradHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetGridGlobalLocation]    Script Date: 03-06-2019 19:23:41 ******/
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
	IF (ISNULL(@FromNumber,0)<> 0)
	BEGIN
		SET @SQLString=@SQLString+N' WHERE RowNumber BETWEEN '+@FromNumber+' AND '+@ToNumber --BETWEEN is inclusive
	END
                   
    --print @SQLString                          
 EXECUTE sp_executesql @SQLString
 EXECUTE sp_executesql @SQLQueryCount

END
GO
/****** Object:  StoredProcedure [dbo].[GetGridUsers]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetHeadCountDB]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetHeadCountDB] 
(  
 @ENTITYID int =31,
 @PAYDATE varchar(20)
)  
as  
declare @sqlqry varchar(max)
Begin  
set @sqlqry='SELECT ''Opening Balance''[Category],count(*)[Value],0 as CTC FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+' 
union all
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')
union all
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')
union all
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')
union all
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')
union all
SELECT ''Closing Balance''[Category],
(


(SELECT count(*) FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+')
+
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +'''))
-
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''Resignation'',''Transfer Out'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')))[Value],0 as CTC
union all
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Package Change'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''')'

exec (@sqlqry)
--print @sqlqry
End
GO
/****** Object:  StoredProcedure [dbo].[GetHeadCountDB_01]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetHeadCountDB_01]
(  
 @ENTITYID int =37,
 @PAYDATE varchar(20)='2019-05-31',
 @PREV_PAYDATE varchar(20)='2019-04-30'
)  
as  
declare @sqlqry_Input varchar(max)
declare @sqlqry_Output varchar(max)
Begin  
set @sqlqry_Input='
SELECT ''Opening Balance''[Category],count(emp_code)[Value],0 as CTC FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''CTC MASTER'' and convert(date,his.paydate)=convert(date,'''+ @PREV_PAYDATE +''')
union all
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''
union all
SELECT ''Closing Balance''[Category],
(

(SELECT count(emp_code)[Value] FROM Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''CTC MASTER'' and convert(date,his.paydate)=convert(date,'''+ @PREV_PAYDATE +'''))


+
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File'')
-
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''Resignation'',''Transfer Out'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''Payroll Input File''))[Value],0 as CTC
union all
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join 
IVAP_MST_FILETYPE f on his.FILE_ID=f.TID where f.CATEGORY=''Package Change'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') 
and f.file_type=''Payroll Input File'''

set @sqlqry_Output='SELECT ''Opening Balance''[Category],count(*)[Value],0 as CTC FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+' 
union all
select ''New Joinee''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC 
from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''New Joiner'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
select ''Transfer In''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer InP'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
select ''Transfer Out''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Transfer Out'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
select ''Resigned''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Resignation'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''
union all
SELECT ''Closing Balance''[Category],
(


(SELECT count(*) FROM Ivap_HRD_MAST_'+Cast(@ENTITYID as varchar)+')
+
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''New Joiner'',''Transfer Inp'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File'')
-
(select count(*) from  Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his 
inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY in(''Resignation'',''Transfer Out'') and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File''))[Value],0 as CTC
union all
select ''Package Change''[Category],count(*)[Value],ISNULL(SUM(ISNULL(cast(his.ctc as decimal),0)),0) as CTC from Ivap_TEMP_HIS_'+Cast(@ENTITYID as varchar)+' his inner join IVAP_MST_FILETYPE f on his.FILE_ID=f.TID 
where f.CATEGORY=''Package Change'' and convert(date,his.paydate)=convert(date,'''+ @PAYDATE +''') and f.file_type=''PMS Output File'''


exec (@sqlqry_Input)
exec (@sqlqry_Output)
--print @sqlqry
End
GO
/****** Object:  StoredProcedure [dbo].[GetInputFileID]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[GetInputFileID]
(
@File_Name nvarchar(200)='',
@Entity_ID int=0
)
as
declare @Count int =0;
	Begin
			select  @Count=tid from IVAP_MST_FILETYPE where ENTITY_ID=@Entity_ID and FILE_NAME= @File_Name and FILE_TYPE='Payroll Input File'

	End
GO
/****** Object:  StoredProcedure [dbo].[GetLeavingReason]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetLeavingReasonHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetLevel]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetLevelHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetLocation]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetLocation]                                
(                              
 @LocID INT=0,                            
 @ParentID INT=0,                                
 @StateID INT=13,  
 @EntityID INT=1,                                 
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
/****** Object:  StoredProcedure [dbo].[GetLocation_Entity]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetLocation_Entity]                               
(                              
 @StateID INT=0
)                                
AS                                
BEGIN     
SELECT GL.LOC_NAME AS GLOBALNAME,GL.TID AS GLOBALLOCTID FROM IVAP_MST_LOCATION_GLOBAL GL WHERE GL.STATE_ID=@StateID                    
END   
GO
/****** Object:  StoredProcedure [dbo].[GetLocationHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetLocationName]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GETLOCNAMEGLOBAL]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetLwf]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetLwfHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetMailSetup]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetMasterMetaData]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetMasterMetaData]  
(  
 @EID INT=27,  
 @SCREEN_NAME VARCHAR(50)='IVAP_MST_BANK',  
 @Menu_Name VARCHAR(50)='ViewBank'  
)  
AS  
BEGIN  
 select TID,DISPLAY_NAME,FIELD_NAME from  IVAP_META_MASTER where ENTITY_ID=@EID AND Table_NAME=@SCREEN_NAME  order by DISPLAY_ORDER
 select Name FROM  IVAP_MST_MENU WHERE ENTITY_ID=@EID AND ROUTE=@Menu_Name AND Menu_Type='MENU';  
END 
GO
/****** Object:  StoredProcedure [dbo].[GetMataMaster]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetMenu]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
			LEFT JOIN IVAP_MST_MENU M1 ON M.TID = M1.PMENU
			WHERE M1.ENTITY_ID =@EID AND M1.NAME IS NOT NULL and M1.ROUTE!='ViewGlobalComponent' ORDER BY M1.ENTITY_ID,M1.PMENU,M1.DISPLAY_ORDER 
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
GO
/****** Object:  StoredProcedure [dbo].[GETMENUACCESSCONTROL]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetMetaDataList]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetMetaDataList]-- 0,1,0,'',45
(
	@FileMetaID int =0,
	@EID int =0
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SQLString nvarchar(Max); 
	DECLARE @ParmDefinition nvarchar(Max); 

	declare @URole int 
	declare @CustomerFilter int ,@CompanyFilter int
	--select @Urole= [Role],@CompanyFilter = Company ,@Customerfilter =Customer from Ecom_Mst_User where UID =@UID

	declare @CustFilter varchar(max)
	
	SET @SQLString =  N'SELECT  metadata.[FileMetaID] ,metadata.[EID] ,metadata.[Description] ,substring( metadata.MetaData,0,len(metadata.MetaData))MetaData,metadata.[CreatedOn]
      ,metadata.[CreatedBy] ,metadata.[FileTypeName],E.ENTITY_NAME [EntityName]
  FROM Ivap_Mst_FileMetaData metadata inner join IVAP_MST_ENTITY E on E.TID = metadata.EID  where 1=1' 

	IF (@FileMetaID>0)
		BEGIN
			SET @SQLString+=' AND metadata.FileMetaID=' + '@FileMetaID'
		END
			
	if (@EID>0)
	begin
	    SET @SQLString+=' AND metadata.EID=' + '@EID'
	end
	
	print ( cast ( @CompanyFilter  as varchar(100)))
	SET @ParmDefinition = N'@FileMetaID int,@EID int '; 
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @FileMetaID ,@EID 

END

--select * from Ivap_Mst_FileMetaData
--select * from IVAP_MST_ENTITY
GO
/****** Object:  StoredProcedure [dbo].[GetMetaDetaFileForSearch]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetMetaDetaFileForSearch]
(
	@EID INT=37,
	@FileID INT=4,
	@text NVARCHAR(500)='123456'
)
AS
BEGIN
	DECLARE @MetaValue VARCHAR(500),@MetaReplace NVARCHAR(500),@Value VARCHAR(500) ='24-Feb-2017', @Filter VARCHAR(MAX),@rowcnt INT
	DECLARE @Query NVARCHAR(MAX)=''
	SET @MetaValue =(select stuff(
	(
		select ',' + CAST(STUFF(t2.MetaData, LEN(t2.MetaData), 1, '') as varchar(MAX)) from IVAP_Mst_FileMetaData t2 where EID =@EID
		for xml path('')
	)
	,1,1,'') as Value)
	Set @Filter =(select stuff(
	(
		select ' OR ' + CAST('MetaValue LIKE ''%' +Value + ':'+@text+'%''' as varchar(MAX)) from [Split](@MetaValue)
		for xml path('') 
	) ,2,2,'') as Value)

	SET @Query = 'SELECT * FROM IVAP_Mst_Files WHERE '+CAST(@Filter As varchar(max)) +' AND EID ='+CAST(@EID As varchar(max)) +' AND PID ='+CAST(@FileID As varchar(max)) +' AND FileType=''File'' AND IsActive=1'
	PRINT @Query
	EXEC Sp_executesql @Query
END
GO
/****** Object:  StoredProcedure [dbo].[GetMinutesItem]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetMinutesItem]
(
@MOM_ID int=0

)
as	
	Begin
			select item_id ITEM_ID,MOM_ID,MoM_Minutes MINUTES, ownership as RESPONSIBILITY,curr_Status as MINUTES_STATUS,CONVERT(VARCHAR(10), Expected_Closure_Date, 103) + ' '  + convert(VARCHAR(8), 
			Expected_Closure_Date, 14) as E_C_D,CONVERT(VARCHAR(10),Actual_Date, 103) + ' '  + convert(VARCHAR(8), Actual_Date, 14) AS A_C_D,REMARKS,
			SYSTEM_FILE_NAME,ORIGINAL_FILE_NAME
			 from ivap_mst_mom_item
			where MOM_ID=@MOM_ID
    end 
GO
/****** Object:  StoredProcedure [dbo].[GetMinWage]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetMinWageHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetMomAttendeesDeatails]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create proc [dbo].[GetMomAttendeesDeatails]
 (
 @MOMID int=0,
 @EntityID int=0
 )
 as
	Begin
			select MEETING_ATTENDEES from IVAP_MST_MOM where tid =@MOMID and ENTITY_ID=@EntityID
	End
GO
/****** Object:  StoredProcedure [dbo].[GetMomCountDeatails]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetMomCountDeatails]    
(     
 @ENTITYID INT =0
)    
AS    
BEGIN    
		;with A(TotalMinutes,TotalPending,TotalClosed,TotalDiscared)
as
(
 select count(i.item_id) TotalMinutes,
 (select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status='Pending') TotalPending
,(select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status='Closed') TotalClosed
,(select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status='Discarded') TotalDiscarded
  from ivap_mst_mom M left join ivap_mst_mom_item i on M.TID=i.MOM_ID  where 1=1 and M.ENTITY_ID=@ENTITYID group by M.TID
)
select sum(TotalMinutes) TotalMinutes,SUM(TotalPending) TotalPending,SUM(TotalClosed) TotalClosed, SUM(TotalDiscared) TotalDiscared from A
		
END
GO
/****** Object:  StoredProcedure [dbo].[GetMomDeatails]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetMomDeatails]    
(    
 @MOMID INT=0,    
 @ENTITYID INT =0,    
 @ISACT VARCHAR(1)='0',  
 @UID INT=0    ,
 @filter nvarchar(10)=''
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
    
 SET @SQLString =N' select M.TID,M.ENTITY_ID,M.MEETING_HELD,M.MEETING_ATTENDEES,M.ADDRESS,M.AGENDA,M.CREATED_ON,M.LASTUPDATE,M.CREATED_BY,case when M.ISACTIVE= 1 then ''Active'' else ''In Active'' end ISACTIVE,count(i.item_id) TotalMinutes
 ,(select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''Pending'') TotalPending
,(select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''Closed'') TotalClosed
,(select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''Discarded'') TotalDiscarded
,(select Count(*) from SplitString(M.MEETING_ATTENDEES,'','')) TotalAttendees
,(select top 1 CONVERT(varchar,Expected_Closure_Date,103) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''PENDING'' and (Expected_Closure_Date<getdate()-1) order by Expected_Closure_Date)PASSED_DATE
  from ivap_mst_mom M left join ivap_mst_mom_item i on M.TID=i.MOM_ID  where 1=1'    
 IF(@MOMID > 0)    
 BEGIN    
  SET @SQLString+=' AND M.TID=' + '@MOMID'    
 END    
 IF(@ENTITYID > 0)    
 BEGIN    
  SET @SQLString+=' AND M.ENTITY_ID=' + '@ENTITYID'    
 END    
 IF(ISNULL(@ISACT,'0') <> '0')    
 BEGIN    
  SET @SQLString+=' AND M.ISACTIVE=' + '@ISACT'    
 END    
  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND M.Created_by in ('+ cast(@UID as varchar)+') '  
 END
if(@filter='Pending')
Begin
		SET @SQLString=@SQLString+' AND i.Curr_Status=''Pending'' '  
End

if(@filter='Discarded')
Begin
		SET @SQLString=@SQLString+' AND i.Curr_Status=''Discarded'' '  
End
 set @SQLString=@SQLString+' group by M.TID,M.ENTITY_ID,M.MEETING_HELD,M.MEETING_ATTENDEES,M.ADDRESS,M.AGENDA,M.CREATED_ON,M.LASTUPDATE,M.CREATED_BY,M.ISACTIVE'    
 if(@filter='Closed')
Begin
		SET @SQLString=@SQLString+' having ((select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''Closed'')=count(i.item_id)) '  
End
 print @SQLString    
 set @SQLString = @SQLString+' order by (select top 1 CONVERT(varchar,Expected_Closure_Date,103) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''PENDING'' and (Expected_Closure_Date<getdate()-1) order by Expected_Closure_Date) desc'     
 SET @ParmDefinition = N'@MOMID int,@ENTITYID INT,@ISACT VARCHAR(1) ';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @MOMID,@ENTITYID,@ISACT    
END

GO
/****** Object:  StoredProcedure [dbo].[GetMomGridDeatails]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[GetMomGridDeatails]    
(    
 @MOMID INT=0,    
 @ENTITYID INT =0,    
 @UID INT=0,
 @STATUS NVARCHAR(20)='All'    
)    
AS    
BEGIN    
 SET NOCOUNT ON    
 DECLARE @SQLString nvarchar(Max);     
 DECLARE @ParmDefinition nvarchar(Max);    
    
 SET @SQLString =N' select M.TID,M.ENTITY_ID,CONVERT(varchar, M.MEETING_HELD,120) MEETING_HELD,M.MEETING_ATTENDEES,M.ADDRESS,M.AGENDA,M.CREATED_ON,M.LASTUPDATE,M.CREATED_BY,
 case when M.ISACTIVE= 1 then ''Active'' else ''In Active'' end ISACTIVE,count(i.item_id) TotalMinutes
 ,(select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''Pending'') TotalPending
,(select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''Closed'') TotalClosed
,(select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''Discarded'') TotalDiscarded
,(select Count(*) from SplitString(M.MEETING_ATTENDEES,'','')) TotalAttendees
,(select top 1 CONVERT(varchar,Expected_Closure_Date,103) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''PENDING'' and (Expected_Closure_Date<getdate()-1) order by Expected_Closure_Date)PASSED_DATE
  from ivap_mst_mom M left join ivap_mst_mom_item i on M.TID=i.MOM_ID  where 1=1'    
 IF(@MOMID > 0)    
 BEGIN    
  SET @SQLString+=' AND M.TID=' + '@MOMID'    
 END    
 IF(@ENTITYID > 0)    
 BEGIN    
  SET @SQLString+=' AND M.ENTITY_ID=' + '@ENTITYID'    
 END    
  IF(@UID <> 0)    
 BEGIN    
  SET @SQLString=@SQLString+' AND M.Created_by in ('+ cast(@UID as varchar)+') '  
 END
 if (@STATUS='Pending')
 Begin
	SET @SQLString=@SQLString+' AND i.Curr_Status=''Pending'''  
 End
  if (@STATUS='Discarded')
 Begin
	SET @SQLString=@SQLString+' AND i.Curr_Status=''Discarded'''  
 End
 set @SQLString=@SQLString+' group by M.TID,M.ENTITY_ID,M.MEETING_HELD,M.MEETING_ATTENDEES,M.ADDRESS,M.AGENDA,M.CREATED_ON,M.LASTUPDATE,M.CREATED_BY,M.ISACTIVE'    
 if (@STATUS='Closed')
 Begin
	SET @SQLString=@SQLString+' having ((select count(Curr_Status) from ivap_mst_mom_item where MOM_ID=M.TID and Curr_Status=''Closed'')=count(i.item_id)) '    
 End
 set @SQLString = @SQLString+' order by M.TID desc'     
 print @SQLString    
 SET @ParmDefinition = N'@MOMID int,@ENTITYID INT';     
 EXECUTE sp_executesql @SQLString, @ParmDefinition, @MOMID,@ENTITYID
END

GO
/****** Object:  StoredProcedure [dbo].[GetMonthClose]    Script Date: 03-06-2019 19:23:41 ******/
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
      CASE WHEN MC.ISACT =1 THEN 'Active' ELSE 'IN Active' END ISACTIVE,E.ENTITY_NAME,E.ENTITY_CODE,MC.ISACT,
	  CASE WHEN MC.DEFAULT_MONTH =1 THEN 'YES' ELSE 'NO' END DEFAULT_MONTH
      FROM IVAP_MONTH_CLOSE MC    
      INNER JOIN IVAP_MST_ENTITY E ON MC.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1 AND MC.ENTITY_ID =@EID
		
	  --UNION ALL SELECT 0 as TID,@EID AS ENTITY_ID,DATENAME(MONTH, DATEADD(MONTH, @currentM, -1 )) AS MONTH, @currentYear AS  YEAR,
	  --FORMAT(GETDATE(),'dd/MM/yyyy') AS CURRENT_STATUS_DATE,FORMAT(GETDATE(),'dd/MM/yyyy') AS OPEN_DATE, null CLOSED_DATE,
	  --'OPEN' STATUS, 'Active' AS ISACTIVE,ENTITY_NAME,ENTITY_CODE,1 AS ISACT  FROM IVAP_MST_ENTITY WHERE TID = @EID AND @CurrentRow =0
	END
	ELSE
	BEGIN
		SELECT MC.TID, MC.ENTITY_ID,DATENAME(MONTH, DATEADD(MONTH, MC.MONTH, -1 )) MONTH,MC.YEAR,
		CASE WHEN MC.STATUS ='OPEN' THEN FORMAT(MC.OPEN_DATE,'dd/MM/yyyy') ELSE FORMAT(MC.CLOSED_DATE,'dd/MM/yyyy') END CURRENT_STATUS_DATE,
		ISNULL(FORMAT(MC.OPEN_DATE,'dd/MM/yyyy'),'') OPEN_DATE,ISNULL(FORMAT(MC.CLOSED_DATE,'dd/MM/yyyy'),'') CLOSED_DATE,MC.STATUS,   
      CASE WHEN MC.ISACT =1 THEN 'Active' ELSE 'IN Active' END ISACTIVE,E.ENTITY_NAME,E.ENTITY_CODE,MC.ISACT,
	  CASE WHEN MC.DEFAULT_MONTH =1 THEN 'YES' ELSE 'NO' END DEFAULT_MONTH  
      FROM IVAP_MONTH_CLOSE MC    
      INNER JOIN IVAP_MST_ENTITY E ON MC.ENTITY_ID=E.TID    
      WHERE E.ISACTIVE=1 AND MC.ENTITY_ID =@EID AND MC.TID =@TID 
	END
END

 
GO
/****** Object:  StoredProcedure [dbo].[GetMonthClose_1]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetMonthCloseHistory]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetNextApproval]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetNextApproval]
(
	@EID INT,
	@FileID INT,
	@RoleID INT
)
AS
BEGIN
	select U.UID,U.USERID,DA.TABLE_NAME,DA.TIDS from 
	IVAP_MST_USER U inner join IVAP_DATA_ACCESS_DTL DA on (U.UID=DA.UID AND DA.TABLE_NAME='IVAP_MST_FILETYPE')
	where U.ENTITY_ID=@EID and U.USER_ROLE=@RoleID
	AND DA.TIDS like '%'+cast(@FileID AS VARCHAR)+',%'
END
GO
/****** Object:  StoredProcedure [dbo].[GetOneTimeEarningDeduction]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetOneTimeEarningDeduction]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
declare @SqlQuery varchar(max)='';  
	 set @SqlQuery=' select ''Provident Fund'' AS Type ,isnull(SUM(ISNULL(cast(prf as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File''
	   UNION ALL
	   select ''ESIC'' AS Type ,isnull(SUM(ISNULL(cast(ESI as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File''
	   UNION ALL
	   select ''Professional Tax'' AS Type ,isnull(SUM(ISNULL(cast(PTX as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File''
	    UNION ALL
	   select ''LWF'' AS Type ,isnull(SUM(ISNULL(cast(LWF as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File''
	    UNION ALL
	   select ''Income Tax'' AS Type ,isnull(SUM(ISNULL(cast(ITAX as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File'''
	   exec (@SqlQuery) 
	   --print @SqlQuery
END
GO
/****** Object:  StoredProcedure [dbo].[GetParrentFolder]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetParrentFolder]
(
	@FileID INT = 36,
	@FileType NVARCHAR(20) =''
)
AS
BEGIN
	IF(@FileType ='Folder')
	BEGIN
		;With CTEs
		As
		(
			select PID,FileID,FileOriginalName from IVAP_Mst_Files where FileID=@FileID
			Union All
			Select a.PID,a.FileID,a.FileOriginalName from IVAP_Mst_Files a, CTEs c where c.PID = a.FileID
		)
		select Stuff((SELECT '/' + FileOriginalName from CTEs Order by FileID Asc FOR XML path('')),1,1,'') FileOriginalName
	END
	ELSE
	BEGIN
		;With CTEs
		As
		(
			select PID,FileID,FileSystemGeneratedName from IVAP_Mst_Files where FileID=@FileID
			Union All
			Select a.PID,a.FileID,a.FileSystemGeneratedName from IVAP_Mst_Files a, CTEs c where c.PID = a.FileID
		)
		select Stuff((SELECT '/' + FileSystemGeneratedName from CTEs Order by FileID Asc FOR XML path('')),1,1,'') FileOriginalName

	END

END
GO
/****** Object:  StoredProcedure [dbo].[GetParrentFolderForRename]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetParrentFolderForRename]
(
	@FileID INT = 24
)
AS
BEGIN
	;With CTEs
		As
		(
			select PID,FileID,FileOriginalName from IVAP_Mst_Files where FileID=@FileID
			Union All
			Select a.PID,a.FileID,a.FileOriginalName from IVAP_Mst_Files a, CTEs c where c.PID = a.FileID
		)
		select Stuff((SELECT '/' + FileOriginalName from CTEs WHERE FileID <> @FileID Order by FileID Asc FOR XML path('')),1,1,'') FileOriginalName
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayComponentName]    Script Date: 03-06-2019 19:23:41 ******/
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
  select distinct COMPONENT_NAME from IVAP_MST_COMPONENT_ENTITY where 
  tid in (select COMPONENT_ID  from IVAP_MST_FILE_COMP_DETAIL where file_id = @FILETYPEID and COMPONENT_DATATYPE='AMOUNT') 
  and ENTITY_ID=@ENTITYID
 END  
END

GO
/****** Object:  StoredProcedure [dbo].[GetPayComponentName_Output]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetPayComponentName_Output] 
(  
@ENTITYID INT=0
)  
AS  
BEGIN  
  select distinct COMPONENT_NAME from IVAP_MST_COMPONENT_ENTITY where 
  tid in (select COMPONENT_ID  from IVAP_MST_FILE_COMP_DETAIL where file_id = 129 and COMPONENT_DATATYPE='AMOUNT') 
  and ENTITY_ID=@ENTITYID
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayComponentTrendData]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPayComponentTrendData] 
(  
 @COMPONENT_NAME varchar(max)
 )  
AS  
 BEGIN
    exec (@COMPONENT_NAME)
 END
GO
/****** Object:  StoredProcedure [dbo].[GetPayDates]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetPayDates]
(
@EID int
)
as
	Declare @SqlQuery nvarchar(max)='';
	Begin
			set @SqlQuery='select distinct Upper(Replace(Right(convert(varchar,PAYDATE,106),8),'' '',''-'')) PayDate_Text, convert(varchar,PAYDATE,103) as PayDate from Ivap_TEMP_HIS_'+ cast(@EID as varchar(100))+' where paydate is not null order by convert(varchar,PAYDATE,103) asc'
			print(@SqlQuery);
			execute(@SqlQuery);
	End
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollCompDB]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetPayrollCompDB_0]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPayrollCompDB_0] 
(  
 @COMPONENT_NAME varchar(max)='SUM(ISNULL(cast(ARR_BASIC as decimal),0))[ARR_BASIC],SUM(ISNULL(cast(ARR_CCA as decimal),0))[ARR_CCA],SUM(ISNULL(cast(ARR_CONV as decimal),0))[ARR_CONV],SUM(ISNULL(cast(ARR_DAYS as decimal),0))[ARR_DAYS],SUM(ISNULL(cast(ARR_HRA as decimal),0))[ARR_HRA],SUM(ISNULL(cast(ARR_MEALALL as decimal),0))[ARR_MEALALL],SUM(ISNULL(cast(ARR_OTHALL as decimal),0))[ARR_OTHALL],SUM(ISNULL(cast(ARR_SFTALL as decimal),0))[ARR_SFTALL],SUM(ISNULL(cast(ARR_SPALL as decimal),0))[ARR_SPALL],SUM(ISNULL(cast(ARR_TELE as decimal),0))[ARR_TELE],SUM(ISNULL(cast(BASIC as decimal),0))[BASIC],SUM(ISNULL(cast(BONUS as decimal),0))[BONUS],SUM(ISNULL(cast(BPRIM as decimal),0))[BPRIM],SUM(ISNULL(cast(CCA as decimal),0))[CCA],SUM(ISNULL(cast(CONVEYANCE as decimal),0))[CONVEYANCE],SUM(ISNULL(cast(CTC as decimal),0))[CTC],SUM(ISNULL(cast(CTC_PF as decimal),0))[CTC_PF],SUM(ISNULL(cast(DRV_RIM as decimal),0))[DRV_RIM],SUM(ISNULL(cast(FODRIM as decimal),0))[FODRIM],SUM(ISNULL(cast(GRATUITY as decimal),0))[GRATUITY],SUM(ISNULL(cast(HOLDAMT as decimal),0))[HOLDAMT],SUM(ISNULL(cast(HRA as decimal),0))[HRA],SUM(ISNULL(cast(LTA_RIM as decimal),0))[LTA_RIM],SUM(ISNULL(cast(LVNCAS as decimal),0))[LVNCAS],SUM(ISNULL(cast(MEDRIM as decimal),0))[MEDRIM],SUM(ISNULL(cast(MELRIM as decimal),0))[MELRIM],SUM(ISNULL(cast(NOTPAY as decimal),0))[NOTPAY],SUM(ISNULL(cast(OTHDED as decimal),0))[OTHDED],SUM(ISNULL(cast(OTHRIM as decimal),0))[OTHRIM],SUM(ISNULL(cast(PAY_EMP_CODE as decimal),0))[PAY_EMP_CODE],SUM(ISNULL(cast(PAYDAYS as decimal),0))[PAYDAYS],SUM(ISNULL(cast(SAL_ADVANCE as decimal),0))[SAL_ADVANCE],SUM(ISNULL(cast(SFTALL as decimal),0))[SFTALL],SUM(ISNULL(cast(SPL_ALLOWANCE as decimal),0))[SPL_ALLOWANCE],SUM(ISNULL(cast(STABON as decimal),0))[STABON],SUM(ISNULL(cast(TELRIM as decimal),0))[TELRIM]',
 @COMPONENT_LIST varchar(max)='ARR_BASIC[ARR_BASIC],ARR_CCA[ARR_CCA],ARR_CONV[ARR_CONV],ARR_DAYS[ARR_DAYS],ARR_HRA[ARR_HRA],ARR_MEALALL[ARR_MEALALL],ARR_OTHALL[ARR_OTHALL],ARR_SFTALL[ARR_SFTALL],ARR_SPALL[ARR_SPALL],ARR_TELE[ARR_TELE],BASIC[BASIC],BONUS[BONUS],BPRIM[BPRIM],CCA[CCA],CONVEYANCE[CONVEYANCE],CTC[CTC],CTC_PF[CTC_PF],DRV_RIM[DRV_RIM],FODRIM[FODRIM],GRATUITY[GRATUITY],HOLDAMT[HOLDAMT],HRA[HRA],LTA_RIM[LTA_RIM],LVNCAS[LVNCAS],MEDRIM[MEDRIM],MELRIM[MELRIM],NOTPAY[NOTPAY],OTHDED[OTHDED],OTHRIM[OTHRIM],PAY_EMP_CODE[PAY_EMP_CODE],PAYDAYS[PAYDAYS],SAL_ADVANCE[SAL_ADVANCE],SFTALL[SFTALL],SPL_ALLOWANCE[SPL_ALLOWANCE],STABON[STABON],TELRIM[TELRIM]',
 @ENTITYID INT=15
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
  --print(@sqlqry)
  exec (@sqlqry) 
END
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayRollInputFile]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[GetPayRollInputFile] 
  (
  @EID int
  )
  as
  begin
     select TID,FILE_NAME from IVAP_MST_FILETYPE where ENTITY_ID=@EID and FILE_TYPE='Payroll Input File'

 end
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInputReport]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetPayrollInputReport]
(
@EID int,
@PayDate varchar(100)
)
As
	Declare @sqlQuery varchar(Max)=''
	Begin
			set @sqlQuery=';with A(FileID,File_name,Category,Total_Uploaded_Count)as '+
						  '(select his.FILE_ID,ft.FILE_NAME,ft.CATEGORY,Count(his.TID) Total_Uploaded_Count from Ivap_TEMP_HIS_'+ CAST(@EID as varchar) +' His inner join IVAP_MST_FILETYPE FT on his.FILE_ID=ft.TID '+ 
						  'where convert(varchar,paydate,103)='''+@PayDate  +''' and ft.File_Type=''Payroll Input File'''+
						  ' Group by his.FILE_ID,ft.FILE_NAME,ft.CATEGORY), B(FileID,File_name,Categoy,Total_Approved_Count)'+
						  'As  (select his.FILE_ID,ft.FILE_NAME,ft.CATEGORY,Count(his.TID) Total_Uploaded_Count from Ivap_TEMP_HIS_'+ CAST(@EID as varchar) +' His inner join IVAP_MST_FILETYPE FT on his.FILE_ID=ft.TID '+ 
						  'where convert(varchar,paydate,103)='''+@PayDate  +''' and ft.File_Type=''Payroll Input File'' and his.CURR_STATUS=''APPROVED'''+
						 'Group by his.FILE_ID,ft.FILE_NAME,ft.CATEGORY )'+
						' select A.FileID,A.File_Name,A.Category,isnull(A.Total_Uploaded_Count,0)Total_Uploaded_Count,isnull(B.Total_Approved_Count,0)Total_Approved_Count from A left join B on A.FileID=b.FileID '
						print(@sqlQuery);
						Execute(@sqlQuery);
	End
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInputReport_New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[GetPayrollInputReport_New]
(
@EID int,
@PayDate varchar(100)
)
As
	Declare @sqlQuery varchar(Max)=''
	Begin
			set @sqlQuery=';with A(FileID,SubFileID,File_name,Category,Total_Uploaded_Count)as '+
						  '(select ft.tid,his.FILE_ID,ft.FILE_NAME,ft.CATEGORY,Count(his.TID) Total_Uploaded_Count from Ivap_TEMP_HIS_'+ CAST(@EID as varchar) +' His inner join IVAP_MST_FILETYPE FT on his.FILE_ID=ft.Payroll_Input_File '+ 
						  'where convert(varchar,paydate,103)='''+@PayDate  +''' and ft.File_Type=''PMS Input File'''+
						  ' Group by ft.tid,his.FILE_ID,ft.FILE_NAME,ft.CATEGORY), B(FileID,SubFileID,File_name,Categoy,Total_Approved_Count)'+
						  'As  (select ft.tid,his.FILE_ID,ft.FILE_NAME,ft.CATEGORY,Count(his.TID) Total_Uploaded_Count from Ivap_TEMP_HIS_'+ CAST(@EID as varchar) +' His inner join IVAP_MST_FILETYPE FT on his.FILE_ID=ft.Payroll_Input_File '+ 
						  'where convert(varchar,paydate,103)='''+@PayDate  +''' and ft.File_Type=''PMs Input File'' and his.CURR_STATUS=''APPROVED'''+
						 'Group by ft.tid,his.FILE_ID,ft.FILE_NAME,ft.CATEGORY )'+
						' select A.FileID,A.SubFileID,A.File_Name,A.Category,isnull(A.Total_Uploaded_Count,0)Total_Uploaded_Count,isnull(B.Total_Approved_Count,0)Total_Approved_Count from A left join B on A.FileID=b.FileID '
						print(@sqlQuery);
						Execute(@sqlQuery);
	End
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollOutputData]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetPayrollOutputData]
(
	@FileIds nvarchar(Max),
	@UID int,
	@EID int
)
	As
		Begin	
				declare @sqlQuery varchar(max)='';
				if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where COM.COMPONENT_NAME ='PAYDATE' AND FD.FILE_ID in(select * from SplitString(@FileIds,',')))
					begin
								print('got it')
							set @sqlQuery=' ;with A(File_Name,HRDCOUNT) as (select  files.FILE_NAME,Count(hrd.TID) HRDCOUNT from IVAP_MST_FILETYPE files left join Ivap_HRD_MAST_'+cast(@EID As VARCHAR)+' HRD on files.TID=hrd.FILE_ID where files.tid in (select * from SplitString('''+@FileIds+''','','')) and files.ENTITY_ID='+cast(@EID As VARCHAR)+' and HRD.Created_By='+Cast(@UID as varchar)+' group by files.FILE_NAME)  ,B(File_Name,PayCount) as (select  files.FILE_NAME,count(Pay.TID) PAYCOUNT from IVAP_MST_FILETYPE files 	left join Ivap_PAY_MAST_'+ cast(@EID As VARCHAR)+' PAY on files.TID=PAY.FILE_ID where files.tid in (select * from SplitString('''+@FileIds+''','','')) and files.ENTITY_ID='+cast(@EID As VARCHAR)+' AND PAY.Created_By='+Cast(@UID as varchar)+'  and CONVERT(varchar,PAYDATE,103) in (select Convert(varchar,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),103)) group by files.FILE_NAME),c(PAYDATE) as (select Right(Upper(Replace(Convert(varchar,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),106),'' '',''-'')),8) PAYDATE )select A.File_Name,HRDCOUNT,PayCount,PAYDATE from A,B,C'
							print(@sqlQuery)
							EXECUTE(@sqlQuery)
					End
		End
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollOutputData_1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetPayrollOutputData_1]
(
	@FileIds nvarchar(Max),
	@UID int,
	@EID int
)
	As
		Begin	
				declare @sqlQuery varchar(max)='';
				if exists(select * from IVAP_MST_FILE_COMP_DETAIL FD inner join IVAP_MST_COMPONENT_ENTITY COM On FD.COMPONENT_ID=COM.TID where COM.COMPONENT_NAME ='PAYDATE' AND FD.FILE_ID in(select * from SplitString(@FileIds,',')))
					begin
								
							set @sqlQuery=' select ''HRDMAST'' MAST ,Count(hrd.TID) TOTALCOUNT from IVAP_MST_FILETYPE files left join Ivap_HRD_MAST_'+cast(@EID As VARCHAR)+' HRD on files.TID=hrd.FILE_ID where files.tid in (select * from SplitString('''+@FileIds+''','','')) and files.ENTITY_ID='+cast(@EID As VARCHAR)+' and HRD.Created_By='+Cast(@UID as varchar)+' Union ALL select  ''PAYMAST'' MAST,count(Pay.TID) TOTALCOUNT from IVAP_MST_FILETYPE files 	left join Ivap_PAY_MAST_'+ cast(@EID As VARCHAR)+' PAY on files.TID=PAY.FILE_ID where files.tid in (select * from SplitString('''+@FileIds+''','','')) and files.ENTITY_ID='+cast(@EID As VARCHAR)+' AND PAY.Created_By='+Cast(@UID as varchar)+'  and CONVERT(varchar,PAYDATE,103) in (select Convert(varchar,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1),103))'
							print(@sqlQuery)
							EXECUTE(@sqlQuery)
					End
		End
GO
/****** Object:  StoredProcedure [dbo].[GetPlant]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetPlantHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetProcess]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetProcessHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetPTAX]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetPTAXHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetPublishData]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetQuickSetup]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetQuickSetup]
(
	@EID INT=31
)
AS
BEGIN
	-- Master Setup--------------------------------------------------------
	DECLARE @PMenu INT = (select TID from ivap_mst_Menu where ENTITY_ID =31 AND UPPER(NAME) = 'MASTER')
	select COUNT(DISTINCT SCREEN_NAME) TotalMaster,
	COUNT(DISTINCT SCREEN_NAME) MenuMasterTotal
	--(select COUNT(*) from ivap_mst_Menu where ENTITY_ID =@EID AND PMENU =@PMenu) MenuMasterTotal
	 from IVAP_META_MASTER WHERE ENTITY_ID =@EID
	--END Master Setup--------------------------------------------------------

	-- Component Setup----------------------------------------------------------------------
	 SELECT COMPONENT_FILE_TYPE, COUNT(COMPONENT_FILE_TYPE) CompCount from IVAP_MST_COMPONENT_ENTITY WHERE ENTITY_ID =@EID GROUP BY COMPONENT_FILE_TYPE ORDER BY COMPONENT_FILE_TYPE ASC
	-- END Component Setup------------------------------------------------------------------

	-- File Setup----------------------------------------------------------------------
	SELECT CATEGORY,COUNT(CATEGORY) CatCount FROM IVAP_MST_FILETYPE WHERE CATEGORY IS NOT NULL AND ENTITY_ID=@EID GROUP BY CATEGORY
	--END File Setup-------------------------------------------------------------------------
	-- User Setup----------------------------------------------------------------------
	SELECT UR.ROLENAME,COUNT(USERID) UserCount from IVAP_MST_USER U
		INNER JOIN IVAP_MST_USERROLE UR ON U.USER_ROLE = UR.TID
	WHERE ENTITY_ID =@EID AND UPPER(UR.ROLENAME) <> 'MYND ADMIN' GROUP BY USER_ROLE,UR.ROLENAME
	-- ENd User Setup
	-- Work FlowSetting----------------------------------------------
	select t.FILE_TYPE,COUNT(t.FILE_TYPE) FileCount from
	(select FILE_TYPE,COUNT(File_ID) FileCount from IVAP_MST_WorkFlowSetting wf
		INNER JOIN IVAP_MST_FILETYPE F ON wf.FILE_ID = F.TID
	 WHERE wf.ENTITY_ID =@EID GROUP BY FILE_ID,FILE_TYPE) as t group by t.FILE_TYPE

 select FILE_TYPE,COUNT(FILE_TYPE) CountFile_Type from IVAP_MST_FILETYPE where ENTITY_ID=@EID AND FILE_TYPE <> 'PMS Input File' GROUP BY FILE_TYPE
 ------------------------------------------------------------------------
END



 


--select File_ID from IVAP_MST_WorkFlowSetting GROUP BY FILE_ID

--select DIstinct FILE_TYPE from IVAP_MST_FILETYPE
--select * from IVAP_MST_FILETYPE

GO
/****** Object:  StoredProcedure [dbo].[GetRegion]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetRegionHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetRoles]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetRootParent]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetRootParent]-- 39
(
	@FileID INT =0
)
AS
BEGIN
	;WITH UserCTE AS (
  SELECT F.FileID,F.EID,F.FileType,FileOriginalName,FileTypeName,MetaValue , F.PID
  FROM IVAP_mst_files F where  f.fileID=@FileID
    
  UNION ALL
  
  SELECT F.FileID,F.EID,F.FileType,F.FileOriginalName,F.FileTypeName,F.MetaValue , F.PID
  FROM UserCTE AS usr
    INNER JOIN IVAP_mst_files F
      ON usr.pid = F.fileid  --where f.CustomerID=464
)
SELECT  FileID, fileOriginaLnAME AS RootParent
  FROM UserCTE AS u where pid=0
  ;
END
GO
/****** Object:  StoredProcedure [dbo].[GetSchemaAndUserRIghtsOfInputFile]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetSchemaAndUserRIghtsOfInputFile]    
(    
	 @EID INT,    
	 @FILE_ID INT  
)    
AS    
BEGIN    
		 select E.COMPONENT_FILE_TYPE,f.FILE_NAME,dtl.EXTRA_INPUT_VALIDATION,dtl.EXTRA_RG_EXPRESSION,
		 E.COMPONENT_TYPE,E.COMPONENT_SUB_TYPE,E.COMPONENT_NAME,E.COMPONENT_DATATYPE,Dtl.COMPONENT_DISPLAY_NAME,Dtl.MANDATORY,E.ISACTIVE ,GCo.COMPONENT_TABLE_NAME,GCo.COMPONENT_COLUMN_NAME,Dtl.MIN_LENGTH,	Dtl.MAX_LENGTH,F.Transpose
		 from IVAP_MST_COMPONENT_ENTITY E  INNER JOIN IVAP_MST_FILE_COMP_DETAIL Dtl ON E.TID = dtl.COMPONENT_ID 
		 inner join IVAP_MST_COMPONENT GCo on e.Globle_Component_ID=GCo.TID 
		 inner join IVAP_MST_FILETYPE F ON Dtl.FILE_ID=F.TID
		 where Dtl.ENTITY_ID=@EID AND dtl.FILE_ID=@FILE_ID ORDER BY dtl.Display_Order 
		 
		 select DTL.UID,DTL.TABLE_NAME,DTL.TIDS from IVAP_DATA_ACCESS_DTL DTL
				inner join IVAP_MST_USER U ON U.UID=DTL.UID
				 where DTL.ISACTIVE=1 AND U.ISACT=1 AND U.ENTITY_ID=31 
		 --AND TID IN (SELECT COMPONENT_ID FROM IVAP_MST_FILE_COMP_DETAIL WHERE FIle_ID =@FILE_ID)    
END
GO
/****** Object:  StoredProcedure [dbo].[GetSDSOutputDashBoard]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetSDSOutputDashBoard]
(
       @EID INT=31,
       @PayDate varchar(30)='2019-01-31',
       @PreviousPayDate varchar(30)='2018-12-31' 
)
AS

BEGIN
declare @SqlQuery varchar(max)='';  
	 set @SqlQuery=' select ''Provident Fund'' AS Type ,isnull(SUM(ISNULL(cast(prf as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File''
	   UNION ALL
	   select ''ESIC'' AS Type ,isnull(SUM(ISNULL(cast(ESI as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File''
	   UNION ALL
	   select ''Professional Tax'' AS Type ,isnull(SUM(ISNULL(cast(PTX as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File''
	    UNION ALL
	   select ''LWF'' AS Type ,isnull(SUM(ISNULL(cast(LWF as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File''
	    UNION ALL
	   select ''Income Tax'' AS Type ,isnull(SUM(ISNULL(cast(ITAX as decimal),0)),0) As TotalCount from Ivap_TEMP_HIS_'+Cast(@EID as varchar)+' Temp
       inner join IVAP_MST_FILETYPE F ON F.TID=Temp.File_ID
       where PayDate=''' + @PayDate + ''' and F.CATEGORY=''CTC MASTER''
       and F.file_type=''PMS Output File'''
	   exec (@SqlQuery) 
	   --print @SqlQuery
END
GO
/****** Object:  StoredProcedure [dbo].[GetSection]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetSectionHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetServiceAvailed]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetSpecialComponentName]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetSpecialComponentName]
(
@EID int,
@SEARCHSTRING nvarchar(20)
)
as
begin

select TID AS id,COMPONENT_NAME AS value from IVAP_MST_COMPONENT_ENTITY where ENTITY_ID=@EID and COMPONENT_NAME like '%'+@SEARCHSTRING+'%' 

end
GO
/****** Object:  StoredProcedure [dbo].[GetSpecialFileComponentTid]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetSpecialFileComponentTid]  
(  
@TID int  
)  
as  
begin  
   select FILE_ID,COMPONENT_ID,CREATED_BY,Display_Order,ENTITY_ID,isnull(COMPONENT_FILE_TYPE,'') as COMPONENT_FILE_TYPE,    
   isnull(COMPONENT_TYPE,'')as COMPONENT_TYPE,isnull(COMPONENT_SUB_TYPE,'') as COMPONENT_SUB_TYPE,isnull(COMPONENT_NAME,'') as COMPONENT_NAME        
  ,isnull(Spl_Field_Value,'') as Spl_Field_Value,isnull(Spl_Field_Type,'') as Spl_Field_Type,           
  isnull(COMPONENT_COLUMN_NAME,'') as COMPONENT_COLUMN_NAME,isnull(COMPONENT_DISPLAY_NAME,'') as COMPONENT_DISPLAY_NAME,isnull(COMPONENT_DESCRIPTION,'') as COMPONENT_DESCRIPTION,ISACTIVE,    
  case when  ISACTIVE=1 then 'ACTIVE' else 'INACTIVE' end STATUS,FILE_ID       
   from IVAP_MST_FILE_COMP_DETAIL where TID=@TID          
end 
GO
/****** Object:  StoredProcedure [dbo].[GetState]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GETSTATEHIS]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetStateList]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetSubFunction]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetSubFunctionHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetTemplateComponent]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetTemplateComponent]
 as
	Begin
			select * from IVAP_MST_COMPONENT where  file_template is not null 
    End
GO
/****** Object:  StoredProcedure [dbo].[GetTempTableData]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetTempTableData24]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetTotalMOM]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetTotalMOM]
(
@MOMID int=0,
@Entity_ID int=0,
@Status varchar(10)='All'
)
as
	Begin
	       if @Status='ALL'
			begin
					select M.TID,i.MoM_Minutes MINUTES,i.OwnerShip RESPONSIBILITY,i.Curr_Status MINUTES_STATUS,
					(ivap.dbo.fnformatdate(i.Actual_Date,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),i.Actual_Date, 22), 11))) A_C_D
					,(ivap.dbo.fnformatdate(i.Expected_Closure_Date,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),i.Expected_Closure_Date, 22), 11))) E_C_D
					from IVAP_MST_MOM M inner join ivap_mst_mom_item i on M.TID=i.MOM_ID inner join IVAP_MST_ENTITY E on M.ENTITY_ID= E.TID
					 where M.tid=@MOMID and M.ENTITY_ID=@Entity_ID
			 end
		   else if @Status='Pending'
			 Begin
					select M.TID,i.MoM_Minutes MINUTES,i.OwnerShip RESPONSIBILITY,i.Curr_Status MINUTES_STATUS,
					(ivap.dbo.fnformatdate(i.Actual_Date,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),i.Actual_Date, 22), 11))) A_C_D
					,(ivap.dbo.fnformatdate(i.Expected_Closure_Date,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),i.Expected_Closure_Date, 22), 11))) E_C_D
					from IVAP_MST_MOM M inner join ivap_mst_mom_item i on M.TID=i.MOM_ID inner join IVAP_MST_ENTITY E on M.ENTITY_ID= E.TID
					 where M.tid=@MOMID and M.ENTITY_ID=@Entity_ID and i.Curr_Status='Pending'
			 End
		   else if @Status='Closed'
			 Begin
										select M.TID,i.MoM_Minutes MINUTES,i.OwnerShip RESPONSIBILITY,i.Curr_Status MINUTES_STATUS,
					(ivap.dbo.fnformatdate(i.Actual_Date,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),i.Actual_Date, 22), 11))) A_C_D
					,(ivap.dbo.fnformatdate(i.Expected_Closure_Date,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),i.Expected_Closure_Date, 22), 11))) E_C_D
					from IVAP_MST_MOM M inner join ivap_mst_mom_item i on M.TID=i.MOM_ID inner join IVAP_MST_ENTITY E on M.ENTITY_ID= E.TID
					 where M.tid=@MOMID and M.ENTITY_ID=@Entity_ID and i.Curr_Status='Closed'
			 End
		   else if @Status='Discarded'
			 Begin
										select M.TID,i.MoM_Minutes MINUTES,i.OwnerShip RESPONSIBILITY,i.Curr_Status MINUTES_STATUS,
					(ivap.dbo.fnformatdate(i.Actual_Date,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),i.Actual_Date, 22), 11))) A_C_D
					,(ivap.dbo.fnformatdate(i.Expected_Closure_Date,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),i.Expected_Closure_Date, 22), 11))) E_C_D
					from IVAP_MST_MOM M inner join ivap_mst_mom_item i on M.TID=i.MOM_ID inner join IVAP_MST_ENTITY E on M.ENTITY_ID= E.TID
					 where M.tid=@MOMID and M.ENTITY_ID=@Entity_ID and i.Curr_Status='Discarded'
			 End

	End

GO
/****** Object:  StoredProcedure [dbo].[GetTranspose]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[GetTranspose]  
  (  
  @FILEID int  
  )   
  as  
  begin  
  
  select Tid,File_Id,Field_Type,Component_Name,Display_Name,Display_Order,case when IsActive=1 then 'Active' else 'InActive' end as STATUS from Ivap_Transpose_Setting where File_Id=@FILEID order by Display_Order 
  end
GO
/****** Object:  StoredProcedure [dbo].[GetTransposeByID]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create proc [dbo].[GetTransposeByID]
  (
  @TID int
  ) 
  as
  begin

  select * from Ivap_Transpose_Setting where Tid=@Tid
  end
GO
/****** Object:  StoredProcedure [dbo].[GetTransposeComponent]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[GetTransposeComponent]    
  (    
  @FILEID int    
  )     
  as    
  begin 
  --declare @ComponentVar nvarchar(max);
  select Component_Name  from Ivap_Transpose_Setting where Field_Type='COMPONENT' and File_Id=@FILEID

  

  end
GO
/****** Object:  StoredProcedure [dbo].[GetTransposeScheema]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetTransposeScheema]
(
@File_ID int
)
as
	Begin
			select * from Ivap_Transpose_Setting where File_Id=@File_ID	 and IsActive=1 order by Display_Order		
	End
GO
/****** Object:  StoredProcedure [dbo].[GetType]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetTypeHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUpdateMOM]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetUpdateMOM]
(
@MOMID int,
@Entity_ID int
)
As
	Begin
			select * from IVAP_MST_MOM where tid=@MOMID	and entity_id=@Entity_ID;		
	End
GO
/****** Object:  StoredProcedure [dbo].[GetUser]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserByRole]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetUserByRole]
(
	@EID INT,
	@Role VARCHAR(50)
)
AS
BEGIN
	SELECT UID,USERID FROM IVAP_MST_USER WHERE ENTITY_ID = @EID AND USER_ROLE = (SELECT TID FROM IVAP_MST_USERROLE WHERE UPPER(ROLENAME) = UPPER(@Role))
END
GO
/****** Object:  StoredProcedure [dbo].[GETUSERCOPYRIGHT]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserFromPassKey]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserLog]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetUserLog] 
(
@UID int
)
as
begin

 select CONCAT(L.USER_FIRSTNAME,L.USER_LASTNAME) AS Name,L.USERID,
 L.USER_EMAIL,L.LAST_PASSWORD_TRY_DATE,U.LOGIN_TIME,U.IP_ADDRESS
 from IVAP_MST_USER L inner join IVAP_LOGIN_LOG U on L.UID=U.UID where U.UID=@UID

end
GO
/****** Object:  StoredProcedure [dbo].[GetUserLog_New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[GetUserLog_New] --40,10,null,null,28
(
 @FromNumber NVARCHAR(10)=1,  
 @ToNumber NVARCHAR(10)=10,  
 @SQLSortString nvarchar(1000)=null,  
 @SQLFilterString nvarchar(1000)=null,  
  @EID int=0
)
as
begin

 SET NOCOUNT ON  
    DECLARE @SQLString nvarchar(Max);   
    DECLARE @SQLQueryCount nvarchar(MAX);  
    DECLARE @ParmDefinition nvarchar(Max);   
  

SET @SQLString =N' CONCAT(L.USER_FIRSTNAME, L.USER_LASTNAME) AS Name,L.USERID,
 L.USER_EMAIL,Convert(varchar,U.LOGOUT_TIME,100) as LOGOUT_TIME,convert(varchar,U.LOGIN_TIME,100) as LOGIN_TIME,
 CASE WHEN U.IP_ADDRESS=''::1'' THEN '' '' ELSE U.IP_ADDRESS END IP_ADDRESS
 from IVAP_MST_USER L inner join IVAP_LOGIN_LOG U on L.UID=U.UID inner join IVAP_MST_ENTITY E on E.TID=L.ENTITY_ID'
  IF(@EID > 0)                    
 BEGIN                
  SET @SQLString=@SQLString+' AND L.ENTITY_ID='+ '@EID'                    
   END 
 SET @SQLQueryCount =N'select Count(*) [TotalCount]   
     FROM IVAP_MST_USER L  
     INNER JOIN IVAP_LOGIN_LOG S ON L.UID = S.UID inner join IVAP_MST_ENTITY E on E.TID=L.ENTITY_ID'  
 IF(@EID > 0)                    
 BEGIN                
  SET @SQLQueryCount=@SQLQueryCount+' AND L.ENTITY_ID='+ '@EID'                    
   END 
 IF @SQLSortString IS NOT NULL and @SQLSortString != ''  
 BEGIN  
  SET @SQLString= N'SELECT ROW_NUMBER() OVER (ORDER BY '+@SQLSortString+') AS ''RowNumber'', ' +  @SQLString  
    
 END  
 ELSE  
 BEGIN  
  SET @SQLString= N'SELECT ROW_NUMBER() OVER (ORDER BY U.UID) AS ''RowNumber'', ' + @SQLString  
    
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
                     
     
 SET @ParmDefinition= N'@EID int' 		                 
 EXECUTE sp_executesql @SQLString,@ParmDefinition,@EID
 EXECUTE sp_executesql @SQLQueryCount,@ParmDefinition,@EID 
 
  -- print @SQLString  
END  


--select * from IVAP_LOGIN_LOG where UID=28

----select ENTITY_ID from IVAP_MST_USER where UID=2
--declare @HUi nvarchar(max)
--select Distinct(UID) from IVAP_MST_USER where ENTITY_ID=1

--select CONCAT(L.USER_FIRSTNAME, L.USER_LASTNAME) AS Name,L.USERID,
-- L.USER_EMAIL,L.LAST_PASSWORD_TRY_DATE,U.LOGIN_TIME,U.IP_ADDRESS
-- from IVAP_MST_USER L inner join IVAP_LOGIN_LOG U on L.UID=U.UID inner join IVAP_MST_ENTITY E on E.TID=L.ENTITY_ID where L.ENTITY_ID=31

--sp_help IVAP_LOGIN_LOG
GO
/****** Object:  StoredProcedure [dbo].[GetUserMenu]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserMenu_EID]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GETUSERMENUACCESS]    Script Date: 03-06-2019 19:23:41 ******/
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
SELECT * FROM IVAP_MST_MENU WHERE ENTITY_ID=@EID AND ROUTE  
 NOT IN('ViewRoles','ViewMenu','MasterMetaSetup','ViewCurrency','ViewPTAX','ViewLWF','EntityList','ViewUser',
 'ViewMinWage','ViewGlobalComponent','EntityComponentsList','DataAccessControl','','ViewGlobalLocation',
 'FileSetupList','MyRequestOutput','UploadFile','DataAccessControl',' ','CalendarSetup','MonthClose',
 'CalendarSetup','MonthClose','WorkFlowSetting','MyRequest','PayRollProcessing','DummyDashBoard','PayrollCompDB','UploadPayrollOutPutFile'  
) and PMENU>0         
END 
GO
/****** Object:  StoredProcedure [dbo].[GETUSERMENUACCESS_1]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GETUSERMENUACCESS_1]   
(      
@EID INT  =1    
)      
AS      
BEGIN      
select * from IVAP_MST_MENU where ENTITY_ID=@EID and ROUTE 
IN('ProcessList','ViewDepartment','ViewCostCentre','ViewCompany','ViewDesignation',
'ViewRegion','Division','Gradelist','ViewFunction','ViewBank','ViewLocation',
'ViewClass','ViewState','ViewSubFunction','ViewCurrency','ViewLevel','ViewPlant','ViewSection',
'ViewLeavingReason','TypeList')         
END   
GO
/****** Object:  StoredProcedure [dbo].[GetUserRoleHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUserRoleWise]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetViewMOM]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetViewMOM]
(
@MOMID int,
@Entity_ID int
)
As
	Begin
			select M.TID,M.ADDRESS,M.AGENDA, (ivap.dbo.fnformatdate(M.MEETING_HELD,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),M.MEETING_HELD, 22), 11))) MEETING_HELD, 
			(ivap.dbo.fnformatdate(M.CREATED_ON,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),M.CREATED_ON, 22), 11))) CREATED_ON,
			(ivap.dbo.fnformatdate(M.LASTUPDATE,E.DATE_FORMAT) +' '+ LTRIM(RIGHT(CONVERT(CHAR(20),M.LASTUPDATE, 22), 11))) LASTUPDATE,
			case when ((select Count(item_id) from ivap_mst_mom_item where MOM_ID=M.tid and Curr_Status='PENDING')=0) then 'Closed' else 'Open' end ISACTIVE,
			M.MEETING_ATTENDEES,
			M.CREATED_BY
			from IVAP_MST_MOM M inner join IVAP_MST_ENTITY E on M.ENTITY_ID= E.TID where M.tid=@MOMID and M.ENTITY_ID=@Entity_ID

		
	End
GO
/****** Object:  StoredProcedure [dbo].[GetWfSetting]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetWfSetting]
(
	@Role INT,
	@Ordering INT,
	@FileID INT,
	@EID INT
)
As 
BEGIN
	select top 1 * from IVAP_MST_WorkFlowSetting where ENTITY_ID=@EID and FILE_ID=@FileID
	AND ORDERING>@Ordering
	 order by ORDERING
END


GO
/****** Object:  StoredProcedure [dbo].[GetWorkFlowSetting]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetWorkFlowSetting31]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GetWorkFlowSettingHis]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[GLOBALLOCATION_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
SELECT TID,LOC_CODE,LOC_NAME,STATE_ID,ISMETRO,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_LOCATION_GLOBAL where TID=@LID 
END
GO
/****** Object:  StoredProcedure [dbo].[InsertDefaultMasterMeta]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[InsertDefaultMenu]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[LEAVINGREASON_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
SELECT TID,ENTITY_ID,PAY_LEAVING_CODE,ERP_LEAVING_CODE,[VOL/NON_VOL],REASON,CREATED_ON,CREATED_BY,UPDATED_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_LEAVING_REASON  where   TID=@LEAVID  
END 
GO
/****** Object:  StoredProcedure [dbo].[LEVEL_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[LOCATION_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
SELECT TID,ENTITY_ID,PAY_LOC_CODE,ERP_LOC_CODE,LOC_NAME,STATE_ID,ISMETRO,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action,PARENT_LOC_ID FROM IVAP_MST_LOCATION  where TID=@LOCID              
END 
GO
/****** Object:  StoredProcedure [dbo].[LogError]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[LogUserLogin]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[LWF_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[MASTERLABEL]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[MINWAGE_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[MonthClose_HIS]    Script Date: 03-06-2019 19:23:41 ******/
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
	INSERT INTO IVAP_HIS_MONTH_CLOSE(MONTH_CLOSE_ID,ENTITY_ID,MONTH,YEAR,OPEN_DATE,CLOSED_DATE,STATUS,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACT,ACTION,DEFAULT_MONTH)
		SELECT TID,ENTITY_ID,MONTH,YEAR,OPEN_DATE,CLOSED_DATE,STATUS,CREATED_ON,CREATED_BY,GETDATE(),@UPDATED_BY,ISACT,@ACTION,DEFAULT_MONTH
		FROM IVAP_MONTH_CLOSE WHERE TID = @TID
END
GO
/****** Object:  StoredProcedure [dbo].[MY_REQUEST_FILE]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[MY_REQUEST_FILE_0]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[PAYROLLPROCESS]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PAYROLLPROCESS]  
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
/****** Object:  StoredProcedure [dbo].[PAYROLLPROCESS_1]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[PLANT_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[PREVENTIVE_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PREVENTIVE_HISTORY]
(
@CID INT,       
@UpdatedBy INT,        
@Action VARCHAR(100) 
)
as
begin
INSERT INTO IVAP_HIS_CAPA_PREVENTIVE(CID,CAPA_ID,PREVENTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ACTION)
SELECT TID,CAPA_ID,PREVENTIVE_ACTION,ACTION_TEXT,ACTION_OWNER,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,@Action FROM IVAP_MST_CAPA_PREVENTIVE WHERE TID=@CID
END
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
SELECT TID,ENTITY_ID,PAY_PROC_CODE,ERP_PROC_CODE,PROC_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,@Action FROM IVAP_MST_PROCESS  where TID=@CID   
END 
GO
/****** Object:  StoredProcedure [dbo].[PublishHRDComponent]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[Regeneratepassword]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[REGION_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[RenmaeFile]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[RenmaeFile]
(
	@FileID INT,
	@OldName NVARCHAR(200),
	@NewName NVARCHAR(200),
	@FileSystemGeneratedName NVARCHAR(MAX),
	@Filetype NVARCHAR(200)
)
AS
BEGIN
	IF(@Filetype ='Folder')
		UPDATE IVAP_Mst_Files SET FileOriginalName =@NewName,FileSystemGeneratedName =@FileSystemGeneratedName WHERE FileID =@FileID
	ELSE
		UPDATE IVAP_Mst_Files SET FileOriginalName =@NewName WHERE FileID =@FileID

	SELECt @FileID AS FileID
END
GO
/****** Object:  StoredProcedure [dbo].[ResetEntityComponent]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ResetEntityComponent](@EntityCompID int =0)
as
begin
declare @GlobalCompID int 
set @GlobalCompID=0
 set @GlobalCompID=(select Globle_Component_ID from  IVAP_MST_COMPONENT_ENTITY where TID=@EntityCompID)

 UPDATE IVAP_MST_COMPONENT_ENTITY SET COMPONENT_FILE_TYPE=C.COMPONENT_FILE_TYPE,COMPONENT_TYPE=C.COMPONENT_TYPE,COMPONENT_SUB_TYPE=C.COMPONENT_SUB_TYPE
 ,COMPONENT_NAME=C.COMPONENT_NAME,COMPONENT_DATATYPE=C.COMPONENT_DATATYPE,COMPONENT_TABLE_NAME=C.COMPONENT_TABLE_NAME
 ,COMPONENT_COLUMN_NAME=C.COMPONENT_COLUMN_NAME,COMPONENT_DESCRIPTION=C.COMPONENT_DESCRIPTION,
  COMPONENT_DISPLAY_NAME=C.COMPONENT_DISPLAY_NAME,UPDATED_BY=c.UPDATED_BY,UPDATE_ON=GETDATE(),
MIN_LENGTH=C.MIN_LENGTH,MAX_LENGTH=C.MAX_LENGTH,MANDATORY=C.MANDATORY
FROM IVAP_MST_COMPONENT_ENTITY CE inner join IVAP_MST_COMPONENT C on CE.Globle_Component_ID =C.TID
 WHERE CE.Globle_Component_ID=@GlobalCompID and CE.TID =@EntityCompID
SELECT 1
end
GO
/****** Object:  StoredProcedure [dbo].[ResetFileComponent]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE Proc [dbo].[ResetFileComponent] 
  (
  @TID int
  )
  as
  begin
	declare @Result int=1,
	 @Type nvarchar(100),
	 @ComponentID int
	

	select @Type=COMPONENT_DATATYPE,@ComponentID=COMPONENT_ID from IVAP_MST_FILE_COMP_DETAIL where TID=@TID

	if(@Type='MASTER')
	begin
	update IVAP_MST_FILE_COMP_DETAIL set  COMPONENT_COLUMN_NAME=CE.COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME=CE.COMPONENT_DISPLAY_NAME,ISACTIVE=CE.ISACTIVE,      
     MANDATORY=CE.MANDATORY,GL_Code=CE.GL_Code,PMS_CODE=CE.PMS_CODE  from IVAP_MST_FILE_COMP_DETAIL inner join IVAP_MST_COMPONENT_ENTITY  CE on CE.TID=@ComponentID where IVAP_MST_FILE_COMP_DETAIL.TID=@TID
	 EXEC FILE_COMPONENT_HISTORY @TID,28,'RESET'  
	  SELECT @Result as result   
	end

	else

	begin

	update IVAP_MST_FILE_COMP_DETAIL set COMPONENT_DISPLAY_NAME=CE.COMPONENT_DISPLAY_NAME,ISACTIVE=CE.ISACTIVE,  
    MIN_LENGTH=CE.MIN_LENGTH,MAX_LENGTH=CE.MAX_LENGTH,MANDATORY=CE.MANDATORY,GL_Code=CE.GL_Code,PMS_CODE=CE.PMS_CODE  from IVAP_MST_FILE_COMP_DETAIL inner join IVAP_MST_COMPONENT_ENTITY  CE on CE.TID=@ComponentID where IVAP_MST_FILE_COMP_DETAIL.TID=@TID
	 EXEC FILE_COMPONENT_HISTORY @TID,28,'RESET' 
	SELECT @Result as result   
	end
	
 end
GO
/****** Object:  StoredProcedure [dbo].[ResetPassLink]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[Section_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[SetDefaultCurrentMonth]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetDefaultCurrentMonth]
(
	@EID INT,
	@UID INT
)
AS
BEGIN
	DECLARE @currentM INT =0,@currentYear INT =0,@Result INT=0
	SET @currentM = (SELECT MONTH(GETDATE()))
	SET @currentYear = (SELECT YEAR(GETDATE()))

	IF EXISTS(SELECT * FROM IVAP_MONTH_CLOSE WHERE [MONTH] =@currentM AND [YEAR] =@currentYear AND ENTITY_ID=@EID)
	BEGIN
		SELECT -1
		RETURN
	END
	UPDATE IVAP_MONTH_CLOSE SET DEFAULT_MONTH =0 WHERE ENTITY_ID =@EID
	INSERT INTO IVAP_MONTH_CLOSE(ENTITY_ID,MONTH,YEAR,OPEN_DATE,CLOSED_DATE,STATUS,DEFAULT_MONTH,CREATED_BY,ISACT)
			VALUES(@EID,MONTH(GETDATE()),YEAR(GETDATE()),GETDATE(),GETDATE(),'OPEN',1,@UID,1)
		SET @result =SCOPE_IDENTITY()  
		Exec MonthClose_HIS @result,@UID,'Create' 
	SELECT @result AS result
END

--select * from IVAP_MONTH_CLOSE
GO
/****** Object:  StoredProcedure [dbo].[SetDefaultMonth]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetDefaultMonth]
(
	@TID INT,
	@EID INT,
	@UID INT
)
AS
BEGIN
	DECLARE @result INT =0
	UPDATE IVAP_MONTH_CLOSE SET DEFAULT_MONTH =0 WHERE TID <> @TID AND ENTITY_ID = @EID
	UPDATE IVAP_MONTH_CLOSE SET DEFAULT_MONTH = 1,UPDATED_BY =@UID,UPDATED_ON =GETDATE() WHERE TID =@TID
	Exec MonthClose_HIS @TID,@UID,'Update' 
	SET @result =0  
	SELECT 0 as result
END
GO
/****** Object:  StoredProcedure [dbo].[SetDisplayOrder_down]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[SetDisplayOrder_FileCompDtl]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[SetDisplayOrder_UP]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[SetInputFileWorkFlow]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SetInputFileWorkFlow]
(
	@FileID INT,
	@UID INT,
	@No_Of_Records INT,
	@Tids varchar(Max),
	@Status  varchar(200),
	@Remarks varchar(Max)
)
As
BEGIN
	insert into IVAP_WF_Input(FileID,UID,No_Of_Records,TIDs,InDate,Status,Remarks)
	values(@FileID,@UID,@No_Of_Records,@Tids,getdate(),@Status,@Remarks);
	select 1;
END
GO
/****** Object:  StoredProcedure [dbo].[SetInputFileWorkFlow0]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SetInputFileWorkFlow0]
(
	@FileID INT,
	@UID INT,
	@No_Of_Records INT,
	@Tids varchar(Max),
	@Status  varchar(200),
	@Remarks varchar(Max),
	@PayDate varchar(20)
)
As
BEGIN
	insert into IVAP_WF_Input(FileID,UID,No_Of_Records,TIDs,InDate,Status,Remarks,PayDate)
	values(@FileID,@UID,@No_Of_Records,@Tids,getdate(),@Status,@Remarks,@PayDate);
	select 1;
END


select * from IVAP_WF_Input
GO
/****** Object:  StoredProcedure [dbo].[SetLogOut]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetLogOut]  
(  
 @UID INT  
)  
AS  
BEGIN  
 UPDATE IVAP_LOGIN_LOG Set LOGOUT_TIME=GetDate() where TID=(Select Top 1 tid FROM IVAP_LOGIN_LOG WHERE UID=@UID ORDER by TID DESC)  
END
GO
/****** Object:  StoredProcedure [dbo].[SetOrderFileCompDtl_Down]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[SetOrderFileCompDtl_UP]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[SetOrderTranspose_Down]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetOrderTranspose_Down]  
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
  
 SET @Dorder=(select ISNULL(Display_Order,0) from Ivap_Transpose_Setting where  TID=@TID)  
 SET @CurrDorder=@Dorder;  
 SET @Dorder=@Dorder+1;  
 DECLARE @lastRecord INT;  
 SET @lastRecord=(SELECT TOP 1 TID from Ivap_Transpose_Setting where  FILE_ID=@FILE_ID and Display_Order>@CurrDorder ORDER BY Display_Order )  
 UPDATE Ivap_Transpose_Setting set Display_Order =@Dorder where  TID=@TID;  
 UPDATE Ivap_Transpose_Setting set Display_Order =Display_Order-1 where  tid=@lastRecord;  
 SELECT 0 AS result  
END
GO
/****** Object:  StoredProcedure [dbo].[SetOrderTranspose_UP]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SetOrderTranspose_UP]  
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
  
 SET @Dorder=(select ISNULL(Display_Order,0) from Ivap_Transpose_Setting where  TID=@TID)  
 SET @CurrDorder=@Dorder;  
 IF(@Dorder>1)  
  SET @Dorder=@Dorder-1;  
 DECLARE @lastRecord INT;  
 SET @lastRecord=(SELECT TOP 1 TID from Ivap_Transpose_Setting where  FILE_ID=@FILE_ID and Display_Order<@CurrDorder ORDER BY Display_Order DESC )  
 UPDATE Ivap_Transpose_Setting set Display_Order =@Dorder where  TID=@TID;  
 UPDATE Ivap_Transpose_Setting set Display_Order =DISPLAY_ORDER+1 where  tid=@lastRecord;  
 SELECT 0 AS result  
END
GO
/****** Object:  StoredProcedure [dbo].[SetOutputFileWorkFlow]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SetOutputFileWorkFlow]
(
	@FileID INT,
	@UID INT,
	@No_Of_Records INT,
	@Tids varchar(Max),
	@Status  varchar(200),
	@Remarks varchar(Max)
)
As
BEGIN
	insert into IVAP_WF_Output(FileID,UID,No_Of_Records,TIDs,InDate,Status,Remarks)
	values(@FileID,@UID,@No_Of_Records,@Tids,getdate(),@Status,@Remarks);
	select 1;
END


 
GO
/****** Object:  StoredProcedure [dbo].[SetOutputFileWorkFlow0]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[SetOutputFileWorkFlow0]
(
	@FileID INT,
	@UID INT,
	@No_Of_Records INT,
	@Tids varchar(Max),
	@Status  varchar(200),
	@Remarks varchar(Max),
	@PayDate varchar(20)
)
As
BEGIN
	insert into IVAP_WF_Output(FileID,UID,No_Of_Records,TIDs,InDate,Status,Remarks,PayDate)
	values(@FileID,@UID,@No_Of_Records,@Tids,getdate(),@Status,@Remarks,@PayDate);
	select 1;
END


select * from IVAP_WF_Output
GO
/****** Object:  StoredProcedure [dbo].[SetStatus_ForMonthClose]    Script Date: 03-06-2019 19:23:41 ******/
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
			SET OPEN_DATE=@OPEN_DATE,CLOSED_DATE=@CLOSED_DATE,STATUS=@Status,
			UPDATED_BY =@UID,UPDATED_ON =GETDATE() WHERE TID =@TID
		END
		ELSE
		BEGIN
			UPDATE IVAP_MONTH_CLOSE
			SET CLOSED_DATE=@CLOSED_DATE,STATUS=@Status,
			UPDATED_BY =@UID,UPDATED_ON =GETDATE() WHERE TID =@TID
		END
		Exec MonthClose_HIS @TID,@UID,'Update' 
		SET @result =0  
	END
	SELECT 0 as result
END
GO
/****** Object:  StoredProcedure [dbo].[SetUserRights]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SetUserRights]
(
	@FileID INT,
	@EID INT,
	@UserRights VARCHAR(500)
)
AS
BEGIN
	UPDATE Ivap_Mst_Files SET UserRights =@UserRights WHERE FileID =@FileID AND EID = @EID
	SELECT 1
END
GO
/****** Object:  StoredProcedure [dbo].[STATE_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 CREATE PROC [dbo].[STATE_HISTORY]    
(    
@SID INT,     
@UpdatedBy INT,      
@Action VARCHAR(100)                          
)     
AS    
BEGIN    
INSERT INTO IVAP_HIS_STATE(SID,STATE_CODE,STATE_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,UPDATED_BY,ISACTIVE,ACTION,COUNTRY)    
SELECT TID,STATE_CODE,STATE_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action,COUNTRY FROM IVAP_MST_STATE  where TID=@SID  
END
GO
/****** Object:  StoredProcedure [dbo].[SUBFUNCTION_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[testfnFormatDate]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[testfnFormatDate] 
(
@Datetime DATETIME, 
@FormatMask VARCHAR(32)
)
AS

BEGIN

    DECLARE @StringDate VARCHAR(32)

    SET @StringDate = @FormatMask

    IF (CHARINDEX ('YYYY',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'YYYY',DATENAME(YY, @Datetime))
	   print @StringDate
    IF (CHARINDEX ('YY',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'YY',RIGHT(DATENAME(YY,@Datetime),2))
	   print @StringDate
    IF (CHARINDEX ('Month',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'Month',DATENAME(MM,@Datetime))
	   print @StringDate
    IF (CHARINDEX ('MON',@StringDate COLLATE SQL_Latin1_General_CP1_CS_AS)>0)

       SET @StringDate = REPLACE(@StringDate, 'MON',LEFT(UPPER(DATENAME(MM, @Datetime)),3))
	   print @StringDate
    IF (CHARINDEX ('Mon',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'Mon',LEFT(DATENAME(MM, @Datetime),3))
	   print @StringDate
    IF (CHARINDEX ('MM',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'MM',RIGHT('0'+CONVERT(VARCHAR,DATEPART(MM, @Datetime)),2))
	   print @StringDate
    IF (CHARINDEX ('M',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'M',CONVERT(VARCHAR,DATEPART(MM, @Datetime)))
	   print @StringDate
    IF (CHARINDEX ('DD',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'DD',RIGHT('0'+DATENAME(DD, @Datetime),2))
	   print @StringDate
    IF (CHARINDEX ('D',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'D',DATENAME(DD, @Datetime))
	   print @StringDate
select @StringDate

END



GO
/****** Object:  StoredProcedure [dbo].[TYPE_HISTORY]    Script Date: 03-06-2019 19:23:41 ******/
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
SELECT TID,ENTITY_ID,PAY_TYPE_CODE,ERP_TYPE_CODE,TYPE_NAME,CREATED_ON,CREATED_BY,UPDATE_ON,@UpdatedBy,ISACTIVE,@Action FROM IVAP_MST_TYPE  where TID=@CID    
END 
GO
/****** Object:  StoredProcedure [dbo].[update_Entity_menu]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateEntity]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateEntity_001]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[UpdateEntity_001]
(
@EntityID int,
@EntityName VARCHAR(100),
@EntityState int,
@EntityCity VARCHAR(50),
@EntityPIN VARCHAR(20),
@EntityAdd1 VARCHAR(max)='',
@EntityAdd2 VARCHAR(max)='',
@DomainName VARCHAR(50),
--@Payperiod VARCHAR(100),
@DateFormat VARCHAR(100),
@EntityCountry int,
@EntityCurrency int,
--@Payperiod_Weekly_Fr VARCHAR(30)='',
--@Payperiod_Weekly_To VARCHAR(30)='',
--@Payperiod_Monthly_Fr int,
--@Payperiod_Monthly_To int,
--@Payperiod_Fortnightly_Fr1 int,
--@Payperiod_Fortnightly_To1 int,
--@Payperiod_Fortnightly_Fr2 int,
--@Payperiod_Fortnightly_To2 int,
@Services_Availed varchar(100),
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
ISACTIVE=@IsAct,DATE_FORMAT=@DateFormat,COUNTRY=@EntityCountry,CURRENCY=@EntityCurrency,
--PAY_PERIOD=@Payperiod,Payperiod_Weekly_Fr=@Payperiod_Weekly_Fr,Payperiod_Weekly_To=@Payperiod_Weekly_To,Payperiod_Monthly_Fr=@Payperiod_Monthly_Fr,
--Payperiod_Monthly_To=@Payperiod_Monthly_To,Payperiod_Fortnightly_Fr1=@Payperiod_Fortnightly_Fr1,Payperiod_Fortnightly_To1=@Payperiod_Fortnightly_To1,
--Payperiod_Fortnightly_Fr2=@Payperiod_Fortnightly_Fr2,Payperiod_Fortnightly_To2=@Payperiod_Fortnightly_To2,
Services_Availed=@Services_Availed,
UPDATED_BY=@UID,UPDATE_ON=GETDATE() where TID=@EntityID
SET @Result =0
end
SELECT @Result AS result
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateFile_Component]    Script Date: 03-06-2019 19:23:41 ******/
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
 @COMPONENT_TABLE_NAME NVARCHAR(50),
 @COMPONENT_COLUMN_NAME NVARCHAR(50),
 @COMPONENT_DISPLAY_NAME NVARCHAR(50),
 @COMPONENT_DESCRIPTION NVARCHAR(50),
 @COMPONENT_DATATYPE NVARCHAR(50),
 @ISACTIVE int,
 @MIN_LENGTH INT,
 @MAX_LENGTH INT,
 @MANDATORY int,
 @HAS_RULE int,
 @GL_Code  NVARCHAR(50),
 @PMS_CODE NVARCHAR(50)
)
AS
BEGIN
 DECLARE @result INT =1  
UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_FILE_TYPE=@COMPONENT_FILE_TYPE,COMPONENT_TYPE=@COMPONENT_TYPE,COMPONENT_SUB_TYPE=@COMPONENT_SUB_TYPE,COMPONENT_NAME=@COMPONENT_NAME,COMPONENT_TABLE_NAME=@COMPONENT_TABLE_NAME,
COMPONENT_COLUMN_NAME=@COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION=@COMPONENT_DESCRIPTION,
COMPONENT_DATATYPE=@COMPONENT_DATATYPE,ISACTIVE=@ISACTIVE,
MIN_LENGTH=@MIN_LENGTH,MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,HAS_RULE=@HAS_RULE,GL_Code=@GL_Code,PMS_CODE=@PMS_CODE WHERE TID=@TID
SELECT @result as result 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileComponent_MASTER]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateFileComponent_MASTER]     
(    
 @TID INT,      
 @UID INT,    
 @COMPONENT_COLUMN_NAME NVARCHAR(50),    
 @COMPONENT_DISPLAY_NAME NVARCHAR(50),    
 @ISACTIVE int,      
 @MANDATORY int,    
 @GL_Code  NVARCHAR(50),    
 @PMS_CODE NVARCHAR(50)    
)    
AS    
BEGIN    
 DECLARE @result INT =1      
UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_COLUMN_NAME=@COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,ISACTIVE=@ISACTIVE,    
MANDATORY=@MANDATORY,GL_Code=@GL_Code,PMS_CODE=@PMS_CODE WHERE TID=@TID  

EXEC FILE_COMPONENT_HISTORY @TID,@UID,'UPDATE'   
SELECT @result as result     
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileComponent_MASTER_20_FEB]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateFileComponent_MASTER_20_FEB]      
(      
 @TID INT,        
 @UID INT,      
 @COMPONENT_COLUMN_NAME NVARCHAR(50),      
 @COMPONENT_DISPLAY_NAME NVARCHAR(50),      
 @ISACTIVE int,        
 @MANDATORY int,      
 @GL_Code  NVARCHAR(50),      
 @PMS_CODE NVARCHAR(50),
 @Extra_Input_Validation  NVARCHAR(100),      
 @Regular_Expression NVARCHAR(100)        
)      
AS      
BEGIN      
 DECLARE @result INT =1  
 DECLARE  @FileID int
 select @FileID=FILE_ID from IVAP_MST_FILE_COMP_DETAIL  where TID=@TID                
if exists(select * from IVAP_MST_FILE_COMP_DETAIL where FILE_ID=@FileID AND COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME  AND TID <> @TID)                    
begin              
set @result=-1                    
select @result as result                    
Return;                    
end     
     
UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_COLUMN_NAME=@COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,ISACTIVE=@ISACTIVE,      
MANDATORY=@MANDATORY,GL_Code=@GL_Code,PMS_CODE=@PMS_CODE,EXTRA_INPUT_VALIDATION=@Extra_Input_Validation,EXTRA_RG_EXPRESSION=@Regular_Expression WHERE TID=@TID    
  
EXEC FILE_COMPONENT_HISTORY @TID,@UID,'UPDATE'     
SELECT @result as result       
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileComponent_New]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateFileComponent_New] 
(
 @TID INT,  
 @UID INT,
 @COMPONENT_DISPLAY_NAME NVARCHAR(50),
 @ISACTIVE int,
 @MIN_LENGTH INT,
 @MAX_LENGTH INT,
 @MANDATORY int,
 @GL_Code  NVARCHAR(50),
 @PMS_CODE NVARCHAR(50)
)
AS
BEGIN
 DECLARE @result INT =1  
UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,ISACTIVE=@ISACTIVE,
MIN_LENGTH=@MIN_LENGTH,MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,GL_Code=@GL_Code,UPDATED_ON=GETDATE(),PMS_CODE=@PMS_CODE WHERE TID=@TID
EXEC FILE_COMPONENT_HISTORY @TID,@UID,'UPDATE' 
SELECT @result as result 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileComponent_New_20_FEB]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateFileComponent_New_20_FEB]   
(  
 @TID INT,    
 @UID INT,  
 @COMPONENT_DISPLAY_NAME NVARCHAR(50),  
 @ISACTIVE int,  
 @MIN_LENGTH INT,  
 @MAX_LENGTH INT,  
 @MANDATORY int,  
 @GL_Code  NVARCHAR(50),  
 @PMS_CODE NVARCHAR(50),
 @Extra_Input_Validation  NVARCHAR(100),      
 @Regular_Expression NVARCHAR(100)   
)  
AS  
BEGIN  
 DECLARE @result INT=1   
 DECLARE  @FileID int
 select @FileID=FILE_ID from IVAP_MST_FILE_COMP_DETAIL where TID=@TID              
if exists(select * from IVAP_MST_FILE_COMP_DETAIL where FILE_ID=@FileID AND UPPER(COMPONENT_DISPLAY_NAME)=UPPER(@COMPONENT_DISPLAY_NAME)  AND TID <> @TID)                    
begin              
set @result=-1                    
select @result as result                    
Return;                    
end   
  
UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,ISACTIVE=@ISACTIVE,  
MIN_LENGTH=@MIN_LENGTH,MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,GL_Code=@GL_Code,UPDATED_ON=GETDATE(),PMS_CODE=@PMS_CODE,
EXTRA_INPUT_VALIDATION=@Extra_Input_Validation,EXTRA_RG_EXPRESSION=@Regular_Expression WHERE TID=@TID  
EXEC FILE_COMPONENT_HISTORY @TID,@UID,'UPDATE'   
SELECT @result as result 
  
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileComponent_New1502]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateFileComponent_New1502] 
(
 @TID varchar(max),  
 @UID INT,
 @COMPONENT_DISPLAY_NAME NVARCHAR(50),
 @ISACTIVE int,
 @MIN_LENGTH INT,
 @MAX_LENGTH INT,
 @MANDATORY int,
 @GL_Code  NVARCHAR(50),
 @PMS_CODE NVARCHAR(50),
 @ENTITYCOMPID INT =0
)
AS
BEGIN
 DECLARE @result INT =1  
 IF(@ENTITYCOMPID=0)
 BEGIN
UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,ISACTIVE=@ISACTIVE,
MIN_LENGTH=@MIN_LENGTH,MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,GL_Code=@GL_Code,PMS_CODE=@PMS_CODE WHERE TID=@TID
EXEC FILE_COMPONENT_HISTORY @TID,@UID,'UPDATE' 
END
IF(@ENTITYCOMPID>0)
BEGIN
UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_DISPLAY_NAME=@COMPONENT_DISPLAY_NAME,ISACTIVE=@ISACTIVE,
MIN_LENGTH=@MIN_LENGTH,MAX_LENGTH=@MAX_LENGTH,MANDATORY=@MANDATORY,GL_Code=@GL_Code,PMS_CODE=@PMS_CODE WHERE TID in (@TID)
--EXEC FILE_COMPONENT_HISTORY @TID,@UID,'CASHCADE' 
END
SELECT @result as result
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateFileComponentDTLCashcade]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateFileComponentDTLCashcade]
(
 @TID varchar(max),  
 @UID INT
)
AS
BEGIN
 DECLARE @result INT =1  
BEGIN
UPDATE IVAP_MST_FILE_COMP_DETAIL SET COMPONENT_DISPLAY_NAME=CE.COMPONENT_DISPLAY_NAME,UPDATED_BY=@UID,UPDATED_ON=GETDATE(),
MIN_LENGTH=CE.MIN_LENGTH,MAX_LENGTH=CE.MAX_LENGTH,MANDATORY=CE.MANDATORY,GL_Code=CE.GL_Code,PMS_CODE=CE.PMS_CODE
FROM IVAP_MST_FILE_COMP_DETAIL CD inner join IVAP_MST_COMPONENT_ENTITY CE on CD.COMPONENT_ID =CE.TID
 WHERE CD.TID in (SELECT * from dbo.SplitString((@TID),','))

 INSERT INTO IVAP_HIS_FILE_COMP_DETAIL(FID,FILE_ID,COMPONENT_ID,CREATED_ON,CREATED_BY,UPDATED_ON,UPDATED_BY,ISACTIVE,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,
 COMPONENT_COLUMN_NAME,COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE,ACTION)
	SELECT TID,FILE_ID,COMPONENT_ID,CREATED_ON,CREATED_BY,getdate(),@UID,ISACTIVE,Display_Order,ENTITY_ID,COMPONENT_FILE_TYPE,COMPONENT_TYPE,COMPONENT_SUB_TYPE,COMPONENT_NAME,COMPONENT_DATATYPE,COMPONENT_TABLE_NAME,COMPONENT_COLUMN_NAME,
 COMPONENT_DISPLAY_NAME,COMPONENT_DESCRIPTION,MIN_LENGTH,MAX_LENGTH,MANDATORY,HAS_RULE,Globle_Component_ID,GL_Code,PMS_CODE,'CASHCADE' FROM IVAP_MST_FILE_COMP_DETAIL where TID in (SELECT * from dbo.SplitString((@TID),','))
--EXEC FILE_COMPONENT_HISTORY @TID,@UID,'CASHCADE' 
SELECT @result as result
END
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateMenu]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[UpdateMOM]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[UpdateMOM]
(
 @MID int,
 @ENTITY_ID int
,@MEETING_HELD datetime
,@MEETING_ATTENDEES NVARCHAR(200)
,@ADDRESS nvarchar(max)
,@AGENDA nvarchar(max)
,@CREATED_BY int
,@ISACTIVE char(1)
)
As
	Begin
			Update IVAP_MST_MOM set MEETING_HELD=@MEETING_HELD,MEETING_ATTENDEES=@MEETING_ATTENDEES,
			ADDRESS=@ADDRESS,AGENDA=@AGENDA,LASTUPDATE=GETDATE(),ISACTIVE=@ISACTIVE where tid=@MID
			select 0
	End

GO
/****** Object:  StoredProcedure [dbo].[UPLOADTEMPTABLE]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[UPLOADTEMPTABLE_NEW]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[User_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[UserRole_History]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[UserSignUp]    Script Date: 03-06-2019 19:23:41 ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insertKeyWord]    Script Date: 03-06-2019 19:23:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_insertKeyWord] (@keyword varchar(100))
as
begin
declare @cnt int
select @cnt = count(*) from IVAP_MST_KEYWORD where keyword = @keyword 
if @cnt >0
begin
select 'Already Exist'
end
else
begin
insert into IVAP_MST_KEYWORD (KEYWORD, CREATED_ON, CREATED_BY, ISACTIVE) values(@keyword , getdate(), 1, 1)
select 'Added'
end


end
GO
/****** Object:  StoredProcedure [dbo].[Workflowsetting_History]    Script Date: 03-06-2019 19:23:41 ******/
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
