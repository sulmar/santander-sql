

-- 1. Tworzymy grupê plików

alter database AdventureWorks
	add filegroup AWMemGroup contains MEMORY_OPTIMIZED_DATA

-- 2. Dodajemy folder(!) do grupy plików

alter database AdventureWorks
	add file 
	(
		Name = N'inmem_demo',
		Filename = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\inmem_demo'
	)
	to filegroup AWMemGroup


select 
	name,
	type,
	type_desc
 from sys.filegroups


 -- | DeviceId | CustomerId | 


 create table Santander.DeviceCustomers
 (
	DeviceId int identity(1, 1) primary key nonclustered hash with (bucket_count=40000),
	CustomerId int not null
 )
 WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_ONLY)


-- SCHEMA_ONLY - dane bêd¹ przechowywane tylko w pamiêci
-- SCHEMA_AND_DATA - dane bêd¹ przechowywane w pamiêci i co pewien czas zrzucane na dysk (tzw. checkpoint)

select
	name,
	is_memory_optimized,
	durability,
	durability_desc
from 
	sys.tables

-- Wstawienie przyk³adowych danych

declare @counter int = 0
declare @NumOfRows int = 100000

while @counter <= @NumOfRows
begin
	insert into Santander.DeviceCustomers(CustomerId)
		values( CAST( RAND() * 1000 as int))

	set @counter = @counter + 1
end


 select * from Santander.DeviceCustomers where DeviceId between 109071 and  119071

-- w³¹czenie statystyk w celu diagnostyki
  set statistics io, time on

-- zajêtoœæ pamiêci
  SELECT 
	t.object_id, 
	t.name, 
	ISNULL((SELECT CONVERT(decimal(18,2),(TMS.memory_used_by_table_kb)/1024.00)), 0.00) AS table_used_memory_in_mb,
	ISNULL((SELECT CONVERT(decimal(18,2),(TMS.memory_allocated_for_table_kb - TMS.memory_used_by_table_kb)/1024.00)), 0.00) AS table_unused_memory_in_mb,
	ISNULL((SELECT CONVERT(decimal(18,2),(TMS.memory_used_by_indexes_kb)/1024.00)), 0.00) AS index_used_memory_in_mb,
	ISNULL((SELECT CONVERT(decimal(18,2),(TMS.memory_allocated_for_indexes_kb - TMS.memory_used_by_indexes_kb)/1024.00)), 0.00) AS index_unused_memory_in_mb
FROM 
	sys.tables t JOIN sys.dm_db_xtp_table_memory_stats TMS ON (t.object_id = TMS.object_id)
	


-- triggers

  alter table [Santander].[AccountOperations]
	add  ModifiedDate datetime2 null

alter table [Santander].[AccountOperations]
	add  CreatedDate datetime2 null





insert into Santander.AccountOperations (AccountOperationId, Account, OperationDate, OperationTypeId, OperationStatus)
	values (100023, '123490104', '2020-05-19 9:58', 1, 'OK')

go


-- Trigger na wstawianie (insert)

drop trigger Santander.trgAccountOperations

create or alter trigger Santander.trgAccountOperationsOnInsert
 ON Santander.AccountOperations
 AFTER INSERT
 AS
 BEGIN

	SET NOCOUNT ON;

	update Santander.AccountOperations 
		set CreatedDate = GETDATE()
		 from inserted 
			 where inserted.AccountOperationId = Santander.AccountOperations.AccountOperationId
		-- where Santander.AccountOperations.AccountOperationId in (select AccountOperationId from inserted)
	
 END
	
go

create or alter trigger Santander.trgAccountOperationsOnUpdate
 ON Santander.AccountOperations
 AFTER UPDATE
 AS
 BEGIN

	SET NOCOUNT ON;

	update Santander.AccountOperations 
		set ModifiedDate = GETDATE()
		 from deleted 
			 where deleted.AccountOperationId = Santander.AccountOperations.AccountOperationId
		-- where Santander.AccountOperations.AccountOperationId in (select AccountOperationId from deleted)
	
 END


 select top 10 * from [Santander].[AccountOperations] order by AccountOperationId desc


 update [Santander].[AccountOperations]
	set OperationStatus = 'OK'
		where AccountOperationId = 100017

