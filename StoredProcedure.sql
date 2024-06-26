USE [ProductDB]
GO
/****** Object:  StoredProcedure [dbo].[SlowlyCahangeDimension_Product]    Script Date: 7/04/2024 6:34:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Mojgan Edalat Nejad
-- Create date:  06/04/2024
-- Description:	 Three Level of Slowly Chang Dimension In Product Table
-- =============================================
CREATE PROCEDURE [dbo].[SlowlyCahangeDimension_Product]
AS
BEGIN
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..##UpdatedPrice') IS NOT NULL
		DROP TABLE ##UpdatedPrice;

	--- SCD Type 0 ProductName and Brand Could not changed
	IF 
	   (SELECT Count(p.Name)
	   FROM Dim.Product p
		INNER JOIN  Stage.Stage_Product sg on p.[ProductAltKey]=sg.[ProductAltKey]
		WHERE p.Name!=sg.Name OR p.Brand!=sg.Brand)>0

	BEGIN
		THROW 50000, 'Not Matched Data.The Load is failed!', 1
		RETURN
	END
	---- SCD Type 1 Update OutOfStock,Url  in place
	UPDATE  Dim.Product 
	SET [Product].[OutOfStock]=[Stage_Product].[OutOfStock],
	    [Product].[Url]=[Stage_Product].[Url]
	FROM  Dim.Product 
	JOIN  Stage.Stage_Product  ON [Product].[ProductAltKey]=[Stage_Product].[ProductAltKey]

	--- SCD Type 2 (Price)
	SELECT  sg.* into ##UpdatedPrice
	FROM Dim.Product p
		INNER JOIN  Stage.Stage_Product sg on p.[ProductAltKey]=sg.[ProductAltKey]
		WHERE p.[Price]!=sg.[Price] and p.EndDate is NUll
-------------------------- Update the EndDate of Last Record with current date
	UPDATE  Dim.Product 
	SET [Product].EndDate=GETDATE()
	FROM   Dim.Product 
	JOIN ##UpdatedPrice ON ##UpdatedPrice.[ProductAltKey]=[Product].[ProductAltKey]
	WHERE   [Product].EndDate is NULL
--------------------------- Insert New Record with new price
	INSERT INTO [ProductDB]. Dim.Product 
	SELECT [ProductAltKey]
		  ,[Name]
		  ,[Price]
		  ,[Brand]
		  ,[OutOfStock]
		  ,[Url]
		  ,GETDATE() StartDate
		  ,NULL EndDate
	FROM ##UpdatedPrice
END
GO
