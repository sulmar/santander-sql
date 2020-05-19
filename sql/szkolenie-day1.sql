use AdventureWorks

-- Normalizacja

create table #Orders 
(
	OrderNumber nvarchar(10),
	Customer nvarchar(100),
	[Address]  nvarchar(250),
	OrderDate datetime2,
	Details nvarchar(max)
)




insert into #Orders values
('1', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower mêski UNIVEGA ALPINA 27.5" 1 szt. 2200 z³'),
('2', 'Speed Cycles', 'ul. Rowerowa 31, 85-142 Bydgoszcz, Kujawsko-Pomorskie', '2020-02-12', 'Rower damski UNIVEGA GEO LIGHT NINE 1 szt. 4400 z³'),
('3', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower mêski UNIVEGA ALPINA 1 27.5" szt. 2200 z³'),
('4', 'Trip Store', 'ul. Górska 12, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower mêski Cube Attain Pro 28" 1 szt. 4200 z³'),
('5', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower mêski Kona Rove ST, ultraviolet 28" 2 szt. 6700 z³'),
('6', 'Trip Store', 'ul. Górska 12, 01-242 Warszawa, Mazowieckie', '2020-04-23', 'Rower mêski UNIVEGA ALPINA 4 szt. 2200 z³')


select * from #Orders

-- redundancja danych 
-- problem z aktualizacj¹ danych
-- problem z wyszukiwaniem

-- 1 postac normalna - 1NF


create table #Orders_1NF
(
	OrderId int,
	OrderNumber nvarchar(10),
	Customer nvarchar(100),
	[Street] nvarchar(100),
	[PostCode] char(6),
	[City] nvarchar(100),
	[Region] nvarchar(100),
	OrderDate datetime2,
	[ProductType] nvarchar(100),
	[ProductName] nvarchar(100),
	[Size] float,
	Quantity int,
	UnitPrice decimal
)


insert into #Orders_1NF values
(1, '1', 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower mêski', 'UNIVEGA ALPINA', 27.5, 1, 2200),
(2, '2', 'Speed Cycles', 'ul. Rowerowa 31', '85-142', 'Bydgoszcz', 'Kujawsko-Pomorskie', '2020-02-12', 'Rower damski', 'UNIVEGA GEO LIGHT NINE', 28.0, 1, 4400),
(3, '3', 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower mêski', 'UNIVEGA ALPINA', 27.5, 1, 2200),
(4, '4', 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower mêski', 'Cube Attain Pro', 28, 1,  4200),
(5, '5', 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower mêski', 'Kona Rove ST, ultraviolet', 28, 2, 6700),
(6, '6', 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-23', 'Rower mêski', 'UNIVEGA ALPINA', 27.5, 4, 2200)

select * from #Orders
select * from #Orders_1NF

-- 2 postaæ normalna - 2 NF

create table #Customers_2NF 
(
	CustomerId int,
	[Street] nvarchar(100),
	Customer nvarchar(100),
	[PostCode] char(6),
	[City] nvarchar(100),
	[Region] nvarchar(100)
)


create table #ProductTypes_2NF
(
	ProductTypeId int, -- PK (Primary Key)
	[Name] nvarchar(100)
)

create table #Products_2NF (
	ProductId int, -- PK (Primary Key)
	ProductTypeId int, -- FK (Foreign Key)
	[ProductName] nvarchar(100),
	[Size] float,
	ListPrice decimal
)

create table #Orders_2NF (
	OrderId int,
	OrderNumber nvarchar(10),
	CustomerId int,	 -- FK
	OrderDate datetime2
)


create table #OrderDetails_2NF (
	OrderDetailId int, -- PK
	OrderId int, -- FK
	ProductId int, -- FK
	Quantity int,
	UnitPrice decimal,
	Tax decimal,
	Total decimal

)


--

insert into #Customers_2NF values
(1, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie'),
(2, 'Speed Cycles', 'ul. Rowerowa 31', '85-142', 'Bydgoszcz', 'Kujawsko-Pomorskie'),
(3, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie')


insert into #ProductTypes_2NF values
(1, 'Rower mêski'),
(2, 'Rower damski')

insert into #Products_2NF values 
(1, 1, 'UNIVEGA ALPINA', 27.5, 2200),
(2, 2, 'UNIVEGA GEO LIGHT NINE', 28.0, 4400),
(3, 1, 'Cube Attain Pro', 28, 4200),
(4, 1, 'Kona Rove ST, ultraviolet', 28, 6700)


insert into #Orders_2NF values
(1, '1', 1, '2020-04-05'),
(2, '2', 2, '2020-02-12'),
(3, '3', 1, '2020-04-05'),
(4, '4', 3, '2020-04-05'),
(5, '5', 1, '2020-04-05' ),
(6, '6', 1, '2020-04-23')


insert into #OrderDetails_2NF values
(1, 1, 1, 1, 2200),
(2, 2, 2, 1, 4400),
(3, 1, 1, 1, 2200),
(4, 3, 3, 1, 4200),
(5, 4, 4, 2, 13400),
(6, 1, 5, 4, 8800)


select * from #Customers_2NF
select * from #OrderDetails_2NF

select * from #Products_2NF


-- select ....


-- aliasy tabel

-- Filip

-- SQL-91
select 	o.OrderId, 	o.OrderNumber, 	c.Customer, 	c.Street, 	c.PostCode, 	c.City,	Region, 	o.OrderDate, 	pt.Name, 	p.ProductName, 	p.Size, 	od.Quantity, 	od.UnitPrice from #Customers_2NF as c	inner join #Orders_2NF as o		on o.CustomerId = c.CustomerId	inner join #OrderDetails_2NF  as od		on od.OrderId = o.OrderId	inner join #Products_2NF as p		on p.ProductId = od.ProductId	inner join #ProductTypes_2NF as pt
		on p.ProductTypeId = pt.ProductTypeId

-- SQL-89
select 
	o.OrderId, 	o.OrderNumber, 	o.OrderDate,  	od.Quantity, 	od.UnitPrice 
 from
	 #Orders_2NF as o,
	 #OrderDetails_2NF as od
where
	o.OrderId = od.OrderId


-- z³¹czenie krzy¿owe (cross-join)	
select 
	o.OrderId, 	o.OrderNumber, 	o.OrderDate,  	od.Quantity, 	od.UnitPrice 
 from
	 #Orders_2NF as o
	cross join
	 #OrderDetails_2NF as od
	 

-- £ukasz
select #Orders_2NF.OrderId, #Orders_2NF.OrderNumber, #Customers_2NF.Street, #Customers_2NF.Customer, #Customers_2NF.PostCode, #Customers_2NF.City, #Customers_2NF.Region, #Orders_2NF.OrderDate, #ProductTypes_2NF.Name, #Products_2NF.ProductName, #Products_2NF.Size, #OrderDetails_2NF.Quantity, #OrderDetails_2NF.UnitPrice from #Orders_2NF inner join #OrderDetails_2NF on #OrderDetails_2NF.OrderId = #Orders_2NF.OrderIdinner join #Products_2NF on #Products_2NF.ProductId = #OrderDetails_2NF.ProductIdinner join #ProductTypes_2NF on #ProductTypes_2NF.ProductTypeId = #Products_2NF.ProductTypeIdinner join #Customers_2NF on #Customers_2NF.CustomerId = #Orders_2NF.CustomerId
-- Filip M.
select #Orders_2NF.OrderID, #Orders_2NF.OrderNumber, #Customers_2NF.Customer, #Customers_2NF.Street, #Customers_2NF.PostCode, #Customers_2NF.City, #Customers_2NF.Region, #Orders_2NF.OrderDate,#ProductTypes_2NF.[Name],#Products_2NF.ProductName, #Products_2NF.Size, #OrderDetails_2NF.Quantity, #OrderDetails_2NF.UnitPricefrom #Orders_2NFINNER JOIN #Customers_2NF ON #Orders_2NF.CustomerID=#Customers_2NF.CustomerIDINNER JOIN #OrderDetails_2NF ON #OrderDetails_2NF.OrderID=#Orders_2NF.OrderIDINNER JOIN #Products_2NF ON #Products_2NF.ProductID=#OrderDetails_2NF.ProductIDINNER JOIN #ProductTypes_2NF ON #ProductTypes_2NF.ProductTypeID=#Products_2NF.ProductTypeID

-- Patryk
Select Orders.OrderId, Orders.OrderNumber,Customers.Customer, Customers.Street, Customers.Postcode, Customers.City, Customers.Region, Orders.OrderDate, ProductTypes.Name, Products.Size, Products.ListPrice, OrderDetails.Quantity from #Orders_2NF as Orders  inner join #OrderDetails_2NF as OrderDetails on Orders.OrderId = OrderDetails.OrderID join #Customers_2NF as Customers on Customers.CustomerId = Orders.CustomerId  join #Products_2NF as Products on Products.ProductId = OrderDetails.ProductId join #ProductTypes_2NF as ProductTypes on ProductTypes.ProductTypeId = Products.ProductTypeId


 insert into #Customers_2NF values
(10, 'John Smith', 'ul. Dworcowa 15', '01-242', 'Warszawa', 'Mazowieckie')

select * from #Customers_2NF

select * from #Customers_2NF as c
	left outer join #Orders_2NF as o
		on c.CustomerId = o.CustomerId





select * from #OrderDetails_2NF

insert #OrderDetails_2NF 
	values(7, 1, 3, 1, null)


select * from #OrderDetails_2NF
	where UnitPrice IS NULL

-- agregacja

select sum(UnitPrice) from #OrderDetails_2NF

-- 5028,571429

select AVG(ISNULL(unitPrice,0)) from #OrderDetails_2NF

select * from #Customers_2NF

select distinct City from #Customers_2NF




select City, Customer from #Customers_2NF where City = 'Warszawa'
union all
select City, Customer from #Customers_2NF where City = 'Bydgoszcz'


-- union -  distinct union all 

select
	o.CustomerId,
	c.Customer,
	SUM(UnitPrice * Quantity) as Total
 from #Orders_2NF as o
	inner join #OrderDetails_2NF as od
		on o.OrderId = od.OrderId
	inner join #Customers_2NF as c
		on c.CustomerId = o.CustomerId
group by
	o.CustomerId, c.Customer
having 
	SUM(UnitPrice * Quantity) > 10000
order by
	Total


-- | OrderYear | Customer | Total




/* Kolejnoœæ logiczna przetwarzania zapytañ w SQL:
 1. FROM
 2. WHERE
 3. GROUP BY
 4. HAVING
 5. SELECT
 6. ORDER BY
 */















select 	o.OrderId, 	o.OrderNumber, 	c.Customer, 	c.Street, 	c.PostCode, 	c.City,	Region, 	o.OrderDate, 	pt.Name, 	p.ProductName, 	p.Size, 	od.Quantity, 	od.UnitPrice from #Customers_2NF as c	inner join #Orders_2NF as o		on o.CustomerId = c.CustomerId	inner join #OrderDetails_2NF  as od		on od.OrderId = o.OrderId	inner join #Products_2NF as p		on p.ProductId = od.ProductId	inner join #ProductTypes_2NF as pt
		on p.ProductTypeId = pt.ProductTypeId


	-- select * from #OrderDetails_2NF


select 	o.*,	c.Customer,	od.*from #Customers_2NF as c	inner join #Orders_2NF as o		on o.CustomerId = c.CustomerId	inner join #OrderDetails_2NF  as od		on od.OrderId = o.OrderId	inner join #Products_2NF as p		on p.ProductId = od.ProductId	inner join #ProductTypes_2NF as pt
		on p.ProductTypeId = pt.ProductTypeId

-- union 
	
select 
	year(o.OrderDate) AS OrderYear,
	o.CustomerId,
	c.Customer,
	SUM(UnitPrice * Quantity) as Total,
	COUNT(*) as Number
 from #Orders_2NF as o
	inner join #OrderDetails_2NF as od
		on o.OrderId = od.OrderId
	inner join #Customers_2NF as c
		on c.CustomerId = o.CustomerId
group by
	YEAR(o.OrderDate), o.CustomerId, c.Customer

union all

select 
	year(o.OrderDate) AS OrderYear,
	null as CustomerId,
	null as Customer,
	SUM(UnitPrice * Quantity) as Total,
	COUNT(*) as Number
 from #Orders_2NF as o
	inner join #OrderDetails_2NF as od
		on o.OrderId = od.OrderId
	inner join #Customers_2NF as c
		on c.CustomerId = o.CustomerId
group by
	YEAR(o.OrderDate)

union all

select 
	null AS OrderYear,
	o.CustomerId,
	Customer,
	SUM(UnitPrice * Quantity) as Total,
	COUNT(*) as Number
 from #Orders_2NF as o
	inner join #OrderDetails_2NF as od
		on o.OrderId = od.OrderId
	inner join #Customers_2NF as c
		on c.CustomerId = o.CustomerId
group by
	o.CustomerId, Customer

union all
	select 
	null AS OrderYear,
	null,
	null,
	SUM(UnitPrice * Quantity) as Total,
	COUNT(*) as Number
 from #Orders_2NF as o
	inner join #OrderDetails_2NF as od
		on o.OrderId = od.OrderId
	inner join #Customers_2NF as c
		on c.CustomerId = o.CustomerId

-- grouping set

select
	YEAR(o.OrderDate) as OrderYear,
	o.CustomerId,
	SUM(UnitPrice * Quantity) as Total
from
	#Orders_2NF as o
		inner join #OrderDetails_2NF as od
			on o.OrderId = od.OrderId
group by
	GROUPING SETS
	(
		(YEAR(o.OrderDate), o.CustomerId),
		(o.CustomerId),
		(YEAR(o.OrderDate)),
		()
	)
order by OrderYear, CustomerId



select
	YEAR(o.OrderDate) as OrderYear,
	o.CustomerId,
	SUM(UnitPrice * Quantity) as Total
from
	#Orders_2NF as o
		inner join #OrderDetails_2NF as od
			on o.OrderId = od.OrderId
group by
	CUBE(YEAR(o.OrderDate), o.CustomerId)

order by OrderYear, CustomerId

-- CUBE (a, b, c) -> GROUPING SETS ( (a,b,c), ), (a,b), (a,c), (b,c), (b), (c), ())

select
	YEAR(o.OrderDate) as OrderYear,
	MONTH(o.OrderDate) as OrderMonth,
	DAY(o.OrderDate) as OrderDay,
	SUM(od.Quantity * od.UnitPrice) as Total
  from #Orders_2NF as o
	 inner join #OrderDetails_2NF as od
				on o.OrderId = od.OrderId
group by
	YEAR(o.OrderDate),
	MONTH(o.OrderDate),
	DAY(o.OrderDate) 

select
	YEAR(o.OrderDate) as OrderYear,
	MONTH(o.OrderDate) as OrderMonth,
	DAY(o.OrderDate) as OrderDay,
	SUM(od.Quantity * od.UnitPrice) as Total
  from #Orders_2NF as o
	 inner join #OrderDetails_2NF as od
				on o.OrderId = od.OrderId
group by
GROUPING SETS
(
	(YEAR(o.OrderDate), MONTH(o.OrderDate), DAY(o.OrderDate)),
	(YEAR(o.OrderDate), MONTH(o.OrderDate)),
	(YEAR(o.OrderDate)),
	()
)


select
	YEAR(o.OrderDate) as OrderYear,
	MONTH(o.OrderDate) as OrderMonth,
	DAY(o.OrderDate) as OrderDay,
	SUM(od.Quantity * od.UnitPrice) as Total
  from #Orders_2NF as o
	 inner join #OrderDetails_2NF as od
				on o.OrderId = od.OrderId
group by
 ROLLUP(YEAR(o.OrderDate), MONTH(o.OrderDate), 	DAY(o.OrderDate) )
 order by
	OrderYear desc, OrderMonth desc, OrderDay desc

--
 select * from Sales.SalesOrderHeader
 -- | year (OrderDate) |  month | day | Total = sum(SubTotal) |
 --    2020    null    null   null
 --	  2020    1       null   null


select	year(soh.OrderDate) as OrderYear,	MONTH(soh.OrderDate) as OrderMonth,	day(soh.OrderDate) as OrderDay,	sum(soh.SubTotal)from sales.SalesOrderHeader as sohgroup by	year(soh.OrderDate), MONTH(soh.OrderDate), day(soh.OrderDate)union allselect	year(soh.OrderDate) as OrderYear,	MONTH(soh.OrderDate) as OrderMonth,	null as OrderDay,	sum(soh.SubTotal)from sales.SalesOrderHeader as sohgroup by	year(soh.OrderDate), MONTH(soh.OrderDate)union allselect	year(soh.OrderDate) as OrderYear,	null as OrderMonth,	null as OrderDay,	sum(soh.SubTotal)from sales.SalesOrderHeader as sohgroup by	year(soh.OrderDate)union allselect	null as OrderYear,	null as OrderMonth,	null as OrderDay,	sum(soh.SubTotal)from sales.SalesOrderHeader as soh


select	year(soh.OrderDate) as OrderYear,	MONTH(soh.OrderDate) as OrderMonth,	day(soh.OrderDate) as OrderDay,	sum(soh.SubTotal)from sales.SalesOrderHeader as sohgroup by	rollup(year(soh.OrderDate),	MONTH(soh.OrderDate), day(soh.OrderDate))


select  
	Quantity,
	UnitPrice,
	Quantity * UnitPrice as TotalAmount
 from #OrderDetails_2NF


 -- computed columns

 alter table #OrderDetails_2NF
	add TotalAmount as (Quantity * UnitPrice)

alter table #OrderDetails_2NF
	add TotalAmount as (Quantity * UnitPrice) persisted



alter table #OrderDetails_2NF
  drop column TotalAmount

select * from #OrderDetails_2NF

update #OrderDetails_2NF
set Quantity = 4
where OrderDetailId = 4


go

create schema Santander;


drop table Santander.OrderDetails

create table Santander.OrderDetails (
	OrderDetailId int, -- PK
	OrderId int, -- FK
	ProductId int, -- FK
	Quantity int,
	UnitPrice decimal,
	Tax decimal,
	Total AS (Quantity * UnitPrice) 
)



select
	YEAR(o.OrderDate) as OrderYear,
	MONTH(o.OrderDate) as OrderMonth,
	DAY(o.OrderDate) as OrderDay,
	SUM(od.TotalAmount) as Total
  from #Orders_2NF as o
	 inner join #OrderDetails_2NF as od
				on o.OrderId = od.OrderId
group by
 ROLLUP(YEAR(o.OrderDate), MONTH(o.OrderDate), 	DAY(o.OrderDate) )
 order by
	OrderYear desc, OrderMonth desc, OrderDay desc

--

select distinct
	PersonType
from Person.Person

select 
	PersonType,
	CASE PersonType
		WHEN 'EM' THEN 'Employee'
		WHEN 'IN' THEN 'Invidual Customer'
		WHEN 'VC' THEN 'Vendor Customer'
		ELSE 'Other'
	END AS PeronTypeName,
	FirstName,
	LastName
 from Person.Person

 select
	[Name],
	ListPrice,
	CASE
		WHEN ListPrice = 0 then 'Gratis'
		WHEN ListPrice < 100 then '<100'
		WHEN ListPrice >= 100 and ListPrice < 500 then '100..500'
		WHEN ListPrice >= 500 and ListPrice < 1000 then '500..1000'
		ELSE '>=1000'
	END AS PriceRange
from 
	Production.Product

-- Predykaty

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID >= 43660 and SalesOrderID <= 43670

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID BETWEEN 43660 AND 43670

SELECT * FROM Person.Person
WHERE LastName LIKE '[^A-D]%'

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43660 or SalesOrderID = 43670 or SalesOrderID = 43665

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID in ( 43660, 43670, 43665)

-- ³¹czenie ci¹gów tekstowych

SELECT
FirstName,
MiddleName,
LastName,
FirstName + isnull(MiddleName, '') + LastName as FullName,
CONCAT(FirstName, MiddleName, LastName) as FullNameConcat
FROM	Person.Person


-- rozdzielenie tekstu

declare @query varchar(max)
set @query = '43660,43670,43665'

select value from string_split(@query, ',')

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID in ( select value from string_split(@query, ',') )





