GO

create or alter trigger Santander.trgAccountOperationsOnDelete
 ON Santander.AccountOperations
 AFTER DELETE
 AS
 BEGIN

	SET NOCOUNT ON;

	 insert into [Santander].[BlockedAccounts]
		select 
			AccountOperationId,
			Account
		from
			deleted

END



 delete from [Santander].[AccountOperations]
 where AccountOperationId = 100015

-- INSERT inserted
-- UPDATE deleted
-- DELETE deleted


GO


create or alter trigger Santander.trgAccountOperationsOnBeforeInsert
 ON Santander.AccountOperations
 INSTEAD OF INSERT
 AS
 BEGIN

	SET NOCOUNT ON;

	insert into [Santander].[BlockedAccounts]
		select 
			AccountOperationId,
			Account
		from	
			inserted

END


insert into Santander.AccountOperations (AccountOperationId, Account, OperationDate, OperationTypeId, OperationStatus)
	values (100025, '123490999', '2020-05-19 9:58', 1, 'OK')

	
 select top 10 * from [Santander].[AccountOperations] order by AccountOperationId desc


 select * from [Santander].[BlockedAccounts]


 -- A (update)   ->    B (update) 


 begin tran
 
 update Santander.AccountOperations 
 set OperationStatus = 'EX'

 delete from [Santander].[BlockedAccounts]

 commit

 rollback


 -- poziom izolacji (dirty-data)

begin tran 

 insert into Orders

 update update Stacks
	set Stack = Stack - OrderQuantity
	
commit

-- Invoices
-- LastNumbers


-- Operacje na zbiorach

select Account from [Santander].[AccountOperations]  where OperationStatus = 'OK'
intersect   -- intersection - czeœæ wspólna zbiorów 
select Account from [Santander].[BlockedAccounts]

select Account from [Santander].[AccountOperations]
except   -- ró¿nica zbiorów
select Account from [Santander].[BlockedAccounts]


go


;with cte_ExceptionAccountOperations as
(
   select distinct Account from [Santander].[AccountOperations] where OperationStatus = 'EX'
),

cte_BlockedAccountOperations as 
(
	select Account from [Santander].[BlockedAccounts]
),

cte_AllAccountOperations as 
(
	select distinct Account from [Santander].[AccountOperations]
)


(select Account from cte_AllAccountOperations
union 
select Account from cte_BlockedAccountOperations
)
except
select Account  from cte_ExceptionAccountOperations

order by Account



-- Funkcje okienkowe (Window Functions)

--- Funkcje rankingowe

select 
	ROW_NUMBER() OVER (ORDER BY OperationDate) as RowNumber,
	Account,
	OperationDate
from [Santander].[AccountOperations] 
where OperationTypeId = 1 and OperationStatus = 'OK'
and OperationDate between '2020-05-01' and '2020-05-10'
order by RowNumber



select 
	ROW_NUMBER() OVER (
		PARTITION BY OperationTypeId
		ORDER BY OperationDate) as RowNumber,
	Account,
	OperationDate,
	OperationTypeId
from [Santander].[AccountOperations] 
where  OperationStatus = 'OK'
and OperationDate between '2020-05-01' and '2020-05-10'
order by OperationTypeId, RowNumber


select
	ROW_NUMBER() OVER (
		PARTITION BY Account
		ORDER BY AccountOperationId
		) as RowNumber,
	Account,
	OperationDate
 from  [Santander].[AccountOperations] 
 order by Account, RowNumber


 select 
	RANK() OVER (
		ORDER BY SubTotal DESC) as [Rank],
	SubTotal,
	TerritoryID
