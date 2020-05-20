select top(20) percent * from Santander.AccountOperations 

select top(20)  * from Santander.AccountOperations order by AccountOperationId desc


select COUNT(*) FROM Santander.AccountOperations 

-- Stronicowanie

select * FROM Santander.AccountOperations 
order by AccountOperationId
OFFSET 15 ROWS
FETCH NEXT 10 ROWS ONLY

-- ROWS = ROW

select * FROM Santander.AccountOperations 
order by AccountOperationId
OFFSET 1 ROW
FETCH NEXT 1 ROW ONLY

select * FROM Santander.AccountOperations 
order by AccountOperationId
OFFSET 1 ROW
FETCH FIRST 5 ROWS ONLY


-- podzapytania

select top(100) * FROM Santander.AccountOperations 

create table Santander.BlockedAccounts
(
	BlockedId int not null primary key,
	Account varchar(9) not null
)



insert into Santander.BlockedAccounts
	values 
		(1, '123479060'),
		(2, '123447002'),
		(3, '123496943'),
		(4, '123484086'),
		(5, '123407362')


select top(100) * FROM Santander.AccountOperations 
select * from Santander.BlockedAccounts

-- Zadanie
-- Pobierz operacje, które by³y realizowane na zamkniêtych kontach


-- podzapytania nieskorelowane
SELECT * FROM Santander.AccountOperations	WHERE Account IN (SELECT Account FROM Santander.BlockedAccounts)

-- podzapytania skorelowane
select * from Santander.AccountOperations as ao
	where EXISTS (
		select Account from [Santander].[BlockedAccounts] as ba
		where ao.Account = ba.Account
		)


select ao.* from Santander.AccountOperations as ao inner join Santander.BlockedAccounts 
	on Santander.BlockedAccounts.Account = ao.Account

SELECT o.* FROM [Santander].[BlockedAccounts] b 	inner JOIN [Santander].[AccountOperations] o	ON b.[Account]=o.[Account]




Select Account into #temp from Santander.BlockedAccountsselect * from Santander.AccountOperationswhere Account in (select * from #temp)



			
SELECT * FROM 
(SELECT * FROM Santander.AccountOperations	WHERE Account IN (SELECT Account FROM Santander.BlockedAccounts)) as Blocked


-- Ile by³o operacji na zablokowanych kontach?
-- | Account | Quantity |

SELECT 	Account, 	count(*) AS 'suma' FROM 	[Santander].[AccountOperations] WHERE 	Account in (SELECT Account FROM [Santander].[BlockedAccounts])GROUP BY 	Account-- podzapytanie skorelowaneSELECT Account,	(SELECT COUNT(*) FROM [Santander].[AccountOperations] as ao WHERE ba.Account = ao.Account) as QuantityFROM 	[Santander].[BlockedAccounts] as ba

