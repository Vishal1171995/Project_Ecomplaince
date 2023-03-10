USE [IVAP]
GO
/****** Object:  User [IVAP]    Script Date: 03-06-2019 19:02:43 ******/
CREATE USER [IVAP] FOR LOGIN [IVAP] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [IVAP]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [IVAP]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [IVAP]
GO
/****** Object:  UserDefinedFunction [dbo].[CapitalizeFirstLetter]    Script Date: 03-06-2019 19:02:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CapitalizeFirstLetter]
(
--string need to format
@string VARCHAR(200)--increase the variable size depending on your needs.
)
RETURNS VARCHAR(200)
AS

BEGIN
--Declare Variables
DECLARE @Index INT,
@ResultString VARCHAR(200)--result string size should equal to the @string variable size
--Initialize the variables
SET @Index = 1
SET @ResultString = ''
--Run the Loop until END of the string

WHILE (@Index <LEN(@string)+1)
BEGIN
IF (@Index = 1)--first letter of the string
BEGIN
--make the first letter capital
SET @ResultString =
@ResultString + UPPER(SUBSTRING(@string, @Index, 1))
SET @Index = @Index+ 1--increase the index
END

-- IF the previous character is space or '-' or next character is '-'

ELSE IF ((SUBSTRING(@string, @Index-1, 1) =' 'or SUBSTRING(@string, @Index-1, 1) ='-' or SUBSTRING(@string, @Index+1, 1) ='-') and @Index+1 <> LEN(@string))
BEGIN
--make the letter capital
SET
@ResultString = @ResultString + UPPER(SUBSTRING(@string,@Index, 1))
SET
@Index = @Index +1--increase the index
END
ELSE-- all others
BEGIN
-- make the letter simple
SET
@ResultString = @ResultString + LOWER(SUBSTRING(@string,@Index, 1))
SET
@Index = @Index +1--incerase the index
END
END--END of the loop

IF (@@ERROR
<> 0)-- any error occur return the sEND string
BEGIN
SET
@ResultString = @string
END
-- IF no error found return the new string
RETURN @ResultString
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnFormatDate]    Script Date: 03-06-2019 19:02:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnFormatDate] (@Datetime DATETIME, @FormatMask VARCHAR(32))

RETURNS VARCHAR(32)

AS

BEGIN

    DECLARE @StringDate VARCHAR(32)

    SET @StringDate = @FormatMask

    IF (CHARINDEX ('YYYY',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'YYYY',

                         DATENAME(YY, @Datetime))

    IF (CHARINDEX ('YY',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'YY',

                         RIGHT(DATENAME(YY, @Datetime),2))

    IF (CHARINDEX ('Month',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'Month',

                         DATENAME(MM, @Datetime))

    IF (CHARINDEX ('MON',@StringDate COLLATE SQL_Latin1_General_CP1_CS_AS)>0)

       SET @StringDate = REPLACE(@StringDate, 'MON',

                         LEFT(UPPER(DATENAME(MM, @Datetime)),3))

    IF (CHARINDEX ('Mon',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'Mon',

                                     LEFT(DATENAME(MM, @Datetime),3))

    IF (CHARINDEX ('MM',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'MM',RIGHT('0'+CONVERT(VARCHAR,DATEPART(MM, @Datetime)),2))

    --IF (CHARINDEX ('M',@StringDate) > 0)

    --   SET @StringDate = REPLACE(@StringDate, 'M',

    --                     CONVERT(VARCHAR,DATEPART(MM, @Datetime)))

    IF (CHARINDEX ('DD',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'DD',

                         RIGHT('0'+DATENAME(DD, @Datetime),2))

    IF (CHARINDEX ('D',@StringDate) > 0)

       SET @StringDate = REPLACE(@StringDate, 'D',

                                     DATENAME(DD, @Datetime))

RETURN @StringDate

END

GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 03-06-2019 19:02:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split] ( @strString varchar(5000))
RETURNS  @Result TABLE(Value VARCHAR(Max))
AS
begin
    WITH StrCTE(start, stop) AS
    (
      SELECT  1, CHARINDEX(',' , @strString )
      UNION ALL
      SELECT  stop + 1, CHARINDEX(',' ,@strString  , stop + 1)
      FROM StrCTE
      WHERE stop > 0
    )
   
    insert into @Result
    SELECT   SUBSTRING(@strString , start, CASE WHEN stop > 0 THEN stop-start ELSE 4000 END) AS stringValue
    FROM StrCTE
   
    return
end   
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 03-06-2019 19:02:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