from Sales.SalesOrderHeader
order by SubTotal desc



 select 
	RANK() OVER (
		PARTITION BY TerritoryID
		ORDER BY SubTotal DESC) as [Rank],
	SubTotal,
	TerritoryID
from Sales.SalesOrderHeader
order by TerritoryID, SubTotal desc

-- select 
--	DENSE_RANK() OVER (
--		PARTITION BY TerritoryID
--		ORDER BY SubTotal DESC) as [Rank],
--	SubTotal,
--	TerritoryID
--from Sales.SalesOrderHeader
--order by TerritoryID, SubTotal desc

SELECT 
	sp.FirstName,
	sp.LastName,
	sum(soh.SubTotal) as TotalSales,
	NTILE(2) OVER (ORDER BY sum(soh.SubTotal) ASC) as Bonus
 from
	 Sales.SalesOrderHeader as soh
	inner join Sales.vSalesPerson as sp
		on sp.BusinessEntityID = soh.SalesPersonID
where
	soh.OrderDate between '2010-06-01' and '2011-06-30'
group by
	sp.FirstName,
	sp.LastName

-- 1000
-- 2000
-- 3000
-- 4000


-- funkcje agreguj¹ce okna

select
	SubTotal,
	sum(SubTotal) OVER (ORDER BY SalesOrderId) as RunningTotal
from 
	 Sales.SalesOrderHeader


	 
select
	SubTotal,
	TerritoryId,
	sum(SubTotal) OVER (
		PARTITION BY TerritoryId
		ORDER BY SalesOrderId) as RunningTotal
from 
	 Sales.SalesOrderHeader


select
	SubTotal,
	TerritoryId,
	sum(SubTotal) OVER (
		PARTITION BY TerritoryId
		ORDER BY SalesOrderId) as RunningTotal,
	count(SubTotal) OVER (
		PARTITION BY TerritoryId
		ORDER BY SalesOrderId) as RunningCount,
	avg(SubTotal) OVER (
		PARTITION BY TerritoryId
		ORDER BY SalesOrderId) as RunningAvg

from 
	 Sales.SalesOrderHeader

-- Offsetowe funkcje okna


--- Poprzednik

SELECT
	CustomerID,
	OrderDate,
	SalesOrderID,
	LAG(SalesOrderID) OVER(ORDER BY SalesOrderID) AS PrevOrderId,
	SubTotal,
	LAG(SubTotal) OVER(ORDER BY SalesOrderID) AS PrevSubTotal,
	LAG(SubTotal) OVER(ORDER BY SalesOrderID) - SubTotal  AS DeltaSubTotal 
 from 
	 Sales.SalesOrderHeader
order by OrderDate
	

SELECT
	CustomerID,
	OrderDate,
	SalesOrderID,
	LAG(SalesOrderID) OVER(ORDER BY SalesOrderID) AS PrevOrderId,
	LAG(SalesOrderID, 5, 0) OVER(ORDER BY SalesOrderID) AS PrevPrevOrderId,
	SubTotal,
	LAG(SubTotal) OVER(ORDER BY SalesOrderID) AS PrevSubTotal,
	LAG(SubTotal) OVER(ORDER BY SalesOrderID) - SubTotal  AS DeltaSubTotal 
 from 
	 Sales.SalesOrderHeader
order by OrderDate

--- Nastêpnik

SELECT
	CustomerID,
	OrderDate,
	SalesOrderID,
	LEAD(SalesOrderID) OVER(ORDER BY SalesOrderID) AS NextOrderId,
	SubTotal,
	LEAD(SubTotal) OVER(ORDER BY SalesOrderID) AS NextSubTotal,
	LEAD(SubTotal) OVER(ORDER BY SalesOrderID) - SubTotal  AS DeltaSubTotal 
 from 
	 Sales.SalesOrderHeader