GO


 --accounts
	--.Where(a=>a == '565454')
	--.OrderBy()
	--.Select(

-- Wyra¿enia CTE (Commom Table Expression)

SELECT 1

;WITH cteBlockedAccount AS 
(
	SELECT Account FROM [Santander].[BlockedAccounts] WHERE BlockedId > 0
),

cteGroupedAccount AS
(
	SELECT 		Account, 		count(*) AS Quantity	FROM 		[Santander].[AccountOperations] 	WHERE 		Account in (SELECT Account FROM cteBlockedAccount)	GROUP BY 		Account
)

SELECT 
	SUM(Quantity) as TotalQuantity
FROM 
	cteGroupedAccount as g


-- tabele tymczasowe
go

create or alter procedure uspBlockedAccountsTempTest as
begin
	Select Account into #BlockedAccountsTemp from Santander.BlockedAccounts

	select count(*) from #BlockedAccountsTemp
end

exec uspBlockedAccountsTempTest

select * from #BlockedAccountsTemp


-- globalna tabela tymczasowa


-- create table #temp

Select Account into ##global_temp from Santander.BlockedAccounts

select * from ##global_temp

go

create or alter procedure uspBlockedAccountsGlobalTempTest as
begin
	Select Account into ##GlobalBlockedAccountsTemp from Santander.BlockedAccounts

	select count(*) from ##GlobalBlockedAccountsTemp
end

exec uspBlockedAccountsGlobalTempTest

select * from ##GlobalBlockedAccountsTemp

drop table  ##GlobalBlockedAccountsTemp



-- Variables

declare @x int 
set @x = 100
print @x

declare @y int = 20
print @y

-- Table-Variables

declare @BlockedAccounts TABLE
(
	Id int identity(1,1) primary key,
	Account varchar(9) unique,
	Quantity int check(Quantity>0)
)

insert into @BlockedAccounts (Account, Quantity)
	SELECT Account, 5 FROM [Santander].[BlockedAccounts]

	
select * from @BlockedAccounts


-- Table-Valued Functions (TVF)

-- ...


-- Views

go

alter VIEW vwTotalAccounts AS
(

SELECT 	Account, 	count(*) AS QuantityFROM 	[Santander].[AccountOperations] WHERE 	Account in (SELECT Account FROM [Santander].[BlockedAccounts])GROUP BY 	Account 
	) 

select * from vwTotalAccounts  order by Quantity

update vwTotalAccounts
	set Quantity = 0
	where Account = 123474924

go

create view vwValidAccountOperations as
(select * FROM [Santander].[AccountOperations]  WHERE OperationStatus in ('OK', 'KO'))


select top 100 * from [Santander].AccountOperations 

select * from vwValidAccountOperations

-- Table-Valued Functions (TVF)
select * from uspGetValidAccountOperationsByYear(2019)





update vwValidAccountOperations
 set OperationStatus = 'EX' 
	where AccountOperationId = 30

insert vwValidAccountOperations
	values (10, '123423057', GETDATE(), 1, 'OK')



-- functions 

-- funkcje dyskretne

select GETDATE(), SUBSTRING('Hello World', 1, 3)

select top(10) * from [Santander].AccountOperations 


-- Zadanie
-- sformatowaæ kolumnê konto (Account) w postaci 123-474-924



select top(10) 
	CONCAT(substring(Account, 1,3), '-', substring(Account, 4,3) , '-', substring(Account, 7,3)) 
from 
	Santander.AccountOperations

select 
	Concat(SUBSTRING(Account, 1,3),'-', SUBSTRING(Account,4,3), '-', SUBSTRING(Account,7,3)) 
from 
	Santander.AccountOperations

select 
	Concat(LEFT(Account,3),'-', SUBSTRING(Account,4,3), '-', RIGHT(Account,3)) 
from Santander.AccountOperations

go

create or alter function Santander.udfFormat(@account varchar(9), @separator char(1) = '-')
returns varchar(11)
as
begin
	return Concat(SUBSTRING(@account, 1,3), @separator, SUBSTRING(@account,4,3), @separator, SUBSTRING(@account,7,3)) 
end

select 
	Account,
	Santander.udfFormat(Account, default) as FormattedAcount
from 
	Santander.AccountOperations

go

create or alter function Santander.udfWeekday(@date datetime2)
returns int
as
begin
return DATEPART ( weekday , @date ) 
end

go

SELECT @@DATEFIRST

select Santander.udfWeekday('2020-05-24')


go

alter function Santander.udfAddWorkDays(@date datetime2, @days int)
returns datetime2
as
begin	

	declare @counter int
	declare @currentdate datetime2 
	
	set @counter = 0
	set @currentdate = @date

	while @counter < @days
	begin
		 
		if Santander.udfWeekday(@currentdate) not in (1,7)
			set @counter = @counter + 1

		SET @currentdate = DATEADD(d, 1, @currentdate)
	end

	return @currentdate

end


select Santander.udfAddWorkDays(GETDATE(), 15)

go

CREATE FUNCTION Santander.udfAddWorkDays(@date DATETIME, @days INT)RETURNS DATETIME2ASBEGIN    SET @date = DATEADD(d, @days, @date)    IF DATENAME(DW, @date) = 'sunday'   		SET @date = DATEADD(d, 1, @date)    IF DATENAME(DW, @date) = 'saturday' 		SET @date = DATEADD(d, 2, @date)      RETURN CAST(@date AS DATETIME2)END





--select 
--	FORMAT(cast(Account as int), '###-###-###') as Account
--from Santander.AccountOperations

-- funkcje tablicowe (Table-Value-Functions)

select * from Santander.AccountOperations

go

create function Santander.udfGetAccountOperations(
@operationStatus char(2)
)
returns table
as
return 
	select 
		AccountOperationId,
		Account,
		OperationDate,
		OperationTypeId,
		OperationStatus
	 from 
		Santander.AccountOperations where OperationStatus = @operationStatus


select * from Santander.udfGetAccountOperations('OK')

go

create function Santander.udfHolidays(@beginDate datetime, @endDate datetime)
returns @Dates table (
	[date] datetime, 
	[name] nvarchar(100)
	)
as
begin
	insert into @Dates
		values 
			 ('2020-05-23', 'urodziny'),
			 ('2020-05-24', 'imieniny'),
			 ('2020-06-01', 'dzieñ dziecka')

	return
end

select * from Santander.udfHolidays('2020-01-01', '2020-07-01')






go

create function dbo.GetEaster(@year int)
returns Date
as begin
        declare @Easter date
        declare @a int, @b int, @c int, @d int, @e int, @f int, @g int,
                        @h int, @i int, @k int, @l int, @m int, @p int, @n int
 
        set @a = @year % 19
        set @b = @year / 100
        set @c = @year % 100
 
        set @d = @b / 4
        set @e = @b % 4
 
        set @f = (@b + 8) / 25
        set @g = (@b - @f + 1) / 3
        set @h = (19 * @a + @b - @d - @g + 15) % 30
       
        set @i = @c / 4
        set @k = @c % 4
 
        set @l = (32 + 2*@e + 2*@i - @h - @k) % 7
        set @m = (@a + 11 * @h + 22 * @l) / 451
 
        set @p = (@h + @l - 7 * @m + 114) % 31
        set @p = @p + 1
 
        set @n = (@h + @l - 7 * @m + 114) / 31
 
        set @Easter = DATEFROMPARTS(@year, @n, @p)
 
        return @Easter
 
 
end


select dbo.GetEaster(2027)


select * from dbo.GetHolidays(2020)


go

-- Funkcja zwraca listê dni wolnych od pracy na podany rok
create function dbo.GetHolidays(@year int)
returns @Dates table (HolidayDate date, HolidayName nvarchar(100))
as
begin
        declare @Easter date
        set @Easter = dbo.GetEaster(@year)
 
        insert into @Dates values
                (DATEFROMPARTS(@year, 1, 1),    'Nowy Rok'),
                (DATEFROMPARTS(@year, 1, 6),    'Trzech Króli (Objawienie Pañskie)'),
                (@Easter,                                               'Wielkanoc'),
                (dateadd(day, 1, @Easter),              'Poniedzia³ek Wielkanocny'),
                (DATEFROMPARTS(@year, 5, 1),    'Miêdzynarodowe Œwiêto Pracy'),
                (DATEFROMPARTS(@year, 5, 3),    'Œwiêto Konstytucji 3 Maja'),
                (dateadd(day, 60, @Easter),             'Bo¿e Cia³o'),
                (DATEFROMPARTS(@year, 8, 15),   'Œwiêto Wojska Polskiego, Wniebowziêcie Najœwiêtszej Maryi Panny'),
                (DATEFROMPARTS(@year, 11, 1),   'Wszystkich Œwiêtych'),
                (DATEFROMPARTS(@year, 11, 11),  'Narodowe œwiêto Niepodleg³oœci'),
                (DATEFROMPARTS(@year, 12, 25),  'Bo¿e Narodzenie (pierwszy dzieñ)'),
                (DATEFROMPARTS(@year, 12, 26),  'Bo¿e Narodzenie (drugi dzieñ)')
        return
end


select top 100 * from [Santander].AccountOperations 

go

create or alter procedure [Santander].uspGetAccountOperations

(
	@operationStatus char(2)
)
as
set nocount on;

begin
  
	select 
		AccountOperationId,
		Account,
		OperationDate,
		OperationTypeId,
		OperationStatus
	 from 
		Santander.AccountOperations where OperationStatus = @operationStatus

	print 'ok'
end

exec [Santander].uspGetAccountOperations 'OK'

go


-- Table-Valued-Parameter (TVP)
exec [Santander].uspGetAccountOperations (accounts) 

create type AccountTableType
as table 
	(Account varchar(9),
	CostRate int)

go

create procedure [Santander].uspCalculateAccountOperations
	@tvp AccountTableType readonly
AS
	
select * from Santander.AccountOperations where Account in (select Account from @tvp)

go

declare @MyTvp as AccountTableType

insert into @MyTvp 
	values (123406395, 2),
		   (123447002, 1),
	       (123476515, 3)

exec  [Santander].uspCalculateAccountOperations @MyTvp






create or alter procedure uspCreateTable(@year int, @month int = 1)
as begin

	declare @sql nvarchar(max) = '
	create table Santander.AccountOperations' + cast(@year as nvarchar(4)) + 
	'(
		Account varchar(9)
	)'

	print @sql

	exec sp_executesql @sql
end


create or alter procedure uspCreateTable(@year int)
as begin

	declare @sql nvarchar(max) = '
	create table Santander.AccountOperations' + cast(@year as nvarchar(4)) + 
	'(
		Account varchar(9)
	)'

	print @sql

	exec sp_executesql @sql
end



select * from Santander.AccountOperations2019

drop table Santander.AccountOperations2018

exec uspCreateTable @year=2018, @month = default

-- SQL Injection
-- REGON [ 0543323232; DROP TABLE Users; ]
-- http://domain.com?City=WroclawOR1=1
