# SQL dla programistów .NET


## Normalizacja

### Przed normalizacją

~~~ sql

insert into #Orders values
('1', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski UNIVEGA ALPINA 27.5" 1 szt. 2200 zł'),
('2', 'Speed Cycles', 'ul. Rowerowa 31, 85-142 Bydgoszcz, Kujawsko-Pomorskie', '2020-02-12', 'Rower damski UNIVEGA GEO LIGHT NINE 1 szt. 4400 zł'),
('3', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski UNIVEGA ALPINA 1 27.5" szt. 2200 zł'),
('4', 'Trip Store', 'ul. Górska 12, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski Cube Attain Pro 28" 1 szt. 4200 zł'),
('5', 'High Quality Bike Store-Street', 'ul. Dworcowa 1, 01-242 Warszawa, Mazowieckie', '2020-04-05', 'Rower męski Kona Rove ST, ultraviolet 28" 2 szt. 6700 zł'),
('6', 'Trip Store', 'ul. Górska 12, 01-242 Warszawa, Mazowieckie', '2020-04-23', 'Rower męski UNIVEGA ALPINA 4 szt. 2200 zł')

~~~

### 1 postać normalna - 1NF

tabela (encja) jest w pierwszej postaci normalnej 1NF kiedy:
- wiersz przechowuje informacje o pojedynczym obiekcie
- nie zawiera kolekcji
- posiada klucz główny (kolumnę lub grupę kolumn jednoznacznie identyfikujących go w zbiorze)
- dane są atomowe

~~~ sql
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
~~~

- Przykładowe dane
~~~ sql
insert into #Orders_1NF values
(1, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 1, 2200),
(2, 'Speed Cycles', 'ul. Rowerowa 31', '85-142', 'Bydgoszcz', 'Kujawsko-Pomorskie', '2020-02-12', 'Rower damski', 'UNIVEGA GEO LIGHT NINE', 28.0, 1, 4400),
(3, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 1, 2200),
(4, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'Cube Attain Pro', 28, 1,  4200),
(5, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-05', 'Rower męski', 'Kona Rove ST, ultraviolet', 28, 2, 6700),
(6, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie', '2020-04-23', 'Rower męski', 'UNIVEGA ALPINA', 27.5, 4, 2200)
~~~


### 2 postać normalna - 2NF

Każda tabela powinna przechowywać dane dotyczące tylko konkretnej klasy obiektów.

~~~ sql
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
	UnitPrice decimal

)

~~~

- Przykładowe dane
~~~ sql

insert into #Customers_2NF values
(1, 'High Quality Bike Store-Street', 'ul. Dworcowa 1', '01-242', 'Warszawa', 'Mazowieckie'),
(2, 'Speed Cycles', 'ul. Rowerowa 31', '85-142', 'Bydgoszcz', 'Kujawsko-Pomorskie'),
(3, 'Trip Store', 'ul. Górska 12', '01-242', 'Warszawa', 'Mazowieckie')


insert into #ProductTypes_2NF values
(1, 'Rower męski'),
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


~~~


### Group by i Union

~~~ sql
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
~~~


## GROUPING SETS

~~~ sql
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
~~~

### CUBE
~~~ sql
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
~~~

~~~
CUBE (a, b, c) -> GROUPING SETS ( (a,b,c), ), (a,b), (a,c), (b,c), (b), (c), ())
~~~

~~~ sql
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
~~~


### ROLLUP
~~~ sql
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
~~~



~~~ sql


select
	year(soh.OrderDate) as OrderYear,
	MONTH(soh.OrderDate) as OrderMonth,
	day(soh.OrderDate) as OrderDay,
	sum(soh.SubTotal)
from sales.SalesOrderHeader as soh
group by
	year(soh.OrderDate), MONTH(soh.OrderDate), day(soh.OrderDate)

union all

select
	year(soh.OrderDate) as OrderYear,
	MONTH(soh.OrderDate) as OrderMonth,
	null as OrderDay,
	sum(soh.SubTotal)
from sales.SalesOrderHeader as soh
group by
	year(soh.OrderDate), MONTH(soh.OrderDate)

union all

select
	year(soh.OrderDate) as OrderYear,
	null as OrderMonth,
	null as OrderDay,
	sum(soh.SubTotal)
from sales.SalesOrderHeader as soh
group by
	year(soh.OrderDate)

union all

select
	null as OrderYear,
	null as OrderMonth,
	null as OrderDay,
	sum(soh.SubTotal)
from sales.SalesOrderHeader as soh


select
	year(soh.OrderDate) as OrderYear,
	MONTH(soh.OrderDate) as OrderMonth,
	day(soh.OrderDate) as OrderDay,
	sum(soh.SubTotal)
from sales.SalesOrderHeader as soh
group by

	rollup(year(soh.OrderDate),	MONTH(soh.OrderDate), day(soh.OrderDate))


~~~


## Kolumny wyliczone (computed)


### Wyliczane w locie
~~~ sql
alter table #OrderDetails_2NF
	add TotalAmount as (Quantity * UnitPrice)
~~~

### Utrwalone w bazie
~~~ sql
alter table #OrderDetails_2NF
	add TotalAmount as (Quantity * UnitPrice) persisted
~~~

### Przy tworzeniu tabeli

~~~ sql
create schema Santander;

create table Santander.OrderDetails (
	OrderDetailId int, -- PK
	OrderId int, -- FK
	ProductId int, -- FK
	Quantity int,
	UnitPrice decimal,
	Tax decimal,
	Total AS (Quantity * UnitPrice) 
)
~~~

Użycie kolumny
~~~ sql
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
~~~


### łączenie tekstu (konkatenacja)

~~~ sql
SELECT
FirstName,
MiddleName,
LastName,
FirstName + isnull(MiddleName, '') + LastName as FullName,
CONCAT(FirstName, MiddleName, LastName) as FullNameConcat
FROM	Person.Person

~~~


### rozdzielenie tekstu (*string_split*)
~~~ sql
declare @query varchar(max)
set @query = '43660,43670,43665'

select value from string_split(@query, ',')

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID in ( select value from string_split(@query, ',') )
~~~ 

### Predykaty
~~~ sql
SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID >= 43660 and SalesOrderID <= 43670
~~~

~~~ sql
SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID BETWEEN 43660 AND 43670
~~~ 

~~~ sql
SELECT * FROM Person.Person
WHERE LastName LIKE '[^A-D]%'
~~~ 

~~~ sql
SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43660 or SalesOrderID = 43670 or SalesOrderID = 43665
~~~

~~~ sql
SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID in ( 43660, 43670, 43665)
~~~
