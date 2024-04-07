USE [ProductDB]

INSERT INTO [Stage].Stage_Product
		 SELECT [ProductAltKey]
			  ,[Name]
			  ,[Price]
			  ,[Brand]
			  ,[OutOfStock]
			  ,[Url]
		  FROM  [Dim].[Product]

 ----- Test SCD 1
Update [Stage].Stage_Product 
SET [OutOfStock]=1 where  [ProductAltKey]='00172f7f-1223-57c0-87a4-c7db24218544' 

------Test SCD2 
Update [Stage].Stage_Product 
SET price=5380 where  [ProductAltKey]='00005493-1875-5b43-8061-20c7d0cbe6b1' 

-------------
--Update [Dim].Product 
--SET [OutOfStock]=1 where  [ProductAltKey]='00172f7f-1223-57c0-87a4-c7db24218544' 
--Update [Dim].Product 
--SET price=545 where  [ProductAltKey]='00005493-1875-5b43-8061-20c7d0cbe6b1' 
--------------------------
exec [dbo].[SlowlyCahangeDimension_Product] with recompile

select * from  dim.Product 
where  [ProductAltKey]='00172f7f-1223-57c0-87a4-c7db24218544' 

------Test SCD2 
select * from  dim.Product 
  where  [ProductAltKey]='00005493-1875-5b43-8061-20c7d0cbe6b1' 