order by OrderDate
	
	
SELECT
	CustomerID,
	OrderDate,
	SalesOrderID,
	LEAD(SalesOrderID) OVER(ORDER BY SalesOrderID) AS NextOrderId,
	LEAD(SalesOrderID, 2, null) OVER(ORDER BY SalesOrderID) AS NextNextOrderId
 from 
	 Sales.SalesOrderHeader
order by OrderDate


-- Pivot


select 
	DaysToManufacture,
	StandardCost
 from 
	Production.Product

select 
	DaysToManufacture, 
	AVG(StandardCost) as AvgCost
 from 
	Production.Product
group by DaysToManufacture

	                   
go


select 
	'œrednia' as AvgCost,
	[0], [1], [2], [3], [4]
FROM

(select 
	DaysToManufacture,
	StandardCost
 from 
	Production.Product) AS SourceTable
PIVOT
(
	AVG(StandardCost)
	FOR DaysToManufacture IN ( [0], [1], [2], [3], [4] )
) AS PivotTable


-- UNPIVOT
	
CREATE TABLE pvt (VendorID int, Emp1 int, Emp2 int,  
    Emp3 int, Emp4 int, Emp5 int);  
GO  
INSERT INTO pvt VALUES (1,4,3,5,4,4);  
INSERT INTO pvt VALUES (2,4,1,5,5,5);  
INSERT INTO pvt VALUES (3,4,3,5,4,4);  
INSERT INTO pvt VALUES (4,4,2,5,5,4);  
INSERT INTO pvt VALUES (5,5,1,5,5,5);  

select * from pvt

GO  
-- Unpivot the table.  
SELECT VendorID, Employee, Orders  
FROM   
   (SELECT VendorID, Emp1, Emp2, Emp3, Emp4, Emp5  
   FROM pvt) p  
UNPIVOT  
   (Orders FOR Employee IN   
      (Emp1, Emp2, Emp3, Emp4, Emp5)  
)AS unpvt;  
GO  



SELECT
	Color,
	ListPrice
FROM Production.Product
where Color is not null


-- | Red | Black | Green | 


-- zastosowanie IIF zamiast Pivot

SELECT
	SUM(IIF(Color = 'Black', ListPrice, 0)) AS Black,
	SUM(IIF(Color = 'Red', ListPrice, 0)) AS Red,
	SUM(IIF(Color = 'Green', ListPrice, 0)) AS Green,
	SUM(ListPrice) AS Total

FROM Production.Product
where Color is not null


-- CLR Stored Procedures


-- 1. w³aczamy CLR

go

sp_configure 'clr enabled', 1

go

reconfigure

go

-- 2. wy³aczenie zabezpieczeñ (tylko do celów testowych!!!)

exec sp_configure 'clr strict security', 0

go

reconfigure

go

-- 3. Rejestracja biblioteki

create assembly CLRStoredProcedures
FROM 'C:\temp\santander\Santander.SQL.CLRStoredProcedures.dll'


-- 4. Rejestracja procedury
go

create procedure usp_HelloWorld
AS 
EXTERNAL NAME CLRStoredProcedures.[Santander.SQL.CLRStoredProcedures.StoredProcedures].HelloWorld;

-- UWAGA: sk³adnia EXTERNAL NAME AssemblyName.[NamespaceName.ClassName].MethodName

-- Spatial Types (geograficzne, geometryczne)


exec usp_HelloWorld

GO


-- Debugowanie procedur sk³adowanych


CREATE PROCEDURE [dbo].[spShowOddNumbers]
@LowerRange INT,
@UpperRange INT
AS
BEGIN
  WHILE(@LowerRange < @UpperRange)
  BEGIN
    if(@LowerRange%2 != 0)
    BEGIN
      PRINT @LowerRange
    END
    SET @LowerRange = @LowerRange + 1
  END
  PRINT 'PRINTED ODD NUMBERS BETWEEN ' + RTRIM(@lowerRange) + ' and ' + RTRIM(@UpperRange)
END
GO

exec [dbo].[spShowOddNumbers] 0, 100

  set statistics io, time off